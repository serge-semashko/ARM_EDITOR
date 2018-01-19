unit UGRTimelines;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, utimeline, ucommon,
  umyevents;

Type

TEditingArea = (edNone, edStart, edCenter, edFinish);

TTLParameters = Class(TObject)
  public
  BackGround : tcolor;        //Фоновый цвет
  ForeGround : tcolor;        //Цвет пустых тайм-линий
  MaxFrameSize : integer;     //Максимальный размер кадра в пиксилях
  FrameSize : integer;        //Текущий размер кадра
  Start  : longint;           //Позиция курсора начала воспроизведения (кадры)
  Finish : longint;           //Позиция курсора конца воспроизведения (кадры)
  NTK    : longint;           //Начальный тайм код (кадры)
  ZeroPoint : longint;        //Нулевая точка отсчета начальный тайм-код (кадры)
  MyCursor : longint;         //Положение курсора относительно начала экрана (пиксили)
  ScreenStart : longint;      //Относительная позиция начала экрана (пиксили)
  ScreenEnd   : longint;      //Относительная позиция конца экрана (пиксли)
  Preroll   : longint;        //Начальный буффер (кадры)
  Postroll  : longint;        //Конечный буффер (кадры)
  Duration  : longint;        //Общая длителность клипа (кадры)
  EndPoint  : longint;        //Положение конца клипа Preroll+Duration (кадры)
  lrTransperent0 : tcolor;    //Цвет прозрачности для слоя 0
  lrTransperent1 : tcolor;    //Цвет прозрачности для слоя 1
  lrTransperent2 : tcolor;    //Цвет прозрачности для слоя 2
  Position : longint;         //Tекущая позиция клипа (кадры)
  ScreenStartFrame : longint; //Абсолютная позиция начала экрана (кадры)
  ScreenEndFrame : longint;   //Абсолютная позиция конца экрана (кадры)
  StopPosition : longint;     //Позиция остановки клип (кадры)
  Scaler : real;              //Отношение ширины Bitmap к ширине экрана
  procedure InitParameters;
  procedure UpdateParameters;
  procedure SetScreenBoanders;
  Procedure WriteToStream(F : tStream);
  Procedure ReadFromStream(F : tStream);
  Constructor Create;
  Destructor Destroy; override;
end;

TTLScaler = Class(TObject)
  public
  PenColor : tcolor;
  FontColor : tcolor;
  FontSize : integer;
  FontName : tfontname;
  Rect   : TRect;
  procedure DrawScaler(cv : tcanvas);
  Procedure WriteToStream(F : tStream);
  Procedure ReadFromStream(F : tStream);
  Constructor Create;
  Destructor Destroy; override;
end;

TTLTimeline = Class(TObject)
  public
  IDTimeline : longint;
  TypeTL :  TTypeTimeline;
  Rect : TRect;
  Count : integer;
  Events : Array of TMyEvent;

  function AddEvent(Position : longint; psgrd, psclr : integer) : integer;
  function FindEventID(IdEvent : Longint) : integer;
  function FindEvent(Position : longint) : integer;
  procedure Delete(Position : longint);
  procedure DeleteID(IdEvent : longint);
  procedure Clear;
  procedure Assign(ListEvents : TTLTimeline);
  Procedure DrawDeviceTimeline(cv : tcanvas);
  Procedure DrawTextTimeline(cv : tcanvas);
  Procedure DrawMediaTimeline(cv : tcanvas; Color : tcolor);
  procedure DrawTimeline(cv : tcanvas; NomTl : integer);
  Procedure WriteToStream(F : tStream);
  Procedure ReadFromStream(F : tStream);
  Constructor Create;
  Destructor Destroy; override;
end;

TTLEditor = Class(TObject)
  public
  Index   : integer;
  isZoneEditor : boolean;
  DoubleClick : boolean;
  IDTimeline : longint;
  TypeTL :  TTypeTimeline;
  Rect       : TRect;
  Count : integer;
  Events : Array of TMyEvent;
  function AddEvent(Position : longint; psgrd, psclr : integer) : integer;
  function InsertDevice(Position : longint) : integer;
  function InsertText(Position : longint) : integer;
  function InsertMarker(Position : longint) : integer;
  procedure Clear;
  procedure DeleteEvent(Position : longint);
  procedure Assign(ttl : TTLTimeline; Indx : integer);
  procedure ReturnEvents(ttl : TTLTimeline);
  procedure DrawEditorDevice(cv : tcanvas);
  procedure DrawEditorDeviceEvent(evnt: tmyevent; cv : tcanvas; TLRect : Trect; lr : boolean);
  procedure DrawEditorTextEvent(evnt: tmyevent; cv : tcanvas; TLRect : Trect; lr : boolean);
  procedure DrawEditorMediaEvent(evnt: tmyevent; cv : tcanvas; TLRect : Trect; lr : boolean);
  procedure DrawEditorText(cv : tcanvas);
  procedure DrawEditorMedia(cv : tcanvas);
  procedure DrawEditor(cv : tcanvas);
  procedure MouseClick(cv : tcanvas; X,Y : integer);
  procedure MouseMove(cv : tcanvas; X,Y : integer);
  procedure UpdateEventData(ev : TMyEvent);
  function FindEventPos(evframe : longint) : integer;
  function CurrentEvents : integer;
  procedure AllSelectFalse;
  procedure EventsSelectFalse;
  Procedure WriteToStream(F : tStream);
  Procedure ReadFromStream(F : tStream);
  Constructor Create;
  Destructor Destroy; override;
end;

TTLZone = Class(TObject)
  private
   Countbuffer : integer;
   TLBuffer : array of TTLTimeline;
   DownTimeline : boolean;
   DownEditor : boolean;
   DownScaler : boolean;
   XDown : integer;
   CRStart : tcolor;
   CRStartDown : boolean;
   CREnd : tcolor;
   CREndDown : boolean;
  public
  TLScaler : TTLScaler;
  TLEditor : TTLEditor;
  Count : integer;
  Timelines : array of TTLTimeline;
  //Procedure DrawLayer1;
  procedure ClearBuffer;
  procedure WriteToBuffer;
  function FindInBuffer(ID : longint) : integer;
  Procedure DownZoneTimeLines(cv : tcanvas; Button: TMouseButton; Shift: TShiftState;  X, Y : integer);
  Procedure MoveMouseTimeline(cv : tcanvas; Shift: TShiftState; X, Y : integer);
  Procedure UPZoneTimeline(cv : tcanvas; Button: TMouseButton; Shift: TShiftState; X, Y : integer);
  Procedure AddTimeline(ID : Longint);
  function FindTimeline(ID : Longint) : integer;
  Procedure InitTimelines(bmp : tbitmap);
  procedure ClearTimeline;
  Procedure DrawLayer2(cv : tcanvas);
  Procedure PositionToLayer2(cv : tcanvas);
  Procedure DrawBitmap(bmp : Tbitmap);
  function PlusHoriz : integer;
  function MinusHoriz : integer;
  Procedure DrawTimelines(cv : tcanvas; bmp: tbitmap);
  procedure DrawCursorStart(cv : tcanvas);
  function MouseInStartCursor(cv : tcanvas; X,Y : integer) : boolean;
  function MouseInEndCursor(cv : tcanvas; X,Y : integer) : boolean;
  //procedure SetBoinders(cv : tcanvas; bmp: tbitmap);
  procedure DrawCursorEnd(cv : tcanvas);
  Procedure SetEditingEventDevice;
  Procedure SetEditingEventText;
  Procedure SetEditingEventMedia;
  Procedure WriteToStream(F : tStream);
  Procedure ReadFromStream(F : tStream);
  procedure ClearZone;
  Constructor Create;
  Destructor Destroy; override;
end;

Var TLZone : TTLZone;
    TLParameters : TTLParameters;

    EditingEvent : integer = -1;
    EditingArea  : TEditingArea;
    EditingStart : longint;
    EditingFinish : longint;


implementation
uses umain, uinitforms, uimgbuttons, udrawtimelines, uplayer,  UAirDraw,
     usettemplate, ugrid, USetEventData, umyfiles;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//процедуры и функции для отрисовки зоны курсоров
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TTLZone.DrawCursorStart(cv : tcanvas);
var hgh : integer;
    rt, rte : trect;
    s : string;
    ps, st : longint;
    cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;

  cv.Lock;
  try
  with form1 do begin
    TLParameters.SetScreenBoanders;
    cv.FillRect(cv.ClipRect);
    if TLParameters.Start < TLParameters.ScreenStartFrame then exit;
    if TLParameters.Start > TLParameters.ScreenEndFrame then exit;
    if TLParameters.Finish <= TLParameters.Start then TLParameters.Start:=TLParameters.Finish - TLParameters.FrameSize;
    cv.FillRect(cv.ClipRect);
    cv.Pen.Color:=CRStart;
    ps := (TLParameters.Start - TLParameters.ScreenStartFrame) * TLParameters.FrameSize;// -1;
    cv.Brush.Style:=bsSolid;
    cv.MoveTo(ps,0);
    cv.LineTo(ps,TLHeights.Height - TLHeights.Review);
    cv.Brush.Color:=CRStart;
    //cv.Brush.Style:=bsSolid;

    cv.Polygon([Point(ps, 0), Point(ps, TLHeights.Scaler), Point(ps + 10, TLHeights.Scaler div 2)]);
    rt.Left:=0;
    rt.Top:=0;
    rt.Right:=ps;
    rt.Bottom:=TLHeights.Height - TLHeights.Review;
    cv.CopyRect(rt,imgTimelines.Canvas,rt);

    if (EditingEvent<> -1) and (EditingArea<>edCenter) then begin
      if EditingStart<ps then begin
        rte.Top:=TLEditor.Rect.Top;
        rte.Bottom:=TLEditor.Rect.Bottom;
        rte.Left := EditingStart;
        if EditingFinish > ps then rte.Right:=ps else rte.Right:= EditingFinish;
        cv.Brush.Style:=bsClear;
        cv.CopyRect(rte,imgLayer0.Canvas,rte);
        cv.Brush.Style:=bsSolid;
      end;
    end;
    cv.Pen.Mode:=pmMerge;
    cv.Brush.Color:=SmoothColor(clBlack,20);
    cv.Pen.Color:=SmoothColor(clBlack,20);
    cv.Rectangle(rt);
    cv.Brush.Style:=bsClear;
    //TLParameters.Start:=ps;
    cv.Pen.Mode:=pmCopy;
    cv.Font.Color:=SmoothColor(clWhite,8);
    s:=FramesToShortStr(TLParameters.Start);
    cv.TextOut(ps-cv.TextWidth(s)-2,(TLHeights.Scaler-cv.TextHeight(s)) div 2, s);
  end;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
  finally
    cv.Unlock;
  end;
end;

procedure TTLZone.ClearZone;
begin
  ClearBuffer;
  ClearTimeline;
  TLEditor.Clear;
end;

procedure TTLZone.DrawCursorEnd(cv : tcanvas);
var hgh : integer;
    rt, rte : trect;
    s : string;
    ps : longint;
    cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;
  cv.Lock;
  try
  with form1 do begin
    TLParameters.SetScreenBoanders;
    if TLParameters.Finish < TLParameters.ScreenStartFrame then exit;
    if TLParameters.Finish > TLParameters.ScreenEndFrame then exit;
    if TLParameters.Finish <= TLParameters.Start then TLParameters.Start:=TLParameters.Finish - TLParameters.FrameSize;
    cv.Pen.Color:=CREnd;
    ps := (TLParameters.Finish - TLParameters.ScreenStartFrame) * TLParameters.FrameSize;
    cv.Brush.Style:=bsSolid;
    cv.MoveTo(ps,0);//TLHeights.Scaler);
    cv.LineTo(ps,TLHeights.Height - TLHeights.Review);
    cv.Brush.Color:=CREnd;

    cv.Polygon([Point(ps, 0), Point(ps, TLHeights.Scaler), Point(ps - 10, TLHeights.Scaler div 2)]);
    rt.Left:=ps;//cv.ClipRect.Left;
    rt.Top:=0;//cv.ClipRect.Top;
    rt.Right:=cv.ClipRect.Right;
    rt.Bottom:=TLHeights.Height - TLHeights.Review;
    cv.CopyRect(rt,imgTimelines.Canvas,rt);

    if (EditingEvent<> -1) and (EditingArea<>edCenter) then begin
      if (EditingStart>=ps) or (EditingFinish > ps) then begin
        rte.Top:=TLEditor.Rect.Top;
        rte.Bottom:=TLEditor.Rect.Bottom;
        if EditingStart >= ps then  rte.Left := EditingStart else rte.Left := ps;
        rte.Right:=EditingFinish;
        cv.Brush.Style:=bsClear;
        cv.CopyRect(rte,imgLayer0.Canvas,rte);
        cv.Brush.Style:=bsSolid;
      end;
    end;

    cv.Pen.Mode:=pmMerge;
    cv.Brush.Color:=SmoothColor(clBlack,20);
    cv.Pen.Color:=SmoothColor(clBlack,20);
    cv.Rectangle(rt);
    cv.Brush.Style:=bsClear;
    s:=FramesToShortStr(TLParameters.Finish);
    cv.TextOut(ps + 2,(TLHeights.Scaler-cv.TextHeight(s)) div 2, s);
  end;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
  finally
    cv.Unlock;
  end;
