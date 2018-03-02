unit UCommon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, JPEG, Math, PasLibVlcUnit,
  System.JSON, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend, Utils;

Type
  TGridPlayer = (grClips, grPlaylist, grDefault);
  TSinchronization = (chltc, chsystem, chnone1);
  TTypeTimeline = (tldevice, tltext, tlmedia, tlnone);

  TEventReplay = record
    Number : integer;
    SafeZone : boolean;
    Image : String;
  end;

  TRectJSON = record helper for TRect
    Function SaveToJSONStr:string;
    Function SaveToJSONObject:tjsonObject;
    Function LoadFromJSONObject(JSON:tjsonobject):boolean;
    Function LoadFromJSONstr(JSONstr:string):boolean;
  End;

  PCompartido =^TCompartido;
  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero    : Integer;
    Shift     : Double;
    State     : boolean;
    Cadena    : String[20];
  end;

Var
//Параметры синхронизации
  MyShift      : double = 0; //Смещение LTC относительно системного времени
  TCExists     : boolean = false;
  MyShiftOld   : double = 0; //Старое смещение LTC относительно системного времени
  MyShiftDelta : double = 0;
  MySinhro     : TSinchronization = chsystem; //Тип синхронизации
  MyStartPlay  : longint = -1;    // Время старта клипа, при chnone не используется, -1 время не установлено.
  MyStartReady : boolean = false; // True - готовность к старту, false - старт осуществлен.
  MyRemainTime : longint = -1;  //время оставшееся до запуска

//Основные параметры программы
  SerialNumber : string = 'DM000001';
  ManagerNumber : integer = 0;
  Port422Name : string ='';
  Port422Number : integer = 0;
  Port422Speed : string = '38400';
  Port422Bits : string = '8';
  Port422Parity : string = 'нечет';
  Port422Stop : string = '1';
  Port422Flow : string = 'нет';
  IPAdress : string = '192.168.000.010';
  IPPort : string = '9009';
  IPLogin : string = '';
  IPPassword : string = '';
  URLServer : string = 'http://localhost:9090/GET_TLEDITOR';
  Port422Init : boolean = false;
  IPPortInit : boolean = false;
  Port422select : boolean = true; // если true -  управление RSPort, false активен IPport
  PortRSStoped : boolean = true; //RS port остановлен

  ListComports : tstrings;

  AutoStart : boolean = false;
  MakeLogging : boolean = true;
  AppPath, AppName : string;
//  SynchDelay : integer = 2;

  ProgrammColor : tcolor = $494747;
  ProgrammFontColor : tcolor = clWhite;
  ProgrammFontName : tfontname = 'Arial';
  ProgrammFontSize : integer = 10;
  MTFontSize : integer = 18;

//Основные параметры Тайм-линий
  TLBackGround : tcolor = $211F1F;
  TLZoneNamesColor : tcolor = $505050;
  TLZoneFontColorSelect  : tcolor = $057522;
  TLZoneNamesFontSize : integer = 14;
  TLZoneNamesFontColor : tcolor = clWhite;
  TLZoneNamesFontName : tfontname = 'Arial';
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
  //Layer2FontColor : tcolor = $202020;
  //Layer2FontSize : integer = 8;
  StatusColor : array[0..4] of tcolor = (clRed,clGreen,clBlue,clYellow,clSilver);
  isZoneEditor : boolean = false;
  TLMaxFrameSize : integer = 10;
  TLPreroll  : longint = 250;
  TLPostroll : longint = 3000;
  TLFlashDuration : integer = 5;
  //TLFontColor : tcolor = clWhite;

  INFOTypeDevice : string = '';
  INFOVendor : string = '';
  INFODevice : string = '';
  INFOProt : string = '';
  INFOName1 : string = '';
  INFOText1 : string = '';
  INFOName2 : string = '';
  INFOText2 : string = '';
  INFOName3 : string = '';
  INFOText3 : string = '';

function UserExists(User,Pass : string) : boolean;
function TwoDigit(dig : integer) : string;
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
function FramesToTime(frm : longint) : tdatetime;
function TimeToFrames(dt : tdatetime) : longint;
function TimeToTimeCodeStr(dt : tdatetime) : string;
function StrTimeCodeToFrames(tc : string) : longint;
function createunicumname : string;
procedure LoadJpegFile(bmp : tbitmap; FileName : string);
procedure MyTextRect(var cv : tcanvas; const Rect : TRect; Text : string);
procedure TemplateToScreen(crpos : TEventReplay);
function MyDateTimeToStr(tm : tdatetime) : string;
function TimeCodeDelta : double;
function TColorToTfcolor(Color : TColor) : TFColor;
procedure Delay(const AMilliseconds: Cardinal);
Procedure addVariableToJson(var json:tjsonobject; varName: string; varvalue: variant);
Function getVariableFromJson(var json:tjsonobject; varName: string;varvalue: variant):variant;
procedure initrect(rt : trect);

