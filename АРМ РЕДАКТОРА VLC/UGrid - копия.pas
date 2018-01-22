unit UGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, JPEG;

Type
  TTypeGrid = (projects,playlists,clips,actplaylist, grtemplate, txttemplate, empty);

  TPhrasePosition = (ppleft,ppcenter,ppright,ppafter,pptab);

  TTypeGraphics = (picture, ellipse, rectangle, roundrect, none);

  TTypeCell = (tsText,tsState,tsImage);


  TCellPhrase = Class(TObject)
    public
    Left  : integer;
    Right : integer;
    Top : integer;
    Bottom : integer;
    Height : integer;
    Width : integer;
    Alignment : TPhrasePosition;
    Layout : TPhrasePosition;
    Text : string;
    Name : string;
    FontColor : TColor;
    FontSize : Integer;
    FontName : tfontname;
    Bold : boolean;
    Italic : boolean;
    Underline : boolean;
    Visible : boolean;
    leftprocent : integer;
    constructor Create;
    destructor  Destroy; override;
  end;

  TPhrasesRow = Class(TObject)
    public
    Count : integer;
    Height : integer;
    Top : integer;
    Phrases : array of TCellPhrase;
    function Add(Name, Text : string) : integer;
    Procedure Clear;
    procedure Recount(Wdth : integer);
    procedure Assign(Phr : TPhrasesRow);
    constructor Create;
    destructor  Destroy; override;
  End;

  TMyCell = Class(TObject)
    public
    CellType : TTypeCell;
    Width : Integer;
    Procents : integer;
    Title : string;
    TitlePosition : TPhrasePosition;
    TitleColorFont : TColor;
    TitleFontSize : integer;
    TitleFontName : tfontname;
    TitleBold : boolean;
    TitleItalic : boolean;
    TitleUnderline : boolean;
    Used : boolean;
    Mark : boolean;
    Select : boolean;
    Background : tcolor;
    Name : string;
    TypeImage : TTypeGraphics;
    ImageWidth: integer;
    ImageHeight : integer;
    ImageRect : Trect;
    ImagePosition : TPhrasePosition;
    ImageLayout : TTextLayout;
    ImageTrue : string;
    ImageFalse : string;
    Stretch : boolean;
    Transperent : boolean;
    ColorTrue : TColor;
    ColorFalse : TColor;
    ColorPen : TColor;
    WidthPen : integer;
    Count : integer;
    TopPhrase : integer;
    Bitmap : tbitmap;
    Interval : integer;
    Rows : array of TPhrasesRow;
    procedure LoadJpeg(Filename : string; wdt, hgh : integer);
    procedure Clear;
    function PositionName(name : string) : tpoint;
    function AddRow : integer;
    function AddPhrase(ARow : integer; Name, Text : String) : integer;
    function UpdatePhrase(Name, Text : string) : boolean;
    function ReadPhrase(Name : string) : string;
    constructor Create;
    destructor  Destroy; override;
  end;

  TGridRows = Class(TObject)
    public
    ID : Longint;
    HeightRow : integer;
    HeightTitle : integer;
    Count : integer;
    MyCells : array of TMyCell;
    function AddCells : integer;
    procedure Clear;
    procedure Assign(GR : TGridRows);
    constructor Create;//(Hght : integer);
    destructor  Destroy; override;
  end;


Var
  ProjCellClick, PlLsCellClick, GrTmCellClick, TxTmCellClick, AcPLCellClick, ClipCellClick : TPoint;
  RowGridClips, RowGridProject, RowGridListPL, RowGridListTxt, RowGridListGR: TGridRows;
  ACell, ARow, APhr : integer;

procedure initgrid(grid : tstringgrid; obj : tgridrows; Width : integer);
procedure GridDrawMyCell(Grid : tstringgrid; ACol, ARow: Integer; Rect: TRect);
function GridAddRow(Grid : tstringgrid; obj : TGridRows) : integer;
procedure MyGridDeleteRow(Grid : tstringgrid; ARow : integer; obj : TGridRows);
function GridColX(Grid : tstringgrid; X : integer) : integer;
function findgridselection(grid : tstringgrid; cell : integer) : integer;
procedure GridClear(Grid : tstringgrid; obj : tgridrows);
procedure GridImageReload(Grid : tstringgrid);

implementation
uses umain, ucommon, uproject;

constructor TGridRows.Create;//(Hght : integer);
begin

  inherited;
  //IDCLIPS:=IDCLIPS+1;
  ID := IDCLIPS;
  HeightRow := 30;
  HeightRow := 30;
  Count := 0;
end;

destructor TGridRows.Destroy;
begin
  FreeMem(@ID);
  FreeMem(@HeightRow);
  FreeMem(@HeightTitle);
  FreeMem(@Count);
  FreeMem(@MyCells);
  inherited;
end;

procedure TGridRows.Clear;
var i : integer;
begin
  ID:=-1;
  HeightRow:=30;
  HeightTitle:=30;
  For i:=Count-1 downto 0 do MyCells[i].Clear;
  Setlength(MyCells,0);
  Count:=0;
end;

Procedure TGridRows.Assign(GR : TGridRows);
var i, j : integer;
begin
  Clear;
  ID:=GR.ID;
  HeightRow:=GR.HeightRow;
  HeightTitle:=GR.HeightTitle;
  Count:=0;
  For i:=0 to Gr.Count-1 do begin
    Count:=Count+1;
    SetLength(Mycells,Count);
    MyCells[Count-1]:=TMyCell.Create;
    MyCells[Count-1].CellType:=Gr.MyCells[Count-1].CellType;
    MyCells[Count-1].Width:=Gr.MyCells[Count-1].Width;
    MyCells[Count-1].Procents:=Gr.MyCells[Count-1].Procents;
    MyCells[Count-1].Title:=Gr.MyCells[Count-1].Title;
    MyCells[Count-1].TitlePosition:=Gr.MyCells[Count-1].TitlePosition;
    MyCells[Count-1].TitleFontName:=Gr.MyCells[Count-1].TitleFontName;
    MyCells[Count-1].TitleColorFont:=Gr.MyCells[Count-1].TitleColorFont;
    MyCells[Count-1].TitleFontSize:=Gr.MyCells[Count-1].TitleFontSize;
    MyCells[Count-1].TitleBold:=Gr.MyCells[Count-1].TitleBold;
    MyCells[Count-1].TitleItalic:=Gr.MyCells[Count-1].TitleItalic;
    MyCells[Count-1].TitleUnderline:=Gr.MyCells[Count-1].TitleUnderline;
    MyCells[Count-1].Used:=Gr.MyCells[Count-1].Used;
    MyCells[Count-1].Mark:=Gr.MyCells[Count-1].Mark;
    MyCells[Count-1].Select:=Gr.MyCells[Count-1].Select;
    MyCells[Count-1].Background:=Gr.MyCells[Count-1].Background;
    MyCells[Count-1].Name:=Gr.MyCells[Count-1].Name;
    MyCells[Count-1].TypeImage:=Gr.MyCells[Count-1].TypeImage;
    MyCells[Count-1].ImageWidth:=Gr.MyCells[Count-1].ImageWidth;
    MyCells[Count-1].ImageHeight:=Gr.MyCells[Count-1].ImageHeight;
    MyCells[Count-1].ImageRect.Left:=Gr.MyCells[Count-1].ImageRect.Left;
    MyCells[Count-1].ImageRect.Right:=Gr.MyCells[Count-1].ImageRect.Right;
    MyCells[Count-1].ImageRect.Top:=Gr.MyCells[Count-1].ImageRect.Top;
    MyCells[Count-1].ImageRect.Bottom:=Gr.MyCells[Count-1].ImageRect.Bottom;
    MyCells[Count-1].ImagePosition:=Gr.MyCells[Count-1].ImagePosition;
    MyCells[Count-1].ImageLayout:=Gr.MyCells[Count-1].ImageLayout;
    MyCells[Count-1].ImageTrue:=Gr.MyCells[Count-1].ImageTrue;
    MyCells[Count-1].ImageFalse:=Gr.MyCells[Count-1].ImageFalse;
    MyCells[Count-1].Stretch:=Gr.MyCells[Count-1].Stretch;
    MyCells[Count-1].Transperent:=Gr.MyCells[Count-1].Transperent;
    MyCells[Count-1].ColorTrue:=Gr.MyCells[Count-1].ColorTrue;
    MyCells[Count-1].ColorFalse:=Gr.MyCells[Count-1].ColorFalse;
    MyCells[Count-1].ColorPen:=Gr.MyCells[Count-1].ColorPen;
    MyCells[Count-1].WidthPen:=Gr.MyCells[Count-1].WidthPen;
    MyCells[Count-1].TopPhrase:=Gr.MyCells[Count-1].TopPhrase;
    MyCells[Count-1].Interval:=Gr.MyCells[Count-1].Interval;
    MyCells[Count-1].Bitmap.Width:=Gr.MyCells[Count-1].Bitmap.Width;
    MyCells[Count-1].Bitmap.Height:=Gr.MyCells[Count-1].Bitmap.Height;
    MyCells[Count-1].Bitmap.Canvas.CopyRect(MyCells[Count-1].Bitmap.Canvas.ClipRect
                                            ,Gr.MyCells[Count-1].Bitmap.Canvas
                                            ,Gr.MyCells[Count-1].Bitmap.Canvas.ClipRect);
    MyCells[Count-1].Count:=0;
    For j:=0 to Gr.MyCells[Count-1].Count - 1 do begin
      MyCells[Count-1].AddRow;
      MyCells[Count-1].Rows[MyCells[Count-1].Count-1].Assign(GR.MyCells[i].Rows[j]);
      //MyCells[Count-1].Count:=MyCells[Count-1].Count+1;
      //Setlength(MyCells[Count-1].Rows,MyCells[Count-1].Count;
      //MyCells[Count-1].Rows[j] :=
      //MyCells[Count-1].Rows:=Gr.MyCells[Count-1];
    end;

  end;
