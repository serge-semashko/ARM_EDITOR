unit UPageSetup;
                   
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Printers, StdCtrls, Buttons, ExtCtrls, ComCtrls, TabNotBk, Math, WinSpool,
  Spin, IniFiles;

type

  TOffset = record
    X,Y : integer;
  end;

  TPageParameters = Class(TObject)
  private
    FPrinterExists : Boolean;
  protected
    procedure SetPrinterExists(Value : boolean);
  public
    pOrientation    : TPrinterOrientation;  // ориентациия страницы
    FormatPage      : string;               // формат листа
    //FormatPrinter   : string;               // формат листа поддерживаемый принтером
    XScrInMM        : Real;                 // количество пиксилей в мм для экрана по горизонтали
    YScrInMM        : Real;                 // количество пиксилей в мм для экрана по вертикали
    XPixInMM        : Real;                 // количество пиксилей в мм для принтера по горизонтали
    YPixInMM        : Real;                 // количество пиксилей в мм для принтера по вертикали
    Width           : Real;                 // ширина страницы в мм.
    Height          : Real;                 // высода страницы в мм.
    SpaceLeft       : Real;                 // левый отступ в мм.
    SpaceTop        : Real;                 // верхний отступ в мм.
    SpaceRight      : Real;                 // правый отступ в мм.
    SpaceBottom     : Real;                 // нижней отступ в мм.
    HeadLineTop     : Real;                 // верхний колонтитул в мм.
    HLTopText       : String;               // значение верхнего колонтитула
    Heading         : Real;                 // размер по высоте заголовка в мм.
    WWorkingArea    : Real;                 // размер по ширине рабочей области в мм.
    HWorkingArea    : Real;                 // размер по высоте рабочей области в мм.
    Footer          : Real;                 // размер по высоте нижней сноски в мм.
    HeadLineBottom  : Real;                 // растояние до нижней границы колонтитула в мм.
    HLBottomText    : String;               // значение нижнего колонтитула;
    PixOffsetH      : Real;                 // отступ по горизонтали в пикселях
    PixOffsetY      : Real;                 // отступ по вертикали в пикселях
    ScaleX          : real;                 // Коэфициент по X
    ScaleY          : real;                 // Коэфициент по Y
    PixPrinterOffset : TOffset;             // отступы от границ листа на принтере в пикселях
    PageDirect      : Boolean;              // Направление просмотра страниц Истина сверху-вниз Ложь слева-направо
    PrintFixCols    : Boolean;              // Печать фиксированные столбцы на всех листах
    PrintFixRows    : Boolean;              // Печатать фиксированные строки на всех листах
    PrintReportName : Boolean;              // Печатать заголовок отчета на каждой странице
    Constructor     Create;
    destructor      Destroy; override;
    procedure       Refresh;
    //function        PageParamToStr : string;
   //procedure       StrToPageParam(str : string);
    //procedure       SaveToFile(FileName : string);
    //procedure       LoadFromFile(FileName : string);
    //procedure       WriteToIniFile(FileName, Section, Ident  : string);
    //procedure       ReadFromIniFile(FileName, Section, Ident  : string);
    property        PrinterExists : Boolean read FPrinterExists write SetPrinterExists default false;

  end;

  TFPage = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    sbBitBtn1: TSpeedButton;
    sbBitBtn2: TSpeedButton;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Image3: TImage;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    SpinButton1: TSpinButton;
    SpinButton2: TSpinButton;
    SpinButton3: TSpinButton;
    SpinButton4: TSpinButton;
    SpinButton5: TSpinButton;
    SpinButton6: TSpinButton;
    GroupBox4: TGroupBox;
    ComboBox2: TComboBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Panel5: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label9: TLabel;
    Bevel1: TBevel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Image5: TImage;
    Image4: TImage;
    Panel6: TPanel;
    Label11: TLabel;
    Label10: TLabel;
    Image7: TImage;
    Image6: TImage;
    Bevel3: TBevel;
    Bevel2: TBevel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Panel7: TPanel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure SpinButton2DownClick(Sender: TObject);
    procedure SpinButton2UpClick(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure SpinButton3DownClick(Sender: TObject);
    procedure SpinButton3UpClick(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure SpinButton6DownClick(Sender: TObject);
    procedure SpinButton6UpClick(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure SpinButton5DownClick(Sender: TObject);
    procedure SpinButton5UpClick(Sender: TObject);
    procedure SpinButton4DownClick(Sender: TObject);
    procedure SpinButton4UpClick(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure sbBitBtn2Click(Sender: TObject);
    procedure sbBitBtn1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPage: TFPage;
  PrintPageParameters : TPageParameters;
  lstsz : tstrings;
  OffsetHorz, OffSetVert : real;

  function PageSetup(pgstp : tpageparameters) : boolean;
  Procedure SetPaperFormat(Name : string);
  function  CurrentPaperFormat : string;

implementation
uses umain, ucommon, uinitforms, umyprint;

{$R *.dfm}

destructor tpageparameters.Destroy;
begin
  freemem(@pOrientation);
  freemem(@FormatPage);
  freemem(@XScrInMM);
  freemem(@YScrInMM);
  freemem(@XPixInMM);
  freemem(@YPixInMM);
  freemem(@Width);
  freemem(@Height);
  freemem(@SpaceLeft);
  freemem(@SpaceTop);
  freemem(@SpaceRight);
  freemem(@SpaceBottom);
  freemem(@HeadLineTop);
  freemem(@HLTopText);
  freemem(@Heading);
  freemem(@WWorkingArea);
  freemem(@HWorkingArea);
  freemem(@Footer);
  freemem(@HeadLineBottom);
  freemem(@HLBottomText);
  freemem(@PixOffsetH);
  freemem(@PixOffsetY);
  freemem(@ScaleX);
  freemem(@ScaleY);
  freemem(@PixPrinterOffset);
  freemem(@PageDirect);
  freemem(@PrintFixCols);
  freemem(@PrintFixRows);
  freemem(@PrintReportName);
  inherited Destroy;
end;

function ValueFromEdit(st : string) : real;
var s, ss : string;
begin
  s:=trim(st);
  if s='' then begin
    result:=0;
    exit;
  end;
  ss:=copy(s,length(s)-2,4);
  if (trim(ss)='см.') or (trim(ss)='cм.') or (trim(ss)='cm.') or (trim(ss)='сm.')
    then s:=copy(s,1,length(s)-3);
  result:=strtofloat(s);
end;

function EditToMM(st : string) : integer;
var s, ss : string;
    rr : real;
begin
  s:=trim(st);
  if s='' then begin
    result:=0;
    exit;
  end;
  ss:=copy(s,length(s)-2,4);
  if (trim(ss)='см.') or (trim(ss)='cм.') or (trim(ss)='cm.') or (trim(ss)='сm.')
    then s:=copy(s,1,length(s)-3);
  rr:=strtofloat(s);
  result:=trunc(rr*10);
end;

Procedure SetDirectImage;
Begin
  if FPage.RadioButton3.Checked then begin
    FPage.Image4.Visible:=true;
    FPage.Image5.Visible:=false;
  end else begin
    FPage.Image5.Visible:=true;
    FPage.Image4.Visible:=false;
  end;
end;

procedure DrawListImage;
var wdt, hgt, sptp, spbt, splf, sprt, vrcl, ngcl : integer;
    i, imwdt, imhgt, zn : integer;
    kfx, kfy : real;
    znx,znw,dlx, zny, znh, dly : integer;
begin
    fpage.Image3.Picture.Bitmap:=nil;
    wdt:=EditToMM(FPage.Edit1.Text);
    hgt:=EditToMM(FPage.Edit2.Text);
    if (wdt=0) or (hgt=0) then exit;
    sptp:=EditToMM(FPage.Edit3.Text);
    spbt:=EditToMM(FPage.Edit7.Text);
    splf:=EditToMM(FPage.Edit6.Text);
    sprt:=EditToMM(FPage.Edit5.Text);
    vrcl:=EditToMM(FPage.Edit4.Text);
    ngcl:=EditToMM(FPage.Edit8.Text);
    if wdt>=hgt then begin
      //FPage.Panel1.Left:=93;
      //FPage.Panel1.Top:=70;
      FPage.Panel1.Width:=150;       //Panel1.Left := GroupBox1.Left + (GroupBox1.Width - Panel1.Width) div 2;
      FPage.Panel1.Height:=112;      //Panel1.Top := GroupBox1.Top + (GroupBox1.Height - Panel1.Height) div 2;
    end else begin
      //FPage.Panel1.Left:=113;
      //FPage.Panel1.Top:=56;
      FPage.Panel1.Width:=112;
      FPage.Panel1.Height:=142;
    end;
    FPage.Panel1.Left:=(FPage.GroupBox1.Width - FPage.Panel1.Width) div 2;
    FPage.Panel1.Top:=(FPage.GroupBox1.Height - FPage.Panel1.Height) div 2;
    FPage.Panel2.Left:=FPage.Panel1.Left-3;
    FPage.Panel2.Top:=FPage.Panel1.Top-3;
    FPage.Panel2.Width:=FPage.Panel1.Width;
    FPage.Panel2.Height:=FPage.Panel1.Height;
    fpage.Image3.Picture.Bitmap.Width:=FPage.Panel2.Width-4;
    fpage.Image3.Picture.Bitmap.Height:=FPage.Panel2.Height-4;
    imwdt:=fpage.Image3.Picture.Bitmap.Width-1;
    imhgt:=fpage.Image3.Picture.Bitmap.Height-1;
    kfx:=imwdt/wdt;
    kfy:=imhgt/hgt;
    fpage.Image3.Canvas.Pen.Style:=psDot;
    fpage.Image3.Canvas.Pen.Color:=clOlive;
    fpage.Image3.Canvas.Pen.Width:=1;
    zn:=trunc(splf*kfx);
    fpage.Image3.Canvas.MoveTo(zn,0);
    fpage.Image3.Canvas.LineTo(zn,imhgt);
    zn:=trunc(sprt*kfx);
    fpage.Image3.Canvas.MoveTo(imwdt-zn,0);
    fpage.Image3.Canvas.LineTo(imwdt-zn,imhgt);
    zn:=trunc(sptp*kfy);
    fpage.Image3.Canvas.MoveTo(0,zn);
    fpage.Image3.Canvas.LineTo(imwdt,zn);
    zn:=trunc(vrcl*kfy);
    fpage.Image3.Canvas.MoveTo(0,zn);
    fpage.Image3.Canvas.LineTo(imwdt,zn);
    zn:=trunc(spbt*kfy);
    fpage.Image3.Canvas.MoveTo(0,imhgt-zn);
    fpage.Image3.Canvas.LineTo(imwdt,imhgt-zn);
    zn:=trunc(ngcl*kfy);
    fpage.Image3.Canvas.MoveTo(0,imhgt-zn);
    fpage.Image3.Canvas.LineTo(imwdt,imhgt-zn);
    znx:=trunc(splf*kfx)+2;
    dlx:=trunc(30*kfx);
    zny:=trunc(sptp*kfy)+2;
    dly:=trunc(15*kfy);
    zn:=(imhgt-trunc(spbt*kfy)-zny-2) div dly;
    if zn > 6 then zn:=6;
    znh:=zny+zn*dly;

    fpage.Image3.Canvas.Pen.Style:=psSolid;
    fpage.Image3.Canvas.Pen.Color:=clSilver;
    znw:=znx-dlx;
    for i:=0 to 5 do begin
      znw := znw + dlx;
      if znw > (imwdt-trunc(sprt*kfx)-2) then begin
        znw:=znw-dlx;
        continue;
      end;
      fpage.Image3.Canvas.MoveTo(znw,zny);
      fpage.Image3.Canvas.LineTo(znw,znh);
    end;
    for i:=0 to zn do begin
      fpage.Image3.Canvas.MoveTo(znx,zny+i*dly);
      fpage.Image3.Canvas.LineTo(znw,zny+i*dly);
    end;
end;

function StrToPoint(s : string) : TPoint;
var s1, s2 : string;
    ps : integer;
begin
  ps:=pos('x',s);
  s1:=trim(copy(s,1,ps-1));
  s2:=trim(copy(s,ps+1,length(s)));
  result.X:=strtoint(s1);
  result.Y:=strtoint(s2);
end;

procedure EditPlusFloat(edit : tedit; dlt, lmt : real);
var s, ss : string;
    rr : real;
begin
  s:=trim(edit.Text);
  ss:=copy(s,length(s)-2,4);
  if (trim(ss)='см.') or (trim(ss)='cм.') or (trim(ss)='cm.') or (trim(ss)='сm.')
    then s:=copy(s,1,length(s)-3);
  try
    rr:=strtofloat(s);
    rr:=rr+dlt;
    if rr>lmt then rr:=lmt;
    edit.Text:=floattostr(rr) + ' см.';
    //DrawListImage;
  except
    raise Exception.Create('Значение ' + edit.text + ' указано неверно');
    fpage.ActiveControl:=edit;
  end;
end;

procedure EditChange(edit : tedit; llmt, hlmt : real);
var s, ss : string;
    rr : real;
begin
  s:=trim(edit.Text);
  if trim(s)='' then begin
    Edit.Text:=FloatToStr(RoundTo(llmt,-2)) + ' см.';
    exit;
  end;
  ss:=copy(s,length(s)-2,4);
  if (trim(ss)='см.') or (trim(ss)='cм.') or (trim(ss)='cm.') or (trim(ss)='сm.')
    then s:=copy(s,1,length(s)-3);
  try
    rr:=strtofloat(s);
    if rr < llmt then Edit.Text:=FloatToStr(RoundTo(llmt,-2)) + ' см.'
    else if (rr > hlmt) and (hlmt>0) then Edit.Text:=FloatToStr(RoundTo(hlmt,-1)) + ' см.'
    else Edit.Text:=FloatToStr(RoundTo(rr,-2)) + ' см.';
  except
     raise Exception.Create('Значение ' + edit.text + ' указано неверно');
    fpage.ActiveControl:=edit;
  end;
end;

procedure EditMinusFloat(edit : tedit; dlt, lmt : real);
var s, ss : string;
    rr : real;
begin
  s:=trim(edit.Text);
  ss:=copy(s,length(s)-2,4);
  if (trim(ss)='см.') or (trim(ss)='cм.') or (trim(ss)='cm.') or (trim(ss)='сm.')
    then s:=copy(s,1,length(s)-3);
  try
    rr:=strtofloat(s);
    rr:=rr-dlt;
    if rr<lmt then rr:=lmt;
    edit.Text:=floattostr(rr) + ' см.';
  except
     raise Exception.Create('Значение ' + edit.text + ' указано неверно');
    fpage.ActiveControl:=edit;
  end;
end;

function GetPaperFormats(pfmt, psz : tstrings; deffmt : string) : string;
type TPaperName = Array [0..63] of Char;
     TPaperNameArray = Array [1..500] of TPaperName;
     PPaperNameArray = ^TPaperNameArray;
     TPaperSizeArray = Array [1..500] of TPoint;
     PPaperSizeArray = ^TPaperSizeArray;
var  Device, Driver, Port: Array [0..255] of Char;
     hDevMode: THandle;
     pdmode : pdevmode;
     i, numPaperFormats, numPaperSize: Integer;
     pPaperFormats: PPaperNameArray;
     pPaperSize : PPaperSizeArray;
     bl : boolean;
     ss : string;
     PixelsX, PixelsY: integer;
begin
  bl:=false;
  Printer.PrinterIndex:=Printer.PrinterIndex;
    if Printer.PrinterIndex = -1 then Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDevmode);

  PixelsX:=GetDeviceCaps(printer.Handle,LogPixelsX);
  PixelsY:=GetDeviceCaps(printer.Handle,LogPixelsY);
  ss:=inttostr(PixelsX) + ' x ' + inttostr(PixelsY);
  numPaperFormats :=  winspool.DeviceCapabilities(Device, Port, DC_PAPERNAMES, Nil, Nil);
  numPaperSize :=  winspool.DeviceCapabilities(Device, Port, DC_PAPERSIZE, Nil, Nil);
  if numPaperformats > 0 then begin
    GetMem(pPaperformats, numPaperformats * Sizeof( TPapername ));
    try
      GetMem(pPaperSize, numPaperSize * Sizeof( TPoint ));
      try
        winspool.DeviceCapabilities(Device, Port, DC_PAPERNAMES, Pchar( pPaperFormats ), Nil);
        winspool.DeviceCapabilities(Device, Port, DC_PAPERSIZE, Pchar( pPaperSize ), Nil);
        pfmt.clear;
        psz.Clear;
        for i := 1 to numPaperformats do begin
          ss:= pPaperformats^[i];
          if ss=deffmt then bl:=true;
          pfmt.add( pPaperformats^[i]);
          psz.Add(inttostr(pPaperSize^[i].X)+ ' x ' + inttostr(pPaperSize^[i].Y));
        end;
      finally FreeMem(pPaperSize);
      end;
    finally FreeMem( pPaperformats );
    end;
  end;
  if not bl then begin
    pdmode:=GlobalLock(hdevmode);
    result:=pdmode^.dmFormName;
    GlobalUnlock(hdevmode);
  end else result:=deffmt;
  printer.PrinterIndex:=printer.PrinterIndex;
end;

function GetPaperBins(sl: TStrings) : smallint;
type
  TBinName      = array [0..23] of Char;
  TBinNameArray = array [1..High(Integer) div SizeOf(TBinName)] of TBinName;
  PBinnameArray = ^TBinNameArray;
  TBinArray     = array [1..High(Integer) div SizeOf(Word)] of Word;
  PBinArray     = ^TBinArray;
var
  Device, Driver, Port: array [0..255] of Char;
  hDevMode: THandle;
  pdmode : pdevmode;
  i, numBinNames, numBins, temp: Integer;
  pBinNames: PBinnameArray;
  pBins: PBinArray;
begin
  Printer.PrinterIndex:=Printer.PrinterIndex;
  if Printer.PrinterIndex = -1 then Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDevmode);
  numBinNames := WinSpool.DeviceCapabilities(Device, Port, DC_BINNAMES, nil, nil);
  numBins     := WinSpool.DeviceCapabilities(Device, Port, DC_BINS, nil, nil);
  if numBins <> numBinNames then
  begin
    raise Exception.Create('DeviceCapabilities reports different number of bins and bin names!');
  end;
  if numBinNames > 0 then
  begin
    pBins := nil;
    GetMem(pBinNames, numBinNames * SizeOf(TBinname));
    GetMem(pBins, numBins * SizeOf(Word));
    try
      WinSpool.DeviceCapabilities(Device, Port, DC_BINNAMES, PChar(pBinNames), nil);
      WinSpool.DeviceCapabilities(Device, Port, DC_BINS, PChar(pBins), nil);
      sl.Clear;
      for i := 1 to numBinNames do
      begin
        temp := pBins^[i];
        sl.addObject(pBinNames^[i], TObject(temp));
      end;
    finally
      FreeMem(pBinNames);
      if pBins <> nil then
        FreeMem(pBins);
    end;
  end;
  pdmode:=GlobalLock(hdevmode);
  result:=pdmode^.dmDefaultSource;
  GlobalUnlock(hdevmode);
  printer.PrinterIndex:=printer.PrinterIndex;
end;

Procedure DrawMaket;
var pnt : tpoint;
    i : integer;
    s : string;
begin
 i:=fpage.ComboBox1.Items.IndexOf(fpage.ComboBox1.Text);
 if (i<0) and (lstsz.count>0) then i:=0;
  pnt := StrToPoint(lstsz.Strings[i]);
  if FPage.RadioButton1.Checked then begin
     fpage.edit1.Text:=floattostr(roundto(pnt.X/100,-2)) + ' см.';
     fpage.edit2.Text:=floattostr(roundto(Pnt.Y/100,-2)) + ' см.';
  end else begin
     fpage.edit1.Text:=floattostr(roundto(pnt.Y/100,-2)) + ' см.';
     fpage.edit2.Text:=floattostr(roundto(Pnt.X/100,-2)) + ' см.';
  end;
  DrawListImage;
end;

procedure TPageParameters.SetPrinterExists(Value : Boolean);
begin
     if Printer.PrinterIndex=-1
        then FPrinterExists:=false else FPrinterExists:=true;
end;

Procedure TPageParameters.Refresh;
Var
  PixPageWidth, PixPageHeight : integer;
  PixX, PixY, ScrX, ScrY : integer;
  scrhdc : thandle;
begin
  try
    Printer.PrinterIndex:=Printer.PrinterIndex;
    if Printer.PrinterIndex=-1 then Printer.PrinterIndex:=-1;
    PixX:=GetDeviceCaps(Printer.Handle,LOGPIXELSX);
    PixY:=GetDeviceCaps(Printer.Handle,LOGPIXELSY);
    scrhdc:=GetDC(0);

    ScrX:=GetDeviceCaps(scrhdc,LOGPIXELSX);
    ScrY:=GetDeviceCaps(scrhdc,LOGPIXELSY);

    ScaleX := PixX / ScrX;
    ScaleY := PixY / ScrY;

    XScrInMM:=ScrX / 25.4;
    YScrInMM:=ScrY / 25.4;

    XPixInMM:=PixX / 25.4;
    YPixInMM:=PixY / 25.4;

    SetPaperFormat(FormatPage);
    FormatPage := CurrentPaperFormat;
    Printer.Orientation:=pOrientation;

    {$IFDEF WIN32}
       PixPageWidth:=GetDeviceCaps(Printer.Handle,PHYSICALWIDTH);
       PixPageHeight:=GetDeviceCaps(Printer.Handle,PHYSICALHEIGHT);
       PixPrinterOffset.X:=trunc(GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX));
       PixPrinterOffset.Y:=Trunc(GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY));
    {$ELSE}
       retval:=Escape(Printer.Handel, GETPRINTINGOFFSET,0,nil,@PixPrinterOffset);
       PixPageWidth:=Printer.PageWidth;
       PixPageHeight:=Printer.PageHeight;
    {$ENDIF}
    Width:=PixPageWidth / XPixInMM;
    Height:=PixPageHeight / YPixInMM;
    PixOffsetH := PixPrinterOffset.X / XPixInMM;
    PixOffsetY := PixPrinterOffset.Y / YPixInMM;
    HWorkingArea:=Height - SpaceTop - SpaceBottom;
    WWorkingArea:=Width - SpaceLeft - SpaceRight;
    Printer.PrinterIndex:=Printer.PrinterIndex;
    except
    end;