implementation
uses mainunit, utimeline, udrawtimelines, ugrtimelines,
     uplayer;
{ TRectJSON }

function TRectJSON.LoadFromJSONObject(JSON: tjsonobject): boolean;
begin
 Top := GetVariableFromJson(json,'Top',Top);
 Bottom := GetVariableFromJson(json,'Bottom',Bottom);
 left := GetVariableFromJson(json,'Left',left);
 Right := GetVariableFromJson(json,'Right',Right);

end;

function TRectJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
  json: tjsonobject;
begin
  json :=  TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONStr), 0) as TJSONObject;
  result := true;
  if json=nil  then begin
   result := false;
  end else LoadFromJsonObject(json);
end;

function TRectJSON.SaveToJSONObject: tjsonObject;
var
 json : tjsonobject;
begin
 json := tjsonobject.Create;
 addVariableToJson(json,'Top',Top);
 addVariableToJson(json,'Bottom',Bottom);
 addVariableToJson(json,'Left',left);
 addVariableToJson(json,'Right',Right);
 result := json;
end;

function TRectJSON.SaveToJSONStr: string;
begin
  result := SaveToJSONObject.ToString;
end;
///// SSSSSSSSSSSSSSSSSSSSSSSSSSSSS end

  Function getVariableFromJson(var json:tjsonobject; varName: string;varvalue: variant):variant;
  var
    tmpjson: tjsonvalue;
    tmpstr : string;
    res : variant;
  begin
    tmpjson := json.GetValue(varName);
    if (tmpjson <> nil) then
    begin
     tmpStr:= tmpjson.Value;
//     varValue := tmpStr;
     result :=tmpstr;
    end;
  end;

  Procedure addVariableToJson(var json:tjsonobject; varName: string; varvalue: variant);
  var
    teststr: ansistring;
    list: TStringList;
    numElement: integer;
    utf8val: string;
    tmpjson: tjsonvalue;
    retval: string;
    strValue : string;
    vType : tvarType;
    tmpInt : integer;
  begin
    FormatSettings.DecimalSeparator := '.';
    vtype:=varType(varValue);
    strValue := varValue;
    utf8val := stringOf(tencoding.UTF8.GetBytes(strValue));
    json.AddPair(varName, strvalue);
  end;

procedure initrect(rt : trect);
begin
  rt.Left:=0;
  rt.Right:=0;
  rt.Top:=0;
  rt.Bottom:=0;
end;

function TColorToTfcolor(Color : TColor) : TFColor;
//Преобразование TColor в RGB
var Clr : longint;
begin
  Clr:=ColorToRGB(Color);
  Result.r:=Clr;
  Result.g:=Clr shr 8;
  Result.b:=Clr shr 16;
end;

function cutstring(Text : string; len : integer) : string;
begin
  result:=Text;
  if length(Text)>len then result:=copy(Text,1,len-3) + '...';
end;



procedure Delay(const AMilliseconds: Cardinal);
var
  SaveTickCount: Cardinal;
begin
  SaveTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
  until GetTickCount - SaveTickCount > AMilliseconds;
end;

function TimeCodeDelta : double;
begin
  result := 0;
  if MySinhro = chltc then result := MyShift;
end;

function UserExists(User,Pass : string) : boolean;
begin
  result:=false;
  if (User='Demo') and (Pass='Demo') then result := true;
end;

function CalcTextExtent(DCHandle:integer;Text:string):TSize;
var
 CharFSize:TABCFloat;
begin
 try
 Result.cx:=0;
 Result.cy:=0;
 if Text='' then
   exit;
 GetTextExtentPoint32(DCHandle,PChar(Text),Length(Text),Result);
 GetCharABCWidthsFloat(DCHandle,Ord(Text[Length(Text)]),Ord(Text[Length(Text)]),CharFSize);
 if CharFSize.abcfC<0 then
   Result.cx:=Result.cx+Trunc(Abs(CharFSize.abcfC));
 except
   //on E: Exception do WriteLog('MAIN', 'UCommon.CalcTextExtent Text=' + Text + ' | ' + E.Message);
 end;