end;

function TGridRows.AddCells : integer;
begin
  Count:=Count + 1;
  Setlength(MyCells,Count);
  MyCells[Count-1]:=TMyCell.Create;
  Result:=Count-1;
end;

Constructor TCellPhrase.Create;
begin
  inherited;
  Left  := 0;
  Right := 0;
  Top := 0;
  Bottom := 0;
  Height := 0;
  Width :=0;
  Alignment := ppLeft;
  Layout := ppCenter;
  Text := '';
  Name := '';
  FontColor := ProgrammFontColor;
  FontSize :=ProgrammFontSize;
  FontName := ProgrammFontName;
  Bold := false;
  Italic := false;
  Underline := false;
  Visible:=true;
  leftprocent:=0;
end;

Destructor TCellPhrase.Destroy;
begin
  FreeMem(@Left);
  FreeMem(@Right);
  FreeMem(@Top);
  FreeMem(@Bottom);
  FreeMem(@Height);
  FreeMem(@Width);
  FreeMem(@Alignment);
  FreeMem(@Layout);
  FreeMem(@Text);
  FreeMem(@Name);
  FreeMem(@FontColor);
  FreeMem(@FontSize);
  FreeMem(@FontName);
  FreeMem(@Bold);
  FreeMem(@Italic);
  FreeMem(@Underline);
  FreeMem(@Visible);
  FreeMem(@leftprocent);
  inherited;
end;

constructor TPhrasesRow.Create;
begin
  inherited;
  Count := 0;
  Height := 0;
  Top := 0;
end;

destructor TPhrasesRow.Destroy;
begin
  FreeMem(@Height);
  FreeMem(@Top);
  FreeMem(@Count);
  FreeMem(Phrases);
  inherited;
end;

function TPhrasesRow.Add(Name,Text : string) : integer;
begin
  count:=count+1;
  setlength(Phrases,count);
  Phrases[Count-1]:=TCellPhrase.Create;
  Phrases[Count-1].Name:=Name;
  Phrases[Count-1].Text:=Text;
  Phrases[Count-1].Top:=Top;
  //Phrases[Count-1].Left:=Left;
  //Phrases[Count-1].Right:=Right;
  result := Count-1;
end;

procedure TPhrasesRow.Recount(Wdth : integer);
var i, wdt : integer;
    prc : real;
begin
  if Count <= 0 then exit;
  prc := Wdth / 100;
  for i:=0 to Count-1 do begin
     Phrases[i].Left:=Round(Phrases[i].leftprocent * prc);
  end;
  wdt := 0;
  if Count > 1 then begin
    for i:=0 to Count-2 do begin
      Phrases[i].Right:=Phrases[i].Left;
      Phrases[i].Width:=Phrases[i+1].Left - Phrases[i].Left;
      wdt:=wdt+Phrases[i].Width;
    end;
    Phrases[Count-1].Width:=Wdth-wdt;
  end else begin
    Phrases[0].Width:=Wdth;
  end;
end;

procedure TPhrasesRow.Clear;
var i : integer;
begin
  Height := 0;
  Top :=0 ;
  for i:=Count-1 downto 0 do Phrases[i].FreeInstance;
  Setlength(Phrases,0);
  Count := 0;
end;

procedure TPhrasesRow.Assign(Phr : TPhrasesRow);
var i : integer;
begin
  Clear;
  Height:=Phr.Height;
  Top:=Phr.Top;
  For i:=0 to Phr.Count-1 do begin
    Count:=Count+1;
    Setlength(Phrases,Count);
    Phrases[Count-1]:=TCellPhrase.Create;
    Phrases[Count-1].Left:=Phr.Phrases[i].Left;
    Phrases[Count-1].Right:=Phr.Phrases[i].Right;
    Phrases[Count-1].Top:=Phr.Phrases[i].Top;
    Phrases[Count-1].Bottom:=Phr.Phrases[i].Bottom;
    Phrases[Count-1].Height:=Phr.Phrases[i].Height;
    Phrases[Count-1].Width:=Phr.Phrases[i].Width;
    Phrases[Count-1].Alignment:=Phr.Phrases[i].Alignment;
    Phrases[Count-1].Layout:=Phr.Phrases[i].Layout;
    Phrases[Count-1].Text:=Phr.Phrases[i].Text;
    Phrases[Count-1].Name:=Phr.Phrases[i].Name;
    Phrases[Count-1].FontColor:=Phr.Phrases[i].FontColor;
    Phrases[Count-1].FontSize:=Phr.Phrases[i].FontSize;
    Phrases[Count-1].FontName:=Phr.Phrases[i].FontName;
    Phrases[Count-1].Bold:=Phr.Phrases[i].Bold;
    Phrases[Count-1].Italic:=Phr.Phrases[i].Italic;
    Phrases[Count-1].Underline:=Phr.Phrases[i].Underline;
    Phrases[Count-1].Visible:=Phr.Phrases[i].Visible;
    Phrases[Count-1].leftprocent:=Phr.Phrases[i].leftprocent;
  end;
end;

