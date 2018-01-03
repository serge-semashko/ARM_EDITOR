unit UDrawCell;

interface
Uses Printers, winspool, WinTypes, WinProcs, Graphics, Variants,
     Grids, Classes, StdCtrls, Types, SysUtils, Forms, Dialogs;

Type
  TCellFormat = Class(TObject)
  public
    OffsetLeft   : Integer;  //отступ от левой границы €чейки
    OffsetTop    : Integer;  //отступ от верхней границы €чейки
    OffsetRight  : Integer;  //отступ от правой границы €чейки
    OffsetBottom : Integer;  //отступ от нижней границы €чейки
    OffsetImageY : Integer;  //отступ от верхней границы €чейки дл€ рисунка
    OffsetImageX : Integer;  //отступ от боковых границ €чейки дл€ рисунка
    FontName     : String;   //шрифт €чейки используетс€ если text=''
    FontSize     : Integer;  //размер шрифта €чейки используетс€ если text=''
    FontColor    : Integer;  //цвет шрифта €чейки используетс€ если text=''
    Bold         : Boolean;  //толстый шрифт €чейки используетс€ если text=''
    Italic       : Boolean;  //наклонный шрифт €чеиспользуетс€ если text=''
    UnderLine    : Boolean;  //ѕодчеркнутый шрифт €чейки используетс€ если text=''
    Flag         : Word;     //‘ормат вывода текста используетс€ если text=''
    Text         : String;   //‘орматированый текст используетс€ если необходимо выводить текст по абзацам
    Bitmap       : TBitmap;  //–исунок отображаемый в €чейке
    Width        : Integer;  //ширина рисунка если равна нулю то ширина €чейки
    Height       : integer;  //высота рисунка если равна нулю то высота €чейки
    Stretch      : Boolean;  //≈сли »стина то рисунок вписываетс€ в €чейку ширина и высота масштабируютс€ в соответствии с параметрами €чейки
    BackGround   : TColor;   //‘оновый цвет €чейки
    FixWidth     : Boolean;  //Ќе измен€ть ширину €чейки
    Comment      : String;   // омментарий
    //SQL          : String;   //SQL-запрос
    NRow         : integer;  //Ќомер строки в описании строк
    NCol         : integer;  //Ќомер столбца в описании столбцов
    //SQLParam     : String;   //—трока описани€ параметров всех SQL запросов
    RotateText   : Boolean;  //ѕризнак показывающий что текст в €чейке необходимо повернуть
    Degrees      : Integer;  //«начение в градусах на которое необходимо повернуть текст (пока только на 90градусов)
    Constructor Create;
    destructor  Destroy; override;
  end;

  function NewParagraph : string;
  function GetCellString(prgf, param, defvol : string) : string;
  function GetCellInteger(prgf, param : string; defvol : integer) : integer;
  procedure SetCellString(var prgf : string; Const param, defvol : string);
  procedure SetCellInteger(var prgf : string; Const param : string; defvol : integer);
  function ListParagraphs(txt : string) : TStrings;
  function selectparagraphs(txt, param : string) : string;
  function CellRotateTextOut(cv : tcanvas; Rect: TRect; ss : string; dgr : integer) : integer;
  procedure MyGridDrawCell(stringgrid1 : tstringgrid; ACol, ARow: Integer;
                           Rect: TRect; State: TGridDrawState);
  function DrawGridCell(CV : TCanvas; kfX,kfY : real; x,y :  integer;
                        gr : tstringgrid; ACol, ARow : integer) : integer;
  procedure setcelloptions(gr : tstringgrid; mmx, mmy : real; ACol, ARow : integer; txt : string; wdtupd : boolean);
  function setrowsheight(gr : tstringgrid; ip : integer) : integer;

implementation

destructor TCellFormat.Destroy;
begin
  FreeMem(@OffsetLeft);
  FreeMem(@OffsetTop);
  FreeMem(@OffsetRight);
  FreeMem(@OffsetBottom);
  FreeMem(@OffsetImageY);
  FreeMem(@OffsetImageX);
  FreeMem(@FontName);
  FreeMem(@FontSize);
  FreeMem(@FontColor);
  FreeMem(@Bold);
  FreeMem(@Italic);
  FreeMem(@UnderLine);
  FreeMem(@Flag);
  FreeMem(@Text);
  bitmap.Free;
  FreeMem(@Width);
  FreeMem(@Height);
  FreeMem(@Stretch);
  FreeMem(@FixWidth);
  FreeMem(@Comment);
  FreeMem(@NRow);
  FreeMem(@NCol);
  FreeMem(@RotateText);
  FreeMem(@Degrees);
  FreeMem(@BackGround);
  inherited Destroy;
