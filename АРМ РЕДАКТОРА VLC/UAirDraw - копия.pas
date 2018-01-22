unit UAirDraw;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer,  MMSystem;

Type

  TRectDevice = Class(TObject)
    public
    Number : integer;
    Value : longint;
    Curr : boolean;
    next : boolean;
    Text : String;
    Color : tcolor;
    Rect : Trect;
    procedure Draw(cv : tcanvas);
    Constructor Create;
    Destructor Destroy;
  end;

  TAirDevices = Class(TObject)
    public
    BackGround : tcolor;
    Rect : TRect;
    Count : integer;
    Devices : array of TRectDevice;
    function AddDevice(Color : TColor) : integer;
    //procedure SetValues;
    procedure Init(cv : tcanvas; grpos : integer);
    procedure Draw(cv : tcanvas);
    procedure Clear;
    Constructor Create;
    Destructor Destroy;
  end;

  TAirOneEvent = Class(TObject)
    public
    BackGround : TColor;
    ForeGround : TColor;
    ColorTimeline : TColor;
    ColorEvent : TColor;
    Number : integer;
    Text : string;
    Dev : integer;
    Start : longint;
    Finish : longint;
    Duration : longint;
    Interval : integer;
    Mix : longint;
    Rect : TRect;
    ROrder : TRect;
    RNumber : TRect;
    RSecond : Trect;
    REvent : TRect;
    procedure AssignEvent(ps : integer; curr : boolean);
    procedure Clear;
    function Init(cv : tcanvas; tp, hgh, intrv, sz1, sz2, sz3, sz0 : integer) : integer;
    procedure Draw(cv : tcanvas; ps :integer);
    Procedure DrawText(cv : tcanvas);
    Constructor Create;
    Destructor Destroy;
  end;

  TAirSecond = Class(TObject)
    public
    BackGround : TColor;
    ForeGround : TColor;
    Color      : TColor;
    Start      : longint;
    Finish     : longint;
    Duration   : longint;
    Mix        : longint;
    Rect       : TRect;
    RTC        : TRect;
    RSecond    : TRect;
    procedure AssignEvent(ps : integer; curr : boolean);
    function Init(cv : tcanvas; tp, hgh, sz0 : integer) : integer;
    procedure Draw(cv : tcanvas);
    procedure DrawSeconds(cv : tcanvas);
    Constructor Create;
    Destructor Destroy;
  end;

  TAirEvents = Class(TObject)
    public
    BackGround : TColor;
    ForeGround : TColor;
    Interval   : integer;
    CurrEvent  : TAirOneEvent;
    CurrTime   : TAirSecond;
    count      : integer;
    Events     : array of TAirOneEvent;
    procedure Clear;
    function AddEvent : integer;
    procedure Init(cv : tcanvas);
    procedure Draw(cv : tcanvas);
    procedure DrawTimeCode(cv : tcanvas; tc : longint);
    Constructor Create;
    Destructor Destroy;
  end;

  TPanelAir = Class(TObject)
    public
    AirEvents : TAirEvents;
    AirDevices : TAirDevices;
    procedure SetValues;
    procedure Draw(cv1, cv2 : tcanvas; grpos : integer);
    Constructor Create;
    Destructor Destroy;
  end;

var MyPanelAir : TPanelAir;

implementation

uses umain, ucommon, ugrtimelines, utimeline, udrawtimelines;

//==============================================================================
//=========== Класс TAirOneEvent рисуем одно событие ===========================
//==============================================================================

Constructor TAirOneEvent.Create;
begin
  inherited;
  BackGround     := ProgrammColor;
  ForeGround     := SmoothColor(ProgrammColor,16);
  ColorTimeline  := SmoothColor(ProgrammColor,48);;
  ColorEvent     := ForeGround;
  Number         := -1;
  Text           := '';
  Dev            := -1;
  Start          := -1;
  Finish         := -1;
  Duration       := -1;
  Interval       := -1;
  Mix            := 0;
  Rect.Left      := 0;
  Rect.Right     := 0;
  Rect.Top       := 0;
  Rect.Bottom    := 0;
  ROrder.Left    := 0;
  ROrder.Right   := 0;
  ROrder.Top     := 0;
  ROrder.Bottom  := 0;
  RNumber.Left   := 0;
  RNumber.Right  := 0;
  RNumber.Top    := 0;
  RNumber.Bottom := 0;
  RSecond.Left   := 0;
  RSecond.Right  := 0;
  RSecond.Top    := 0;
  RSecond.Bottom := 0;
  REvent.Left    := 0;
  REvent.Right   := 0;
  REvent.Top     := 0;
  REvent.Bottom  := 0;
