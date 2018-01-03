unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    PanelMenu: TPanel;
    PanelUsers: TPanel;
    pnctrlusers: TPanel;
    GridUsers: TStringGrid;
    imgbtnsusers: TImage;
    sbpmusers: TSpeedButton;
    sbpmprog: TSpeedButton;
    sbpmform: TSpeedButton;
    sbpmlist: TSpeedButton;
    sbpmevent: TSpeedButton;
    sbpmhotkey: TSpeedButton;
    Label1: TLabel;
    PanelProg: TPanel;
    pnctrlprog: TPanel;
    pnviewprog: TPanel;
    pnsampleprog: TPanel;
    Panel1: TPanel;
    GridSample: TStringGrid;
    imgsamplebtn: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Image1: TImage;
    Label4: TLabel;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure imgbtnsusersMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgbtnsusersMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridUsersDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure PanelUsersResize(Sender: TObject);
    procedure GridUsersDblClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbpmusersClick(Sender: TObject);
    procedure sbpmprogClick(Sender: TObject);
    procedure imgsamplebtnMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgsamplebtnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelProgResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ucommon, uimgbuttons, ugrid, unewuser, uinitforms, uchose;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var wdth : integer;
begin
  initmainprogram;
  initPanelMenu;
  initUsersPanel;
  initPanelProg;
end;

procedure TForm1.imgbtnsusersMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnspanelusers.MouseMove(imgbtnsusers.Canvas, X, Y);
end;

procedure TForm1.imgbtnsusersMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i, res : integer;
    s : string;
begin
  res := btnspanelusers.ClickButton(imgbtnsusers.Canvas, X, Y);
  BTNSPNUSERS(Res);
  
end;

procedure TForm1.imgsamplebtnMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  btnspanelsample.MouseMove(imgsamplebtn.Canvas,X,Y);
end;

procedure TForm1.imgsamplebtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res : integer;
begin
  res:=btnspanelsample.ClickButton(imgsamplebtn.Canvas,X,Y);
end;

procedure TForm1.GridUsersDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  GridDrawMyCell(GridUsers, ACol, ARow, Rect);
end;

procedure TForm1.PanelProgResize(Sender: TObject);
begin
  initPanelProg;
end;

procedure TForm1.PanelUsersResize(Sender: TObject);
begin
   GridUsers.ColWidths[0]:=Width - pnctrlusers.Width;
end;

procedure TForm1.sbpmprogClick(Sender: TObject);
begin
  BTNSPNMENU(1);
end;

procedure TForm1.sbpmusersClick(Sender: TObject);
begin
  BTNSPNMENU(0);
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
// нопки панели меню
  If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 85) then begin
    BTNSPNMENU(0);  //Ctrl + U
    exit;
  end;

  If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 80) then begin
    BTNSPNMENU(1);  //Ctrl + P
    exit;
  end;

// нопки окна пользоввателей
  if panelusers.Visible then begin
    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 78) then begin
      BTNSPNUSERS(0);  //Ctrl + N
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 82) then begin
      BTNSPNUSERS(1);  //Ctrl + R
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 46) then begin
      BTNSPNUSERS(2);  //DELETE
      exit;
    end;
  end;
end;

procedure TForm1.GridUsersDblClick(Sender: TObject);
begin
  EditUser(GridUsers.Row);
end;

end.
