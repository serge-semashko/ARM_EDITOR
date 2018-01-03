unit UCommon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid, JPEG;

Type
  TGridPlayer = (grClips, grPlaylist);
  TTypeTimeline = (tldevice, tltext, tlmedia, tlnone);

  TEventReplay = record
    Number : integer;
    SafeZone : boolean;
    Image : String;
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

//Основные параметры программы
  MainWindowStayOnTop : boolean = false;
  StepCoding : integer =5;
  SpeedMultiple : double = 1;
  DepthUNDO : integer = 20;
  RowsEvents : integer = 7;
  AppPath, AppName : string;

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
  GridFontSize : Integer = 14;
  GridFontBold : boolean = false;
  GridFontItalic : boolean = false;
  GridFontUnderline : boolean = false;
  GridSubFontName : tfontname = 'Times New Roman';
  GridSubFontColor : tcolor = clWhite;
  GridSubFontSize : Integer = 10;
  GridSubFontBold : boolean = false;
  GridSubFontItalic : boolean = false;
  GridSubFontUnderline : boolean = false;
  ProjectHeightTitle : integer = 30;
  ProjectHeightRow : integer = 47;
  ProjectRowsTop : integer = 1;
  ProjectRowsHeight : integer = 21;
  ProjectRowsInterval : integer = 4;
  PLHeightTitle : integer = 0;
  PLHeightRow : integer = 60;
  PLRowsTop : integer = 1;
  PLRowsHeight : integer = 21;
  PLRowsInterval : integer = 10;
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

//Procedure SetMainGridPanel(TypeGrid : TTypeGrid);
function UserExists(User,Pass : string) : boolean;

procedure LoadBMPFromRes(cv : tcanvas; rect : trect; width, height : integer; name : string);
function SmoothColor(color : tcolor; step : integer) : tcolor;
Function DefineFontSizeW(cv : TCanvas; width : integer; txt : string): integer;
Function DefineFontSizeH(cv : TCanvas; height : integer): integer;
function MyDoubleToSTime(db : Double) : string;
function MyDoubleToFrame(db : Double) : longint;
function FramesToStr(frm : longint) : string;
function FramesToShortStr(frm : longint) : string;
function SecondToStr(frm : longint) : string;
function SecondToShortStr(frm : longint) : string;
function FramesToDouble(frm : longint) : Double;
function createunicumname : string;
procedure CreateDirectories(NewProject : string);
procedure UpdateProjectPathes(NewProject : string);

procedure LoadJpegFile(bmp : tbitmap; FileName : string);

procedure MyTextRect(var cv : tcanvas; const Rect : TRect; Text : string);

implementation
uses umain, uimgbuttons;


function UserExists(User,Pass : string) : boolean;
begin
  result:=false;
  if (User='Demo') and (Pass='Demo') then result := true;
end;


Procedure SetPathProject(IDProject : string);
begin
  PathProject:=AppPath + DirProjects + '\' + IDProject;
  //PathEvents:=PathProject + '\' + DirEvents;
  PathTemp:=PathProject + '\' + DirTemp;
  PathTemplates:=PathProject + '\' + DirTemplates;
end;

function CalcTextExtent(DCHandle:integer;Text:string):TSize;
var
 CharFSize:TABCFloat;
begin
 Result.cx:=0;
 Result.cy:=0;
 if Text='' then
   exit;
 GetTextExtentPoint32(DCHandle,PChar(Text),Length(Text),Result);
 GetCharABCWidthsFloat(DCHandle,Ord(Text[Length(Text)]),Ord(Text[Length(Text)]),CharFSize);
 if CharFSize.abcfC<0 then
   Result.cx:=Result.cx+Trunc(Abs(CharFSize.abcfC));
end;

function CalcTextWidth(DCHandle:integer;Text:string):integer;
begin
 Result:= CalcTextExtent(DCHandle,Text).cx;
end;

procedure MyTextRect(var cv : tcanvas; const Rect : TRect; Text : string);
var LR : TLogFont;
    FHOld, FHNew : HFONT;
    wdth, fntsz, sz, sz1, szc, sz2, szm : integer;
    size : TSize;
    pr : integer;
    s, s1, s2: string;
    bmp : tbitmap;