end;

Constructor TPageParameters.Create;
Var
  PixPageWidth, PixPageHeight : integer;
  PixX, PixY, ScrX, ScrY : integer;
  scrhdc : thandle;
begin
  try
    inherited;
    Printer.PrinterIndex:=Printer.PrinterIndex;
    if Printer.PrinterIndex=-1 then Printer.PrinterIndex:=-1;
    PixX:=GetDeviceCaps(Printer.Handle,LOGPIXELSX);
    PixY:=GetDeviceCaps(Printer.Handle,LOGPIXELSY);
    scrhdc:=GetDC(0);

    ScrX:=GetDeviceCaps(scrhdc,LOGPIXELSX);
    ScrY:=GetDeviceCaps(scrhdc,LOGPIXELSY);

    ScaleX := PixX / ScrX;
    ScaleY := PixY / ScrY;

    XScrInMM:=ScrX / 25.4;
    YScrInMM:=ScrY / 25.4;

    XPixInMM:=PixX / 25.4;
    YPixInMM:=PixY / 25.4;

    pOrientation := Printer.Orientation;
    FormatPage := CurrentPaperFormat;
    SpaceLeft:=PrintSpaceLeft;
    SpaceTop:=PrintSpaceTop;
    SpaceRight:=PrintSpaceRight;
    SpaceBottom:=PrintSpaceBottom;
    HeadLineTop:=PrintHeadLineTop;
    HLTopText:='';
    Heading:=15.0;
    Footer:=0;
    HeadLineBottom:=PrintHeadLineBottom;
    HLBottomText:='';

    PrintFixCols:=true;
    PrintFixRows:=true;
    PrintReportName:=true;
    PageDirect:=false;

    {$IFDEF WIN32}
       PixPageWidth:=GetDeviceCaps(Printer.Handle,PHYSICALWIDTH);
       PixPageHeight:=GetDeviceCaps(Printer.Handle,PHYSICALHEIGHT);
       PixPrinterOffset.X:=trunc(GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX));
       PixPrinterOffset.Y:=Trunc(GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY));
    {$ELSE}
       retval:=Escape(Printer.Handel, GETPRINTINGOFFSET,0,nil,@PixPrinterOffset);
       PixPageWidth:=Printer.PageWidth;
       PixPageHeight:=Printer.PageHeight;
    {$ENDIF}
    Width:=PixPageWidth / XPixInMM;
    Height:=PixPageHeight / YPixInMM;
    PixOffsetH := PixPrinterOffset.X / XPixInMM;
    PixOffsetY := PixPrinterOffset.Y / YPixInMM;
    HWorkingArea:=Height - SpaceTop - SpaceBottom;
    WWorkingArea:=Width - SpaceLeft - SpaceRight;
    Printer.PrinterIndex:=Printer.PrinterIndex;
    except
    end;
