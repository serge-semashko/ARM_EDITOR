unit UfrProtocols;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  utimeline, Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend;

type
  TVendors = class
    Str1 : string;
    rt1 : trect;
    TypeDevice : string;
    rttd : trect;
    Str2 : string;
    rt2 : trect;
    Vendor : string;
    rtv : trect;
    Str3 : string;
    rt3 : trect;
    Device : string;
    rtd : trect;
    Str4 : string;
    rt4 : trect;
    Protocol : string;
    rtp : trect;
    function GetString : string;
    procedure SetString(stri : string);
    procedure Draw(cv : tcanvas; hghtrw : integer);
    function ClickMouse(cv : tcanvas; X, Y : integer) : integer;
    constructor create;
    destructor destroy;
  end;

  TPort422 = class
    rt0 : trect;
    rtcm : trect;
    ComPort : String;
    rt1 : trect;
    rtsp : trect;
    Speed : string;
    LSpeed : string;
    rt2 : trect;
    rtbt : trect;
    Bits : string;
    LBits : string;
    rt3 : trect;
    rtpr : trect;
    Parity : string;
    LParity : string;
    rt4 : trect;
    rtst : trect;
    Stop : string;
    LStop : string;
    rt5 : trect;
    rtfl : trect;
    Flow : string;
    LFlow : string;
    function GetString : string;
    procedure SetString(stri : string);
    procedure draw(dib : tfastdib; Top, HgRw : integer);
    function ClickMouse(cv : tcanvas; X, Y : integer) : integer;
    constructor create;
    destructor destroy;
  end;

  TPortIP = class
    rt1 : trect;
    rtip : trect;
    IPAdress : String;
    rt2 : trect;
    rtpr : trect;
    IPPort : String;
    rt3 : trect;
    rtlg : trect;
    Login : String;
    rt4 : trect;
    rtps : trect;
    Password : String;
    function GetString : string;
    procedure SetString(stri : string);
    procedure draw(dib : tfastdib; Top, HgRw : integer);
    function ClickMouse(cv : tcanvas; X, Y : integer) : integer;
    constructor create;
    destructor destroy;
  end;

  TMyPort = class
    exist422 : boolean;
    existip : boolean;
    select422 : boolean;
    rt422 : trect;
    rtip  : trect;
    rt1 : trect;
    rtdm : trect;
    devicemanager : string;
    port422 : Tport422;
    portip : tportip;
    function GetString : string;
    procedure SetString(stri : string);
    procedure draw(cv : tcanvas; HghtRw : Integer);
    function ClickMouse(cv : tcanvas; X, Y : integer) : integer;
    constructor create;
    destructor destroy;
  end;

  TOneStringTable = class
    Name  : string;
    rtnm  : trect;
    Text  : string;
    rttxt : trect;
    constructor create(SName, SText : string);
    destructor destroy;
  end;

  TProtocolData = class
    Title : string;
    rect : trect;
    Count : integer;
    List : array of TOneStringTable;
    //procedure Add(SName, SText)
    procedure clear;
    constructor  create;
    destructor destroy;
  end;

  TFrProtocols = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    imgButtons: TImage;
    ComboBox1: TComboBox;
    ComboBox3: TComboBox;
    imgAddParam: TImage;
    ComboBox4: TComboBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    imgDevice: TImage;
    imgPorts: TImage;
    GroupBox3: TGroupBox;
    imgMainParam: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgDeviceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboBox1Change(Sender: TObject);
    procedure imgButtonsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgButtonsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgPortsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgPortsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgMainParamMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgAddParamMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgDeviceMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ComboBox4Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrProtocols: TFrProtocols;
  Vendors : TVendors;
  indxven : integer = -1;
  MyPort  : TMyPort;
  indxport : integer = -1;

  STRVendors : string = '';

procedure SetProtocol(OPTTimeline : TTimelineOptions);
procedure SelectVendors(TpTL,TpDv,Vnd,Dev,Prt : string);

implementation
uses umyfiles, ucommon, StrUtils, uinitforms, uimgbuttons;

{$R *.dfm}

procedure GetLisParam(SrcStr : string; lst : tstrings);
var ssrc, sstr, stmp : string;
    pss, pse : integer;
begin
  lst.Clear;
  pss:=1;
  pse:=posex('|',SrcStr,pss);
  while pse<>0 do begin
    stmp := copy(SrcStr,pss,pse-pss);
    stmp := StringReplace(stmp,'|','',[rfReplaceAll, rfIgnoreCase]);
    if trim(stmp)<>'' then lst.Add(stmp);
    pss:=pse+1;
    pse:=posex('|',SrcStr,pss);
  end;
  stmp := copy(SrcStr,pss,length(SrcStr));
  stmp := StringReplace(stmp,'|','',[rfReplaceAll, rfIgnoreCase]);
  if trim(stmp)<>'' then lst.Add(stmp);
end;

function ReadListProtocols : widestring;
var Stream : TFileStream;
    FileName : string;
    i, cnt: integer;
    ch : widechar;
    ss : widestring;
    buff : tstrings;
begin
  result:='';
  try
  buff := TStringList.Create;
  buff.Clear;
  try
  result := '';
  FileName:=extractfilepath(application.ExeName) + 'AListProtocols.txt';
  if not FileExists(FileName) then exit;
  WriteLog('PROTOCOLS', 'ReadListProtocols ' + FileName);
    buff.LoadFromFile(FileName);
    for i:=0 to buff.Count-1 do result:=result + trim(buff.Strings[i]);
  finally
    buff.Free;
    WriteLog('PROTOCOLS', 'ReadListProtocols Finish');
  end;
  except
    buff.Free;
    WriteLog('PROTOCOLS', 'ReadListProtocols Error');
  end;
end;

procedure SetProtocol(OPTTimeline : TTimelineOptions);
var sprotocols : string;
    lst : tstrings;
begin
  if Vendors=nil then Vendors := TVendors.create;
  if MyPort=nil then MyPort := TMyPort.create;

  //sprotocols :=  ReadListProtocols;
  //sprotocols := GetProtocolsStr(sprotocols, 'TLDevices');
  //
  //FrProtocols.ComboBox1.Clear;
  //GetProtocolsList(sprotocols, 'TypeDevices=',FrProtocols.ComboBox1.Items);
  //if FrProtocols.ComboBox1.Items.Count>0
  //  then Vendors.TypeDevice:=FrProtocols.ComboBox1.Items.Strings[0];
  //FrProtocols.ComboBox1.Clear;
  //GetProtocolsList(sprotocols, 'Firms=',FrProtocols.ComboBox1.Items);
  //if FrProtocols.ComboBox1.Items.Count>0
  //  then Vendors.Vendor:=FrProtocols.ComboBox1.Items.Strings[0];
  //sprotocols := GetProtocolsStr(sprotocols, 'Firms='+trim(Vendors.Vendor));
  //FrProtocols.ComboBox1.Clear;
  //GetProtocolsList(sprotocols, 'Protocol=',FrProtocols.ComboBox1.Items);
  //if FrProtocols.ComboBox1.Items.Count>0
  //  then Vendors.Protocol:=FrProtocols.ComboBox1.Items.Strings[0];
  FrProtocols.ComboBox1.Visible:=false;
  STRVendors := OPTTimeline.Protocol;
  Vendors.SetString(OPTTimeline.Protocol);

  Vendors.Draw(FrProtocols.imgDevice.Canvas,FrProtocols.ComboBox1.Height);
  FrProtocols.imgDevice.Repaint;

  MyPort.SetString(OPTTimeline.Protocol);
  MyPort.draw(FrProtocols.imgPorts.Canvas,FrProtocols.ComboBox4.Height);
  FrProtocols.imgPorts.Repaint;

  FrProtocols.ShowModal;
  if FrProtocols.ModalResult=mrOk then begin
    OPTTimeline.Protocol:=STRVendors;
    if Vendors<>nil then begin
      Vendors.FreeInstance;
      Vendors:=nil;
    end;
    if MyPort<>nil then begin
      MyPort.FreeInstance;
      MyPort:=nil;
    end;
  end;