end;

Constructor TCellFormat.Create;
begin
    inherited;
    OffsetLeft := 3;
    OffsetTop := 3;
    OffsetRight :=3;
    OffsetBottom :=3;
    OffsetImageY := 1;
    OffsetImageX := 1;
    FontName := '';
    FontSize := 8;
    FontColor := clBlack;
    Bold :=false;
    Italic :=false;
    UnderLine :=false;
    Flag :=DT_LEFT or DT_WORDBREAK;
    Text :='';
    Bitmap :=nil;
    Width :=0;
    Height :=0;
    Stretch := false;
    FixWidth := false;
    Comment := '';
    NRow := 0;
    NCol := 0;
    RotateText := false;
    Degrees:=90;
    BackGround := clBtnFace;
end;

procedure setcelloptions(gr : tstringgrid; mmx, mmy : real; ACol, ARow : integer; txt : string; wdtupd : boolean);
var sbgnd : string;
    wdt : integer;
begin
  if gr.Objects[ACol, ARow]=nil then gr.Objects[ACol, ARow]:=tcellformat.Create;
  (gr.Objects[ACol, ARow] as tcellformat).OffsetLeft:=trunc(STRTOFLOAT(getcellstring(txt,'SpaceLeft','0')) * mmx);
  (gr.Objects[ACol, ARow] as tcellformat).OffsetRight:=trunc(STRTOFLOAT(getcellstring(txt,'SpaceRight','0')) * mmx);
  (gr.Objects[ACol, ARow] as tcellformat).OffsetTop:=trunc(STRTOFLOAT(getcellstring(txt,'SpaceTop','0')) * mmy);
  (gr.Objects[ACol, ARow] as tcellformat).OffsetBottom:=trunc(STRTOFLOAT(getcellstring(txt,'SpaceBottom','0')) * mmy);
  if ARow=0 then begin
    wdt:=trunc(STRTOFLOAT(getcellstring(txt,'ColWidth','20')) * mmx);
    if wdtupd
      then gr.ColWidths[ACol]:=wdt
      else if wdt > gr.ColWidths[ACol] then gr.ColWidths[ACol]:=wdt;
    if getcellinteger(txt,'FixWidth',0) = 1
      then (gr.Objects[ACol, ARow] as tcellformat).FixWidth:=True
      else (gr.Objects[ACol, ARow] as tcellformat).FixWidth:=False;
  end;

  if trim(GetCellString(txt,'Orientation','√оризонтально'))='√оризонтально' then begin
    (gr.Objects[ACol, ARow] as tcellformat).RotateText:=false;
    (gr.Objects[ACol, ARow] as tcellformat).Degrees:=0;
  end else begin
    (gr.Objects[ACol, ARow] as tcellformat).RotateText:=true;
    (gr.Objects[ACol, ARow] as tcellformat).Degrees:=90;
  end;
  (gr.Objects[ACol, ARow] as tcellformat).Flag:=GetCellInteger(txt,'Flag',DT_CENTER or DT_VCENTER);
  sbgnd := getcellstring(txt,'BackGroundType','');
  if trim(sbgnd)=''
    then (gr.Objects[ACol, ARow] as tcellformat).BackGround:=getcellinteger(txt,'BackGround',gr.FixedColor)
    else (gr.Objects[ACol, ARow] as tcellformat).BackGround:=gr.Color;
  (gr.Objects[ACol, ARow] as tcellformat).FontName:=getcellstring(txt,'FontName',gr.Font.Name);
  (gr.Objects[ACol, ARow] as tcellformat).FontSize:=getcellinteger(txt,'FontSize',gr.Font.Size);
  (gr.Objects[ACol, ARow] as tcellformat).FontColor:=getcellinteger(txt,'FontColor',gr.Font.Color);
  if getcellinteger(txt,'Bold',0) = 1
    then (gr.Objects[ACol, ARow] as tcellformat).Bold:=True
    else (gr.Objects[ACol, ARow] as tcellformat).Bold:=False;
  if getcellinteger(txt,'Italic',0) = 1
    then (gr.Objects[ACol, ARow] as tcellformat).Italic:=True
    else (gr.Objects[ACol, ARow] as tcellformat).Italic:=False;
  if getcellinteger(txt,'UnderLine',0) = 1
    then (gr.Objects[ACol, ARow] as tcellformat).UnderLine:=True
    else (gr.Objects[ACol, ARow] as tcellformat).UnderLine:=False;