end;

Procedure SetDefaultParam(fmt : string; ornt : TPrinterOrientation);
var currformat : string;
    defbin : smallint;
begin
  currformat:=GetPaperFormats(fpage.ComboBox1.Items, lstsz, fmt);
  fpage.ComboBox1.ItemIndex:=fpage.ComboBox1.Items.IndexOf(currformat);
  defbin:=GetPaperBins(fpage.ComboBox2.Items);
  if (defbin>=0) and (defbin<=fpage.ComboBox2.Items.Count-1)
    then fpage.ComboBox2.ItemIndex:=defbin
    else fpage.ComboBox2.ItemIndex:=0;
  if ornt=poPortrait then begin
    fpage.RadioButton1.Checked:=true;
   end else begin
    fpage.RadioButton2.Checked:=true;
  end;
  DrawMaket;
end;

function PageSetup(pgstp : tpageparameters) : boolean;
begin
  result:=false;
  lstsz:=tstringlist.Create;
  lstsz.Clear;
  PrintPageParameters:=pgstp;
  OffsetHorz:=RoundTo(pgstp.PixOffsetH/10,-1);
  OffsetVert:=RoundTo(pgstp.PixOffsetY/10,-1);

//  fpage.Edit3.Text:=floattostr(roundto(pgstp.SpaceTop/10,-2)) + ' см.';
//  fpage.Edit4.Text:=floattostr(roundto(pgstp.HeadLineTop/10,-2)) + ' см.';
//  fpage.Edit5.Text:=floattostr(roundto(pgstp.SpaceRight/10,-2)) + ' см.';
//  fpage.Edit6.Text:=floattostr(roundto(pgstp.SpaceLeft/10,-2)) + ' см.';
//  fpage.Edit8.Text:=floattostr(roundto(pgstp.HeadLineBottom/10,-2)) + ' см.';
//  fpage.Edit7.Text:=floattostr(roundto(pgstp.SpaceBottom/10,-2)) + ' см.';

  fpage.Edit3.Text:=floattostr(roundto(PrintSpaceTop/10,-2)) + ' см.';
  fpage.Edit4.Text:=floattostr(roundto(PrintHeadLineTop/10,-2)) + ' см.';
  fpage.Edit5.Text:=floattostr(roundto(PrintSpaceRight/10,-2)) + ' см.';
  fpage.Edit6.Text:=floattostr(roundto(PrintSpaceLeft/10,-2)) + ' см.';
  fpage.Edit8.Text:=floattostr(roundto(PrintHeadLineBottom/10,-2)) + ' см.';
  fpage.Edit7.Text:=floattostr(roundto(PrintSpaceBottom/10,-2)) + ' см.';

  fpage.CheckBox1.Checked:=pgstp.PrintFixCols;
  fpage.CheckBox2.Checked:=pgstp.PrintFixRows;
  fpage.CheckBox3.Checked:=pgstp.PrintReportName;
  fpage.RadioButton4.Checked:=pgstp.PageDirect;
  SetDefaultParam(pgstp.FormatPage,pgstp.pOrientation);
  SetDirectImage;

  FPage.ShowModal;
  if FPage.ModalResult=mrOk then begin
      pgstp.FormatPage:=fpage.ComboBox1.Text;
      if Fpage.RadioButton1.Checked
        then pgstp.pOrientation:=poPortrait else pgstp.pOrientation:=poLandscape;
      pgstp.Width:=ValueFromEdit(fpage.Edit1.Text)*10;
      pgstp.Height:=ValueFromEdit(fpage.Edit2.Text)*10;
      pgstp.SpaceTop:=ValueFromEdit(fpage.Edit3.Text)*10;
      pgstp.HeadLineTop:=ValueFromEdit(fpage.Edit4.Text)*10;
      pgstp.SpaceLeft:=ValueFromEdit(fpage.Edit6.Text)*10;
      pgstp.SpaceRight:=ValueFromEdit(fpage.Edit5.Text)*10;
      pgstp.SpaceBottom:=ValueFromEdit(fpage.Edit7.Text)*10;
      pgstp.HeadLineBottom:=ValueFromEdit(fpage.Edit8.Text)*10;

      PrintSpaceTop:=ValueFromEdit(fpage.Edit3.Text)*10;
      PrintHeadLineTop:=ValueFromEdit(fpage.Edit4.Text)*10;
      PrintSpaceLeft:=ValueFromEdit(fpage.Edit6.Text)*10;
      PrintSpaceRight:=ValueFromEdit(fpage.Edit5.Text)*10;
      PrintSpaceBottom:=ValueFromEdit(fpage.Edit7.Text)*10;
      PrintHeadLineBottom:=ValueFromEdit(fpage.Edit8.Text)*10;

      pgstp.PrintFixCols:=fpage.CheckBox1.Checked;
      pgstp.PrintFixRows:=fpage.CheckBox2.Checked;
      pgstp.PrintReportName:=fpage.CheckBox3.Checked;
      pgstp.PageDirect:=fpage.RadioButton4.Checked;
      pgstp.HLTopText:=PrintPageParameters.HLTopText;
      pgstp.HLBottomText:=PrintPageParameters.HLBottomText;
      pgstp.Refresh;
      result:=true;
  end;
