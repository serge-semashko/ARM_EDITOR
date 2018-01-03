unit UMTXInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, UCommon;

Const
   WM_MYCOMMAND1 = WM_USER + 1;
   WM_MYCOMMAND2 = WM_USER + 2;
type
  TfmMTXInput = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    procedure ReceiverCommand(var Msg: TMessage); message WM_MYCOMMAND2;
  public
    { Public declarations }
  end;

var
  fmMTXInput: TfmMTXInput;
  CurBTN : integer = -1;
  CurFunc : integer = -1;
  DownBtn : integer = -1;
  DownFunc : integer = -1;
  CurColor : Tcolor;
  FuncBtn : boolean = false;
  BoolBTNSel : boolean = false;
  //NewBTN : integer = 0;


implementation

{$R *.dfm}
{$RANGECHECKS ON}

procedure TfmMTXInput.ReceiverCommand(var Msg: TMessage);
var i, val1, val2 : integer;
    s : string;
begin
  BTNOUTPUTS.CurrBTN:=Integer(msg.lparam);
  val2:=Integer(msg.WParam);
  //BTNOUTPUTS.BTNNames1[4]:=inttostr(val);
  if BTNINPUTS.CurrBTN<>-1 then MTXButtonDraw(Image1.Canvas,BTNINPUTS.CurrBTN,BTNINPUTS,BTNINPUTS.CLBTN,false);
  BTNINPUTS.CurrBTN:=val2;
  //MTXButtonDraw(Image1.Canvas,BTNINPUTS.CurrBTN,BTNINPUTS,BTNINPUTS.CLBTNSET,false);
  for i:=0 to BTNINPUTS.BCNT-1 do BTNINPUTS.BTNSelects[i]:=false;
  ToDisplayMTXButtons(Image1.Canvas,BTNINPUTS);
  msg.result:=1;
end;

procedure TfmMTXInput.Timer1Timer(Sender: TObject);
var i : integer;
begin
  BoolBTNSel:=not BoolBTNSel;
  for i:=0 to BTNINPUTS.BCNT-1 do begin
    if BTNINPUTS.BTNSelects[i] then begin
      if BoolBTNSel
        then MTXButtonDraw(Image1.Canvas,i+1,BTNINPUTS,DownColor(BTNOUTPUTS.CLBTNSEL,40),false)
        else MTXButtonDraw(Image1.Canvas,i+1,BTNINPUTS,BTNOUTPUTS.CLBTNSEL,false);
        //application.ProcessMessages;
    end;
  end;
end;

procedure TfmMTXInput.FormCreate(Sender: TObject);
var xi, yi : integer;
    inp, cntbtn, i, lft, top, dlt2, ttlh : integer;
begin
  fmMTXInput.DoubleBuffered:=true;
  image1.Parent.DoubleBuffered:=true;
  INHANDLE:=fmMTXInput.Handle;
    InitMTXButtons(BTNINPUTS);
  BTNINPUTS.NameForm:='S o u r c e s';
  BTNINPUTS.TYPEBTN:=false;
  for i := 0 to BTNINPUTS.BCNT - 1 do begin
    BTNINPUTS.BTNNames1[i]:=inttostr(i+1);
    BTNINPUTS.BTNNames2[i]:='In-' + inttostr(i+1);
    BTNINPUTS.BTNTitles[i]:='Out-' + inttostr(i+1);
  end;
  BTNINPUTS.FCNT:=2;
  SetLength(BTNINPUTS.FBTNNames1,BTNINPUTS.FCNT);
  SetLength(BTNINPUTS.FBTNNames2,BTNINPUTS.FCNT);
  SetLength(BTNINPUTS.FBTNTitles,BTNINPUTS.FCNT);
  BTNINPUTS.CNTX:=16;
  BTNINPUTS.CNTY:=2;
  BTNINPUTS.CNTFX:=1;
  BTNINPUTS.CNTFY:=2;
  BTNINPUTS.FBTNNames1[0]:='Take';
  BTNINPUTS.FBTNNames1[1]:='Close';
  BKGND_Form(fmMTXInput,Image1,BTNINPUTS);
  RegionMTXButtons(Image1.Canvas, BTNINPUTS);
  RegionFUNCButtons(Image1.Canvas, BTNINPUTS);