end;

destructor TAirOneEvent.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@ForeGround);
  FreeMem(@ColorTimeline);
  FreeMem(@ColorEvent);
  FreeMem(@Number);
  FreeMem(@Text);
  FreeMem(@Dev);
  FreeMem(@Start);
  FreeMem(@Finish);
  FreeMem(@Duration);
  FreeMem(@Interval);
  FreeMem(@Mix);
  FreeMem(@Rect);
  FreeMem(@ROrder);
  FreeMem(@RNumber);
  FreeMem(@RSecond);
  FreeMem(@REvent);
  inherited;
end;

function TAirOneEvent.Init(cv : tcanvas; tp, hgh, intrv, sz1, sz2, sz3, sz0 : integer) : integer;
begin
  Interval := intrv;

  Rect.Top := tp;
  Rect.Bottom := tp + hgh;
  Rect.Left := cv.ClipRect.Left;
  Rect.Right := cv.ClipRect.Right;

  ROrder.Top := Rect.Top;
  ROrder.Bottom := Rect.Bottom;
  ROrder.Left := cv.ClipRect.Left;
  ROrder.Right := sz1 - 5;

  RNumber.Top := Rect.Top;
  RNumber.Bottom := Rect.Bottom;
  RNumber.Left := sz1;
  RNumber.Right := sz2;

  RSecond.Top := Rect.Top;
  RSecond.Bottom := Rect.Bottom;
  RSecond.Left := sz3;
  RSecond.Right := sz0;

  REvent.Top := Rect.Top;
  REvent.Bottom := Rect.Bottom;
  REvent.Left := sz0;
  REvent.Right := cv.ClipRect.Right;
  result := tp + hgh;
end;

procedure TAirOneEvent.Draw(cv : tcanvas; ps : integer);
var rt : trect;
    stp, str, dlt : longint;
    s : string;
    clb : tcolor;
    hgh : integer;
    brcl, pncl, fncl : tcolor;
    brst : tbrushstyle;
    fnnm : tfontname;
    fnsz, pnwd : integer;
begin
  brcl := cv.Brush.Color;
  pncl := cv.Pen.Color;
  brst := cv.Brush.Style;
  pnwd := cv.Pen.Width;
  fnsz := cv.Font.Size;
  fncl := cv.Font.Color;
  fnnm := cv.Font.Name;

  cv.Brush.Color:=Foreground;
  cv.FillRect(Rect);
  cv.Brush.Color:=smoothcolor(Foreground,5);
  cv.FillRect(REvent);
  cv.Brush.Color:=ColorTimeline;
  cv.Brush.Style:=bsSolid;
  cv.Pen.Color:=ColorTimeline;
  if start < 0 then start:=0;
  rt.Left := REvent.Left + start * TLParameters.FrameSize;;
  rt.Top := REvent.Top;
  rt.Right := REvent.Left + Finish * TLParameters.FrameSize;
  rt.Bottom := REvent.Bottom;
  if Duration > 0 then cv.Rectangle(rt);

  Mix:=50;//Warm*****************

  if Number>= 0 then begin
    if Mix > 0 then begin
      if Mix > Duration then Mix := Duration;
      clb := cv.Brush.Color;
      if ps <> -1 then begin
        cv.Brush.Color := SmoothColor(BackGround,5);
        cv.Polygon([Point(rt.Left,rt.Top), Point(rt.Left,rt.Bottom),
                    Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top)]);
        hgh := rt.Bottom - rt.Top + Interval;
        if ps=0 then begin
          cv.Brush.Color := SmoothColor(ColorTimeline,25);
          cv.Polygon([Point(rt.Left,rt.Top-Interval), Point(rt.Left,rt.Top-hgh),
                  Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top-Interval)]);
        end else begin
          cv.Brush.Color := SmoothColor(ColorTimeline,25);
          cv.Polygon([Point(rt.Left,rt.Top-Interval), Point(rt.Left,rt.Top-hgh),
                  Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top-Interval)]);
        end;
      end else begin
        cv.Brush.Color := SmoothColor(ColorTimeline,56);
        if start=0 then begin
          str:=Duration-Mix;
          if Finish > str then begin
            dlt := (Finish - str) * TLParameters.FrameSize;
            stp := trunc(dlt * ((rt.Bottom-rt.Top) / (Mix * TLParameters.FrameSize)));
            cv.Polygon([Point(rt.Left,rt.Bottom-stp), Point(rt.Left,rt.Bottom),
                    Point(rt.Left + dlt, rt.Bottom)]);
          end;
        end else begin
          cv.Polygon([Point(rt.Left,rt.Top), Point(rt.Left,rt.Bottom),
                    Point(rt.Left + Mix * TLParameters.FrameSize, rt.Bottom)]);
        end;
      end;
      cv.Brush.Color := clb;
    end;

    cv.Brush.Style:=bsClear;
    cv.Font.Color:=ProgrammFontColor;
    cv.Font.Name:=ProgrammFontName;

    s := SecondToShortStr(Round((Finish - Start) / 25));
    cv.Font.Size:=40;
    cv.Font.Size:=DefineFontSizeW(cv,RSecond.Right-RSecond.Left,'0:00');
    cv.TextOut(RSecond.Left, RSecond.Top + (RSecond.Bottom-RSecond.Top-cv.TextHeight('0')) div 2, s);

    s:=inttostr(Number);
    cv.TextOut(ROrder.Right - cv.TextWidth(s)-2, ROrder.Top + (ROrder.Bottom-ROrder.Top-cv.TextHeight('0')) div 2, s);

    cv.Brush.Style:=bsSolid;
    cv.Brush.Color:=ColorEvent;
    cv.Rectangle(RNumber);
    s:=inttostr(Dev+1);
    cv.TextOut(RNumber.Left + (RNumber.Right - RNumber.Left - cv.TextWidth(s)) div 2,
               RNumber.Top + (RNumber.Bottom-RNumber.Top-cv.TextHeight('0')) div 2, s);
  end;

  cv.Brush.Color  :=  brcl;
  cv.Pen.Color    :=  pncl;
  cv.Brush.Style  :=  brst;
  cv.Pen.Width    :=  pnwd;
  cv.Font.Size    :=  fnsz;
  cv.Font.Color   :=  fncl;
  cv.Font.Name    :=  fnnm;