end;

procedure SetPaperFormat(Name : string);
// Функция устанавливает формат листа
type TPaperName = Array [0..63] of Char;
     TPaperNameArray = Array [1..500] of TPaperName;
     PPaperNameArray = ^TPaperNameArray;
     TPgFormatsArray = Array [1..500] of Word;
     PPgFormatsArray = ^TPgFormatsArray;
var  Device, Driver, Port: Array [0..255] of Char;
     hDevMode: THandle;
     pdmode : pdevmode;
     i, j, numPaperformats: Integer;
     pPaperFormats: PPapernameArray;
     pPgFormats: PPgFormatsArray;
     fss : string;
begin
  Printer.PrinterIndex:=Printer.PrinterIndex;
  if Printer.PrinterIndex = -1 then Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDevmode);
  numPaperformats :=  winspool.DeviceCapabilities(Device, Port, DC_PAPERNAMES, Nil, Nil);
  if numPaperformats > 0 then begin
    GetMem(pPaperformats, numPaperformats * Sizeof( TPapername ));
    GetMem(pPgformats, numPaperformats * 2);
    try
      GetMem(pPgformats, numPaperformats * 2);
      try
        winspool.DeviceCapabilities(Device, Port, DC_PAPERNAMES, Pchar( pPaperFormats ), Nil);
        winspool.DeviceCapabilities(Device, Port, DC_PAPERS, Pchar(pPgFormats) , Nil);
        for i := 1 to numPaperformats do begin
          if ansilowercase(trim(pPaperformats^[i]))=ansilowercase(trim(Name)) then begin
            pdmode:=GlobalLock(hdevmode);
            pdmode^.dmPaperSize:=pPgFormats^[i];
            fss:=trim(Name);
            for j:=0 to length(fss) do pdmode^.dmFormName[j]:=fss[j+1];
            GlobalUnlock(hdevmode);
          end;
        end;
      finally FreeMem(pPgformats);
      end;
    finally FreeMem( pPaperformats );
    end;
  end;
  printer.PrinterIndex:=printer.PrinterIndex;
