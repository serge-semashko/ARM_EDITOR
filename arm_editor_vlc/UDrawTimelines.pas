unit UDrawTimelines;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, utimeline;

Type

  TTLZone = (znscaler, znedit, zntimelines, znreview, znnone);

  TTLButton = (btplusH,btminusH,btplusW,btminusW,btprocent,btlock,btstatus,bttimeline,btreview,btnone);

  TTLNResult = record
    Zone : TTLZone;
    ID : integer;
    Position : integer;
    Button : TTLButton;
  end;

   TZoneScaler = Class(TObject)
     public
       Rect : Trect;
       OffsetText : integer;
       Text : string;
       Color : tcolor;
       FontColor : tcolor;
       FontSize : integer;
       FontName : tfontname;
       FontStyles : tfontstyles;
       plusH : trect;
       plusHSelect : boolean;
       plusHLock : boolean;
       minusH : trect;
       minusHSelect : boolean;
       minusHLock : boolean;
       plusW : trect;
       plusWSelect : boolean;
       plusWLock : boolean;
       minusW : trect;
       minusWSelect : boolean;
       minusWLock : boolean;
       procent : trect;
       procentSelect : boolean;
     function ClickScaler(cv : tcanvas; X, Y : integer) : TTLNResult;
     procedure MoveMouse(cv : tcanvas; X, Y : integer);
     procedure Draw(cv : tcanvas; height : integer);
     Procedure WriteToStream(F : tStream);
     Procedure ReadFromStream(F : tStream);
     Constructor Create;
     Destructor Destroy; override;
   end;

  TTimeLineName = Class(TObject)
    public
      Rect : trect;
      IDTimeline : longint;
      Selection : boolean;
      Editing : boolean;
      OffsetTextX : integer;
      Color : tcolor;
      FontColor : tcolor;
      FontSize : integer;
      FontName : tfontname;
      FontStyles : tfontstyles;
      imgRect : trect;
      BlockRect : trect;
      StatusRect : trect;
    procedure Draw(cv : tcanvas;  Grid : tstringgrid; APos : integer);
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    Constructor Create;
    Destructor Destroy; override;
  end;

  TNamesTL = Class(TObject)
    public
      Rect : trect;
      Interval : integer;
      HeightTL : integer;
      Color : tcolor;
      FontColor : tcolor;
      FontSize : integer;
      FontName : tfontname;
      FontStyles : tfontstyles;
      Count : integer;
      Names : array of TTimelineName;
    Procedure MoveMouse(cv : tcanvas; Grid : tstringgrid; X, Y : integer);
    function ClickNamesTL(cv : tcanvas; X, Y : integer) : TTLNResult;
    Procedure Draw(cv : tcanvas; Grid : tstringgrid; Top, Height : integer);
    Function Add(Timeline : TTimelineOptions) : integer;
    Procedure Clear;
    Function Init( Grid : tstringgrid; erase : boolean) : integer;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    Constructor Create;
    Destructor Destroy; override;
  end;

  TZoneEditTL = Class(TObject)
    public
      Rect : trect;
      IDTimeline : integer;
      OffsetTextX : integer;
      OffsetTextY : integer;
      Color : tcolor;
      FontColor : tcolor;
      FontSize : integer;
      FontName : tfontname;
      FontStyles : tfontstyles;
      imgRect : trect;
      BlockRect : trect;
      BlockSelect : boolean;
      StatusRect : trect;
      StatusSelect : boolean;
    procedure MoveMouse(cv : tcanvas; Grid : tstringgrid; X, Y : integer);
    function ClickEditTl(cv : tcanvas; Grid : tstringgrid; X, Y : integer) : TTLNResult;
    Procedure AssignTL(cv : tcanvas; Grid : tstringgrid; TLN : TTimeLineName);
    function GridPosition( Grid : tstringgrid; IDTimeline : integer) : integer;
    function TLPosition(NM : TNamesTL; IDTimeline : integer) : integer;
    procedure Draw(cv : tcanvas; Grid : tstringgrid; Top, Height : integer);
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    Constructor Create;
    Destructor Destroy; override;
  end;

  TZoneReview = Class(TObject)
    public
      Rect : trect;
      ImgRect : Trect;
      Selection : boolean;
      Color : tcolor;
      FontColor : tcolor;
      FontSize : integer;
      FontName : tfontname;
      FontStyles : tfontstyles;
      startview : integer;
      stopview : integer;
    procedure Draw(cv : tcanvas; Top, Height : integer);
    procedure MouseMove(cv : tcanvas; X, Y : integer);
    function ClickViewer(cv : tcanvas; X, Y : integer) : TTLNResult;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLHeights = Class(TObject)
    public
      MaxHeight : integer;
      MinHeightTL : integer;
      Step : integer;
      Scaler : integer;
      IntervalEdit : integer;
      Edit : integer;
      IntervalTL : integer;
      Timelines : integer;
      Review : integer;
      HeightTL : integer;
      Interval : integer;
    function StepPlus : boolean;
    function StepMinus : boolean;
    function Height : integer;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    Constructor Create;
    Destructor Destroy; override;
  end;

  TTLNames = Class(TObject)
    public
      BackGround : tcolor;
      Color : tcolor;
      Font : tfont;
      Scaler : TZoneScaler;
      Edit : TZoneEditTL;
      NamesTL : TNamesTL;
      Review : TZoneReview;
    Procedure Update;
    Procedure Draw(cv : tcanvas; Grid : tstringgrid; updtl : boolean);
    function ClickTTLNames(cv : tcanvas; Grid : tstringgrid; X, Y : integer) : TTLNResult;
    Procedure MoveMouse(cv : tcanvas; Grid : tstringgrid; X, Y : integer);
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    Constructor Create;
    Destructor Destroy; override;
  end;

Var HScale,HEditTL,HTimelines,HView,HDelt : integer;
    ZoneNames : TTLNames;
    //ZoneTimelines : array[0..18] of trect;
    CountTL : Integer;
    Scal  : TZoneScaler;
    EditTL : TZoneEditTL;
    NamesTL : TNamesTL;
    TLHeights : TTLHeights;

    ZoneReview : TZoneReview;
    ZoneNamesLeft, ZoneNamesRight : integer;
    TLBitmap : integer;

implementation

uses umain, uinitforms, ucommon, uimgbuttons, ugrtimelines, uplayer, umyfiles;

//Класс TTLNames отвечает за работу с зоной имен тайм-линий

Constructor TTLNames.Create;
begin
  inherited;
    BackGround := TLBackGround;
    Color := TLZoneNamesColor;
    Font := tfont.Create;
    Font.Size := TLZoneNamesFontSize;
    Font.Color := TLZoneNamesFontColor;
    Font.Name := TLZoneNamesFontName;
    Scaler := TZoneScaler.Create;
    Edit := TZoneEditTL.Create;
    NamesTL := TNamesTL.Create;
    Review := TZoneReview.Create;
end;

Destructor TTLNames.Destroy;
begin
  FreeMem(@BackGround);
  FreeMem(@Color);
  Font.Free;
  Scaler.Free;
  Edit.Free;
  NamesTL.Free;
  Review.Free;
  inherited;
end;

Procedure TTLNames.Update;
var i : integer;
begin
  Scaler.Color:=Color;
  Scaler.FontColor := Font.Color;
  Scaler.FontSize  := Font.Size;
  Scaler.FontName  := Font.Name;
  Scaler.FontStyles := Font.Style;
  Scaler.plusHSelect:=false;
  Scaler.minusHSelect:=false;
  Scaler.plusWSelect:=false;
  Scaler.plusWSelect:=false;
  Scaler.procentSelect:=false;
  Edit.Color:=Color;
  Edit.FontColor := Font.Color;
  Edit.FontSize  := Font.Size;
  Edit.FontName  := Font.Name;
  Edit.FontStyles := Font.Style;
  Edit.BlockSelect:=false;
  Edit.StatusSelect:=false;
  NamesTL.Color:=Color;
  NamesTL.FontColor := Font.Color;
  NamesTL.FontSize  := Font.Size;
  NamesTL.FontName  := Font.Name;
  NamesTL.FontStyles := Font.Style;
  for i:=0 to NamesTL.Count-1 do begin
    NamesTL.Names[i].Color:=Color;
    NamesTL.Names[i].FontColor := Font.Color;
    NamesTL.Names[i].FontSize  := Font.Size;
    NamesTL.Names[i].FontName  := Font.Name;
    NamesTL.Names[i].FontStyles := Font.Style;
    NamesTL.Names[i].Selection := false;
  end;
  Review.Color:=Color;
  Review.FontColor := Font.Color;
  Review.FontSize  := Font.Size;
  Review.FontName  := Font.Name;
  Review.FontStyles := Font.Style;