end;

function CellRotateTextOut(cv : tcanvas; Rect: TRect; ss : string; dgr : integer) : integer;
var OldFont, NewFont: hFont;
    lf : TLogFont;
    ww, hh, x, y : integer;
begin
  With lf, cv do begin
   lfHeight := Font.Height;
   lfWidth := 0;
   lfEscapement := dgr*10;
   lfOrientation := dgr*10;
   if fsBold in Font.Style then lfWeight := FW_BOLD
   else lfWeight := FW_NORMAL;
   lfItalic := Byte(fsItalic in Font.Style);
   lfUnderline := Byte(fsUnderline in Font.Style);
   lfStrikeOut := Byte(fsStrikeOut in Font.Style);
   lfCharSet := DEFAULT_CHARSET;
   StrPCopy(lfFaceName, Font.Name);
   lfQuality := DEFAULT_QUALITY;
   lfOutPrecision := OUT_DEFAULT_PRECIS;
   lfClipPrecision := CLIP_DEFAULT_PRECIS;
   lfPitchAndFamily := DEFAULT_PITCH;
  end;
  NewFont := CreateFontIndirect(lf);
  OldFont := SelectObject(cv.Handle, NewFont);
    ww:=cv.TextWidth(ss);
    hh:=cv.TextHeight(ss);
    x:=Rect.Left +(Rect.Right-Rect.Left) div 2 - hh div 2;
    y:=Rect.Top + (Rect.Bottom-Rect.Top) div 2 + ww div 2;
  Cv.TextOut(x, y, ss);
  SelectObject(Cv.Handle, OldFont);
  DeleteObject(NewFont);
  result:=ww + hh div 2;
END;