end;

function CurrentPaperFormat : string;
var  Device, Driver, Port: Array [0..255] of Char;
     hDevMode: THandle;
     pdmode : pdevmode;
     s : string;
begin
  Printer.PrinterIndex:=Printer.PrinterIndex;
  if Printer.PrinterIndex = -1 then Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDevmode);
  pdmode:=GlobalLock(hdevmode);
  s:=pdmode^.dmFormName;
  result:=pdmode^.dmFormName;
  GlobalUnlock(hdevmode);
  printer.PrinterIndex:=printer.PrinterIndex;
end;

procedure TFPage.RadioButton1Click(Sender: TObject);
begin
   DrawMaket;
end;


procedure TFPage.RadioButton2Click(Sender: TObject);
begin
   DrawMaket;
end;

Procedure SetPanel(nom : integer);
begin
      case nom of
  1: begin
       FPage.Panel4.Visible := true;
       FPage.Panel5.Visible := false;
       FPage.Panel6.Visible := false;
       FPage.SpeedButton5.Font.Style := FPage.SpeedButton5.Font.Style + [fsBold, fsUnderline];
       FPage.SpeedButton6.Font.Style := FPage.SpeedButton6.Font.Style - [fsBold, fsUnderline];
       FPage.SpeedButton7.Font.Style := FPage.SpeedButton7.Font.Style - [fsBold, fsUnderline];
     end;
  2: begin
       FPage.Panel4.Visible := false;
       FPage.Panel5.Visible := false;
       FPage.Panel6.Visible := true;
       FPage.SpeedButton5.Font.Style := FPage.SpeedButton5.Font.Style - [fsBold, fsUnderline];
       FPage.SpeedButton6.Font.Style := FPage.SpeedButton6.Font.Style + [fsBold, fsUnderline];
       FPage.SpeedButton7.Font.Style := FPage.SpeedButton7.Font.Style - [fsBold, fsUnderline];
     end;
  3: begin
       FPage.Panel4.Visible := false;
       FPage.Panel5.Visible := true;
       FPage.Panel6.Visible := false;
       FPage.SpeedButton5.Font.Style := FPage.SpeedButton5.Font.Style - [fsBold, fsUnderline];
       FPage.SpeedButton6.Font.Style := FPage.SpeedButton6.Font.Style - [fsBold, fsUnderline];
       FPage.SpeedButton7.Font.Style := FPage.SpeedButton7.Font.Style + [fsBold, fsUnderline];
     end;
      end;
