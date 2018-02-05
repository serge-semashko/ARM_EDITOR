unit UGRTimelines;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, utimeline, umyevents;

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
  Constructor Create;
  Destructor Destroy; override;
end;

TTLEditor = Class(TObject)
  public
  Index   : integer;
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
  procedure DrawEditorDeviceEvent(evnt: tmyevent; cv : tcanvas; lr : boolean);
  procedure DrawEditorTextEvent(evnt: tmyevent; cv : tcanvas; lr : boolean);
  procedure DrawEditorText(cv : tcanvas);
  procedure DrawEditorMedia(cv : tcanvas);
  procedure DrawLayer0(cv : tcanvas);
  procedure DrawLayer0Device(cv : tcanvas);
  procedure DrawLayer0Text(cv : tcanvas);
  procedure DrawEditor(cv : tcanvas);
  procedure MouseClick(cv : tcanvas; X,Y : integer);
  procedure MouseMove(cv : tcanvas; X,Y : integer);
  function FindEventPos(evframe : longint) : integer;
  procedure AllSelectFalse;
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
uses umain, uinitforms, ucommon, uimgbuttons, udrawtimelines, uplayer,  UAirDraw;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//процедуры и функции для отрисовки зоны курсоров
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TTLZone.DrawCursorStart(cv : tcanvas);
var hgh : integer;
    rt : trect;
    s : string;
    ps : longint;
begin
  cv.Lock;
  try
  with form1 do begin
    TLParameters.SetScreenBoanders;
    cv.FillRect(cv.ClipRect);
    if TLParameters.Start < TLParameters.ScreenStartFrame then exit;
    if TLParameters.Start > TLParameters.ScreenEndFrame then exit;
    cv.FillRect(cv.ClipRect);
    cv.Pen.Color:=CRStart;
    ps := (TLParameters.Start - TLParameters.ScreenStartFrame) * TLParameters.FrameSize-1;
    cv.MoveTo(ps,0);//TLHeights.Scaler);
    cv.LineTo(ps,TLHeights.Height - TLHeights.Review);
    cv.Brush.Color:=CRStart;
    cv.Brush.Style:=bsSolid;

    cv.Polygon([Point(ps, 0), Point(ps, TLHeights.Scaler), Point(ps + 10, TLHeights.Scaler div 2)]);
     //TLParameters.lrTransperent1;
    rt.Left:=0;//cv.ClipRect.Left;
    rt.Top:=0;//cv.ClipRect.Top;
    rt.Right:=ps;
    rt.Bottom:=TLHeights.Height - TLHeights.Review;
    cv.CopyRect(rt,imgTimelines.Canvas,rt);
    cv.Pen.Mode:=pmMerge;
    cv.Brush.Color:=SmoothColor(clBlack,20);
    cv.Pen.Color:=SmoothColor(clBlack,20);
    cv.Rectangle(rt);
    //cv.Brush.Style:=clClear;
    //TLParameters.Start:=ps;
    s:=FramesToShortStr(TLParameters.Start);
    cv.TextOut(ps-cv.TextWidth(s)-2,(TLHeights.Scaler-cv.TextHeight(s)) div 2, s);
  end;
  finally
    cv.Unlock;
  end;
end;

procedure TTLZone.DrawCursorEnd(cv : tcanvas);
var hgh : integer;
    rt : trect;
    s : string;
    ps : longint;