end;

procedure TfmMTXInput.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  downbtn:=ButtonInRect(X,Y,0,BTNINPUTS);
  downfunc:=ButtonInRect(X,Y,1,BTNINPUTS);
  if (downbtn<>-1) then begin
    MTXButtonDraw(Image1.Canvas,downbtn,BTNINPUTS,BTNINPUTS.CLBTNDOWN,false);
    exit;
  end;
  if downfunc<>-1 then begin;
    MTXButtonDraw(Image1.Canvas,downfunc,BTNINPUTS,BTNINPUTS.CLBTNDOWN,true);
    exit;
  end;
  ReleaseCapture;
  fmMTXInput.perform(WM_SysCommand,$F012,0);
end;

procedure TfmMTXInput.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var dlt1, dlt2, i, cnt : integer;
begin
  curbtn:=ButtonInRect(X,Y,0,BTNINPUTS);
  curfunc:=ButtonInRect(X,Y,1,BTNINPUTS);

  if (curbtn=downbtn) and (curbtn<>-1) then begin
    for i:=0 to BTNINPUTS.BCNT-1 do BTNINPUTS.BTNSelects[i]:=false;
    BTNINPUTS.BTNSelects[curbtn-1]:=True;
    SendMessage(OUTHANDLE,WM_MYCOMMAND1,0,Integer(curbtn));
    ToDisplayMTXButtons(Image1.Canvas,BTNINPUTS);
    exit
  end;
  if (curfunc=downfunc) and (curfunc<>-1) then begin
    for i:=0 to BTNINPUTS.FCNT-1 do BTNINPUTS.FBTNSelects[i]:=false;
    BTNINPUTS.FBTNSelects[curfunc-1]:=True;
    ToDisplayMTXButtons(Image1.Canvas,BTNINPUTS);
    if BTNINPUTS.FBTNNames1[curfunc-1]='Close' then begin
      curfunc:=-1;
      downfunc:=-1;
      close;
    end;
//    if BTNINPUTS.FBTNNames1[curfunc-1]='Take' then begin
//      SendMessage(OUTHANDLE,WM_MYCOMMAND1,0,Integer(curbtn));
//      //close;
//    end;
  end;
end;

procedure TfmMTXInput.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var dlt1, dlt2, i, cnt : integer;
begin
  dlt1:=ButtonInRect(X,Y,0,BTNINPUTS);
  dlt2:=ButtonInRect(X,Y,1,BTNINPUTS);

  if (dlt1=-1) and (dlt2=-1) then exit;

  if (dlt1<>downbtn) or (dlt1=-1) then begin
//    for i:=0 to BTNINPUTS.BCNT-1 do begin
//      if BTNINPUTS.BTNSelects[i] then begin
//        if BoolBTNSel
//          then MTXButtonDraw(Image1.Canvas,i+1,BTNINPUTS,DownColor(BTNOUTPUTS.CLBTNSEL,40),false)
//          else ToDisplayMTXButtons(Image1.Canvas,BTNINPUTS);;
//      end;
//    end;
    for i:=0 to BTNINPUTS.BCNT-1 do BTNINPUTS.BTNSelects[i]:=false;
//    if downbtn<>-1 then BTNINPUTS.BTNSelects[downbtn-1]:=true;
    ToDisplayMTXButtons(Image1.Canvas,BTNINPUTS);
    exit
  end;
  if (dlt2=downfunc) and (downfunc<>-1) then begin
//    for i:=0 to BTNINPUTS.FCNT-1 do BTNINPUTS.FBTNSelects[i]:=false;
//    BTNINPUTS.FBTNSelects[curfunc-1]:=True;
    ToDisplayMTXButtons(Image1.Canvas,BTNINPUTS);
  end;
end;

end.








