unit UProject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid;

Type
  TFNewProject = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    Memo1: TMemo;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNewProject: TFNewProject;

function CreateProject(gridpos: longint): boolean;
procedure ProjectToPanel(ARow: integer);

Procedure SetProjectBlocking(ARow: integer);
function AddNewProject(Project, comment, EndData: string): integer;

implementation

uses umain, ucommon, uinitforms, umymessage;

{$R *.dfm}

Procedure SetProjectBlocking(ARow: integer);
begin
  With Form1.GridProjects do
  begin
    if objects[0, ARow] is TGridRows then
    begin
      if not(objects[0, ARow] as TGridRows).MyCells[2].Mark then
        exit;
      Form1.imgBlockProjects.Canvas.FillRect
        (Form1.imgBlockProjects.Canvas.ClipRect);
      if (objects[0, ARow] as TGridRows).MyCells[0].Mark then
        LoadBMPFromRes(Form1.imgBlockProjects.Canvas,
          Form1.imgBlockProjects.Canvas.ClipRect, 30, 30, 'Lock')
        // Form1.imgBlockProjects.Canvas.StretchDraw(Form1.imgBlockProjects.ClientRect,Form1.imgLock.Picture.Graphic)
      else
        LoadBMPFromRes(Form1.imgBlockProjects.Canvas,
          Form1.imgBlockProjects.Canvas.ClipRect, 30, 30, 'Unlock');
      // Form1.imgBlockProjects.Canvas.StretchDraw(Form1.imgBlockProjects.ClientRect,Form1.imgUnLock.Picture.Graphic);
    end;
    Form1.imgBlockProjects.Repaint;
  End;
end;

procedure ProjectToPanel(ARow: integer);
begin
  with Form1, Form1.GridProjects do
  begin
    lbProjectName.Caption := (objects[0, ARow] as TGridRows).MyCells[3]
      .ReadPhrase('Project');
    lbpComment.Caption := (objects[0, ARow] as TGridRows).MyCells[3]
      .ReadPhrase('Comment');
    lbDateStart.Caption := (objects[0, ARow] as TGridRows).MyCells[3]
      .ReadPhrase('ImportDate');
    lbDateEnd.Caption := (objects[0, ARow] as TGridRows).MyCells[3]
      .ReadPhrase('EndDate');
  end;
end;

function AddNewProject(Project, comment, EndData: string): integer;
var
  i, setpos: integer;
  dt: string;
begin
  With Form1.GridProjects do
  begin
    ucommon.initnewproject;
    setpos := GridAddRow(Form1.GridProjects, RowGridProject);
    (objects[0, setpos] as TGridRows).MyCells[0].Mark := false;
    (objects[0, setpos] as TGridRows).MyCells[1].Mark := false;
    (objects[0, setpos] as TGridRows).MyCells[3].UpdatePhrase
      ('Project', Project);
    (objects[0, setpos] as TGridRows).MyCells[3].UpdatePhrase
      ('Comment', comment);
    dt := (objects[0, setpos] as TGridRows).MyCells[3].ReadPhrase('ImportData');
    if trim(dt) = '' then
      (objects[0, setpos] as TGridRows).MyCells[3].UpdatePhrase('ImportDate',
        datetostr(Now));
    (objects[0, setpos] as TGridRows).MyCells[3].UpdatePhrase
      ('EndDate', EndData);
    for i := 1 to RowCount - 1 do
      (objects[0, i] as TGridRows).MyCells[2].Mark := false;
    (objects[0, setpos] as TGridRows).MyCells[2].Mark := true;
    IDProj := IDProj + 1;
    (objects[0, setpos] as TGridRows).ID := IDProj;
    ProjectNumber := createunicumname;
    (objects[0, setpos] as TGridRows).MyCells[3].UpdatePhrase('Note',
      ProjectNumber);
    Row := setpos;
    ProjectToPanel(setpos);
    result := setpos;
  end; // with