constructor TMyCell.Create;
begin
  inherited;
  CellType := tsState;
  Width := -1;
  Procents := 100;
  Used := false;
  Mark := false;
  Title := '';
  TitlePosition:=ppCenter;
  TitleColorFont := ProgrammFontColor;
  TitleFontSize := ProgrammFontSize + 2;
  TitleFontName := ProgrammFontName;
  TitleBold := true;
  TitleItalic := false;
  TitleUnderline := false;
  Select := false;
  BackGround := GridBackGround;
  Name := '';
  TypeImage := none;
  ImageWidth:= 0;
  ImageHeight := 0;
  ImageRect.Left := 0;
  ImageRect.Right := 0;
  ImageRect.Top := 0;
  ImageRect.Bottom := 0;
  ImagePosition := ppCenter;
  ImageLayout := tlCenter;
  ImageTrue := '';
  ImageFalse := '';
  Stretch := true;
  Transperent := true;
  ColorTrue := clGreen;
  ColorFalse := SmoothColor(BackGround, 32);
  ColorPen := GridColorPen;
  WidthPen := 1;
  Count := 0;
  TopPhrase := 0;
  Interval := 4;
  Bitmap := TBitmap.Create;
end;

Destructor TMyCell.Destroy;
begin
  FreeMem(@CellType);
  FreeMem(@Width);
  FreeMem(@Procents);
  FreeMem(@Title);
  FreeMem(@TitlePosition);
  FreeMem(@TitleColorFont);
  FreeMem(@TitleFontSize);
  FreeMem(@TitleFontName);
  FreeMem(@TitleBold);
  FreeMem(@TitleItalic);
  FreeMem(@TitleUnderline);
  FreeMem(@Used);
  FreeMem(@Mark);
  FreeMem(@Select);
  FreeMem(@BackGround);
  FreeMem(@Name);
  FreeMem(@TypeImage);
  FreeMem(@ImageWidth);
  FreeMem(@ImageHeight);
  FreeMem(@ImageRect.Left);
  FreeMem(@ImageRect.Right);
  FreeMem(@ImageRect.Top);
  FreeMem(@ImageRect.Bottom);
  FreeMem(@ImagePosition);
  FreeMem(@ImageTrue);
  FreeMem(@ImageFalse);
  FreeMem(@Stretch);
  FreeMem(@Transperent);
  FreeMem(@ColorTrue);
  FreeMem(@ColorFalse);
  FreeMem(@ColorPen);
  FreeMem(@WidthPen);
  FreeMem(@Count);
  FreeMem(@TopPhrase);
  FreeMem(@Interval);
  FreeMem(@Rows);
  Bitmap.Destroy;
  inherited;
end;

procedure TMyCell.LoadJpeg(Filename : string; wdt, hgh : integer);
var
  JpegIm: TJpegImage;
  wdth,hght,bwdth,bhght : integer;
  dlt : real;
  bmp : tbitmap;
begin
  Bitmap.Width:=wdt;
  Bitmap.Height:=hgh;
  bmp := tbitmap.Create;
  try
    JpegIm := TJpegImage.Create;
    try
      JpegIm.LoadFromFile(FileName);
      bmp.Assign(JpegIm);
      Bitmap.Canvas.StretchDraw(Bitmap.Canvas.ClipRect,bmp);
    finally
      JpegIm.Free;
    end;
  finally
    bmp.Free;
  end;
end;

procedure TMyCell.Clear;
var i,j : integer;
begin
  inherited;
  CellType := tsState;
  Width := 0;
  Procents := 100;
  Title:='';
  TitlePosition := ppCenter;
  TitleColorFont := ProgrammFontColor;
  TitleFontSize := ProgrammFontSize + 2;
  TitleFontName := ProgrammFontName;
  TitleBold := true;
  TitleItalic := false;
  TitleUnderline := false;
  Used := false;
  Mark := false;
  Select := false;
  BackGround := GridBackGround;
  Name := '';
  TypeImage := none;
  ImageWidth:= 0;
  ImageHeight := 0;
  ImageRect.Left := 0;
  ImageRect.Right := 0;
  ImageRect.Top := 0;
  ImageRect.Bottom := 0;
  ImagePosition := ppCenter;
  ImageTrue := '';
  ImageFalse := '';
  Stretch := true;
  Transperent := true;
  ColorTrue := clGreen;
  ColorFalse := SmoothColor(BackGround, 32);
  ColorPen := GridColorPen;
  WidthPen := 1;
  TopPhrase := 0;
  Interval := 4;
  Bitmap.Canvas.Brush.Color:=GridBackGround;
  Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);
  if count < 0 then exit;
  for i:=Count-1 downto 0 do begin
    for j:=Rows[i].Count-1 downto 0 do Rows[i].Phrases[j].FreeInstance;
    Rows[i].Count:=0;
    setlength( Rows[i].Phrases,0);
  end;
  Count:=0;
  setlength(Rows,0);
end;

function TMyCell.PositionName(Name : string) : TPoint;
var i,j : integer;
begin
  result.X:=-1;
  result.Y:=-1;
  if Count<=0 then exit;
  For i:=0 to Count -1 do begin
    For j:=0 to Rows[i].Count - 1 do begin
      if LowerCase(Rows[i].Phrases[j].Name)=LowerCase(name) then begin
        result.X:=i;
        result.Y:=j;
        exit;
      end;
    End;
  End;
end;

function TMyCell.AddRow : integer;
var i, tp : integer;
begin
  tp:=TopPhrase;
  if count > 0 then begin
    for i:=0 to count-1 do tp:=tp + Rows[i].height + Interval;
  end;
  count:=count+1;
  setlength(Rows,count);
  Rows[Count-1]:=TPhrasesRow.Create;
  Rows[Count-1].Top:=Count-1;
  result := Count-1;
end;

function TMyCell.UpdatePhrase(Name, Text : String) : boolean;
var CPos : TPoint;
begin
  CPos := PositionName(Name);
  result := true;
  if (CPos.X<>-1) and (CPos.Y<>-1)
    then Rows[Cpos.X].Phrases[Cpos.Y].Text:=Text
    else result:=false;
end;

function TMyCell.ReadPhrase(Name : string) : string;
  var CPos : TPoint;
begin
  result:='';
  CPos := PositionName(Name);
  if (CPos.X<>-1) and (CPos.Y<>-1) then result:=Rows[Cpos.X].Phrases[Cpos.Y].Text;
end;

function TMyCell.AddPhrase(ARow : integer; Name, Text : String) : integer;
begin
  Result:=Rows[ARow].Add(Name, Text);
end;

procedure initgrid(grid : tstringgrid; obj : tgridrows; Width : integer);
var i, j, wdt : integer;
begin
  For i:=0 to grid.RowCount-1
    do for j:=0 to grid.ColCount
      do begin
        grid.Objects[j,i]:=nil;
        grid.Cells[j,i]:='';
      end;
  If obj.HeightTitle<>-1 then grid.RowCount:=2 else grid.RowCount:=1;
  grid.ColCount:=obj.Count;
  for i:=0 to grid.RowCount-1 do begin
    if (obj.HeightTitle<>-1) and (i=0)
     then grid.RowHeights[0]:=obj.HeightTitle
     else grid.RowHeights[i]:=obj.HeightRow;
    grid.Objects[0,i] := TGridRows.Create;
    (grid.Objects[0,i] as TGridRows).Assign(obj);
  end;
  wdt:=0;
  grid.ColCount:=obj.Count;
  For i:=0 to obj.Count-1 do begin
    if obj.MyCells[i].Width<>-1 then begin
      wdt:=wdt+obj.MyCells[i].Width;
      grid.ColWidths[i]:=obj.MyCells[i].Width;
    end;
  end;
  wdt:=Width - wdt;
  For i:=0 to obj.Count-1 do begin
    if obj.MyCells[i].Width=-1 then begin
      grid.ColWidths[i]:=Round(wdt / 100 * obj.MyCells[i].Procents);
    end;
  end;
  grid.Repaint;
