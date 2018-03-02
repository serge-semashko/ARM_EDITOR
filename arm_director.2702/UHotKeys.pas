unit UHotKeys;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend,
  ufrhotkeys;

type
  TCellKey = class
    Rect  : TRect;
    MainColor   : TColor;
    Busycolor   : TColor;
    Selectcolor : TColor;
    FontColor   : TColor;
    Busy        : boolean;
    Select      : boolean;
    Notuse      : boolean;
    MSelect     : boolean;
    MName       : string;
    DName       : string;
    mkey        : byte;
    dkey        : byte;
    wordwrap    : word;
    //function    GetKey(numstate : boolean) : byte;
    procedure   Draw(dib : tfastdib; SelBusy : boolean);
    Constructor Create(Name1, Name2 : string; Key1, Key2 : Byte; Rt : TRect; flags : word);
    destructor  Destroy;
  end;

  TMainKeyboard = class
    KCtrl   : boolean;
    KShift  : boolean;
    KAlt    : boolean;
    KKey    : byte;
    UKCtrl  : boolean;
    UKShift : boolean;
    UKAlt   : boolean;
    UKKey   : byte;
    UKPos   : integer;
    Background : tcolor;
    Count : integer;
    Keys : array of TCellKey;
    SCount : integer;
    SKeys : array of TCellKey;
    procedure init(Width, Height : integer);
    procedure Draw(cv : tcanvas);
    procedure SetKeySelected(skeys : string);

    procedure AddStatus(Name1 : string; Key1 : Byte; Rt : TRect; flags : word);
    procedure Add(Name1 : string; Key1 : Byte; Rt : TRect; flags : word); overload;
    procedure Add(Name1,Name2 : string; Key1, Key2 : Byte; Rt : TRect; flags : word); overload;
    procedure SetBusy(Nm : string; Value : boolean); overload;
    procedure SetBusy(Kl : byte; Value : boolean); overload;
    procedure SetSelect(Nm : string; Value : boolean); overload;
    procedure SetSelect(Kl : byte; Value : boolean); overload;
    procedure ClearKey(Nm : string); overload;
    procedure ClearKey(Kl : byte); overload;
    procedure ClearBusy;
    procedure ClearSelect;
    procedure ClearAll;
    procedure ClearSelectWithoutControl;
    function GetKeySelection(Name : string) : boolean; overload;
    function GetKeySelection(Key : byte) : boolean; overload;
    function GetKeyBusy(Name : string) : boolean; overload;
    function GetKeyBusy(Key : byte) : boolean; overload;
    function GetControlValue : word;
    function KeySelect(Name : string) : boolean; overload;
    function KeySelect(Key : byte) : boolean; overload;
    function MoveMouse(cv : tcanvas; X,Y : integer) : byte;
    function ClickMouse(cv : tcanvas; X,Y : integer) : byte;
    procedure SetBusyHotKeys(mode : byte; lst : TMyListHotKeys);
    constructor create;
    destructor destroy;
  end;

  TNUMKeyboard = class
    KCtrl   : boolean;
    KShift  : boolean;
    KAlt    : boolean;
    KKey    : byte;
    UKCtrl  : boolean;
    UKShift : boolean;
    UKAlt   : boolean;
    UKKey   : byte;
    UKPos   : integer;
    MyShift : boolean;
    Background : tcolor;
    NumRect : trect;
    //NumState : boolean;
    Count : integer;
    Keys : array of TCellKey;
    procedure init(Width, Height : integer);
    procedure DrawNumLight(dib : tfastdib);
    procedure Draw(cv : tcanvas);
    procedure SetKeySelected(skeys : string);
    procedure Add(Name1 : string; Key1 : Byte; Rt : TRect; flags : word); overload;
    procedure Add(Name1,Name2 : string; Key1, Key2 : Byte; Rt : TRect; flags : word); overload;
    procedure SetBusy(Nm : string; Value : boolean); overload;
    procedure SetBusy(Kl : byte; Value : boolean); overload;
    procedure SetSelect(Nm : string; Value : boolean); overload;
    procedure SetSelect(Kl : byte; Value : boolean); overload;
    procedure ClearKey(Nm : string); overload;
    procedure ClearKey(Kl : byte); overload;
    procedure ClearBusy;
    procedure ClearSelect;
    procedure ClearAll;
    procedure ClearSelectWithoutControl;
    function GetKeySelection(Name : string) : boolean; overload;
    function GetKeySelection(Key : byte) : boolean; overload;
    function GetKeyBusy(Name : string) : boolean; overload;
    function GetKeyBusy(Key : byte) : boolean; overload;
    function GetControlValue : word;
    function KeySelect(Name : string) : boolean; overload;
    function KeySelect(Key : byte) : boolean; overload;
    function MoveMouse(cv : tcanvas; X,Y : integer) : byte;
    function ClickMouse(cv : tcanvas; X,Y : integer) : byte;
    procedure SetBusyHotKeys(mode : byte; lst : TMyListHotKeys);
    procedure SwapKeys;
    constructor create;
    destructor destroy;
  end;

var
  MyArray : array of tpoint;
  mainkeyboard : tmainkeyboard;
  numkeyboard  : tnumkeyboard;

procedure SetLampState(Key : integer; Value : Boolean);

implementation
uses umain, ucommon;

procedure SetLampState(Key : integer; Value : Boolean);
var KeyState : TKeyboardState;
    abKeyState: array [0..255] of byte;
begin
//  GetKeyboardState(( Addr( abKeyState[ 0 ] ) );
//  abKeyState[ VK_NUMLOCK ] := abKeyState[ VK_NUMLOCK ] or $01;
//  SetKeyboardState( Addr( abKeyState[ 0 ] ) );

//  Var
//KeyState:  TKeyboardState;
//begin
GetKeyboardState(KeyState);
if (KeyState[VK_NUMLOCK] = 0) then
   KeyState[VK_NUMLOCK] := 1
else
  KeyState[VK_NUMLOCK] := 0;
SetKeyboardState(KeyState);
//end;

//  GetKeyboardState(KeyState);
//  KeyState[Key]:=Integer(Value);
//  SetKeyboardState(KeyState);
  //SetState(VK_NUMLOCK,True); // Включение Num Lock
  //SetState(VK_SCROLL,False); // Включение Scroll Lock
  //SetState(VK_CAPITAL,False); // Включение Caps Lock
end;