end;

procedure TAirOneEvent.DrawText(cv : tcanvas);
var fncl : tcolor;
    brst : tbrushstyle;
    fnnm : tfontname;
    fnsz : integer;
begin
  brst := cv.Brush.Style;
  fnsz := cv.Font.Size;
  fncl := cv.Font.Color;
  fnnm := cv.Font.Name;
  if Number>= 0 then begin
    cv.Brush.Style:=bsClear;
    cv.Font.Color:=ProgrammFontColor;
    cv.Font.Name:=ProgrammFontName;
    cv.Font.Size:=DefineFontSizeH(cv,REvent.Bottom-REvent.Top - trunc((REvent.Bottom-REvent.Top) / 6));
    //Warning*****************
    cv.TextOut(REvent.Left + 15,REvent.Top + (REvent.Bottom-REvent.Top-cv.TextHeight('0')) div 2, Text);
  end;
  cv.Brush.Style  :=  brst;
  cv.Font.Size    :=  fnsz;
  cv.Font.Color   :=  fncl;
  cv.Font.Name    :=  fnnm;
end;

procedure TAirOneEvent.Clear;
begin
  ColorEvent     := ForeGround;
  Number         := -1;
  Text           := '';
  Dev            := -1;
  Start          := -1;
  Finish         := -1;
  Duration       := -1;
  Mix            := 0;
end;

procedure TAirOneEvent.AssignEvent(ps : integer; curr : boolean);
begin
  ColorEvent := TLZone.TLEditor.Events[ps].Color;
  Number     := ps;
  Text       := '';
  Start := TLZone.TLEditor.Events[ps].Start - TLParameters.Position;
  Finish     := TLZone.TLEditor.Events[ps].Finish - TLParameters.Position;
  Duration   := TLZone.TLEditor.Events[ps].Finish - TLZone.TLEditor.Events[ps].Start;
  Text := TLZone.TLEditor.Events[ps].ReadPhraseText('Text');
  if TLZone.TLEditor.TypeTL=tldevice then begin
    Dev := TLZone.TLEditor.Events[ps].ReadPhraseData('Device'); //WARMING**************
    Mix  := TLZone.TLEditor.Events[ps].ReadPhraseData('Duration');
  end;
end;

//==============================================================================
//=========== Класс TAirSecond рисуем одно событие ===========================
//==============================================================================

