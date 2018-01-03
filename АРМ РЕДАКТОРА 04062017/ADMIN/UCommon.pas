unit UCommon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid, JPEG;

Type
  TGridPlayer = (grClips, grPlaylist, grDefault);
  TSinchronization = (chltc, chsystem, chnone);
  TTypeTimeline = (tldevice, tltext, tlmedia, tlnone);

  TEventReplay = record
    Number : integer;
    SafeZone : boolean;
    Image : String;
  end;

  PCompartido =^TCompartido;
  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero    : Integer;
    Shift     : Double;
    State     : boolean;
    Cadena    : String[20];
  end;

Const
  DirProjects  = 'Projects';
  DirFiles = 'Clips';
  DirLists = '\Lists';
  DirTemplates = '\Templates';
  DirClips     = '\Clips';
  DirPlayLists      = '\PlayLists';
  DirTemp      = '\Temp';
  Alphabet = '0123456789абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz';

Var

//Временно используемые параметрв для отладки программы
  //IDTL : longint = 0;     // Для формирования IDTimeline
  IDCLIPS : longint = 0;  // Для формирования IDClips
  IDPROJ : longint = 0;   // Для формирования IDProj
  IDPLst : longint = 0;   // Для формирования IDLst
  IDTXTTmp : longint = 0; // Для формирования IDTXTTmp
  IDGRTmp : longint = 0;  // Для формирования IDGRTmp
  IDEvents : longint = 0; // Для формирование IDEvents
  szFontEvents1, szFontEvents2 : integer;

//  FWait : TFWaiting;
//Параметры синхронизации
  MyShift      : double = 0; //Смещение LTC относительно системного времени
  TCExists     : boolean = false;
  MyShiftOld   : double = 0; //Старое смещение LTC относительно системного времени
  MyShiftDelta : double = 0;
  MySinhro     : TSinchronization = chnone; //Тип синхронизации
  MyStartPlay  : longint = -1;    // Время старта клипа, при chnone не используется, -1 время не установлено.
  MyStartReady : boolean = false; // True - готовность к старту, false - старт осуществлен.
  MyRemainTime : longint = -1;  //время оставшееся до запуска

//Основные параметры программы
  MainWindowStayOnTop : boolean = false;
  StepCoding : integer =5;
  StepMouseWheel : integer = 10;
  SpeedMultiple : double = 1;
  DepthUNDO : integer = 20;
  RowsEvents : integer = 7;
  AppPath, AppName : string;
  DefaultClipDuration : longint = 10500;

  PredClipID : string = '';

  WorkDirGRTemplate : string ='';
  WorkDirTextTemplate  : string ='';
  WorkDirClips  : string ='';
  WorkDirSubtitors  : string ='';

  PathFiles : string;
  PathProject : string;
  PathClips : string;
  PathLists : string;
  PathPlayLists : string;
  PathTemp : string;
  PathTemplates : string;

  ProjectNumber : string;
  CurrentImageTemplate : string = '@#@';

  RowDownGridProject : integer = -1;
  RowDownGridLists   : integer = -1;
  RowDownGridClips   : integer = -1;
  RowDownGridImgTemplate   : integer = -1;
  RowDownGridActPlayList : integer = -1;

  DeltaDateDelete : integer = 10;
  CurrentMode : boolean = false;
  MainGrid : TTypeGrid = projects;
  SecondaryGrid : TTypeGrid = empty;
  ProgrammColor : tcolor = $494747;
  ProgrammCommentColor : tcolor = clYellow;
  ProgrammFontColor : tcolor = clWhite;
  ProgrammFontName : tfontname = 'Times New Roman';
  ProgrammFontSize : integer = 10;
  ProgrammEditColor : tcolor = clWhite;
  ProgrammEditFontColor : tcolor = clBlack;
  ProgrammEditFontName : tfontname = 'Times New Roman';
  ProgrammEditFontSize : integer = 14;
  CurrentUser : string = 'Иванов И.И.';
  bmpTimeline : TBitmap;
  bmpEvents : TBitmap;
  bmpAirDevices : TBitmap;

  GridPlayer : TGridPlayer = grPlayList;
  GridPlayerRow  : integer = -1;
  UpdateGridTemplate : boolean = true;

  TextRichSelect : boolean = false;

//Основные параметры вспомогательных форм
  FormsColor : tcolor = clBackground;
  FormsFontColor : tcolor = clWhite;
  FormsFontSize : integer = 10;
  FormsSmallFont : integer = 8;
  FormsFontName : tfontname = 'Times New Roman';
  FormsEditColor : tcolor = clWindow;
  FormsEditFontColor : tcolor = clBlack;
  FormsEditFontSize : integer = 10;
  FormsEditFontName : tfontname = 'Times New Roman';