procedure MyGridDrawCell(stringgrid1 : tstringgrid; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var s, zn : string;
    dlt, i, H, H1, DH : integer;
    OffTxtX, OffTxtY : integer;
    wdtimg, hgtimg  : integer;
    Flag : Word;
    TempRect, ImgRect : TRect;
    lst : tstrings;
    clr : tcolor;
    RotateText : boolean;
begin
  dlt:=0;
  s:=stringgrid1.Cells[ACol, ARow];
  if (stringgrid1.Objects[ACol,ARow] as TCellFormat)<> nil then begin
    s:=(StringGrid1.Objects[ACol,ARow] as TCellFormat).Text;
    if trim(s)='' then s:=stringgrid1.Cells[ACol, ARow];
  end;

  with StringGrid1 do begin
    try
      if (ARow < stringgrid1.FixedRows) or (ACol < stringgrid1.FixedCols)
        then clr := stringgrid1.FixedColor
        else clr := stringgrid1.Color;

      if (stringgrid1.Objects[ACol,ARow] as TCellFormat)<> nil
        then clr:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).BackGround;

      Canvas.Brush.Color:=clr;
      Canvas.Brush.Style := bsSolid;
      Canvas.FillRect(Rect);
      OffTxtX:=0;
      OffTxtY:=0;
      if (stringgrid1.Objects[ACol,ARow] as TCellFormat)<> nil then begin
        if (stringgrid1.Objects[ACol,ARow] as TCellFormat).Bitmap<>nil then begin
          if not (stringgrid1.Objects[ACol,ARow] as TCellFormat).Stretch then begin
            wdtimg := (stringgrid1.Objects[ACol,ARow] as TCellFormat).Width;
            hgtimg := (stringgrid1.Objects[ACol,ARow] as TCellFormat).Height;
            OffTxtX:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetImageX;
            OffTxtY:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetImageY;
            if wdtimg=0 then wdtimg:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).Bitmap.Width;
            if hgtimg=0 then hgtimg:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).Bitmap.Height;
            if (2*OffTxtX + wdtimg) < StringGrid1.ColWidths[ACol]
              then OffTxtX:=OffTxtX + wdtimg else OffTxtX:=StringGrid1.ColWidths[ACol];
            if (2*OffTxtY + hgtimg) < StringGrid1.RowHeights[ARow]
              then OffTxtY:=OffTxtY + hgtimg else OffTxtY:=StringGrid1.RowHeights[ACol];
          end;
          imgrect.Left:=Rect.Left+(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetImageX;
          imgrect.Top:=Rect.Top + (stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetImageY;
          imgrect.Right:=Rect.Left + wdtimg+(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetImageX;
          imgrect.Bottom:=Rect.Top + hgtimg+(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetImageY;
        end;
      end;

      lst:=ListParagraphs(s);
      h1:=0;
      if lst.count>0 then begin
         dlt:=(stringgrid1.Objects[ACol, ARow] as tcellformat).OffsetTop;
         for i:=0 to lst.Count-1 do begin
           flag:=getcellinteger(lst.Strings[i],'Flag',(stringgrid1.Objects[ACol,ARow] as TCellFormat).Flag);
           Canvas.Font.Color:=getcellinteger(lst.Strings[i], 'FontColor', (stringgrid1.Objects[ACol,ARow] as TCellFormat).FontColor);
           Canvas.Font.Name:=getcellstring(lst.Strings[i], 'FontName', (stringgrid1.Objects[ACol,ARow] as TCellFormat).FontName);
           Canvas.Font.Size:=getcellinteger(lst.Strings[i], 'FontSize', (stringgrid1.Objects[ACol,ARow] as TCellFormat).FontSize);
           if getcellinteger(lst.Strings[i], 'Bold', 0)=1
             then Canvas.Font.Style:=Canvas.Font.Style + [fsBold]
             else Canvas.Font.Style:=Canvas.Font.Style - [fsBold];
           if getcellinteger(lst.Strings[i], 'Italic', 0)=1
             then Canvas.Font.Style:=Canvas.Font.Style + [fsItalic]
             else Canvas.Font.Style:=Canvas.Font.Style - [fsItalic];
           if getcellinteger(lst.Strings[i], 'UnderLine', 0)=1
             then Canvas.Font.Style:=Canvas.Font.Style + [fsUnderLine]
             else Canvas.Font.Style:=Canvas.Font.Style - [fsUnderLine];

           TempRect.Top:=Rect.Top+(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetTop+h1;//Paragraph.OffsetTop+H1;
           TempRect.Left:=Rect.Left+OffTxtX+(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetLeft;//+Paragraph.OffsetLeft;
           TempRect.Right:=Rect.Right-(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetRight;//+Paragraph.OffsetRight;
           TempRect.Bottom:=Rect.Bottom+h1;

           zn:= getcellstring(lst.Strings[i], 'Text', '');
           H := DrawText(Canvas.Handle,PChar(zn),length(zn),temprect,flag) + 3;
           H1:=H+H1;
         end;
         lst.Clear;
      end else begin
         if (stringgrid1.Objects[ACol,ARow] as TCellFormat)<> nil then begin
           dlt:=(stringgrid1.Objects[ACol, ARow] as tcellformat).OffsetTop;
           RotateText:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).RotateText;
           flag:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).Flag;
           Canvas.Font.Color:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).FontColor;
           Canvas.Font.Name:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).FontName;
           Canvas.Font.Size:=(stringgrid1.Objects[ACol,ARow] as TCellFormat).FontSize;
           if (stringgrid1.Objects[ACol,ARow] as TCellFormat).Bold
             then Canvas.Font.Style:=Canvas.Font.Style + [fsBold]
             else Canvas.Font.Style:=Canvas.Font.Style - [fsBold];
           if (stringgrid1.Objects[ACol,ARow] as TCellFormat).Italic
             then Canvas.Font.Style:=Canvas.Font.Style + [fsItalic]
             else Canvas.Font.Style:=Canvas.Font.Style - [fsItalic];
           if (stringgrid1.Objects[ACol,ARow] as TCellFormat).UnderLine
             then Canvas.Font.Style:=Canvas.Font.Style + [fsUnderLine]
             else Canvas.Font.Style:=Canvas.Font.Style - [fsUnderLine];

           TempRect.Top:=Rect.Top+(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetTop;
           TempRect.Left:=Rect.Left+OffTxtX+(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetLeft;
           TempRect.Right:=Rect.Right-(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetRight;
           TempRect.Bottom:=Rect.Bottom;
         end else begin
           flag:=DT_LEFT or DT_WORDBREAK;
           Canvas.Font.Color := stringgrid1.Font.Color;
           Canvas.Font.Name  := stringgrid1.Font.Name;
           Canvas.Font.Size  := stringgrid1.Font.Size;
           Canvas.Font.Style := stringgrid1.Font.Style;

           TempRect.Top:=Rect.Top+3;
           TempRect.Left:=Rect.Left+3;
           TempRect.Right:=Rect.Right-3;
           TempRect.Bottom:=Rect.Bottom;
         end;
         if  RotateText then begin
           H1:=CellRotateTextOut(stringgrid1.Canvas,TempRect,s,(stringgrid1.Objects[ACol,ARow] as TCellFormat).degrees);
           //H1:=StringGridRotateTextOut(stringgrid1,arow,acol,rect)+20;
         end else H1 := DrawText(Canvas.Handle,PChar(s),length(s),temprect,flag);// + 3;
     end;
     //dh:=stringgrid1.RowHeights[ARow];
     if H1 > stringgrid1.RowHeights[ARow]+dlt then stringgrid1.RowHeights[ARow] := H1 + dlt;  //увеличиваем

     if (stringgrid1.Objects[ACol,ARow] as TCellFormat)<> nil then begin
       if (stringgrid1.Objects[ACol,ARow] as TCellFormat).Bitmap<>nil then begin
         if (stringgrid1.Objects[ACol,ARow] as TCellFormat).Stretch then begin
           imgrect.Right:=Rect.Right-(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetImageX;
           imgrect.Bottom:=rect.Bottom-(stringgrid1.Objects[ACol,ARow] as TCellFormat).OffsetImageY;
         end;
         canvas.StretchDraw(imgrect,(stringgrid1.Objects[ACol,ARow] as TCellFormat).Bitmap);
       end;
     end;
     if stringgrid1.GridLineWidth > 0 then begin
       Canvas.CopyMode:=cmSrcCopy;
       Canvas.Pen.Color:=clBlack;
       Canvas.Brush.Style:=bsClear;
       canvas.Rectangle(rect.Left-1,rect.Top-1,rect.Left+stringgrid1.ColWidths[ACol]+1,rect.Top+stringgrid1.RowHeights[ARow]+1);
     end;
     lst.Clear;
    finally lst.Free;
    end;
  end;
end;

//функци€ рисует €чейку таблицы и заполн€ет ee
function DrawGridCell(CV : TCanvas; kfX,kfY : real; x,y :  integer; gr : tstringgrid; ACol, ARow : integer) : integer;
var s, zn : string;
    dlt, i, Hh, H1 : integer;
    OffTxtX, OffTxtY : integer;
    wdtimg, hgtimg  : integer;
    Flag : Word;
    r, TempRect, ImgRect : TRect;
    lst : tstrings;
    clr : tcolor;
    wd, hg : integer;
    RotateText:Boolean;
begin
  dlt:=0;
  RotateText:=false;
  s:=gr.Cells[ACol, ARow];
  if (gr.Objects[ACol,ARow] as TCellFormat)<> nil then begin
    s:=(gr.Objects[ACol,ARow] as TCellFormat).Text;
    if trim(s)='' then s:=gr.Cells[ACol, ARow];
  end;
    try
      if (ARow < gr.FixedRows) or (ACol < gr.FixedCols)
        then clr := gr.FixedColor
        else clr := gr.Color;

      if (gr.Objects[ACol,ARow] as TCellFormat)<> nil
        then clr:=(gr.Objects[ACol,ARow] as TCellFormat).BackGround;

      CV.Brush.Color:=clr;
      CV.Brush.Style := bsSolid;
      wd:=trunc(gr.ColWidths[ACol]*kfx);
      hg:=trunc(gr.RowHeights[ARow]*kfy);
      r:=Rect(x,y,x+trunc(gr.ColWidths[ACol]*kfx),y+trunc(gr.RowHeights[ARow]*kfy));

        CV.FillRect(r);
     if gr.GridLineWidth>0 then begin   
        CV.MoveTo(x,y);
        CV.LineTo(x +trunc(gr.ColWidths[ACol]*kfx),y);
        CV.MoveTo(x,y);
        CV.LineTo(x,y+trunc(gr.RowHeights[ARow]*kfy));
        CV.MoveTo(x+trunc(gr.ColWidths[ACol]*kfx),y);
        CV.LineTo(x+trunc(gr.ColWidths[ACol]*kfx),y+trunc(gr.RowHeights[ARow]*kfy));
        CV.MoveTo(x,y+trunc(gr.RowHeights[ARow]*kfy));
        CV.LineTo(x+trunc(gr.ColWidths[ACol]*kfx),y+trunc(gr.RowHeights[ARow]*kfy));
     end;

      OffTxtX:=0;
      OffTxtY:=0;
      if (gr.Objects[ACol,ARow] as TCellFormat)<> nil then begin
        if (gr.Objects[ACol,ARow] as TCellFormat).Bitmap<>nil then begin
          if not (gr.Objects[ACol,ARow] as TCellFormat).Stretch then begin
            wdtimg := trunc((gr.Objects[ACol,ARow] as TCellFormat).Width*kfx);
            hgtimg := trunc((gr.Objects[ACol,ARow] as TCellFormat).Height*kfy);
            OffTxtX:=trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetImageX*kfx);
            OffTxtY:=trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetImageY*kfy);
            if wdtimg=0 then wdtimg:=trunc((gr.Objects[ACol,ARow] as TCellFormat).Bitmap.Width*kfx);
            if hgtimg=0 then hgtimg:=trunc((gr.Objects[ACol,ARow] as TCellFormat).Bitmap.Height*kfy);
            if (2*OffTxtX + wdtimg) < trunc(gr.ColWidths[ACol]*kfx)
              then OffTxtX:=OffTxtX + wdtimg else OffTxtX:=trunc(gr.ColWidths[ACol]*kfx);
            if (2*OffTxtY + hgtimg) < trunc(gr.RowHeights[ARow]*kfy)
              then OffTxtY:=OffTxtY + hgtimg else OffTxtY:=trunc(gr.RowHeights[ARow]*kfy);
          end;
          imgrect.Left:=R.Left+trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetImageX*kfx);
          imgrect.Top:=R.Top + trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetImageY*kfy);
          imgrect.Right:=R.Left + wdtimg+trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetImageX*kfx);
          imgrect.Bottom:=R.Top + hgtimg+trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetImageY*kfy);
        end;
      end;

      lst:=ListParagraphs(s);
      h1:=0;
      Hh:=0;
      if lst.count>0 then begin
         dlt:=trunc((gr.Objects[ACol, ARow] as tcellformat).OffsetTop * kfy);
         for i:=0 to lst.Count-1 do begin
           flag:=getcellinteger(lst.Strings[i],'Flag',(gr.Objects[ACol,ARow] as TCellFormat).Flag);
           CV.Font.Color:=getcellinteger(lst.Strings[i], 'FontColor', (gr.Objects[ACol,ARow] as TCellFormat).FontColor);
           CV.Font.Name:=getcellstring(lst.Strings[i], 'FontName', (gr.Objects[ACol,ARow] as TCellFormat).FontName);
           CV.Font.Size:=getcellinteger(lst.Strings[i], 'FontSize', (gr.Objects[ACol,ARow] as TCellFormat).FontSize);
           if getcellinteger(lst.Strings[i], 'Bold', 0)=1
             then CV.Font.Style:=CV.Font.Style + [fsBold]
             else CV.Font.Style:=CV.Font.Style - [fsBold];
           if getcellinteger(lst.Strings[i], 'Italic', 0)=1
             then CV.Font.Style:=CV.Font.Style + [fsItalic]
             else CV.Font.Style:=CV.Font.Style - [fsItalic];
           if getcellinteger(lst.Strings[i], 'UnderLine', 0)=1
             then CV.Font.Style:=CV.Font.Style + [fsUnderLine]
             else CV.Font.Style:=CV.Font.Style - [fsUnderLine];

           TempRect.Top:=R.Top+trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetTop*kfy+1)+h1;
           TempRect.Left:=R.Left+OffTxtX+trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetLeft*kfx+1);
           TempRect.Right:=R.Right-trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetRight*kfx+1);
           TempRect.Bottom:=R.Bottom+h1;

           zn:= getcellstring(lst.Strings[i], 'Text', '');
           Hh := DrawText(CV.Handle,PChar(zn),length(zn),temprect,flag) + trunc(3*kfy);
           H1:=Hh+H1;
         end;
         lst.Clear;
      end else begin
         if (gr.Objects[ACol,ARow] as TCellFormat)<> nil then begin
           dlt:=trunc((gr.Objects[ACol, ARow] as tcellformat).OffsetTop * kfy);
           RotateText:=(gr.Objects[ACol,ARow] as TCellFormat).RotateText;
           flag:=(gr.Objects[ACol,ARow] as TCellFormat).Flag;
           CV.Font.Color:=(gr.Objects[ACol,ARow] as TCellFormat).FontColor;
           CV.Font.Name:=(gr.Objects[ACol,ARow] as TCellFormat).FontName;
           CV.Font.Size:=(gr.Objects[ACol,ARow] as TCellFormat).FontSize;
           if (gr.Objects[ACol,ARow] as TCellFormat).Bold
             then CV.Font.Style:=CV.Font.Style + [fsBold]
             else CV.Font.Style:=CV.Font.Style - [fsBold];
           if (gr.Objects[ACol,ARow] as TCellFormat).Italic
             then CV.Font.Style:=CV.Font.Style + [fsItalic]
             else CV.Font.Style:=CV.Font.Style - [fsItalic];
           if (gr.Objects[ACol,ARow] as TCellFormat).UnderLine
             then CV.Font.Style:=CV.Font.Style + [fsUnderLine]
             else CV.Font.Style:=CV.Font.Style - [fsUnderLine];

           TempRect.Top:=R.Top+trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetTop*kfy);
           TempRect.Left:=R.Left+OffTxtX+trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetLeft*kfx);
           TempRect.Right:=R.Right-trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetRight*kfx);
           TempRect.Bottom:=R.Bottom;
         end else begin
           flag:=DT_LEFT or DT_WORDBREAK;
           CV.Font.Color := gr.Font.Color;
           CV.Font.Name  := gr.Font.Name;
           CV.Font.Size  := gr.Font.Size;
           CV.Font.Style := gr.Font.Style;

           TempRect.Top:=R.Top+trunc(3*kfy);
           TempRect.Left:=R.Left+trunc(3*kfx);
           TempRect.Right:=R.Right-trunc(3*kfx);
           TempRect.Bottom:=R.Bottom;
         end;
         if RotateText then begin
           h1:=CellRotateTextOut(CV, Temprect,s,(gr.Objects[ACol,ARow] as TCellFormat).Degrees);
         end else H1 := DrawText(CV.Handle,PChar(s),length(s),temprect,flag);// + trunc(3*kfy);
     end;

     //if H1 > gr.RowHeights[ARow] then gr.RowHeights[ARow] := H1;

     if (gr.Objects[ACol,ARow] as TCellFormat)<> nil then begin
       if (gr.Objects[ACol,ARow] as TCellFormat).Bitmap<>nil then begin
         if (gr.Objects[ACol,ARow] as TCellFormat).Stretch then begin
           imgrect.Right:=R.Right-trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetImageX*kfx);
           imgrect.Bottom:=r.Bottom-trunc((gr.Objects[ACol,ARow] as TCellFormat).OffsetImageY*kfy);
         end;
         CV.StretchDraw(imgrect,(gr.Objects[ACol,ARow] as TCellFormat).Bitmap);
       end;
     end;

     lst.Clear;
    finally lst.Free;
    end;
    result := h1 + dlt;
