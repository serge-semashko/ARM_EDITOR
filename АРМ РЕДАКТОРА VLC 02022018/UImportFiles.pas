unit UImportFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons;

type
  TFImportFiles = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    lbClip: TLabel;
    lbSong: TLabel;
    lbSinger: TLabel;
    lbTotalDurTxt: TLabel;
    lbNTKTxt: TLabel;
    lbDURTxt: TLabel;
    lbTypeTxt: TLabel;
    edClip: TEdit;
    edSong: TEdit;
    edSinger: TEdit;
    lbType1: TLabel;
    lbFile: TLabel;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    mmComment: TMemo;
    Panel1: TPanel;
    Label3: TLabel;
    mmMistakes: TMemo;
    SpeedButton3: TSpeedButton;
    edTotalDur: TEdit;
    edNTK: TEdit;
    EdDur: TEdit;
    lbStartTimeTxt: TLabel;
    EdStartTime: TEdit;
    CheckBox1: TCheckBox;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure mmCommentKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edTotalDurKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edTotalDurKeyPress(Sender: TObject; var Key: Char);
    procedure EdStartTimeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNTKKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdDurKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNTKKeyPress(Sender: TObject; var Key: Char);
    procedure EdDurKeyPress(Sender: TObject; var Key: Char);
    procedure EdStartTimeKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure edClipKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSongKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSingerKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNTKChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NeedCopy : boolean;
    ExternalValue : boolean;
  end;

var
  FImportFiles: TFImportFiles;
  oldntk, olddur : longint;

procedure EditClip(ARow : integer);
procedure GridClipsToPanel(ARow : integer);
procedure ClearClipsPanel;

implementation
uses umain, ucommon, ugrid, uplayer, uactplaylist, uwaiting, UHRTimer, umyfiles,
     umymessage, uinitforms, umediacopy;

{$R *.dfm}

procedure EditClip(ARow : integer);
var err, rw : integer;
    Duration: Int64;
    txt, fn, snch, clpid : string;
begin
  if WorkDirClips<>'' then FImportFiles.OpenDialog1.InitialDir:=WorkDirClips;
  with FImportFiles do begin