begin
  cv.Lock;
  try
  with form1 do begin
    TLParameters.SetScreenBoanders;
    if TLParameters.Finish < TLParameters.ScreenStartFrame then exit;
    if TLParameters.Finish > TLParameters.ScreenEndFrame then exit;
    cv.FillRect(cv.ClipRect);
    cv.Pen.Color:=CREnd;
    //TLParameters.SetScreenBoanders;
    ps := (TLParameters.Finish - TLParameters.ScreenStartFrame) * TLParameters.FrameSize;
    cv.MoveTo(ps,0);//TLHeights.Scaler);
    cv.LineTo(ps,TLHeights.Height - TLHeights.Review);
    cv.Brush.Color:=CREnd;
    cv.Brush.Style:=bsSolid;

    cv.Polygon([Point(ps, 0), Point(ps, TLHeights.Scaler), Point(ps - 10, TLHeights.Scaler div 2)]);
     //TLParameters.lrTransperent1;
    rt.Left:=ps;//cv.ClipRect.Left;
    rt.Top:=0;//cv.ClipRect.Top;
    rt.Right:=cv.ClipRect.Right;
    rt.Bottom:=TLHeights.Height - TLHeights.Review;
    cv.CopyRect(rt,imgTimelines.Canvas,rt);
    cv.Pen.Mode:=pmMerge;
    cv.Brush.Color:=SmoothColor(clBlack,20);
    cv.Pen.Color:=SmoothColor(clBlack,20);
    cv.Rectangle(rt);
    //cv.Brush.Style:=clClear;
    //TLParameters.Start:=ps;
    s:=FramesToShortStr(TLParameters.Finish);
    cv.TextOut(ps + 2,(TLHeights.Scaler-cv.TextHeight(s)) div 2, s);
  end;
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
  lrTransperent0 := clBlack;
  lrTransperent1 := clBlack;
  lrTransperent2 := clBlack;
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
  FreeMem(Events);
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
    rt : trect;
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
    rt.Right:=Rect.Left + Events[i].Finish * TLparameters.FrameSize;;
    rt.Top:=Rect.Top+2;
    rt.Bottom:=rect.Bottom-2;
    rt.Left:=Rect.Left + Events[i].Start * TLparameters.FrameSize;

    cv.Brush.Style:=bsSolid;
    cv.Brush.Color:=Events[i].Color;
    cv.FillRect(rt);

    //cv.Brush.Color:=SmoothColor(Events[i].Color,12);
    cv.Brush.Color:=SmoothColor(Events[i].Color,16);
    cv.Pen.Color:=SmoothColor(Events[i].Color,32);
    arglen:=25 * TLParameters.FrameSize;
    if arglen > rt.Right-rt.Left then arglen := rt.Right-rt.Left;
    cv.Polygon([Point(rt.Left, rt.Top+1), Point(rt.Left, rt.Bottom-1),
                Point(rt.Left + arglen, rt.Bottom-1)]);

    cv.Font.Size:=TLZoneNamesFontSize;
    for rw := 0 to Events[i].Count-1 do begin
      st:=15;
      for pfr := 0 to Events[i].Rows[0].Count-1 do begin
        Events[i].Rows[0].Phrases[pfr].Rect.Top := rt.Top;
        Events[i].Rows[0].Phrases[pfr].Rect.Bottom := rt.Bottom;
        Events[i].Rows[0].Phrases[pfr].Rect.Left := rt.Left + st;
        Events[i].Rows[0].Phrases[pfr].Rect.Right := rt.Right;
        st := st + cv.TextWidth(Events[i].Rows[0].Phrases[pfr].Text) + 5;
        xp := Events[i].Rows[0].Phrases[pfr].Rect.Left;
        yp := Events[i].Rows[0].Phrases[pfr].Rect.Top;
        cv.Brush.Style := bsClear;
        cv.TextOut(xp, yp, Events[i].Rows[0].Phrases[pfr].Text);
      end;
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

    rt.Top:=Rect.Top;
    rt.Bottom:=Rect.Bottom;
    for i:=0 to Count-1 do begin
      rt.Left:=Rect.Left + Events[i].Start * TLParameters.FrameSize;
      rt.Right:=Rect.Left + Events[i].Finish * TLParameters.FrameSize;
      cv.Brush.Style:=bsClear;
      cv.Brush.Color:=TLParameters.Foreground;//SmoothColor(TLParameters.Foreground,8);//Events[i].Color;
      cv.FillRect(rt);

      cv.Font.Color:=TLZoneNamesFontColor;
      cv.Font.Size:=TLZoneNamesFontSize + 4;

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
var rt : trect;
    txt : string;
    i : integer;
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
  rt.Right:=Rect.Left + TLparameters.EndPoint * TLparameters.FrameSize;;
  rt.Top:=Rect.Top+2;
  rt.Bottom:=rect.Bottom-2;
  rt.Left:=Rect.Left + TLParameters.Preroll * TLparameters.FrameSize;
  cv.Brush.Color:=Color;
  cv.FillRect(rt);
  cv.Font.Color:=TLZoneNamesFontColor;
  cv.Font.Size:=TLZoneNamesFontSize-4;
  txt := extractfilename(Form1.lbPlayerFile.Caption);
  cv.TextOut(rt.Left + 5, rt.Top + (rt.Bottom-rt.Top-cv.TextHeight(txt)) div 2 ,txt);

  for i:=0 to count-1 do begin
    cv.Pen.Color:=Events[i].Color;
    cv.MoveTo(Events[i].Start * TLParameters.FrameSize, rt.Top);
    cv.LineTo(Events[i].Start * TLParameters.FrameSize, rt.Bottom);
    cv.Polygon([Point(Events[i].Start * TLParameters.FrameSize, rt.Top),
               Point(Events[i].Start * TLParameters.FrameSize+5, rt.Top+10),
               Point(Events[i].Start * TLParameters.FrameSize, rt.Top+20)]);
  end;
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

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Класс TTLEditor отвечает за отрисовку области редактирование тайм-линий
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Constructor TTLEditor.Create;
begin
  inherited;
  Index := 0;
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
  if TypeTL =tlText then exit;
  Events[Position].Start:=start;
  if Position>=Count-1 then begin
    Events[Count-1].Finish:=TLParameters.EndPoint;
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
    if Position = Events[i].Start then begin
      Result:=i;
      if i=Count-1 then Events[i].Finish:=TLParameters.Finish;
      exit;
    end;
  end;
  rw:=-1;
  for i:=0 to Count-1 do begin
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
    Events[0].Finish:=Events[1].Start;
    Result:=0;
    exit;
  end;

  for i:=0 to Count-1 do begin
    if Position = Events[i].Start then begin
      Result:=i;
      exit;
    end;
  end;
  rw:=-1;
  for i:=0 to Count-2 do begin
    if (Position > Events[i].Start) and (Position < Events[i+1].Start) then begin
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
  Result:=rw+1;
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

  for i:=0 to Count-1 do begin
    if Position = Events[i].Start then begin
      Result:=i;
      exit;
    end;
  end;
  rw:=-1;
  for i:=0 to Count-2 do begin
    if (Position > Events[i].Start) and (Position < Events[i+1].Start) then begin
      rw:=i;
      break;
    end;
  end;

  count:=count + 1;
  setlength(Events,count);
  Events[Count-1] := TMyEvent.Create;
  if rw=-1 then rw:=count - 1;
  for i:=Count-1 downto rw+1 do Events[i].Assign(Events[i-1]);
  Events[rw].Assign(EventText);
  //Events[rw].Finish:=Position;
  Events[rw].Start:=Position;
  Events[Count-1].Select := false;
  Result:=rw;