end;

function TTLZone.MouseInStartCursor(cv : tcanvas; X,Y : integer) : boolean;
var ps : longint;
begin
  result:=false;
  ps:=(TLParameters.Start - TLParameters.ScreenStartFrame) * TLParameters.FrameSize;
  if (X>=ps-2) and (X<=ps+8) then result:=true;
end;

function TTLZone.MouseInEndCursor(cv : tcanvas; X,Y : integer) : boolean;
var ps : longint;
begin
  result:=false;
  ps:=(TLParameters.Finish - TLParameters.ScreenStartFrame) * TLParameters.FrameSize;
  if (X>=ps-8) and (X<=ps+1) then result:=true;
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Вспомогательные процедуры и функции для отрисовки зоны тайм-линий
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure DrawZoneTimeline(cv : tcanvas; Rect : TRect);
var rt : trect;
begin
  cv.Brush.Color:=SmoothColor(TLParameters.Foreground,32);
  rt.Left:=Rect.Left;
  rt.Right:=Rect.Left + TLParameters.Preroll*TLParameters.FrameSize;
  rt.Top:=Rect.Top;
  rt.Bottom:=Rect.Bottom;
  cv.FillRect(rt);
  cv.Brush.Color:=TLParameters.Foreground;
  rt.Left:=rt.Right;
  rt.Right:=rt.Right + TLParameters.Duration*TLParameters.FrameSize;
  cv.FillRect(rt);
  cv.Brush.Color:=SmoothColor(TLParameters.Foreground,32);
  rt.Left:=rt.Right;
  rt.Right:=Rect.Right;
  cv.FillRect(rt);
end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Класс TTLParametrs отвечает за параметры отрисовки зоны тайм-линий
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLParameters.Create;
begin
  inherited;
  Background := TLBackGround;;
  Foreground := SmoothColor(TLZoneNamesColor,16);
  MaxFrameSize := 10;
  FrameSize :=5;
  Start  :=0;
  Finish :=0;
  MyCursor :=100;
  ScreenStart :=0;
  ScreenEnd   :=0;
  Preroll  := 250;
  Postroll := 250;
  Duration := 750;
  NTK := 0;
  lrTransperent0 := clWhite;
  lrTransperent1 := clWhite;
  lrTransperent2 := clWhite;
  Position := 257;
  ScreenStartFrame := 0;
  ScreenEndFrame := 0;
  ZeroPoint := 0;
  StopPosition := 0;
  EndPoint :=Preroll + Duration;
  Scaler :=1;
end;

Destructor TTLParameters.Destroy;
begin
  FreeMem(@Background);
  FreeMem(@Foreground);
  FreeMem(@MaxFrameSize);
  FreeMem(@FrameSize);
  FreeMem(@Start);
  FreeMem(@Finish);
  FreeMem(@MyCursor);
  FreeMem(@ScreenStart);
  FreeMem(@ScreenEnd);
  FreeMem(@Preroll);
  FreeMem(@Postroll);
  FreeMem(@Duration);
  FreeMem(@lrTransperent0);
  FreeMem(@lrTransperent1);
  FreeMem(@lrTransperent2);
  FreeMem(@Position);
  FreeMem(@Scaler);
  FreeMem(@NTK);
  FreeMem(@StopPosition);
  FreeMem(@ScreenStartFrame);
  FreeMem(@ScreenEndFrame);
  FreeMem(@ZeroPoint);
  FreeMem(@EndPoint);
  inherited;
end;

procedure TTLParameters.SetScreenBoanders;
begin
  TLParameters.ScreenStart := TLParameters.Position * TLParameters.FrameSize - TLParameters.MyCursor;
  TLParameters.ScreenEnd := TLParameters.ScreenStart + Form1.imgTimelines.Width;
  TLParameters.ScreenStartFrame:=Round(TLParameters.ScreenStart / TLParameters.FrameSize);
  TLParameters.ScreenEndFrame:=Round(TLParameters.ScreenEnd / TLParameters.FrameSize);
end;

procedure TTLParameters.InitParameters;
begin
  ZeroPoint:=Preroll + NTK;
  EndPoint := Preroll + Duration;
  Start  :=ZeroPoint;
  Finish :=EndPoint;
  Position := ZeroPoint;
  SetScreenBoanders;
end;

procedure TTLParameters.UpdateParameters;
begin
  ZeroPoint:=Preroll + NTK;
  EndPoint := Preroll + Duration;
  SetScreenBoanders;
end;

Procedure TTLParameters.WriteToStream(F : tStream);
begin
  F.WriteBuffer(BackGround, SizeOf(tcolor));
  F.WriteBuffer(ForeGround, SizeOf(tcolor));
  F.WriteBuffer(MaxFrameSize, SizeOf(integer));
  F.WriteBuffer(FrameSize, SizeOf(integer));
  F.WriteBuffer(Start, SizeOf(longint));
  F.WriteBuffer(Finish, SizeOf(longint));
  F.WriteBuffer(NTK, SizeOf(longint));
  F.WriteBuffer(ZeroPoint, SizeOf(longint));
  F.WriteBuffer(MyCursor, SizeOf(longint));
  F.WriteBuffer(ScreenStart, SizeOf(longint));
  F.WriteBuffer(ScreenEnd, SizeOf(longint));
  F.WriteBuffer(Preroll, SizeOf(longint));
  F.WriteBuffer(Postroll, SizeOf(longint));
  F.WriteBuffer(Duration, SizeOf(longint));
  F.WriteBuffer(EndPoint, SizeOf(longint));
  F.WriteBuffer(lrTransperent0, SizeOf(tcolor));
  F.WriteBuffer(lrTransperent1, SizeOf(tcolor));
  F.WriteBuffer(lrTransperent2, SizeOf(tcolor));
  F.WriteBuffer(Position, SizeOf(longint));
  F.WriteBuffer(ScreenStartFrame, SizeOf(longint));
  F.WriteBuffer(ScreenEndFrame, SizeOf(longint));
  F.WriteBuffer(StopPosition, SizeOf(longint));
  F.WriteBuffer(Scaler, SizeOf(real));
end;

Procedure TTLParameters.ReadFromStream(F : tStream);
begin
  F.ReadBuffer(BackGround, SizeOf(tcolor));
  F.ReadBuffer(ForeGround, SizeOf(tcolor));
  F.ReadBuffer(MaxFrameSize, SizeOf(integer));
  F.ReadBuffer(FrameSize, SizeOf(integer));
  F.ReadBuffer(Start, SizeOf(longint));
  F.ReadBuffer(Finish, SizeOf(longint));
  F.ReadBuffer(NTK, SizeOf(longint));
  F.ReadBuffer(ZeroPoint, SizeOf(longint));
  F.ReadBuffer(MyCursor, SizeOf(longint));
  F.ReadBuffer(ScreenStart, SizeOf(longint));
  F.ReadBuffer(ScreenEnd, SizeOf(longint));
  F.ReadBuffer(Preroll, SizeOf(longint));
  F.ReadBuffer(Postroll, SizeOf(longint));
  F.ReadBuffer(Duration, SizeOf(longint));
  F.ReadBuffer(EndPoint, SizeOf(longint));
  F.ReadBuffer(lrTransperent0, SizeOf(tcolor));
  F.ReadBuffer(lrTransperent1, SizeOf(tcolor));
  F.ReadBuffer(lrTransperent2, SizeOf(tcolor));
  F.ReadBuffer(Position, SizeOf(longint));
  F.ReadBuffer(ScreenStartFrame, SizeOf(longint));
  F.ReadBuffer(ScreenEndFrame, SizeOf(longint));
  F.ReadBuffer(StopPosition, SizeOf(longint));
  F.ReadBuffer(Scaler, SizeOf(real));
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Класс TTLTimeline отвечает за отрисовку области шкалы времени
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLTimeline.Create;
begin
  inherited;
  IDTimeline := -1;
  TypeTL := tldevice;
  Rect.Left:=0;
  Rect.Right:=0;
  Rect.Top:=0;
  Rect.Bottom:=0;
  Count:=0;
end;

Destructor TTLTimeline.Destroy;
begin
  FreeMem(@IDTimeline);
  Freemem(@TypeTL);
  FreeMem(@Rect);
  FreeMem(@Count);
  FreeMem(@Events);
  inherited;
end;

function TTLTimeline.AddEvent(Position : longint; psgrd, psclr : integer) : integer;
begin
  count:=count+1;
  setlength(Events,count);
  Events[Count-1] := TMyEvent.Create;
  //Events[Count-1].Color:=(Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).DevColors[psclr];
  //Events[Count-1]:=(Form1.GridTimeLines.Objects[0,psgrid] as TTimelineOptions).DevColors[psclr];
  Events[Count-1].Start:=Position;
  Result:=Count-1;
end;

function TTLTimeline.FindEventID(IdEvent : Longint) : integer;
var i : integer;
begin
  result:=-1;
  for i:=0 to Count-1 do begin
    if Events[i].IDEvent=IDEvent then begin
      result:=i;
      exit;
    end;
  end;
end;

function TTLTimeline.FindEvent(Position : Longint) : integer;
var i : integer;
begin
  result:=-1;
  for i:=0 to Count-1 do begin
    if (Events[i].Start>=Position) and (Position < Events[i].Finish) then begin
      result:=i;
      exit;
    end;
  end;
end;

procedure TTLTimeline.DeleteID(IDEvent : longint);
var i, ps : integer;
begin
  ps:=FindEventID(IDEvent);
  if ps=-1 then exit;
  if ps=count-1 then begin
     Events[ps].FreeInstance;
     Count:=Count-1;
     setlength(Events,count);
     exit;
   end;
   for i:= ps to count-2 do Events[i].Assign(Events[i+1]);
   Events[Count-1].FreeInstance;
   Count:=Count-1;
   setlength(Events,count);
end;

procedure TTLTimeline.Delete(Position : longint);
var i, ps : integer;
begin
  ps:=FindEvent(Position);
  if ps=-1 then exit;
  if ps=count-1 then begin
     Events[ps].FreeInstance;
     Count:=Count-1;
     setlength(Events,count);
     exit;
   end;
   for i:= ps to count-2 do Events[i].Assign(Events[i+1]);
   Events[Count-1].FreeInstance;
   Count:=Count-1;
   setlength(Events,count);
end;

procedure TTLTimeline.Clear;
var i : integer;
begin
  For i:=Count-1 downto 0 do begin
    Events[i].Clear;
    Events[i].FreeInstance;
  end;
  Count:=0;
  Setlength(Events,Count);
end;

procedure TTLTimeline.Assign(ListEvents : TTLTimeline);
var i : integer;
begin
  IDTimeline := ListEvents.IDTimeline;
  TypeTL := ListEvents.TypeTL;
  Clear;
  for i:=0 to ListEvents.Count-1 do begin
    Count:=Count+1;
    Setlength(Events,Count);
    Events[Count-1] := TMyEvent.Create;
    Events[Count-1].Assign(ListEvents.Events[i]);
  end;
end;