end;

function setrowsheight(gr : tstringgrid; ip : integer) : integer;
var i,j,h,h1 : integer;
    temp : tbitmap;
    st : TGridDrawState;
begin
   temp:=tbitmap.Create;
   try
     //temp.Height:=gr.RowHeights[ip];
     temp.Height:=gr.DefaultRowHeight;
     for j:=0 to gr.ColCount-1 do begin
       temp.Width:=gr.ColWidths[j];
       h1 := DrawGridCell(temp.Canvas,1,1,1,1,gr,j,ip);
       if h1 > gr.RowHeights[ip] then gr.RowHeights[ip]:=h1;
     end;
   finally temp.Free;
   end;
   result:=gr.RowHeights[ip]
end;

function NewParagraph : string;
var s : string;
begin
  result:='<Paragraph>''</Paragraph>';
end;

function selectvalue(txt, param : string) : string;
var ps1, ps2, lng : integer;
    s, zn, snm, enm : string;
begin
  result:='';
  s:=ansilowercase(txt);
  snm := '<' + trim(ansilowercase(param)) + '>';
  enm := '</' + trim(ansilowercase(param)) + '>';
  ps1:=pos(snm,s);
  ps2:=pos(enm,s);
  if (ps1<>0) and (ps2<>0) and (ps1<ps2) then begin
    ps1:=ps1+length(snm);
    result:=copy(txt,ps1,ps2-ps1);
  end;