end;

Procedure TTLNames.Draw(cv : tcanvas; Grid : tstringgrid; updtl : boolean);
var tp : integer;
begin
  cv.Brush.Style:=bsSolid;
  cv.Brush.Color:=BackGround;
  cv.FillRect(cv.ClipRect);

  NamesTL.HeightTL:=TLHeights.HeightTL;
  NamesTL.Interval:=TLHeights.Interval;

  Scaler.Draw(cv,TLHeights.Scaler);
  tp:=TLHeights.Scaler+TLHeights.IntervalEdit;
  ZoneNames.Edit.Draw(cv,Grid,tp,TLHeights.Edit);

  tp:=tp + TLHeights.Edit + TLHeights.IntervalTL;
  ZoneNames.NamesTL.Init(Grid, updtl);
  ZoneNames.NamesTL.Draw(cv, Grid, tp, TLHeights.Timelines);

  tp:=tp + TLHeights.Timelines + TLHeights.Interval;
  ZoneNames.Review.Draw(cv, tp, TLHeights.Review);
end;

Procedure TTLNames.MoveMouse(cv : tcanvas; Grid : tstringgrid; X, Y : integer);
begin
  Scaler.MoveMouse(cv,X,Y);
  Edit.MoveMouse(cv,Grid,X,Y);
  NamesTL.MoveMouse(cv,Grid,X,Y);
  Review.MouseMove(cv,X,Y);
end;

function TTLNames.ClickTTLNames(cv : tcanvas; Grid : tstringgrid; X, Y : integer) : TTLNResult;
var res, APos, GPos : integer;
begin
  Result:=Scaler.ClickScaler(cv, X, Y);
  if Result.Button<>btnone then begin
        case Result.Button of
     btplusH   : TLHeights.StepPlus;
     btminusH  : TLHeights.StepMinus;
     btplusW   : TLZone.PlusHoriz;
     btminusW  : TLZone.MinusHoriz;
     btprocent : begin
                 end;
        end;
    //TLZone.DrawBitmap(bmptimeline);
    TLZone.TLEditor.DrawEditor(bmptimeline.Canvas);
    if mode <> play then TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
    TLZone.DrawLayer2(Form1.imgLayer2.Canvas);
    exit;
  end;
  Result:=Edit.ClickEditTl(cv, Grid, X, Y);
  if Result.Button<>btnone then begin
    APos:=Edit.TLPosition(NamesTL,Result.ID);
    if APos=-1 then exit;
    NamesTL.Names[APos].Draw(cv,Grid,APos);
    exit;
  end;
  Result:=NamesTL.ClickNamesTL(cv, X, Y);
  if Result.Position >= 0 then begin
     Edit.AssignTL(cv, Grid, NamesTL.Names[Result.Position]);
     //TLZone.DrawBitmap(bmptimeline);
     TLZone.TLEditor.DrawEditor(bmptimeline.Canvas);
     if mode <> play then TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
     exit;
  end;
  Result:=Review.ClickViewer(cv, X, Y);
end;

Procedure TTLNames.WriteToStream(F : tStream);
begin
  F.WriteBuffer(BackGround, SizeOf(BackGround));
  F.WriteBuffer(Color, SizeOf(Color));
  //Font : tfont;
  Scaler.WriteToStream(F);
  Edit.WriteToStream(F);
  NamesTL.WriteToStream(F);
  Review.WriteToStream(F);
end;

Procedure TTLNames.ReadFromStream(F : tStream);
begin
  F.ReadBuffer(BackGround, SizeOf(BackGround));
  F.ReadBuffer(Color, SizeOf(Color));
  //Font : tfont;
  Scaler.ReadFromStream(F);
  Edit.ReadFromStream(F);
  NamesTL.ReadFromStream(F);
  Review.ReadFromStream(F);
end;

//Класс TTLHeights отвечает за высоты элементов зоны тайм-линий

Constructor TTLHeights.Create;
begin
  inherited;
  MinHeightTL := 25;
  Step :=2;
  Scaler :=MinHeightTL;
  IntervalEdit:=16;
  HeightTL := MinHeightTL+10;
  Edit := HeightTL * 3;
  Review := HeightTL + 10;
  Interval := trunc(HeightTL / 10);
  IF Interval < 2 then Interval := 2;
  IntervalTL := 3 * interval;
  Timelines := (HeightTL + Interval) * 3 - Interval;
  MaxHeight := 22*MinHeightTL + 16*Interval + IntervalEdit + IntervalTL;
end;

Destructor TTLHeights.Destroy;
begin
  FreeMem(@MaxHeight);
  FreeMem(@MinHeightTL);
  FreeMem(@Step);
  FreeMem(@IntervalEdit);
  FreeMem(@IntervalTL);
  FreeMem(@Scaler);
  FreeMem(@Edit);
  FreeMem(@Timelines);
  FreeMem(@Review);
  FreeMem(@HeightTL);
  FreeMem(@Interval);
  inherited Destroy;
end;

function TTLHeights.Height : integer;
begin
  Timelines := (HeightTL + Interval) * (Form1.GridTimeLines.RowCount-1) - Interval;
  Result := Scaler + IntervalEdit + Edit + IntervalTL + Timelines + Interval + Review;
end;

function TTLHeights.StepPlus : boolean;
var ed, tl, intrv, rv, htl, hght : integer;
begin
  result := false;
  ed := Edit + Step;
  htl := HeightTL + Step;
  intrv := trunc(HeightTL / 10);
  if intrv < 2 then intrv := 2;
  rv := Review + Step;
  hght := Scaler + intervaledit + ed + intervaltl + (htl + intrv) * (Form1.GridTimeLines.RowCount-1) + rv;
  if hght <= MaxHeight then begin
    Edit := Edit + Step;
    Review := Review + Step;
    HeightTL :=HeightTL + Step;
    Interval := intrv;
    Timelines := (HeightTL + Interval) * (Form1.GridTimeLines.RowCount-1) - Interval;
    result := true;
  end;
  UpdatePanelPrepare;
end;

function TTLHeights.StepMinus : boolean;
var ed, tl, intrv, rv, htl, hght : integer;
begin
  result := true;
  if HeightTL - Step < MinHeightTL then begin
    HeightTL:=MinHeightTL;
    Interval := trunc(HeightTL / 10);
    If Interval < 2 then Interval := 2;
    Edit := 3 * MinHeightTL;
    Review := 2 * MinHeightTL;
    Timelines := (HeightTL + Interval) * (Form1.GridTimeLines.RowCount-1) - Interval;
    result := false;
    exit;
  end;
  Edit := Edit - Step;
  HeightTL := HeightTL - Step;
  Interval := trunc(HeightTL / 10);
  If Interval < 2 then Interval := 2;
  Review := Review - Step;
  Timelines := (HeightTL + Interval) * (Form1.GridTimeLines.RowCount-1) - Interval;
  UpdatePanelPrepare;
end;

