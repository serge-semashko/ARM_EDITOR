unit UMTXButton;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Spin, ExtCtrls, Math, UCommon;

Const
  WM_MYCOMMAND1 = WM_USER + 1;
  WM_MYCOMMAND2 = WM_USER + 2;

type
  TfmMTX = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure ReceiverCommand(var Msg: TMessage); message WM_MYCOMMAND1;
  public
    { Public declarations }
  end;

var
  fmMTX: TfmMTX;
  CurBTN : integer = -1;
  FuncBtn : boolean = false;
  bl : boolean;
  //NewBTN : integer = 0;
  //BTNOUTPUTS : TMTXButtons;

implementation
uses ComPortUnit, UMTXInput;

{$R *.dfm}

procedure TfmMTX.ReceiverCommand(var Msg: TMessage);
var val : integer;
    s : string;
begin
  val:=Integer(msg.lparam);
  if CurBTN<>-1 then begin
   BTNOUTPUTS.BTNNames1[CurBTN-1]:=inttostr(val);
   MTXButtonDraw(Image1.Canvas,CurBTN,BTNOUTPUTS,BTNOUTPUTS.CLBTNSEL,false);
  end; 
  msg.result:=1;
end;

procedure TfmMTX.Timer1Timer(Sender: TObject);
var  i, cnt, ps : integer;
     ss, s1, s2, str : string;

begin
//  bl:=not bl;
//  for i:=0 to BTNOUTPUTS.BCNT-1 do begin
//    if trim(BTNOUTPUTS.BTNNames1[i])=inttostr(1) then begin
//      if bl
//        then MTXButtonDraw(Image1.Canvas,i+1,BTNOUTPUTS,DownColor(BTNOUTPUTS.CLBTNSEL,25),false)
//        else MTXButtonDraw(Image1.Canvas,i+1,BTNOUTPUTS,BTNOUTPUTS.CLBTNSEL,false);
//        //application.ProcessMessages;
//    end;
//  end;

//  str:='';
//  CommDataRead:=false;
//  WriteStrToPort('R');
//  repeat application.ProcessMessages; until CommDataRead;
//  for i := 0 to lstCommMes.Count - 1
//    do if trim(lstCommMes.Strings[i])<>'' then str:=str+trim(lstCommMes.Strings[i]);
//  lstOutputs.Clear;
//  cnt:=cntx * cnty;
//  for i:=1 to cnt do begin
//    lstOutputs.Add('0');
//  end;
//  s1:=str;
//  for i:=1 to cnt do begin
//    ss:='0' + inttostr(i) + ',';
//    ps:=pos(ss,str);
//    if ps<>0 then begin
//      s2:=copy(str,ps+length(ss),4);
//      lstOutputs.Strings[i-1]:=s2;
//    end;
//  end;
  //SpeedButton1Click(nil);
end;

procedure TfmMTX.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=false;
end;

procedure TfmMTX.FormCreate(Sender: TObject);
var xi, yi : integer;
    inp, cntbtn, i, lft, top, dlt2, ttlh : integer;
begin
  fmMTX.DoubleBuffered:=true;
  image1.Parent.DoubleBuffered:=true;
  OUTHANDLE:=fmMTX.Handle;
    InitMTXButtons(BTNOUTPUTS);
  BTNOUTPUTS.NameForm:='D e s t i n a t i o n s';
  BTNOUTPUTS.TYPEBTN:=true;
  BTNOUTPUTS.frmTop:=50;
  BTNOUTPUTS.CLBTN:=clAqua;
  for i := 0 to BTNOUTPUTS.BCNT - 1 do begin
    BTNOUTPUTS.BTNNames1[i]:=inttostr(i+1);
    BTNOUTPUTS.BTNNames2[i]:='In-' + inttostr(i+1);
    BTNOUTPUTS.BTNTitles[i]:='Out-' + inttostr(i+1);
  end;
  BTNOUTPUTS.FCNT:=2;
  SetLength(BTNOUTPUTS.FBTNNames1,BTNOUTPUTS.FCNT);
  SetLength(BTNOUTPUTS.FBTNNames2,BTNOUTPUTS.FCNT);
  SetLength(BTNOUTPUTS.FBTNTitles,BTNOUTPUTS.FCNT);
  BTNOUTPUTS.CNTX:=16;
  BTNOUTPUTS.CNTY:=2;
  BTNOUTPUTS.FCNT:=1;
  BTNOUTPUTS.CNTFX:=1;
  BTNOUTPUTS.CNTFY:=1;
  BTNOUTPUTS.FBTNNames1[0]:='Close';
  //BTNOUTPUTS.FBTNNames1[1]:='';
  BKGND_Form(fmMTX,Image1,BTNOUTPUTS);
  RegionMTXButtons(Image1.Canvas, BTNOUTPUTS);
  RegionFUNCButtons(Image1.Canvas, BTNOUTPUTS);
end;

procedure TfmMTX.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var dlt1, dlt2 : integer;
begin
  dlt1:=ButtonInRect(X,Y,0,BTNOUTPUTS);
  dlt2:=ButtonInRect(X,Y,1,BTNOUTPUTS);
  if dlt1<>-1 then begin
     MTXButtonDraw(Image1.Canvas,dlt1,BTNOUTPUTS,BTNOUTPUTS.CLBTNDOWN,false);
     funcbtn:=false;
     curbtn:=dlt1;
  end else if dlt2<>-1 then begin;
     MTXButtonDraw(Image1.Canvas,dlt2,BTNOUTPUTS,BTNOUTPUTS.CLBTNDOWN,true);
     funcbtn:=true;
     curbtn:=dlt2;
  end else begin
    ReleaseCapture;
    fmMTX.perform(WM_SysCommand,$F012,0);
  end;
end;

procedure TfmMTX.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var dlt1, dlt2, src : integer;
begin
  dlt1:=ButtonInRect(X,Y,0,BTNOUTPUTS);
  dlt2:=ButtonInRect(X,Y,1,BTNOUTPUTS);
  if (curbtn<>dlt1) and (not funcbtn)  then MTXButtonDraw(Image1.Canvas,curbtn,BTNOUTPUTS,BTNOUTPUTS.CLBTN,false);
  if (curbtn<>dlt2) and funcbtn then MTXButtonDraw(Image1.Canvas,curbtn,BTNOUTPUTS,BTNOUTPUTS.CLFBTN,true);
  if dlt1<>-1 then begin
     MTXButtonDraw(Image1.Canvas,dlt1,BTNOUTPUTS,BTNOUTPUTS.CLBTNSEL,false);
     src:=STRTOINT(BTNOUTPUTS.BTNNames1[dlt1-1]);
     SendMessage(INHANDLE,WM_MYCOMMAND2,Integer(src),Integer(dlt1));
     fmMTXInput.Show;
     Timer1.Enabled:=true;
  end else if dlt2<>-1 then begin;
     MTXButtonDraw(Image1.Canvas,dlt2,BTNOUTPUTS,BTNOUTPUTS.CLFBTN,true);
     if BTNOUTPUTS.FBTNNames1[dlt2-1]='Close' then fmMTX.Close;
  end;
end;

end.