Procedure TTLTimeline.DrawDeviceTimeline(cv : tcanvas);
var i, rw, pfr, st, xp, yp, arglen: integer;
    rt, rtfr : trect;
    cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;

  for i:=0 to Count - 1 do begin
    Events[i].SetRectAreas(tldevice);
    rt.Right:=Rect.Left + Events[i].Finish * TLparameters.FrameSize;;
    rt.Top:=Rect.Top+8;
    rt.Bottom:=rect.Bottom-2;
    rt.Left:=Rect.Left + Events[i].Start * TLparameters.FrameSize;

    cv.Brush.Style:=bsSolid;
    cv.Brush.Color:=Events[i].Color;
    cv.FillRect(rt);

    cv.Brush.Color:=SmoothColor(Events[i].Color,16);
    cv.Pen.Color:=SmoothColor(Events[i].Color,32);

    if Events[i].PhraseIsVisible('Duration') then begin
      arglen := Events[i].ReadPhraseData('Duration') * TLparameters.FrameSize;
      if arglen > rt.Right-rt.Left then arglen := rt.Right-rt.Left;
      cv.Polygon([Point(rt.Left, rt.Top+1), Point(rt.Left, rt.Bottom-1),
                Point(rt.Left + arglen, rt.Bottom-1)]);
    end;
    cv.Font.Size:=Events[i].FontSize-2;
    cv.Font.Name:=Events[i].FontName;
    cv.Font.Color:=Events[i].FontColor;

    for pfr := 0 to Events[i].Rows[0].Count-1 do begin
      xp := rt.Left + Events[i].Rows[0].Phrases[pfr].Rect.Left;
      yp := rt.Top + (rt.Bottom-rt.Top - cv.TextHeight('0')) div 2;//Events[i].Rows[0].Phrases[pfr].Rect.Top;
      cv.Brush.Style:=bsClear;
      rtfr.Left:=rt.Left+Events[i].Rows[0].Phrases[pfr].Rect.Left;
      rtfr.Top:=rt.Top + Events[i].Rows[0].Phrases[pfr].Rect.Top;
      rtfr.Right:=rt.Left + Events[i].Rows[0].Phrases[pfr].Rect.Right;
      if (rw=0) or (rtfr.Right > rt.Right) then rtfr.Right:=rt.Right - Events[i].SafeZone;
      rtfr.Bottom:=rt.Top + Events[i].Rows[0].Phrases[pfr].Rect.Bottom;
      cv.TextRect(rtfr,xp, yp, Events[i].Rows[0].Phrases[pfr].Text);
    end;
  end;

  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLTimeline.DrawTextTimeline(cv : tcanvas);
var rt, rts : trect;
    txt : string;
    i, cnt, stp, ps : integer;
    cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;

    ps:= TLZone.FindTimeline(IDTimeline);
    rt.Top:=Rect.Top+3;
    rt.Bottom:=Rect.Bottom-3;
    for i:=0 to Count-1 do begin
      rt.Left:=Rect.Left + Events[i].Start * TLParameters.FrameSize;
      rt.Right:=Rect.Left + Events[i].Finish * TLParameters.FrameSize;
      cv.Brush.Style:=bsClear;
      cv.Brush.Color:=(Form1.GridTimeLines.Objects[0,ps + 1] as TTimelineOptions).TextColor;
      cv.FillRect(rt);

      cv.Font.Color:=Events[i].FontColor;
      cv.Font.Size:= Events[i].FontSize;

      txt := Events[i].ReadPhraseText('Text');
      rts.Top:=rt.Top+2;
      rts.Bottom:=rt.Bottom - 2;
      rts.Left:=rt.Left;
      rts.Right:=rt.Right;

      MyTextRect(cv, rts, txt);

      cv.Brush.Color:=SmoothColor(clBlack,24);
      cv.Pen.Color:=SmoothColor(clBlack,24);
      rts.Top:=rt.Top+4;
      rts.Bottom:=rt.Bottom-4;
      rts.Left:=rt.Left;
      rts.Right:=rt.Left + Events[i].SafeZone;
      cv.Pen.Mode:=pmMerge;
      cv.Rectangle(rts);

      rts.Right:=rt.Right;
      rts.Left:=rt.Right - Events[i].SafeZone;
      cv.Rectangle(rts);
    end;

  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

Procedure TTLTimeline.DrawMediaTimeline(cv : tcanvas; Color : tcolor);
var rt, rtfr : trect;
    txt : string;
    i, rw, pfr, tp, hgh, yp, xp, fsz, psx : integer;
    cfn, cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;
  cfn := cv.Font.Color;

  rt.Right:=Rect.Left + TLparameters.EndPoint * TLparameters.FrameSize;;
  rt.Top:=Rect.Top+4;
  rt.Bottom:=rect.Bottom-3;
  rt.Left:=Rect.Left + TLParameters.Preroll * TLparameters.FrameSize;
  cv.Brush.Style:=bsSolid;
  cv.Brush.Color:=Color;
  cv.FillRect(rt);

  cv.Font.Color:=TLZoneNamesFontColor;
  cv.Font.Size:=TLZoneNamesFontSize-4;
  txt := extractfilename(Form1.lbPlayerFile.Caption);
  cv.TextOut(rt.Left + 5, rt.Top + (rt.Bottom-rt.Top-cv.TextHeight(txt)) div 2 ,txt);

  for i:=0 to count-1 do begin
    cv.Brush.Style:=bsSolid;
    cv.Pen.Color:=Events[i].FontColor;
    psx := Events[i].Start * TLParameters.FrameSize;
    cv.MoveTo(psx, rt.Top);
    cv.LineTo(psx, rt.Bottom);
    cv.Brush.Color:=Events[i].FontColor;
    cv.Polygon([Point(psx, rt.Top), Point(psx + 5, rt.Top+10), Point(psx, rt.Top+20)]);
    cv.Font.Color:=Events[i].FontColor;
    cv.Font.Name := Events[i].FontName;
    hgh := (rt.Bottom-rt.Top) div Events[i].Count;
    for rw := 0 to Events[i].Count-1 do begin
      tp:= rt.Top + rw * hgh;
      yp := tp;
      for pfr := 0 to Events[i].Rows[rw].Count-1 do begin
        xp := psx + Events[i].SafeZone;
        cv.Brush.Style:=bsClear;
        rtfr.Left:=psx+10;
        rtfr.Top:=tp;
        rtfr.Right:=rtfr.Left + Events[i].Rows[rw].Phrases[pfr].Rect.Right;
        rtfr.Bottom:=tp + hgh;
        fsz:=DefineFontSizeH(cv, rtfr.Bottom - rtfr.Top);
        if fsz < 6 then cv.Font.Size:=6 else cv.Font.Size:=fsz;
        cv.TextOut(xp, yp, Events[i].Rows[rw].Phrases[pfr].Text);
      end;
      tp:=hgh+1
    end;
  end;

  cv.Font.Color   := cfn;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLTimeline.DrawTimeline(cv : tcanvas; NomTl : integer);
var i, rw, pfr, st, xp, yp: integer;
    rt : trect;
begin
  DrawZoneTimeline(cv, Rect);
          case TypeTL of
  tldevice : DrawDeviceTimeline(cv);
  tltext   : DrawTextTimeline(cv);
  tlmedia  : DrawMediaTimeline(cv, (Form1.GridTimeLines.Objects[0,NomTL + 1] as TTimelineOptions).MediaColor);
          end;//
end;

Procedure TTLTimeline.WriteToStream(F : tStream);
var i : integer;
begin
  F.WriteBuffer(IDTimeline, SizeOf(longint));
  i:=ord(TypeTL);
  F.WriteBuffer(i, SizeOf(integer));
  //TypeTL :  TTypeTimeline;
  F.WriteBuffer(Rect.Top, SizeOf(integer));
  F.WriteBuffer(Rect.Bottom, SizeOf(integer));
  F.WriteBuffer(Rect.Left, SizeOf(integer));
  F.WriteBuffer(Rect.Right, SizeOf(integer));
  F.WriteBuffer(Count, SizeOf(integer));
  for i:=0 to Count-1 do Events[i].WriteToStream(F);
end;

Procedure TTLTimeline.ReadFromStream(F : tStream);
var i : integer;
begin
  F.ReadBuffer(IDTimeline, SizeOf(longint));
  i:=ord(TypeTL);
  F.ReadBuffer(i, SizeOf(integer));
  TypeTL :=  SetTypeTimeline(i);
  F.ReadBuffer(Rect.Top, SizeOf(integer));
  F.ReadBuffer(Rect.Bottom, SizeOf(integer));
  F.ReadBuffer(Rect.Left, SizeOf(integer));
  F.ReadBuffer(Rect.Right, SizeOf(integer));
  clear;
  F.ReadBuffer(Count, SizeOf(integer));
  for i:=0 to Count-1 do begin
    Setlength(Events,i+1);
    Events[i] := TMyEvent.Create;
    Events[i].ReadFromStream(F);
  end;
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Класс TTLEditor отвечает за отрисовку области редактирование тайм-линий
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLEditor.Create;
begin
  inherited;
  Index := 0;
  isZoneEditor:=false;
  DoubleClick:=false;
  IDTimeline := -1;
  TypeTL := tldevice;
  Rect.Left:=0;
  Rect.Right:=0;
  Rect.Top:=0;
  Rect.Bottom:=0;
  Count := 0;
end;

Destructor TTLEditor.Destroy;
begin
  FreeMem(@Index);
  FreeMem(@isZoneEditor);
  FreeMem(@DoubleClick);
  FreeMem(@IDTimeline);
  FreeMem(@TypeTL);
  FreeMem(@Rect);
  FreeMem(@Count);
  FreeMem(@Events);
  inherited;
end;

Procedure TTLEditor.Clear;
var i : integer;
begin
  For i:=Count-1 downto 0 do begin
    Events[i].Clear;
    Events[i].FreeInstance;
  end;
  Count:=0;
  Setlength(Events,Count);
end;

Procedure TTLEditor.DeleteEvent(Position : longint);
var i : integer;
    start : longint;
    finish : longint;
begin
  start := Events[Position].Start;
  finish := Events[Position].Finish;
  For i:=Position to Count-2 do begin
    Events[i].Assign(Events[i+1]);
  end;
  Events[Count-1].Clear;
  Events[Count-1].FreeInstance;
  Count:=Count-1;
  Setlength(Events,Count);
  if Count=0 then exit;
  if Position=0 then exit;
  if (TypeTL =tlText) or (TypeTL = tlmedia) then exit;
  Events[Position].Start:=start;
  if (Position>=Count-1) then begin
    Events[Count-1].Finish:=TLParameters.Finish;
    exit;
  end;

end;

Procedure TTLEditor.Assign(ttl : TTLTimeline; Indx : integer);
var i : integer;
begin
  IDTimeline:=ttl.IDTimeline;
  TypeTL:=ttl.TypeTL;
  Index:=Indx;
  Clear;
  for i:=0 to ttl.Count-1 do begin
    Count:=Count+1;
    Setlength(Events,Count);
    Events[Count-1] := TMyEvent.Create;
    Events[Count-1].Assign(ttl.Events[i]);
  end;
end;

procedure TTLEditor.ReturnEvents(ttl : TTLTimeline);
var i : integer;
begin
  ttl.Clear;
  for i:=0 to Count-1 do begin
    ttl.Count:=ttl.Count+1;
    Setlength(ttl.Events,ttl.Count);
    ttl.Events[ttl.Count-1] := TMyEvent.Create;
    ttl.Events[ttl.Count-1].Assign(Events[i]);
  end;
end;

function TTLEditor.InsertDevice(Position : longint) : integer;
var i, rw : integer;
begin
  if Count=0 then begin
    count:=count+1;
    setlength(Events,count);
    Events[Count-1] := TMyEvent.Create;
    Events[Count-1].Assign(EventDevice);
    Events[Count-1].Start := Position;
    Events[Count-1].Finish := TLParameters.Finish;//.Preroll+TLParameters.Duration+TLParameters.Postroll;
    Events[Count-1].Select := false;
    Result:=0;
    exit;
  end;

  if Position < Events[0].Start then begin
    count:=count+1;
    setlength(Events,count);
    Events[Count-1] := TMyEvent.Create;
    for i:=Count-1 downto 1 do Events[i].Assign(Events[i-1]);
    //Events[Count-1].Assign(Events[0]);
    Events[0].Assign(EventDevice);
    Events[0].Start:=position;
    Events[0].Finish:=Events[1].Start;
    Events[Count-1].Select := false;
    Result:=0;
    exit;
  end;

  for i:=0 to Count-1 do begin
    Events[i].Select:=false;
    if Position = Events[i].Start then begin
      Result:=i;
      if i=Count-1 then Events[i].Finish:=TLParameters.Finish;
      exit;
    end;
  end;
  rw:=-1;
  for i:=0 to Count-1 do begin
    Events[i].Select:=false;
    if (Position > Events[i].Start) and (Position < Events[i].Finish) then begin
      rw:=i;
      break;
    end;
  end;
  if rw=-1 then rw:=count - 1;
  count:=count + 1;
  setlength(Events,count);
  Events[Count-1] := TMyEvent.Create;
  for i:=Count-1 downto rw+1 do Events[i].Assign(Events[i-1]);
  Events[rw].Finish:=Position;
  Events[rw+1].Start:=Position;
  Events[Count-1].Finish:=TLParameters.Finish;
  Events[Count-1].Select := false;
  Result:=rw+1;
end;