Constructor TAirSecond.Create;
begin
  inherited;
  BackGround     :=ProgrammColor;
  ForeGround     :=SmoothColor(ProgrammColor,12);
  Color          := clWhite;
  Start          := -1;
  Finish         := -1;
  Duration       := -1;
  Mix            := 0;
  Rect.Left      := 0;
  Rect.Right     := 0;
  Rect.Top       := 0;
  Rect.Bottom    := 0;
  RTC.Left       := 0;
  RTC.Right      := 0;
  RTC.Top        := 0;
  RTC.Bottom     := 0;
  RSecond.Left   := 0;
  RSecond.Right  := 0;
  RSecond.Top    := 0;
  RSecond.Bottom := 0;
end;

destructor TAirSecond.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@ForeGround);
  FreeMem(@Color);
  FreeMem(@Start);
  FreeMem(@Finish);
  FreeMem(@Duration);
  FreeMem(@Mix);
  FreeMem(@Rect);
  FreeMem(@RTC);
  FreeMem(@RSecond);
  inherited;
end;

function TAirSecond.Init(cv : tcanvas; tp, hgh,  sz0 : integer) : integer;
begin
  Rect.Top := tp;
  Rect.Bottom := tp + hgh;
  Rect.Left := cv.ClipRect.Left;
  Rect.Right := cv.ClipRect.Right;

  RTC.Top := tp;
  RTC.Bottom := tp + hgh;
  RTC.Left := cv.ClipRect.Left;
  RTC.Right := sz0;

  RSecond.Top := tp;
  RSecond.Bottom := tp + hgh;
  RSecond.Left := sz0;
  RSecond.Right := cv.ClipRect.Right;
  result := tp + hgh;
end;

procedure TAirSecond.Draw(cv : tcanvas);
var rt : trect;
    stp, str, dlt : longint;
    clb : tcolor;
    brcl, pncl, fncl : tcolor;
    brst : tbrushstyle;
    fnnm : tfontname;
    fnsz, pnwd : integer;
begin
  brcl := cv.Brush.Color;
  pncl := cv.Pen.Color;
  brst := cv.Brush.Style;
  pnwd := cv.Pen.Width;
  fnsz := cv.Font.Size;
  fncl := cv.Font.Color;
  fnnm := cv.Font.Name;

  cv.Brush.Color:=background;
  cv.FillRect(Rect);
  cv.Brush.Color:=Color;
  cv.Brush.Style:=bsSolid;
  cv.Pen.Color:=Color;
  rt.Top := RSecond.Top;
  rt.Bottom := RSecond.Bottom;

  if start < 0 then start:=0;
  rt.Left := RSecond.Left + Start * TLParameters.FrameSize;;
  rt.Right := RSecond.Left + Finish * TLParameters.FrameSize;

  if Duration > 0 then cv.Rectangle(rt);

  Mix:=50; //Warm*****************

  if Mix > 0 then begin
    cv.Brush.Color := SmoothColor(color,56);
    cv.Pen.Color := SmoothColor(color,56);
    if Mix > Duration then Mix := Duration;
    if start=0 then begin
      str:=Duration-Mix;
      if Finish > str then begin
        dlt := (Finish - str) * TLParameters.FrameSize;
        stp := trunc(dlt * ((rt.Bottom-rt.Top) / (Mix * TLParameters.FrameSize)));
        cv.Polygon([Point(rt.Left,rt.Top + stp), Point(rt.Left,rt.Top), Point(rt.Left + dlt, rt.Top)]);
      end;
    end else begin
      cv.Polygon([Point(rt.Left,rt.Bottom), Point(rt.Left,rt.Top), Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top)]);
    end;
  end;

  cv.Brush.Color  :=  brcl;
  cv.Pen.Color    :=  pncl;
  cv.Brush.Style  :=  brst;
  cv.Pen.Width    :=  pnwd;
  cv.Font.Size    :=  fnsz;
  cv.Font.Color   :=  fncl;
  cv.Font.Name    :=  fnnm;
end;

procedure TAirSecond.DrawSeconds(cv : tcanvas);
var rt : trect;
    stp, str, dlt : longint;
    clp : tcolor;
    pnw : integer;
begin
  clp:=cv.Pen.Color;
  pnw:=cv.Pen.Width;
  stp := 25 * TLParameters.FrameSize;
  str := Rsecond.Left + stp;
  cv.Pen.Color:=BackGround;
  while str < Rsecond.Right do begin
    cv.MoveTo(str,RSecond.Top);
    cv.LineTo(str,RSecond.Bottom);
    str:=str+stp;
  end;
  cv.Pen.Width:=pnw;
  cv.Pen.Color:=clp;
end;