begin
  if length(Text)<=0 then exit;
  bmp := tbitmap.Create;
  try
  try
    bmp.Width:=rect.Right-rect.Left;
    bmp.Height:=rect.Bottom-rect.Top;
    bmp.Canvas.Brush.Style:=bsSolid;
    bmp.Canvas.CopyRect(bmp.Canvas.ClipRect,cv,Rect);
    bmp.Canvas.Font.Assign(cv.Font);
    wdth := Rect.Right-Rect.Left;
    GetObject(bmp.Canvas.Font.Handle, SizeOf(LR), Addr(LR));
    LR.lfHeight:=Rect.Bottom-Rect.Top;

    szm := (wdth - length(Text)) div length(Text);
    LR.lfWidth:=szm;
    FHNew:=CreateFontIndirect(LR);
    FHOld:=SelectObject(bmp.Canvas.Handle,FHNew);
    szc := bmp.Canvas.TextWidth(Text);
    FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
    DeleteObject(FHNew);

    if szc <= wdth then begin
       for sz:=szm to 50 do begin
         LR.lfWidth:=sz;
         FHNew:=CreateFontIndirect(LR);
         FHOld:=SelectObject(bmp.Canvas.Handle,FHNew);
         szc := bmp.Canvas.TextWidth(Text);
         FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
         DeleteObject(FHNew);
         if szc > wdth then begin
           LR.lfWidth:=sz-1;
           FHNew:=CreateFontIndirect(LR);
           FHOld:=SelectObject(bmp.Canvas.Handle,FHNew);
           szc := bmp.Canvas.TextWidth(Text);
           break;
         end;
       end;
    end else begin
       for sz:=szm downto 1 do begin
         LR.lfWidth:=sz;
         FHNew:=CreateFontIndirect(LR);
         FHOld:=SelectObject(bmp.Canvas.Handle,FHNew);
         szc := bmp.Canvas.TextWidth(Text);
         if szc <= wdth then break
         else begin
           FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
           DeleteObject(FHNew);
         end;
       end;
    end;

    sz2 := wdth - szc;
    s1:=copy(Text,1,Length(Text)-sz2);
    s2:=copy(Text,length(Text)-sz2+1,sz2);
    bmp.Canvas.Brush.Style:=bsClear;
    bmp.Canvas.TextOut(0,0,s1);
    szc:=bmp.Canvas.TextWidth(s1);
    SetTextCharacterExtra(bmp.Canvas.Handle, 1);
    bmp.Canvas.TextOut(szc,0,s2);
    bitblt(cv.Handle, rect.left, rect.top, rect.Right-rect.Left, rect.Bottom-rect.Top ,bmp.Canvas.Handle, 0, 0 , SRCCOPY);
    SetTextCharacterExtra(bmp.Canvas.Handle, 0);
    FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
    DeleteObject(FHNew);
  finally
    bmp.Free;
    bmp:=nil;
  end;
  except
    FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
    DeleteObject(FHNew);
    bmp.Free;
    bmp:=nil;
  end;
end;

procedure LoadJpegFile(bmp : tbitmap; FileName : string);
var
  JpegIm: TJpegImage;
  wdth,hght,bwdth,bhght : integer;
  dlt : real;
begin
  JpegIm := TJpegImage.Create;
  try
  JpegIm.LoadFromFile(FileName);
  bmp.Assign(JpegIm);
  finally
    JpegIm.Free;
  end;
end;

procedure UpdateProjectPathes(NewProject : string);
begin
  PathProject:=AppPath + DirProjects + '\' + NewProject;
  PathLists := PathProject + DirLists;
  PathClips := PathProject + DirClips;
  PathTemplates := PathProject + DirTemplates;
  PathPlayLists := PathProject + DirPlayLists;
  PathTemp := PathProject + DirTemp;
end;

procedure CreateDirectories(NewProject : string);
var i : integer;
    ext : string;
begin
  AppPath := extractfilepath(Application.ExeName);
  AppName := extractfilename(Application.ExeName);
  ext := extractfileext(Application.ExeName);
  AppName := copy(AppName,1,length(AppName)-length(ext));
  PathFiles:=AppPath+DirFiles;
  if not DirectoryExists(PathFiles) then ForceDirectories(PathFiles);
  PathProject:=AppPath+DirProjects;
  if not DirectoryExists(PathProject) then ForceDirectories(PathProject);
  If Trim(NewProject)='' then exit;
  PathProject:=AppPath + DirProjects + '\' + NewProject;
  PathLists := PathProject + DirLists;
  if not DirectoryExists(PathLists) then ForceDirectories(PathLists);
  PathClips := PathProject + DirClips;
  if not DirectoryExists(PathClips) then ForceDirectories(PathClips);
  PathTemplates := PathProject + DirTemplates;
  if not DirectoryExists(PathTemplates)  then ForceDirectories(PathTemplates);
  PathPlayLists := PathProject + DirPlayLists;
  if not DirectoryExists(PathPlayLists)  then ForceDirectories(PathPlayLists);
  PathTemp := PathProject + DirTemp;
  if not DirectoryExists(PathTemp) then ForceDirectories(PathTemp);
end;

function createunicumname : string;
var YY,MN,DD : Word;
    HH,MM,SS,MS : Word;