function TTLEditor.InsertMarker(Position : longint) : integer;
var i, rw : integer;
begin

  if Count=0 then begin
    count:=count+1;
    setlength(Events,count);
    Events[Count-1] := TMyEvent.Create;
    Events[Count-1].Assign(EventMedia);
    Events[Count-1].Start := Position;
    Events[Count-1].Select := false;
    Result:=0;
    exit;
  end;

  if Position < Events[0].Start then begin
    count:=count+1;
    setlength(Events,count);
    Events[Count-1] := TMyEvent.Create;
    for i:=Count-1 downto 1 do Events[i].Assign(Events[i-1]);
    Events[0].Assign(EventMedia);
    Events[0].Start:=position;
    Events[Count-1].Select := false;
    //Events[0].Finish:=Events[1].Start;
    Result:=0;
    exit;
  end;

  if (Position >= Events[Count-1].Start) then begin
    count:=count+1;
    setlength(Events,count);
    Events[Count-1] := TMyEvent.Create;
    Events[Count-1].Assign(EventMedia);
    Events[Count-1].Start := Position;
    Events[Count-1].Select := false;
    Result:=count-1;
    exit;
  end;

  rw:=-1;
  for i:=0 to count-2 do begin
    if ((Position >= Events[i].Start) and ( Position < Events[i].Finish))
       or ((Position >= Events[i].Finish) and (Position < Events[i+1].Start)) then begin
      rw:=i+1;
      break;
    end;
  end;

  count:=count + 1;
  setlength(Events,count);
  Events[Count-1] := TMyEvent.Create;
  if rw=-1 then rw:=count - 1;
  for i:=Count-1 downto rw do Events[i].Assign(Events[i-1]);
  Events[rw].Assign(EventMedia);
  Events[rw].Start:=Position;
  Events[Count-1].Select := false;
  Result:=rw;
end;

function TTLEditor.InsertText(Position : longint) : integer;
var i, rw : integer;
begin

  if Count=0 then begin
    count:=count+1;
    setlength(Events,count);
    Events[Count-1] := TMyEvent.Create;
    Events[Count-1].Assign(EventText);
    Events[Count-1].Start := Position;
    Events[Count-1].Select := false;
    Result:=0;
    exit;
  end;

  if Position < Events[0].Start then begin
    count:=count+1;
    setlength(Events,count);
    Events[Count-1] := TMyEvent.Create;
    for i:=Count-1 downto 1 do Events[i].Assign(Events[i-1]);
    Events[0].Assign(EventText);
    Events[0].Start:=position;
    Events[Count-1].Select := false;
    //Events[0].Finish:=Events[1].Start;
    Result:=0;
    exit;
  end;

  if (Position > Events[Count-1].Start) or (Position > Events[Count-1].Finish) then begin
    count:=count+1;
    setlength(Events,count);
    Events[Count-1] := TMyEvent.Create;
    Events[Count-1].Assign(EventText);
    Events[Count-1].Start := Position;
    Events[Count-1].Select := false;
    Result:=count-1;
    exit;
  end;

  rw:=-1;
  for i:=0 to count-2 do begin
    Events[i].Select:=false;
    Events[i+1].Select:=false;
    if ((Position >= Events[i].Start) and ( Position < Events[i].Finish))
       or ((Position >= Events[i].Finish) and (Position < Events[i+1].Start)) then begin
      rw:=i+1;
      break;
    end;
  end;

  count:=count + 1;
  setlength(Events,count);
  Events[Count-1] := TMyEvent.Create;
  if rw=-1 then rw:=count - 1;
  for i:=Count-1 downto rw do Events[i].Assign(Events[i-1]);
  Events[rw].Assign(EventText);
  Events[rw].Start:=Position;
  Events[rw].Select:=false;
  Events[Count-1].Select := false;
  Result:=rw;
end;

function TTLEditor.AddEvent(Position : longint; psgrd, psclr : integer) : integer;
var ARow : integer;
    frm : longint;
begin
       //AllSelectFalse;
       case TypeTL of
  tldevice : begin
               ARow:=InsertDevice(Position);
               Events[ARow].SetEvents((Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).DevEvents[psclr]);
               //Events[ARow].Color:=(Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).DevEvent[psclr];
               //Events[ARow].SetPhraseText('Device', (Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).DevNames[psclr]);
               //Events[ARow].SetPhraseData('Device', psclr+1);
              { Events[ARow].SetPhraseText('Text', '');
               Events[ARow].SetPhraseCommand('Text', '');
               Events[ARow].SetPhraseText('Command', 'Cut');
               Events[ARow].SetPhraseVisible('Duration',false);
               Events[ARow].SetPhraseVisible('Set',false);
               Events[ARow].SetPhraseText('ShortNum', inttostr(ARow + 1));
               Events[ARow].SetPhraseText('Comment', ''); }
               Result:=ARow;
               AllSelectFalse;
             end;
  tltext   : begin
               ARow:=InsertText(Position);
               //Events[ARow].Assign((Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).TextEvent);
               //Events[ARow].Color:=(Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).TextColor;
               Events[ARow].SetEvents((Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).TextEvent);
               Events[ARow].SetPhraseText('Text',Trim(Form1.RichEdit1.Text));
               //Events[ARow].SetPhraseText('Color','White');
               if Trim(Form1.RichEdit1.Text)='' then begin
                 Events[ARow].Finish:=Events[ARow].Start + (Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).EventDuration;
               end else begin
                 frm:=trunc(length(Trim(Form1.RichEdit1.Text)) * (Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).CharDuration / 40);
                 Events[ARow].Finish:=Events[ARow].Start + frm;
               end;
               Result:=ARow;
             end;
  tlmedia  : begin
               ARow:=InsertMarker(Position);
               Events[ARow].Finish:=Events[ARow].Start + Events[ARow].SafeZone + 50;
               Events[ARow].SetEvents((Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).MediaEvent);
               //Events[ARow].Color:=(Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).MediaColor;
               //Events[ARow].Color:=clRed;
               Result:=ARow;
             end;
       end; //case
  //AllSelectFalse;
end;

procedure TTLEditor.MouseClick(cv : tcanvas; X,Y : integer);
var i:integer;
    lft, rth : longint;

begin
  for i:=0 to Count-1 do begin
    rth := Rect.Left + Events[i].Finish * TLparameters.FrameSize;
    lft := Rect.Left + Events[i].Start * TLparameters.FrameSize;
    if (X>=lft) and (X<=rth) and (Y<=rect.Top) and (Y>=rect.Bottom) then begin
      Events[i].Editing:=not Events[i].Editing;
    end;
  end;
end;

function TTLEditor.FindEventPos(evframe : longint) : integer;
var i : integer;
begin
  result:=-1;
  for i := 0 to Count-1 do begin
    if (evframe >= Events[i].Start) and (evframe <= Events[i].Finish) then begin
      result := i;
      exit;
    end;
  end;
end;

procedure TTLEditor.AllSelectFalse;
var ev, i, j : integer;
begin
  for ev:=0 to Count-1
    do for i:=0 to Events[ev].Count-1
         do for j:=0 to Events[ev].Rows[i].Count-1
              do Events[ev].Rows[i].Phrases[j].Select:=false;
end;

procedure TTLEditor.EventsSelectFalse;
var ev, i, j : integer;
begin
  for ev:=0 to Count-1 do Events[ev].Select:=false;
end;

procedure TTLEditor.MouseMove(cv : tcanvas; X,Y : integer);
var i, j, ph :integer;
    lfts, rths, lft, rth, top, btm, tpp, psx, psf, l1, r1 : longint;
    s : string;
    rt : trect;

begin
  TLParameters.SetScreenBoanders;
  for i:=0 to Count-1 do begin
    //psf := Round((TLParameters.ScreenStart + X) / TLparameters.FrameSize);
    if Events[i].Finish<=TLParameters.ScreenStartFrame then continue;
    if Events[i].Start>=TLParameters.ScreenEndFrame then exit;
    lft := Events[i].Start * TLparameters.FrameSize - TLParameters.ScreenStart;
    lfts := lft;
    if lft<0 then lfts:=0;
    rth := Events[i].Finish * TLparameters.FrameSize - TLParameters.ScreenStart;
    rths := rth;
    if rth > TLParameters.ScreenEnd then rths := TLParameters.ScreenEnd;
    s:=inttostr(psf);
    tpp:=TLHeights.Scaler + TLHeights.IntervalEdit;
    if (X >= lfts) and (X <= rths) then begin
      Events[i].SetRectAreas(TypeTL);
      for j:=0 to Events[i].Count-1 do begin
          for ph:=0 to Events[i].Rows[j].Count-1 do begin
            top:=tpp + Events[i].Rows[j].Phrases[ph].Rect.Top;
            btm:=tpp + Events[i].Rows[j].Phrases[ph].Rect.Bottom;
            l1:=lft + Events[i].Rows[j].Phrases[ph].Rect.Left;
            r1:=lft + Events[i].Rows[j].Phrases[ph].Rect.Right;
            if (X>=l1) and (X<=r1) and (Y>=top) and (Y<=btm) then begin
              Events[i].Rows[j].Phrases[ph].Select:=true;
              //cv.Refresh;
              exit;
            end;
          end;
      end;
      //cv.Refresh;
      exit;
    end;
  end;
end;

function TTLEditor.CurrentEvents : integer;
var i : integer;
begin
  result:=-1;
  for i:=0 to Count-1 do begin
    if Events[i].Start > TLParameters.Position then exit;
    if Events[i].Finish < TLParameters.Position then continue;
    if (Events[i].Start <= TLParameters.Position) and (Events[i].Finish > TLParameters.Position) then begin
      result:=i;
      exit;
    end;
  end;
end;

procedure TTLEditor.DrawEditorDeviceEvent(evnt: tmyevent; cv : tcanvas; TLRect : Trect; lr : boolean);
var rt, rts, rtf, rtfr : trect;
    i, rw, ev, pfr, hh, tp, bt, st, fn : integer;
    xp, yp, arglen : integer;
    txt, tpdt : string;
    cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;

  //cv.Font.Size:=evnt.FontSize;
  cv.Font.Name:=evnt.FontName;

  rt.Top:=TLRect.Top;
  rt.Bottom:=TLRect.Bottom;
  if lr then begin
    //cv.Font.Color:=smoothcolor(evnt.FontColor,4);
    if evnt.FontColor = TLParameters.lrTransperent0 then cv.Font.Color:=smoothcolor(evnt.FontColor, 4);
    if EditingFinish > EditingStart then begin
      rt.Right:=TLRect.Left + EditingFinish;
      rt.Left:=TLRect.Left + EditingStart;
    end else begin
      rt.Right:=TLRect.Left + EditingStart;
      rt.Left:=TLRect.Left + EditingFinish;
    end;
  end else begin
    cv.Font.Color:=evnt.FontColor;
    rt.Right:=TLRect.Left + evnt.Finish * TLparameters.FrameSize;//Rect.Right;
    rt.Left:=TLRect.Left + evnt.Start * TLparameters.FrameSize;
  end;

  evnt.SetRectAreas(tldevice);

  cv.Brush.Style:=bsSolid;
  cv.Brush.Color:=evnt.Color;
  cv.FillRect(rt);

  cv.Brush.Color:=SmoothColor(evnt.Color,16);
  cv.Pen.Color:=SmoothColor(evnt.Color,32);
  cv.Pen.Width:=1;

  if evnt.PhraseIsVisible('Duration') then begin
    arglen := evnt.ReadPhraseData('Duration') * TLparameters.FrameSize;
    if arglen > rt.Right-rt.Left then arglen := rt.Right-rt.Left;
    cv.Polygon([Point(rt.Left, rt.Top+1),
    Point(rt.Left, rt.Bottom-1), Point(rt.Left + arglen, rt.Bottom-1)]);
  end;

  rts.Left:=rt.Left;
  rts.Right:=rt.Left + evnt.SafeZone;
  rts.Top:=rt.Top;
  rts.Bottom:=rt.Bottom;
  cv.Brush.Color:=SmoothColor(evnt.Color,32);
  cv.Pen.Color:=SmoothColor(evnt.Color,40);
  cv.Pen.Width:=1;
  cv.Rectangle(rts);

  cv.Brush.Color:=evnt.Color;

   for rw := 0 to evnt.Count-1 do begin
      cv.Font.Size:=evnt.FontSize - 2;
      cv.Font.Name:=evnt.FontName;
      //cv.Font.Color:=evnt.FontColor;
      for pfr := 0 to evnt.Rows[rw].Count-1 do begin
        xp := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left;
        yp := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
        if not (evnt.Rows[rw].Phrases[pfr].visible) then continue;
        if (evnt.Rows[rw].Phrases[pfr].Select) and (evnt.Rows[rw].Phrases[pfr].visible)  then begin
          cv.Brush.Color := smoothcolor(evnt.Color, 48);
          rtfr.Left:=rt.Left+evnt.Rows[rw].Phrases[pfr].Rect.Left;
          rtfr.Top:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
          rtfr.Right:=rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
          if rtfr.Right > rt.Right then rtfr.Right:=rt.Right;
          rtfr.Bottom:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
          cv.FillRect(rtfr);//Events[i].Rows[rw].Phrases[pfr].Rect);
        end;
        if rw = 0 then cv.Font.Size:=evnt.FontSize else cv.Font.Size:=evnt.FontSizeSub;
        cv.Brush.Style:=bsClear;
        rtfr.Left:=rt.Left+evnt.Rows[rw].Phrases[pfr].Rect.Left;
        rtfr.Top:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
        rtfr.Right:=rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
        if (rw=0) or (rtfr.Right > rt.Right) then rtfr.Right:=rt.Right - evnt.SafeZone;
        rtfr.Bottom:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
        tpdt := trim(lowercase(evnt.Rows[rw].Phrases[pfr].WorkData));
        if (tpdt='data') or (tpdt='integer') then cv.TextRect(rtfr,xp, yp, inttostr(evnt.Rows[rw].Phrases[pfr].Data))
        else if tpdt='device' then cv.TextRect(rtfr,xp, yp, evnt.Rows[rw].Phrases[pfr].Text)
        else if (tpdt='tag') then cv.TextRect(rtfr,xp, yp, inttostr(evnt.Rows[rw].Phrases[pfr].Tag))
        else if (tpdt='timecode') or (tpdt='shorttimecode') then cv.TextRect(rtfr,xp, yp, FramesToShortStr(evnt.Rows[rw].Phrases[pfr].Data))
        else if (tpdt='command') then cv.TextRect(rtfr,xp, yp, evnt.Rows[rw].Phrases[pfr].Command)
        else cv.TextRect(rtfr,xp, yp, evnt.Rows[rw].Phrases[pfr].Text);
      end;
    end;
  if evnt.Select then begin
    cv.Brush.Style:=bsClear;
    cv.Pen.Width := 4;
    if lr then begin
      if TLParameters.lrTransperent0 = clWhite then cv.Pen.Color := SmoothColor(clWhite,4);
    end else  cv.Pen.Color := clWhite;

    cv.Rectangle(rt.Left+2,rt.Top+2,rt.Right-2,rt.Bottom-2);
  end;

  cv.Refresh;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawEditorDevice(cv : tcanvas);