//function TColorToTfcolor(Color : TColor) : TFColor;
//Преобразование TColor в RGB
//var Clr : longint;
//begin
//  Clr:=ColorToRGB(Color);
//  Result.r:=Clr;
//  Result.g:=Clr shr 8;
//  Result.b:=Clr shr 16;
//end;

//function SmoothColor(color : tcolor; step : integer) : tcolor;
//var cColor: Longint;
//    r, g, b: Byte;
//    zn : integer;
//    rm, gm, bm : Byte;
//begin
//  cColor := ColorToRGB(Color);
//  r := cColor;
// g := cColor shr 8;
//  b := cColor shr 16;
//
//    if (r >= g) and (r >= b) then begin
//    if (r + step) <= 255 then begin
//       r := r + step;
//       g := g + step;
//       b := b + step;
//   end else begin
//       if r-step > 0 then r:=r-step else r:=0;
//       if g-step > 0 then g:=g-step else g:=0;
//       if b-step > 0 then b:=b-step else b:=0;
//    end;
//    result:=RGB(r,g,b);
//    exit;
//  end;
//
//  if (g >= r) and (g >= b) then begin
//    if (g + step) <= 255 then begin
//       r := r + step;
//       g := g + step;
//       b := b + step;
//    end else begin
//       if r-step > 0 then r:=r-step else r:=0;
//      if g-step > 0 then g:=g-step else g:=0;
//       if b-step > 0 then b:=b-step else b:=0;
//    end;
//    result:=RGB(r,g,b);
//    exit;
//  end;
//
//  if (b >= r) and (b >= g) then begin
//   if (b + step) <= 255 then begin
//       r := r + step;
//       g := g + step;
//       b := b + step;
//    end else begin
//       if r-step > 0 then r:=r-step else r:=0;
//       if g-step > 0 then g:=g-step else g:=0;
//       if b-step > 0 then b:=b-step else b:=0;
//   end;
//    result:=RGB(r,g,b);
//    exit;
//  end;
//
//end;

constructor tmainkeyboard.create;
begin
  KCtrl   := false;
  KShift  := false;
  KAlt    := false;
  KKey    := $ff;
  UKCtrl  := false;
  UKShift := false;
  UKAlt   := false;
  UKKey   := $ff;
  UKPos   :=-1;
  Background := clSilver;
  Count:=0;
  SCount:=0;
end;

destructor tmainkeyboard.destroy;
var i : integer;
begin
  freemem(@KCtrl);
  freemem(@KShift);
  freemem(@KAlt);
  freemem(@KKey);
  freemem(@UKCtrl);
  freemem(@UKShift);
  freemem(@UKAlt);
  freemem(@UKKey);
  freemem(@UKPos);
  freemem(@Background);
  for i:=Count-1 downto 0 do begin
    Keys[Count-1].FreeInstance;
    Count:=Count-1;
    Setlength(Keys,Count);
  end;
  freemem(@Count);
  freemem(@Keys);
  for i:=SCount-1 downto 0 do begin
    SKeys[SCount-1].FreeInstance;
    SCount:=SCount-1;
    Setlength(SKeys,SCount);
  end;
  freemem(@SCount);
  freemem(@SKeys);
end;

procedure tmainkeyboard.AddStatus(Name1 : string; Key1 : Byte; Rt : TRect; flags : word);
begin
  SCount:=SCount+1;
  Setlength(SKeys,SCount);
  SKeys[SCount-1] := tcellkey.Create(Name1, Name1, Key1, Key1, Rt, flags);
end;

procedure tmainkeyboard.Add(Name1 : string; Key1 : Byte; Rt : TRect; flags : word);
begin
  Count:=Count+1;
  Setlength(Keys,Count);
  Keys[Count-1] := tcellkey.Create(Name1, Name1, Key1, Key1, Rt, flags);
end;

procedure tmainkeyboard.Add(Name1, Name2 : string; Key1, Key2 : Byte; Rt : TRect; flags : word);
begin
  Count:=Count+1;
  Setlength(Keys,Count);
  Keys[Count-1] := tcellkey.Create(Name1, Name2, Key1, Key2, Rt, flags);
end;

procedure tmainkeyboard.init(Width, Height : integer);
var dlt, intx, inty, wcell, hcell, drwidth, drheight, endstr : integer;
    rt, rts : trect;
begin
  dlt:=100;
  hcell := (Height-30) div 6;
  wcell := (Width-dlt-24) div 19;
  if wcell>hcell then wcell:=hcell else hcell:=wcell;
  drwidth:=wcell*19+24;
  drheight:=hcell*6+10;
  intx:=(Width - drwidth-dlt) div 2;
  inty:=(height - drheight) div 2;
  rts.Left:=20;
  rts.Right:=rts.Left+trunc(1.75*wcell);