end;

procedure TFPage.FormCreate(Sender: TObject);
begin
  InitFPageSetup;
  SetPanel(1);
  Image6.Canvas.Brush.Style:=bsSolid;
  Image6.Canvas.Brush.Color:=clWhite;
  Image6.Canvas.FillRect(image1.ClientRect);
  Image7.Canvas.Brush.Style:=bsSolid;
  Image7.Canvas.Brush.Color:=clWhite;
  Image7.Canvas.FillRect(image1.ClientRect);
  Image4.Left:=Image5.Left;
  Image4.Top:=Image5.Top;
  Panel1.Left := GroupBox1.Left + (GroupBox1.Width - Panel1.Width) div 2;
  Panel1.Top := GroupBox1.Top + (GroupBox1.Height - Panel1.Height) div 2;
  //Panel2.Left := GroupBox1.Left + (GroupBox1.Width - Panel2.Width) div 2;
  //Panel2.Top := GroupBox1.Top + (GroupBox1.Height - Panel2.Height) div 2;
  //Fpage.TabbedNotebook1.PageIndex:=0;
end;

procedure TFPage.ComboBox1Change(Sender: TObject);
begin
   DrawMaket;
end;

procedure TFPage.SpinButton1DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit3,0.1,ValueFromEdit(Edit4.Text));
end;