Procedure TTLHeights.WriteToStream(F : tStream);
begin
  F.WriteBuffer(MaxHeight, SizeOf(MaxHeight));
  F.WriteBuffer(MinHeightTL, SizeOf(MinHeightTL));
  F.WriteBuffer(Step, SizeOf(Step));
  F.WriteBuffer(Scaler, SizeOf(Scaler));
  F.WriteBuffer(IntervalEdit, SizeOf(IntervalEdit));
  F.WriteBuffer(Edit, SizeOf(Edit));
  F.WriteBuffer(IntervalTL, SizeOf(IntervalTL));
  F.WriteBuffer(Timelines, SizeOf(Timelines));
  F.WriteBuffer(Review, SizeOf(Review));
  F.WriteBuffer(HeightTL, SizeOf(HeightTL));
  F.WriteBuffer(Interval, SizeOf(Interval));
end;

Procedure TTLHeights.ReadFromStream(F : tStream);
begin
  F.ReadBuffer(MaxHeight, SizeOf(MaxHeight));
  F.ReadBuffer(MinHeightTL, SizeOf(MinHeightTL));
  F.ReadBuffer(Step, SizeOf(Step));
  F.ReadBuffer(Scaler, SizeOf(Scaler));
  F.ReadBuffer(IntervalEdit, SizeOf(IntervalEdit));
  F.ReadBuffer(Edit, SizeOf(Edit));
  F.ReadBuffer(IntervalTL, SizeOf(IntervalTL));
  F.ReadBuffer(Timelines, SizeOf(Timelines));
  F.ReadBuffer(Review, SizeOf(Review));
  F.ReadBuffer(HeightTL, SizeOf(HeightTL));
  F.ReadBuffer(Interval, SizeOf(Interval));
end;

//Класс TZoneReview - отвечает за область отображения всех тайм линий;

Constructor TZoneReview.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 60;
  ImgRect.Left := 0;
  ImgRect.Right := 0;
  ImgRect.Top := 0;
  ImgRect.Bottom := 60;
  Selection := false;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  startview := 0;
  stopview := 0;
end;

Destructor TZoneReview.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@ImgRect);
  FreeMem(@Selection);
  FreeMem(@startview);
  FreeMem(@stopview);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontStyles);
  inherited Destroy;
end;

procedure TZoneReview.Draw(cv : tcanvas; Top, Height : integer);
begin
  cv.Pen.Color:=FontColor;
  cv.Font.Size:=FontSize - 1;
  cv.Font.Color:=FontColor;
  cv.Font.Name:=FontName;
  cv.Font.Style:=FontStyles;
  cv.Pen.Color:=FontColor;
  Rect.Left:=cv.ClipRect.Left;
  Rect.Right:=cv.ClipRect.Right;
  Rect.Top:=Top;
  Rect.Bottom:=Top + Height;
  cv.Brush.Color:=Color;
  cv.FillRect(Rect);
  ImgRect.Left:=cv.ClipRect.Left + 10;
  ImgRect.Right:=imgRect.Left + 30;
  ImgRect.Top:=Top + (Height -25) div 2;
  ImgRect.Bottom:=ImgRect.Top + 25;
  if Selection then  cv.Brush.Color:=Color else cv.Brush.Color:=SmoothColor(Color,32);
  cv.FillRect(ImgRect);
end;

function TZoneReview.ClickViewer(cv : tcanvas; X, Y : integer) : TTLNResult;
begin
  Result.Zone:=znreview;
  Result.ID:=-1;
  Result.Position:=-1;
  Result.Button:=btnone;
  if (X > ImgRect.Left) and (X < ImgRect.Right) and (Y > ImgRect.Top) and (Y < ImgRect.Bottom)
    then Result.Button:=btreview;
end;

procedure TZoneReview.MouseMove(cv : tcanvas; X, Y : integer);
begin
  if (X > ImgRect.Left) and (X < ImgRect.Right) and (Y > ImgRect.Top) and (Y < ImgRect.Bottom)
    then Selection:=true else Selection:=false;
  Draw(cv,Rect.Top,Rect.Bottom - Rect.Top);
end;

Procedure TZoneReview.WriteToStream(F : tStream);
var fsbl : boolean;
begin
  F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
  F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
  F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

  F.WriteBuffer(ImgRect.Top, SizeOf(ImgRect.Top));
  F.WriteBuffer(ImgRect.Bottom, SizeOf(ImgRect.Bottom));
  F.WriteBuffer(ImgRect.Left, SizeOf(ImgRect.Left));
  F.WriteBuffer(ImgRect.Right, SizeOf(ImgRect.Right));

  F.WriteBuffer(Selection, SizeOf(Selection));

  F.WriteBuffer(Color, SizeOf(Color));
  F.WriteBuffer(FontColor, SizeOf(FontColor));
  F.WriteBuffer(FontSize, SizeOf(FontSize));
  WriteBufferStr(F, FontName);

  if fsBold in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsItalic in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsUnderline in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsStrikeOut in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));

  F.WriteBuffer(startview, SizeOf(startview));
  F.WriteBuffer(stopview, SizeOf(stopview));
end;

Procedure TZoneReview.ReadFromStream(F : tStream);
var fsbl : boolean;
begin
  F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
  F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
  F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

  F.ReadBuffer(ImgRect.Top, SizeOf(ImgRect.Top));
  F.ReadBuffer(ImgRect.Bottom, SizeOf(ImgRect.Bottom));
  F.ReadBuffer(ImgRect.Left, SizeOf(ImgRect.Left));
  F.ReadBuffer(ImgRect.Right, SizeOf(ImgRect.Right));

  F.ReadBuffer(Selection, SizeOf(Selection));

  F.ReadBuffer(Color, SizeOf(Color));
  F.ReadBuffer(FontColor, SizeOf(FontColor));
  F.ReadBuffer(FontSize, SizeOf(FontSize));
  ReadBufferStr(F, FontName);

  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsBold] else FontStyles := FontStyles - [fsBold];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsItalic] else FontStyles := FontStyles - [fsItalic];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsUnderline] else FontStyles := FontStyles - [fsUnderline];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsStrikeOut] else FontStyles := FontStyles - [fsStrikeOut];

  F.ReadBuffer(startview, SizeOf(startview));
  F.ReadBuffer(stopview, SizeOf(stopview));
end;

//================= TNamesTL ======================

Constructor TNamesTL.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 60;
  Interval := 3;
  HeightTL := 25;
  Count :=0;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
end;

Destructor TNamesTL.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@Interval);
  FreeMem(@HeightTL);
  FreeMem(@Count);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontStyles);
  FreeMem(@Names);
  inherited Destroy;
end;

function TNamesTL.Add(Timeline : TTimelineOptions) : integer;
begin
  Count:=Count+1;
  setlength(Names,count);
  Names[Count-1]:=TTimelineName.Create;
  Names[Count-1].Rect.Left:=Rect.Left;
  Names[Count-1].Rect.Right:=Rect.Right;
  Names[Count-1].Rect.Top:=Rect.Top + (HeightTL + Interval) * (Count-1);
  Names[Count-1].Rect.Bottom:=Names[Count-1].Rect.Top + HeightTL;
  Names[Count-1].IDTimeline:=Timeline.IDTimeline;
  Names[Count-1].Selection := false;
  Names[Count-1].OffsetTextX:=20;
  Names[Count-1].Color:=Color;
  Names[Count-1].FontColor:=FontColor;
  Names[Count-1].FontSize:=FontSize;
  Names[Count-1].FontName:=FontName;
  Names[Count-1].FontStyles:=FontStyles;
  result := Count-1;
end;

procedure TNamesTL.Clear;
var i : integer;
begin
  if Count <= 0 then exit;
  for i:=Count-1 downto 0 do Names[i].FreeInstance;
  setlength(Names,0);
  Count:=0;
end;

function TNamesTL.Init( Grid : tstringgrid; erase : boolean) : integer;
var i, APos, Hght : integer;
begin
  Result := 0;
  //if erase then
  Clear;
  For i:=1 to Grid.RowCount-1 do begin
    if Grid.Objects[0,i] is TTimelineOptions
      then APos:=Add(Grid.Objects[0,i] as TTimelineOptions);

    Result := Result + HeightTL + Interval;
  end;
  Result := Result - Interval;
end;