end;

function TTLEditor.AddEvent(Position : longint; psgrd, psclr : integer) : integer;
var ARow : integer;
    frm : longint;
begin

       case TypeTL of
  tldevice : begin
               ARow:=InsertDevice(Position);
               //Events[ARow].Assign(EventDevice);
               Events[ARow].Color:=(Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).DevColors[psclr];
               Events[ARow].SetPhraseText('Device', (Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).DevNames[psclr]);
               Events[ARow].SetPhraseData('Device', psclr);
               Result:=ARow;
               AllSelectFalse;
             end;
  tltext   : begin
               ARow:=InsertText(Position);
               Events[ARow].Color:=(Form1.GridTimeLines.Objects[0,psgrd] as TTimelineOptions).TextColor;
               Events[ARow].SetPhraseText('Text',Trim(Form1.RichEdit1.Text));
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
               Events[ARow].Color:=clRed;
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

procedure TTLEditor.MouseMove(cv : tcanvas; X,Y : integer);
var i, j, ph :integer;
    lfts, rths, lft, rth, top, btm, tpp, psx, psf, l1, r1 : longint;
    s : string;
    rt : trect;

begin
  for i:=0 to Count-1 do begin
    psf := Round((TLParameters.ScreenStart + X) / TLparameters.FrameSize);
    lft := Events[i].Start * TLparameters.FrameSize - TLParameters.ScreenStart;
    lfts := lft;
    if lft<0 then lfts:=0;
    rth := Events[i].Finish * TLparameters.FrameSize - TLParameters.ScreenStart;
    rths := rth;
    if rth > TLParameters.ScreenEnd then rths := TLParameters.ScreenEnd;
    s:=inttostr(psf);
    tpp:=TLHeights.Scaler + TLHeights.IntervalEdit;
    if (X >= lfts) and (X <= rths) then begin
      Events[i].SetRectAreas;
      for j:=0 to Events[i].Count-1 do begin
          for ph:=0 to Events[i].Rows[j].Count-1 do begin
            top:=tpp + Events[i].Rows[j].Phrases[ph].Rect.Top;
            btm:=tpp + Events[i].Rows[j].Phrases[ph].Rect.Bottom;
            l1:=lft + Events[i].Rows[j].Phrases[ph].Rect.Left;
            r1:=lft + Events[i].Rows[j].Phrases[ph].Rect.Right;
            if (X>=l1) and (X<=r1) and (Y>=top) and (Y<=btm) then begin
              Events[i].Rows[j].Phrases[ph].Select:=true;
              cv.Refresh;
              exit;
            end;
          end;
      end;
      cv.Refresh;
      exit;
    end;
  end;
