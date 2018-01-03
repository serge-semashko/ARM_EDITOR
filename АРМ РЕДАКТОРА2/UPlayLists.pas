unit UPlayLists;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, CheckLst;

type
  TMyListBoxObject = class(TObject)
    public
    ClipID : String;
    Constructor Create;
    Destructor  Destroy;
  end;

  TFPlayLists = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    edNamePL: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    mmCommentPL: TMemo;
    Label3: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PlayListName : string;
  end;

var
  FPlayLists: TFPlayLists;

Procedure EditPlayList(ARow : integer);
Procedure PlaylistToPanel(ARow : integer);
Procedure SetPlaylistBlocking(ARow : integer);
Procedure ReadListClips;
Procedure LoadClipsFromPlayLists(PLName : string);

implementation

uses umain, ucommon, uinitforms, ugrid, uactplaylist;

{$R *.dfm}

constructor TMyListBoxObject.Create;
begin
  inherited;
  ClipID := '';
end;

destructor TMyListBoxObject.Destroy;
begin
  FreeMem(@ClipID);
  inherited;
end;

Procedure SetPlaylistBlocking(ARow : integer);
begin
  With Form1.GridLists do begin
    Form1.Image1.Canvas.FillRect(Form1.Image1.Canvas.ClipRect);
    if objects[0,ARow] is TGridRows
      then if (Objects[0,ARow] as TGridRows).MyCells[0].Mark
              then LoadBMPFromRes(Form1.Image1.Canvas,Form1.Image1.Canvas.ClipRect,20,20,'UnLock')
              else LoadBMPFromRes(Form1.Image1.Canvas,Form1.Image1.Canvas.ClipRect,20,20,'Lock');
    Form1.Image1.Repaint;
  End;
end;

Procedure PlaylistToPanel(ARow : integer);
var plnm : string;
    i, j : integer;