procedure TAirSecond.AssignEvent(ps : integer; curr : boolean);
begin
  Start := TLZone.TLEditor.Events[ps].Start - TLParameters.Position;
  Finish := TLZone.TLEditor.Events[ps].Finish  - TLParameters.Position;
  Duration := TLZone.TLEditor.Events[ps].Finish -TLZone.TLEditor.Events[ps].Start;
  if TLZone.TLEditor.TypeTL=tldevice then Mix  := TLZone.TLEditor.Events[ps].ReadPhraseData('Duration');
end;

//==============================================================================
//=========== Класс TAirEvents список событий ==================================
//==============================================================================

Constructor TAirEvents.Create;
begin
  inherited;
  BackGround :=ProgrammColor;
  ForeGround :=SmoothColor(BackGround,12);
  Interval := 2;
  CurrEvent := TAirOneEvent.Create;
  CurrTime := TAirSecond.Create;
  Count := 0;
end;

destructor TAirEvents.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@ForeGround);
  FreeMem(@Interval);
  FreeMem(@CurrEvent);
  FreeMem(@CurrTime);
  FreeMem(@Count);
  FreeMem(@Events);
  inherited;
end;

function TAirEvents.AddEvent : integer;
begin
  count:=count+1;
  Setlength(Events,Count);
  Events[Count-1] := TAirOneEvent.Create;
  result := Count-1;
end;

procedure TAirEvents.Clear;
var i : integer;
begin
  CurrEvent.Clear;
  CurrTime.Start:=-1;
  CurrTime.Finish:=-1;
  for i:=Count-1 downto 0 do Events[i].FreeInstance;
  Count:=0;
  Setlength(Events,Count);
end;

procedure TAirEvents.Init(cv : tcanvas);
var sz0, sz1, sz2, sz3, szd, hgh, ps, i : integer;
begin
  sz0 := Form1.imgTLNames.Width + TLParameters.MyCursor;
  szd := sz0 div 4 - 5;
  sz3 := sz0 - szd;
  sz2 := sz3 - 5;
  sz1 := sz2 - szd;
  hgh := trunc(((cv.ClipRect.Bottom - cv.ClipRect.Top) - interval * (Count +1)) div (Count + 2));

  ps := CurrEvent.Init(cv, cv.ClipRect.Top, hgh, Interval, sz1, sz2, sz3, sz0);
  ps := ps + interval;
  ps := CurrTime.Init(cv, ps, hgh, sz0);
  ps:=ps + Interval;
  Clear;
  Application.ProcessMessages;
  for i:=0 to RowsEvents-1 do begin
    AddEvent;
    ps := Events[Count-1].Init(cv, ps, hgh, Interval, sz1, sz2, sz3, sz0);
    ps:=ps+Interval;
  end;
end;

procedure TAirEvents.Draw(cv : tcanvas);
var i : integer;
begin
  bmpEvents.Width:=cv.ClipRect.Right-cv.ClipRect.Left;
  bmpEvents.Height:=cv.ClipRect.Bottom-cv.ClipRect.Top;
  bmpEvents.Canvas.Brush.Color:=background;
  bmpEvents.Canvas.FillRect(bmpEvents.Canvas.ClipRect);
  CurrEvent.Draw(bmpEvents.Canvas,-1);
  CurrEvent.DrawText(bmpEvents.Canvas);
  CurrTime.Draw(bmpEvents.Canvas);
  for i:=0 to Count-1 do Events[i].Draw(bmpEvents.Canvas,i);
  for i:=0 to Count-1 do Events[i].DrawText(bmpEvents.Canvas);
  CurrTime.DrawSeconds(bmpEvents.Canvas);
  cv.CopyRect(cv.ClipRect,bmpEvents.Canvas,bmpEvents.Canvas.ClipRect);
end;

procedure  TAirEvents.DrawTimeCode(cv : tcanvas; tc : longint);
var i : integer;
    clb, clf : tcolor;
    fnm : tfontname;
    fsz : integer;
    bst : tbrushstyle;
    s : string;