end;

function CalcTextWidth(DCHandle:integer;Text:string):integer;
begin
 try
 Result:= CalcTextExtent(DCHandle,Text).cx;
 except
   //on E: Exception do WriteLog('MAIN', 'UCommon.CalcTextWidth Text=' + Text + ' | ' + E.Message);
 end;
end;

procedure TemplateToScreen(crpos : TEventReplay);
begin

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
    on E: Exception do begin
      //WriteLog('MAIN', 'UCommon.MyTextRect : Text=' + Text + ' | ' + E.Message);
      FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
      DeleteObject(FHNew);
      bmp.Free;
      bmp:=nil;
    end else begin
      FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
      DeleteObject(FHNew);
      bmp.Free;
      bmp:=nil;
    end;
  end;
end;

procedure LoadJpegFile(bmp : tbitmap; FileName : string);
var
  JpegIm: TJpegImage;
  wdth,hght,bwdth,bhght : integer;
  dlt : real;
begin
  try
  //WriteLog('MAIN', 'UCommon.LoadJpegFile FileName=' + FileName);
  JpegIm := TJpegImage.Create;
  try
  JpegIm.LoadFromFile(FileName);
  bmp.Assign(JpegIm);
  finally
    JpegIm.Free;
  end;
  except
    //on E: Exception do WriteLog('MAIN', 'UCommon.LoadJpegFile FileName=' + FileName + ' | ' + E.Message);
  end;
end;

function createunicumname : string;
var YY,MN,DD : Word;
    HH,MM,SS,MS : Word;
begin
  try
  DecodeDate(Now,YY,MN,dd);
  DecodeTime(Now,HH,MM,SS,MS);
  result := inttostr(YY) + inttostr(MN) + inttostr(DD) +
            inttostr(HH) + inttostr(MM) + inttostr(SS) + inttostr(MS);
//  WriteLog('MAIN', 'UCommon.createunicumname Result=' + result);
  except
//    On E : Exception do  WriteLog('MAIN', 'UCommon.createunicumname | ' + E.Message);
  end;
end;

procedure LoadBMPFromRes(cv : tcanvas; rect : trect; width, height : integer; name : string);
var bmp : tbitmap;
    wdth, hght, deltx, delty : integer;
    rt : trect;
begin
  try
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
  except
//    On E : Exception do  WriteLog('MAIN', 'UCommon.LoadBMPFromRes Name=' + Name + ' | ' + E.Message);
  end;
end;

function TwoDigit(dig : integer) : string;
begin
  try
  if (dig>=0) and (dig<=9) then Result:='0'+IntToStr(dig)
  else Result:=IntToStr(dig);
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.TwoDigit | ' + E.Message);
       Result:='00';
    end else Result:='00';
  end;
end;

function FramesToDouble(frm : longint) : Double;
var HH,MM,SS,FF,DLT : longint;
begin
  try
  DLT:=frm div 25;
  FF:= frm mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := (HH*3600 + mm*60 + SS) + (FF*40/1000);
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.FramesToDouble | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function FramesToTime(frm : longint) : tdatetime;
var HH,MM,SS,FF,DLT : longint;
begin
  try
  DLT:=frm div 25;
  FF:= frm mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := encodetime(HH,mm,SS,FF*40);
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.FramesToTime | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function TimeToFrames(dt : tdatetime) : longint;
var HH,MM,SS,ms : word;
begin
  try
  DecodeTime(dt,hh,mm,ss,ms);
  result := (hh*3600 + mm*60 + ss) * 25 + trunc(ms / 40);
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.TimeToFrames | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function TimeToTimeCodeStr(dt : tdatetime) : string;
var HH,MM,SS,ms : word;
begin
  try
  DecodeTime(dt,hh,mm,ss,ms);
  result := TwoDigit(hh) + ':' + TwoDigit(mm) + ':' + TwoDigit(ss) + ':' + TwoDigit(trunc(ms / 40));
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.TimeToTimeCodeStr | ' + E.Message);
       Result:='00:00:00:00';
    end else Result:='00:00:00:00';
  end;
end;

//function MyTimeToStr : string;
//var HH,MM,SS,ms : word;
//   dbl : double;
//begin
//  try
  //DecodeTime(dt,hh,mm,ss,ms);
  //dbl := RoundTo(dt * 1000,-3);
  //dbld2 := MyTimer.ReadTimer;
  //result := FloatToStr(RoundTo((dbld2 - dbld1) * 1000, -3)) + 'ms';
  //dbld1:=dbld2;
  //result := FloatToStr(dt);
  //TwoDigit(hh) + ':' + TwoDigit(mm) + ':' + TwoDigit(ss) + ':' + inttostr(ms);