procedure TNamesTL.Draw(cv : tcanvas; Grid : tstringgrid; Top, Height : integer);
var i, tp : integer;
begin
  tp:=Top;
  Rect.Left:=cv.ClipRect.Left;
  Rect.Right:=cv.ClipRect.Right;
  Rect.Top:=Top;
  Rect.Bottom:=Top + Height;
  for i:=0 to Count-1 do begin
    Names[i].Rect.Left:=Rect.Left;
    Names[i].Rect.Right:=Rect.Right;
    Names[i].Rect.Top:=tp;
    Names[i].Rect.Bottom:=Names[i].Rect.Top+HeightTL;
    Names[i].Draw(cv,Grid,i);
    tp := Names[i].Rect.Bottom + Interval;
  end;
end;

function TNamesTL.ClickNamesTL(cv : tcanvas; X, Y : integer) : TTLNResult;
var i, j : integer;
begin

  Result.Zone:=zntimelines;
  Result.ID:=-1;
  Result.Position:=-1;
  Result.Button:=btnone;
  for i := 0 to Count-1 do begin
    if (X > Names[i].Rect.Left+10) and (X < Names[i].Rect.Right-10) and (Y+2 > Names[i].Rect.Top) and (Y-2 < Names[i].Rect.Bottom)
    then begin
       Result.ID:=Names[i].IDTimeline;
       Result.Position:=i;
       Result.Button:=bttimeline;
       for j:=0 to Count-1 do Names[j].Editing:=false;
       Names[i].Editing:=true;
    end;
  end;
  //Draw(cv,Rect.Top,Rect.Bottom-Rect.Top);
end;

Procedure TNamesTL.MoveMouse(cv : tcanvas; Grid : tstringgrid; X, Y : integer);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if (X > Names[i].Rect.Left+10) and (X < Names[i].Rect.Right-10) and (Y+2 > Names[i].Rect.Top) and (Y-2 < Names[i].Rect.Bottom)
      then Names[i].Selection:=true else Names[i].Selection:=false;
  end;
  Draw(cv,Grid,Rect.Top,Rect.Bottom-Rect.Top);
end;

Procedure TNamesTL.WriteToStream(F : tStream);
var i : integer;
    fsbl : boolean;
begin
  F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
  F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
  F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

  F.WriteBuffer(Interval, SizeOf(Interval));
  F.WriteBuffer(HeightTL, SizeOf(HeightTL));

  F.WriteBuffer(Color, SizeOf(Color));
  F.WriteBuffer(FontColor, SizeOf(FontColor));
  F.WriteBuffer(FontSize, SizeOf(FontSize));
  WriteBufferStr(F, FontName);

  if fsBold in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsItalic in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsUnderline in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsStrikeOut in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));

  F.WriteBuffer(Count, SizeOf(Count));
  for i:=0 to Count-1 do Names[i].WriteToStream(F);
end;

Procedure TNamesTL.ReadFromStream(F : tStream);
var i : integer;
    fsbl : boolean;
begin
  F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
  F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
  F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

  F.ReadBuffer(Interval, SizeOf(Interval));
  F.ReadBuffer(HeightTL, SizeOf(HeightTL));

  F.ReadBuffer(Color, SizeOf(Color));
  F.ReadBuffer(FontColor, SizeOf(FontColor));
  F.ReadBuffer(FontSize, SizeOf(FontSize));
  ReadBufferStr(F, FontName);

  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsBold] else FontStyles := FontStyles - [fsBold];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsItalic] else FontStyles := FontStyles - [fsItalic];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsUnderline] else FontStyles := FontStyles - [fsUnderline];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsStrikeOut] else FontStyles := FontStyles - [fsStrikeOut];

  Clear;
  F.ReadBuffer(Count, SizeOf(Count));
  for i:=0 to Count-1 do begin
    Setlength(Names, i+1);
    Names[i] := TTimelineName.Create;
    Names[i].ReadFromStream(F);
  end;
end;

//========= Класс одного поля тайм-лайна TTimeLineName

Constructor TTimeLineName.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  IDTimeline := 1;
  Selection := false;
  Editing := false;
  OffsetTextX := 20;
  Color := clGray;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  imgRect.Left := 0;
  imgRect.Right := 0;
  imgRect.Top := 0;
  imgRect.Bottom := 0;
  BlockRect.Left := 0;
  BlockRect.Right := 0;
  BlockRect.Top := 0;
  BlockRect.Bottom := 0;
  StatusRect.Left := 0;
  StatusRect.Right := 0;
  StatusRect.Top := 0;
  StatusRect.Bottom := 0;
end;

Destructor TTimeLineName.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@IDTimeline);
  FreeMem(@Selection);
  FreeMem(@Editing);
  FreeMem(@OffsetTextX);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontStyles);
  FreeMem(@imgRect);
  FreeMem(@BlockRect);
  FreeMem(@StatusRect);
  inherited Destroy;
end;

procedure TTimeLineName.Draw(cv : tcanvas; Grid : tstringgrid; APos : integer);
var text : string;
    hgh : integer;
begin
  cv.Pen.Color:=FontColor;
  cv.Font.Size:=FontSize - 1;

  if Editing
    then cv.Font.Color:=FontColor
    else cv.Font.Color:=SmoothColor(Color,128);
  cv.Font.Name:=FontName;
  cv.Font.Style:=FontStyles;
  cv.Pen.Color:=FontColor;

  if Selection
    then cv.Brush.Color:=SmoothColor(Color,32)
    else cv.Brush.Color:=Color;
  cv.FillRect(Rect);
  cv.Brush.Style:=bsClear;

  if (Grid.Objects[0,APos+1] is TTimelineOptions) then begin

    imgRect.Left:=Rect.Left + 1;
    imgRect.Right:=imgRect.Left + 21;
    imgRect.Top:=Rect.Top+(Rect.Bottom - Rect.Top - 20) div 2;
    ImgRect.Bottom:=imgRect.Top+20;
    with (Grid.Objects[0,APos+1] as TTimelineOptions) do begin
            Case TypeTL of
      tldevice: Text:='Tools';
      tltext  : Text:='Text';
      tlmedia : Text:='Media';
            end;
      LoadBMPFromRes(cv, imgRect, 20, 20, Text + inttostr(NumberBmp));
      hgh:=(Rect.Bottom - Rect.Top - cv.TextHeight('Name')) div 2;
      cv.TextOut(ImgRect.Right+10,Rect.Top + hgh,Name);
    end;

    StatusRect.Left:=Rect.Right-22;
    StatusRect.Right:=Rect.Right-8;
    StatusRect.Top:=Rect.Top+(Rect.Bottom - Rect.Top - 16) div 2;
    StatusRect.Bottom:=StatusRect.Top + 16;
    cv.Pen.Color:=FontColor;

    cv.Brush.Color:= StatusColor[(Grid.Objects[0,APos+1] as TTimelineOptions).Status];
    cv.Pen.Color:=FontColor;
    cv.Ellipse(StatusRect);

    BlockRect.Right:=StatusRect.Left-10;
    BlockRect.Left:=BlockRect.Right-18;
    BlockRect.Top:=Rect.Top+(Rect.Bottom - Rect.Top - 18) div 2;
    BlockRect.Bottom:=BlockRect.Top + 18;
    if (Grid.Objects[0,APos+1] as TTimelineOptions).Block
      then LoadBMPFromRes(cv, BlockRect, 20, 20, 'Unlock')
      else LoadBMPFromRes(cv, BlockRect, 20, 20, 'Lock');
  end;
end;

