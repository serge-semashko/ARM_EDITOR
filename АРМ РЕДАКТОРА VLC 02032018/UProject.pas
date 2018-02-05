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
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNewProject: TFNewProject;

function CreateProject(mode : integer) : boolean;
procedure OpenProject;
procedure SaveProjectAs;
procedure SaveProject;

implementation

uses umain, ucommon, uinitforms, umymessage, umyfiles, ugrtimelines;

{$R *.dfm}

procedure OpenProject;
begin
  with Form1 do begin
    if IsProjectChanges then begin
      if MyTextMessage('Вопрос','Сохранить текущий проект '+ FileNameProject +'?',2)
           then SaveProject;
    end;
    opendialog1.InitialDir:=PathProject;
    opendialog1.FileName:=FileNameProject;
    opendialog1.Filter:='Файлы проета (*.proj)|*.PROJ|Все файлы (*.*)|*.*';
    opendialog1.FilterIndex:=0;
    if not opendialog1.Execute then exit;
    FileNameProject:=opendialog1.FileName;
    ReadProjectFromFile(opendialog1.FileName);
    savedialog1.FileName:=FileNameProject;
    TLZone.ClearZone;
    Form1.lbActiveClipID.Caption:='';
    Label2Click(nil);
    SetMainGridPanel(projects);
    IsProjectChanges := false;
    ClearClipsStatusPlay;
  end;
end;

procedure SaveProjectAs;
var nm, ext : string;
begin
  SaveClipFromPanelPrepare;
  with Form1 do begin
    SaveDialog1.InitialDir:=PathProject;
    savedialog1.FileName:=FileNameProject;
    savedialog1.Filter:='Файлы проета (*.proj)|*.PROJ|Все файлы (*.*)|*.*';
    savedialog1.FilterIndex:=0;
    if not savedialog1.Execute then exit;
    nm := savedialog1.FileName;
    ext := extractfileext(nm);
    if trim(ext)='' then nm := nm + '.proj';
    SaveProjectToFile(nm);
    WriteEditedProjects(nm);
    FileNameProject:=nm;
    IsProjectChanges := false;
  end;
end;

procedure SaveProject;
begin
  if trim(FileNameProject)<>'' then begin
    SaveClipFromPanelPrepare;
    SaveProjectToFile(FileNameProject);
    IsProjectChanges := false;
  end else SaveProjectAs;
end;

function CreateProject(mode : integer) : boolean;
var i, setpos, ps : integer;
    dt, nm : string;
begin
  if IsProjectChanges then begin
      if MessageDlg('Сохранить текущий проект '+ FileNameProject +'?',
         mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then SaveProject;
  end;
  result := false;
  if trim(ProjectNumber)<>'' then begin
    if MyTextMessage('Вопрос', 'Сохранить текущий проект?',2) then begin
      if trim(FileNameProject)='' then saveprojectas else saveproject;
    end;
  end;
  if mode<0 then begin
    FNewProject.Edit1.Text:='';
    FNewProject.Memo1.Text:='';
    FNewProject.DateTimePicker1.DateTime:=now + DeltaDateDelete;
  end else begin
    FNewProject.Edit1.Text:=Form1.lbProjectName.Caption;
    FNewProject.Memo1.Text:=Form1.lbpComment.Caption;
    if trim(Form1.lbDateEnd.Caption)=''
      then FNewProject.DateTimePicker1.DateTime:=now + DeltaDateDelete
      else FNewProject.DateTimePicker1.DateTime:=strtodate(Form1.lbDateEnd.Caption);
  end;

  FNewProject.ActiveControl:=FNewProject.Edit1;
  FNewProject.ShowModal;

  if FNewProject.ModalResult=mrOk then begin
    result := true;
    if mode<0 then ProjectNumber := createunicumname;
    Form1.lbProjectName.Caption:=FNewProject.Edit1.Text;
    Form1.lbpComment.Caption:=FNewProject.Memo1.Text;
    Form1.lbDateStart.Caption:=datetostr(Now);
    Form1.lbDateEnd.Caption:=datetostr(FNewProject.DateTimePicker1.Date);
    IsProjectChanges := false;
  end;
end;

procedure TFNewProject.SpeedButton1Click(Sender: TObject);
begin
  if Trim(FNewProject.Edit1.Text)<>''
    then FNewProject.ModalResult:=mrOk
    else ActiveControl:=Edit1;
end;

procedure TFNewProject.SpeedButton2Click(Sender: TObject);
begin
  FNewProject.ModalResult:=mrCancel;
end;

procedure TFNewProject.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then begin
    if ActiveControl=Memo1 then exit;
    SpeedButton1Click(nil);
  end;
  if key=27 then ModalResult:=mrCancel;
end;

procedure TFNewProject.FormCreate(Sender: TObject);
begin
  InitNewProject;
end;

end.