procedure TFPage.SpinButton1UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit3,0.1,ValueFromEdit(Edit2.Text)-ValueFromEdit(Edit7.Text));
end;

procedure TFPage.Edit3Change(Sender: TObject);
begin
  EditChange(Edit3,ValueFromEdit(Edit4.Text),ValueFromEdit(Edit2.Text)-ValueFromEdit(Edit7.Text));
  DrawListImage;
end;

procedure TFPage.SpinButton2DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit4,0.1,OffsetVert);
end;

procedure TFPage.SpinButton2UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit4,0.1,ValueFromEdit(Edit3.Text));
end;

procedure TFPage.Edit4Change(Sender: TObject);
begin
  EditChange(Edit4,OffsetVert,ValueFromEdit(Edit3.Text));
  DrawListImage;
end;

procedure TFPage.SpinButton3DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit5,0.1,OffsetHorz);
end;

procedure TFPage.SpinButton3UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit5,0.1,ValueFromEdit(Edit1.Text)-ValueFromEdit(Edit6.Text));
end;

procedure TFPage.Edit5Change(Sender: TObject);
begin
  EditChange(Edit5,OffsetHorz,ValueFromEdit(Edit1.Text)-ValueFromEdit(Edit6.Text));
  DrawListImage;
end;

procedure TFPage.SpinButton6DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit6,0.1,OffsetHorz);
end;

procedure TFPage.SpinButton6UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit6,0.1,ValueFromEdit(Edit1.Text)-ValueFromEdit(Edit5.Text));
end;