begin
  with Form1, Form1.GridLists do begin
    cbPlayLists.Clear;
    for i:=1 to GridLists.RowCount-1 do begin
      cbPlayLists.Items.Add((GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Name'));
      j := cbPlayLists.Items.Count-1;
      if not (cbPlayLists.Items.Objects[j] is TMyListBoxObject) then cbPlayLists.Items.Objects[j] := TMyListBoxObject.Create;
      (cbPlayLists.Items.Objects[j] as TMyListBoxObject).ClipId := (GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
    end;
    //ps:=findgridselection(GridLists,2);
    cbPlayLists.ItemIndex:=ARow-1;

    //plnm := (Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Note');
    //lbPLName.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Note');
    //lbPlaylist.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Name');
    lbPLComment.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Comment');
    //lbPLCreate.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('ImportDate');
    //lbPLEnd.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('EndDate');
  end; //with
end;

procedure TFPlayLists.FormCreate(Sender: TObject);
begin
  InitPlaylists;
end;

Procedure ReadListClips;
var i, ps : integer;
    clpid : string;
begin
  with Form1.GridClips do begin
    FPlayLists.ListBox1.clear;
    for i:=1 to RowCount-1 do begin
       FPlayLists.ListBox1.Items.Add('    ' + (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Clip'));
       ps := FPlayLists.ListBox1.Items.Count-1;
       if not (FPlayLists.ListBox1.Items.Objects[ps] is TMyListBoxObject) then FPlayLists.ListBox1.Items.Objects[ps] := TMyListBoxObject.Create;
       (FPlayLists.ListBox1.Items.Objects[ps] as TMyListBoxObject).ClipId := (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    end; //for
  end;
end;

function findclipposition(ClipID : string) : integer;
var i : integer;
begin
  result:=-1;
  for i:=1 to Form1.GridClips.RowCount-1 do begin
    if trim((Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID'))=trim(ClipID) then begin
      result:=i;
      exit;
    end;
  end;
end;

procedure WriteClipsToPlayLists;
var Stream : TFileStream;
    i, j, ps, cnt : integer;
    renm, FileName, clipid : string;
begin
  with FPlayLists do begin
    FileName := PathPlayLists + '\' + FPlayLists.PlayListName;
    if FileExists(FileName) then begin
      renm := PathPlayLists + '\' + 'Temp.prjl';
      RenameFile(FileName,renm);
      DeleteFile(renm);
    end;
    Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
    try
      for i:=ListBox2.Items.Count-1 downto 0
        do if trim(ListBox2.Items.Strings[i])='' then ListBox2.Items.Delete(i);
      cnt := ListBox2.Items.Count+1;
      //Stream.WriteBuffer(cnt, SizeOf(cnt));
      //(Form1.GridClips.Objects[0,0] as TGridRows).WriteToStream(Stream);
      if cnt=1 then begin
        cnt:=2;

        Stream.WriteBuffer(cnt, SizeOf(cnt));
        (Form1.GridClips.Objects[0,0] as TGridRows).WriteToStream(Stream);
        TempGridRow.Clear;
        TempGridRow.Assign(RowGridClips);
        TempGridRow.WriteToStream(Stream);
      end else begin
        Stream.WriteBuffer(cnt, SizeOf(cnt));
       (Form1.GridClips.Objects[0,0] as TGridRows).WriteToStream(Stream);
        for i:=0 to ListBox2.Items.Count-1 do begin
          clipid := trim((ListBox2.Items.Objects[i] as TMyListBoxObject).ClipId);
          if clipid<>'' then begin
            ps := findclipposition(clipid);
            (Form1.GridClips.Objects[0,ps] as TGridRows).WriteToStream(Stream);
          end;
        end;
      end;
    finally
      FreeAndNil(Stream);
    end;
  end;
end;

//function ClipIsListBox1(clipid : string)

Procedure LoadClipsFromPlayLists(PLName : string);
var Stream : TFileStream;
    i, cnt, ps : integer;
    //sz, ps : longint;
    renm, FileName : string;
    tc : TTypeCell;
    clp, clpid : string;
begin
  with FPlayLists do begin
    FileName := PathPlayLists + '\' + FPlayLists.PlayListName;
    if not FileExists(FileName) then exit;
    Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
    try
    Stream.ReadBuffer(cnt, SizeOf(integer));
    ListBox2.Items.Clear;
    for i:=0 to cnt-1 do begin
      TempGridRow.Clear;
      TempGridRow.ReadFromStream(Stream);
      TempGridRow.SetDefaultFonts;
      if i>0 then begin
        clp:=TempGridRow.MyCells[3].ReadPhrase('Clip');
        clpid:=TempGridRow.MyCells[3].ReadPhrase('ClipId');

        ListBox2.Items.Add(TempGridRow.MyCells[3].ReadPhrase('Clip'));
        ps := ListBox2.Items.Count-1;
        if not (ListBox2.Items.Objects[ps] is TMyListBoxObject) then ListBox2.Items.Objects[ps] := TMyListBoxObject.Create;
        (ListBox2.Items.Objects[ps] as TMyListBoxObject).ClipId := TempGridRow.MyCells[3].ReadPhrase('ClipId');
      end;
    end;
    finally
      FreeAndNil(Stream);
    end;
  end;
end;

Procedure EditPlayList(ARow : integer);
var i, setpos : integer;
    dt : string;
begin
  //if trim(TempPlayLists) = '' then TempPlayLists:='TMP' + createunicumname + '.tpls';
  ReadListClips;
  FPlayLists.ListBox2.Clear;
  if ARow=-1 then begin
    FPlayLists.edNamePL.Text:='';
    FPlayLists.mmCommentPL.Clear;
    FPlayLists.PlayListName := '';
  end else begin
    FPlayLists.edNamePL.Text:=(Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Name');
    FPlayLists.mmCommentPL.Text:=(Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Comment');
    FPlayLists.PlayListName := (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Note');
    if trim(FPlayLists.PlayListName)<>'' then LoadClipsFromPlayLists(FPlayLists.PlayListName);
  end;

  FPlayLists.ActiveControl:=FPlayLists.edNamePL;
  FPlayLists.ShowModal;

  if FPlayLists.ModalResult = mrOk then begin
    if ARow=-1 then begin
      setpos := GridAddRow(Form1.GridLists, RowGridListPL);
      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[0].Mark:=false;
      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[1].Mark:=false;
      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].UpdatePhrase('Name',FPlayLists.edNamePL.Text);
      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].UpdatePhrase('Comment',FPlayLists.mmCommentPL.Text);
      //dt := (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].ReadPhrase('ImportData');
      //if trim(dt)='' then (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].UpdatePhrase('ImportDate',datetostr(Now));
//      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].UpdatePhrase('EndDate',datetostr(FPlayLists.dtpEndDate.Date));
      for i:=1 to Form1.GridLists.RowCount-1 do (Form1.GridLists.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[2].Mark:=true;
      IDPLst := IDPLst + 1;
      (Form1.GridLists.Objects[0,setpos] as TGridRows).ID:= IDPLst;
      FPlayLists.PlayListName := 'PL' + createunicumname +'.plst';
      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].UpdatePhrase('Note',FPlayLists.PlayListName);
      Form1.GridLists.Row:=setpos;
      GridClear(Form1.GridActPlayList,RowGridClips);
      //PlaylistToPanel(setpos);

    end else begin
      setpos:=ARow;
      (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('Name',FPlayLists.edNamePL.Text);
      (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('Comment',FPlayLists.mmCommentPL.Text);
     // dt := (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('ImportData');
     // if trim(dt)='' then (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('ImportDate',datetostr(Now));
//      (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('EndDate',datetostr(FPlayLists.dtpEndDate.Date));
      dt := (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Note');
      if trim(dt)='' then begin
        FPlayLists.PlayListName := 'PL' + createunicumname +'.plst';
        (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('Note',FPlayLists.PlayListName);
      end else FPlayLists.PlayListName := dt;
      //if (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[2].Mark then PlaylistToPanel(ARow);
    end;
    WriteClipsToPlayLists;
    SetPlaylistBlocking(setpos);
    //LoadClipsFromPlayLists(FPlayLists.PlayListName);
  end;
end;

procedure TFPlayLists.SpeedButton2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TFPlayLists.SpeedButton1Click(Sender: TObject);
begin
  if Trim(edNamePL.Text)<>''
    then ModalResult:=mrOk
    else ActiveControl:=edNamePL;
end;

procedure TFPlayLists.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then begin
    if ActiveControl=mmCommentPL then exit;
    SpeedButton1Click(nil);
  end;
end;

procedure TFPlayLists.SpeedButton3Click(Sender: TObject);
var i : integer;
begin
  ListBox2.DeleteSelected;
end;

function ClipExists(ClipID : String) : boolean;
var i : integer;
begin
  with FPlayLists do begin
    result := false;
    for i:=0 to ListBox2.Items.Count-1 do begin
      if ListBox2.Items.Objects[i] is TMyListBoxObject then begin
        if (ListBox2.Items.Objects[i] as TMyListBoxObject).ClipID=ClipID then begin
          Result := true;
          exit;
        end;
      end;
    end;
  end;
end;

procedure TFPlayLists.SpeedButton5Click(Sender: TObject);
var i, ps : integer;

begin
  for i:=ListBox2.Items.Count-1 downto 0
        do if trim(ListBox2.Items.Strings[i])='' then ListBox2.Items.Delete(i);

//  with FPlayLists do begin
    for i:=0 to ListBox1.Items.Count-1 do begin
      if ListBox1.Selected[i] then begin
        if ListBox1.Items.Objects[i] is TMyListBoxObject then begin
          if not ClipExists((ListBox1.Items.Objects[i] as TMyListBoxObject).ClipID) then begin
            ListBox2.Items.Add(trim(ListBox1.Items.Strings[i]));
            ps := ListBox2.Items.Count-1;
            if not (ListBox2.Items.Objects[ps] is TMyListBoxObject) then ListBox2.Items.Objects[ps] := TMyListBoxObject.Create;
            (ListBox2.Items.Objects[ps] as TMyListBoxObject).ClipId := (ListBox1.Items.Objects[i] as TMyListBoxObject).ClipId;
          end;
        end;
      end;
      ListBox1.Selected[i]:=false;
    end;
//  end;
end;

end.