begin
  DecodeDate(Now,YY,MN,dd);
  DecodeTime(Now,HH,MM,SS,MS);
  result := inttostr(YY) + inttostr(MN) + inttostr(DD) +
            inttostr(HH) + inttostr(MM) + inttostr(SS) + inttostr(MS);
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

function TwoDigit(dig : integer) : string;
begin
  if (dig>=0) and (dig<=9) then Result:='0'+IntToStr(dig)
  else Result:=IntToStr(dig);
end;

function FramesToDouble(frm : longint) : Double;
var HH,MM,SS,FF,DLT : longint;
begin
  DLT:=frm div 25;
  FF:= frm mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := (HH*3600 + mm*60 + SS) + (FF*40/1000);
end;

function FramesToStr(frm : longint) : string;
var ZN, HH,MM,SS,FF,DLT : longint;
    znak : char;
begin
  ZN := frm;
  znak := #32;
  if frm<0 then begin
    znak := '-';
    ZN :=-1 * ZN;
  end;
  DLT:=ZN div 25;
  FF:= ZN mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := znak + TwoDigit(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
end;

function FramesToShortStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  if frm < 0 then begin
    st:='-';
    fr := -1 * frm;
  end else begin
    st:='';
    fr:=frm;
  end;
  DLT:=fr div 25;
  FF:= fr mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  if HH<>0 then begin
    result := st + TwoDigit(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
    exit;
  end;
  if MM<>0 then begin
    result := st + TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
    exit;
  end;
  result := st +TwoDigit(SS)+':'+TwoDigit(FF);
end;

function SecondToStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  if frm < 0 then begin
    st:='-';
    fr := -1 * frm;
  end else begin
    st:='';
    fr:=frm;
  end;
  HH:=fr div 3600;
  MM:=fr mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  if HH<>0 then begin
    result := st + inttostr(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS);
    exit;
  end;
  result := st +inttostr(MM)+':'+TwoDigit(SS);
end;

function SecondToShortStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  if frm < 0 then begin
    st:='-';
    fr := -1 * frm;
  end else begin
    st:='';
    fr:=frm;
  end;
  HH:=fr div 3600;
  MM:=fr mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  if HH<>0 then begin
    result := st + inttostr(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS);
    exit;
  end;
  if MM<>0 then begin
    result := st +inttostr(MM)+':'+TwoDigit(SS);
    exit;
  end;
  result := st + ':'+TwoDigit(SS);
end;

function MyDoubleToSTime(db : Double) : string;
var HH,MM,SS,FF,DLT : longint;
begin
  DLT:=trunc(db);
  FF:=Trunc((db-DLT)*1000/40);
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := TwoDigit(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
end;

function MyDoubleToFrame(db : Double) : longint;
var HH,MM,SS,FF,DLT : longint;
begin
  DLT:=trunc(db);
  FF:=trunc((db-DLT)*1000/40);
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := (HH*3600 + mm*60 + SS)*25 + FF;
end;

function MyDateTimeToStr(tm : tdatetime) : string;
var Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(tm, Hour, Min, Sec, MSec);
  Result := twodigit(Hour) + ':' + twodigit(Min) + ':' + twodigit(Sec) + ':' + twodigit(trunc(MSec/40));
end;

Function DefineFontSizeW(cv : TCanvas; width : integer; txt : string): integer;
var fntsz, sz : integer;
begin
  result:=0;
  if cv.Font.Size=0 then cv.Font.Size:=40;
  fntsz:=cv.Font.Size;
  For sz:=fntsz downto 5 do begin
    cv.Font.Size:=sz;
    if cv.TextWidth(txt) < width - 4 then break;
  end;
  result := sz;
  cv.Font.Size:=fntsz;
end;

Function DefineFontSizeH(cv : TCanvas; height : integer): integer;
var fntsz, sz : integer;
begin
  result:=0;
  fntsz:=cv.Font.Size;
  //cv.Font.Size:=40;
  For sz:=40 downto 5 do begin
    cv.Font.Size:=sz;
    if cv.TextHeight('0') < height-2 then break;
  end;
  result := sz;
  cv.Font.Size:=fntsz;
end;

//function SmoothColor(color : tcolor; step : integer) : tcolor;
//var cColor: Longint;
//    r, g, b: Byte;
//begin
//  cColor := ColorToRGB(Color);
//  r := cColor;
//  g := cColor shr 8;
//  b := cColor shr 16;
//  if (r + step) < 255 then r := r+step else r:=r-step;
//  if (g + step) < 255 then g := g+step else g:=g-step;
//  if (b + step) < 255 then b := b+step else b:=b-step;
//  result:=RGB(r,g,b);
//end;

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


end.