end;

procedure initrect(rt : trect);
begin
  rt.Left:=0;
  rt.Right:=0;
  rt.Top:=0;
  rt.Bottom:=0;
end;

constructor TMyPort.create;
begin
  exist422 :=true;
  existip := true;
  select422 := true;
  initrect(rt422);
  initrect(rtip);
  initrect(rt1);
  initrect(rtdm);
  devicemanager := '';
  port422 := Tport422.create;
  portip := tportip.create;
end;

destructor TMyPort.destroy;
begin
  freemem(@exist422);
  freemem(@existip);
  freemem(@select422);
  freemem(@rt422);
  freemem(@rtip);
  freemem(@rt1);
  freemem(@rtdm);
  freemem(@devicemanager);
  freemem(@port422);
  freemem(@portip);
end;

function TMyPort.GetString : string;
begin
  result:='<Ports>';
  if exist422 then result := result + port422.GetString;
  if existip then result := result + portip.GetString;
  result:= result +'</Ports>'
end;

procedure TMyPort.SetString(stri : string);
var sports : string;
begin
  sports  := GetProtocolsStr(stri, 'Port422');
  //sports := StringReplace(sports,'<Port422>','',[rfReplaceAll, rfIgnoreCase]);
  //sports := StringReplace(sports,'</Port422>','',[rfReplaceAll, rfIgnoreCase]);

  if trim(sports)<>'' then begin
    port422.SetString(sports);
    exist422:=true;
  end else begin
    exist422:=false;
  end;

  sports  := GetProtocolsStr(stri, 'PortIP');
  //sports := StringReplace(sports,'<PortIP>','',[rfReplaceAll, rfIgnoreCase]);
  //sports := StringReplace(sports,'</PortIP>','',[rfReplaceAll, rfIgnoreCase]);

  if trim(sports)<>'' then begin
    portip.SetString(sports);
    existip:=true;
  end else begin
    existip:=false;
  end;

  if (not exist422) and existip then select422:=false
  else if (not existip) and exist422 then select422:=true;
end;

procedure TMyPort.draw(cv : tcanvas; HghtRw : Integer);
var tmp : tfastdib;
    i, wdth, hght, ps, top : integer;
    clr : tcolor;
    intclr : longint;
    rt : trect;
begin
   tmp := tfastdib.Create;
   try
     wdth := cv.ClipRect.Right-cv.ClipRect.Left;
     hght := cv.ClipRect.Bottom-cv.ClipRect.Top;
     ps := (wdth-10) div 2;
     tmp.SetSize(wdth, hght, 32);
     tmp.Clear(TColorToTfcolor(FormsColor));
     tmp.SetBrush(bs_solid,0,colortorgb(FormsColor));
     tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
     tmp.SetTransparent(true);
     tmp.SetPen(ps_Solid,1,ColorToRGB(FormsFontColor));
     tmp.SetTextColor(ColorToRGB(FormsFontColor));
     tmp.SetFont(FormsFontName, MTFontSize);

     top := 5;
     ps := (wdth - 10) div 2;

     if exist422 and existip then begin
       rt422.Left:=5;
       rt422.Right:=ps-5;
       rt422.Top:=top;
       rt422.Bottom:=rt422.Top+HghtRw;
       rtip.Left:=ps+5;
       rtip.Right:=wdth-5;
       rtip.Top:=top;
       rtip.Bottom:=rt422.Top+HghtRw;
       tmp.Rectangle(rt422.Left, rt422.Top+4, rt422.Left+HghtRw-8,rt422.Bottom-4);
       tmp.Rectangle(rtip.Left, rtip.Top+4, rtip.Left+HghtRw-8,rtip.Bottom-4);
       if select422 then begin
         tmp.DrawText('X',Rect(rt422.Left, rt422.Top+4, rt422.Left+HghtRw-8,rt422.Bottom-4)
                      ,DT_CENTER or DT_SINGLELINE);
         tmp.DrawText('  ',Rect(rtip.Left, rtip.Top+4, rtip.Left+HghtRw-8,rtip.Bottom-4)
                      ,DT_CENTER or DT_SINGLELINE);
       end else begin
         tmp.DrawText('  ',Rect(rt422.Left, rt422.Top+4, rt422.Left+HghtRw-8,rt422.Bottom-4)
                      ,DT_CENTER or DT_SINGLELINE);
         tmp.DrawText('X',Rect(rtip.Left, rtip.Top+4, rtip.Left+HghtRw-8,rtip.Bottom-4)
                      ,DT_CENTER or DT_SINGLELINE);
       end;
       //tmp.Rectangle(rt422.Left, rt422.Top+4, rt422.Left+HghtRw-8,rt422.Bottom-4);
       tmp.DrawText('COM Порт',Rect(rt422.Left + hghtrw -5, rt422.Top, rt422.Right, rt422.Bottom)
                    ,DT_VCENTER or DT_SINGLELINE);

       //tmp.Rectangle(rtip.Left, rtip.Top+4, rtip.Left+HghtRw-8,rtip.Bottom-4);
       tmp.DrawText('IP Адрес',Rect(rtip.Left + hghtrw -5, rtip.Top, rtip.Right, rtip.Bottom)
                    ,DT_VCENTER or DT_SINGLELINE);

       rt1.Left:=5;
       rt1.Right:=ps-10;
       rt1.Top:=top+hghtrw + 5;
       rt1.Bottom:=rt1.Top+hghtrw;
       rtdm.Left:=ps-5;
       rtdm.Right:=wdth-5;
       rtdm.Top:=rt1.Top;
       rtdm.Bottom:=rt1.Bottom;
       tmp.DrawText('Модуль упр.:',rt1,DT_VCENTER or DT_SINGLELINE);
       tmp.DrawText(devicemanager,rtdm,DT_VCENTER or DT_SINGLELINE);
       if select422
         then port422.draw(tmp,rt1.Bottom,hghtrw)
         else portip.draw(tmp,rt1.Bottom,hghtrw);
     end else if (not exist422) and existip then begin
       top := top + hghtrw;
       rt1.Left:=5;
       rt1.Right:=ps-10;
       rt1.Top:=top + 5;
       rt1.Bottom:=rt1.Top+hghtrw;
       rtdm.Left:=ps-5;
       rtdm.Right:=wdth-5;
       rtdm.Top:=rt1.Top;
       rtdm.Bottom:=rt1.Bottom;
       tmp.DrawText('Модуль упр.:',rt1,DT_VCENTER or DT_SINGLELINE);
       tmp.DrawText(devicemanager,rtdm,DT_VCENTER or DT_SINGLELINE);
       portip.draw(tmp,rt1.Bottom,hghtrw);
     end else if (not existip) and exist422 then begin
       top := top + hghtrw;
       rt1.Left:=5;
       rt1.Right:=ps-10;
       rt1.Top:=top;//+hghtrw + 5;
       rt1.Bottom:=rt1.Top+hghtrw;
       rtdm.Left:=ps-5;
       rtdm.Right:=wdth-5;
       rtdm.Top:=rt1.Top;
       rtdm.Bottom:=rt1.Bottom;
       tmp.DrawText('Модуль упр.:',rt1,DT_VCENTER or DT_SINGLELINE);
       tmp.DrawText(devicemanager,rtdm,DT_VCENTER or DT_SINGLELINE);
       port422.draw(tmp,rt1.Bottom,hghtrw);
     end else if (not exist422) and (not existip) then begin
       tmp.SetTextColor(colortorgb(smoothcolor(FormsFontColor,32)));
       top := top + hghtrw;
       rt1.Left:=5;
       rt1.Right:=ps-10;
       rt1.Top:=top;//+hghtrw + 5;
       rt1.Bottom:=rt1.Top+hghtrw;
       rtdm.Left:=ps-5;
       rtdm.Right:=wdth-5;
       rtdm.Top:=rt1.Top;
       rtdm.Bottom:=rt1.Bottom;
       tmp.DrawText('Модуль упр.:',rt1,DT_VCENTER or DT_SINGLELINE);
       tmp.DrawText(devicemanager,rtdm,DT_VCENTER or DT_SINGLELINE);
       if select422
         then port422.draw(tmp,rt1.Bottom,hghtrw)
         else portip.draw(tmp,rt1.Bottom,hghtrw);
     end;

     tmp.SetTransparent(false);
     tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
     cv.Refresh;
   finally
     tmp.Free;
     tmp:=nil;
   end