end;

Procedure DrawMyTextCell(Grid : tstringgrid; ACol, ARow: Integer; Rect: TRect; obj : TMyCell);
var i, j, posx, posy : integer;
    cvc, pnc, fncl : tcolor;
    cvs : tbrushstyle;
    pns : tpenstyle;
    fnsz, pnw : integer;
    fnnm : tfontname;
    fnst : tfontstyles;
begin
  cvc := Grid.Canvas.Brush.Color;
  cvs := Grid.Canvas.Brush.Style;
  pnc := Grid.Canvas.Pen.Color;
  pns := Grid.Canvas.Pen.Style;
  pnw := Grid.Canvas.Pen.Width;
  fncl := Grid.Canvas.Font.Color;
  fnsz := Grid.Canvas.Font.Size;
  fnnm := Grid.Canvas.Font.Name;
  fnst := Grid.Canvas.Font.Style;

  if (ARow=0) and ((Grid.Objects[0,0] as TGridRows).HeightTitle > -1)  then begin
    Grid.Canvas.Font.Color:=obj.TitleColorFont;
    Grid.Canvas.Font.Size:=obj.TitleFontSize;
    Grid.Canvas.Font.Name:=obj.TitleFontName;
    if obj.TitleBold
      then Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style + [fsBold]
      else Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style - [fsBold];
    if obj.TitleItalic
      then Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style + [fsItalic]
      else Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style - [fsItalic];
    if obj.TitleUnderline
      then Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style + [fsUnderline]
      else Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style - [fsUnderline];
             case obj.TitlePosition of
      ppLeft  : posx := Rect.Left+5;
      ppRight : posx := Rect.Right - 5 - Grid.Canvas.TextWidth(obj.Title);
      else posx := Rect.Left + ((Rect.Right-Rect.Left-Grid.Canvas.TextWidth(obj.Title)) div 2);
             end; //case
      posy:=Rect.Top + ((Rect.Bottom-Rect.Top-Grid.Canvas.TextHeight(obj.Title)) div 2);
      Grid.Canvas.TextOut(posx,posy,obj.Title);
  end else begin
    if Grid.Objects[0,ARow] is TGridRows then
       if (Grid.Objects[0,ARow] as TGridRows).ID <=0 then exit;
    For i:=0 to obj.Count-1 do begin
      obj.Rows[i].Recount(grid.Width);
      For j:=0 to obj.Rows[i].Count-1 do begin
        Grid.Canvas.Font.Color:=obj.Rows[i].Phrases[j].FontColor;
        Grid.Canvas.Font.Size:=obj.Rows[i].Phrases[j].FontSize;
        Grid.Canvas.Font.Name:=obj.Rows[i].Phrases[j].FontName;
        if obj.Rows[i].Phrases[j].Bold
          then Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style + [fsBold]
          else Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style - [fsBold];
        if obj.Rows[i].Phrases[j].Italic
          then Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style + [fsItalic]
          else Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style - [fsItalic];
        if obj.Rows[i].Phrases[j].Underline
          then Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style + [fsUnderline]
          else Grid.Canvas.Font.Style:=Grid.Canvas.Font.Style - [fsUnderline];
        posx:=Rect.Left + obj.Rows[i].Phrases[j].Left;
        posy:=Rect.Top + obj.Rows[i].Phrases[j].Top;
        if obj.Rows[i].Phrases[j].Visible then Grid.Canvas.TextOut(posx,posy,obj.Rows[i].Phrases[j].Text);
      End;
    End
  end;;

  Grid.Canvas.Brush.Color := cvc;
  Grid.Canvas.Brush.Style := cvs;
  Grid.Canvas.Pen.Color   := pnc;
  Grid.Canvas.Pen.Style   := pns;
  Grid.Canvas.Pen.Width   := pnw;
  Grid.Canvas.Font.Color  := fncl;
  Grid.Canvas.Font.Size   := fnsz;
  Grid.Canvas.Font.Name   := fnnm;
  Grid.Canvas.Font.Style  := fnst;
end;

//+++++++++++++++++++++++++++++++++++++

Procedure DrawMyImageCell(Grid : tstringgrid; ACol, ARow: Integer; Rect: TRect; obj : TMyCell);
var i, j, posx, posy : integer;
    cvc, pnc, fncl : tcolor;
    cvs : tbrushstyle;
    pns : tpenstyle;
    fnsz, pnw : integer;
    fnnm : tfontname;
    fnst : tfontstyles;
    bmp : tbitmap;
    nm, nt, ny : string;
    pict : tbitmap;