var rt, rts, rtf, rtfr : trect;
    i, rw, ev, pfr, hh, tp, bt, st, fn : integer;
    xp, yp, arglen : integer;
    txt : string;
    cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
    evnt : tmyevent;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;

  for i:=0 to Count - 1 do begin
    if (EditingEvent=i) and (EditingArea=edStart) then begin
      if (i > 0) then begin
        if (Events[i-1].Start  * TLparameters.FrameSize) - TLParameters.ScreenStart < EditingStart then begin
          Events[i-1].Finish := Events[i].Finish;//TLParameters.ScreenStartFrame + trunc(EditingStart / TLParameters.FrameSize) +1;
          DrawEditorDeviceEvent(Events[i-1], cv, Rect, false);
        end;
      end;
      cv.Refresh;
      DrawEditorDeviceEvent(Events[i], form1.imgLayer0.Canvas, Rect, true);
      form1.imgLayer0.Repaint;
    end else DrawEditorDeviceEvent(Events[i], cv, Rect, false);
  end;
  cv.Refresh;
 // form1.imgLayer0.Picture.Bitmap.TransparentColor:=TLParameters.lrTransperent0;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawEditorTextEvent(evnt: tmyevent; cv : tcanvas; TLRect : Trect; lr : boolean);
var rt, rts, rtfr : trect;
    txt : string;
    i, cnt, stp, ps, rw, pfr, xp, yp : integer;
    cfn, cbr, cpn, subcl : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;
  cfn := cv.Font.Color;

  cv.Font.Size:=evnt.FontSize;
  cv.Font.Name:=evnt.FontName;
  cv.Font.Color:=evnt.FontColor;
  subcl:=TLZoneNamesFontColor;

  rt.Top:=TLRect.Top;
  rt.Bottom:=TLRect.Bottom;
  txt := evnt.ReadPhraseText('Text');
  cnt := length(txt) * (TLParameters.FrameSize + 1);
  if cnt=0 then cnt := evnt.SafeZone * 5;
  if lr then begin
    if EditingFinish-EditingStart < cnt then EditingFinish:=EditingStart + cnt;
    rt.Right:=TLRect.Left + EditingFinish;
    rt.Left:=TLRect.Left + EditingStart;
    if evnt.FontColor = TLParameters.lrTransperent0 then cv.Font.Color:=smoothcolor(evnt.FontColor, 4);
    if TLZoneNamesFontColor = TLParameters.lrTransperent0 then subcl:=smoothcolor(TLZoneNamesFontColor, 4);
  end else begin
    rt.Left:=TLRect.Left + evnt.Start * TLParameters.FrameSize;
    rt.Right:=TLRect.Left + evnt.Finish * TLParameters.FrameSize;
    cv.Font.Color:=evnt.FontColor;
    subcl:=TLZoneNamesFontColor;
  end;

  cv.Brush.Style := bsSolid;
  cv.Brush.Color:=evnt.color;//(Form1.GridTimeLines.Objects[0,Index] as TTimelineOptions).TextColor; //TLParameters.ForeGround; //Events[i].Color;
  cv.FillRect(rt);

  for rw := 0 to evnt.Count-1 do begin
    for pfr := 0 to evnt.Rows[rw].Count-1 do begin
      xp := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left;
      yp := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top + 1;
      if (evnt.Rows[rw].Phrases[pfr].Select) and (evnt.Rows[rw].Phrases[pfr].visible)  then begin
        cv.Brush.Color := smoothcolor(evnt.Color, 48);
        rtfr.Left:=rt.Left+evnt.Rows[rw].Phrases[pfr].Rect.Left;
        rtfr.Top:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
        rtfr.Right:=rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
        if (rw=0) or (rtfr.Right > rt.Right) then rtfr.Right:=rt.Right - evnt.SafeZone;
        rtfr.Bottom:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
        cv.Brush.Style:=bsSolid;
        cv.FillRect(rtfr);
      end;
      if rw=0 then begin
        rts.Top:=rt.Top + evnt.Rows[0].Phrases[0].Rect.Top; //rt.Top+2;
        rts.Bottom:=rt.Top + evnt.Rows[0].Phrases[0].Rect.Bottom;//rt.Top + (rt.Bottom-rt.Top) div 2 - 2;
        rts.Left:=rt.Left;
        rts.Right:=rt.Right;
        //cv.Font.Color:=SmoothColor(clWhite,4);
        cv.Brush.Style:=bsSolid;
        MyTextRect(cv, rts, txt);
      end else begin
        cv.Brush.Style:=bsClear;
        rtfr.Left:=rt.Left+evnt.Rows[rw].Phrases[pfr].Rect.Left;
        rtfr.Top:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
        rtfr.Right:=rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
        if (rw=0) or (rtfr.Right > rt.Right) then rtfr.Right:=rt.Right - evnt.SafeZone;
        rtfr.Bottom:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
        cv.TextRect(rtfr,xp, yp, evnt.Rows[rw].Phrases[pfr].Text);
      end;
    end;
    cv.Font.Size:=evnt.FontSizeSub;
    cv.Font.Color:=subcl;
  end;

  cv.Brush.Color:=SmoothColor(clBlack,24);
  cv.Pen.Color := SmoothColor(clBlack,8);
  rts.Top:=rt.Top;
  rts.Bottom:=rt.Bottom;
  rts.Left:=rt.Left;
  rts.Right:=rt.Left + evnt.SafeZone;
  cv.Pen.Mode:=pmMerge;
  cv.Rectangle(rts);

  rts.Right:=rt.Right;
  rts.Left:=rt.Right - evnt.SafeZone;
  cv.Rectangle(rts);

  if evnt.Select then begin
      cv.Brush.Style:=bsClear;
      cv.Pen.Width := 4;
      cv.Pen.Color := SmoothColor(clBlue,64);
      cv.Rectangle(rt.Left+2,rt.Top+2,rt.Right-2,rt.Bottom-2);
  end;

//  if lr then begin
//    if EditingStart < TLParameters.
//  end;
  cv.Font.Color   := cfn;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawEditorText(cv : tcanvas);
var rt, rts, rtfr : trect;
    txt : string;
    i, cnt, stp, ps, rw, pfr, xp, yp : integer;
    cfn, cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;
  cfn := cv.Font.Color;

  for i:=0 to Count-1 do begin
    Events[i].SetRectAreas(tltext);
    if (EditingEvent<>-1) and (EditingEvent=i) and ((EditingArea=edStart) or (EditingArea=edFinish))
      then DrawEditorTextEvent(Events[i], Form1.ImgLayer0.Canvas, Rect, true)
      else DrawEditorTextEvent(Events[i], cv, Rect, false);
  end;

  //form1.imgLayer0.Picture.Bitmap.TransparentColor:=TLParameters.lrTransperent0;
  cv.Font.Color   := cfn;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawEditorMediaEvent(evnt: tmyevent; cv : tcanvas; TLRect : TRect; lr : boolean);
var rt,rtfr : trect;
    txt : string;
    i, cnt, stp, ps, psx, rw, pfr, xp ,yp : integer;
    cfn, cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;

begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;
  cfn := cv.Font.Color;

  cv.Font.Size:=evnt.FontSizeSub;
  cv.Font.Name:=evnt.FontName;
  cv.Font.Color:=evnt.FontColor;

  rt.Top:=TLRect.Top+1;
  rt.Bottom:=TLRect.Bottom-1;
  if lr then begin
    //if EditingFinish-EditingStart < cnt then EditingFinish:=EditingStart + cnt;
    rt.Left:=EditingStart;
    if cv.Font.Color = TLParameters.lrTransperent0 then cv.Font.Color:=smoothcolor(evnt.FontColor, 4);
  end else begin
    rt.Left:=evnt.Start * TLParameters.FrameSize;
    cv.Font.Color:=evnt.FontColor;
  end;
  rt.Right:=rt.Left + cv.TextWidth('0000000000');

  cv.Brush.Style:=bsSolid;
  cv.Brush.Color:=evnt.FontColor;
  cv.Pen.Color:=evnt.FontColor;
  cv.MoveTo(rt.Left, rt.Top);
  cv.LineTo(rt.Left, rt.Bottom);
  cv.Polygon([Point(rt.Left, rt.Top), Point(rt.Left+5, rt.Top+10), Point(rt.Left, rt.Top+20)]);
  cv.Brush.Color:=cbr;

  for rw := 0 to evnt.Count-1 do begin
    for pfr := 0 to evnt.Rows[rw].Count-1 do begin
      xp := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left - (evnt.SafeZone div 2);
      yp := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top + 1;
      if (evnt.Rows[rw].Phrases[pfr].Select) and (evnt.Rows[rw].Phrases[pfr].visible)  then begin
        cv.Brush.Color := smoothcolor(evnt.Color, 48);
        rtfr.Left:=rt.Left+evnt.Rows[rw].Phrases[pfr].Rect.Left - evnt.SafeZone;
        rtfr.Top:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
        rtfr.Right:=rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
        rtfr.Bottom:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
        cv.Brush.Style:=bsSolid;
        cv.FillRect(rtfr);
        cv.Brush.Color:=cbr;
      end;
      cv.Brush.Style:=bsClear;
      rtfr.Left:=rt.Left+evnt.Rows[rw].Phrases[pfr].Rect.Left - evnt.SafeZone;
      rtfr.Top:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
      rtfr.Right:=rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
      rtfr.Bottom:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
      cv.TextRect(rtfr,xp, yp, evnt.Rows[rw].Phrases[pfr].Text);
    end;
    cv.Font.Size:=evnt.FontSizeSub;
  end;

  cv.Font.Color   := cfn;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawEditorMedia(cv : tcanvas);
var rt, rts, rtfr : trect;
    txt : string;
    i, cnt, stp, ps, rw, pfr, xp, yp : integer;
    cfn, cbr, cpn : tcolor;
    wpn : integer;
    sbr : tbrushstyle;
    mpn : tpenmode;