end;

function TMyPort.ClickMouse(cv : tcanvas; X, Y : integer) : integer;
begin
  result:=-1;
  if exist422 and existip then begin
    if (X>rt422.Left) and (X<rt422.Right) and (Y>rt422.Top) and (Y<rt422.Bottom) then begin
      result:=0;
      exit
    end;
    if (X>rtip.Left) and (X<rtip.Right) and (Y>rtip.Top) and (Y<rtip.Bottom) then begin
      result:=1;
      exit
    end;
  end;
  if (X>rtdm.Left) and (X<rtdm.Right) and (Y>rtdm.Top) and (Y<rtdm.Bottom) then begin
    result:=2;
    exit
  end;
  if select422 then result:=port422.ClickMouse(cv,X,Y) else result:=portip.ClickMouse(cv,X,Y);
end;

constructor TportIP.create;
begin
  initrect(rt1);
  initrect(rtip);
  IPAdress:='';
  initrect(rt2);
  initrect(rtpr);
  IPPort:='';
  initrect(rt3);
  initrect(rtlg);
  Login:='';
  initrect(rt4);
  initrect(rtps);
  Password:='';
end;

destructor TportIP.destroy;
begin
  freemem(@rt1);
  freemem(@rtip);
  freemem(@IPAdress);
  freemem(@rt2);
  freemem(@rtpr);
  freemem(@IPPort);
  freemem(@rt3);
  freemem(@rtlg);
  freemem(@Login);
  freemem(@rt4);
  freemem(@rtps);
  freemem(@Password);
end;

function TportIP.GetString : string;
begin
  result := '<PortIP><IPAdress='+IPAdress+'><IPPort='+IPPort+'><Login='+Login+
            '><Password='+Password+'></PortIP>';
end;

procedure TportIP.SetString(stri : string);
var sport : string;
begin
  sport  := GetProtocolsStr(stri, 'PortIP');
  IPAdress  := GetProtocolsParam(sport, 'IPAdress');
  IPPort   := GetProtocolsParam(sport, 'IPPort');
  Login := GetProtocolsParam(sport, 'Login');
  Password   := GetProtocolsParam(sport, 'Password');
end;