begin
  cvc := Grid.Canvas.Brush.Color;
  cvs := Grid.Canvas.Brush.Style;
  pnc := Grid.Canvas.Pen.Color;
  pns := Grid.Canvas.Pen.Style;
  pnw := Grid.Canvas.Pen.Width;
  fncl := Grid.Canvas.Font.Color;
  fnsz := Grid.Canvas.Font.Size;
  fnnm := Grid.Canvas.Font.Name;
  fnst := Grid.Canvas.Font.Style;
  if Grid.Objects[0,ARow] is TGridRows then
    if (Grid.Objects[0,ARow] as TGridRows).ID <=0 then exit;
  if obj.Count = 0 then exit;
  nm := obj.ReadPhrase('File');
  nt := obj.ReadPhrase('Note');
  ny := obj.ReadPhrase('Import');

  if FileExists(AppPath + DirImages + '\' + nm) then begin
    Grid.Canvas.CopyRect(Rect,obj.Bitmap.Canvas,obj.Bitmap.Canvas.ClipRect);
//      pict := tbitmap.Create;
//      try
//        LoadJpegFile(pict, AppPath + DirImages + '\' + nm);
//        Grid.Canvas.CopyRect(Rect,pict.Canvas,pict.Canvas.ClipRect);
//      finally
//        pict.Free;
//      end;
//      obj.UpdatePhrase('Import','Да');
  end else begin
    Grid.Canvas.Font.Size   := DefineFontSizeW(Grid.Canvas, Rect.Right - Rect.Left, nt);
    posx := Rect.Left + ((Rect.Right-Rect.Left-Grid.Canvas.TextWidth(nt)) div 2);
    posy:=Rect.Top + ((Rect.Bottom-Rect.Top-Grid.Canvas.TextHeight(nt)) div 2);
    Grid.Canvas.TextOut(posx,posy,nt);
  end ;

  Grid.Canvas.Brush.Color := cvc;
  Grid.Canvas.Brush.Style := cvs;
  Grid.Canvas.Pen.Color   := pnc;
  Grid.Canvas.Pen.Style   := pns;
  Grid.Canvas.Pen.Width   := pnw;
  Grid.Canvas.Font.Color  := fncl;
  Grid.Canvas.Font.Size   := fnsz;
  Grid.Canvas.Font.Name   := fnnm;
  Grid.Canvas.Font.Style  := fnst;
end;

//+++++++++++++++++++++++++++++++++++++

Procedure DrawMyStateCell(Grid : tstringgrid; ACol, ARow: Integer; Rect: TRect; var obj : TMyCell);
var img : string;
    cvc, pnc, fncl : tcolor;
    cvs : tbrushstyle;
    pns : tpenstyle;
    fnsz, pnw : integer;
    fnnm : tfontname;
    fnst : tfontstyles;
begin
  cvc := Grid.Canvas.Brush.Color;
  cvs := Grid.Canvas.Brush.Style;
  pnc := Grid.Canvas.Pen.Color;
  pns := Grid.Canvas.Pen.Style;
  pnw := Grid.Canvas.Pen.Width;
  fncl := Grid.Canvas.Font.Color;
  fnsz := Grid.Canvas.Font.Size;
  fnnm := Grid.Canvas.Font.Name;
  fnst := Grid.Canvas.Font.Style;

      if not obj.Used then begin
        grid.Canvas.FillRect(Rect);
        exit;
      end;

      case obj.ImagePosition of
  ppLeft   : begin
               obj.ImageRect.Left:=Rect.Left;
               obj.ImageRect.Right:=obj.ImageRect.Left + obj.ImageWidth;
             end;
  ppRight  : begin
               obj.ImageRect.Left:=Rect.Right - obj.ImageWidth;
               obj.ImageRect.Right:=Rect.Right;
             end;
  ppCenter : begin
               obj.ImageRect.Left:=Rect.Left + ((Rect.Right-Rect.Left - obj.ImageWidth) div 2);
               obj.ImageRect.Right:=obj.ImageRect.Left + obj.ImageWidth;
             end;
  else begin
         obj.ImageRect.Left:=Rect.Left;
         obj.ImageRect.Right:=Rect.Right;
       end;
      end; //case

      case obj.ImageLayout of
  tlTop    : begin
               obj.ImageRect.Top:=Rect.Top;
               obj.ImageRect.Bottom:=obj.ImageRect.Top + obj.ImageHeight;
             end;
  tlCenter : begin
               obj.ImageRect.Top:=Rect.Top + ((Rect.Bottom - Rect.Top - obj.ImageHeight) div 2);
               obj.ImageRect.Bottom:=obj.ImageRect.Top + obj.ImageHeight;
             end;
  tlBottom : begin
               obj.ImageRect.Top:=Rect.Bottom - obj.ImageHeight ;
               obj.ImageRect.Bottom:=Rect.Bottom;
             end;
      end; //case

  if obj.Mark then begin
    Grid.Canvas.Brush.Color:=obj.ColorTrue;
    img := obj.ImageTrue;
  end else begin
    Grid.Canvas.Brush.Color:=obj.ColorFalse;
    img := obj.ImageFalse;
  end;;

       case obj.TypeImage of
  picture   : begin

                LoadBMPFromRes(grid.Canvas, obj.ImageRect,obj.ImageWidth,obj.ImageHeight, img)
              end;
  ellipse   : begin

                Grid.Canvas.Ellipse(obj.ImageRect);
              end;
  rectangle : begin
                Grid.Canvas.Rectangle(obj.ImageRect);
              end;
  roundrect : begin
                Grid.Canvas.RoundRect(obj.ImageRect.Left,obj.ImageRect.Top,obj.ImageRect.Right,obj.ImageRect.Bottom
                     , (obj.ImageRect.Right-obj.ImageRect.Left) div 2, (obj.ImageRect.Bottom-obj.ImageRect.Top) div 2);
              end;
  none      : begin
                Grid.Canvas.FillRect(Rect);
              end;
       end; //case

  Grid.Canvas.Brush.Color := cvc;
  Grid.Canvas.Brush.Style := cvs;
  Grid.Canvas.Pen.Color   := pnc;
  Grid.Canvas.Pen.Style   := pns;
  Grid.Canvas.Pen.Width   := pnw;
  Grid.Canvas.Font.Color  := fncl;
  Grid.Canvas.Font.Size   := fnsz;
  Grid.Canvas.Font.Name   := fnnm;
  Grid.Canvas.Font.Style  := fnst;
end;

procedure GridDrawMyCell(Grid : tstringgrid; ACol, ARow: Integer; Rect: TRect);
Var RT : TRect;
    strs : string;
    deltx, delty : integer;
    oldfontsize : integer;
    oldfontcolor : tcolor;
    cvc, pnc, fncl : tcolor;
    cvs : tbrushstyle;
    pns : tpenstyle;
    fnsz, pnw : integer;
    fnnm : tfontname;
    fnst : tfontstyles;
begin
  //if Grid.Objects[0,] Grid.RowHeights[ARow]:=
  cvc := Grid.Canvas.Brush.Color;
  cvs := Grid.Canvas.Brush.Style;
  pnc := Grid.Canvas.Pen.Color;
  pns := Grid.Canvas.Pen.Style;
  pnw := Grid.Canvas.Pen.Width;
  fncl := Grid.Canvas.Font.Color;
  fnsz := Grid.Canvas.Font.Size;
  fnnm := Grid.Canvas.Font.Name;
  fnst := Grid.Canvas.Font.Style;

  strs:='';

  If ARow = 0 then begin
    grid.Canvas.Brush.Color:=ProgrammColor;
    grid.Canvas.Font.Color:=ProgrammFontColor;
    grid.Canvas.Font.Size:=ProgrammFontSize;
    grid.Canvas.Font.Name:=ProgrammFontName;
    grid.Canvas.Pen.Color:=SmoothColor(GridBackGround,64);
    //grid.Canvas.Pen.Width:=1;
    //grid.Canvas.MoveTo(Rect.Left,Rect.Bottom);
    //grid.Canvas.LineTo(Rect.Right,Rect.Bottom);
    //if ACol in [2,3,4] then begin
    //  grid.Canvas.MoveTo(Rect.Right-1,Rect.Top);
    //  grid.Canvas.LineTo(Rect.Right-1,Rect.Bottom);
    //end;
  end else begin
    if (ARow mod 2)=0
      then grid.Canvas.Brush.Color:=GridColorRow1
      else grid.Canvas.Brush.Color:=GridColorRow2;
    if ARow=grid.Selection.Top then grid.Canvas.Brush.Color:=GridColorSelection;
    grid.Canvas.FillRect(Rect);
    grid.Canvas.Pen.Color:=SmoothColor(GridBackGround,64);//GridColorPen;
    grid.Canvas.Pen.Width:=1;
  end;

  if grid.Objects[0,ARow] is TGridRows then begin
     if ARow=0 then begin
       if (grid.Objects[0,ARow] as TGridRows).HeightTitle<>-1
         then grid.RowHeights[ARow]:=(grid.Objects[0,ARow] as TGridRows).HeightTitle
         else grid.RowHeights[ARow]:=(grid.Objects[0,ARow] as TGridRows).HeightRow
     end else grid.RowHeights[ARow]:=(grid.Objects[0,ARow] as TGridRows).HeightRow;
       case (grid.Objects[0,ARow] as TGridRows).MyCells[ACol].CellType of
    tsText  : DrawMyTextCell(Grid, ACol, ARow, Rect, (grid.Objects[0,ARow] as TGridRows).MyCells[ACol]);
    tsState : DrawMyStateCell(Grid, ACol, ARow, Rect, (grid.Objects[0,ARow] as TGridRows).MyCells[ACol]);
    tsImage : DrawMyImageCell(Grid, ACol, ARow, Rect, (grid.Objects[0,ARow] as TGridRows).MyCells[ACol]);
       end; //case
  end;

  Grid.Canvas.Brush.Color := cvc;
  Grid.Canvas.Brush.Style := cvs;
  Grid.Canvas.Pen.Color   := pnc;
  Grid.Canvas.Pen.Style   := pns;
  Grid.Canvas.Pen.Width   := pnw;
  Grid.Canvas.Font.Color  := fncl;
  Grid.Canvas.Font.Size   := fnsz;
  Grid.Canvas.Font.Name   := fnnm;
  Grid.Canvas.Font.Style  := fnst;
end;

function GridAddRow(Grid : tstringgrid; obj : TGridRows) : integer;
var min : integer;
begin
  result:=-1;
  if Grid.Objects[0,0] is TGridRows then begin
    if (Grid.Objects[0,0] as TGridRows).HeightTitle = -1 then min:=1 else min:=2;
    if Grid.RowCount=min then begin
      if Grid.Objects[0,min-1] is TGridRows then begin
        if (Grid.Objects[0,min-1] as TGridRows).ID=0 then begin
          (Grid.Objects[0,min-1] as TGridRows).Assign(obj);
           //IDCLIPS:=IDCLIPS+1;
          //(Grid.Objects[0,min-1] as TGridRows).ID:=IDCLIPS;
          result:=min-1;
          exit;
        end;
      end;
    end;
    Grid.RowCount:=Grid.RowCount + 1;
    if not (Grid.Objects[0,Grid.RowCount-1] is TGridRows) then begin
      Grid.Objects[0,Grid.RowCount-1] := TGridRows.Create;
      (Grid.Objects[0,Grid.RowCount-1] as TGridRows).Assign(obj);
      //IDCLIPS:=IDCLIPS+1;
      //(Grid.Objects[0,Grid.RowCount-1] as TGridRows).ID:=IDCLIPS;
    end;
    result := Grid.RowCount-1;
  end;
end;

procedure MyGridDeleteRow(Grid : tstringgrid; ARow : integer; obj : TGridRows);
var i, min : integer;
begin
  if Grid.Objects[0,0] is TGridRows then begin
    if (Grid.Objects[0,0] as TGridRows).HeightTitle = -1 then min:=1 else min:=2;
    if ARow < min - 1 then exit;
    if Grid.RowCount=min then begin
      (Grid.Objects[0,min-1] as TGridRows).Assign(obj);
      (Grid.Objects[0,min-1] as TGridRows).ID:=0;
      exit;
    end;
    If ARow=Grid.RowCount-1 then begin
      Grid.Objects[0,ARow]:=nil;
      Grid.RowCount:=Grid.RowCount-1;
      exit;
    end;
    If (ARow >= min-1) and (ARow < Grid.RowCount-1) then begin
      for i:=ARow to Grid.RowCount-2 do begin
        (Grid.Objects[0,i] as TGridRows).Assign((Grid.Objects[0,i+1] as TGridRows));
      end;
      Grid.Objects[0,Grid.RowCount-1]:=nil;
      Grid.RowCount:=Grid.RowCount-1;
      exit;
    end;
  end;
end;

function GridColX(Grid : tstringgrid; X : integer) : integer;
var i, lft, rgt, cl : integer;
begin
  result:=-1;
  lft:=0;
  for i:=Grid.LeftCol to Grid.ColCount-1 do begin
    rgt :=lft + Grid.ColWidths[i] + Grid.GridLineWidth;
    if (X > lft) and (X < rgt) then begin
      Result:=i;
      exit;
    end;
    lft := rgt;
  end;
end;

function findgridselection(grid : tstringgrid; cell : integer) : integer;
var i, st : integer;
begin
  result := -1;
  if grid.Objects[0,0] is TGridRows then begin
    if (grid.Objects[0,0] as TGridRows).HeightTitle >=0 then st:=1 else st:=0;
  end;
  if grid.RowCount=st+1 then begin
    if (grid.Objects[0,st] as TGridRows).ID <= 0 then exit;
  end;
  for i:=st to grid.RowCount-1 do begin
    if grid.Objects[0,i] is TGridRows then begin
      if (grid.Objects[0,i] as TGridRows).MyCells[cell].Mark then begin
        result:=i;
        exit;
      end;
    end;
  end;
end;

procedure GridClear(Grid : tstringgrid; obj : tgridrows);
var i, strt : integer;
begin
  strt := 1;
  if Grid.Objects[0,0] is tgridrows
    then if (Grid.Objects[0,0] as tgridrows).HeightTitle<>-1 then strt:=1 else strt:=0;
  for i:=Grid.RowCount-1 downto strt do MyGridDeleteRow(Grid, i, obj);
end;

procedure GridImageReload(Grid : tstringgrid);
var i, rw : integer;
    nm : string;
begin
  for rw:=0 to grid.RowCount-1 do begin
    if grid.Objects[0,rw] is tgridrows then begin
       for i:=0 to grid.ColCount-1 do begin
         if (grid.Objects[0,rw] as tgridrows).MyCells[i].CellType=tsImage then begin
           nm := (grid.Objects[0,rw] as tgridrows).MyCells[i].ReadPhrase('File');
           if FileExists(AppPath + dirimages + '\' +nm)
             then (grid.Objects[0,rw] as tgridrows).MyCells[i].LoadJpeg(AppPath + dirimages + '\' +nm,grid.ColWidths[i],grid.RowHeights[rw]);
         end;
         if rw mod 5 = 0 then grid.Repaint;
       end;
    end;
  end;
end;

Initialization
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Создаем шаблон таблицы Клипов и Активного плей-листа
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
RowGridClips := TGridRows.Create;

RowGridClips.HeightTitle:=30;
RowGridClips.HeightRow:=45;

ACell:=RowGridClips.AddCells;
RowGridClips.MyCells[ACell].CellType:=tsState;
RowGridClips.MyCells[ACell].Width:=25;
RowGridClips.MyCells[ACell].Used:=true;
RowGridClips.MyCells[ACell].Mark:=false;
RowGridClips.MyCells[ACell].Name:='Lock';
RowGridClips.MyCells[ACell].TypeImage:=picture;
RowGridClips.MyCells[ACell].ImageWidth:=20;
RowGridClips.MyCells[ACell].ImageHeight:=20;
RowGridClips.MyCells[ACell].ImagePosition:=ppCenter;
RowGridClips.MyCells[ACell].ImageTrue:='Lock';

ACell:=RowGridClips.AddCells;
RowGridClips.MyCells[ACell].CellType:=tsState;
RowGridClips.MyCells[ACell].Width:=25;
RowGridClips.MyCells[ACell].Used:=true;
RowGridClips.MyCells[ACell].Mark:=false;
RowGridClips.MyCells[ACell].Name:='Select';
RowGridClips.MyCells[ACell].TypeImage:=ellipse;
RowGridClips.MyCells[ACell].ColorFalse:=clGray;
RowGridClips.MyCells[ACell].ImageWidth:=18;
RowGridClips.MyCells[ACell].ImageHeight:=18;
RowGridClips.MyCells[ACell].ImagePosition:=ppCenter;
RowGridClips.MyCells[ACell].ColorTrue:=clGreen;


ACell:=RowGridClips.AddCells;
RowGridClips.MyCells[ACell].CellType:=tsState;
RowGridClips.MyCells[ACell].Width:=25;
RowGridClips.MyCells[ACell].Used:=true;
RowGridClips.MyCells[ACell].Mark:=true;
RowGridClips.MyCells[ACell].Name:='Play';
RowGridClips.MyCells[ACell].TypeImage:=picture;
RowGridClips.MyCells[ACell].ImageWidth:=20;
RowGridClips.MyCells[ACell].ImageHeight:=20;
RowGridClips.MyCells[ACell].ImagePosition:=ppCenter;
RowGridClips.MyCells[ACell].ImageTrue:='Button2';

ACell:=RowGridClips.AddCells;
RowGridClips.MyCells[ACell].CellType:=tsText;
RowGridClips.MyCells[ACell].Title:='Список клипов';
RowGridClips.MyCells[ACell].Mark:=true;
RowGridClips.MyCells[ACell].Width:=-1;
RowGridClips.MyCells[ACell].Procents:=100;
RowGridClips.MyCells[ACell].TopPhrase:=2;
RowGridClips.MyCells[ACell].Interval:=4;

ARow:=RowGridClips.MyCells[ACell].AddRow;
RowGridClips.MyCells[ACell].Rows[ARow].Top:=2;
RowGridClips.MyCells[ACell].Rows[ARow].Height:=20;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'Clip','');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize+2;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold:=true;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'File','');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=25;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=false;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'ImDataTTL','Дата регистрации:');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=50;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'ImportData','');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=59;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'DurTTL','Хронометраж:');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=75;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'Duration','');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=85;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'Comment','');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=95;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=false;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'NTK','00:00:00:00');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=98;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=false;