begin
  clb := cv.Brush.Color;
  clf := cv.Font.Color;
  fnm := cv.Font.Name;
  fsz := cv.Font.Size;
  bst := cv.Brush.Style;
  cv.Brush.Color := Background;
  cv.Font.Color:=ProgrammFontColor;
  cv.Font.Name:=ProgrammFontName;
  cv.Font.Size:=40;
  cv.Font.Size:=DefineFontSizeH(cv,CurrTime.RTC.Bottom - CurrTime.RTC.Top);
  s:=FramesToShortStr(tc);
  cv.TextOut(CurrTime.RTC.Right - cv.TextWidth('00:00:00:00'), CurrTime.RTC.Top +
            (CurrTime.RTC.Bottom - CurrTime.RTC.Top - cv.TextHeight('0')) div 2, s);
  cv.Brush.Color := clb;
  cv.Font.Color  := clf;
  cv.Font.Name   := fnm;
  cv.Font.Size   := fsz;
  cv.Brush.Style := bst;
end;

//==============================================================================
//=========== Класс TRECTDevice рисуем номера устройств ========================
//==============================================================================

Constructor TRectDevice.Create;
begin
  Number :=0;
  Value := -1;
  Text :='';
  Curr := false;
  Next := false;
  Color := ProgrammFontColor;
  Rect.Left := 0;
  Rect.Right:= 0;
  Rect.Top:= 0;
  Rect.Bottom:=0;
end;

Destructor TRectDevice.Destroy;
begin
  FreeMem(@Number);
  FreeMem(@Value);
  FreeMem(@Curr);
  FreeMem(@Next);
  FreeMem(@Text);
  FreeMem(@Color);
  FreeMem(@Rect);
end;

procedure TRectDevice.Draw(cv : tcanvas);
var clb, clp : tcolor;
    bst : TBrushStyle;
    pnw, fns : integer;
    px, py : integer;
    fnm : tfontname;
begin
  clb:=cv.Brush.Color;
  clp:=cv.Pen.Color;
  bst:=cv.Brush.Style;
  pnw:=cv.Pen.Width;
  fnm:=cv.Font.Name;
  fns:=cv.Font.Size;

  cv.Pen.Width:=4;
  cv.Pen.Color:=Color;
  cv.Brush.Style:=bsSolid;
  cv.Brush.Color:=ProgrammColor;
  cv.Font.Color:=ProgrammFontColor;
  if Curr then cv.Brush.Color:=clRed
  else if Next then cv.Brush.Color:=clGreen
  else cv.Brush.Color:=ProgrammColor;

  cv.Rectangle(Rect);
  cv.Brush.Color:=Color;
  cv.Font.Size:=7;
  cv.Rectangle(Rect.Left,Rect.Top,Rect.Left+cv.TextWidth('00'),Rect.Top + cv.TextHeight('0')-2);
  cv.TextOut(Rect.Left+(cv.TextWidth('00') - cv.TextWidth(inttostr(Number))) div 2
                        ,rect.Top-2,inttostr(Number));


  if Curr then cv.Brush.Color:=clRed
  else if Next then cv.Brush.Color:=clGreen
  else cv.Brush.Color:=ProgrammColor;
  cv.Font.Size:=40;
  cv.Font.Size:=DefineFontSizeW(cv, Rect.Right - Rect.Left -20, '000');
  px:=Rect.Left + (Rect.Right-Rect.Left-cv.TextWidth(inttostr(value))) div 2;
  py:=Rect.Top + (Rect.Bottom - Rect.Top-cv.TextHeight('0')) div 2;
  if Value<>-1 then cv.TextOut(px,py,inttostr(value));

  cv.Font.Size:=fns;
  cv.Font.Name:=fnm;
  cv.Pen.Width:=pnw;
  cv.Brush.Style:=bst;
  cv.Brush.Color:=clb;
  cv.Pen.Color:=clp;
end;

//==============================================================================
//=========== Класс TAirDevice рисуем номера устройств =========================
//==============================================================================

Constructor TAIRDevices.Create;
begin
   inherited;
   BackGround := ProgrammColor;
   Rect.Left := 0;
   Rect.Right:= 0;
   Rect.Top:= 0;
   Rect.Bottom:=0;
end;

Destructor  TAIRDevices.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@Rect);
  inherited;
end;

procedure TAIRDevices.Init(cv : tcanvas; grpos : integer);
var i, j1, rw, sz, fsz, hgh, px, py : integer;
    ssz, sz1, sz2 : integer;