end;

function selectparagraphs(txt, param : string) : string;//TParagraph;
var ps1, ps2, lng : integer;
    s, zn, snm, enm : string;
begin
  result:='';
  s:=ansilowercase(txt);
  snm := '<' + trim(ansilowercase(param)) + '>';
  enm := '</' + trim(ansilowercase(param)) + '>';
  ps1:=pos(snm,s);
  ps2:=pos(enm,s);
  if (ps1<>0) and (ps2<>0) and (ps1<ps2) then begin
    ps2:=ps2+length(enm);
    result:=copy(txt,ps1,ps2-ps1);
  end;
end;

function GetCellString(prgf, param, defvol : string) : string;
var ts, prm : string;
begin
  prm := trim(ansilowercase(param));
  ts := selectvalue(prgf,param);
  if ts<>'' then result:=ts else result:=defvol;
end;

function GetCellInteger(prgf, param : string; defvol : integer) : integer;
var ts, prm : string;

begin
  result := defvol;
  prm := trim(ansilowercase(param));
  ts := selectvalue(prgf,param);
  if trim(ts)<>'' then result:=strtoint(ts);
end;

function findfirstword(str : string) : string;
var i:integer;
    ps1, ps2 : integer;
begin
  ps1:=pos('<',str);
  ps2:=pos('>',str);
  result:=copy(str,ps1+1,ps2-ps1-1);