Procedure TTimeLineName.WriteToStream(F : tStream);
var fsbl : boolean;
begin
  F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
  F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
  F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

  F.WriteBuffer(IDTimeline, SizeOf(IDTimeline));
  F.WriteBuffer(Selection, SizeOf(Selection));
  F.WriteBuffer(Editing, SizeOf(Editing));
  F.WriteBuffer(OffsetTextX, SizeOf(OffsetTextX));
  F.WriteBuffer(Color, SizeOf(Color));
  F.WriteBuffer(FontColor, SizeOf(FontColor));
  F.WriteBuffer(FontSize, SizeOf(FontSize));
  WriteBufferStr(F, FontName);

  if fsBold in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsItalic in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsUnderline in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsStrikeOut in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));

  F.WriteBuffer(imgRect.Top, SizeOf(imgRect.Top));
  F.WriteBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
  F.WriteBuffer(imgRect.Left, SizeOf(imgRect.Left));
  F.WriteBuffer(imgRect.Right, SizeOf(imgRect.Right));

  F.WriteBuffer(BlockRect.Top, SizeOf(BlockRect.Top));
  F.WriteBuffer(BlockRect.Bottom, SizeOf(BlockRect.Bottom));
  F.WriteBuffer(BlockRect.Left, SizeOf(BlockRect.Left));
  F.WriteBuffer(BlockRect.Right, SizeOf(BlockRect.Right));

  F.WriteBuffer(StatusRect.Top, SizeOf(integer));
  F.WriteBuffer(StatusRect.Bottom, SizeOf(integer));
  F.WriteBuffer(StatusRect.Left, SizeOf(integer));
  F.WriteBuffer(StatusRect.Right, SizeOf(integer));
end;

Procedure TTimeLineName.ReadFromStream(F : tStream);
var fsbl : boolean;
begin
  F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
  F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
  F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

  F.ReadBuffer(IDTimeline, SizeOf(IDTimeline));
  F.ReadBuffer(Selection, SizeOf(Selection));
  F.ReadBuffer(Editing, SizeOf(Editing));
  F.ReadBuffer(OffsetTextX, SizeOf(OffsetTextX));
  F.ReadBuffer(Color, SizeOf(Color));
  F.ReadBuffer(FontColor, SizeOf(FontColor));
  F.ReadBuffer(FontSize, SizeOf(FontSize));
  ReadBufferStr(F, FontName);

  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsBold] else FontStyles := FontStyles - [fsBold];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsItalic] else FontStyles := FontStyles - [fsItalic];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsUnderline] else FontStyles := FontStyles - [fsUnderline];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsStrikeOut] else FontStyles := FontStyles - [fsStrikeOut];

  F.ReadBuffer(imgRect.Top, SizeOf(imgRect.Top));
  F.ReadBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
  F.ReadBuffer(imgRect.Left, SizeOf(imgRect.Left));
  F.ReadBuffer(imgRect.Right, SizeOf(imgRect.Right));

  F.ReadBuffer(BlockRect.Top, SizeOf(BlockRect.Top));
  F.ReadBuffer(BlockRect.Bottom, SizeOf(BlockRect.Bottom));
  F.ReadBuffer(BlockRect.Left, SizeOf(BlockRect.Left));
  F.ReadBuffer(BlockRect.Right, SizeOf(BlockRect.Right));

  F.ReadBuffer(StatusRect.Top, SizeOf(StatusRect.Top));
  F.ReadBuffer(StatusRect.Bottom, SizeOf(StatusRect.Bottom));
  F.ReadBuffer(StatusRect.Left, SizeOf(StatusRect.Left));
  F.ReadBuffer(StatusRect.Right, SizeOf(StatusRect.Right));
end;

//=================== Зона редактируемуего тайм-лайна ZoneEditTL

Constructor TZoneEditTL.Create;
begin
  inherited;
  Rect.Left := 0;
  Rect.Right := 0;
  Rect.Top := 0;
  Rect.Bottom := 0;
  IDTimeline := 1;
  OffsetTextX := 20;
  OffsetTextY := 5;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  imgRect.Left := 0;
  imgRect.Right := 0;
  imgRect.Top := 0;
  imgRect.Bottom := 0;
  BlockRect.Left := 0;
  BlockRect.Right := 0;
  BlockRect.Top := 0;
  BlockRect.Bottom := 0;
  BlockSelect := false;
  StatusRect.Left := 0;
  StatusRect.Right := 0;
  StatusRect.Top := 0;
  StatusRect.Bottom := 0;
  StatusSelect := false;
end;

Destructor TZoneEditTL.Destroy;
begin
  FreeMem(@Rect);
  FreeMem(@IDTimeline);
  FreeMem(@OffsetTextX);
  FreeMem(@OffsetTextY);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontStyles);
  FreeMem(@imgRect);
  FreeMem(@BlockRect);
  FreeMem(@BlockSelect);
  FreeMem(@StatusRect);
  FreeMem(@StatusSelect);
  inherited Destroy;
end;

procedure TZoneEditTL.Draw(cv : tcanvas; Grid : tstringgrid; Top, Height : integer);
var APos : integer;
    Text : string;
begin
  cv.Font.Size:=FontSize + 2;;
  cv.Font.Color:=FontColor;
  cv.Font.Name:=FontName;
  cv.Font.Style:=FontStyles;
  cv.Pen.Color:=FontColor;

  Rect.Left:=cv.ClipRect.Left;
  Rect.Right:=cv.ClipRect.Right;
  Rect.Top:=cv.ClipRect.Top + Top;
  Rect.Bottom:=Rect.Top + Height;

  cv.Brush.Color:=Color;
  cv.FillRect(Rect);
  cv.Brush.Style:=bsClear;

  APos := GridPosition(Grid,IDTimeline);
  if APos=-1 then APos:=1;
  if (Grid.Objects[0,Apos] is TTimelineOptions) then begin
    imgRect.Left:=Rect.Left + 1;
    imgRect.Right:=imgRect.Left + 20;
    imgRect.Top:=Rect.Top+OffsetTextY;
    ImgRect.Bottom:=imgRect.Top+20;
    with (Grid.Objects[0,Apos] as TTimelineOptions) do begin
            Case TypeTL of
      tldevice: Text:='Tools';
      tltext  : Text:='Text';
      tlmedia : Text:='Media';
            end;
      LoadBMPFromRes(cv, imgRect, 20, 20, Text + inttostr(NumberBmp));
      cv.TextOut(ImgRect.Right+10,Rect.Top + OffsetTextY,Name);
      StatusRect.Left:=Rect.Right-24;
      StatusRect.Right:=Rect.Right-4;
      StatusRect.Bottom:=Rect.Bottom-4;
      StatusRect.Top:=StatusRect.Bottom-20;
      cv.Pen.Color:=clWhite;

      if StatusSelect then begin
        cv.Brush.Color:=SmoothColor(StatusColor[Status],32);
        cv.Pen.Color:=SmoothColor(cv.Pen.Color,32);
      end else begin
        cv.Brush.Color:= StatusColor[Status];
        cv.Pen.Color:=FontColor;
      end;
      cv.Ellipse(StatusRect);

      BlockRect.Right:=StatusRect.Left-10;
      BlockRect.Left:=BlockRect.Right-20;
      BlockRect.Bottom:=Rect.Bottom-4;
      BlockRect.Top:=StatusRect.Bottom-20;

      if BlockSelect then cv.Brush.Color:=SmoothColor(Color,32) else cv.Brush.Color:= Color;
      cv.Pen.Color:=cv.Brush.Color;
      cv.Rectangle(BlockRect);
      if Block then begin
        LoadBMPFromRes(cv, BlockRect, 20, 20, 'Unlock');
        cv.Font.Size:=cv.Font.Size-3;
        cv.Brush.Color:= Color;
        UserLock:=CurrentUser;
        cv.TextOut(ImgRect.Right+10, Rect.Bottom-4-cv.TextHeight(UserLock),UserLock);
      end else begin
        LoadBMPFromRes(cv, BlockRect, 20, 20, 'Lock');
      end;
    end;
  end;
end;

function TZoneEditTL.GridPosition(Grid : tstringgrid; IDTimeline : integer) : integer;
var i : integer;
begin
  result := -1;
  for i:=1 to Grid.RowCount-1 do begin
    if Grid.Objects[0,i] is TTimelineOptions then begin
      if (Grid.Objects[0,i] as TTimelineOptions).IDTimeline=IDTimeline then begin
        result := i;
        exit;
      end;
    end;
  end;