begin
  with Form1.GridTimeLines do begin
    ssz := Form1.imgTLNames.Width + TLParameters.MyCursor;
    sz1 := ssz div 4 - 5;
    sz2 := (Form1.ImgDevices.ClientRect.Right - ssz) div 14 -5;
    if sz1 < sz2 then sz:=sz1 else sz:=sz2;
    Rect.Left := ssz - 2 * sz - 5;
    Rect.Right:=Form1.PanelAir.Width;
    Rect.Top:=Form1.ImgDevices.ClientRect.Top;
    Rect.Bottom:=Form1.ImgDevices.ClientRect.Top + Form1.ImgDevices.Height;
    if TLZone.TLEditor.TypeTL<>tldevice then exit;
    Clear;
    if Objects[0,grpos] is TTimelineOptions then begin
      fsz := DefineFontSizeW(cv, sz-20, '000');
      cv.Font.Size:=fsz;
      hgh := (Rect.Bottom - Rect.Top - 20) div 2; //cv.TextHeight('000') + 20;
      if (Objects[0,grpos] as TTimelineOptions).CountDev <= 16 then begin
        py := Rect.Top + (Rect.Bottom - Rect.Top - hgh) div 2;
        px := Rect.Left;
        for i:=0 to (Objects[0,grpos] as TTimelineOptions).CountDev - 1 do begin
          rw:=AddDevice((Objects[0,grpos] as TTimelineOptions).DevColors[i]);
          Devices[rw].Rect.Top:=py;
          Devices[rw].Rect.Bottom:=py + hgh;
          Devices[rw].Rect.Left:=px;
          Devices[rw].Rect.Right:=px + sz;
          px:=Devices[rw].Rect.Right + 5;
        end;
      end else begin
        py :=Rect.Top + 5;//(Rect.Bottom - Rect.Top - 2 * hgh -10) div 2;
        px := Rect.Left;
        for i:=0 to 15  do begin
          rw:=AddDevice((Objects[0,grpos] as TTimelineOptions).DevColors[i]);
          Devices[rw].Rect.Top:=py;
          Devices[rw].Rect.Bottom:=py + hgh;
          Devices[rw].Rect.Left:=px;
          Devices[rw].Rect.Right:=px + sz;
          px:=Devices[rw].Rect.Right + 5;
        end;
        py := py + hgh + 10;
        px := Rect.Left;
        //j1:=(Objects[0,grpos] as TTimelineOptions).CountDev - 16;
        for i:=16 to (Objects[0,grpos] as TTimelineOptions).CountDev - 1 do begin
          rw:=AddDevice((Objects[0,grpos] as TTimelineOptions).DevColors[i]);
          Devices[rw].Rect.Top:=py;
          Devices[rw].Rect.Bottom:=py + hgh;
          Devices[rw].Rect.Left:=px;
          Devices[rw].Rect.Right:=px + sz;
          px:=Devices[rw].Rect.Right + 5;
        end;
      end;
    end;
  end;
end;

procedure TAIRDevices.Draw(cv : tcanvas);
var i : integer;
begin
  cv.Brush.Color:=BackGround;
  cv.FillRect(cv.ClipRect);
  if TLZone.TLEditor.TypeTL<>tldevice then exit;
  //SetValues;
  for i:=0 to Count-1 do Devices[i].Draw(cv);
end;

procedure TAIRDevices.Clear;
var i : integer;
begin
  for i:=Count-1 downto 0 do Devices[i].FreeInstance;
  Count:=0;
  Setlength(Devices,Count);
end;

function TAIRDevices.AddDevice(Color : TColor) : integer;
begin
  count:=count+1;
  Setlength(Devices,count);
  Devices[Count-1] := TRectDevice.Create;
  Devices[Count-1].Color:=Color;
  Devices[Count-1].Number:=Count;
  result := Count-1;
end;

//==============================================================================
//=========== Класс TPanelAir рисуем номера устройствв =========================
//==============================================================================

Constructor TPanelAir.Create;
begin
  inherited;
  AirEvents:=TAirEvents.Create;
  AirDevices:= TAirDevices.Create;
end;

destructor TPanelAir.Destroy;
begin
  AirEvents.Free;
  AirDevices.Free;
  Inherited;
end;

//ПРОЦЕДУРА ОТСЛЕЖИВАЕТ СОСТОЯНИЕ ТАЙМ-ЛИНИЙ
//ТЕРБУЕТСЯ ДОРОБОТКА ПРИ ВОСПРОИЗВЕДЕНИИ ДЛЯ УПРАВЛЕНИЯ УСТРОЙСТВАМИ.

procedure TPanelAir.SetValues;
var i, j, ps, st, ie, cie : integer;
    pred : longint;
    s : string;
begin

  with TLZone do begin
// Если тайм-линия Медиа
    if TLEditor.TypeTL=tlmedia then exit;