end;

procedure TTLEditor.DrawEditorDeviceEvent(evnt: tmyevent; cv : tcanvas; lr : boolean);
var rt, rts, rtf, rtfr : trect;
    i, rw, ev, pfr, hh, tp, bt, st, fn : integer;
    xp, yp, arglen : integer;
    txt : string;
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

//  for i:=0 to Count - 1 do begin
    rt.Top:=Rect.Top;
    rt.Bottom:=rect.Bottom;
    if lr then begin
      if EditingFinish > EditingStart then begin
        rt.Right:=Rect.Left + EditingFinish;
        rt.Left:=Rect.Left + EditingStart;
      end else begin
        rt.Right:=Rect.Left + EditingStart;
        rt.Left:=Rect.Left + EditingFinish;
      end;
      //rt.Right:=Rect.Left + evnt.Finish * TLparameters.FrameSize - TLParameters.ScreenStart;//Rect.Right;
      //rt.Left:=Rect.Left + evnt.Start * TLparameters.FrameSize - TLParameters.ScreenStart;
    end else begin
      rt.Right:=Rect.Left + evnt.Finish * TLparameters.FrameSize;//Rect.Right;
      rt.Left:=Rect.Left + evnt.Start * TLparameters.FrameSize;
    end;
    cv.Brush.Style:=bsSolid;
    cv.Brush.Color:=evnt.Color;
    cv.FillRect(rt);

    cv.Brush.Color:=SmoothColor(evnt.Color,16);
    cv.Pen.Color:=SmoothColor(evnt.Color,32);
    cv.Pen.Width:=1;
    arglen := 25 * TLparameters.FrameSize;
    if arglen > rt.Right-rt.Left then arglen := rt.Right-rt.Left;
    cv.Polygon([Point(rt.Left, rt.Top+1),
    Point(rt.Left, rt.Bottom-1), Point(rt.Left + arglen, rt.Bottom-1)]);

    rts.Left:=rt.Left;
    rts.Right:=rt.Left + evnt.SafeZone;
    rts.Top:=rt.Top;
    rts.Bottom:=rt.Bottom;
    cv.Brush.Color:=SmoothColor(evnt.Color,28);
    cv.Pen.Color:=SmoothColor(evnt.Color,32);
    cv.Pen.Width:=1;
    cv.Rectangle(rts);

    cv.Brush.Color:=evnt.Color;

      for rw := 0 to evnt.Count-1 do begin
        cv.Font.Size:=evnt.FontSize;
        cv.Font.Name:=evnt.FontName;
        cv.Font.Color:=evnt.FontColor;
        for pfr := 0 to evnt.Rows[rw].Count-1 do begin
          xp := rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Left;
          yp := rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
          if (evnt.Rows[rw].Phrases[pfr].Select) and (evnt.Rows[rw].Phrases[pfr].visible)  then begin
            cv.Brush.Color := smoothcolor(evnt.Color, 48);
            rtfr.Left:=rt.Left+evnt.Rows[rw].Phrases[pfr].Rect.Left;
            rtfr.Top:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Top;
            rtfr.Right:=rt.Left + evnt.Rows[rw].Phrases[pfr].Rect.Right;
            if rtfr.Right > rt.Right then rtfr.Right:=rt.Right;
              rtfr.Bottom:=rt.Top + evnt.Rows[rw].Phrases[pfr].Rect.Bottom;
              cv.FillRect(rtfr);//Events[i].Rows[rw].Phrases[pfr].Rect);
          end;
          cv.Brush.Style:=bsClear;
          cv.TextOut(xp, yp, evnt.Rows[rw].Phrases[pfr].Text);
        end;
        cv.Font.Size:=evnt.FontSizeSub;// TLZoneNamesFontSize - 2;
      end;