ARow:=RowGridClips.MyCells[ACell].AddRow;
RowGridClips.MyCells[ACell].Rows[ARow].Top:=22;
RowGridClips.MyCells[ACell].Rows[ARow].Height:=18;
APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'Song','');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'Singer','');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=25;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'EndDataTTL','Дата окончания:');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=50;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'EndData','');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=59;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'TypeTTL','Тип медиа данных:');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=75;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'TypeMedia','');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=85;

APhr:=RowGridClips.MyCells[ACell].AddPhrase(ARow,'Dur','00:00:00:00');
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=95;
RowGridClips.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=false;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Создаем шаблон списка Проекты
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

RowGridProject := TGridRows.Create;

RowGridProject.HeightTitle:=30;
RowGridProject.HeightRow:=45;

ACell:=RowGridProject.AddCells;
RowGridProject.MyCells[ACell].CellType:=tsState;
RowGridProject.MyCells[ACell].Width:=25;
RowGridProject.MyCells[ACell].Used:=true;
RowGridProject.MyCells[ACell].Mark:=true;
RowGridProject.MyCells[ACell].Name:='Lock';
RowGridProject.MyCells[ACell].TypeImage:=picture;
RowGridProject.MyCells[ACell].ImageWidth:=20;
RowGridProject.MyCells[ACell].ImageHeight:=20;
RowGridProject.MyCells[ACell].ImagePosition:=ppCenter;
RowGridProject.MyCells[ACell].ImageTrue:='Lock';