procedure TFPage.Edit6Change(Sender: TObject);
begin
  EditChange(Edit6,OffsetHorz,ValueFromEdit(Edit1.Text)-ValueFromEdit(Edit5.Text));
  DrawListImage;
end;

procedure TFPage.Edit7Change(Sender: TObject);
begin
  EditChange(Edit7,ValueFromEdit(Edit8.Text),ValueFromEdit(Edit2.Text)-ValueFromEdit(Edit3.Text));
  DrawListImage;
end;

procedure TFPage.SpinButton5DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit7,0.1,ValueFromEdit(Edit8.Text));
end;

procedure TFPage.SpinButton5UpClick(Sender: TObject);
begin
  EditPlusFloat(Edit7,0.1,ValueFromEdit(Edit2.Text)-ValueFromEdit(Edit3.Text));
end;

procedure TFPage.SpinButton4DownClick(Sender: TObject);
begin
  EditMinusFloat(Edit8,0.1,OffsetVert);
end;

procedure TFPage.SpinButton4UpClick(Sender: TObject);
begin
   EditPlusFloat(Edit8,0.1,ValueFromEdit(Edit7.Text));
end;

procedure TFPage.Edit8Change(Sender: TObject);
begin
  EditChange(Edit8,OffsetVert,ValueFromEdit(Edit7.Text));
  DrawListImage;
end;

procedure TFPage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LstSz.Free;
end;

procedure TFPage.SpeedButton1Click(Sender: TObject);
begin
  OffsetHorz:=RoundTo(PrintPageParameters.PixOffsetH/10,-1);
  OffsetVert:=RoundTo(PrintPageParameters.PixOffsetY/10,-1);
  fpage.Edit3.Text:=floattostr(roundto(PrintPageParameters.SpaceTop/10,-2)) + ' см.';
  fpage.Edit4.Text:=floattostr(roundto(PrintPageParameters.HeadLineTop/10,-2)) + ' см.';
  fpage.Edit5.Text:=floattostr(roundto(PrintPageParameters.SpaceRight/10,-2)) + ' см.';
  fpage.Edit6.Text:=floattostr(roundto(PrintPageParameters.SpaceLeft/10,-2)) + ' см.';
  fpage.Edit8.Text:=floattostr(roundto(PrintPageParameters.HeadLineBottom/10,-2)) + ' см.';
  fpage.Edit7.Text:=floattostr(roundto(PrintPageParameters.SpaceBottom/10,-2)) + ' см.';
  SetDefaultParam(PrintPageParameters.FormatPage, PrintPageParameters.pOrientation);
end;

procedure TFPage.SpeedButton2Click(Sender: TObject);
var ornt : TPrinterOrientation;
    predfmt : string;
begin
  predfmt:=ComboBox1.Text;
  if selectprinter then begin
    printer.PrinterIndex:=printer.PrinterIndex;
    if RadioButton1.Checked
      then ornt:=poPortrait else ornt:=poLandscape;
    SetDefaultParam(ComboBox1.Text, ornt);
    if ComboBox1.Text<>predfmt
       then MessageDlg('Принтер ' + Printer.Printers.Strings[printer.printerindex] +
                       #10'не поддерживает формат листа - "' + predfmt + '".' +
                       #10'Установлен формат листа - "' + ComboBox1.Text + '".', mtInformation, [mbOk], 0);
    PrintPageParameters.Refresh;
    OffsetHorz:=RoundTo(PrintPageParameters.PixOffsetH/10,-1);
    OffsetVert:=RoundTo(PrintPageParameters.PixOffsetY/10,-1);
    EditChange(Edit4,OffsetVert,ValueFromEdit(Edit3.Text));
    EditChange(Edit8,OffsetVert,ValueFromEdit(Edit7.Text));
    EditChange(Edit5,OffsetHorz,ValueFromEdit(Edit1.Text)-ValueFromEdit(Edit6.Text));
    EditChange(Edit6,OffsetHorz,ValueFromEdit(Edit1.Text)-ValueFromEdit(Edit5.Text));
    EditChange(Edit3,ValueFromEdit(Edit4.Text),ValueFromEdit(Edit2.Text)-ValueFromEdit(Edit7.Text));
    EditChange(Edit7,ValueFromEdit(Edit8.Text),ValueFromEdit(Edit2.Text)-ValueFromEdit(Edit3.Text));
  end;
end;

procedure TFPage.SpeedButton4Click(Sender: TObject);
begin
//  FHeadLine.Caption:='Нижний колонтитул';
//  PrintPageParameters.HLBottomText:=CreateHeadLine(PrintPageParameters.HLBottomText);
//  DrawHeadLine(Image7,ValueFromEdit(Edit7.Text)-ValueFromEdit(Edit8.Text),PrintPageParameters.HLBottomText);
end;

procedure TFPage.RadioButton3Click(Sender: TObject);
begin
  SetDirectImage;
end;

procedure TFPage.RadioButton4Click(Sender: TObject);
begin
  SetDirectImage;
end;

procedure TFPage.sbBitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFPage.sbBitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFPage.SpeedButton5Click(Sender: TObject);
begin
  SetPanel(1);
end;

procedure TFPage.SpeedButton6Click(Sender: TObject);
begin
  SetPanel(2);
end;

procedure TFPage.SpeedButton7Click(Sender: TObject);
begin
  SetPanel(3);
end;

initialization
PrintPageParameters := TPageParameters.Create;

finalization
PrintPageParameters.FreeInstance;
PrintPageParameters := nil;
end.