//  end;
  cv.Refresh;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawEditorTextEvent(evnt: tmyevent; cv : tcanvas; lr : boolean);
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

  rt.Top:=Rect.Top;
  rt.Bottom:=Rect.Bottom;

  rt.Right:=Rect.Left + EditingFinish;
  rt.Left:=Rect.Left + EditingStart;

  cv.Brush.Style := bsSolid;
  cv.Brush.Color:=TLParameters.ForeGround; //Events[i].Color;
  cv.FillRect(rt);

  cv.Font.Color:=TLZoneNamesFontColor;
  cv.Font.Size:=TLZoneNamesFontSize + 6;

  txt := evnt.ReadPhraseText('Text');
  rts.Top:=rt.Top+2;
  rts.Bottom:=rt.Top + (rt.Bottom-rt.Top) div 2 - 2;
  rts.Left:=rt.Left;
  rts.Right:=rt.Right;

  cv.Font.Color:=SmoothColor(clWhite,4);
  MyTextRect(cv, rts, txt);

  cv.Brush.Color:=SmoothColor(clBlack,24);
  cv.Pen.Color := SmoothColor(clBlack,24);
  rts.Top:=rt.Top;
  rts.Bottom:=rt.Bottom;
  rts.Left:=rt.Left;
  rts.Right:=rt.Left + evnt.SafeZone;
  cv.Pen.Mode:=pmMerge;
  cv.Rectangle(rts);

  rts.Right:=rt.Right;
  rts.Left:=rt.Right - evnt.SafeZone;
  cv.Rectangle(rts);

  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawLayer0(cv : tcanvas);
var evnt : tmyevent;
begin
  if (EditingEvent >= 0) and (EditingEvent < Count) then begin
         case TypeTL of
  tldevice : DrawLayer0Device(cv);
  tltext   : DrawLayer0Text(cv);
  tlmedia  : begin end;
         end;
  end;
//  EditingEvent:=-1;
//  EditingArea:=edNone;
end;

procedure TTLEditor.DrawLayer0Device(cv : tcanvas);
var evnt : tmyevent;
begin
  if EditingArea<>edStart then exit;
  if (EditingEvent > 0) and (EditingEvent < Count) then begin
    evnt := tmyevent.Create;
    try
      evnt.Assign(Events[EditingEvent-1]);
      evnt.Finish:=Events[EditingEvent].Finish;
      DrawEditorDeviceEvent(evnt,cv, false);
    finally
      evnt.FreeInstance;
    end;
  end;
  if EditingEvent<>-1 then begin
    DrawEditorDeviceEvent(Events[EditingEvent],Form1.ImgLayer0.Canvas, true);
    Form1.ImgLayer0.Repaint;
  end;
end;