// Устанваливаем первоначальные значения
    If ARow < 0 then begin
      CheckBox1.Checked:=false;
      if ARow=-1 then begin
      if not OpenDialog1.Execute then exit;
        WorkDirClips:=IncludeTrailingBackslash(extractfilepath(OpenDialog1.FileName));
        if OpenDialog1.Files.Count > 1 then begin
          NeedCopy:=false;
          //If MyTextMessage('Вопрос', 'Копировать импортируемые медиа файлы на компьютер', 2) then NeedCopy:=true;
          if CopyMediaFiles(OpenDialog1.Files, pathfiles, mmMistakes) then begin
            FImportFiles.Panel3.Visible:=false;
            FImportFiles.Panel1.Visible:=true;
            FImportFiles.SpeedButton2.Visible:=false;
            FImportFiles.SpeedButton1.Caption:='Закрыть';
            FImportFiles.ShowModal;
            If FImportFiles.ModalResult=mrOk then begin
            end;
          end;
          exit;
        end;
        err := LoadVLCPlayer(OpenDialog1.FileName);
        if Err<>0 then begin
          ShowMessage('Невозможно прочитать параметры выбранного медиафайла.');
          exit;
        end;
        //Panel3.Visible:=true;
        //Panel1.Visible:=false;
        lbFile.Caption:=OpenDialog1.FileName;
        txt := extractfilename(OpenDialog1.FileName);
        fn := extractfileext(OpenDialog1.FileName);
        txt := copy(txt,1,Length(txt)-length(fn));
        //pMediaPosition.get_Duration(Duration);
        Duration:=vlcplayer.Duration div 40;
      end;
      if ARow=-100 then begin
        txt := '';
        lbFile.Caption:='Медиа-данные не заданы.';
        Duration:=0;
      end;
      Panel3.Visible:=true;
      Panel1.Visible:=false;
      SpeedButton2.Visible:=true;
      SpeedButton1.Caption:='Сохранить';
      edClip.Text:=txt;
      //pMediaPosition.get_Duration(Duration);
      edSong.Text:=txt;
      edSinger.Text:='';
      mmComment.Text:='';
      if not externalvalue then begin
        edTotalDur.Text:=Trim(FramesToStr(Duration));//MyDoubleToSTime(Duration);
        edNTK.Text:='00:00:00:00';
        edDUR.Text:=trim(edTotalDur.Text);
        externalvalue := false;
      end;
      edStartTime.Text:='00:00:00:00';
      lbType1.Caption:='';
    end else begin
      if Form1.GridClips.Objects[0,ARow] is TGridRows then begin
        with (Form1.GridClips.Objects[0,ARow] as TGridRows).MyCells[3] do begin
          Panel3.Visible:=true;
          Panel1.Visible:=false;
          clpid := Trim(ReadPhrase('ClipId'));
          if clpid=trim(Form1.lbActiveClipID.Caption) then SaveClipEditingToFile(clpid);
          txt := Trim(ReadPhrase('File'));

          if txt='' then lbFile.Caption:='Медиа-данные не заданы.' else lbFile.Caption:=Trim(ReadPhrase('File'));

          edClip.Text:=Trim(ReadPhrase('Clip'));
          edSong.Text:=Trim(ReadPhrase('Song'));
          edSinger.Text:=Trim(ReadPhrase('Singer'));
          mmComment.Text:=Trim(ReadPhrase('Comment'));
          edTotalDur.Text:=Trim(ReadPhrase('Duration'));
          edNTK.Text:=Trim(ReadPhrase('NTK'));
          edDUR.Text:=Trim(ReadPhrase('Dur'));
          edStartTime.Text:=Trim(ReadPhrase('TypeMedia'));
          if trim(edStartTime.Text)='' then begin
            CheckBox1.Checked:=false;
            edStartTime.Text:='00:00:00:00';
          end else CheckBox1.Checked:=true;
          //if length(edStartTime.Text)>11 then begin
          //   CheckBox1.Checked:=true;
             //snch := copy(edStartTime.Text,13,3);
             //if snch = 'ltc' then RadioButton1.Checked :=true;
             //if snch = 'sys' then RadioButton2.Checked :=true;
          //   edStartTime.Text:=copy(edStartTime.Text,1,11);
          //end else begin
          //   CheckBox1.Checked:=false;
          //end;
          //lbType1.Caption:=ReadPhrase('TypeMedia');
        end;
      end else exit;
    end;
// Открываем форму
    oldntk := StrTimeCodeToFrames(trim(edNTK.Text));
    olddur := StrTimeCodeToFrames(trim(edDur.Text));
    ShowModal;
    ActiveControl:=edClip;
// Заносим результат в список клипов
    oldntk := StrTimeCodeToFrames(trim(edNTK.Text));
    olddur := StrTimeCodeToFrames(trim(edDur.Text));
    If ModalResult=mrOk then begin
      AllClipsReset;
      rw:=ARow;
      if ARow < 0 then begin
         rw:=GridAddRow(Form1.GridClips,RowGridClips);
         IDCLIPS:=IDCLIPS+1;
         (Form1.GridClips.Objects[0,rw] as TGridRows).ID:=IDCLIPS;
         clpid := createunicumname;
         (Form1.GridClips.Objects[0,rw] as TGridRows).MyCells[3].UpdatePhrase('ClipID',clpid);
         if ARow<>-100 then begin
           fn:=extractfilename(Opendialog1.FileName);
           fn:=PathFiles + '\' + fn;
           lbFile.Caption := CopyMediaFile(Opendialog1.FileName, PathFiles);
         end;
      end;
      (Form1.GridClips.Objects[0,rw] as TGridRows).MyCells[1].Mark:=true;
      with (Form1.GridClips.Objects[0,rw] as TGridRows).MyCells[3] do begin
        if ARow<>-100 then UpdatePhrase('File',lbFile.Caption)
        else begin
          UpdatePhrase('File','');
          (Form1.GridClips.Objects[0,Form1.GridClips.RowCount-1] as TGridRows).MyCells[3].SetPhraseColor('Clip',PhraseErrorColor);
        end;
        UpdatePhrase('Clip',edClip.Text);
        UpdatePhrase('Song',edSong.Text);
        UpdatePhrase('Comment',mmComment.Text);
        UpdatePhrase('Singer',edSinger.Text);
        UpdatePhrase('Duration',edTotalDur.Text);
        UpdatePhrase('NTK',edNTK.Text);
        UpdatePhrase('Dur',edDUR.Text);
        //snch := '';
        if CheckBox1.Checked then UpdatePhrase('TypeMedia',edStartTime.Text) else UpdatePhrase('TypeMedia','');
        //UpdatePhrase('TypeMedia',lbType.Caption);
      end;
      Form1.GridClips.Row:=rw;
      GridClipsToPanel(rw);
      if clpid=trim(Form1.lbActiveClipID.Caption) then PlayClipFromClipsList;;
    end;
  end;