end;

Function CreateProject(gridpos: longint): boolean;
var
  i, setpos, ps: integer;
  dt, nm: string;
begin
  result := false;
  With Form1.GridProjects do
  begin
    if gridpos >= RowCount then
      exit;
    if gridpos = -1 then
    begin
      ps := findgridselection(Form1.GridProjects, 2);
      if ps <> -1 then
        if MyTextMessage('Вопрос', 'Сохранить текущий проект?', 2) then
          saveoldproject;
      FNewProject.Edit1.Text := '';
      FNewProject.Memo1.Text := '';
      FNewProject.DateTimePicker1.DateTime := Now + DeltaDateDelete;
      // Form1.lbPLName.Caption:='';
    end
    else
    begin
      FNewProject.Edit1.Text := (objects[0, gridpos] as TGridRows).MyCells[3]
        .ReadPhrase('Project');
      FNewProject.Memo1.Text := (objects[0, gridpos] as TGridRows).MyCells[3]
        .ReadPhrase('Comment');
      dt := (objects[0, gridpos] as TGridRows).MyCells[3].ReadPhrase('EndDate');
      if trim(dt) = '' then
        FNewProject.DateTimePicker1.DateTime := Now + DeltaDateDelete
      else
        FNewProject.DateTimePicker1.DateTime := StrToDate(dt);
    end;

    FNewProject.ActiveControl := FNewProject.Edit1;

    FNewProject.ShowModal;

    if FNewProject.ModalResult = mrOk then
    begin
      result := true;
      if gridpos = -1 then
      begin
        setpos := AddNewProject(FNewProject.Edit1.Text, FNewProject.Memo1.Text,
          datetostr(FNewProject.DateTimePicker1.Date));
        CreateDirectories(ProjectNumber);
      end
      else
      begin
        setpos := gridpos;
        (objects[0, gridpos] as TGridRows).MyCells[3].UpdatePhrase('Project',
          FNewProject.Edit1.Text);
        (objects[0, gridpos] as TGridRows).MyCells[3].UpdatePhrase('Comment',
          FNewProject.Memo1.Text);
        dt := (objects[0, gridpos] as TGridRows).MyCells[3]
          .ReadPhrase('ImportData');
        if trim(dt) = '' then
          (objects[0, gridpos] as TGridRows).MyCells[3].UpdatePhrase
            ('ImportDate', datetostr(Now));
        (objects[0, gridpos] as TGridRows).MyCells[3].UpdatePhrase('EndDate',
          datetostr(FNewProject.DateTimePicker1.Date));
        if (objects[0, setpos] as TGridRows).MyCells[2].Mark then
          ProjectToPanel(gridpos);
        dt := (objects[0, gridpos] as TGridRows).MyCells[3].ReadPhrase('Note');
        if trim(dt) = '' then
        begin
          ProjectNumber := createunicumname;
          (objects[0, gridpos] as TGridRows).MyCells[3].UpdatePhrase('Note',
            ProjectNumber);
        end;
      end;

      SetProjectBlocking(setpos);
      Form1.GridProjects.Row := setpos;
      Form1.ActiveControl := Form1.GridProjects;

    end; // ModalResult
  end; // With
end;

procedure TFNewProject.SpeedButton1Click(Sender: TObject);
begin
  if trim(FNewProject.Edit1.Text) <> '' then
    FNewProject.ModalResult := mrOk
  else
    ActiveControl := Edit1;
end;

procedure TFNewProject.SpeedButton2Click(Sender: TObject);
begin
  FNewProject.ModalResult := mrCancel;
end;

procedure TFNewProject.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    if ActiveControl = Memo1 then
      exit;
    SpeedButton1Click(nil);
  end;
  if Key = 27 then
    ModalResult := mrCancel;
end;

procedure TFNewProject.FormCreate(Sender: TObject);
begin
  initnewproject;
end;

end.