ACell:=RowGridProject.AddCells;
RowGridProject.MyCells[ACell].CellType:=tsState;
RowGridProject.MyCells[ACell].Width:=25;
RowGridProject.MyCells[ACell].Used:=true;
RowGridProject.MyCells[ACell].Mark:=false;
RowGridProject.MyCells[ACell].Name:='Select';
RowGridProject.MyCells[ACell].TypeImage:=ellipse;
RowGridProject.MyCells[ACell].ColorFalse:=clGray;
RowGridProject.MyCells[ACell].ImageWidth:=18;
RowGridProject.MyCells[ACell].ImageHeight:=18;
RowGridProject.MyCells[ACell].ImagePosition:=ppCenter;
RowGridProject.MyCells[ACell].ColorTrue:=clGreen;


ACell:=RowGridProject.AddCells;
RowGridProject.MyCells[ACell].CellType:=tsState;
RowGridProject.MyCells[ACell].Width:=25;
RowGridProject.MyCells[ACell].Used:=true;
RowGridProject.MyCells[ACell].Mark:=false;
RowGridProject.MyCells[ACell].Name:='Play';
RowGridProject.MyCells[ACell].TypeImage:=picture;
RowGridProject.MyCells[ACell].ImageWidth:=20;
RowGridProject.MyCells[ACell].ImageHeight:=20;
RowGridProject.MyCells[ACell].ImagePosition:=ppCenter;
RowGridProject.MyCells[ACell].ImageTrue:='OK';

ACell:=RowGridProject.AddCells;
RowGridProject.MyCells[ACell].CellType:=tsText;
RowGridProject.MyCells[ACell].Title:='Список проектов';
RowGridProject.MyCells[ACell].Mark:=true;
RowGridProject.MyCells[ACell].Width:=-1;
RowGridProject.MyCells[ACell].Procents:=100;
RowGridProject.MyCells[ACell].TopPhrase:=2;
RowGridProject.MyCells[ACell].Interval:=4;

ARow:=RowGridProject.MyCells[ACell].AddRow;
RowGridProject.MyCells[ACell].Rows[ARow].Top:=1;
RowGridProject.MyCells[ACell].Rows[ARow].Height:=22;

APhr:=RowGridProject.MyCells[ACell].AddPhrase(ARow,'Project','');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize+2;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold:=true;

APhr:=RowGridProject.MyCells[ACell].AddPhrase(ARow,'Note','');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=45;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=false;

APhr:=RowGridProject.MyCells[ACell].AddPhrase(ARow,'ImDataTTL','Дата регистрации:');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=60;

APhr:=RowGridProject.MyCells[ACell].AddPhrase(ARow,'ImportDate','');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=69;

ARow:=RowGridProject.MyCells[ACell].AddRow;
RowGridProject.MyCells[ACell].Rows[ARow].Top:=25;
RowGridProject.MyCells[ACell].Rows[ARow].Height:=20;
APhr:=RowGridProject.MyCells[ACell].AddPhrase(ARow,'Comment','');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize-2;

APhr:=RowGridProject.MyCells[ACell].AddPhrase(ARow,'EndDataTTL','Дата окончания:');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=60;

APhr:=RowGridProject.MyCells[ACell].AddPhrase(ARow,'EndDate','');
RowGridProject.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=69;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Создаем шаблон списка Плей-листов
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

RowGridListPL := TGridRows.Create;

RowGridListPL .HeightTitle:=0;
RowGridListPL .HeightRow:=45;

ACell:=RowGridListPL .AddCells;
RowGridListPL .MyCells[ACell].CellType:=tsState;
RowGridListPL .MyCells[ACell].Width:=25;
RowGridListPL .MyCells[ACell].Used:=true;
RowGridListPL .MyCells[ACell].Mark:=true;
RowGridListPL .MyCells[ACell].Name:='Lock';
RowGridListPL .MyCells[ACell].TypeImage:=picture;
RowGridListPL .MyCells[ACell].ImageWidth:=20;
RowGridListPL .MyCells[ACell].ImageHeight:=20;
RowGridListPL .MyCells[ACell].ImagePosition:=ppCenter;
RowGridListPL .MyCells[ACell].ImageTrue:='Lock';

ACell:=RowGridListPL .AddCells;
RowGridListPL .MyCells[ACell].CellType:=tsState;
RowGridListPL .MyCells[ACell].Width:=25;
RowGridListPL .MyCells[ACell].Used:=true;
RowGridListPL .MyCells[ACell].Mark:=false;
RowGridListPL .MyCells[ACell].Name:='Select';
RowGridListPL .MyCells[ACell].TypeImage:=ellipse;
RowGridListPL .MyCells[ACell].ColorFalse:=clGray;
RowGridListPL .MyCells[ACell].ImageWidth:=18;
RowGridListPL .MyCells[ACell].ImageHeight:=18;
RowGridListPL .MyCells[ACell].ImagePosition:=ppCenter;
RowGridListPL .MyCells[ACell].ColorTrue:=clGreen;


ACell:=RowGridListPL .AddCells;
RowGridListPL .MyCells[ACell].CellType:=tsState;
RowGridListPL .MyCells[ACell].Width:=25;
RowGridListPL .MyCells[ACell].Used:=true;
RowGridListPL .MyCells[ACell].Mark:=false;
RowGridListPL .MyCells[ACell].Name:='Play';
RowGridListPL .MyCells[ACell].TypeImage:=picture;
RowGridListPL .MyCells[ACell].ImageWidth:=20;
RowGridListPL .MyCells[ACell].ImageHeight:=20;
RowGridListPL .MyCells[ACell].ImagePosition:=ppCenter;
RowGridListPL .MyCells[ACell].ImageTrue:='OK';