end;

procedure TFImportFiles.SpeedButton1Click(Sender: TObject);
begin
  if panel1.Visible then begin
    modalresult := mrOk;
    exit;
  end;
  //if (ActiveControl=mmComment) then exit;
  If trim(edClip.Text)='' then begin
    ActiveControl:=edClip;
    exit;
  end;
  If trim(edSong.Text)='' then begin
    ActiveControl:=edSong;
    exit;
  end;

  if trim(edTotalDur.Text)='00:00:00:00' then begin
    ActiveControl:=edTotalDur;
    edTotalDur.SelStart:=0;
    edTotalDur.SelLength:=Length(edTotalDur.Text);
    exit;
  end;

  if trim(edDur.Text)='00:00:00:00' then begin
    edDur.Text := FramesToStr(StrTimeCodeToFrames(edTotalDur.Text) - StrTimeCodeToFrames(edNTK.Text));
  end;
//  If trim(edSinger.Text)='' then begin
//    ActiveControl:=edSinger;
//    exit;
//  end;
  modalresult := mrOk;
end;

procedure TFImportFiles.SpeedButton2Click(Sender: TObject);
begin
  modalresult:=mrcancel;
end;

procedure TFImportFiles.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then begin
    SpeedButton1.OnClick(nil);
  end;
end;

procedure GridClipsToPanel(ARow : integer);
var dur : longint;
    txt : string;
    i : integer;