end;

function TZoneEditTL.TLPosition(NM : TNamesTL; IDTimeline : integer) : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to NM.Count-1 do begin
    if NM.Names[i].IDTimeline=IDTimeline then begin
      result:=i;
      exit;
    end;
  end;
end;

Procedure TZoneEditTL.AssignTL(cv : tcanvas; Grid : tstringgrid; TLN : TTimeLineName);
var APos : integer;
begin
  IDTimeline :=TLN.IDTimeline;
  //TLZone.TLEditor.IDTimeline:=TLN.IDTimeline;
  //TLZone.FindTimeline(IDTimeline );
  //TLZone.TLEditor.Assign(TLN); //#########Warning
  Draw(cv, Grid, Rect.Top, Rect.Bottom-Rect.Top);
  APos := GridPosition(Grid, TLN.IDTimeline);
  TLZone.TLEditor.Assign(TLZone.Timelines[APos-1],APos);

  if APos > 0 then begin
    if Grid.Objects[0,Apos] is TTimelineOptions then begin
            case (Grid.Objects[0,Apos] as TTimelineOptions).TypeTL of
      tldevice : begin
                   Form1.pnDevTL.Visible:=true;
                   Form1.PnTextTL.Visible:=false;
                   Form1.pnMediaTL.Visible:=false;
                   btnsdevicepr.BackGround:=ProgrammColor;
                   InitBTNSDEVICE(Form1.imgDeviceTL.Canvas, (Grid.Objects[0,APos] as TTimelineOptions), btnsdevicepr);
                 end;
      tltext   : begin
                   Form1.pnDevTL.Visible:=false;
                   Form1.PnTextTL.Visible:=true;
                   Form1.pnMediaTL.Visible:=false;
                   Form1.imgTextTL.Width:=Form1.pnPrepareCTL.Width;
                   Form1.imgTextTL.Picture.Bitmap.Width:=Form1.imgTextTL.Width;
                   btnstexttl.Draw(Form1.imgTextTL.Canvas);
                 end;
      tlmedia  : begin
                   Form1.pnDevTL.Visible:=false;
                   Form1.PnTextTL.Visible:=false;
                   Form1.pnMediaTL.Visible:=true;
                   Form1.imgMediaTL.Picture.Bitmap.Width := Form1.imgMediaTL.Width;
                   Form1.imgMediaTL.Picture.Bitmap.Height := Form1.imgMediaTL.Height;
                   btnsmediatl.Top:=Form1.imgMediaTL.Height div 2 - 35;
                   btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
                 end;
            end; //case
      UpdatePanelPrepare;
    end;
  end;
end;

function TZoneEditTL.ClickEditTl(cv : tcanvas; Grid : tstringgrid; X, Y : integer) : TTLNResult;
var GPos : integer;
begin
  StatusSelect := false;
  BlockSelect :=false;
  Result.Zone := znedit;
  Result.ID:=IDTimeline;
  Result.Position:=-1;
  Result.Button:=btnone;
  GPos:=GridPosition(Grid,IDTimeline);
  if Grid.Objects[0,GPos] is TTimelineOptions then begin
    if (X > StatusRect.Left) and (X < StatusRect.Right) and (Y > StatusRect.Top) and (Y < StatusRect.Bottom) then begin
      Result.ID:=IDTimeline;
      Result.Button:=btstatus;
      (Grid.Objects[0,GPos] as TTimelineOptions).Status:=(Grid.Objects[0,GPos] as TTimelineOptions).Status+1;
      If (Grid.Objects[0,GPos] as TTimelineOptions).Status > 4 then (Grid.Objects[0,GPos] as TTimelineOptions).Status:=0;
    end else if (X > BlockRect.Left) and (X < BlockRect.Right) and (Y > BlockRect.Top) and (Y < BlockRect.Bottom) then begin
      Result.ID:=IDTimeline;
      Result.Button:=btlock;
      (Grid.Objects[0,GPos] as TTimelineOptions).Block:=not (Grid.Objects[0,GPos] as TTimelineOptions).Block;
    end;
  end;
end;

procedure TZoneEditTL.MoveMouse(cv : tcanvas; Grid : tstringgrid; X, Y : integer);
begin
  StatusSelect := false;
  BlockSelect :=false;
  if (X > StatusRect.Left) and (X < StatusRect.Right) and (Y > StatusRect.Top) and (Y < StatusRect.Bottom) then StatusSelect := true
  else if (X > BlockRect.Left) and (X < BlockRect.Right) and (Y > BlockRect.Top) and (Y < BlockRect.Bottom) then BlockSelect := true;
  Draw(cv, Grid, Rect.Top, Rect.Bottom-Rect.Top);
end;

Procedure TZoneEditTL.WriteToStream(F : tStream);
var fsbl : boolean;
begin
  F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
  F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
  F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

  F.WriteBuffer(IDTimeline, SizeOf(IDTimeline));
  F.WriteBuffer(OffsetTextX, SizeOf(OffsetTextX));
  F.WriteBuffer(OffsetTextY, SizeOf(OffsetTextY));

  F.WriteBuffer(Color, SizeOf(Color));
  F.WriteBuffer(FontColor, SizeOf(FontColor));
  F.WriteBuffer(FontSize, SizeOf(FontSize));
  WriteBufferStr(F, FontName);

  if fsBold in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsItalic in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsUnderline in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsStrikeOut in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));

  F.WriteBuffer(imgRect.Top, SizeOf(imgRect.Top));
  F.WriteBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
  F.WriteBuffer(imgRect.Left, SizeOf(imgRect.Left));
  F.WriteBuffer(imgRect.Right, SizeOf(imgRect.Right));

  F.WriteBuffer(BlockRect.Top, SizeOf(BlockRect.Top));
  F.WriteBuffer(BlockRect.Bottom, SizeOf(BlockRect.Bottom));
  F.WriteBuffer(BlockRect.Left, SizeOf(BlockRect.Left));
  F.WriteBuffer(BlockRect.Right, SizeOf(BlockRect.Right));

  F.WriteBuffer(BlockSelect, SizeOf(BlockSelect));

  F.WriteBuffer(StatusRect.Top, SizeOf(StatusRect.Top));
  F.WriteBuffer(StatusRect.Bottom, SizeOf(StatusRect.Bottom));
  F.WriteBuffer(StatusRect.Left, SizeOf(StatusRect.Left));
  F.WriteBuffer(StatusRect.Right, SizeOf(StatusRect.Right));

  F.WriteBuffer(StatusSelect, SizeOf(StatusSelect));
end;

Procedure TZoneEditTL.ReadFromStream(F : tStream);
var fsbl : boolean;
begin
  F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
  F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
  F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

  F.ReadBuffer(IDTimeline, SizeOf(IDTimeline));
  F.ReadBuffer(OffsetTextX, SizeOf(OffsetTextX));
  F.ReadBuffer(OffsetTextY, SizeOf(OffsetTextY));

  F.ReadBuffer(Color, SizeOf(Color));
  F.ReadBuffer(FontColor, SizeOf(FontColor));
  F.ReadBuffer(FontSize, SizeOf(FontSize));
  ReadBufferStr(F, FontName);

  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsBold] else FontStyles := FontStyles - [fsBold];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsItalic] else FontStyles := FontStyles - [fsItalic];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsUnderline] else FontStyles := FontStyles - [fsUnderline];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsStrikeOut] else FontStyles := FontStyles - [fsStrikeOut];

  F.ReadBuffer(imgRect.Top, SizeOf(imgRect.Top));
  F.ReadBuffer(imgRect.Bottom, SizeOf(imgRect.Bottom));
  F.ReadBuffer(imgRect.Left, SizeOf(imgRect.Left));
  F.ReadBuffer(imgRect.Right, SizeOf(imgRect.Right));

  F.ReadBuffer(BlockRect.Top, SizeOf(BlockRect.Top));
  F.ReadBuffer(BlockRect.Bottom, SizeOf(BlockRect.Bottom));
  F.ReadBuffer(BlockRect.Left, SizeOf(BlockRect.Left));
  F.ReadBuffer(BlockRect.Right, SizeOf(BlockRect.Right));

  F.ReadBuffer(BlockSelect, SizeOf(BlockSelect));

  F.ReadBuffer(StatusRect.Top, SizeOf(StatusRect.Top));
  F.ReadBuffer(StatusRect.Bottom, SizeOf(StatusRect.Bottom));
  F.ReadBuffer(StatusRect.Left, SizeOf(StatusRect.Left));
  F.ReadBuffer(StatusRect.Right, SizeOf(StatusRect.Right));

  F.ReadBuffer(StatusSelect, SizeOf(StatusSelect));