end;

procedure SetCellString(var prgf : string; Const param, defvol : string);
var ps1, ps2, lng : integer;
    ends, s, ts, zn, snm, enm, spred, snext : string;
begin
  s:=findfirstword(prgf);
  ends := '</' + s + '>';
  zn := defvol;
  snm := '<' + trim(param) + '>';
  enm := '</' + trim(param) + '>';
  ps1:=pos(ansilowercase(snm),ansilowercase(prgf));
  ps2:=pos(ansilowercase(enm),ansilowercase(prgf));
  if (ps1<>0) and (ps2<>0) and (ps1<ps2) then begin
    delete(prgf,ps1,ps2+length(enm)-ps1);
  end else begin
     if ps1<>0 then delete(prgf,ps1,length(snm));
     if ps2<>0 then delete(prgf,ps2,length(enm));
  end;
  ps1:=pos(ansilowercase(ends),ansilowercase(prgf));
  delete(prgf,ps1,length(ends));
  prgf:=prgf+snm+zn+enm+ends;
end;

procedure SetCellInteger(var prgf : string; Const param : string; defvol : integer);
var ps1, ps2, lng : integer;
    ends, s, ts, zn, snm, enm, spred, snext : string;
begin
  s:=findfirstword(prgf);
  ends := '</' + s + '>';
  zn:=inttostr(defvol);
  snm := '<' + trim(param) + '>';
  enm := '</' + trim(param) + '>';
  ps1:=pos(ansilowercase(snm),ansilowercase(prgf));
  ps2:=pos(ansilowercase(enm),ansilowercase(prgf));
  if (ps1<>0) and (ps2<>0) and (ps1<ps2) then begin
    delete(prgf,ps1,ps2+length(enm)-ps1);
  end else begin
     if ps1<>0 then delete(prgf,ps1,length(snm));
     if ps2<>0 then delete(prgf,ps2,length(enm));
  end;
  ps1:=pos(ansilowercase(ends),ansilowercase(prgf));
  delete(prgf,ps1,length(ends));
  prgf:=prgf+snm+zn+enm+ends;
end;

function ListParagraphs(txt : string) : TStrings;
var i, ps1, ps2 : integer;
    zn, s, sl, s1, s2 : string;
    lst : tstrings;
begin
  lst := tstringlist.Create;
  lst.Clear;
  s := txt;
  zn := selectparagraphs(s,'Paragraph');
  //s := trim(Copy(s,length(zn)+23,length(s)));
  while trim(zn)<>'' do begin
      lst.Add(zn);
      //s := trim(Copy(s,length(zn),length(s)));
      delete(s,pos(zn,s),length(zn));
      zn:=selectparagraphs(s,'Paragraph');
  end;
  result:=lst;
end;

function chr16toint(ch : char) : byte;
begin
   result:=0;
      case ch of
  '0'..'9': result:=strtoint(ch);
  'a','A' : result:=10;
  'b','B' : result:=11;
  'c','C' : result:=12;
  'd','D' : result:=13;
  'e','E' : result:=14;
  'f','F' : result:=15;
     end;
end;

function hextoint(str : string) : longint;
var i, d, r : longint;
begin
  r:=0;
  for i:=1 to length(str) do begin
    d:=chr16toint(str[i]);
    r:=r * 16 + d;
  end;
  result:=r;
end;

end.
