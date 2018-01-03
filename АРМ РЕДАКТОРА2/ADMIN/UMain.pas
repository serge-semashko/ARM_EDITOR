unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    PanelUsers: TPanel;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    imgbtnsusers: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure imgbtnsusersMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgbtnsusersMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure PanelUsersResize(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ucommon, uimgbuttons, ugrid, unewuser;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var wdth : integer;
begin
  PanelUsers.Align:=alClient;
  btnspanelusers.Draw(imgbtnsusers.Canvas);
  Stringgrid1.RowCount:=2;
  stringgrid1.ColCount:=1;
  GridColorRow1:=SmoothColor(ProgrammColor,24);
  GridColorRow2:=SmoothColor(ProgrammColor,72);
  initgrid(stringgrid1, RowGridUsers, Form1.Width - Panel3.Width);
  ReadUsersFromFile('workingdata.dll',Stringgrid1);
  Stringgrid1.Repaint;
end;

procedure TForm1.imgbtnsusersMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnspanelusers.MouseMove(imgbtnsusers.Canvas, X, Y);
end;

procedure TForm1.imgbtnsusersMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res : integer;
begin
  res := btnspanelusers.ClickButton(imgbtnsusers.Canvas, X, Y);
       case res of
  0: EditUser(-1);
  1: begin end;
       end;
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  GridDrawMyCell(stringgrid1, ACol, ARow, Rect);
end;

procedure TForm1.PanelUsersResize(Sender: TObject);
begin
   Stringgrid1.ColWidths[0]:=Width - panel3.Width;
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
  EditUser(StringGrid1.Row);
end;

end.
