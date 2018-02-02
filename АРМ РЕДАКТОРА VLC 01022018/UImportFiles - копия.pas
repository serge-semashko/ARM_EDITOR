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
    lbDateImpTxt: TLabel;
    lbDateEnd: TLabel;
    lbTotalDurTxt: TLabel;
    lbNTKTxt: TLabel;
    lbDURTxt: TLabel;
    lbTypeTxt: TLabel;
    edClip: TEdit;
    edSong: TEdit;
    edSinger: TEdit;
    lbType: TLabel;
    dtpDateEnd: TDateTimePicker;
    lbDateReg: TLabel;
    lbTotalDur: TLabel;
    lbNTK: TLabel;
    lbDur: TLabel;
    Bevel1: TBevel;
    Label15: TLabel;
    lbFile: TLabel;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    mmComment: TMemo;
    Panel1: TPanel;
    Label3: TLabel;
    mmMistakes: TMemo;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FImportFiles: TFImportFiles;

procedure EditClip(ARow : integer);
procedure GridClipsToPanel(ARow : integer);

implementation
uses umain, ucommon, ugrid, uplayer, uactplaylist, uwaiting, UHRTimer, umyfiles, uinitforms;

{$R *.dfm}

procedure AllClipsReset;
var i : integer;
begin
  for i:=1 to form1.GridClips.RowCount-1 do begin
    if form1.GridClips.Objects[0,i] is TGridRows then begin
      (form1.GridClips.Objects[0,i] as TGridRows).MyCells[1].Mark:=False;
    end;
  end;
end;

procedure LoadMultipleClips;
var err, i, ei, rw : integer;
    fne, fn, ext : string;
    Duration: Double;
begin
  with FImportFiles do begin
    mmMistakes.Lines.Clear;
    AllClipsReset;
    //WaitingStart('Импорт медиа-файлов');
    MyTimer.Waiting:=true;
    Application.ProcessMessages;
    ei := 0;
    for i:=0 to OpenDialog1.Files.Count-1 do begin
      fne := extractfilename(OpenDialog1.Files.Strings[i]);
      ext := extractfileext(OpenDialog1.Files.Strings[i]);
      fn := copy(fne,1,length(fne) - length(ext));
      FWait.timerword := 'Проверка: ' + fne;
      application.ProcessMessages;
      err := CreateGraph(OpenDialog1.Files.Strings[i]);
      application.ProcessMessages;
      if Err=0 then begin
         pMediaPosition.get_Duration(Duration);
         rw:=GridAddRow(Form1.GridClips,RowGridClips);
         IDCLIPS:=IDCLIPS+1;
         (Form1.GridClips.Objects[0,rw] as TGridRows).ID:=IDCLIPS;
         (Form1.GridClips.Objects[0,rw] as TGridRows).MyCells[1].Mark:=true;
         with (Form1.GridClips.Objects[0,rw] as TGridRows).MyCells[3] do begin
           UpdatePhrase('File',OpenDialog1.Files.Strings[i]);
           UpdatePhrase('Clip',fn + '_' + inttostr(IDCLIPS));
           UpdatePhrase('Song','');
           UpdatePhrase('Comment','');
           UpdatePhrase('Singer','');
           UpdatePhrase('ImportData',FormatDateTime('dd.mm.yyyy',now));
           UpdatePhrase('EndData',DateToStr(dtpDateEnd.Date + DeltaDateDelete));
           UpdatePhrase('Duration',MyDoubleToSTime(Duration));
           UpdatePhrase('NTK','00:00:00:00');
           UpdatePhrase('Dur',MyDoubleToSTime(Duration));
           UpdatePhrase('TypeMedia','');
         end;
         mmMistakes.Lines.Add('     ' + inttostr(i) + ')    Медиа-файл ' + fne + ' - Импортирован.');

      end else begin
        ei := ei + 1;
        mmMistakes.Lines.Add('     ' + inttostr(i) + ')    Медиа-файл ' + fne + ' - Невозможно прочитать.');
      end; //if
    end; //for
    MyTimer.Waiting:=false;

    WaitingStop;
    //systimer.StopTimer;
    if ei > 0 then begin
      mmMistakes.Lines.Add('');
      mmMistakes.Lines.Add('     Импортировалось медиа-файлов: ' + IntToStr(OpenDialog1.Files.Count));
      mmMistakes.Lines.Add('     Импортировано: ' + IntToStr(OpenDialog1.Files.Count - ei));
      mmMistakes.Lines.Add('     Не удалось импортировать: ' + IntToStr(ei));
      Panel3.Visible:=false;
      Panel1.Visible:=true;
      SpeedButton2.Visible:=false;
      SpeedButton1.Caption:='Закрыть';
      ShowModal;
      If ModalResult=mrOk then begin
         //SaveGridToFile(AppPath + DirProjects + '\' + TempClipsLists, Form1.GridClips);
      end;
    end else begin
      Form1.GridClips.Row:=rw;
      GridClipsToPanel(rw);
      //SaveGridToFile(AppPath + DirProjects + '\' + TempClipsLists, Form1.GridClips);
      ModalResult:=mrOk;
    end;
  end; //with
end;

procedure EditClip(ARow : integer);
var err, rw : integer;
    Duration: Double;
begin
  with FImportFiles do begin