//Основные параметры гридов
  GridBackGround : tcolor = clBlack;
  GridColorPen : tcolor = clWhite;
  GridMainFontColor : tcolor = clWhite;
  GridColorRow1 : tcolor = $211F1F;
  GridColorRow2 : tcolor = $201E1E;
  GridColorSelection : tcolor = $212020;
  PhraseErrorColor : tcolor = clRed;
  PhrasePlayColor : tcolor = clLime;

  GridTitleFontName : tfontname = 'Times New Roman';
  GridTitleFontColor : tcolor = clWhite;
  GridTitleFontSize : Integer = 14;
  GridTitleFontBold : boolean = true;
  GridTitleFontItalic : boolean = false;
  GridTitleFontUnderline : boolean = false;
  GridFontName : tfontname = 'Times New Roman';
  GridFontColor : tcolor = clWhite;
  GridFontSize : Integer = 11;
  GridFontBold : boolean = false;
  GridFontItalic : boolean = false;
  GridFontUnderline : boolean = false;
  GridSubFontName : tfontname = 'Times New Roman';
  GridSubFontColor : tcolor = clWhite;
  GridSubFontSize : Integer = 9;
  GridSubFontBold : boolean = false;
  GridSubFontItalic : boolean = false;
  GridSubFontUnderline : boolean = false;
  ProjectHeightTitle : integer = 30;
  ProjectHeightRow : integer = 47;
  ProjectRowsTop : integer = 1;
  ProjectRowsHeight : integer = 21;
  ProjectRowsInterval : integer = 4;
  PLHeightTitle : integer = 0;
  PLHeightRow : integer = 47;
  PLRowsTop : integer = 1;
  PLRowsHeight : integer = 21;
  PLRowsInterval : integer = 4;
  ClipsHeightTitle : integer = 30;
  ClipsHeightRow : integer = 46;
  ClipsRowsTop : integer = 2;
  ClipsRowsHeight : integer = 20;
  ClipsRowsInterval : integer = 4;
  ListTxtHeightTitle : integer = 0;
  ListTxtHeightRow : integer = 35;
  ListTxtRowsTop : integer = 5;
  ListTxtRowsHeight : integer = 20;
  ListGRHeightTitle : integer = 0;
  ListGRHeightRow : integer = 80;
  ListGRRowsTop : integer = 8;
  ListGRRowsHeight : integer = 30;
  ListGRRowsInterval : integer = 8;
  MyCellColorTrue : tcolor = clLime;
  MyCellColorFalse : tcolor = clGray;
  MyCellColorSelect : tcolor = clRed;

  MouseInLayer2 : boolean = false;
  DblClickClips : boolean;
  DblClickProject : boolean;
  DblClickLists : boolean;
  DblClickImgTemplate  : boolean = false;
  DblClickGridGRTemplate : boolean = false;

  GridGrTemplateSelect : boolean = true;
  RowGridGrTemplateSelect : integer = -1;

//Основные параметры Тайм-линий
  TLBackGround : tcolor = $211F1F;
  TLZoneNamesColor : tcolor = $505050;
  TLZoneNamesFontSize : integer = 14;
  TLZoneNamesFontColor : tcolor = clWhite;
  TLZoneNamesFontName : tfontname = 'Times New Roman';
  TLZoneNamesFontBold : boolean = false;
  TLZoneNamesFontItalic : boolean = false;
  TLZoneNamesFontUnderline : boolean = false;
  TLZoneEditFontBold : boolean = false;
  TLZoneEditFontItalic : boolean = false;
  TLZoneEditFontUnderline : boolean = false;
  TLMaxDevice : integer = 6;
  TLMaxText : integer =5;
  TLMaxMedia : integer = 1;
  TLMaxCount : integer = 16;
  DefaultMediaColor : tcolor = $00d8a520;
  DefaultTextColor : tcolor = $00aceae1;
  Layer2FontColor : tcolor = $202020;
  Layer2FontSize : integer = 8;
  StatusColor : array[0..4] of tcolor = (clRed,clGreen,clBlue,clYellow,clSilver);
  isZoneEditor : boolean = false;
  TLMaxFrameSize : integer = 10;
  TLPreroll  : longint = 250;
  TLPostroll : longint = 3000;
  TLFlashDuration : integer = 5;
  //Основные параметры кнопок
  ProgBTNSFontName : tfontname = 'Times New Roman';
  ProgBTNSFontColor : tcolor = clWhite;
  ProgBTNSFontSize : Integer = 10;
  HintBTNSFontName : tfontname = 'Times New Roman';
  HintBTNSFontColor : tcolor = clBlack;
  HintBTNSFontSize : Integer = 9;
  //Основные параметры печати
  PrintSpaceLeft       : Real = 5;
  PrintSpaceTop        : Real = 5;
  PrintSpaceRight      : Real = 5;
  PrintSpaceBottom     : Real = 5;
  PrintHeadLineTop     : Real = 5;
  PrintHeadLineBottom  : Real = 5;