ACell:=RowGridListPL .AddCells;
RowGridListPL .MyCells[ACell].CellType:=tsText;
RowGridListPL .MyCells[ACell].Title:='Список проектов';
RowGridListPL .MyCells[ACell].Mark:=true;
RowGridListPL .MyCells[ACell].Width:=-1;
RowGridListPL .MyCells[ACell].Procents:=100;
RowGridListPL .MyCells[ACell].TopPhrase:=2;
RowGridListPL .MyCells[ACell].Interval:=4;

ARow:=RowGridListPL .MyCells[ACell].AddRow;
RowGridListPL .MyCells[ACell].Rows[ARow].Top:=1;
RowGridListPL .MyCells[ACell].Rows[ARow].Height:=22;

APhr:=RowGridListPL .MyCells[ACell].AddPhrase(ARow,'Name','');
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize+2;
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].Bold:=true;

APhr:=RowGridListPL .MyCells[ACell].AddPhrase(ARow,'Note','');
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=45;
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=false;

APhr:=RowGridListPL .MyCells[ACell].AddPhrase(ARow,'ImDataTTL','Дата регистрации:');
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=60;

APhr:=RowGridListPL .MyCells[ACell].AddPhrase(ARow,'ImportDate','');
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=69;

ARow:=RowGridListPL .MyCells[ACell].AddRow;
RowGridListPL .MyCells[ACell].Rows[ARow].Top:=25;
RowGridListPL .MyCells[ACell].Rows[ARow].Height:=20;
APhr:=RowGridListPL .MyCells[ACell].AddPhrase(ARow,'Comment','');
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize-2;

APhr:=RowGridListPL .MyCells[ACell].AddPhrase(ARow,'EndDataTTL','Дата окончания:');
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=60;

APhr:=RowGridListPL .MyCells[ACell].AddPhrase(ARow,'EndDate','');
RowGridListPL .MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=69;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Создаем шаблон списка Текстовых шаблонов
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

RowGridListTxt := TGridRows.Create;

RowGridListTxt .HeightTitle:=0;
RowGridListTxt .HeightRow:=35;

ACell:=RowGridListTxt .AddCells;
RowGridListTxt .MyCells[ACell].CellType:=tsState;
RowGridListTxt .MyCells[ACell].Width:=25;
RowGridListTxt .MyCells[ACell].Used:=true;
RowGridListTxt .MyCells[ACell].Mark:=false;
RowGridListTxt .MyCells[ACell].Name:='Select';
RowGridListTxt .MyCells[ACell].TypeImage:=ellipse;
RowGridListTxt .MyCells[ACell].ColorFalse:=clGray;
RowGridListTxt .MyCells[ACell].ImageWidth:=18;
RowGridListTxt .MyCells[ACell].ImageHeight:=18;
RowGridListTxt .MyCells[ACell].ImagePosition:=ppCenter;
RowGridListTxt .MyCells[ACell].ColorTrue:=clGreen;

ACell:=RowGridListTxt .AddCells;
RowGridListTxt .MyCells[ACell].CellType:=tsText;
RowGridListTxt .MyCells[ACell].Title:='Список текстовых щаблонов';
RowGridListTxt .MyCells[ACell].Mark:=true;
RowGridListTxt .MyCells[ACell].Width:=-1;
RowGridListTxt .MyCells[ACell].Procents:=100;
RowGridListTxt .MyCells[ACell].TopPhrase:=2;
RowGridListTxt .MyCells[ACell].Interval:=4;

ARow:=RowGridListTxt .MyCells[ACell].AddRow;
RowGridListTxt .MyCells[ACell].Rows[ARow].Top:=5;
RowGridListTxt .MyCells[ACell].Rows[ARow].Height:=20;

APhr:=RowGridListTxt .MyCells[ACell].AddPhrase(ARow,'Template','');
RowGridListTxt .MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridListTxt .MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize+2;
RowGridListTxt .MyCells[ACell].Rows[ARow].Phrases[APhr].Bold:=true;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Создаем шаблон списка Графических шаблонов
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

RowGridListGR := TGridRows.Create;

RowGridListGR.HeightTitle:=0;
RowGridListGR.HeightRow:=80;

ACell:=RowGridListGR.AddCells;
RowGridListGR.MyCells[ACell].CellType:=tsState;
RowGridListGR.MyCells[ACell].Width:=25;
RowGridListGR.MyCells[ACell].Used:=true;
RowGridListGR.MyCells[ACell].Mark:=false;
RowGridListGR.MyCells[ACell].Name:='Select';
RowGridListGR.MyCells[ACell].TypeImage:=ellipse;
RowGridListGR.MyCells[ACell].ColorFalse:=clGray;
RowGridListGR.MyCells[ACell].ImageWidth:=18;
RowGridListGR.MyCells[ACell].ImageHeight:=18;
RowGridListGR.MyCells[ACell].ImagePosition:=ppCenter;
RowGridListGR.MyCells[ACell].ColorTrue:=clGreen;

ACell:=RowGridListGR.AddCells;
RowGridListGR.MyCells[ACell].CellType:=tsImage;
RowGridListGR.MyCells[ACell].Width:=RowGridListGR.HeightRow div 9 *16;
RowGridListGR.MyCells[ACell].Used:=true;
RowGridListGR.MyCells[ACell].Mark:=false;
RowGridListGR.MyCells[ACell].Name:='Picture';
RowGridListGR.MyCells[ACell].TypeImage:=ellipse;
RowGridListGR.MyCells[ACell].ColorFalse:=clGray;

ARow:=RowGridListGR.MyCells[ACell].AddRow;
RowGridListGR.MyCells[ACell].Rows[ARow].Top:=8;
RowGridListGR.MyCells[ACell].Rows[ARow].Height:=30;
APhr:=RowGridListGR.MyCells[ACell].AddPhrase(ARow,'File','');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=false;

APhr:=RowGridListGR.MyCells[ACell].AddPhrase(ARow,'Import','');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=false;

ARow:=RowGridListGR.MyCells[ACell].AddRow;
RowGridListGR.MyCells[ACell].Rows[ARow].Top:=45;
RowGridListGR.MyCells[ACell].Rows[ARow].Height:=20;
APhr:=RowGridListGR.MyCells[ACell].AddPhrase(ARow,'Note','Файл не найден');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Visible:=false;

ACell:=RowGridListGR.AddCells;
RowGridListGR.MyCells[ACell].CellType:=tsText;
RowGridListGR.MyCells[ACell].Title:='Список графических шаблонов';
RowGridListGR.MyCells[ACell].Mark:=true;
RowGridListGR.MyCells[ACell].Width:=-1;
RowGridListGR.MyCells[ACell].Procents:=100;
RowGridListGR.MyCells[ACell].TopPhrase:=2;
RowGridListGR.MyCells[ACell].Interval:=4;

ARow:=RowGridListGR.MyCells[ACell].AddRow;
RowGridListGR.MyCells[ACell].Rows[ARow].Top:=8;
RowGridListGR.MyCells[ACell].Rows[ARow].Height:=30;

APhr:=RowGridListGR.MyCells[ACell].AddPhrase(ARow,'Template','');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize+2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold:=true;

ARow:=RowGridListGR.MyCells[ACell].AddRow;
RowGridListGR.MyCells[ACell].Rows[ARow].Top:=45;
RowGridListGR.MyCells[ACell].Rows[ARow].Height:=20;

APhr:=RowGridListGR.MyCells[ACell].AddPhrase(ARow,'File','');
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].leftprocent:=2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].FontSize:=ProgrammFontSize-2;
RowGridListGR.MyCells[ACell].Rows[ARow].Phrases[APhr].Bold:=true;

end.