procedure TportIP.draw(dib : tfastdib; Top, HgRw : integer);
var ps : integer;
begin
  ps := (dib.Width-10) div 2;
  rt1.Left:=5;
  rt1.Right:=ps-10;
  rt1.Top:=top;
  rt1.Bottom:=rt1.Top+HgRw;
  rtip.Left := ps-5;
  rtip.Right := dib.Width-5;
  rtip.Top := rt1.Top;
  rtip.Bottom := rt1.Bottom;
  dib.DrawText('IP Адрес:',rt1,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(IPAdress,rtip,DT_VCENTER or DT_SINGLELINE);
  rt2.Left:=5;
  rt2.Right:=ps-10;
  rt2.Top:=rt1.Bottom;
  rt2.Bottom:=rt2.Top+HgRw;
  rtpr.Left := ps-5;
  rtpr.Right := dib.Width-5;
  rtpr.Top := rt2.Top;
  rtpr.Bottom := rt2.Bottom;
  dib.DrawText('Порт:',rt2,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(IPPort,rtpr,DT_VCENTER or DT_SINGLELINE);
  rt3.Left:=5;
  rt3.Right:=ps-10;
  rt3.Top:=rt2.Bottom;
  rt3.Bottom:=rt3.Top+HgRw;
  rtlg.Left := ps-5;
  rtlg.Right := dib.Width-5;
  rtlg.Top := rt3.Top;
  rtlg.Bottom := rt3.Bottom;
  dib.DrawText('Логин:',rt3,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Login,rtlg,DT_VCENTER or DT_SINGLELINE);
  rt4.Left:=5;
  rt4.Right:=ps-10;
  rt4.Top:=rt3.Bottom;
  rt4.Bottom:=rt4.Top+HgRw;
  rtps.Left := ps-5;
  rtps.Right := dib.Width-5;
  rtps.Top := rt4.Top;
  rtps.Bottom := rt4.Bottom;
  dib.DrawText('Пароль:',rt4,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Password,rtps,DT_VCENTER or DT_SINGLELINE);
end;

function TPortIP.ClickMouse(cv : tcanvas; X, Y : integer) : integer;
begin
  result := -1;
  if (X>rtip.Left) and (X<rtip.Right) and (Y>rtip.Top) and (Y<rtip.Bottom) then begin
    result:=20;
    exit
  end;
  if (X>rtpr.Left) and (X<rtpr.Right) and (Y>rtpr.Top) and (Y<rtpr.Bottom) then begin
    result:=21;
    exit
  end;
  if (X>rtlg.Left) and (X<rtlg.Right) and (Y>rtlg.Top) and (Y<rtlg.Bottom) then begin
    result:=22;
    exit
  end;
  if (X>rtps.Left) and (X<rtps.Right) and (Y>rtps.Top) and (Y<rtps.Bottom) then begin
    result:=23;
    exit
  end;
end;

constructor TPort422.create;
begin
  initrect(rt1);
  initrect(rtsp);
  Speed := '';
  LSpeed := '1200|1800|2400|4800|7200|9600|14400|19200|38400|57600|115200';
  initrect(rt2);
  initrect(rtbt);
  Bits := '';
  LBits := '4|5|6|7|8';
  initrect(rt3);
  initrect(rtpr);
  Parity :='';
  LParity := 'чет|нечет|нет|маркер|пробел';
  initrect(rt4);
  initrect(rtst);
  Stop := '';
  LStop := '1|1,5|2';
  initrect(rt5);
  initrect(rtfl);
  Flow := '';
  LFlow := 'XOn/XOff|Аппаратный|Нет';
end;

destructor TPort422.destroy;
begin
  FreeMem(@rt1);
  FreeMem(@rtsp);
  FreeMem(@Speed);
  FreeMem(@LSpeed);
  FreeMem(@rt2);
  FreeMem(@rtbt);
  FreeMem(@Bits);
  FreeMem(@LBits);
  FreeMem(@rt3);
  FreeMem(@rtpr);
  FreeMem(@Parity);
  FreeMem(@LParity);
  FreeMem(@rt4);
  FreeMem(@rtst);
  FreeMem(@Stop);
  FreeMem(@LStop);
  FreeMem(@rt5);
  FreeMem(@rtfl);
  FreeMem(@Flow);
  FreeMem(@LFlow);
end;

procedure TPort422.draw(dib : tfastdib; Top, HgRw : integer);
var ps : integer;
begin
  ps := (dib.Width-10) div 2;
  rt0.Left:=5;
  rt0.Right:=ps-10;
  rt0.Top:=top;
  rt0.Bottom:=rt0.Top+HgRw;
  rtcm.Left := ps-5;
  rtcm.Right := dib.Width-5;
  rtcm.Top := rt0.Top;
  rtcm.Bottom := rt0.Bottom;
  dib.DrawText('COM Порт:',rt0,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(ComPort,rtcm,DT_VCENTER or DT_SINGLELINE);

  rt1.Left:=5;
  rt1.Right:=ps-10;
  rt1.Top:=rt0.Bottom;
  rt1.Bottom:=rt1.Top+HgRw;
  rtsp.Left := ps-5;
  rtsp.Right := dib.Width-5;
  rtsp.Top := rt1.Top;
  rtsp.Bottom := rt1.Bottom;
  dib.DrawText('Скорость:',rt1,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Speed,rtsp,DT_VCENTER or DT_SINGLELINE);
  rt2.Left:=5;
  rt2.Right:=ps-10;
  rt2.Top:=rt1.Bottom;
  rt2.Bottom:=rt2.Top+HgRw;
  rtbt.Left := ps-5;
  rtbt.Right := dib.Width-5;
  rtbt.Top := rt2.Top;
  rtbt.Bottom := rt2.Bottom;
  dib.DrawText('Кол-во бит:',rt2,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Bits,rtbt,DT_VCENTER or DT_SINGLELINE);
  rt3.Left:=5;
  rt3.Right:=ps-10;
  rt3.Top:=rt2.Bottom;
  rt3.Bottom:=rt3.Top+HgRw;
  rtpr.Left := ps-5;
  rtpr.Right := dib.Width-5;
  rtpr.Top := rt3.Top;
  rtpr.Bottom := rt3.Bottom;
  dib.DrawText('Четность:',rt3,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Parity,rtpr,DT_VCENTER or DT_SINGLELINE);
  rt4.Left:=5;
  rt4.Right:=ps-10;
  rt4.Top:=rt3.Bottom;
  rt4.Bottom:=rt4.Top+HgRw;
  rtst.Left := ps-5;
  rtst.Right := dib.Width-5;
  rtst.Top := rt4.Top;
  rtst.Bottom := rt4.Bottom;
  dib.DrawText('Стоп бит:',rt4,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Stop,rtst,DT_VCENTER or DT_SINGLELINE);
  rt5.Left:=5;
  rt5.Right:=ps-10;
  rt5.Top:=rt4.Bottom;
  rt5.Bottom:=rt5.Top+HgRw;
  rtfl.Left := ps-5;
  rtfl.Right := dib.Width-5;
  rtfl.Top := rt5.Top;
  rtfl.Bottom := rt5.Bottom;
  dib.DrawText('Упр. потоком:',rt5,DT_VCENTER or DT_SINGLELINE);
  dib.DrawText(Flow,rtfl,DT_VCENTER or DT_SINGLELINE);
end;

function tport422.ClickMouse(cv : tcanvas; X, Y : integer) : integer;
begin
  result := -1;
  if (X>rtsp.Left) and (X<rtsp.Right) and (Y>rtsp.Top) and (Y<rtsp.Bottom) then begin
    result:=10;
    exit
  end;
  if (X>rtbt.Left) and (X<rtbt.Right) and (Y>rtbt.Top) and (Y<rtbt.Bottom) then begin
    result:=11;
    exit
  end;
  if (X>rtpr.Left) and (X<rtpr.Right) and (Y>rtpr.Top) and (Y<rtpr.Bottom) then begin
    result:=12;
    exit
  end;
  if (X>rtst.Left) and (X<rtst.Right) and (Y>rtst.Top) and (Y<rtst.Bottom) then begin
    result:=13;
    exit
  end;
  if (X>rtfl.Left) and (X<rtfl.Right) and (Y>rtfl.Top) and (Y<rtfl.Bottom) then begin
    result:=14;
    exit
  end;
end;

function tport422.GetString : string;
begin
  result := '<Port422><Speed='+Speed+'><Bits='+Bits+'><Parity='+Parity+
            '><Stop='+Stop+'><Flow='+Flow+'></Port422>';
end;

procedure tport422.SetString(stri : string);
var sport : string;
begin
  sport  := GetProtocolsStr(stri, 'Port422');
  Speed  := GetProtocolsParam(sport, 'Speed');
  Bits   := GetProtocolsParam(sport, 'Bits');
  Parity := GetProtocolsParam(sport, 'Parity');
  Stop   := GetProtocolsParam(sport, 'Stop');
  Flow   := GetProtocolsParam(sport, 'Flow');
end;

constructor tvendors.create;
begin
  Str1 := 'Тип оборудования:';
  rt1.Left := 0;
  rt1.Top := 0;
  rt1.Right := 0;
  rt1.Bottom := 0;
  TypeDevice :='';
  rttd.Left := 0;
  rttd.Top := 0;
  rttd.Right := 0;
  rttd.Bottom := 0;
  Str2 := 'Производитель:';
  rt2.Left := 0;
  rt2.Top := 0;
  rt2.Right := 0;
  rt2.Bottom := 0;
  Vendor := '';
  rtv.Left := 0;
  rtv.Top := 0;
  rtv.Right := 0;
  rtv.Bottom := 0;
  Str3 := 'Устройство:';
  rt3.Left := 0;
  rt3.Top := 0;
  rt3.Right := 0;
  rt3.Bottom := 0;
  Device := '';
  rtd.Left := 0;
  rtd.Top := 0;
  rtd.Right := 0;
  rtd.Bottom := 0;
  Str4 := 'Протокол:';
  rt4.Left := 0;
  rt4.Top := 0;
  rt4.Right := 0;
  rt4.Bottom := 0;
  Protocol := '';
  rtp.Left := 0;
  rtp.Top := 0;
  rtp.Right := 0;
  rtp.Bottom := 0;
end;

destructor tvendors.destroy;
begin
  freemem(@Str1);
  freemem(@rt1);
  freemem(@TypeDevice);
  freemem(@rttd);
  freemem(@Str2);
  freemem(@rt2);
  freemem(@Vendor);
  freemem(@rtv);
  freemem(@Str3);
  freemem(@rt3);
  freemem(@Device);
  freemem(@rtd);
  freemem(@Str4);
  freemem(@rt4);
  freemem(@Protocol);
  freemem(@rtp);
end;

procedure tvendors.Draw(cv : tcanvas; hghtrw : integer);
var tmp : tfastdib;
    i, wdth, hght, ps : integer;
    clr : tcolor;
    intclr : longint;
    rt : trect;
begin
   tmp := tfastdib.Create;
   try
     wdth := cv.ClipRect.Right-cv.ClipRect.Left;
     hght := cv.ClipRect.Bottom-cv.ClipRect.Top;
     ps := (wdth-10) div 2;
     tmp.SetSize(wdth, hght, 32);
     tmp.Clear(TColorToTfcolor(FormsColor));
     tmp.SetBrush(bs_solid,0,colortorgb(FormsColor));
     tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
     tmp.SetTransparent(true);
     tmp.SetPen(ps_Solid,1,ColorToRGB(FormsFontColor));
     tmp.SetTextColor(ColorToRGB(FormsFontColor));
     tmp.SetFont(FormsFontName, MTFontSize);
     rt1.Left:=5;
     rt1.Top:=5;
     rt1.Right:=rt1.Left+ps;
     rt1.Bottom:=rt1.Top+hghtrw;
     rttd.Left:=rt1.Right+5;
     rttd.Top:=rt1.Top;
     rttd.Right:=wdth-5;
     rttd.Bottom:=rt1.Bottom;
     tmp.DrawText(Str1,rt1,DT_VCENTER or DT_SINGLELINE);
     tmp.DrawText(TypeDevice,rttd,DT_VCENTER or DT_SINGLELINE);

     rt2.Left:=rt1.Left;
     rt2.Top:=rt1.Bottom;
     rt2.Right:=rt1.Left+ps;
     rt2.Bottom:=rt2.Top+hghtrw;
     rtv.Left:=rt1.Right+5;
     rtv.Top:=rt2.Top;
     rtv.Right:=wdth-5;
     rtv.Bottom:=rt2.Bottom;
     tmp.DrawText(Str2,rt2,DT_VCENTER or DT_SINGLELINE);
     tmp.DrawText(Vendor,rtv,DT_VCENTER or DT_SINGLELINE);

     rt3.Left:=rt1.Left;
     rt3.Top:=rt2.Bottom;
     rt3.Right:=rt1.Left+ps;
     rt3.Bottom:=rt3.Top+hghtrw;
     rtd.Left:=rt1.Right+5;
     rtd.Top:=rt3.Top;
     rtd.Right:=wdth-5;
     rtd.Bottom:=rt3.Bottom;
     tmp.DrawText(Str3,rt3,DT_VCENTER or DT_SINGLELINE);
     tmp.DrawText(Device,rtd,DT_VCENTER or DT_SINGLELINE);

     rt4.Left:=rt1.Left;
     rt4.Top:=rt3.Bottom;
     rt4.Right:=rt1.Left+ps;
     rt4.Bottom:=rt4.Top+hghtrw;
     rtp.Left:=rt1.Right+5;
     rtp.Top:=rt4.Top;
     rtp.Right:=wdth-5;
     rtp.Bottom:=rt4.Bottom;
     tmp.DrawText(Str4,rt4,DT_VCENTER or DT_SINGLELINE);
     tmp.DrawText(Protocol,rtp,DT_VCENTER or DT_SINGLELINE);
     tmp.SetTransparent(false);
     tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
     cv.Refresh;
   finally
     tmp.Free;
     tmp:=nil;
   end
end;

function tvendors.ClickMouse(cv : tcanvas; X, Y : integer) : integer;
begin
  result:=-1;
  if (X>rttd.Left) and (X<rttd.Right) and (Y>rttd.Top) and (Y<rttd.Bottom) then begin
    result := 0;
    exit;
  end;
  if (X>rtv.Left) and (X<rtv.Right) and (Y>rtv.Top) and (Y<rtv.Bottom) then begin
    result := 1;
    exit;
  end;
  if (X>rtd.Left) and (X<rtd.Right) and (Y>rtd.Top) and (Y<rtd.Bottom) then begin
    result := 2;
    exit;
  end;
  if (X>rtp.Left) and (X<rtp.Right) and (Y>rtp.Top) and (Y<rtp.Bottom) then begin
    result := 3;
    exit;
  end;
end;

function tvendors.GetString : string;
begin
  result := '<Vendors><TypeDevice='+TypeDevice+'><Vendor='+Vendor+'><Device='
            +Device+'><Protocol='+Protocol+'></Vendors>';
end;

procedure tvendors.SetString(stri : string);
var svens : string;
begin
  svens := GetProtocolsStr(stri, 'Vendors');
  TypeDevice := GetProtocolsParam(svens, 'TypeDevice');
  Vendor := GetProtocolsParam(svens, 'Vendor');
  Device := GetProtocolsParam(svens, 'Device');
  Protocol := GetProtocolsParam(svens, 'Protocol');
end;

constructor TOneStringTable.create(SName, SText : string);
begin
  Name  := SName;
  rtnm.Left := 0;
  rtnm.Top := 0;
  rtnm.Right := 0;
  rtnm.Bottom := 0;
  Text  := SText;
  rttxt.Left := 0;
  rttxt.Top := 0;
  rttxt.Right := 0;
  rttxt.Bottom := 0;
end;

destructor TOneStringTable.destroy;
begin
  freemem(@Name);
  freemem(@rtnm);
  freemem(@Text);
  freemem(@rttxt);
end;

constructor TProtocolData.create;
begin
  Title :='';
  rect.Left :=0;
  rect.Top :=0;
  rect.Right :=0;
  rect.Bottom :=0;
  Count := 0;
end;

procedure TProtocolData.clear;
var i : integer;
begin
  for i:=Count-1 downto 0 do begin
    List[Count-1].FreeInstance;
    Count:=Count - 1;
    Setlength(List, Count);
  end;
  Count := 0;
end;

destructor TProtocolData.destroy;
begin
  freemem(@Title);
  freemem(@rect);
  clear;
  freemem(@Count);
  freemem(@List);
end;

procedure TFrProtocols.ComboBox1Change(Sender: TObject);
begin
      case indxven of
  0 : if ComboBox1.ItemIndex=-1
        then Vendors.TypeDevice:=''
        else Vendors.TypeDevice:=ComboBox1.Items.Strings[ComboBox1.ItemIndex];

  1 : if ComboBox1.ItemIndex=-1
        then Vendors.Vendor:=''
        else Vendors.Vendor:=ComboBox1.Items.Strings[ComboBox1.ItemIndex];
  2 : if ComboBox1.ItemIndex=-1
        then Vendors.Device:=''
        else Vendors.Device:=ComboBox1.Items.Strings[ComboBox1.ItemIndex];
  3 : if ComboBox1.ItemIndex=-1
        then Vendors.Protocol:=''
        else Vendors.Protocol:=ComboBox1.Items.Strings[ComboBox1.ItemIndex];
      end;
  SelectVendors('TLDevices',Vendors.TypeDevice,Vendors.Vendor,Vendors.Device,Vendors.Protocol);
  Vendors.Draw(imgDevice.Canvas,ComboBox1.Height);
  imgDevice.Repaint;
end;

procedure TFrProtocols.ComboBox4Change(Sender: TObject);
begin
     case indxport of
  2  : MyPort.devicemanager:=Combobox4.Items.Strings[Combobox4.ItemIndex];
  10 : MyPort.port422.Speed:=Combobox4.Items.Strings[Combobox4.ItemIndex];
  11 : MyPort.port422.Bits:=Combobox4.Items.Strings[Combobox4.ItemIndex];
  12 : MyPort.port422.Parity:=Combobox4.Items.Strings[Combobox4.ItemIndex];
  13 : MyPort.port422.Stop:=Combobox4.Items.Strings[Combobox4.ItemIndex];
  14 : MyPort.port422.Flow:=Combobox4.Items.Strings[Combobox4.ItemIndex];
     end;
  MyPort.draw(imgPorts.Canvas, ComboBox4.Height);
  imgPorts.Repaint;
end;

procedure TFrProtocols.Edit1Change(Sender: TObject);
var s : string;
begin
  s :=trim(Edit1.Text);
  if length(s)>15 then s:=copy(s,1,15);
  Edit1.Text:=s;
     case indxport of
  20 : MyPort.portip.IPAdress:=Edit1.Text;
  21 : MyPort.portip.IPPort:=Edit1.Text;
  22 : MyPort.portip.Login:=Edit1.Text;
  23 : MyPort.portip.Password:=Edit1.Text;
     end;
  MyPort.draw(imgPorts.Canvas, ComboBox4.Height);
  imgPorts.Repaint;
end;

procedure TFrProtocols.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (indxport=20) or (indxport=21)
    then if key=46 then key:=0;
end;

procedure TFrProtocols.Edit1KeyPress(Sender: TObject; var Key: Char);
  var s : string;
  i,p1,p2,p3 : integer;
begin
   case indxport of

20 : begin
       if not (key in ['0'..'9',#8]) then begin
         key:=#0;
         exit;
       end;
       s:=edit1.Text;
       p2:=edit1.SelStart;
          Case Key of
            #8  : begin
                    if edit1.SelLength=0 then begin
                      if (p2<>4) and (p2<>8) and (p2<>12) then begin
                         s[p2]:='0';
                         edit1.Text:=s;
                         key:=#0;
                         if p2>0 then edit1.SelStart:=p2-1;
                      end else begin
                         s[p2]:='.';
                         edit1.Text:=s;
                         key:=#0;
                         if p2>0 then edit1.SelStart:=p2-1;
                      end;
                    end else begin
                      for i:=p2+1 to p2+edit1.SelLength do begin
                        if (i<>4) and (i<>8) and (i<>12) then s[i]:='0';
                      end;
                      edit1.SelLength:=0;
                      edit1.Text:=s;
                      if (p2=3) or (p2=7) or (p2=12) then edit1.SelStart:=p2+1;
                      if p2>0 then key:=s[p2-1];
                    end;
                  end;
       '0'..'9' : begin
                    if (p2=3) or (p2=7) or (p2=11) then p2:=p2+1;
                    if (p2<>3) and (p2<>7) and (p2<>11) then begin
                      if p2<15 then p2:=p2+1 else p2:=16;
                   //     case p2 of
                   // 1 : if strtoint(Key)>2 then Key:='2';
                   // 2 : if s[1]='2' then if strtoint(Key)>3 then Key:='3';
                   // 4 : if strtoint(Key)>5 then Key:='5';
                   // 7 : if strtoint(Key)>5 then Key:='5';
                   // 10: if strtoint(Key)>2 then Key:='2';
                   // 11: if s[10]='2' then if strtoint(Key)>4 then Key:='4';
                   //     end;
                      s[p2]:=Key;
                      edit1.Text:=s;
                      key:=#0;
                      if p2<=15 then begin
                        if (p2=3) or (p2=7) or (p2=11) then edit1.SelStart:=p2+1 else edit1.SelStart:=p2;
                      end;
                    end;
                  end;
          End;
     end;
21 : begin
       if not (key in ['0'..'9',#8]) then begin
         key:=#0;
         exit;
       end;
     end;
   end;
end;

procedure TFrProtocols.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Vendors<>nil then begin
    Vendors.FreeInstance;
    Vendors:=nil;
  end;
  if MyPort<>nil then begin
      MyPort.FreeInstance;
      MyPort:=nil;
  end;
end;

procedure TFrProtocols.FormCreate(Sender: TObject);
begin
  InitFrProtocols;
end;

procedure TFrProtocols.imgAddParamMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 if combobox1.Visible then combobox1.Visible := false;
 if combobox4.Visible then combobox4.Visible := false;
 if Edit1.Visible then Edit1.Visible := false;
end;

procedure TFrProtocols.imgButtonsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnpnlpotocol.MouseMove(imgButtons.Canvas, X, Y);
end;

procedure TFrProtocols.imgButtonsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res : integer;
begin
  res := btnpnlpotocol.ClickButton(imgButtons.Canvas, X, Y);
    case res of
  0 : FrProtocols.ModalResult:=mrCancel;
  1 : begin
       STRVendors := Vendors.GetString + MyPort.GetString;
       FrProtocols.ModalResult:=mrOk;
      end;
    end;

end;

procedure SelectVendors(TpTL,TpDv,Vnd,Dev,Prt : string);
var sprotocols : string;
    lst : tstrings;
    indx : integer;
begin
  lst := tstringlist.Create;
  lst.Clear;
  try
  sprotocols :=  ReadListProtocols;
  sprotocols := GetProtocolsStr(sprotocols, TpTl);
  GetProtocolsList(sprotocols, 'TypeDevices=',lst);
  if trim(TpDv)='' then begin
    if lst.Count>0 then Vendors.TypeDevice:=lst.Strings[0]
    else begin
      Vendors.TypeDevice:='';
      Vendors.Vendor:='';
      Vendors.Device:='';
      Vendors.Protocol:='';
      exit;
    end;
  end else begin
    indx := lst.IndexOf(TpDv);
    if indx<>-1 then Vendors.TypeDevice:=lst.Strings[indx]
    else begin
      Vendors.TypeDevice:='';
      Vendors.Vendor:='';
      Vendors.Device:='';
      Vendors.Protocol:='';
      exit;
    end;
  end;

  sprotocols := GetProtocolsStr(sprotocols, 'TypeDevices='+trim(Vendors.TypeDevice));
  lst.Clear;
  GetProtocolsList(sprotocols, 'Firms=',lst);
  if trim(Vnd)='' then begin
    if lst.Count>0 then Vendors.Vendor:=lst.Strings[0]
    else begin
      Vendors.Vendor:='';
      Vendors.Device:='';
      Vendors.Protocol:='';
      exit;
    end;
  end else begin
    indx := lst.IndexOf(Vnd);
    if indx<>-1 then Vendors.Vendor:=lst.Strings[indx]
    else begin
      Vendors.Vendor:='';
      Vendors.Device:='';
      Vendors.Protocol:='';
      exit;
    end;
  end;

  sprotocols := GetProtocolsStr(sprotocols, 'Firms='+trim(Vendors.Vendor));
  lst.Clear;
  GetProtocolsList(sprotocols, 'Device=',lst);
  if trim(Dev)='' then begin
    if lst.Count>0 then Vendors.Device:=lst.Strings[0]
    else begin
      Vendors.Device:='';
    end;
  end else begin
    indx := lst.IndexOf(Dev);
    if indx<>-1 then Vendors.Device:=lst.Strings[indx]
    else if lst.Count>0 then Vendors.Device:=lst.Strings[0] else Vendors.Device:='';
  end;

  if Trim(Vendors.Device)<>''
    then sprotocols := GetProtocolsStr(sprotocols, 'Device='+trim(Vendors.Device));
  lst.Clear;
    GetProtocolsList(sprotocols, 'Protocol=',lst);
  if trim(Prt)='' then begin
    if lst.Count>0 then Vendors.Protocol:=lst.Strings[0]
    else Vendors.Protocol:='';
  end else begin
    indx := lst.IndexOf(Prt);
    if indx<>-1 then Vendors.Protocol:=lst.Strings[indx]
    else if lst.Count>0 then Vendors.Protocol:=lst.Strings[0] else Vendors.Protocol:='';
  end;

  if (Vendors.Protocol)<>'' then begin
    sprotocols := GetProtocolsStr(sprotocols, 'Protocol='+trim(Vendors.Protocol));
    if MyPort<>nil then MyPort.SetString(sprotocols);
    MyPort.draw(FrProtocols.imgPorts.Canvas,FrProtocols.ComboBox4.Height);
    FrProtocols.imgPorts.Repaint;
  end;

  finally
    lst.Free
  end;
end;



procedure TFrProtocols.imgDeviceMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if combobox4.Visible then combobox4.Visible := false;
  if combobox1.Visible then combobox1.Visible := false;
  if Edit1.Visible then Edit1.Visible := false;
end;

procedure TFrProtocols.imgDeviceMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res, indx : integer;
    sprotocols : string;
begin
  res := vendors.ClickMouse(imgDevice.Canvas, X, Y);
  if res<>-1 then begin
    sprotocols :=  ReadListProtocols;
    sprotocols := GetProtocolsStr(sprotocols, 'TLDevices');
     case indxven of
  0 : Vendors.TypeDevice:=FrProtocols.ComboBox1.Items.Strings[FrProtocols.ComboBox1.ItemIndex];
  1 : Vendors.Vendor:=FrProtocols.ComboBox1.Items.Strings[FrProtocols.ComboBox1.ItemIndex];
  2 : Vendors.Device:=FrProtocols.ComboBox1.Items.Strings[FrProtocols.ComboBox1.ItemIndex];
  3 : Vendors.Protocol:=FrProtocols.ComboBox1.Items.Strings[FrProtocols.ComboBox1.ItemIndex];
     end;
     //SelectVendors('TLDevices',Vendors.TypeDevice,Vendors.Vendor,Vendors.Device,Vendors.Protocol);
     case res of
  0  : begin

         FrProtocols.ComboBox1.Visible:=false;
         FrProtocols.ComboBox1.Left:=Vendors.rttd.Left;
         FrProtocols.ComboBox1.Top:=imgDevice.Top + Vendors.rttd.Top;
         FrProtocols.ComboBox1.Width:=Vendors.rttd.Right - Vendors.rttd.Left;
         FrProtocols.ComboBox1.Clear;
         GetProtocolsList(sprotocols, 'TypeDevices=',FrProtocols.ComboBox1.Items);
         indx := FrProtocols.ComboBox1.Items.IndexOf(Vendors.TypeDevice);
         if indx=-1
           then FrProtocols.ComboBox1.ItemIndex:=0
           else FrProtocols.ComboBox1.ItemIndex:=indx;
         FrProtocols.ComboBox1.Visible:=true;
         indxven:=0;
       end;
  1  : begin
         sprotocols := GetProtocolsStr(sprotocols, 'TypeDevices='+trim(Vendors.TypeDevice));
         FrProtocols.ComboBox1.Visible:=false;
         FrProtocols.ComboBox1.Left:=Vendors.rtv.Left;
         FrProtocols.ComboBox1.Top:=imgDevice.Top + Vendors.rtv.Top;
         FrProtocols.ComboBox1.Width:=Vendors.rtv.Right - Vendors.rtv.Left;
         FrProtocols.ComboBox1.Clear;
         GetProtocolsList(sprotocols, 'Firms=',FrProtocols.ComboBox1.Items);
         indx := FrProtocols.ComboBox1.Items.IndexOf(Vendors.Vendor);
         if indx=-1
           then FrProtocols.ComboBox1.ItemIndex:=0
           else FrProtocols.ComboBox1.ItemIndex:=indx;
         FrProtocols.ComboBox1.Visible:=true;
         indxven:=1;
       end;
  2  : begin
         sprotocols := GetProtocolsStr(sprotocols, 'Firms='+trim(Vendors.Vendor));
         FrProtocols.ComboBox1.Visible:=false;
         FrProtocols.ComboBox1.Left:=Vendors.rtd.Left;
         FrProtocols.ComboBox1.Top:=imgDevice.Top + Vendors.rtd.Top;
         FrProtocols.ComboBox1.Width:=Vendors.rtd.Right - Vendors.rtd.Left;
         FrProtocols.ComboBox1.Clear;
         GetProtocolsList(sprotocols, 'Device=',FrProtocols.ComboBox1.Items);
         indx := FrProtocols.ComboBox1.Items.IndexOf(Vendors.Protocol);
         if indx=-1
           then FrProtocols.ComboBox1.ItemIndex:=0
           else FrProtocols.ComboBox1.ItemIndex:=indx;
         FrProtocols.ComboBox1.Visible:=true;
         indxven:=2;
       end;
  3  : begin
         sprotocols := GetProtocolsStr(sprotocols, 'Firms='+trim(Vendors.Vendor));
         if trim(Vendors.Device)<>''
           then sprotocols := GetProtocolsStr(sprotocols, 'Device='+trim(Vendors.Device));
         FrProtocols.ComboBox1.Visible:=false;
         FrProtocols.ComboBox1.Left:=Vendors.rtp.Left;
         FrProtocols.ComboBox1.Top:=imgDevice.Top + Vendors.rtp.Top;
         FrProtocols.ComboBox1.Width:=Vendors.rtp.Right - Vendors.rtp.Left;
         FrProtocols.ComboBox1.Clear;
         GetProtocolsList(sprotocols, 'Protocol=',FrProtocols.ComboBox1.Items);
         indx := FrProtocols.ComboBox1.Items.IndexOf(Vendors.Protocol);
         if indx=-1
           then FrProtocols.ComboBox1.ItemIndex:=0
           else FrProtocols.ComboBox1.ItemIndex:=indx;
         FrProtocols.ComboBox1.Visible:=true;
         indxven:=3;
       end;
     end;
  end else begin
    FrProtocols.ComboBox1.Visible:=false;
    indxven:=-1;
  end;
  SelectVendors('TLDevices',Vendors.TypeDevice,Vendors.Vendor,Vendors.Device,Vendors.Protocol);
  Vendors.Draw(FrProtocols.imgDevice.Canvas,FrProtocols.ComboBox1.Height);
  FrProtocols.imgDevice.Repaint;
end;

procedure TFrProtocols.imgMainParamMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if combobox1.Visible then combobox1.Visible := false;
  if combobox4.Visible then combobox4.Visible := false;
  if Edit1.Visible then Edit1.Visible := false;
end;

procedure TFrProtocols.imgPortsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if combobox1.Visible then combobox1.Visible := false;
  if combobox4.Visible then combobox4.Visible := false;
  //if Edit1.Visible then Edit1.Visible := false;
end;

procedure TFrProtocols.imgPortsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res, indx : integer;
begin
  res := MyPort.ClickMouse(imgPorts.Canvas, X, Y);
     case res of
  0 :  begin
         indxport:=0;
         Edit1.Visible:=false;
         Combobox4.Visible:=false;
         MyPort.select422 := true;
       end;
  1 :  begin
         indxport:=1;
         Edit1.Visible:=false;
         Combobox4.Visible:=false;
         MyPort.select422 := false;
       end;
  2 :  begin
         Edit1.Visible:=false;
         Combobox4.Visible:=false;
         Combobox4.Left:=MyPort.rtdm.Left;
         Combobox4.Top:=imgPorts.Top + MyPort.rtdm.Top;
         Combobox4.Width:=MyPort.rtdm.Right - MyPort.rtdm.Left;
         indxport:=2;
         Combobox4.Items.Clear;
         Combobox4.Visible:=true;
       end;
  10 : begin
         Edit1.Visible:=false;
         Combobox4.Visible:=false;
         Combobox4.Left:=MyPort.port422.rtsp.Left;
         Combobox4.Top:=imgPorts.Top + MyPort.port422.rtsp.Top;
         Combobox4.Width:=MyPort.port422.rtsp.Right - MyPort.port422.rtsp.Left;
         indxport:=10;
         Combobox4.Items.Clear;
         GetLisParam(MyPort.port422.LSpeed, Combobox4.Items);
         indx := Combobox4.Items.IndexOf(MyPort.port422.Speed);
         if indx=-1 then Combobox4.ItemIndex:=0 else Combobox4.ItemIndex:=indx;
         MyPort.port422.Speed:=Combobox4.Items.Strings[Combobox4.ItemIndex];
         Combobox4.Visible:=true;
       end;
  11 : begin
         Edit1.Visible:=false;
         Combobox4.Visible:=false;
         Combobox4.Left:=MyPort.port422.rtbt.Left;
         Combobox4.Top:=imgPorts.Top + MyPort.port422.rtbt.Top;
         Combobox4.Width:=MyPort.port422.rtbt.Right - MyPort.port422.rtbt.Left;
         indxport:=11;
         Combobox4.Items.Clear;
         GetLisParam(MyPort.port422.LBits, Combobox4.Items);
         indx := Combobox4.Items.IndexOf(MyPort.port422.Bits);
         if indx=-1 then Combobox4.ItemIndex:=0 else Combobox4.ItemIndex:=indx;
         MyPort.port422.Bits:=Combobox4.Items.Strings[Combobox4.ItemIndex];
         Combobox4.Visible:=true;
       end;
  12 : begin
         Edit1.Visible:=false;
         Combobox4.Visible:=false;
         Combobox4.Left:=MyPort.port422.rtpr.Left;
         Combobox4.Top:=imgPorts.Top + MyPort.port422.rtpr.Top;
         Combobox4.Width:=MyPort.port422.rtpr.Right - MyPort.port422.rtpr.Left;
         indxport:=12;
         Combobox4.Items.Clear;
         GetLisParam(MyPort.port422.LParity, Combobox4.Items);
         indx := Combobox4.Items.IndexOf(MyPort.port422.Parity);
         if indx=-1 then Combobox4.ItemIndex:=0 else Combobox4.ItemIndex:=indx;
         MyPort.port422.Parity:=Combobox4.Items.Strings[Combobox4.ItemIndex];
         Combobox4.Visible:=true;
       end;
  13 : begin
         Edit1.Visible:=false;
         Combobox4.Visible:=false;
         Combobox4.Left:=MyPort.port422.rtst.Left;
         Combobox4.Top:=imgPorts.Top + MyPort.port422.rtst.Top;
         Combobox4.Width:=MyPort.port422.rtst.Right - MyPort.port422.rtst.Left;
         indxport:=13;
         Combobox4.Items.Clear;
         GetLisParam(MyPort.port422.LStop, Combobox4.Items);
         indx := Combobox4.Items.IndexOf(MyPort.port422.Stop);
         if indx=-1 then Combobox4.ItemIndex:=0 else Combobox4.ItemIndex:=indx;
         MyPort.port422.Stop:=Combobox4.Items.Strings[Combobox4.ItemIndex];
         Combobox4.Visible:=true;
       end;
  14 : begin
         Edit1.Visible:=false;
         Combobox4.Visible:=false;
         Combobox4.Left:=MyPort.port422.rtfl.Left;
         Combobox4.Top:=imgPorts.Top + MyPort.port422.rtfl.Top;
         Combobox4.Width:=MyPort.port422.rtfl.Right - MyPort.port422.rtfl.Left;
         indxport:=14;
         Combobox4.Items.Clear;
         GetLisParam(MyPort.port422.LFlow, Combobox4.Items);
         indx := Combobox4.Items.IndexOf(MyPort.port422.Flow);
         if indx=-1 then Combobox4.ItemIndex:=0 else Combobox4.ItemIndex:=indx;
         MyPort.port422.Flow:=Combobox4.Items.Strings[Combobox4.ItemIndex];
         Combobox4.Visible:=true;
       end;
  20 : begin
         Combobox4.Visible:=false;
         Edit1.Visible:=false;
         Edit1.Left:=MyPort.portip.rtip.Left;
         Edit1.Top:=imgPorts.Top + MyPort.portip.rtip.Top;
         Edit1.Width:=MyPort.portip.rtip.Right - MyPort.portip.rtip.Left;
         Edit1.Height:=MyPort.portip.rtip.Bottom - MyPort.portip.rtip.Top;
         indxport:=20;
         Edit1.Text:=MyPort.portip.IPAdress;
         Edit1.Visible:=true;
       end;
  21 : begin
         Combobox4.Visible:=false;
         Edit1.Visible:=false;
         Edit1.Left:=MyPort.portip.rtpr.Left;
         Edit1.Top:=imgPorts.Top + MyPort.portip.rtpr.Top;
         Edit1.Width:=MyPort.portip.rtpr.Right - MyPort.portip.rtpr.Left;
         Edit1.Height:=MyPort.portip.rtpr.Bottom - MyPort.portip.rtpr.Top;
         indxport:=21;
         Edit1.Text:=MyPort.portip.IPPort;
         Edit1.Visible:=true;
       end;
  22 : begin
         Combobox4.Visible:=false;
         Edit1.Visible:=false;
         Edit1.Left:=MyPort.portip.rtlg.Left;
         Edit1.Top:=imgPorts.Top + MyPort.portip.rtlg.Top;
         Edit1.Width:=MyPort.portip.rtlg.Right - MyPort.portip.rtlg.Left;
         Edit1.Height:=MyPort.portip.rtlg.Bottom - MyPort.portip.rtlg.Top;
         indxport:=22;
         Edit1.Text:=MyPort.portip.Login;
         Edit1.Visible:=true;
       end;
  23 : begin
         Combobox4.Visible:=false;
         Edit1.Visible:=false;
         Edit1.Left:=MyPort.portip.rtps.Left;
         Edit1.Top:=imgPorts.Top + MyPort.portip.rtps.Top;
         Edit1.Width:=MyPort.portip.rtps.Right - MyPort.portip.rtps.Left;
         Edit1.Height:=MyPort.portip.rtps.Bottom - MyPort.portip.rtps.Top;
         indxport:=23;
         Edit1.Text:=MyPort.portip.Password;
         Edit1.Visible:=true;
       end;
     end;

  MyPort.draw(imgPorts.Canvas, ComboBox4.Height);
  imgPorts.Repaint;
end;

end.