begin
  cbr := cv.Brush.Color;
  cpn := cv.Pen.Color;
  wpn := cv.Pen.Width;
  sbr := cv.Brush.Style;
  mpn := cv.Pen.Mode;
  cfn := cv.Font.Color;

  rt.Right:=Rect.Left + TLparameters.EndPoint * TLparameters.FrameSize;;
  rt.Top:=Rect.Top+2;
  rt.Bottom:=rect.Bottom-2;
  rt.Left:={Rect.Left + }TLParameters.Preroll * TLparameters.FrameSize;
  cv.Brush.Style:=bsSolid;
  cv.Brush.Color:=(Form1.GridTimeLines.Objects[0,Index] as TTimelineOptions).MediaColor;
  cv.FillRect(rt);

  cv.Pen.Width:=1;
  cv.Pen.Color := TLZoneNamesFontColor;//clWhite;//SmoothColor(clWhite,5);
  stp := 25 * TLParameters.FrameSize;
  cnt := (rt.Right-rt.Left) div stp;
  cv.Font.Color:=TLZoneNamesFontColor;
  cv.Font.Size:=TLZoneNamesFontSize-3;
  for i:=1 to cnt do begin
    ps:=rt.Left + i * stp;
    cv.MoveTo(ps, rt.Top);
    cv.LineTo(ps, rt.Bottom);
    if (i mod 5)= 0 then cv.TextOut(ps + 3,rt.Bottom - 2 -cv.TextHeight('0'),SecondToStr(i));
  end;
  //cv.Font.Color:=TLZoneNamesFontColor;
  cv.Font.Size:=TLZoneNamesFontSize;
  txt := extractfilename(Form1.lbPlayerFile.Caption);
  cv.TextOut(rt.Left + 5, rt.Top + (rt.Bottom-rt.Top-cv.TextHeight(txt)) div 2 ,txt);
  cv.Pen.Width:=2;
  cv.Pen.Color:=TLZone.CRStart;
  cv.MoveTo(rt.Left + TLParameters.NTK *  TLParameters.FrameSize, rt.Top);
  cv.LineTo(rt.Left + TLParameters.NTK *  TLParameters.FrameSize, rt.Bottom);

  for i:=0 to Count-1 do begin
    Events[i].SetRectAreas(tlmedia);
    if (EditingEvent<>-1) and (EditingEvent=i) and (EditingArea=edStart)
      then DrawEditorMediaEvent(Events[i], Form1.ImgLayer0.Canvas, Rect, true)
      else DrawEditorMediaEvent(Events[i], cv, Rect, false);
  end;

  //form1.imgLayer0.Picture.Bitmap.TransparentColor:=TLParameters.lrTransperent0;
  cv.Font.Color   := cfn;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawEditor(cv : tcanvas);
var rt, rts, rtf : trect;
    i, rw, ev, pfr, hh, tp, bt, st, fn : integer;
    xp, yp : integer;
    txt : string;
begin
  DrawZoneTimeline(cv, Rect);

          case TypeTL of
  tldevice : DrawEditorDevice(cv);
  tltext   : DrawEditorText(cv);
  tlmedia  : DrawEditorMedia(cv);
          end;//
  //if EditingEvent > -1 then DrawLayer0(cv);
  cv.Refresh;
  if Form1.PanelAir.Visible then begin
    MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas,index);
    MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,index);
  end;  
end;

procedure TTLEditor.UpdateEventData(ev : TMyEvent);
var nm, dt, lsnm, txt  : string;
begin
  nm := ev.SelectionPhrase;
  if nm='' then exit;
  dt := ev.ReadPhraseType(nm);
  if Trim(LowerCase(dt))='template' then begin
    if Trim(LowerCase(nm))='comment'
      then ev.SetPhraseText(nm, SetTextTemplate(ev.ReadPhraseText(nm),true))
      else ev.SetPhraseText(nm, SetTextTemplate(ev.ReadPhraseText(nm),false));
  end else SetEventData(ev, nm);
end;

Procedure TTLEditor.WriteToStream(F : tStream);
var i : integer;
begin
  F.WriteBuffer(Index, SizeOf(integer));
  F.WriteBuffer(isZoneEditor, SizeOf(boolean));
  F.WriteBuffer(DoubleClick, SizeOf(boolean));
  F.WriteBuffer(IDTimeline, SizeOf(longint));
  i := ord(TypeTL); //:  TTypeTimeline;
  F.WriteBuffer(i, SizeOf(integer));
  F.WriteBuffer(Rect.Top, SizeOf(integer));
  F.WriteBuffer(Rect.Bottom, SizeOf(integer));
  F.WriteBuffer(Rect.Left, SizeOf(integer));
  F.WriteBuffer(Rect.Right, SizeOf(integer));
  F.WriteBuffer(Count, SizeOf(integer));
  For i:=0 to Count-1 do Events[i].WriteToStream(F);
end;

Procedure TTLEditor.ReadFromStream(F : tStream);
var i : integer;
begin
  F.WriteBuffer(Index, SizeOf(integer));
  F.ReadBuffer(isZoneEditor, SizeOf(boolean));
  F.ReadBuffer(DoubleClick, SizeOf(boolean));
  F.ReadBuffer(IDTimeline, SizeOf(longint));
  F.ReadBuffer(i, SizeOf(integer));
  TypeTL := SetTypeTimeline(i);
  F.ReadBuffer(Rect.Top, SizeOf(integer));
  F.ReadBuffer(Rect.Bottom, SizeOf(integer));
  F.ReadBuffer(Rect.Left, SizeOf(integer));
  F.ReadBuffer(Rect.Right, SizeOf(integer));
  clear;
  F.ReadBuffer(Count, SizeOf(integer));
  for i:=0 to Count-1 do begin
    Setlength(Events,i+1);
    Events[i] := TMyEvent.Create;
    Events[i].ReadFromStream(F);
  end;
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Класс TTLScaler отвечает за отрисовку области шкалы времени
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLScaler.Create;
begin
  inherited;
  PenColor := SmoothColor(TLParameters.Foreground,64);;
  FontColor := ProgrammFontColor;
  FontSize := 8;
  FontName := ProgrammFontName;
  Rect.Left:=0;
  Rect.Right:=0;
  Rect.Top:=0;
  Rect.Bottom:=0;
end;

Destructor TTLScaler.Destroy;
begin
  FreeMem(@PenColor);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@Rect);
  inherited;
end;

Procedure TTLScaler.DrawScaler(cv : tcanvas);
var i, j, cntb, cntp , dur, step, ps, tp, zero, befor, post : longint;
begin
  with TLParameters do begin
    dur:=(Preroll + duration + Postroll)*FrameSize;
    zero:=ZeroPoint*FrameSize;
    post:=dur - zero;
    step:=25*FrameSize;

    cntb:=zero div FrameSize;
    cntp:=post div FrameSize;

    cv.Brush.Color:=Foreground;
    //cv.FillRect(Rect);
    cv.Pen.Color:=PenColor;
    cv.Font.Color:=FontColor;
    cv.Font.Size:=FontSize;
    cv.Font.Name:=FontName;
    cv.FillRect(Rect);
    ps:=zero;

    cv.MoveTo(ps,0);
    cv.LineTo(ps,TLHeights.Scaler);
    cv.TextOut(ps+2,0,'0:00');
    tp := TLHeights.Scaler div 2;
    ps := ps - FrameSize;
    For i:=1 to cntb do begin
      if (i mod 25)=0 then begin
        cv.MoveTo(ps,0);
        cv.LineTo(ps,TLHeights.Scaler);
        cv.TextOut(ps+2,0,'-' + secondtostr(i div 25));
      end else begin
        cv.MoveTo(ps,tp);
        cv.LineTo(ps,TLHeights.Scaler);
      end;
      ps:=ps - FrameSize;
    End;
    ps:=zero + FrameSize;;
    for i:=1 to cntp do begin
      if (i mod 25)=0 then begin
        cv.MoveTo(ps,0);
        cv.LineTo(ps,TLHeights.Scaler);
        cv.TextOut(ps+2,0,secondtostr(i div 25));
      end else begin
        cv.MoveTo(ps,tp);
        cv.LineTo(ps,TLHeights.Scaler);
      end;
      ps:=ps + FrameSize;
    end;
  end; //with
end;

Procedure TTLScaler.WriteToStream(F : tStream);
begin
  F.WriteBuffer(PenColor, SizeOf(PenColor));
  F.WriteBuffer(FontColor, SizeOf(FontColor));
  F.WriteBuffer(FontSize, SizeOf(FontSize));
  WriteBufferStr(F, FontName);
  F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
  F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
  F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));
end;

Procedure TTLScaler.ReadFromStream(F : tStream);
begin
  F.ReadBuffer(PenColor, SizeOf(PenColor));
  F.ReadBuffer(FontColor, SizeOf(FontColor));
  F.ReadBuffer(FontSize, SizeOf(FontSize));
  ReadBufferStr(F, FontName);
  F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
  F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
  F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Класс TTLZone отвечает за всю область тайм-линий
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLZone.Create;
begin
  inherited;
  Countbuffer := 0;
  DownTimeline := false;
  DownEditor := false;
  DownScaler := false;
  XDown := -1;
  CRStart := clGreen;
  CREnd := clBlue;
  CRStartDown := false;
  CREndDown := false;
  Count:=0;
  TLScaler := TTLScaler.Create;
  TLEditor := TTLEditor.Create;
end;

Destructor TTLZone.Destroy;
begin
  FreeMem(@Countbuffer);
  FreeMem(@TLBuffer);
  FreeMem(@DownTimeline);
  FreeMem(@DownEditor);
  FreeMem(@DownScaler);
  FreeMem(@XDown);
  FreeMem(@CRStart);
  FreeMem(@CREnd);
  FreeMem(@CRStartDown);
  FreeMem(@CREndDown);
  FreeMem(@Count);
  TLScaler.Free;
  TLEditor.Free;
  FreeMem(@Timelines);
  inherited;
end;

Procedure TTLZone.ClearBuffer;
var i : integer;
begin
  For i:=Countbuffer-1 downto 0 do begin
    TLBuffer[i].Clear;
    TLBuffer[i].FreeInstance;
  end;
  Countbuffer:=0;
  SetLength(TLBuffer,Countbuffer);
end;

Procedure TTLZone.WriteToBuffer;
var i, j : integer;
begin
  Clearbuffer;
  For i:=0 to Count-1  do begin
    countbuffer := countbuffer + 1;
    setlength(TLBuffer,countbuffer);
    TLBuffer[countbuffer-1]:= TTLTimeline.Create;
    TLBuffer[countbuffer-1].Assign(Timelines[i]);
  end;
end;

function TTLZone.FindInBuffer(ID : longint) : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to countbuffer-1 do begin
    if TLBuffer[i].IDTimeline=ID then begin
       result:=i;
       exit;
    end;
  end;
end;

Procedure TTLZone.SetEditingEventDevice;
var i, sev, fev, cnt : integer;
    start, finish, sfzn : longint;
    direction: boolean;
begin
  if EditingFinish=EditingStart then begin
    TLEditor.DeleteEvent(EditingEvent);
    exit;
  end;

  if EditingFinish > EditingStart then begin

    start := Round((TLParameters.ScreenStart + EditingStart) / TLParameters.FrameSize);
    finish := TLEditor.Events[EditingEvent].Finish;

    if EditingEvent=0 then begin
      TLEditor.Events[0].Start:=start;
      exit;
    end;

    sev := TLEditor.FindEventPos(start);

    if sev=-1 then begin
      //TLEditor.Events[EditingEvent].Start:=start;
      For i:= EditingEvent-1 downto 0
         do TLEditor.DeleteEvent(i);
      TLEditor.Events[0].Start:=start;
      exit;
    end;

    if EditingEvent>0 then begin
      if TLEditor.Events[sev].Finish=TLEditor.Events[EditingEvent].Finish then begin
        TLEditor.Events[EditingEvent].Start:=start;
        TLEditor.Events[EditingEvent-1].Finish:=start;
        exit;
      end else begin
        //sev := TLEditor.FindEventPos(start);
        TLEditor.Events[EditingEvent].Start:=start;
        For i:=EditingEvent-1 downto sev+1 do TLEditor.DeleteEvent(i);
        TLEditor.Events[sev+1].Start:=start;
        TLEditor.Events[sev].Finish:=start;
        exit;
      end;
    end;
    
  end;

  if EditingFinish < EditingStart then begin
    finish := Round((TLParameters.ScreenStart + EditingStart) / TLParameters.FrameSize);
    start := TLEditor.Events[EditingEvent].Finish;
    sev := TLEditor.FindEventPos(finish);
    if sev=-1 then begin
      if TLEditor.Count > 1 then begin
         For i:=TLEditor.Count-1 downto EditingEvent+1 do TLEditor.DeleteEvent(i);
         TLEditor.Events[EditingEvent].Start:=start;
         TLEditor.Events[EditingEvent].Finish:=TLParameters.Finish;
      end else TLEditor.DeleteEvent(TLEditor.Count-1);
      exit;
    end;
    if sev=EditingEvent+1 then begin
      TLEditor.Events[EditingEvent].Start:=start;
      TLEditor.Events[EditingEvent].Finish:=finish;
      TLEditor.Events[EditingEvent+1].Start:=finish;
    end;
    if sev - EditingEvent > 1 then begin
      For i:=sev-1 downto EditingEvent+1 do TLEditor.DeleteEvent(i);
      TLEditor.Events[EditingEvent].Start:=start;
      TLEditor.Events[EditingEvent].Finish:=finish;
      TLEditor.Events[EditingEvent+1].Start:=finish;
    end;
  end;

  EditingEvent:=-1;
  EditingArea := edNone;