end;


//================================Зона Подсмотра TZoneScaler

Constructor TZoneScaler.Create;
begin
  inherited;
  plusHSelect :=false;
  minusHSelect := false;
  plusWSelect := false;
  minusWSelect := false;
  plusHLock :=false;
  minusHLock := false;
  plusWLock := false;
  minusWLock := false;
  procentSelect := false;
  Rect.Left:=0;
  Rect.Right:=0;
  Rect.Top:=0;
  Rect.Bottom:=30;
  OffsetText := 22;
  Text := 'Масштаб';
  PlusH.Left:=0;
  PlusH.Right:=0;
  PlusH.Top:=0;
  PlusH.Bottom:=30;
  MinusH.Left:=0;
  MinusH.Right:=0;
  MinusH.Top:=0;
  MinusH.Bottom:=30;
  PlusW.Left:=0;
  PlusW.Right:=0;
  PlusW.Top:=0;
  PlusW.Bottom:=30;
  MinusW.Left:=0;
  MinusW.Right:=0;
  MinusW.Top:=0;
  MinusW.Bottom:=30;
  procent.Left:=0;
  procent.Right:=0;
  procent.Top:=0;
  procent.Bottom:=30;
  Color := TLZoneNamesColor;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontName := TLZoneNamesFontName;
  //FontStyles := False;
end;

destructor TZoneScaler.Destroy;
begin
  FreeMem(@plusHSelect);
  FreeMem(@minusHSelect);
  FreeMem(@plusWSelect);
  FreeMem(@minusWSelect);
  FreeMem(@plusHLock);
  FreeMem(@minusHLock);
  FreeMem(@plusWLock);
  FreeMem(@minusWLock);
  FreeMem(@procentSelect);
  FreeMem(@Rect);
  FreeMem(@OffsetText);
  FreeMem(@Text);
  FreeMem(@PlusH);
  FreeMem(@MinusH);
  FreeMem(@PlusW);
  FreeMem(@MinusW);
  FreeMem(@procent);
  FreeMem(@Color);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@FontStyles);
  inherited Destroy;
end;

procedure TZoneScaler.Draw(cv : tcanvas; height : integer);
var psx, psy: integer;
    s : string;
begin

  cv.Font.Size:=FontSize;
  cv.Font.Color:=FontColor;
  cv.Font.Name:=FontName;
  cv.Font.Style:=FontStyles;
  cv.Pen.Color:=FontColor;

  Rect.Left:=cv.ClipRect.Left;
  Rect.Right:=cv.ClipRect.Right;
  Rect.Top:=cv.ClipRect.Top;
  Rect.Bottom:=cv.ClipRect.Top + height;

  cv.Brush.Color:=Color;
  cv.FillRect(Rect);
  cv.Brush.Style:=bsClear;
  //OffsetText := 22;
  //Text := 'Масштаб';
  PlusH.Left:=cv.ClipRect.Left+1;
  PlusH.Right:=cv.ClipRect.Left + 19;
  PlusH.Top:=cv.ClipRect.Top + 1;
  PlusH.Bottom:=cv.ClipRect.Top - 1 + (height div 2);

  if PlusHSelect then cv.Brush.Color:=SmoothColor(Color, 32) else cv.Brush.Color:=Color;
  cv.Rectangle(PlusH);
  cv.TextRect(PlusH,PlusH.Left + (PlusH.Right-PlusH.Left - cv.TextWidth('+')) div 2,(PlusH.Bottom-PlusH.Top - cv.TextHeight('+')) div 2, '+');

  MinusH.Left:=cv.ClipRect.Left+1;
  MinusH.Right:=cv.ClipRect.Left + 19;
  MinusH.Top:=cv.ClipRect.Top + (height div 2)+ 1;
  MinusH.Bottom:=cv.ClipRect.Top + height - 1;

  if MinusHSelect then cv.Brush.Color:=SmoothColor(Color, 32) else cv.Brush.Color:=Color;
  cv.Rectangle(MinusH);
  cv.TextRect(MinusH,MinusH.Left + (MinusH.Right-MinusH.Left - cv.TextWidth('-')) div 2, MinusH.Top + (MinusH.Bottom-MinusH.Top - cv.TextHeight('-')) div 2, '-');
//  cv.TextOut(MinusH.Left + (MinusH.Right-MinusH.Left - cv.TextWidth('-')) div 2, (MinusH.Bottom-MinusH.Top - cv.TextHeight('-')) div 2, '-');

  MinusW.Left:=Rect.Right - 20;
  MinusW.Right:=Rect.Right - 2;
  MinusW.Top:=Rect.Top+2;
  MinusW.Bottom:=Rect.Bottom-2;

//  cv.Rectangle(MinusW);
  if MinusWSelect then cv.Brush.Color:=SmoothColor(Color, 32) else cv.Brush.Color:=Color;
  cv.TextRect(MinusW,MinusW.Left + (MinusW.Right-MinusW.Left - cv.TextWidth('-')) div 2,(MinusW.Bottom-MinusW.Top - cv.TextHeight('-')) div 2, '-');

  cv.Font.Size:=cv.Font.Size - 2;
  procent.Left:=MinusW.Left - cv.TextWidth('000%') - 8;
  procent.Right:=MinusW.Left - 4;
  procent.Top:=Rect.Top;
  procent.Bottom:=Rect.Bottom;
  if procentSelect then cv.Brush.Color:=SmoothColor(Color, 32) else cv.Brush.Color:=Color;
  cv.TextRect(procent,procent.Left + 4, (procent.Bottom-procent.Top - cv.TextHeight('0')) div 2, '100%');
  cv.Brush.Color:=Color;
  cv.TextOut(Rect.Left + 30, (procent.Bottom-procent.Top - cv.TextHeight('0')) div 2, Text);

  cv.Font.Size:=cv.Font.Size + 2;
  PlusW.Left:=procent.Left - 18;
  PlusW.Right:=procent.Left;
  PlusW.Top:=Rect.Top+2;
  PlusW.Bottom:=Rect.Bottom-2;

//  cv.Rectangle(PlusW);
  if PlusWSelect then cv.Brush.Color:=SmoothColor(Color, 32) else cv.Brush.Color:=Color;
  cv.TextRect(PLusW,PlusW.Left + (PlusW.Right-PlusW.Left - cv.TextWidth('+')) div 2,(PlusW.Bottom-PlusW.Top - cv.TextHeight('+')) div 2, '+');

end;

Procedure TZoneScaler.MoveMouse(cv : tcanvas; X, Y : integer);
begin
  plusHSelect :=false;
  minusHSelect := false;
  plusWSelect := false;
  minusWSelect := false;
  procentSelect := false;
  if (X > PlusH.Left) and (X < PlusH.Right) and (Y > PlusH.Top) and (Y < PlusH.Bottom) then plusHSelect := true
  else if (X > minusH.Left) and (X < minusH.Right) and (Y > minusH.Top) and (Y < minusH.Bottom) then minusHSelect := true
  else if (X > minusW.Left) and (X < minusW.Right) and (Y > minusW.Top) and (Y < minusW.Bottom) then minusWSelect := true
  else if (X > PlusW.Left) and (X < PlusW.Right) and (Y > PlusW.Top) and (Y < PlusW.Bottom) then PlusWSelect := true
  else if (X > procent.Left) and (X < procent.Right) and (Y > procent.Top) and (Y < procent.Bottom) then procentSelect := true;
  application.ProcessMessages;
  Draw(cv, Rect.Bottom-Rect.Top);
