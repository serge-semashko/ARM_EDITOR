unit UPlayLists;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TFPlayLists = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    edNamePL: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    dtpEndDate: TDateTimePicker;
    Label2: TLabel;
    mmCommentPL: TMemo;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPlayLists: TFPlayLists;

Procedure EditPlayList(ARow : integer);
Procedure PlaylistToPanel(ARow : integer);
Procedure SetPlaylistBlocking(ARow : integer);

implementation

uses umain, ucommon, uinitforms, ugrid;

{$R *.dfm}

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
begin
  with Form1, Form1.GridLists do begin
    lbPLName.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Note');
    lbPlaylist.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Name');
    lbPLComment.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Comment');
    lbPLCreate.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('ImportDate');
    lbPLEnd.Caption:=(Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('EndDate');
  end; //with
end;

procedure TFPlayLists.FormCreate(Sender: TObject);
begin
  InitPlaylists;
end;

Procedure EditPlayList(ARow : integer);
var i, setpos : integer;
    dt : string;
begin
  //if trim(TempPlayLists) = '' then TempPlayLists:='TMP' + createunicumname + '.tpls';
  if ARow=-1 then begin
    FPlayLists.edNamePL.Text:='';
    FPlayLists.mmCommentPL.Clear;
    FPlayLists.dtpEndDate.Date:=Now + DeltaDateDelete;
  end else begin
    FPlayLists.edNamePL.Text:=(Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Name');
    FPlayLists.mmCommentPL.Text:=(Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Comment');
    dt := (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('EndDate');
    if trim(dt)<>'' then FPlayLists.dtpEndDate.Date:=StrToDate(dt);
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
      dt := (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].ReadPhrase('ImportData');
      if trim(dt)='' then (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].UpdatePhrase('ImportDate',datetostr(Now));
      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].UpdatePhrase('EndDate',datetostr(FPlayLists.dtpEndDate.Date));
      for i:=1 to Form1.GridLists.RowCount-1 do (Form1.GridLists.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[2].Mark:=true;
      IDPLst := IDPLst + 1;
      (Form1.GridLists.Objects[0,setpos] as TGridRows).ID:= IDPLst;
      (Form1.GridLists.Objects[0,setpos] as TGridRows).MyCells[3].UpdatePhrase('Note','PL' + createunicumname +'.plst');
      Form1.GridLists.Row:=setpos;
      GridClear(Form1.GridActPlayList,RowGridClips);
      PlaylistToPanel(setpos);

    end else begin
      setpos:=ARow;
      (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('Name',FPlayLists.edNamePL.Text);
      (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('Comment',FPlayLists.mmCommentPL.Text);
      dt := (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('ImportData');
      if trim(dt)='' then (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('ImportDate',datetostr(Now));
      (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('EndDate',datetostr(FPlayLists.dtpEndDate.Date));
      dt := (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('Note');
        if trim(dt)='' then (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('Note','PL' + createunicumname +'.plst');
      if (Form1.GridLists.Objects[0,ARow] as TGridRows).MyCells[2].Mark then PlaylistToPanel(ARow);
    end;
    SetPlaylistBlocking(setpos);
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

end.