begin
  if Not (Form1.GridClips.Objects[0,ARow] is TGridRows) then exit;
  with (Form1.GridClips.Objects[0,ARow] as TGridRows).MyCells[3] do begin
    if  ARow>=0 then begin
      Form1.lbClip.Caption:='Клип:   ' + trim(ReadPhrase('Clip'));
      Form1.lbClipSong.Caption:='Песня:   ' + trim(ReadPhrase('Song'));
      Form1.lbClipComment.Caption:=trim(ReadPhrase('Comment'));
      Form1.lbClipSinger.Caption:=trim(ReadPhrase('Singer'));
      Form1.lbClipTotalDur.Caption:=trim(ReadPhrase('Duration'));
      Form1.lbClipNTK.Caption:=trim(ReadPhrase('NTK'));
      Form1.lbClipDUR.Caption:=trim(ReadPhrase('Dur'));
      Form1.lbClipType.Caption:=trim(ReadPhrase('TypeMedia'));
      Form1.lbClipPath.Caption:='Файл:   ' + trim(ReadPhrase('File'));
    end else begin
      Form1.lbClip.Caption:='Клип:';
      Form1.lbClipSong.Caption:='Песня:';
      Form1.lbClipComment.Caption:='';//ReadPhrase('Comment');
      Form1.lbClipSinger.Caption:='';//ReadPhrase('Singer');
      Form1.lbClipTotalDur.Caption:='';//ReadPhrase('Duration');
      Form1.lbClipNTK.Caption:='';//ReadPhrase('NTK');
      Form1.lbClipDUR.Caption:='';//ReadPhrase('Dur');
      Form1.lbClipType.Caption:='';//ReadPhrase('TypeMedia');
      Form1.lbClipPath.Caption:='Файл:';// ReadPhrase('File');
    end;
    dur := 0;
    for i:=1 to Form1.GridClips.RowCount-1 do begin
      if Form1.GridClips.Objects[0,i] is TGridRows then begin
        txt := trim((Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Dur'));
        if txt<>'' then dur := dur + StrTimeCodeToFrames(txt);
      end;
    end;
    Form1.lbclipfulldur.Caption := FramesToStr(dur);
  end;
  Form1.image2.Canvas.FillRect(Form1.image2.Canvas.ClipRect);
  if (Form1.GridClips.Objects[0,ARow] as TGridRows).MyCells[0].Mark
    then LoadBMPFromRes(Form1.image2.Canvas,Form1.image2.Canvas.ClipRect,30,30,'Lock')
    else LoadBMPFromRes(Form1.image2.Canvas,Form1.image2.Canvas.ClipRect,30,30,'Unlock');
end;

procedure ClearClipsPanel;
begin
  Form1.lbClip.Caption:='';
  Form1.lbClipSong.Caption:='';
  Form1.lbClipComment.Caption:='';
  Form1.lbClipSinger.Caption:='';
  //Form1.lbClipRegistr.Caption:='';
  //Form1.lbClipStopUse.Caption:='';
  Form1.lbClipTotalDur.Caption:='';
  Form1.lbClipNTK.Caption:='';
  Form1.lbClipDUR.Caption:='';
  Form1.lbClipType.Caption:='';
  Form1.lbClipPath.Caption:='';
end;

procedure TFImportFiles.FormCreate(Sender: TObject);
begin
  InitImportFiles;
  Panel1.Align := alClient;
  ExternalValue := false;
end;

procedure TFImportFiles.mmCommentKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then begin
    key := 13;
    exit;
  end;
  if (ssCtrl in Shift) and (Key=65) then begin
    mmComment.SelStart:=0;
    mmComment.SelLength:=Length(mmComment.Text);
  end;
end;

procedure TFImportFiles.edTotalDurKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=46 then key:=0;
end;

procedure TFImportFiles.edTotalDurKeyPress(Sender: TObject; var Key: Char);
var s : string;
  i,p1,p2,p3 : integer;
begin
  if not (key in ['0'..'9',#8]) then begin
   key:=#0;
   exit;
  end;
  s:=edTotalDur.Text;
  p2:=edTotalDur.SelStart;
     Case Key of
       #8  : begin
               if edTotalDur.SelLength=0 then begin
                 if (p2<>3) and (p2<>6) and (p2<>9) then begin
                    s[p2]:='0';
                    edTotalDur.Text:=s;
                    key:=#0;
                    if p2>0 then edTotalDur.SelStart:=p2-1;
                 end else begin
                    s[p2]:=':';
                    edTotalDur.Text:=s;
                    key:=#0;
                    if p2>0 then edTotalDur.SelStart:=p2-1;
                 end;
               end else begin
                 for i:=p2+1 to p2+edTotalDur.SelLength do begin
                   if (i<>3) and (i<>6) and (i<>9) then s[i]:='0';
                 end;
                 edTotalDur.SelLength:=0;
                 edTotalDur.Text:=s;
                 if (p2=2) or (p2=5) or (p2=8) then edTotalDur.SelStart:=p2+1;
                 if p2>0 then key:=s[p2-1];
               end;
             end;
  '0'..'9' : begin
               if (p2=2) or (p2=5) or (p2=8) then p2:=p2+1;
               if (p2<>2) and (p2<>5) and (p2<>8) then begin
                 if p2<11 then p2:=p2+1 else p2:=12;
                   case p2 of
               1 : if strtoint(Key)>2 then Key:='2';
               2 : if s[1]='2' then if strtoint(Key)>3 then Key:='3';
               4 : if strtoint(Key)>5 then Key:='5';
               7 : if strtoint(Key)>5 then Key:='5';
               10: if strtoint(Key)>2 then Key:='2';
               11: if s[10]='2' then if strtoint(Key)>4 then Key:='4';
                   end;
                 s[p2]:=Key;
                 edTotalDur.Text:=s;
                 key:=#0;
                 if p2<=11 then begin
                   if (p2=2) or (p2=5) or (p2=8) then edTotalDur.SelStart:=p2+1 else edTotalDur.SelStart:=p2;
                 end;
               end;
             end;
     End;
end;

procedure TFImportFiles.EdStartTimeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=46 then key:=0;
end;

procedure TFImportFiles.edNTKKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=46 then key:=0;
end;

procedure TFImportFiles.EdDurKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=46 then key:=0;
end;

procedure TFImportFiles.edNTKKeyPress(Sender: TObject; var Key: Char);
var s : string;
  i,p1,p2,p3 : integer;
begin
  if not (key in ['0'..'9',#8]) then begin
   key:=#0;
   exit;
  end;
  s:=edNTK.Text;
  p2:=edNTK.SelStart;
     Case Key of
       #8  : begin
               if edNTK.SelLength=0 then begin
                 if (p2<>3) and (p2<>6) and (p2<>9) then begin
                    s[p2]:='0';
                    edNTK.Text:=s;
                    key:=#0;
                    if p2>0 then edNTK.SelStart:=p2-1;
                 end else begin
                    s[p2]:=':';
                    edNTK.Text:=s;
                    key:=#0;
                    if p2>0 then edNTK.SelStart:=p2-1;
                 end;
               end else begin
                 for i:=p2+1 to p2+edNTK.SelLength do begin
                   if (i<>3) and (i<>6) and (i<>9) then s[i]:='0';
                 end;
                 edNTK.SelLength:=0;
                 edNTK.Text:=s;
                 if (p2=2) or (p2=5) or (p2=8) then edNTK.SelStart:=p2+1;
                 if p2>0 then key:=s[p2-1];
               end;
             end;
  '0'..'9' : begin
               if (p2=2) or (p2=5) or (p2=8) then p2:=p2+1;
               if (p2<>2) and (p2<>5) and (p2<>8) then begin
                 if p2<11 then p2:=p2+1 else p2:=12;
                   case p2 of
               1 : if strtoint(Key)>2 then Key:='2';
               2 : if s[1]='2' then if strtoint(Key)>3 then Key:='3';
               4 : if strtoint(Key)>5 then Key:='5';
               7 : if strtoint(Key)>5 then Key:='5';
               10: if strtoint(Key)>2 then Key:='2';
               11: if s[10]='2' then if strtoint(Key)>4 then Key:='4';
                   end;
                 s[p2]:=Key;
                 edNTK.Text:=s;
                 key:=#0;
                 if p2<=11 then begin
                   if (p2=2) or (p2=5) or (p2=8) then edNTK.SelStart:=p2+1 else edNTK.SelStart:=p2;
                 end;
               end;
             end;
     End;
end;

procedure TFImportFiles.EdDurKeyPress(Sender: TObject; var Key: Char);
var s : string;
  i,p1,p2,p3 : integer;
begin
  if not (key in ['0'..'9',#8]) then begin
   key:=#0;
   exit;
  end;
  s:=EdDur.Text;
  p2:=EdDur.SelStart;
     Case Key of
       #8  : begin
               if EdDur.SelLength=0 then begin
                 if (p2<>3) and (p2<>6) and (p2<>9) then begin
                    s[p2]:='0';
                    EdDur.Text:=s;
                    key:=#0;
                    if p2>0 then EdDur.SelStart:=p2-1;
                 end else begin
                    s[p2]:=':';
                    EdDur.Text:=s;
                    key:=#0;
                    if p2>0 then EdDur.SelStart:=p2-1;
                 end;
               end else begin
                 for i:=p2+1 to p2+EdDur.SelLength do begin
                   if (i<>3) and (i<>6) and (i<>9) then s[i]:='0';
                 end;
                 EdDur.SelLength:=0;
                 EdDur.Text:=s;
                 if (p2=2) or (p2=5) or (p2=8) then EdDur.SelStart:=p2+1;
                 if p2>0 then key:=s[p2-1];
               end;
             end;
  '0'..'9' : begin
               if (p2=2) or (p2=5) or (p2=8) then p2:=p2+1;
               if (p2<>2) and (p2<>5) and (p2<>8) then begin
                 if p2<11 then p2:=p2+1 else p2:=12;
                   case p2 of
               1 : if strtoint(Key)>2 then Key:='2';
               2 : if s[1]='2' then if strtoint(Key)>3 then Key:='3';
               4 : if strtoint(Key)>5 then Key:='5';
               7 : if strtoint(Key)>5 then Key:='5';
               10: if strtoint(Key)>2 then Key:='2';
               11: if s[10]='2' then if strtoint(Key)>4 then Key:='4';
                   end;
                 s[p2]:=Key;
                 EdDur.Text:=s;
                 key:=#0;
                 if p2<=11 then begin
                   if (p2=2) or (p2=5) or (p2=8) then EdDur.SelStart:=p2+1 else EdDur.SelStart:=p2;
                 end;
               end;
             end;
     End;
end;

procedure TFImportFiles.EdStartTimeKeyPress(Sender: TObject;
  var Key: Char);
var s : string;
  i,p1,p2,p3 : integer;
begin
  if not (key in ['0'..'9',#8]) then begin
   key:=#0;
   exit;
  end;
  s:=EdStartTime.Text;
  p2:=EdStartTime.SelStart;
     Case Key of
       #8  : begin
               if EdStartTime.SelLength=0 then begin
                 if (p2<>3) and (p2<>6) and (p2<>9) then begin
                    s[p2]:='0';
                    EdStartTime.Text:=s;
                    key:=#0;
                    if p2>0 then EdStartTime.SelStart:=p2-1;
                 end else begin
                    s[p2]:=':';
                    EdStartTime.Text:=s;
                    key:=#0;
                    if p2>0 then EdStartTime.SelStart:=p2-1;
                 end;
               end else begin
                 for i:=p2+1 to p2+EdStartTime.SelLength do begin
                   if (i<>3) and (i<>6) and (i<>9) then s[i]:='0';
                 end;
                 EdStartTime.SelLength:=0;
                 EdStartTime.Text:=s;
                 if (p2=2) or (p2=5) or (p2=8) then EdStartTime.SelStart:=p2+1;
                 if p2>0 then key:=s[p2-1];
               end;
             end;
  '0'..'9' : begin
               if (p2=2) or (p2=5) or (p2=8) then p2:=p2+1;
               if (p2<>2) and (p2<>5) and (p2<>8) then begin
                 if p2<11 then p2:=p2+1 else p2:=12;
                   case p2 of
               1 : if strtoint(Key)>2 then Key:='2';
               2 : if s[1]='2' then if strtoint(Key)>3 then Key:='3';
               4 : if strtoint(Key)>5 then Key:='5';
               7 : if strtoint(Key)>5 then Key:='5';
               10: if strtoint(Key)>2 then Key:='2';
               11: if s[10]='2' then if strtoint(Key)>4 then Key:='4';
                   end;
                 s[p2]:=Key;
                 EdStartTime.Text:=s;
                 key:=#0;
                 if p2<=11 then begin
                   if (p2=2) or (p2=5) or (p2=8) then EdStartTime.SelStart:=p2+1 else EdStartTime.SelStart:=p2;
                 end;
               end;
             end;
     End;
end;

procedure TFImportFiles.SpeedButton3Click(Sender: TObject);
begin
  //txt := (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('File');
  ReloadClipInList(Form1.GridClips, Form1.GridClips.Row);
  lbFile.Caption := (Form1.GridClips.Objects[0,Form1.GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('File');
  edTotalDur.Text := (Form1.GridClips.Objects[0,Form1.GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('Duration');

  
end;

procedure TFImportFiles.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then begin
    //Label2.Enabled:=true;
    //RadioButton1.Enabled:=true;
    //RadioButton2.Enabled:=true;
    lbStartTimeTxt.Enabled:=true;
    edStartTime.Enabled:=true;
    //if (not RadioButton1.Checked) and (not RadioButton2.Checked) then RadioButton2.Checked:=true;
  end else begin
    //Label2.Enabled:=false;
    //RadioButton1.Enabled:=false;
    //RadioButton2.Enabled:=false;
    lbStartTimeTxt.Enabled:=false;
    edStartTime.Enabled:=false;
  end;
end;

procedure TFImportFiles.edClipKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key=65) then begin
    edClip.SelStart:=0;
    edClip.SelLength:=Length(edClip.Text);
  end;
end;

procedure TFImportFiles.edSongKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key=65) then begin
    edSong.SelStart:=0;
    edSong.SelLength:=Length(edSong.Text);
  end;
end;

procedure TFImportFiles.edSingerKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key=65) then begin
    edSinger.SelStart:=0;
    edSinger.SelLength:=Length(edSinger.Text);
  end;
end;

procedure TFImportFiles.edNTKChange(Sender: TObject);
var dlt, tdur, dur : longint;
begin
  if trim(edTotalDur.Text)='00:00:00:00' then begin
    ActiveControl:=edTotalDur;
    edTotalDur.SelStart:=0;
    edTotalDur.SelLength:=Length(edTotalDur.Text);
    exit;
  end;

  if trim(edDur.Text)='00:00:00:00' then begin
    edDur.Text := Trim(edTotalDur.Text);
    olddur := StrTimeCodeToFrames(edDur.Text);
  end;

  dur := oldntk + olddur - StrTimeCodeToFrames(edNTK.Text);
  edDur.Text := trim(FramesToStr(dur));

  oldntk := StrTimeCodeToFrames(edNTK.Text);
  olddur := dur;//StrTimeCodeToFrames(edDur.Text);
end;

end.