end;

function TZoneScaler.ClickScaler(cv : tcanvas; X, Y : integer) : TTLNResult;
begin
  plusHSelect :=false;
  minusHSelect := false;
  plusWSelect := false;
  minusWSelect := false;
  procentSelect := false;
  result.Zone := znScaler;
  result.ID:=-1;
  result.Position:=-1;
  result.Button:=btnone;
  if (X > PlusH.Left) and (X < PlusH.Right) and (Y > PlusH.Top) and (Y < PlusH.Bottom) then result.Button := btplusH
  else if (X > minusH.Left) and (X < minusH.Right) and (Y > minusH.Top) and (Y < minusH.Bottom) then result.Button := btminusH
  else if (X > minusW.Left) and (X < minusW.Right) and (Y > minusW.Top) and (Y < minusW.Bottom) then result.Button := btminusW
  else if (X > PlusW.Left) and (X < PlusW.Right) and (Y > PlusW.Top) and (Y < PlusW.Bottom) then result.Button := btplusW
  else if (X > procent.Left) and (X < procent.Right) and (Y > procent.Top) and (Y < procent.Bottom) then result.Button := btprocent;
end;

Procedure TZoneScaler.WriteToStream(F : tStream);
var fsbl : boolean;
begin
  F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
  F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
  F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));

  F.WriteBuffer(OffsetText, SizeOf(OffsetText));
  WriteBufferStr(F, Text);
  F.WriteBuffer(Color, SizeOf(Color));
  F.WriteBuffer(FontColor, SizeOf(FontColor));
  F.WriteBuffer(FontSize, SizeOf(FontSize));
  WriteBufferStr(F, FontName);

  //FontStyles : tfontstyles; //fsBold, fsItalic, fsUnderline, fsStrikeOut
  if fsBold in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsItalic in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsUnderline in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));
  if fsStrikeOut in FontStyles then fsbl := true else fsbl := false;
  F.WriteBuffer(fsbl, SizeOf(fsbl));

  F.WriteBuffer(plusH.Top, SizeOf(plusH.Top));
  F.WriteBuffer(plusH.Bottom, SizeOf(plusH.Bottom));
  F.WriteBuffer(plusH.Left, SizeOf(plusH.Left));
  F.WriteBuffer(plusH.Right, SizeOf(plusH.Right));

  F.WriteBuffer(plusHSelect, SizeOf(plusHSelect));
  F.WriteBuffer(plusHLock, SizeOf(plusHLock));

  F.WriteBuffer(minusH.Top, SizeOf(minusH.Top));
  F.WriteBuffer(minusH.Bottom, SizeOf(minusH.Bottom));
  F.WriteBuffer(minusH.Left, SizeOf(minusH.Left));
  F.WriteBuffer(minusH.Right, SizeOf(minusH.Right));

  F.WriteBuffer(minusHSelect, SizeOf(minusHSelect));
  F.WriteBuffer(minusHLock, SizeOf(minusHLock));

  F.WriteBuffer(plusW.Top, SizeOf(plusW.Top));
  F.WriteBuffer(plusW.Bottom, SizeOf(plusW.Bottom));
  F.WriteBuffer(plusW.Left, SizeOf(plusW.Left));
  F.WriteBuffer(plusW.Right, SizeOf(plusW.Right));

  F.WriteBuffer(plusWSelect, SizeOf(plusWSelect));
  F.WriteBuffer(plusWLock, SizeOf(plusWLock));

  F.WriteBuffer(minusW.Top, SizeOf(minusW.Top));
  F.WriteBuffer(minusW.Bottom, SizeOf(minusW.Bottom));
  F.WriteBuffer(minusW.Left, SizeOf(minusW.Left));
  F.WriteBuffer(minusW.Right, SizeOf(minusW.Right));

  F.WriteBuffer(minusWSelect, SizeOf(minusWSelect));
  F.WriteBuffer(minusWLock, SizeOf(minusWLock));

  F.WriteBuffer(procent.Top, SizeOf(procent.Top));
  F.WriteBuffer(procent.Bottom, SizeOf(procent.Bottom));
  F.WriteBuffer(procent.Left, SizeOf(procent.Left));
  F.WriteBuffer(procent.Right, SizeOf(procent.Right));

  F.WriteBuffer(procentSelect, SizeOf(procentSelect));
end;

Procedure TZoneScaler.ReadFromStream(F : tStream);
var fsbl : boolean;
begin
  F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
  F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
  F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
  F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));

  F.ReadBuffer(OffsetText, SizeOf(OffsetText));
  ReadBufferStr(F, Text);
  F.ReadBuffer(Color, SizeOf(Color));
  F.ReadBuffer(FontColor, SizeOf(FontColor));
  F.ReadBuffer(FontSize, SizeOf(FontSize));
  ReadBufferStr(F, FontName);

  //FontStyles : tfontstyles; //fsBold, fsItalic, fsUnderline, fsStrikeOut

  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsBold] else FontStyles := FontStyles - [fsBold];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsItalic] else FontStyles := FontStyles - [fsItalic];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsUnderline] else FontStyles := FontStyles - [fsUnderline];
  F.ReadBuffer(fsbl, SizeOf(fsbl));
  if fsbl then FontStyles := FontStyles + [fsStrikeOut] else FontStyles := FontStyles - [fsStrikeOut];

  F.ReadBuffer(plusH.Top, SizeOf(plusH.Top));
  F.ReadBuffer(plusH.Bottom, SizeOf(plusH.Bottom));
  F.ReadBuffer(plusH.Left, SizeOf(plusH.Left));
  F.ReadBuffer(plusH.Right, SizeOf(plusH.Right));

  F.ReadBuffer(plusHSelect, SizeOf(plusHSelect));
  F.ReadBuffer(plusHLock, SizeOf(plusHLock));

  F.ReadBuffer(minusH.Top, SizeOf(minusH.Top));
  F.ReadBuffer(minusH.Bottom, SizeOf(minusH.Bottom));
  F.ReadBuffer(minusH.Left, SizeOf(minusH.Left));
  F.ReadBuffer(minusH.Right, SizeOf(minusH.Right));

  F.ReadBuffer(minusHSelect, SizeOf(minusHSelect));
  F.ReadBuffer(minusHLock, SizeOf(minusHLock));

  F.ReadBuffer(plusW.Top, SizeOf(plusW.Top));
  F.ReadBuffer(plusW.Bottom, SizeOf(plusW.Bottom));
  F.ReadBuffer(plusW.Left, SizeOf(plusW.Left));
  F.ReadBuffer(plusW.Right, SizeOf(plusW.Right));

  F.ReadBuffer(plusWSelect, SizeOf(plusWSelect));
  F.ReadBuffer(plusWLock, SizeOf(plusWLock));

  F.ReadBuffer(minusW.Top, SizeOf(minusW.Top));
  F.ReadBuffer(minusW.Bottom, SizeOf(minusW.Bottom));
  F.ReadBuffer(minusW.Left, SizeOf(minusW.Left));
  F.ReadBuffer(minusW.Right, SizeOf(minusW.Right));

  F.ReadBuffer(minusWSelect, SizeOf(minusWSelect));
  F.ReadBuffer(minusWLock, SizeOf(minusWLock));

  F.ReadBuffer(procent.Top, SizeOf(procent.Top));
  F.ReadBuffer(procent.Bottom, SizeOf(procent.Bottom));
  F.ReadBuffer(procent.Left, SizeOf(procent.Left));
  F.ReadBuffer(procent.Right, SizeOf(procent.Right));

  F.ReadBuffer(procentSelect, SizeOf(procentSelect));
end;

Initialization

ZoneNames := TTLNames.Create;
TLHeights := TTLHeights.Create;

end.