//первая строка
  rt.Top := inty;
  rt.Bottom := rt.Top+hcell;
  rt.left :=dlt + intx;
  rt.Right:=rt.Left+wcell;
  Add('Esc',27,rt,0);
  rt.left :=rt.Right+wcell;
  rt.Right:=rt.Left+wcell;
  Add('F1',112,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('F2',113,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('F3',114,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('F4',115,rt,0);
  rt.left :=rt.Right+wcell div 2+5;
  rt.Right:=rt.Left+wcell;
  Add('F5',116,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('F6',117,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('F7',118,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('F8',119,rt,0);
  rt.left :=rt.Right+wcell div 2+5;
  rt.Right:=rt.Left+wcell;
  Add('F9',120,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('F10',121,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('F11',122,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  endstr:=rt.Right;
  Add('F12',123,rt,0);

  rt.Right:=dlt+intx+drwidth;
  rt.Left:=rt.Right-wcell;
  Add('Pause Break',255,rt,3);
  Keys[Count-1].Notuse:=true;
  rt.Right:=rt.Left-2;
  rt.Left:=rt.Right-wcell;
  Add('Scroll Caps',255,rt,2);
  Keys[Count-1].Notuse:=true;
  rt.Right:=rt.Left-2;
  rt.Left:=rt.Right-wcell;
  Add('Print Screen',255,rt,2);
  Keys[Count-1].Notuse:=true;

//вторая строка
  rt.Top := rt.Bottom+2;
  rt.Bottom := rt.Top+hcell;
  rts.Top:=rt.Top;
  rts.Bottom:=rt.Bottom;
  AddStatus('Свободна',0,rts,3);
  rt.left :=dlt + intx;
  rt.Right:=rt.Left+wcell;
  Add('~',192,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('1',49,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('2',50,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('3',51,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('4',52,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('5',53,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('6',54,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('7',55,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('8',56,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('9',57,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('0',48,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('MINUS',189,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('PLUS',187,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=endstr;//rt.Left+2*wcell;
  Add('Backspace',8,rt,1);

  rt.Right:=dlt+intx+drwidth;
  rt.Left:=rt.Right-wcell;
  Add('Page Up',33,rt,3);
  rt.Right:=rt.Left-2;
  rt.Left:=rt.Right-wcell;
  Add('Home',36,rt,3);
  rt.Right:=rt.Left-2;
  rt.Left:=rt.Right-wcell;
  Add('Insert',45,rt,2);

//третья строка
  rt.Top := rt.Bottom+2;
  rt.Bottom := rt.Top+hcell;
  rts.Top:=rt.Top;
  rts.Bottom:=rt.Bottom;
  AddStatus('Занята',0,rts,3);
  SKeys[SCount-1].Busy:=true;
  rt.left :=dlt+intx;
  rt.Right:=rt.Left+trunc(1.5*wcell);
  Add('Tab',9,rt,0);
  Keys[Count-1].Notuse:=true;
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('Q',81,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('W',87,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('E',69,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('R',82,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('T',84,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('Y',89,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('U',85,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('I',73,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('O',79,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('P',80,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('[',219,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add(']',221,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=endstr;//rt.Left+trunc(1.5*wcell);
  Add('\',220,rt,0);

  rt.Right:=dlt+intx+drwidth;
  rt.Left:=rt.Right-wcell;
  Add('Page Down',35,rt,3);
  rt.Right:=rt.Left-2;
  rt.Left:=rt.Right-wcell;
  Add('End',35,rt,3);
  rt.Right:=rt.Left-2;
  rt.Left:=rt.Right-wcell;
  Add('Delete',46,rt,2);

//четвертая строка
  rt.Top := rt.Bottom+2;
  rt.Bottom := rt.Top+hcell;
  rts.Top:=rt.Top;
  rts.Bottom:=rt.Bottom;
  AddStatus('Выбрана',0,rts,3);
  SKeys[SCount-1].Select:=true;
  rt.left :=dlt+intx;
  rt.Right:=rt.Left+trunc(1.7*wcell);
  Add('Caps Lock',20,rt,1);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('A',65,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('S',83,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('D',68,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('F',70,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('G',71,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('H',72,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('J',74,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('K',75,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('L',76,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add(';',186,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('''',222,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=endstr;//rt.Left+trunc(2.35*wcell);
  Add('Enter',13,rt,0);

//пятая строка
  rt.Top := rt.Bottom+2;
  rt.Bottom := rt.Top+hcell;
  rts.Top:=rt.Top;
  rts.Bottom:=rt.Bottom;
  AddStatus('Не используется',0,rts,2);
  SKeys[SCount-1].Notuse:=true;
  rt.left :=dlt+intx;
  rt.Right:=rt.Left+trunc(2.1*wcell);
  Add('Shift',16,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('Z',90,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('X',88,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('C',67,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('V',86,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('B',66,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('N',78,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('M',77,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('<',188,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('>',190,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('?',191,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=endstr;//rt.Left+3*wcell;
  Add('Shift',16,rt,0);

  rt.Right:=dlt+intx+drwidth-wcell-2;
  rt.Left:=rt.Right-wcell;
  Add('Up',38,rt,0);

//Шестая строка
  rt.Top := rt.Bottom+2;
  rt.Bottom := rt.Top+hcell;
  rt.left :=dlt+intx;
  rt.Right:=rt.Left+2*wcell;
  Add('Ctrl',17,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('Win Left',91,rt,1);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+2*wcell;
  Add('Alt',18,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+trunc(5.4*wcell);
  Add('Space',32,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+2*wcell;
  Add('Alt',18,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('Win Right',93,rt,1);
  rt.left :=rt.Right+2;
  rt.Right:=endstr;//rt.Left+2*wcell;
  Add('Ctrl',17,rt,0);

  rt.Right:=dlt+intx+drwidth;
  rt.Left:=rt.Right-wcell;
  Add('Right',39,rt,3);
  rt.Right:=rt.Left-2;
  rt.Left:=rt.Right-wcell;
  Add('Down',40,rt,3);
  rt.Right:=rt.Left-2;
  rt.Left:=rt.Right-wcell;
  Add('Left',37,rt,0);
end;

procedure tmainkeyboard.SetBusy(Nm : string; Value : boolean);
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm))=lowercase(trim(s)) then keys[i].Busy:=Value;
  end;
end;

procedure tmainkeyboard.SetBusy(Kl : byte; Value : boolean);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if Kl=Keys[i].mkey then keys[i].Busy:=Value;
  end;
end;

procedure tmainkeyboard.SetSelect(Nm : string; Value : boolean);
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm))=lowercase(trim(s)) then keys[i].Select:=Value;
  end;
end;

procedure tmainkeyboard.SetSelect(Kl : byte; Value : boolean);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if Kl=Keys[i].mkey then keys[i].Select:=Value;
  end;
end;

procedure tmainkeyboard.ClearKey(Nm : string);
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm))=lowercase(trim(s)) then begin
      keys[i].Busy:=false;
      keys[i].Select:=false;
    end;
  end;
end;

procedure tmainkeyboard.ClearKey(Kl : byte);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if Kl=Keys[i].mkey then begin
      keys[i].Busy:=false;
      keys[i].Select:=false;
    end;
  end;
end;

procedure tmainkeyboard.ClearBusy;
var i : integer;
begin
  for i:=0 to Count-1 do keys[i].Busy:=false;
end;

procedure tmainkeyboard.ClearSelect;
var i : integer;
begin
  for i:=0 to Count-1 do keys[i].Select:=false;
end;

procedure tmainkeyboard.ClearAll;
var i : integer;
begin
  for i:=0 to Count-1 do begin
    keys[i].Busy:=false;
    keys[i].Select:=false;
  end;
end;

procedure tmainkeyboard.ClearSelectWithoutControl;
var i : integer;
begin
  for i:=0 to Count-1
    do if not (keys[i].mkey in [16,17,18]) then keys[i].Select:=false;
end;

function tmainkeyboard.GetKeySelection(Name : string) : boolean;
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name))=lowercase(trim(s)) then begin
      result := keys[i].Select;
      exit;
    end;
  end;
end;

function tmainkeyboard.GetKeySelection(key : byte) : boolean;
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    if Key=Keys[i].mkey then begin
      result := keys[i].Select;
      exit;
    end;
  end;
end;

function tmainkeyboard.GetKeyBusy(Name : string) : boolean;
var i : integer;
    s : string;
begin
  result:=false;
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name))=lowercase(trim(s)) then begin
      result := keys[i].Busy;
      exit;
    end;
  end;
end;

function tmainkeyboard.GetKeyBusy(key : byte) : boolean;
var i : integer;
    s : string;
begin
  result := false;
  for i:=0 to Count-1 do begin
    if Key=Keys[i].mkey then begin
      result := keys[i].Busy;
      exit;
    end;
  end;
end;

function tmainkeyboard.GetControlValue : word;
var i : integer;
begin
  result:=0;
  if GetKeySelection('CTRL') then result := result or $0100;
  if GetKeySelection('SHIFT') then result := result or $0200;
  if GetKeySelection('ALT') then result := result or $0400;
end;

function tmainkeyboard.KeySelect(Name : string) : boolean;
var i : integer;
    s : string;
begin
  result:=false;
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name))=lowercase(trim(s)) then begin
      if keys[i].Select then result:=false;
      exit;
    end;
  end;
end;

function tmainkeyboard.KeySelect(Key : byte) : boolean;
var i : integer;
begin
  result:=false;
  for i:=0 to Count-1 do begin
    if Key=Keys[i].mkey then begin
      if keys[i].Select then result:=false;
      exit;
    end;
  end;
end;

function tmainkeyboard.MoveMouse(cv : tcanvas; X,Y : integer) : byte;
var i : integer;
begin
  result:=255;
  for i:=0 to Count-1 do begin
    if (X>Keys[i].rect.Left+5) and (X<Keys[i].rect.Right-5)
       and (Y>Keys[i].rect.Top+5) and (Y<Keys[i].rect.Bottom-5) then begin
      if (not Keys[i].notuse) or (not Keys[i].Busy) then begin
         Keys[i].MSelect:=true;
         result := Keys[i].mkey;
      end;
    end else Keys[i].MSelect:=false;
  end;
  //Draw(cv);
end;

function tmainkeyboard.ClickMouse(cv : tcanvas; X,Y : integer) : byte;
  var i : integer;
      bl : boolean;
begin
  result:=255;
  for i:=0 to Count-1 do begin
    if (X>Keys[i].rect.Left) and (X<Keys[i].rect.Right)
       and (Y>Keys[i].rect.Top) and (Y<Keys[i].rect.Bottom) then begin
      if Keys[i].Busy then ClearSelectWithoutControl;
      if (not Keys[i].notuse) and (not Keys[i].Busy) then begin
        bl := Keys[i].Select;
        ClearSelectWithoutControl;
        Keys[i].Select:=not bl;//Keys[i].Select;
        if Keys[i].mkey in [16,17,18] then  SetSelect(Keys[i].MName,Keys[i].Select);
        if Keys[i].Select then result := Keys[i].mkey;
      end;
    end;
    Keys[i].MSelect:=false;
  end;
  //Draw(cv);
end;

procedure tmainkeyboard.SetBusyHotKeys(mode : byte; lst : TMyListHotKeys);
var i, j : integer;
    ctrl, cmd : word;
begin
  ctrl := GetControlValue;
  for i:=0 to Count-1 do Keys[i].Busy:=false;
  for i:=0 to Count-1 do begin
    if not (Keys[i].mkey in [16,17,18]) then begin
      cmd:=ctrl+Keys[i].mkey;
      if mode=0 then begin
        if lst.CommandExists(cmd)
          then Keys[i].Busy:=true;// else Keys[i].Busy:=false;
      end else begin
        if lst.CommandExists(0, cmd)
          then Keys[i].Busy:=true;// else Keys[i].Busy:=false;
        if lst.CommandExists(mode, cmd)
          then Keys[i].Busy:=true;// else Keys[i].Busy:=false;
      end;
    end;
    application.ProcessMessages;
  end;
end;

procedure tmainkeyboard.Draw(cv : tcanvas);
var tmp : tfastdib;
    i : integer;
    rt: trect;
begin
   tmp := tfastdib.Create;
   try
     tmp.SetSize(cv.ClipRect.Right-cv.ClipRect.Left,cv.ClipRect.Bottom-cv.ClipRect.Top,32);
     tmp.Clear(TColorToTfcolor(Background));
     tmp.SetBrush(bs_solid,0,colortorgb(Background));
     tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
     tmp.SetTransparent(true);
     UKKey := $ff;
     for i:=0 to Count-1 do begin
       if lowercase(trim(Keys[i].MName))='ctrl' then UKCtrl:=Keys[i].Select
       else if lowercase(trim(Keys[i].MName))='shift' then UKShift:=Keys[i].Select
       else if lowercase(trim(Keys[i].MName))='alt' then UKAlt:=Keys[i].Select;
       if (UKCtrl=KCtrl) and (UKShift=KShift) and (UKAlt=KAlt) and (Keys[i].mkey=kKey)
           and (kkey<>$ff) then Keys[i].Draw(tmp,true) else Keys[i].Draw(tmp,false);
       application.ProcessMessages;
     end;
     for i:=0 to SCount-1 do SKeys[i].Draw(tmp,false);

     rt.Left:=5;
     rt.Top := 5;
     rt.Right := 80;
     rt.Bottom := 55;
     tmp.SetTextColor(colortorgb(clBlack));
     tmp.SetFont(KEYFontName,12);
     tmp.DrawText('Основная клавиатура',rt,DT_LEFT or DT_WORDBREAK);
     tmp.SetTransparent(false);
     tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
     cv.Refresh;
   finally
     tmp.Free;
   end;
end;

procedure tmainkeyboard.SetKeySelected(skeys : string);
var ps : integer;
    s : string;
begin
  try
    s:=uppercase(trim(skeys));
    if s='' then begin
      KCtrl:=false;
      KShift:=false;
      KAlt:=false;
      KKey:=$ff;
      exit;
    end;
    ps:=pos('CTRL',s);
    if ps<>0 then KCtrl:=true else KCtrl:=false;
    ps:=pos('SHIFT',s);
    if ps<>0 then KShift:=true else KShift:=false;
    ps:=pos('ALT',s);
    if ps<>0 then KAlt:=true else KAlt:=false;
    s:=stringreplace(s,'ctrl','',[rfReplaceAll, rfIgnoreCase]);
    s:=stringreplace(s,'shift','',[rfReplaceAll, rfIgnoreCase]);
    s:=stringreplace(s,'alt','',[rfReplaceAll, rfIgnoreCase]);
    s:=stringreplace(s,' ','',[rfReplaceAll, rfIgnoreCase]);
    s:=stringreplace(s,'+','',[rfReplaceAll, rfIgnoreCase]);
    if trim(s)<>'' then begin
      ClearSelect;
      SetSelect('ctrl',KCtrl);
      SetSelect('shift',KShift);
      SetSelect('alt',KAlt);
      KKey:=NameToKey(s);
      SetSelect(s,true);
    end;
  except
  end;
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TCellKey.Create(Name1,Name2 : string; Key1, Key2 : Byte; Rt : TRect; flags : word);
begin
  Rect.left   := RT.Left;
  Rect.Top    := RT.Top;
  Rect.Right  := RT.Right;
  Rect.Bottom := RT.Bottom;
  MainColor   :=clBlack;
  Busycolor   :=clRed;
  Selectcolor :=clGreen;
  FontColor   := clWhite;
  Busy        :=false;
  Select      :=false;
  MName       := Name1;
  DName       := Name2;
  mkey        := Key1;
  dkey        := Key2;
  Notuse      := false;
  MSelect     := false;
  wordwrap    := flags;
end;

destructor TCellKey.destroy;
begin
  freemem(@Rect.left);
  freemem(@Rect.Top);
  freemem(@Rect.Right);
  freemem(@Rect.Bottom);
  freemem(@MainColor);
  freemem(@Busycolor);
  freemem(@Selectcolor);
  freemem(@FontColor);
  freemem(@Busy);
  freemem(@Select);
  freemem(@MName);
  freemem(@mkey);
  freemem(@DName);
  freemem(@dkey);
  freemem(@Notuse);
  freemem(@MSelect);
  freemem(@wordwrap);
end;

procedure   TCellKey.Draw(dib : tfastdib; SelBusy : boolean);
var ps, len, fnwdt, fnhgt : integer;
    rt : trect;
    s1, s2 : string;
begin

  if notuse then dib.SetBrush(bs_solid,0,colortorgb(SmoothColor(maincolor,100)))
  else if busy then begin
    if SelBusy
      then dib.SetBrush(bs_solid,0,colortorgb(smoothcolor(selectcolor,96)))
      else dib.SetBrush(bs_solid,0,colortorgb(busycolor));
  end else if Select then dib.SetBrush(bs_solid,0,colortorgb(selectcolor))
  else dib.SetBrush(bs_solid,0,colortorgb(maincolor));
  dib.SetPen(ps_solid,2,colortorgb(maincolor));
  dib.FillRect(Rect);
  if MSelect then begin
    dib.SetPen(ps_solid,3,colortorgb(smoothcolor(maincolor,164)));
  end else begin
    dib.SetPen(ps_solid,2,colortorgb(maincolor));
  end;
  dib.Rectangle(rect.Left,rect.Top,rect.Right,rect.Bottom);
  if trim(MName)='' then len:=1 else len:=length(trim(MName));
  if (Rect.Bottom-rect.Top)>=2*(Rect.Right-Rect.Left) then begin
    fnwdt:=(Rect.Right-Rect.Left-4) div len;
    fnhgt:=(Rect.Right-Rect.Left) div 2 - 2;
  end else begin
    fnwdt:=(Rect.Right-Rect.Left-4) div len;
    fnhgt:=(Rect.Bottom-rect.Top) div 2 - 2;
  end;

  //dib.SetFontEx(KeyFontName,fnwdt,fnhgt,1,false,false,false);
  //dib.SetTextColor(colortorgb(FontColor));

  if (wordwrap=0) or (wordwrap=1) then begin
    dib.SetFont(KeyFontName,fnhgt);
    dib.SetTextColor(colortorgb(FontColor));
  end else begin
    s2:=trim(MName);
    ps:=pos(' ',s2);
    if ps<>0 then begin
      s1:=trim(copy(s2,1,ps-1));
      s2:=trim(copy(s2,ps+1,length(s2)));
      if length(s1)>length(s2) then len:=Length(s1) else len:=length(s2);
    end else len:=length(s2);
    if wordwrap=2
      then fnwdt:=(Rect.Right-Rect.Left-6) div len
      else fnwdt:=(Rect.Right-Rect.Left-10) div (len+1);
    dib.SetFontEx(KeyFontName,fnwdt,fnhgt,1,false,false,false);
  end;

  rt.Left:=rect.Left+2;
  rt.Top:=rect.Top+2;
  rt.Right:=rect.Right-2;
  rt.Bottom:=rect.Bottom-2;
  s1:=MName;
  if lowercase(trim(s1))='minus' then s1:='-';
  if lowercase(trim(s1))='plus' then s1:='+';
  if lowercase(trim(s1))='numpadminus' then s1:='-';
  if lowercase(trim(s1))='numpadplus' then s1:='+';
  if lowercase(trim(s1))='numpadmult' then s1:='*';
  if lowercase(trim(s1))='numpaddiv' then s1:='/';
  if lowercase(trim(s1))='numpadpoint' then s1:='.';
  if lowercase(trim(s1))='numpad0' then s1:='0';
  if lowercase(trim(s1))='numpad1' then s1:='1';
  if lowercase(trim(s1))='numpad2' then s1:='2';
  if lowercase(trim(s1))='numpad3' then s1:='3';
  if lowercase(trim(s1))='numpad4' then s1:='4';
  if lowercase(trim(s1))='numpad5' then s1:='5';
  if lowercase(trim(s1))='numpad6' then s1:='6';
  if lowercase(trim(s1))='numpad7' then s1:='7';
  if lowercase(trim(s1))='numpad8' then s1:='8';
  if lowercase(trim(s1))='numpad9' then s1:='9';
  if lowercase(trim(s1))='\' then s1:='|';
  if wordwrap=0
    then dib.DrawText(trim(s1),Rt,DT_CENTER)
    else dib.DrawText(trim(s1),Rt,DT_CENTER or DT_WORDBREAK);
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//function decodecommand(s : string) : tpoint;
//var ps : integer;
//    s1, s2 : string;
//begin
//  ps := pos('=',s);
//  s1 := copy(s,1,ps-1);
//  s2 := copy(s,ps+1,length(s));
//  result.X:=strtoint(s1);
//  result.Y:=strtoint(s2);
//end;

//procedure LoadCommandKeys(FN : string);
//var i : integer;
//    lst : tstrings;
//begin
//  if not FileExists(FN) then exit;
//
//  lst := tstringlist.Create;
//  lst.Clear;
//  try
//    lst.LoadFromFile(FN);
//    Setlength(MyArray,lst.Count);
//    for i:=0 to lst.Count-1 do begin
//      MyArray[i]:=DecodeCommand(lst.Strings[i]);
//    end;
//  finally
//    lst.Free;
//  end;
//end;

//function selectcommand(cmd : word; mp : array of tpoint) : integer;
//var i : integer;
//begin
//  result:=-1;
//  for i:=0 to High(mp)-1 do begin
//    if mp[i].Y=cmd then begin
//      result := mp[i].X;
//      exit;
//    end;
//  end;
//end;

//  fn := extractfilepath(Application.ExeName) + 'ListKeys.keys';
//  Memo1.Lines.SaveToFile(fn);

//fn := extractfilepath(Application.ExeName) + 'ListKeys.keys';
//if Fileexists(fn) then LoadCommandKeys(fn);

//  if trim(Edit2.Text)='' then Edit2.Text:='0';
//  key := strtoint(Edit2.Text);
//  if (key and $0100)<>0 then s:='CTRL';
//  if (key and $0200)<>0 then s:=addplus(s) + 'SHIFT';
//  if (key and $0400)<>0 then s:=addplus(s) + 'ALT';
//  bt:=key and $00FF;
//  s:=addplus(s) + chr(bt);
//  Label15.Caption:=s;

constructor tnumkeyboard.create;
begin
  KCtrl   := false;
  KShift  := false;
  KAlt    := false;
  KKey    := $ff;
  UKCtrl  := false;
  UKShift := false;
  UKAlt   := false;
  UKKey   := $ff;
  UKPos   :=-1;
  Background := clSilver;
  Count:=0;
  NUMRect.Left:=0;
  NUMRect.Top:=0;
  NUMRect.Right:=0;
  NUMRect.Bottom:=0;
  MyShift := false;
end;

destructor tnumkeyboard.destroy;
var i : integer;
begin
  freemem(@KCtrl);
  freemem(@KShift);
  freemem(@KAlt);
  freemem(@KKey);
  freemem(@UKCtrl);
  freemem(@UKShift);
  freemem(@UKAlt);
  freemem(@UKKey);
  freemem(@UKPos);
  freemem(@Background);
  freemem(@NUMRect);
  for i:=Count-1 downto 0 do begin
    Keys[Count-1].FreeInstance;
    Count:=Count-1;
    Setlength(Keys,Count);
  end;
  freemem(@Count);
  freemem(@Keys);
  freemem(@MyShift);
end;

procedure tnumkeyboard.Add(Name1 : string; Key1 : Byte; Rt : TRect; flags : word);
begin
  Count:=Count+1;
  Setlength(Keys,Count);
  Keys[Count-1] := tcellkey.Create(Name1, Name1, Key1, Key1, Rt, flags);
end;

procedure tnumkeyboard.Add(Name1, Name2 : string; Key1, Key2 : Byte; Rt : TRect; flags : word);
begin
  Count:=Count+1;
  Setlength(Keys,Count);
  Keys[Count-1] := tcellkey.Create(Name1, Name2, Key1, Key2, Rt, flags);
end;

procedure tnumkeyboard.init(Width, Height : integer);
var dlt, intx, inty, wcell, hcell, drwidth, drheight, endstr : integer;
    rt, rts : trect;
begin
  //dlt:=100;

  hcell := (Height-30) div 6;
  wcell := (Width-24) div 6;
  if wcell>hcell then wcell:=hcell else hcell:=wcell;
  drwidth:=wcell*6+10;
  drheight:=hcell*6+10;
  intx:=(Width - drwidth) div 2;
  inty:=(height - drheight) div 2;
  numrect.Left:=intx+2*wcell+4;
  numrect.Right:=numrect.Left+trunc(3*wcell);
  numrect.Top:=inty;
  numrect.Bottom:=numrect.Top+hcell;
//первая строка
//  rt.Left:=intx;
//  rt.Right:=rt.Left+trunc(1.7*wcell);
  rt.Top := numrect.Bottom+2;
  rt.Bottom := rt.Top+hcell;
//  Add('Shift',16,rt,0);
  rt.left :=numrect.Left;
  rt.Right:=rt.Left+wcell;
  Add('Num',144,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPADDIV',111,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPADMULT',106,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPADMINUS',109,rt,0);

//вторая строка
  rt.Left:=intx;
  rt.Right:=rt.Left+trunc(1.7*wcell);
  rt.Top := rt.Bottom+2;
  rt.Bottom := rt.Top+hcell;
  Add('Shift',16,rt,0);
  rt.left :=numrect.Left;
  rt.Right:=rt.Left+wcell;
  Add('NUMPAD7','Home',103,36,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPAD8','UP',104,38,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPAD9','Page Up',105,33,rt,1);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  rts.Left:=rt.Left;
  rts.Top:=rt.Top;
  rts.Right:=rt.Right;
  rts.Bottom:=rt.Top+2*hcell+2;
  Add('NUMPADPLUS',107,rts,0);
//третья строка
  rt.Left:=intx;
  rt.Right:=rt.Left+trunc(1.7*wcell);
  rt.Top := rt.Bottom+2;
  rt.Bottom := rt.Top+hcell;
  Add('Ctrl',17,rt,0);
  rt.left :=numrect.Left;
  rt.Right:=rt.Left+wcell;
  Add('NUMPAD4','Left',100,37,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPAD5','',101,255,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPAD6','Right',102,39,rt,0);

//четвертая строка
  rt.Left:=intx;
  rt.Right:=rt.Left+trunc(1.7*wcell);
  rt.Top := rt.Bottom+2;
  rt.Bottom := rt.Top+hcell;
  Add('Alt',18,rt,0);
//  rt.Top := rt.Bottom+2;
//  rt.Bottom := rt.Top+hcell;
  rt.left :=numrect.Left;
  rt.Right:=rt.Left+wcell;
  Add('NUMPAD1','End',97,35,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPAD2','Down',98,40,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPAD3','Page Down',99,34,rt,1);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  rts.Left:=rt.Left;
  rts.Top:=rt.Top;
  rts.Right:=rt.Right;
  rts.Bottom:=rt.Top+2*hcell+2;
  Add('Enter',13,rts,0);

//пятая строка
  rt.Top := rt.Bottom+2;
  rt.Bottom := rt.Top+hcell;
  rt.left :=numrect.Left;
  rt.Right:=rt.Left+2*wcell +2;
  Add('NUMPAD0','Insert',96,45,rt,0);
  rt.left :=rt.Right+2;
  rt.Right:=rt.Left+wcell;
  Add('NUMPADPOINT','Delete',110,46,rt,2);
end;

procedure tnumkeyboard.SetBusy(Nm : string; Value : boolean);
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm))=lowercase(trim(s)) then keys[i].Busy:=Value;
  end;
end;

procedure tnumkeyboard.SetBusy(Kl : byte; Value : boolean);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if Kl=Keys[i].mkey then keys[i].Busy:=Value;
  end;
end;

procedure tnumkeyboard.SetSelect(Nm : string; Value : boolean);
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm))=lowercase(trim(s)) then keys[i].Select:=Value;
  end;
end;

procedure tnumkeyboard.SetSelect(Kl : byte; Value : boolean);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if Kl=Keys[i].mkey then keys[i].Select:=Value;
  end;
end;

procedure tnumkeyboard.ClearKey(Nm : string);
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Nm))=lowercase(trim(s)) then begin
      keys[i].Busy:=false;
      keys[i].Select:=false;
    end;
  end;
end;

procedure tnumkeyboard.ClearKey(Kl : byte);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if Kl=Keys[i].mkey then begin
      keys[i].Busy:=false;
      keys[i].Select:=false;
    end;
  end;
end;

procedure tnumkeyboard.ClearBusy;
var i : integer;
begin
  for i:=0 to Count-1 do if lowercase(trim(keys[i].MName))<>'num' then keys[i].Busy:=false;
end;

procedure tnumkeyboard.ClearSelect;
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if lowercase(trim(keys[i].MName))<>'num' then keys[i].Select:=false;
  end;
end;

procedure tnumkeyboard.ClearAll;
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if lowercase(trim(keys[i].MName))<>'num' then begin
      keys[i].Busy:=false;
      keys[i].Select:=false;
    end;
  end;
end;

procedure tnumkeyboard.ClearSelectWithoutControl;
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if not (keys[i].mkey in [16,17,18]) then begin
      if lowercase(trim(keys[i].MName))<>'num' then keys[i].Select:=false;
    end;
  end;
end;

function tnumkeyboard.GetKeySelection(Name : string) : boolean;
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name))=lowercase(trim(s)) then begin
      result := keys[i].Select;
      exit;
    end;
  end;
end;

function tnumkeyboard.GetKeySelection(key : byte) : boolean;
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    if Key=Keys[i].mkey then begin
      result := keys[i].Select;
      exit;
    end;
  end;
end;

function tnumkeyboard.GetKeyBusy(Name : string) : boolean;
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name))=lowercase(trim(s)) then begin
      result := keys[i].Busy;
      exit;
    end;
  end;
end;

function tnumkeyboard.GetKeyBusy(key : byte) : boolean;
var i : integer;
    s : string;
begin
  for i:=0 to Count-1 do begin
    if Key=Keys[i].mkey then begin
      result := keys[i].Busy;
      exit;
    end;
  end;
end;

function tnumkeyboard.GetControlValue : word;
var i : integer;
begin
  result:=0;
  if GetKeySelection('CTRL') then result := result or $0100;
  if GetKeySelection('SHIFT') then result := result or $0200;
  if GetKeySelection('ALT') then result := result or $0400;
end;

function tnumkeyboard.KeySelect(Name : string) : boolean;
var i : integer;
    s : string;
begin
  result:=false;
  for i:=0 to Count-1 do begin
    s:=stringreplace(Keys[i].MName,' ','', [rfReplaceAll, rfIgnoreCase]);
    if lowercase(trim(Name))=lowercase(trim(s)) then begin
      if keys[i].Select then result:=false;
      exit;
    end;
  end;
end;

function tnumkeyboard.KeySelect(Key : byte) : boolean;
var i : integer;
begin
  result:=false;
  for i:=0 to Count-1 do begin
    if Key=Keys[i].mkey then begin
      if keys[i].Select then result:=false;
      exit;
    end;
  end;
end;

function tnumkeyboard.MoveMouse(cv : tcanvas; X,Y : integer) : byte;
var i : integer;
begin
  result:=255;
  for i:=0 to Count-1 do begin
    if (X>Keys[i].rect.Left) and (X<Keys[i].rect.Right)
       and (Y>Keys[i].rect.Top) and (Y<Keys[i].rect.Bottom) then begin
      if (not Keys[i].notuse) or (not Keys[i].Busy) then begin
         Keys[i].MSelect:=true;
         result := Keys[i].mkey;
      end;
    end else Keys[i].MSelect:=false;
  end;
  //Draw(cv);
end;

function tnumkeyboard.ClickMouse(cv : tcanvas; X,Y : integer) : byte;
var i : integer;
   bl : boolean;
begin
  result:=255;
  for i:=0 to Count-1 do begin
    if (X>Keys[i].rect.Left) and (X<Keys[i].rect.Right)
       and (Y>Keys[i].rect.Top) and (Y<Keys[i].rect.Bottom) then begin
      if Keys[i].Busy then ClearSelectWithoutControl;
      if (not Keys[i].notuse) and (not Keys[i].Busy) then begin
        bl := Keys[i].Select;
        ClearSelectWithoutControl;
        Keys[i].Select:=not bl;
        if Keys[i].mkey in [16,17,18] then  SetSelect(Keys[i].MName,Keys[i].Select);
        if Keys[i].Select then result := Keys[i].mkey;
      end;
    end;
    Keys[i].MSelect:=false;
  end;
  //Draw(cv);
end;

procedure tnumkeyboard.SwapKeys;
var i : integer;
    bt : byte;
    s : string;
    need : boolean;
begin
  need:=false;

  if GetKeyState(VK_NUMLOCK)=1 then begin
    numkeyboard.SetSelect('NUM',true);
    if GetKeySelection(16) then begin
      if Keys[6].mkey>80 then need := true;
    end else if (Keys[6].mkey<80) then need := true;
  end else begin
    numkeyboard.SetSelect('NUM',false);
    if Keys[6].mkey>80 then need := true;
  end;

  if need then begin
    for i:=0 to Count-1 do begin
      bt:=Keys[i].mkey;
      Keys[i].mkey:=Keys[i].dkey;
      Keys[i].dkey:=bt;
      s:=Keys[i].MName;
      Keys[i].MName:=Keys[i].DName;
      Keys[i].DName:=s;
    end;
  end;
end;

procedure tnumkeyboard.SetBusyHotKeys(mode : byte; lst : TMyListHotKeys);
var i, j : integer;
    ctrl, cmd : word;
begin
  ctrl := GetControlValue;
  for i:=0 to Count-1 do Keys[i].Busy:=false;
  for i:=0 to Count-1 do begin
    if not (Keys[i].mkey in [16,17,18]) then begin
      cmd:=ctrl+Keys[i].mkey;
      if mode=0 then begin
        if lst.CommandExists(cmd)
          then Keys[i].Busy:=true;// else Keys[i].Busy:=false;
      end else begin
        if lst.CommandExists(0, cmd)
          then Keys[i].Busy:=true;// else Keys[i].Busy:=false;
        if lst.CommandExists(mode, cmd)
          then Keys[i].Busy:=true;// else Keys[i].Busy:=false;
      end;
    end;
    application.ProcessMessages;
  end;
end;

procedure tnumkeyboard.DrawNumLight(dib : tfastdib);
var rtp,rtl,rtn : trect;
    ww, hh, psw, psh : integer;
begin
  ww:=(NumRect.Right-NumRect.Left) div 2;
  hh:=(Numrect.Bottom-numrect.Top) div 2;
  rtp.Left:=Numrect.Left + (ww-hh) div 2;
  rtp.Right:=rtp.Left+hh;
  rtp.Top:=Numrect.Top;
  rtp.Bottom:=rtp.Top+hh;
  rtl.Left:=rtp.Right+2;
  rtl.Right:=numrect.Right;
  rtl.Top:=rtp.Top;
  rtl.Bottom:=rtp.Bottom;
  rtn.Left:=numrect.Left;
  rtn.Right:=rtn.Left+ww;
  rtn.Top:=rtp.Bottom;
  rtn.Bottom:=numrect.Bottom;
  dib.SetFont(KEYFontName,hh-2);
  dib.DrawText('Num Lock', rtn, DT_CENTER);
  if GetKeyState(VK_NUMLOCK)=1 then begin
    dib.SetBrush(bs_solid,0,colortorgb(clLime));
    //dib.DrawText('On', rtl, DT_Left);
    //Label11.Caption := 'On'
  end else begin
    dib.SetBrush(bs_solid,0,colortorgb(smoothcolor(clBlack,100)));
    //dib.DrawText('Off', rtl, DT_Left);
    //Label11.Caption := 'Off';
  end;
  dib.Ellipse(rtp.Left,rtp.Top,rtp.Right,rtp.Bottom);
end;

procedure tnumkeyboard.Draw(cv : tcanvas);
var tmp : tfastdib;
    i : integer;
    rt: trect;
begin
   tmp := tfastdib.Create;
   try
     tmp.SetSize(cv.ClipRect.Right-cv.ClipRect.Left,cv.ClipRect.Bottom-cv.ClipRect.Top,32);
     tmp.Clear(TColorToTfcolor(Background));
     tmp.SetBrush(bs_solid,0,colortorgb(Background));
     tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
     tmp.SetTransparent(true);
     for i:=0 to Count-1 do begin
       if lowercase(trim(Keys[i].MName))='ctrl' then UKCtrl:=Keys[i].Select
       else if lowercase(trim(Keys[i].MName))='shift' then UKShift:=Keys[i].Select
       else if lowercase(trim(Keys[i].MName))='alt' then UKAlt:=Keys[i].Select;
       if (UKCtrl=KCtrl) and (UKShift=KShift) and (UKAlt=KAlt) and (Keys[i].mkey=kKey)
           and (kkey<>$ff) then Keys[i].Draw(tmp,true) else Keys[i].Draw(tmp,false);
       application.ProcessMessages;
       //Keys[i].Draw(tmp,false);
       //application.ProcessMessages;
     end;
     rt.Left:=5;
     rt.Top := 5;
     rt.Right := 80;
     rt.Bottom := 55;
     tmp.SetTextColor(colortorgb(clBlack));
     tmp.SetFont(KEYFontName,12);
     tmp.DrawText('Дополнительная клавиатура',rt,DT_LEFT or DT_WORDBREAK);
     DrawNumLight(tmp);
     tmp.SetTransparent(false);
     tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
     cv.Refresh;
   finally
     tmp.Free;
   end;
end;

procedure tnumkeyboard.SetKeySelected(skeys : string);
var ps : integer;
    s : string;
begin
  try
    s:=uppercase(trim(skeys));
    if s='' then begin
      KCtrl:=false;
      KShift:=false;
      KAlt:=false;
      KKey:=$ff;
      exit;
    end;
    ps:=pos('CTRL',s);
    if ps<>0 then KCtrl:=true else KCtrl:=false;
    ps:=pos('SHIFT',s);
    if ps<>0 then KShift:=true else KShift:=false;
    ps:=pos('ALT',s);
    if ps<>0 then KAlt:=true else KAlt:=false;
    s:=stringreplace(s,'ctrl','',[rfReplaceAll, rfIgnoreCase]);
    s:=stringreplace(s,'shift','',[rfReplaceAll, rfIgnoreCase]);
    s:=stringreplace(s,'alt','',[rfReplaceAll, rfIgnoreCase]);
    s:=stringreplace(s,' ','',[rfReplaceAll, rfIgnoreCase]);
    s:=stringreplace(s,'+','',[rfReplaceAll, rfIgnoreCase]);
    if trim(s)<>'' then begin
      ClearSelect;
      SetSelect('ctrl',KCtrl);
      SetSelect('shift',KShift);
      SetSelect('alt',KAlt);
      KKey:=NameToKey(s);
      SetSelect(s,true);
    end;
  except
  end;
end;

end.