procedure TTLEditor.DrawLayer0Text(cv : tcanvas);
begin
  if (EditingArea=edCenter) or (EditingArea=edNone) then exit;

  if (EditingEvent >= 0) and (EditingEvent < Count) then begin
    DrawEditorTextEvent(Events[EditingEvent],Form1.ImgLayer0.Canvas, true);
    Form1.ImgLayer0.Repaint;
  end;
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
    if (EditingEvent=0) and (i=0) and (EditingArea=edStart) then continue;
    rt.Right:=Rect.Left + Events[i].Finish * TLparameters.FrameSize;//Rect.Right;
    rt.Top:=Rect.Top;
    rt.Bottom:=rect.Bottom;
    rt.Left:=Rect.Left + Events[i].Start * TLparameters.FrameSize;

    cv.Brush.Style:=bsSolid;
    cv.Brush.Color:=Events[i].Color;
    cv.FillRect(rt);
    cv.Brush.Color:=SmoothColor(Events[i].Color,16);
    cv.Pen.Color:=SmoothColor(Events[i].Color,32);
    cv.Pen.Width:=1;
    arglen := 25 * TLparameters.FrameSize;
    if arglen > rt.Right-rt.Left then arglen := rt.Right-rt.Left;
    cv.Polygon([Point(rt.Left, rt.Top+1),
    Point(rt.Left, rt.Bottom-1), Point(rt.Left + arglen, rt.Bottom-1)]);

    rts.Left:=rt.Left;
    rts.Right:=rt.Left + Events[i].SafeZone;
    rts.Top:=rt.Top;
    rts.Bottom:=rt.Bottom;
    cv.Brush.Color:=SmoothColor(Events[i].Color,28);
    cv.Pen.Color:=SmoothColor(Events[i].Color,32);
    cv.Pen.Width:=1;
    cv.Rectangle(rts);

    cv.Brush.Color:=Events[i].Color;

    for rw := 0 to Events[i].Count-1 do begin
      cv.Font.Size:=Events[i].FontSize;
      cv.Font.Name:=Events[i].FontName;
      cv.Font.Color:=Events[i].FontColor;
      for pfr := 0 to Events[i].Rows[rw].Count-1 do begin
        xp := rt.Left + Events[i].Rows[rw].Phrases[pfr].Rect.Left;
        yp := rt.Top + Events[i].Rows[rw].Phrases[pfr].Rect.Top;
        if (Events[i].Rows[rw].Phrases[pfr].Select) and (Events[i].Rows[rw].Phrases[pfr].visible)  then begin
          cv.Brush.Color := smoothcolor(Events[i].Color, 48);
          rtfr.Left:=rt.Left+Events[i].Rows[rw].Phrases[pfr].Rect.Left;
          rtfr.Top:=rt.Top + Events[i].Rows[rw].Phrases[pfr].Rect.Top;
          rtfr.Right:=rt.Left + Events[i].Rows[rw].Phrases[pfr].Rect.Right;
          if rtfr.Right > rt.Right then rtfr.Right:=rt.Right;
            rtfr.Bottom:=rt.Top + Events[i].Rows[rw].Phrases[pfr].Rect.Bottom;
            cv.FillRect(rtfr);//Events[i].Rows[rw].Phrases[pfr].Rect);
        end;
        cv.Brush.Style:=bsClear;
        cv.TextOut(xp, yp, Events[i].Rows[rw].Phrases[pfr].Text);
      end;
      cv.Font.Size:=Events[i].FontSizeSub;// TLZoneNamesFontSize - 2;
    end;

    cv.Brush.Style:=bsClear;
    cv.Pen.Width := 4;
    cv.Pen.Color := clWhite;
    if Events[i].Select
      then begin
        cv.Rectangle(rt.Left+2,rt.Top+2,rt.Right-2,rt.Bottom-2);
      end;
  end;
  cv.Refresh;
  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawEditorText(cv : tcanvas);
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
    rt.Top:=Rect.Top;
    rt.Bottom:=Rect.Bottom;
    for i:=0 to Count-1 do begin
      if (EditingEvent=i) and ((EditingArea=edStart) or (EditingArea=edFinish)) then continue;
      rt.Left:=Rect.Left + Events[i].Start * TLParameters.FrameSize;
      rt.Right:=Rect.Left + Events[i].Finish * TLParameters.FrameSize;

      cv.Brush.Color:=TLParameters.ForeGround; //Events[i].Color;
      cv.FillRect(rt);

      cv.Font.Color:=TLZoneNamesFontColor;
      cv.Font.Size:=TLZoneNamesFontSize + 6;

      txt := Events[i].ReadPhraseText('Text');
      rts.Top:=rt.Top+2;
      rts.Bottom:=rt.Top + (rt.Bottom-rt.Top) div 2 - 2;
      rts.Left:=rt.Left;
      rts.Right:=rt.Right;

      MyTextRect(cv, rts, txt);

      cv.Brush.Color:=SmoothColor(clBlack,24);
      cv.Pen.Color := SmoothColor(clBlack,24);
      rts.Top:=rt.Top;
      rts.Bottom:=rt.Bottom;
      rts.Left:=rt.Left;
      rts.Right:=rt.Left + Events[i].SafeZone;
      cv.Pen.Mode:=pmMerge;
      cv.Rectangle(rts);

      rts.Right:=rt.Right;
      rts.Left:=rt.Right - Events[i].SafeZone;
      cv.Rectangle(rts);

      cv.Brush.Style:=bsClear;
      cv.Pen.Width := 4;
      cv.Pen.Color := SmoothColor(clBlue,64);
      if Events[i].Select then begin
        cv.Rectangle(rt.Left+2,rt.Top+2,rt.Right-2,rt.Bottom-2);
      end;
      //application.ProcessMessages;
    end;

  cv.Brush.Color  := cbr;
  cv.Pen.Color    := cpn;
  cv.Pen.Width    := wpn;
  cv.Brush.Style  := sbr;
  cv.Pen.Mode     := mpn;
end;