// Если текстовая тайм-линия
    if TLEditor.TypeTL=tltext then begin
      AirEvents.CurrEvent.Clear;
      AirEvents.CurrTime.Start:=-1;
      AirEvents.CurrTime.Finish:=-1;
      AirEvents.CurrTime.Duration:=-1;
      For ie:=0 to AirEvents.Count - 1 do AirEvents.Events[ie].Clear;
      if TLEditor.Count<=0 then exit;
      if TLParameters.Position > TLEditor.Events[TLEditor.Count-1].Finish then exit;
      pred := 0;
      for i:=0 to TLEditor.Count-1 do begin
        if (pred < TLParameters.Position) and (TLParameters.Position < TLEditor.Events[i].Finish) then begin
          AirEvents.CurrEvent.AssignEvent(i,true);
          AirEvents.CurrTime.AssignEvent(i,true);
          For j:=i+1 to TLEditor.Count - 1 do begin
            if j-i-1 >= AirEvents.Count then exit;
            AirEvents.Events[j-i-1].AssignEvent(j,false);
          end;
          exit;
        end;
        pred:=TLEditor.Events[i].Finish;
      end;
      exit;
    end;

// Если тайм-линия устройств
    with AirDevices do begin
      for j:=0 to Count-1 do begin
        Devices[j].Value:=-1;
        Devices[j].Curr:=false;
        Devices[j].next:=false;
      end;
      if TLEditor.Count<=0 then exit;
      if TLParameters.Position < TLEditor.Events[0].Start then begin
        ps:=TLEditor.Events[0].ReadPhraseData('Device');
        if AirDevices.Devices[ps].Value=-1 then begin
          AirDevices.Devices[ps].Next:=true;
          AirDevices.Devices[ps].Value:=Round((TLEditor.Events[0].Start - TLParameters.Position) / 25);
          AirEvents.CurrEvent.AssignEvent(0,true);
          AirEvents.CurrTime.AssignEvent(0, true);
          j := 1;
          for i:=1 to TLEditor.Count-1 do begin
            if j <= AirEvents.count then AirEvents.Events[j-1].AssignEvent(i,false);
            ps:=TLEditor.Events[i].ReadPhraseData('Device');
            if AirDevices.Devices[ps].Value=-1 then AirDevices.Devices[ps].Value:=Round((TLEditor.Events[i].Start - TLParameters.Position) / 25);
            j:=j+1;
          end;
        end;
        exit;
      end;

      For i:=0 to TLEditor.Count-1 do begin

        if (TLEditor.Events[i].Start<=TLParameters.Position) and (TLEditor.Events[i].Finish > TLParameters.Position) then begin
          ps:=TLEditor.Events[i].ReadPhraseData('Device');
          if AirDevices.Devices[ps].Value=-1 then begin
            AirDevices.Devices[ps].Curr:=true;
            AirDevices.Devices[ps].Value:=Round((TLEditor.Events[i].Finish - TLParameters.Position) / 25);
            AirEvents.CurrEvent.AssignEvent(i,true);
            AirEvents.CurrTime.AssignEvent(i, true);
            For ie:=0 to AirEvents.Count - 1 do AirEvents.Events[ie].Clear;
            if i + AirEvents.Count < TLEditor.Count then cie:=AirEvents.Count+1 else cie:=TLEditor.Count-i;
            for ie:=i+1 to i + cie -1 do AirEvents.Events[ie-i-1].AssignEvent(ie,false);
            st:=i;
            if i < TLEditor.Count-1 then begin
              ps:=TLEditor.Events[i+1].ReadPhraseData('Device');
              if AirDevices.Devices[ps].Value=-1 then begin
                AirDevices.Devices[ps].next:=true;
                AirDevices.Devices[ps].Value:=Round((TLEditor.Events[i+1].Start - TLParameters.Position) / 25);
                st:=i+1;
                break;
              end;
            end;
            break;
          end;
        end;
      end;
      For i:=st+1 to TLEditor.Count-1 do begin
        ps:=TLEditor.Events[i].ReadPhraseData('Device');
        if AirDevices.Devices[ps].Value=-1 then begin
          AirDevices.Devices[ps].Value:=Round((TLEditor.Events[i].Start - TLParameters.Position-1) / 25);
        end;
      end;
    end;
  end;
end;


procedure TPanelAir.Draw(cv1, cv2 : tcanvas; grpos : integer);
begin
  //SetValues;
  AirEvents.Draw(cv2);
  MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, TLParameters.Position - TLParameters.ZeroPoint);
  AirDevices.Draw(cv1);
end;

initialization

MyPanelAir := TPanelAir.Create;

end.