end;

Procedure TTLZone.SetEditingEventText;
var evnt : tmyevent;
    ps : longint;
    nm : integer;
begin
  evnt := tmyevent.Create;
  try
    ps:=Round((TLParameters.ScreenStart + EditingStart) / TLParameters.FrameSize);
    TLEditor.Events[EditingEvent].Start:=ps;
    TLEditor.Events[EditingEvent].Finish:=Round((TLParameters.ScreenStart + EditingFinish) / TLParameters.FrameSize);
    evnt.Assign(TLEditor.Events[EditingEvent]);
    TLEditor.DeleteEvent(EditingEvent);
    nm:=TLEditor.InsertText(ps);
    TLEditor.Events[nm].Assign(evnt);
  finally
    evnt.FreeInstance;
  end;
end;

Procedure TTLZone.SetEditingEventMedia;
var evnt : tmyevent;
    ps : longint;
    nm : integer;
begin
  evnt := tmyevent.Create;
  try
    ps:=Round((TLParameters.ScreenStart + EditingStart) / TLParameters.FrameSize);
    TLEditor.Events[EditingEvent].Start:=ps;
    TLEditor.Events[EditingEvent].Finish:=ps + TLEditor.Events[EditingEvent].SafeZone + 5;
    evnt.Assign(TLEditor.Events[EditingEvent]);
    TLEditor.DeleteEvent(EditingEvent);
    nm:=TLEditor.InsertMarker(ps);
    TLEditor.Events[nm].Assign(evnt);
  finally
    evnt.FreeInstance;
  end;
end;

Procedure TTLZone.UPZoneTimeline(cv : tcanvas; Button: TMouseButton; Shift: TShiftState;  X, Y : integer);
var ps, i, rw, fr : integer;
    txt, flnm : string;
begin
  if DownEditor then begin
    if (EditingArea=edNone) and (EditingEvent=-1) and (not (ssShift in shift)) then begin
      TLEditor.DoubleClick:=false;
      TLEditor.EventsSelectFalse;
    end;
    if (EditingEvent<>-1) then begin

      if EditingArea = edStart then begin
              Case TLEditor.TypeTL of
        tlDevice : SetEditingEventDevice;
        tlText   : SetEditingEventText;
        tlMedia  : SetEditingEventMedia;
              end; //case
     // end else begin
        EditingEvent:=-1;
        EditingArea:=edNone;
      end;
      if (EditingArea = edFinish) and (TLEditor.TypeTL=tltext) then begin
        SetEditingEventText;
        EditingEvent:=-1;
        EditingArea:=edNone;
      end;
      if (EditingArea = edCenter) and TLEditor.DoubleClick then begin
        TLEditor.DoubleClick:=false;
        TLEditor.UpdateEventData(TLEditor.Events[EditingEvent]);
        TLEditor.AllSelectFalse;
      end;
    end;
    EditingEvent:=-1;
    EditingArea:=edNone;
    ps:=FindTimeline(TLEditor.IDTimeline);
    TLEditor.ReturnEvents(Timelines[ps]);
    TLEditor.DrawEditor(bmptimeline.Canvas);
    Timelines[ps].DrawTimeline(bmptimeline.Canvas, ps);
    Form1.ImgLayer0.Canvas.Brush.Color:=TLParameters.lrTransperent0;// Form1.ImgLayer0.Picture.Bitmap.TransparentColor;
    Form1.ImgLayer0.Canvas.FillRect(Form1.ImgLayer0.Canvas.ClipRect);
    if mode <> play then DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
  end;

  DownTimeline:=false;
  DownEditor:=false;
  DownScaler:=false;
  CRStartDown:=false;
  CREndDown:=false;
  cv.refresh;
end;

Procedure TTLZone.MoveMouseTimeline(cv : tcanvas; Shift: TShiftState;  X, Y : integer);
var dlt, crpos : integer;
    shft, ln : longint;
    hgh1, hgh2 : integer;
begin
  try
  TLEditor.isZoneEditor := false;
  With TLParameters do begin
    if FrameSize=0 then FrameSize:=2;
    hgh1 := 0;
    hgh2 := TLHeights.Scaler;

    if (Y >= hgh1) and (Y <= hgh2) then begin
      if CRStartDown then begin
        shft := trunc(X / TLParameters.FrameSize);
        TLParameters.Start := TLParameters.ScreenStartFrame + shft;
      end;
      if CREndDown then begin
        dlt := X - XDown;
        shft := trunc(X / TLParameters.FrameSize);
        TLParameters.Finish := TLParameters.ScreenStartFrame + shft;
      end;
      DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
      exit;
    end;

    hgh1 := hgh2 + TLHeights.IntervalEdit;
    hgh2 := hgh1 + TLHeights.Edit;

    if (Y >= hgh1) and (Y <= hgh2) then begin
      //if mode<>play then TLEditor.AllSelectFalse;
      TLEditor.isZoneEditor := true;
      if DownEditor then begin
        if EditingEvent < 0 then exit;
               case TLEditor.TypeTL of
        tldevice,
        tlmedia : EditingStart := EditingStart + X - XDown;
        tltext  : begin
                     if EditingArea=edFinish then EditingFinish := EditingFinish + X - XDown;
                     if EditingArea=edStart then begin
                       EditingStart := EditingStart + X - XDown;
                       EditingFinish := EditingFinish + X - XDown;
                     end;
                  end;
               end;//case
        form1.ImgLayer0.Canvas.Brush.Color:=TLParameters.lrTransperent0; //form1.ImgLayer0.Picture.Bitmap.TransparentColor;
        form1.ImgLayer0.Canvas.FillRect(form1.ImgLayer0.Canvas.ClipRect);
        XDown:=X;
      end else begin
        if mode=play then exit;
        if mode<>play then TLEditor.AllSelectFalse;
        TLEditor.MouseMove(cv,X,Y);
      end;
      TLEditor.DrawEditor(bmptimeline.Canvas);
      form1.imgLayer0.repaint;
      if mode<>play then TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
      exit;
    end;

    hgh1 := hgh2 + TLHeights.IntervalTL;
    hgh2 := cv.ClipRect.Bottom-cv.ClipRect.Top - TLHeights.Review - TLHeights.Interval;

    if (Y >= hgh1) and (Y <= hgh2) then begin
      if DownTimeline then begin
        if mode=play then exit;
        dlt := X - XDown;
        shft := dlt;// * TLScaler.FrameSize;
        Position := Position - shft;
        if Position <=0 then Position:=0;
        //if TLParameters.ScreenStartFrame < 0 then exit;
        ln:=TLParameters.Preroll+TLParameters.Duration+TLParameters.Postroll;
        if Position >= ln then Position := ln;
        //TLEditor.DrawEditor(bmptimeline.Canvas);  //+++++++++++++++Warning
        crpos := TLEditor.CurrentEvents;
        if crpos <> -1 then begin
          MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', TLEditor.Events[crpos].ReadPhraseCommand('Text'));
        end;
        DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
        form1.imgTimelines.Repaint;
        MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
        MediaSetPosition(Position, false);
        mediapause;
        XDown:=X;
        form1.imgTimelines.Repaint;
        exit;
      end;
      exit;
    end;
  end;
  except
  end;
end;

Procedure TTLZone.DownZoneTimeLines(cv : tcanvas; Button: TMouseButton; Shift: TShiftState;  X, Y : integer);
var i, hgh1, hgh2 : integer;
    clicktc, sfzn : longint;
    s : string;
begin
  DownTimeline:=false;
  DownEditor:=false;
  DownScaler:=false;
  TLEditor.isZoneEditor := false;
  XDown:=X;
  hgh1 := 0;
  hgh2 := TLHeights.Scaler;

  if (Y >= hgh1) and (Y <= hgh2) then begin
    DownScaler:=true;
    if MouseInStartCursor(cv, X, Y) then CRStartDown:=true;
    if MouseInEndCursor(cv, X, Y) then CREndDown:=true;
    exit;
  end;

  hgh1 := hgh2 + TLHeights.IntervalEdit;
  hgh2 := hgh1 + TLHeights.Edit;

  if (Y >= hgh1) and (Y <= hgh2) then begin
    DownEditor:=true;
    TLEditor.isZoneEditor := true;
    clicktc:=TLParameters.ScreenStartFrame + Round(X / TLparameters.FrameSize);
    s:=inttostr(clicktc);
    if TLEditor.TypeTL=tltext then form1.RichEdit1.Text:='';
    For i:=0 to TLEditor.Count-1 do begin
      sfzn := trunc(TLEditor.Events[i].SafeZone / TLparameters.FrameSize) + 1;
      if (clicktc>=TLEditor.Events[i].Start) and (clicktc<=TLEditor.Events[i].Finish) then begin
         if (ssShift in shift) then begin
           TLEditor.Events[i].Select := not TLEditor.Events[i].Select;
           Timelines[FindTimeline(TLEditor.IDTimeline)].Events[i].Select := TLEditor.Events[i].Select;
           break;
         end else begin
           TLEditor.EventsSelectFalse;
           TLEditor.Events[i].Select := true;//not TLEditor.Events[i].Select;
           Timelines[FindTimeline(TLEditor.IDTimeline)].Events[i].Select := TLEditor.Events[i].Select;
         end;

         EditingArea := edNone;

//         if TLEditor.TypeTL=tltext
//           then if TLEditor.Events[i].Select
//                  then form1.RichEdit1.Text:=TLEditor.Events[i].ReadPhraseText('Text')
//                  else form1.RichEdit1.Text:='';

         if (clicktc>=TLEditor.Events[i].Start) and (clicktc<=TLEditor.Events[i].Start + sfzn) then begin
           EditingEvent:=i;
           EditingArea := edStart;
           EditingFinish:=TLEditor.Events[i].Finish * TLparameters.FrameSize - TLParameters.ScreenStart;
           EditingStart:=TLEditor.Events[i].Start * TLparameters.FrameSize - TLParameters.ScreenStart;
         end;

         if (clicktc>=TLEditor.Events[i].Finish - sfzn) and (clicktc<=TLEditor.Events[i].Finish) then begin
           EditingEvent:=i;
           EditingArea := edFinish;
           EditingFinish:=TLEditor.Events[i].Finish * TLparameters.FrameSize - TLParameters.ScreenStart;
           EditingStart:=TLEditor.Events[i].Start * TLparameters.FrameSize - TLParameters.ScreenStart;
         end;

         if (clicktc>=TLEditor.Events[i].Start + sfzn) and (clicktc<=TLEditor.Events[i].Finish - sfzn) then begin
           EditingEvent:=i;
           EditingArea := edCenter;
           EditingFinish:=TLEditor.Events[i].Finish * TLparameters.FrameSize - TLParameters.ScreenStart;
           EditingStart:=TLEditor.Events[i].Start * TLparameters.FrameSize - TLParameters.ScreenStart;
         end;

      end;
    end;

    TLEditor.DrawEditor(bmptimeline.Canvas);
    form1.imgLayer0.repaint;
    DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
    exit;
  end;

  hgh1 := hgh2 + TLHeights.IntervalTL;
  hgh2 := cv.ClipRect.Bottom-cv.ClipRect.Top - TLHeights.Review - TLHeights.Interval;

  if (Y >= hgh1) and (Y <= hgh2) then begin
    DownTimeline:=true;
    exit;
  end;
end;

Procedure TTLZone.AddTimeline(ID : Longint);
begin
  Count:=Count + 1;
  Setlength(Timelines,Count);
  Timelines[Count-1]:=TTLTimeline.Create;
  Timelines[Count-1].IDTimeline:=ID;
end;

function TTLZone.FindTimeline(ID : Longint) : integer;
var i : integer;
begin
  result:=-1;
  for i:=0 to Count-1 do begin
    If Timelines[i].IDTimeline=ID then begin
      Result:=i;
      exit;
    end;
  end;
end;

procedure TTLZone.ClearTimeline;
var i : integer;
begin
  For i:=Count-1 downto 0 do begin
    Timelines[i].Clear;
    Timelines[i].FreeInstance;
  end;
  SetLength(Timelines,0);
  Count:=0;
end;