procedure TTLEditor.DrawEditorMedia(cv : tcanvas);
var rt : trect;
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

  rt.Right:=Rect.Left + TLparameters.EndPoint * TLparameters.FrameSize;;
  rt.Top:=Rect.Top+2;
  rt.Bottom:=rect.Bottom-2;
  rt.Left:={Rect.Left + }TLParameters.Preroll * TLparameters.FrameSize;
  cv.Brush.Color:=(Form1.GridTimeLines.Objects[0,Index] as TTimelineOptions).MediaColor;
  cv.FillRect(rt);
  cv.Pen.Width:=1;
  cv.Pen.Color := clWhite;//SmoothColor(clWhite,5);
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
  cv.Font.Color:=TLZoneNamesFontColor;
  cv.Font.Size:=TLZoneNamesFontSize;
  txt := extractfilename(Form1.lbPlayerFile.Caption);
  cv.TextOut(rt.Left + 5, rt.Top + (rt.Bottom-rt.Top-cv.TextHeight(txt)) div 2 ,txt);
  cv.Pen.Width:=2;
  cv.Pen.Color:=TLZone.CRStart;
  cv.MoveTo(rt.Left + TLParameters.NTK *  TLParameters.FrameSize, rt.Top);
  cv.LineTo(rt.Left + TLParameters.NTK *  TLParameters.FrameSize, rt.Bottom);
  for i:=0 to count-1 do begin
    cv.Pen.Color:=Events[i].Color;
    cv.MoveTo(Events[i].Start * TLParameters.FrameSize, rt.Top);
    cv.LineTo(Events[i].Start * TLParameters.FrameSize, rt.Bottom);
    cv.Polygon([Point(Events[i].Start * TLParameters.FrameSize, rt.Top),
               Point(Events[i].Start * TLParameters.FrameSize+5, rt.Top+10),
               Point(Events[i].Start * TLParameters.FrameSize, rt.Top+20)]);
  end;

  //cv.Pen.Color:=TLZone.CREnd;
  //cv.MoveTo(rt.Left + (TLParameters.Finish - TLParameters.Preroll) * TLParameters.FrameSize, rt.Top);
  //cv.LineTo(rt.Left + (TLParameters.Finish - TLParameters.Preroll) * TLParameters.FrameSize, rt.Bottom);
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
  if EditingEvent > -1 then DrawLayer0(cv);

  if Form1.PanelAir.Visible then begin
    MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas,index);
    MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,index);
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
    cv.FillRect(Rect);
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
  procedure setmybounds(sev, fev : integer; start, finish : longint);
  begin
    if sev=fev then begin
      sfzn := trunc(TLEditor.Events[sev].SafeZone / TLParameters.FrameSize);
      if finish-start < sfzn then begin
        TLEditor.DeleteEvent(sev);
        exit;
      end;
      TLEditor.Events[sev].Start := start;
      if sev > 0 then TLEditor.Events[sev-1].Finish := start;
      exit;
    end;
    if (sev = -1) and (fev=0) then begin
      TLEditor.Events[0].Start := start;
      exit;
    end;
    if fev - sev = 1 then begin
      if TLEditor.Events[sev].Finish = start then begin
        if sev > 0 then TLEditor.Events[sev-1].Finish:=start;
        TLEditor.Events[sev].Start:=start;
        TLEditor.Events[sev].Finish:=finish;
        TLEditor.Events[fev].Start:=finish;
        exit;
      end;
      if TLEditor.Events[sev].Start < start then begin
        TLEditor.Events[sev].Finish:=start;
        TLEditor.Events[fev].Start:=start;
        exit;
      end;
      if TLEditor.Events[sev].Start = start then begin
        TLEditor.DeleteEvent(sev);
        TLEditor.Events[sev].Start := start;
      end;
    end;
  end;

begin

  if EditingFinish > EditingStart then begin
    start := Round((TLParameters.ScreenStart + EditingStart) / TLParameters.FrameSize);
    finish := Round((TLParameters.ScreenStart + EditingFinish) / TLParameters.FrameSize);
    direction := true;
  end else begin
    finish := Round((TLParameters.ScreenStart + EditingStart) / TLParameters.FrameSize);
    start := Round((TLParameters.ScreenStart + EditingFinish) / TLParameters.FrameSize);
    direction := false;
  end;

  EditingEvent:=-1;
  EditingArea := edNone;
  form1.ImgLayer0.Canvas.Brush.Color:=form1.ImgLayer0.Picture.Bitmap.TransparentColor;
  form1.ImgLayer0.Canvas.FillRect(form1.ImgLayer0.Canvas.ClipRect);

  sev := TLEditor.FindEventPos(start);
  fev := TLEditor.FindEventPos(finish);

  if direction then begin
    if (sev=fev) or (fev-sev=1) or ((sev = -1) and (fev=0)) then setmybounds(sev, fev, start, finish)
    else begin
      if fev-sev > 1 then begin
        for i:=fev-1 downto sev+1 do TLEditor.DeleteEvent(i);
        sev := TLEditor.FindEventPos(start);
        fev := TLEditor.FindEventPos(finish);
        if (sev = -1) and (fev=0) then begin
          setmybounds(sev, fev, start, finish);
          exit;
        end;
        if TLEditor.Events[sev].Finish=start then sev:=sev+1;
        setmybounds(sev, fev, start, finish)
      end;
    end;
  end else begin
    if (sev=fev) or (fev-sev=1) or ((sev = -1) and (fev=0)) then setmybounds(sev, fev, start, finish)
    else begin
       if fev=-1 then begin
         TLEditor.DeleteEvent(TLEditor.Count-1);
         exit;
       end;
       if TLEditor.Events[fev].Finish=finish then cnt:=fev else cnt:=fev-1;
       for i:= cnt downto sev+1 do TLEditor.DeleteEvent(i);
       TLEditor.Events[sev].Start:=start;
       TLEditor.Events[sev].Finish:=finish;
       if TLEditor.Events[sev+1].Start < finish then TLEditor.Events[sev+1].Start := finish;
       if sev > 0 then TLEditor.Events[sev-1].Finish:=start;
    end;
  end;