function SmoothColor(color : tcolor; step : integer) : tcolor;
Function DefineFontSizeH(cv : TCanvas; height : integer): integer;
Function DefineFontSizeW(cv : TCanvas; width : integer; txt : string): integer;
procedure LoadBMPFromRes(cv : tcanvas; rect : trect; width, height : integer; name : string);

implementation
uses umain;
     //uproject, uinitforms, umyfiles, utimeline, udrawtimelines, ugrtimelines,
     //uplaylists, uactplaylist, uplayer, uimportfiles, ulock, umyundo, uimgbuttons,
     //ushifttl, UShortNum, UEvSwapBuffer, UMyMessage, uairdraw, UMyMediaSwitcher,
     //UGridSort, UImageTemplate, UTextTemplate, umyprint, umediacopy, UMyTextTemplate;
function SmoothColor(color : tcolor; step : integer) : tcolor;
var cColor: Longint;
    r, g, b: Byte;
    zn : integer;
    rm, gm, bm : Byte;
begin
  cColor := ColorToRGB(Color);
  r := cColor;
  g := cColor shr 8;
  b := cColor shr 16;

    if (r >= g) and (r >= b) then begin
    if (r + step) <= 255 then begin
       r := r + step;
       g := g + step;
       b := b + step;
    end else begin
       if r-step > 0 then r:=r-step else r:=0;
       if g-step > 0 then g:=g-step else g:=0;
       if b-step > 0 then b:=b-step else b:=0;
    end;
    result:=RGB(r,g,b);
    exit;
  end;

  if (g >= r) and (g >= b) then begin
    if (g + step) <= 255 then begin
       r := r + step;
       g := g + step;
       b := b + step;
    end else begin
       if r-step > 0 then r:=r-step else r:=0;
       if g-step > 0 then g:=g-step else g:=0;
       if b-step > 0 then b:=b-step else b:=0;
    end;
    result:=RGB(r,g,b);
    exit;
  end;

  if (b >= r) and (b >= g) then begin
    if (b + step) <= 255 then begin
       r := r + step;
       g := g + step;
       b := b + step;
    end else begin
       if r-step > 0 then r:=r-step else r:=0;
       if g-step > 0 then g:=g-step else g:=0;
       if b-step > 0 then b:=b-step else b:=0;
    end;
    result:=RGB(r,g,b);
    exit;
  end;

end;

Function DefineFontSizeW(cv : TCanvas; width : integer; txt : string): integer;
var fntsz, sz : integer;
    bmp : tbitmap;
begin
  bmp := tbitmap.Create;
  try
    result:=0;
    if bmp.Canvas.Font.Size=0 then bmp.Canvas.Font.Size:=40;
    fntsz:=cv.Font.Size;
    For sz:=fntsz downto 5 do begin
      bmp.Canvas.Font.Size:=sz;
      if bmp.Canvas.TextWidth(txt) < width - 4 then break;
    end;
    result := sz;
    //cv.Font.Size:=fntsz;
  finally
    bmp.Free;
  end;
end;

Function DefineFontSizeH(cv : TCanvas; height : integer): integer;
var fntsz, sz : integer;
    bmp : tbitmap;
begin
  bmp := tbitmap.Create;
  try
  result:=0;
  //fntsz:=cv.Font.Size;
  //cv.Font.Size:=40;
  For sz:=40 downto 5 do begin
    bmp.Canvas.Font.Size:=sz;
    if bmp.Canvas.TextHeight('0') < height-2 then break;
  end;
  result := sz;
  //cv.Font.Size:=fntsz;
  finally
    bmp.Free;
  end;
end;

procedure LoadBMPFromRes(cv : tcanvas; rect : trect; width, height : integer; name : string);
var bmp : tbitmap;
    wdth, hght, deltx, delty : integer;
    rt : trect;
begin
  if trim(name)='' then exit;
  bmp:=tbitmap.Create;
  bmp.LoadFromResourceName(HInstance, name);
  bmp.Transparent:=true;
  rt.Left:=rect.Left;
  rt.Right:=rect.Right;
  rt.Top:=rect.Top;
  rt.Bottom:=rect.Bottom;
  wdth:=rect.Right-rect.Left;
  hght:=rect.Bottom-rect.Top;
  if wdth > width then begin
    deltx:=(wdth-width) div 2;
    rt.Left:=rect.Left+deltx;
    rt.Right:=rect.Right-deltx;
  end;
  if hght > height then begin
    delty:=(hght-height) div 2;
    rt.Top:=rect.Top+delty;
    rt.Bottom:=rect.Bottom-delty;
  end;
  cv.StretchDraw(rt,bmp);
  bmp.Free;
end;

end.