// Устанваливаем первоначальные значения

    If ARow=-1 then begin
      if not OpenDialog1.Execute then exit;

      if OpenDialog1.Files.Count > 1 then begin
        //FWait.Start('Импорт медиа-файлов');
        LoadMultipleClips;
        exit;
      end;
      err := CreateGraph(OpenDialog1.FileName);
      if Err<>0 then begin
        ShowMessage('Не возможно прочитать параметры выбранного медиафайла.');
        exit;
      end;
      Panel3.Visible:=true;
      Panel1.Visible:=false;
      SpeedButton2.Visible:=true;
      SpeedButton1.Caption:='Сохранить';
      pMediaPosition.get_Duration(Duration);
      lbFile.Caption:=OpenDialog1.FileName;
      edClip.Text:='';
      edSong.Text:='';
      edSinger.Text:='';
      mmComment.Text:='';
      lbDateReg.Caption:=FormatDateTime('dd.mm.yyyy',now);
      dtpDateEnd.Date:=Now+DeltaDateDelete;
      lbTotalDur.Caption:=MyDoubleToSTime(Duration);
      lbNTK.Caption:='';
      lbDUR.Caption:='';
      lbType.Caption:='';
    end else begin
      if Form1.GridClips.Objects[0,ARow] is TGridRows then begin
        with (Form1.GridClips.Objects[0,ARow] as TGridRows).MyCells[3] do begin
          lbFile.Caption:=ReadPhrase('File');
          edClip.Text:=ReadPhrase('Clip');
          edSong.Text:=ReadPhrase('Song');
          edSinger.Text:=ReadPhrase('Singer');
          mmComment.Text:=ReadPhrase('Comment');
          lbDateReg.Caption:=ReadPhrase('ImportData');
          dtpDateEnd.Date:=StrToDate(ReadPhrase('EndData'));
          lbTotalDur.Caption:=ReadPhrase('Duration');
          lbNTK.Caption:=ReadPhrase('NTK');
          lbDUR.Caption:=ReadPhrase('Dur');
          lbType.Caption:=ReadPhrase('TypeMedia');
        end;
      end else exit;
    end;
// Открываем форму
    //FWait.Stop;
    ShowModal;
    ActiveControl:=edClip;
// Заносим результат в список клипов
    If ModalResult=mrOk then begin
      AllClipsReset;
      rw:=ARow;
      if ARow=-1 then begin
         rw:=GridAddRow(Form1.GridClips,RowGridClips);
         IDCLIPS:=IDCLIPS+1;
         (Form1.GridClips.Objects[0,rw] as TGridRows).ID:=IDCLIPS;
      end;
      (Form1.GridClips.Objects[0,rw] as TGridRows).MyCells[1].Mark:=true;
      with (Form1.GridClips.Objects[0,rw] as TGridRows).MyCells[3] do begin
        UpdatePhrase('File',lbFile.Caption);
        UpdatePhrase('Clip',edClip.Text);
        UpdatePhrase('Song',edSong.Text);
        UpdatePhrase('Comment',mmComment.Text);
        UpdatePhrase('Singer',edSinger.Text);
        UpdatePhrase('ImportData',lbDateReg.Caption);
        UpdatePhrase('EndData',DateToStr(dtpDateEnd.Date));
        UpdatePhrase('Duration',lbTotalDur.Caption);
        UpdatePhrase('NTK',lbNTK.Caption);
        UpdatePhrase('Dur',lbDur.Caption);
        UpdatePhrase('TypeMedia',lbType.Caption);
      end;
      Form1.GridClips.Row:=rw;
      GridClipsToPanel(rw);
      //SaveGridToFile(AppPath + DirProjects + '\' + TempClipsLists, Form1.GridClips);
    end;
  end;
end;

procedure TFImportFiles.SpeedButton1Click(Sender: TObject);
begin
  if panel1.Visible then begin
    modalresult := mrOk;
    exit;
  end;
  if (ActiveControl=mmComment) then exit;
  If trim(edClip.Text)='' then begin
    ActiveControl:=edClip;
    exit;
  end;
  If trim(edSong.Text)='' then begin
    ActiveControl:=edSong;
    exit;
  end;
  If trim(edSinger.Text)='' then begin
    ActiveControl:=edSinger;
    exit;
  end;
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
begin
  if Not (Form1.GridClips.Objects[0,ARow] is TGridRows) then exit;
  with (Form1.GridClips.Objects[0,ARow] as TGridRows).MyCells[3] do begin
    Form1.lbClip.Caption:=ReadPhrase('Clip');
    Form1.lbClipSong.Caption:=ReadPhrase('Song');
    Form1.lbClipComment.Caption:=ReadPhrase('Comment');
    Form1.lbClipSinger.Caption:=ReadPhrase('Singer');
    Form1.lbClipRegistr.Caption:=ReadPhrase('ImportData');
    Form1.lbClipStopUse.Caption:=ReadPhrase('EndData');
    Form1.lbClipTotalDur.Caption:=ReadPhrase('Duration');
    Form1.lbClipNTK.Caption:=ReadPhrase('NTK');
    Form1.lbClipDUR.Caption:=ReadPhrase('Dur');
    Form1.lbClipType.Caption:=ReadPhrase('TypeMedia');
    Form1.lbClipPath.Caption:=ReadPhrase('File');
  end;
end;

procedure TFImportFiles.FormCreate(Sender: TObject);
begin
  InitImportFiles;
  Panel1.Align := alClient;
end;

end.