end;

Procedure TTLZone.SetEditingEventText;
var i, sev, fev, cnt : integer;
    start, finish, sfzn : longint;
begin
  start := Round((TLParameters.ScreenStart + EditingStart) / TLParameters.FrameSize);
  finish := Round((TLParameters.ScreenStart + EditingFinish) / TLParameters.FrameSize);
  TLEditor.Events[EditingEvent].Start:=start;
  TLEditor.Events[EditingEvent].Finish:=Finish;
  Form1.ImgLayer0.Canvas.Brush.Color:=Form1.ImgLayer0.Picture.Bitmap.TransparentColor;
  Form1.ImgLayer0.Canvas.FillRect(Form1.ImgLayer0.Canvas.ClipRect);
end;

Procedure TTLZone.UPZoneTimeline(cv : tcanvas; Button: TMouseButton; Shift: TShiftState;  X, Y : integer);
var ps : integer;
begin
  if DownEditor then begin
    if EditingEvent<>-1 then begin

      if EditingArea = edStart then begin
              Case TLEditor.TypeTL of
        tlDevice : SetEditingEventDevice;
        tlText   : SetEditingEventText;
        tlMedia  : begin end;
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
    end;
    EditingEvent:=-1;
    EditingArea:=edNone;
    ps:=FindTimeline(TLEditor.IDTimeline);
    TLEditor.ReturnEvents(Timelines[ps]);
    TLEditor.DrawEditor(bmptimeline.Canvas);
    Timelines[ps].DrawTimeline(bmptimeline.Canvas, ps);
  end;

  DownTimeline:=false;
  DownEditor:=false;
  DownScaler:=false;
  CRStartDown:=false;
  CREndDown:=false;
end;

Procedure TTLZone.MoveMouseTimeline(cv : tcanvas; Shift: TShiftState;  X, Y : integer);
var dlt : integer;
    shft, ln : longint;
    hgh1, hgh2 : integer;
begin

  With TLParameters do begin
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
      if mode<>play then TLEditor.AllSelectFalse;
      if DownEditor then begin
        if EditingEvent < 0 then exit;
        EditingStart := EditingStart + X - XDown;
        if EditingArea=edFinish then EditingFinish := EditingFinish + X - XDown;
        form1.ImgLayer0.Canvas.Brush.Color:=form1.ImgLayer0.Picture.Bitmap.TransparentColor;
        form1.ImgLayer0.Canvas.FillRect(form1.ImgLayer0.Canvas.ClipRect);
        XDown:=X;
      end else begin
        if mode=play then exit;
        TLEditor.MouseMove(cv,X,Y);
      end;
      TLZone.TLEditor.DrawEditor(bmptimeline.Canvas);
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
        ln:=TLParameters.Preroll+TLParameters.Duration+TLParameters.Postroll;
        if Position >= ln then Position := ln;
        DrawTimelines(form1.imgTimelines.Canvas, bmptimeline);
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
end;

Procedure TTLZone.DownZoneTimeLines(cv : tcanvas; Button: TMouseButton; Shift: TShiftState;  X, Y : integer);
var i, hgh1, hgh2 : integer;
    clicktc, sfzn : longint;
    s : string;
begin
  DownTimeline:=false;
  DownEditor:=false;
  DownScaler:=false;
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
         end;

         EditingArea := edNone;

         if TLEditor.TypeTL=tltext
           then if TLEditor.Events[i].Select
                  then form1.RichEdit1.Text:=TLEditor.Events[i].ReadPhraseText('Text')
                  else form1.RichEdit1.Text:='';

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

  if Form1.imgLayer1.Canvas.LockCount=0 then DrawCursorStart(Form1.imgLayer1.Canvas);

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
   if TLParameters.FrameSize < 1 then TLParameters.FrameSize := 1;
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

initialization
TLParameters := TTLParameters.Create;
TLZone := TTLZone.Create;

end.
