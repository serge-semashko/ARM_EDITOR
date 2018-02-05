unit UButtonOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, utimeline;

type
  TFButtonOptions = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    lbNumber: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Bevel1: TBevel;
    Image1: TImage;
    Label2: TLabel;
    Bevel2: TBevel;
    ColorDialog1: TColorDialog;
    procedure Image1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetFormParam;
  end;

var
  FButtonOptions: TFButtonOptions;

procedure EditButtonsOptions(nom : integer; obj : TTimelineOptions);

implementation
uses ucommon, uimgbuttons;

{$R *.dfm}

procedure TFButtonOptions.SetFormParam;
begin
  //FButtonOptions
  FButtonOptions.Color:=FormsColor;
  FButtonOptions.Font.Color:=FormsFontColor;
  FButtonOptions.Font.Size:=FormsFontSize;
  if FormsFontName <> '' then FButtonOptions.Font.Name:=FormsFontName;
  //Edit1
  Edit1.Color:=FormsColor;
  Edit1.Font.Color:=FormsFontColor;
  Edit1.Font.Size:=FormsFontSize;
  if FormsFontName <> '' then Edit1.Font.Name:=FormsFontName;
  //Image1
  image1.Canvas.Brush.Color:=FormsColor;
  //Label1
  Label1.Color:=FormsColor;
  Label1.Font.Color:=FormsFontColor;
  Label1.Font.Size:=FormsFontSize;
  if FormsFontName <> '' then Label1.Font.Name:=FormsFontName;
  //Label
  Label2.Color:=FormsColor;
  Label2.Font.Color:=FormsFontColor;
  Label2.Font.Size:=FormsFontSize;
  if FormsFontName <> '' then Label2.Font.Name:=FormsFontName;
  //Label3
  Label3.Color:=FormsColor;
  Label3.Font.Color:=FormsFontColor;
  Label3.Font.Size:=FormsFontSize;
  if FormsFontName <> '' then Label3.Font.Name:=FormsFontName;
  //lbNumber
  lbNumber.Color:=FormsColor;
  lbNumber.Font.Color:=FormsFontColor;
  lbNumber.Font.Size:=FormsFontSize;
  if FormsFontName <> '' then lbNumber.Font.Name:=FormsFontName;
   //Panel1
  Panel1.Color:=FormsColor;
  Panel1.Font.Color:=FormsFontColor;
  Panel1.Font.Size:=FormsFontSize;
  if FormsFontName <> '' then Panel1.Font.Name:=FormsFontName;
  //SpeedButton1;
  SpeedButton1.Font.Color:=FormsFontColor;
  SpeedButton1.Font.Size:=FormsFontSize;
  if FormsFontName <> '' then SpeedButton1.Font.Name:=FormsFontName;
  //SpeedButton2;
  SpeedButton2.Font.Color:=FormsFontColor;
  SpeedButton2.Font.Size:=FormsFontSize;
  if FormsFontName <> '' then SpeedButton2.Font.Name:=FormsFontName;
end;

procedure EditButtonsOptions(nom : integer; obj : TTimelineOptions);
var deltx, delty : integer;
begin
  FButtonOptions.lbNumber.Caption:=inttostr(nom+1);
  FButtonOptions.Edit1.Text:=obj.DevNames[nom];
  FButtonOptions.Image1.Canvas.Brush.Color:=obj.DevColors[nom];
  FButtonOptions.Image1.Canvas.FillRect(FButtonOptions.Image1.Canvas.ClipRect);
  FButtonOptions.Image1.Canvas.Font.Color:=FormsFontColor;
  FButtonOptions.Image1.Canvas.Font.Size:=FormsFontSize+2;
  FButtonOptions.Image1.Canvas.Font.Style:=FButtonOptions.Image1.Canvas.Font.Style + [fsBold];
  deltx:=(FButtonOptions.Image1.Canvas.ClipRect.Right - FButtonOptions.Image1.Canvas.ClipRect.Left - FButtonOptions.Image1.Canvas.TextWidth(Trim(FButtonOptions.Edit1.Text))) div 2;
  delty:=(FButtonOptions.Image1.Canvas.ClipRect.Bottom - FButtonOptions.Image1.Canvas.ClipRect.Top - FButtonOptions.Image1.Canvas.TextHeight(Trim(FButtonOptions.Edit1.Text))) div 2;
  FButtonOptions.Image1.Canvas.TextOut(deltx,delty,Trim(FButtonOptions.Edit1.Text));
  FButtonOptions.ShowModal;
  if FButtonOptions.ModalResult=mrOk then begin
    if trim(FButtonOptions.Edit1.Text)<>''
    then obj.DevNames[nom]:=FButtonOptions.Edit1.Text
    else obj.DevNames[nom]:=inttostr(nom+1);
    obj.DevColors[nom]:=FButtonOptions.Image1.Canvas.Brush.Color;
  end;
end;


procedure TFButtonOptions.Image1Click(Sender: TObject);
var deltx, delty : integer;
begin
  Colordialog1.Color:=Image1.Canvas.Brush.Color;
  if Colordialog1.Execute then begin
    Image1.Canvas.Brush.Color:=Colordialog1.Color;
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
    Image1.Canvas.Font.Color:=FormsFontColor;
    Image1.Canvas.Font.Size:=FormsFontSize+2;
    Image1.Canvas.Font.Style:=Image1.Canvas.Font.Style + [fsBold];
    deltx:=(Image1.Canvas.ClipRect.Right - Image1.Canvas.ClipRect.Left - Image1.Canvas.TextWidth(Trim(Edit1.Text))) div 2;
    delty:=(Image1.Canvas.ClipRect.Bottom - Image1.Canvas.ClipRect.Top - Image1.Canvas.TextHeight(Trim(Edit1.Text))) div 2;
    Image1.Canvas.TextOut(deltx,delty,Trim(Edit1.Text));
  end;
end;

procedure TFButtonOptions.SpeedButton1Click(Sender: TObject);
begin
  FButtonOptions.ModalResult:=mrOk;
end;

procedure TFButtonOptions.SpeedButton2Click(Sender: TObject);
begin
  FButtonOptions.ModalResult:=mrCancel;
end;

procedure TFButtonOptions.FormCreate(Sender: TObject);
begin
  SetFormParam;
end;

end.