Procedure TTLZone.InitTimelines(bmp : tbitmap);
var i, hgh, ps, cnt : integer;

Begin
  TLScaler.Rect.Left:=0;
  TLScaler.Rect.Right:=bmp.Width;
  TLScaler.Rect.Top:=0;
  TLScaler.Rect.Bottom:=TLHeights.Scaler;

  TLEditor.Rect.Left:=0;
  TLEditor.Rect.Right:=bmp.Width;
  TLEditor.Rect.Top:=TLHeights.Scaler+TLHeights.IntervalEdit;
  TLEditor.Rect.Bottom:=TLHeights.Scaler+TLHeights.IntervalEdit+TLHeights.Edit;


  hgh :=TLHeights.Scaler+TLHeights.IntervalEdit+TLHeights.Edit + TLHeights.IntervalTL;

  WriteToBuffer;
  ClearTimeline;

  For i:=1 to Form1.GridTimeLines.RowCount-1 do begin
    if Form1.GridTimeLines.Objects[0,i] is TTimelineOptions then begin
      //ps:=FindTimeline((Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).IDTimeline);
      AddTimeline((Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).IDTimeline);
      Timelines[Count-1].Rect.Left:=0;
      Timelines[Count-1].Rect.Right:=bmp.Width;
      Timelines[Count-1].Rect.Top:=hgh;
      hgh:=hgh + TLHeights.HeightTL;
      Timelines[Count-1].Rect.Bottom:=hgh;
      Timelines[Count-1].TypeTL:=(Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).TypeTL;
      hgh:=hgh + TLHeights.Interval;
      ps:=FindInBuffer(Timelines[Count-1].IDTimeline);
      if ps<>-1 then Timelines[Count-1].Assign(TLBuffer[ps]);
    end;
  end;
  CLearBuffer;
End;

Procedure TTLZone.DrawLayer2(cv : tcanvas);
var hgh : integer;
begin
  hgh:=TLHeights.Height;
  with Form1 do begin
    cv.Pen.Color:=smoothcolor(clWhite,32);
    cv.MoveTo(TLParameters.MyCursor,0);//TLHeights.Scaler);
    cv.LineTo(TLParameters.MyCursor,TLHeights.Height-TLHeights.Review);
  end;
end;

procedure TTLZone.DrawBitmap(bmp : tbitmap);
var i : integer;
begin
//  bmp.Canvas.Lock;
//  Form1.imgLayer1.Canvas.Lock;
//  Form1.imgLayer2.Canvas.Lock;
//  Form1.imgLayer0.Canvas.Lock;
//  Form1.imgTimelines.Canvas.Lock;
  try
  bmp.Height:=TLHeights.Height - TLHeights.Review - TLHeights.Interval;
  bmp.Width:=(TLParameters.Preroll + TLParameters.Duration + TLParameters.Postroll) * TLParameters.FrameSize;
  bmp.Canvas.Brush.Color:=TLParameters.Background;
  bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
  InitTimelines(bmp);
  TLScaler.DrawScaler(bmp.Canvas);
  TLEditor.DrawEditor(bmp.Canvas);

  For i:=0 to Count-1 do Timelines[i].DrawTimeline(bmp.Canvas, i);
  finally
//    bmp.Canvas.Unlock;
  //  Form1.imgLayer1.Canvas.UnLock;
  //  Form1.imgLayer2.Canvas.UnLock;
  //  Form1.imgLayer0.Canvas.UnLock;
  //  Form1.imgTimelines.Canvas.UnLock;
  end;
end;

Procedure TTLZone.DrawTimelines(cv : tcanvas; bmp: tbitmap);
var rect1, rect2, rect3 : trect;
    pn : TPenMode;
    cl : TColor;
    msht : Real;
    smsh : longint;
    sz, st, en : longint;
    DCs : HDC;
begin
  //cv.Lock;
//  Form1.imgLayer1.Canvas.Lock;
//  Form1.imgLayer2.Canvas.Lock;
//  Form1.imgLayer0.Canvas.Lock;
//  Form1.imgTimelines.Canvas.Lock;
//  try
  if bmptimeline.Canvas.LockCount <>0 then exit;
  rect1.Left := cv.ClipRect.Left;
  rect1.Right := cv.ClipRect.Right;
  rect1.Top := cv.ClipRect.Top;
  rect1.Bottom := cv.ClipRect.Bottom - TLHeights.Review - TLHeights.Interval;

  TLParameters.SetScreenBoanders;

  rect2.Left:=TLParameters.ScreenStart;
  rect2.Right:=TLParameters.ScreenEnd;
  rect2.Top:=0;
  rect2.Bottom := bmp.Height;

  sz := (TLParameters.Finish - TLParameters.Start) * TLParameters.FrameSize;
  if sz = 0 then sz:=bmp.Width;
  Msht:=sz / (TLParameters.ScreenEnd -TLParameters.ScreenStart);
  smsh := trunc(TLParameters.MyCursor / Msht);
  rect3.Left:=trunc((TLParameters.ScreenStart - TLParameters.Start * TLParameters.FrameSize)/ Msht);
  rect3.Right:=trunc((TLParameters.ScreenEnd - TLParameters.Start * TLParameters.FrameSize )/ Msht);

  //cv.FillRect(cv.ClipRect);
  //cv.CopyRect(rect1,bmp.Canvas,rect2);
  //DCs:=GetDC(cv.Handle);
  bitblt(cv.Handle, rect1.Left, rect1.Top, rect1.Right-rect1.Left, rect1.Bottom-rect1.Top,
         bmp.Canvas.Handle, rect2.Left, rect2.Top , SRCCOPY);
  //ReleaseDC(cv.Handle, DCs);
  //DeleteDC(DCs);

  if Form1.imgLayer2.Canvas.LockCount=0 then PositionToLayer2(Form1.imgLayer2.Canvas);

  if Form1.imgLayer1.Canvas.LockCount=0 then  DrawCursorStart(Form1.imgLayer1.Canvas);

  if Form1.imgLayer1.Canvas.LockCount=0 then DrawCursorEnd(Form1.imgLayer1.Canvas);

  rect1.Left := cv.ClipRect.Left;
  rect1.Right := cv.ClipRect.Right;
  rect1.Top := cv.ClipRect.Bottom - TLHeights.Review;
  rect1.Bottom := cv.ClipRect.Bottom;

  rect2.Left:=TLParameters.Start*TLParameters.FrameSize;//0;
  rect2.Right:=TLParameters.Finish*TLParameters.FrameSize;//bmp.Width;
  rect2.Top:=TLHeights.Scaler + TLHeights.IntervalEdit + TLHeights.Edit + TLHeights.IntervalTL;
  rect2.Bottom := bmp.Height;

  stretchblt(cv.Handle, rect1.Left, rect1.Top, rect1.Right-rect1.Left, rect1.Bottom-rect1.Top,
         bmp.Canvas.Handle, rect2.Left, rect2.Top, rect2.Right-rect2.Left, rect2.Bottom-rect2.Top, SRCCOPY);
  //cv.CopyRect(rect1,bmp.Canvas,rect2);


  Rect3.Top:=Rect1.Top;
  rect3.Bottom:=rect1.Bottom;
  pn:=cv.Pen.Mode;
  cl:=cv.Pen.Color;
  cv.Pen.Mode:=pmMerge;
 // cv.Brush.Color:=clWhite;
  cv.Pen.Color := TLZoneNamesColor;//clgray;// $626262;
  cv.Rectangle(rect3);
  cv.Pen.Mode:=pmCopy;
  cv.Pen.Color:=clWhite;
  cv.MoveTo(rect3.Left+smsh, rect3.Top);
  cv.LineTo(rect3.Left+smsh, rect3.Bottom);
  cv.Pen.Color := cl;
  cv.Pen.Mode:=pn;
//  finally
   //cv.Unlock;
//   Form1.imgLayer1.Canvas.UnLock;
//   Form1.imgLayer2.Canvas.UnLock;
//   Form1.imgLayer0.Canvas.UnLock;
//   Form1.imgTimelines.Canvas.UnLock;
//  end;
end;

function TTLZone.PlusHoriz : integer;
begin
   TLParameters.FrameSize := TLParameters.FrameSize + 1;
   if TLParameters.FrameSize > TLParameters.MaxFrameSize then TLParameters.FrameSize := TLParameters.MaxFrameSize;
   Result := TLParameters.FrameSize;
   DrawBitmap(bmptimeline);
   DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
end;

function TTLZone.MinusHoriz : integer;
begin
   TLParameters.FrameSize := TLParameters.FrameSize - 1;
   if TLParameters.FrameSize < 2 then TLParameters.FrameSize := 2;
   Result := TLParameters.FrameSize;
   DrawBitmap(bmptimeline);
   DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
end;

Procedure TTLZone.PositionToLayer2(cv : tcanvas);
var rt : trect;
    s : string;
    cl : tcolor;
    ps : longint;
begin
  cv.Lock;
  try
  //cv.Pen.Color:=smoothcolor(clWhite,32);
  DrawLayer2(cv);
  cv.Font.Color:=smoothcolor(clWhite,32);
  cv.Font.Style:=cv.Font.Style - [fsBold];
  cv.Font.Name := ProgrammFontName;
  ps:=TLParameters.Position-TLParameters.ZeroPoint;
  s:=FramesToShortStr(ps);//inttostr(TLParameters.Position);
  rt.Left:=TLParameters.MyCursor+2;
  rt.Right:=rt.Left+cv.TextWidth('-00:00:00:00');
  rt.Top:=TLHeights.Scaler;
  rt.Bottom:=rt.Top+TLHeights.IntervalEdit;
  //cv.Brush.Style:=bsSolid;
  cl:=cv.Brush.Color;
  cv.Brush.Color:=TLBackGround;
  //cv.FillRect(rt);
  //cv.Pen.Color:=TLBackGround;
  cv.Rectangle(rt);
  cv.TextRect(rt,rt.Left,rt.Top,s);
  //cv.Brush.Style:=bsClear;
  cv.Brush.Color:=cl;
 // DrawLayer2(cv);
 finally
   cv.Unlock;
 end;
end;

Procedure TTLZone.WriteToStream(F : tStream);
var i : integer;
begin
//  F.WriteBuffer(Countbuffer, SizeOf(integer));
//  for i := 0 to Countbuffer-1 do TLBuffer[i].WriteToStream(F);
  F.WriteBuffer(DownTimeline, SizeOf(DownTimeline));
  F.WriteBuffer(DownEditor, SizeOf(DownEditor));
  F.WriteBuffer(DownScaler, SizeOf(DownScaler));
  F.WriteBuffer(XDown, SizeOf(XDown));
  F.WriteBuffer(CRStart, SizeOf(CRStart));
  F.WriteBuffer(CRStartDown, SizeOf(CRStartDown));
  F.WriteBuffer(CREnd, SizeOf(CREnd));
  F.WriteBuffer(CREndDown, SizeOf(CREndDown));
  TLScaler.WriteToStream(F);
  TLEditor.WriteToStream(F);
  F.WriteBuffer(Count, SizeOf(integer));
  for i := 0 to Count-1 do Timelines[i].WriteToStream(F);
end;

Procedure TTLZone.ReadFromStream(F : tStream);
var i : integer;
begin

//  clearbuffer;
//  F.ReadBuffer(Countbuffer, SizeOf(integer));
//  for i := 0 to Count-1 do begin
//    Setlength(TLBuffer, i+1);
//    TLBuffer[i] := TTLtimeline.Create;
//    TLBuffer[i].WriteToStream(F);
//  end;
  F.ReadBuffer(DownTimeline, SizeOf(DownTimeline));
  F.ReadBuffer(DownEditor, SizeOf(DownEditor));
  F.ReadBuffer(DownScaler, SizeOf(DownScaler));
  F.ReadBuffer(XDown, SizeOf(XDown));
  F.ReadBuffer(CRStart, SizeOf(CRStart));
  F.ReadBuffer(CRStartDown, SizeOf(CRStartDown));
  F.ReadBuffer(CREnd, SizeOf(CREnd));
  F.ReadBuffer(CREndDown, SizeOf(CREndDown));
  //TLScaler := TTLScaler.Create;
  TLScaler.ReadFromStream(F);
  //TLEditor := TTLEditor.Create;
  TLEditor.Clear;
  TLEditor.ReadFromStream(F);
  cleartimeline;
  F.ReadBuffer(Count, SizeOf(integer));
  for i := 0 to Count-1 do begin
    Setlength(Timelines, i+1);
    Timelines[i] := TTLtimeline.Create;
    Timelines[i].ReadFromStream(F);
  end;
end;

initialization
TLParameters := TTLParameters.Create;
TLZone := TTLZone.Create;

end.