//  except
//    On E : Exception do begin
//       //WriteLog('MAIN', 'UCommon.MyTimeToStr | ' + E.Message);
//       Result:='00:00:00:000';
//    end else Result:='00:00:00:000';
//  end;
//end;

function StrTimeCodeToFrames(tc : string) : longint;
var HH,MM,SS,ms : word;
    s : string;
begin
  try
  s:=trim(tc);
  s:=StringReplace(s,'Старт в (','',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,')','',[rfReplaceAll, rfIgnoreCase]);
  hh:=strtoint(s[1]+s[2]);
  mm:=strtoint(s[4]+s[5]);
  ss:=strtoint(s[7]+s[8]);
  ms:=strtoint(s[10]+s[11]);
  result := (hh*3600 + mm*60 + ss) * 25 + ms;
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.StrTimeCodeToFrames TC=' + tc + ' | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function FramesToStr(frm : longint) : string;
var ZN, HH,MM,SS,FF,DLT : longint;
    znak : char;
begin
  try
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
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.FramesToStr | ' + E.Message);
       Result:='00:00:00:00';
    end else Result:='00:00:00:00';
  end;
end;

function FramesToShortStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  try
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
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.FramesToShortStr | ' + E.Message);
       Result:='00:00';
    end else Result:='00:00';
  end;
end;

function SecondToStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  try
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
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.SecondToStr | ' + E.Message);
       Result:='00:00';
    end else Result:='00:00';
  end;
end;

function SecondToShortStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  try
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
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.SecondToShortStr | ' + E.Message);
       Result:='00:00';
    end else Result:='00:00';
  end;
end;

function MyDoubleToSTime(db : Double) : string;
var HH,MM,SS,FF,DLT : longint;
begin
  try
  DLT:=trunc(db);
  FF:=Trunc((db-DLT)*1000/40);
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := TwoDigit(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.MyDoubleToSTime | ' + E.Message);
       Result:='00:00:00:00';
    end else Result:='00:00:00:00';
  end;
end;

function MyDoubleToFrame(db : Double) : longint;
var HH,MM,SS,FF,DLT : longint;
begin
  try
  DLT:=trunc(db);
  FF:=trunc((db-DLT)*1000/40);
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := (HH*3600 + mm*60 + SS)*25 + FF;
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.MyDoubleToFrame | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function MyDateTimeToStr(tm : tdatetime) : string;
var Hour, Min, Sec, MSec: Word;
begin
  try
  DecodeTime(tm, Hour, Min, Sec, MSec);
  Result := twodigit(Hour) + ':' + twodigit(Min) + ':' + twodigit(Sec) + ':' + twodigit(trunc(MSec/40));
  except
    On E : Exception do begin
       //WriteLog('MAIN', 'UCommon.MyDateTimeToStr | ' + E.Message);
       Result:='00:00:00:00';
    end else Result:='00:00:00:00';
  end;
end;

Function DefineFontSizeW(cv : TCanvas; width : integer; txt : string): integer;
var fntsz, sz : integer;
    bmp : tbitmap;
begin
  try
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
  except
    //On E : Exception do WriteLog('MAIN', 'UCommon.DefineFontSizeW | ' + E.Message);
  end;
end;

Function DefineFontSizeH(cv : TCanvas; height : integer): integer;
var fntsz, sz : integer;
    bmp : tbitmap;
begin
  try
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
  except
    //On E : Exception do WriteLog('MAIN', 'UCommon.DefineFontSizeH | ' + E.Message);
  end;
end;

function SmoothColor(color : tcolor; step : integer) : tcolor;
var cColor: Longint;
    r, g, b: Byte;
    zn : integer;
    rm, gm, bm : Byte;
begin
  try
  cColor := ColorToRGB(Color);
  r := cColor and $FF;
  g := (cColor shr 8) and $FF;
  b := (cColor shr 16) and $FF;

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
  except
   // On E : Exception do WriteLog('MAIN', 'UCommon.SmoothColor | ' + E.Message);
  end;
end;


initialization
  ListComports := tstringlist.Create;
  ListComports.Clear;
finalization
  ListComports.Free;
  ListComports:=nil;

end.
