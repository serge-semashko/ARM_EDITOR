unit UCommon;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

Type
  TREGBTNRect = Record
    Left,Top,Right,Bottom : integer;
  end;

  TCNTBTN = Record
    Visible            : Boolean;
    Down               : Boolean;
    X, Y, Width, Heigh : integer;
    BitmapUp           : TBitmap;
    BitmapDown         : TBitmap;
  end;

  TMTXButtons = record
    BCNT         : integer;         //Количество кнопок
    FCNT         : integer;         //Количество функц. кнопок
    NameForm     : string;          //Название формы
    CNTX         : integer;         //Кол-во кнопок по горизонтали
    CNTY         : integer;         //Кол-во кнопок по вертикали
    CNTFX        : integer;         //Кол-во функц. кнопок по горизонтали
    CNTFY        : integer;         //Кол-во функц. кнопок по вертикали
    BTNW         : integer;         //Размер кнопки по горизонтали
    BTNH         : integer;         //Размер кнопки по вертикали
    BTNTTLH      : integer;         //Высота области заголовка кнопки
    TYPEBTN      : boolean;         //false - без заголовка, true - с заголовком
    BTNRECT      : TREGBTNRect;     //границы области кнопок
    FNCRECT      : TREGBTNRect;     //границы области функц. кнопок
    CNTRECT      : TREGBTNRect;     //границы области управляющих кнопок
    CLBTN        : TColor;          //Основной цвет кнопки
    CLFBTN       : TColor;          //Основной цвет кнопки
    CLBTNDOWN    : TColor;          //Цвет нажатой кнопки
    CLBTNSEL     : TColor;          //Цвет выбранной кнопку
    CLBTNSET     : TColor;          //Цвет установленной кнопки
    CLBTNLOC     : TColor;          //Цвет залоченной кнопки
    CLTITLE      : TColor;          //Основной цвет шрифта зоголовка
    CLNAME       : TColor;          //Цвет шрифта кнопки
    CBTN1        : TCNTBTN;         //Кнопка управления 1
    CBTN2        : TCNTBTN;         //Кнопка управления 2
    CBTN3        : TCNTBTN;         //Кнопка управления 3
    CBTN4        : TCNTBTN;         //Кнопка управления 4
    CBTN5        : TCNTBTN;         //Кнопка управления 5
    Logotip      : TBitmap;         //Рисунок логотипа
    LogoVisible  : boolean;         //Oтображать или нет логотип
    MTXPins      : array of integer;//Список соответсвия кнопок и входов/выходов матрицы
    BTNNames1    : array of string; //Список названий отображаемых в верхней части кнопки
    BTNNames2    : array of string; //Список названий отображаемых в нижней/средней части кнопки
    BTNTitles    : array of string; //Список заголовков кнопк
    BTNSelects   : array of boolean;//Список выбранных кнопок
    BTNEnables   : array of boolean;//Список доступных кнопок
    BTNLockeds   : array of boolean;//Залочена или нет кнопка
    FBTNNames1   : array of string; //Список названий отображаемых в верхней части функц. кнопки
    FBTNNames2   : array of string; //Список названий отображаемых в нижней/средней части функц. кнопки
    FBTNTitles   : array of string; //Список заголовков кнопк
    FBTNSelects  : array of boolean;//Список выбранных функциональных кнопк;
    GroupSelect  : boolean;         //Разрешен групповой выбор кнопок
    frmLeft      : integer;         //Отступ слева
    frmTop       : integer;         //Отступ сверху
    frmRight     : integer;         //Отступ справа
    frmBottom    : integer;         //Отступ снизу
    frmBTNFUNC   : integer;         //Отступ функц. кнопок
    //FontName     : TFontName;       //Шрифт который используется для надписей
    FSizeTitle   : integer;         //Размер шрифта заголовка
    FSizeNames1  : integer;         //Размер шрифта верхней надписи
    FSizeNames2  : integer;         //Размер шрифта нижней надписи
    FSizeMiddle  : integer;         //Размер шрифта средней надписи
    CurrBTN      : integer;         //Текущая выбранная клавиша
  end;

Var
  BTNW : integer = 45;
  BTNH : integer = 45;
  Color_Step : integer = 45;
  TITLEHEIGH : integer = 0;
  //DEFAULTBUTTONS : TMTXButtons;
  BTNINPUTS : TMTXButtons;
  BTNOUTPUTS : TMTXButtons;
  OUTHANDLE, INHANDLE : Cardinal;
  ips : integer;
//  OUTSet     : integer = -1;
//  INSet      : integer = -1;
  OUTSelect  : integer = -1;
  INSelect   : integer = -1;

procedure DrawGradient(ACanvas: TCanvas; Rect: TRect;
                       Horicontal: Boolean; Color : TColor);
//Function MTXButtonDraw(cv : tcanvas; nom : integer; BTN : TMTXButtons; downup, func : boolean ) : TPoint;
Function MTXButtonDraw(cv : tcanvas; nom : integer; BTN : TMTXButtons; btncolor : tcolor; func : boolean ) : TPoint;
procedure BKGND_Form(FRM : TForm; img : timage; VAR BTN : TMTXButtons);
Procedure RegionMTXButtons(cv : tcanvas; VAR BTN : TMTXButtons);
Procedure RegionFUNCButtons(cv : tcanvas; VAR BTN : TMTXButtons);
function ButtonInRect(X,Y : integer;  typerect : integer; var BTN : TMTXButtons) : integer;
procedure InitMTXButtons(var btn : TMTXButtons);
Procedure ToDisplayMTXButtons(cv : tcanvas; var btn : TMTXButtons);
function DownColor(clr : tcolor; Color_Step : integer) : tcolor;

implementation

procedure DrawGradient(ACanvas: TCanvas; Rect: TRect;
                       Horicontal: Boolean; Color : TColor);
 type
   RGBArray = array[0..2] of Byte;
 var
   cr, cg, cb : byte;
   i, x, y, z, stelle, mx, bis, faColorsh, mass: Integer;
   Faktor: double;
   A: RGBArray;
   B: array of RGBArray;
   merkw: integer;
   merks: TPenStyle;
   merkp: TColor;
   Colors : array of TColor;
 begin
   cr := GetRValue(Color);
   cg := GetGValue(Color);
   cb := GetBValue(Color);
   SetLength(Colors,10);
   Colors[4]:=Color;
   Colors[5]:=Color;

   for i := 0 to 3 do begin
     if cr>Color_Step then cr:=cr-Color_Step else cr:=0;
     if cg>Color_Step then cg:=cg-Color_Step else cg:=0;
     if cb>Color_Step then cb:=cb-Color_Step else cb:=0;
     Colors[3-i]:= cr + (cg * 256) + (cb * 65536);
     Colors[6+i]:= cr + (cg * 256) + (cb * 65536);
   end;

   mx := High(Colors);
   if mx > 0 then
   begin
     if Horicontal then
       mass := Rect.Right - Rect.Left
     else
       mass := Rect.Bottom - Rect.Top;
     SetLength(b, mx + 1);
     for x := 0 to mx do
     begin
       Colors[x] := ColorToRGB(Colors[x]);
       b[x][0] := GetRValue(Colors[x]);
       b[x][1] := GetGValue(Colors[x]);
       b[x][2] := GetBValue(Colors[x]);
     end;
     merkw := ACanvas.Pen.Width;
     merks := ACanvas.Pen.Style;
     merkp := ACanvas.Pen.Color;
     ACanvas.Pen.Width := 1;
     ACanvas.Pen.Style := psSolid;
     faColorsh := Round(mass / mx);
     for y := 0 to mx - 1 do
     begin
       if y = mx - 1 then
         bis := mass - y * faColorsh - 1
       else
         bis := faColorsh;
       for x := 0 to bis do
       begin
         Stelle := x + y * faColorsh;
         faktor := x / bis;
         for z := 0 to 3 do
           a[z] := Trunc(b[y][z] + ((b[y + 1][z] - b[y][z]) * Faktor));
         ACanvas.Pen.Color := RGB(a[0], a[1], a[2]);
         if Horicontal then
         begin
           ACanvas.MoveTo(Rect.Left + Stelle, Rect.Top);
           ACanvas.LineTo(Rect.Left + Stelle, Rect.Bottom);
         end
         else
         begin
           ACanvas.MoveTo(Rect.Left, Rect.Top + Stelle);
           ACanvas.LineTo(Rect.Right, Rect.Top + Stelle);
         end;
       end;
     end;
     b := nil;
     ACanvas.Pen.Width := merkw;
     ACanvas.Pen.Style := merks;
     ACanvas.Pen.Color := merkp;
   end
   else
     // Please specify at least two colors
    raise EMathError.Create('Es mussen mindestens zwei Farben angegeben werden.');
 end;

function DownColor(clr : tcolor; Color_Step : integer) : tcolor;
var cr, cg, cb : byte;
begin
   cr := GetRValue(clr);
   cg := GetGValue(Clr);
   cb := GetBValue(Clr);
   if cr>Color_Step then cr:=cr-Color_Step else cr:=0;
   if cg>Color_Step then cg:=cg-Color_Step else cg:=0;
   if cb>Color_Step then cb:=cb-Color_Step else cb:=0;
   result:= cr + (cg * 256) + (cb * 65536);
end;

Procedure cvDrawText3D(cv : tcanvas; x, y : integer; txt : string; clr : tcolor);
begin
  cv.Font.Color:=clWhite;
  cv.TextOut(x-1, y-1, txt);
  cv.Font.Color:=clr;
  cv.TextOut(x, y, txt);
end;

Function MTXButtonDraw(cv : tcanvas; nom : integer; BTN : TMTXButtons; btncolor : tcolor; func : boolean ) : TPoint;
var bmp : tbitmap;
    fw, fh : integer;
    str, stemp, sbtnttl, sbtnnm1, sbtnnm2 : string;
    bltemp : boolean;
    CNTX, psx, psy, lft, top : integer;
    //btncolor : tcolor;
begin
  if func then begin
    sbtnttl:=BTN.FBTNTitles[nom-1];
    sbtnnm1:=BTN.FBTNNames1[nom-1];
    sbtnnm2:=BTN.FBTNNames2[nom-1];
    //btncolor:=BTN.CLFBTN;
  end else begin
    sbtnttl:=BTN.BTNTitles[nom-1];
    sbtnnm1:=BTN.BTNNames1[nom-1];
    sbtnnm2:=BTN.BTNNames2[nom-1];
    //btncolor:=BTN.CLFBTN;
  end;
//  if func then btncolor:=BTN.CLFBTN
//  else if BTN.BTNLocked[nom-1] then btncolor:=BTN.CLBTNLOC
//  else btncolor:=BTN.CLBTN;;

  bmp:=tbitmap.Create;
  try
  bmp.Width:=BTN.BTNW;
  bmp.Height:=BTN.BTNH + BTN.BTNTTLH;

  bmp.Canvas.Brush.Color:=clSilver;
  bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
  bmp.Canvas.Font.Size:=BTN.FSizeTitle;
  bmp.Canvas.Font.Color:=clBlack;

  bmp.Canvas.Brush.Style:=bsClear;
  if BTN.TYPEBTN then begin
    fw:=bmp.Canvas.TextWidth(sbtnttl);
    cvDrawText3D(bmp.Canvas,BTN.BTNW div 2 - fw div 2 + 1, 4, sbtnttl,BTN.CLTITLE);
  end;

//  if downup then begin
  if btncolor<>BTN.CLBTNDOWN then begin
    bmp.Canvas.Brush.Color:=clBlack;
    bmp.Canvas.FillRect(Rect(4,BTN.BTNTTLH + 4,BTN.BTNW-1,BTN.BTNH + BTN.BTNTTLH-1));
    DrawGradient(bmp.Canvas, Rect(2,BTN.BTNTTLH + 2,BTN.BTNW-4,BTN.BTNH + BTN.BTNTTLH -4), false, btncolor);
  end else begin
    DrawGradient(bmp.Canvas, Rect(2,BTN.BTNTTLH + 2,BTN.BTNW-1,BTN.BTNH + BTN.BTNTTLH -1), true, BTN.CLBTNDOWN);
  end;
    bmp.Canvas.Brush.Style:=bsClear;

    if (sbtnnm1='') or (sbtnnm2='') then begin
      bmp.Canvas.Font.Size:=BTN.FSizeMiddle;
      str:=sbtnnm1;
      if str='' then str:=sbtnnm2;
      fw:=bmp.Canvas.TextWidth(str);
      fh:=bmp.Canvas.TextHeight(str);
      cvDrawText3D(bmp.Canvas,(BTN.BTNW-6) div 2 - fw div 2 + 3,
                 BTN.BTNTTLH +(BTN.BTNH div 2 - fh div 2), str,BTN.CLNAME);
    end else begin ;
      bmp.Canvas.Font.Size:=BTN.FSizeNames1;
      fw:=bmp.Canvas.TextWidth(sbtnnm1);
      fh:=bmp.Canvas.TextHeight(sbtnnm1);
      cvDrawText3D(bmp.Canvas,(BTN.BTNW-6) div 2 - fw div 2 + 3,
                             BTN.BTNTTLH +(BTN.BTNH div 4 - fh div 2 + 1), sbtnnm1,BTN.CLNAME);
      bmp.Canvas.Font.Size:=BTN.FSizeNames2;
      fw:=bmp.Canvas.TextWidth(sbtnnm2);
      fh:=bmp.Canvas.TextHeight(sbtnnm2);
      cvDrawText3D(bmp.Canvas,(BTN.BTNW-6) div 2 - fw div 2 + 3,
                             BTN.BTNTTLH +(BTN.BTNH div 4 * 3 - fh div 2 - 1), sbtnnm2,BTN.CLNAME);
    end;
//  end else begin
//    DrawGradient(bmp.Canvas, Rect(2,BTN.BTNTTLH + 2,BTN.BTNW-1,BTN.BTNH + BTN.BTNTTLH -1), true, BTN.CLBTNDOWN);
//    bmp.Canvas.Brush.Style:=bsClear;
//    if (sbtnnm1='') or (sbtnnm2='') then begin
//      bmp.Canvas.Font.Size:=BTN.FSizeMiddle;
//      str:=sbtnnm1;
//      if str='' then str:=sbtnnm2;
//      fw:=bmp.Canvas.TextWidth(str);
//      fh:=bmp.Canvas.TextHeight(str);
//      cvDrawText3D(bmp.Canvas,(BTN.BTNW-6) div 2 - fw div 2 + 3,
//                 BTN.BTNTTLH +(BTN.BTNH div 2 - fh div 2), str,clBlack);
//    end else begin ;
//      bmp.Canvas.Font.Size:=BTN.FSizeNames1;
//      fw:=bmp.Canvas.TextWidth(sbtnnm1);
//      fh:=bmp.Canvas.TextHeight(sbtnnm1);
//      cvDrawText3D(bmp.Canvas,(BTN.BTNW-6) div 2 - fw div 2 + 3,
//                             BTN.BTNTTLH +(BTN.BTNH div 4 - fh div 2 + 1), sbtnnm1,clBlack);
//      bmp.Canvas.Font.Size:=BTN.FSizeNames2;
//      fw:=bmp.Canvas.TextWidth(sbtnnm2);
//      fh:=bmp.Canvas.TextHeight(sbtnnm2);
//      cvDrawText3D(bmp.Canvas,(BTN.BTNW-6) div 2 - fw div 2 + 3,
//                            BTN.BTNTTLH +(BTN.BTNH div 4 * 3 - fh div 2 - 1), sbtnnm2, clBlack);
//    end;
//  end;
  bmp.TransparentColor:=clSilver;
  bmp.Transparent:=true;
  bmp.Canvas.Brush.Style:=bsClear;
  cv.Brush.Style:=bsClear;
  if func then begin
    lft:=BTN.FNCRECT.Left;
    top:=BTN.FNCRECT.Top;
    CNTX:=BTN.CNTFX;
  end else begin
    lft:=BTN.BTNRECT.Left;
    top:=BTN.BTNRECT.Top;
    CNTX:=BTN.CNTX;
  end;

  psx:=nom mod CNTX;
  psy:=nom div CNTX;
  if psx=0 then begin
    psx:=CNTX-1;
    psy:=psy-1;
  end else psx:=psx-1;

  cv.Draw(lft+psx*bmp.Width,top+psy*bmp.Height,bmp);
  result.X:=lft + psx * bmp.Width + bmp.Width;
  result.Y:=top + psy * bmp.Height + bmp.Height;
  finally bmp.free
  end;
end;

procedure BKGND_Form(FRM : TForm; img : timage; VAR BTN : TMTXButtons);
var ttlh : integer;
begin
//Определяем размер формы
  FRM.Width:=(BTN.CNTX + BTN.CNTFX) * BTN.BTNW + BTN.frmLeft + BTN.frmBTNFUNC + BTN.frmRight;
  if BTN.TYPEBTN then begin
    img.Canvas.Font.Size:=BTN.FSizeTitle;
    BTN.BTNTTLH:=img.Canvas.TextHeight('0') + 4;
  end else BTN.BTNTTLH:=0;
  FRM.Height:=(BTN.CNTY * (BTN.BTNTTLH + BTN.BTNH))  + BTN.frmTop + BTN.frmBottom;
  img.Picture.Bitmap.Width:=FRM.Width;
  img.Picture.Bitmap.Height:=FRM.Height;
//Рисуем Градиент на форме
  DrawGradient(img.Canvas, img.Canvas.ClipRect, true, clWhite);
//Рисуем рамку формы
  img.Canvas.Brush.Style:=bsClear;
  img.Canvas.Pen.Width:=4;
  img.Canvas.Pen.Color:=$00444444;
  img.Canvas.Rectangle(2,2,img.Width-2,img.Height-2);
  img.Canvas.Font.Style:=img.Canvas.Font.Style;// + [fsBold];
  img.Canvas.Pen.Width:=3;
  img.Canvas.Pen.Color:=clGray;
  img.Canvas.MoveTo(5,5);
  img.Canvas.LineTo(img.Width-7,5);
  img.Canvas.MoveTo(5,5);
  img.Canvas.LineTo(5,img.Height-7);
  img.Canvas.Pen.Color:=clLTGray;
  img.Canvas.MoveTo(7,img.Height-7);
  img.Canvas.LineTo(img.Width-7,img.Height-7);
  img.Canvas.MoveTo(img.Width-7,7);
  img.Canvas.LineTo(img.Width-7,img.Height-7);
//Рисуем название формы
  img.Canvas.Pen.Width:=1;
  img.Canvas.Brush.Style:=bsClear;
  img.Canvas.Font.Size:=14;
  img.Canvas.Font.Color:=clWhite;
  img.Canvas.TextOut(48,9,BTN.NameForm);
  img.Canvas.Font.Color:=$00444444;
  img.Canvas.TextOut(50,10,BTN.NameForm);
end;

Procedure RegionMTXButtons(cv : tcanvas; VAR BTN : TMTXButtons);
var i : integer;
    xy : tpoint;
begin
    BTN.BTNRECT.Left:=BTN.frmLeft;
    BTN.BTNRECT.Top:=BTN.frmTop;
    for i:=0 to BTN.BCNT-1 do xy:=MTXButtonDraw(cv,i+1,BTN,BTN.CLBTN,false);
    BTN.BTNRECT.Right:=xy.X;
    BTN.BTNRECT.Bottom:=xy.Y;
end;

Procedure RegionFUNCButtons(cv : tcanvas; VAR BTN : TMTXButtons);
var i : integer;
    xy : tpoint;
begin
    BTN.FNCRECT.Left:=BTN.BTNRECT.Right + BTN.frmBTNFUNC;
    BTN.FNCRECT.Top:=BTN.frmTop;
    for i:=0 to BTN.FCNT-1 do xy:=MTXButtonDraw(cv,i+1,BTN,BTN.CLFBTN, True);
    BTN.FNCRECT.Right:=xy.X;
    BTN.FNCRECT.Bottom:=xy.Y;
end;

function ButtonInRect(X,Y : integer; typerect : integer; Var BTN : TMTXButtons) : integer;
var lft,top,rght,bttm : integer;
    cntx, cnty, btnw, btnh, btnttl : integer;
    CX, CY, nom, psx, psy : integer;
begin
  result:=-1;
  case typerect of
 0: begin
      cntx:=BTN.CNTX;
      cnty:=BTN.CNTY;
      btnw:=BTN.BTNW;
      btnh:=BTN.BTNH;
      if BTN.TYPEBTN then btnttl:=BTN.BTNTTLH else btnttl:=0;
      CX:=X-BTN.BTNRECT.Left;
      CY:=Y-BTN.BTNRECT.Top;
      lft:=0;
      top:=0;
      rght:=BTN.BTNRECT.Right-BTN.BTNRECT.Left;
      bttm:=BTN.BTNRECT.Bottom-BTN.BTNRECT.Top;
    end;
 1: begin
      cntx:=BTN.CNTFX;
      cnty:=BTN.CNTFY;
      btnw:=BTN.BTNW;
      btnh:=BTN.BTNH;
      if BTN.TYPEBTN then btnttl:=BTN.BTNTTLH else btnttl:=0;
      CX:=X-BTN.FNCRECT.Left;
      CY:=Y-BTN.FNCRECT.Top;
      lft:=0;
      top:=0;
      rght:=BTN.FNCRECT.Right-BTN.FNCRECT.Left;
      bttm:=BTN.FNCRECT.Bottom-BTN.FNCRECT.Top;
    end;
 2: begin
      cntx:=5;
      cnty:=1;
      btnw:=BTN.CBTN1.Width;
      btnh:=BTN.CBTN1.Heigh;
      btnttl:=0;
      CX:=X-BTN.CNTRECT.Left;
      CY:=Y-BTN.CNTRECT.Top;
      lft:=0;
      top:=0;
      rght:=BTN.CNTRECT.Right-BTN.CNTRECT.Left;
      bttm:=BTN.CNTRECT.Bottom-BTN.CNTRECT.Top;
    end;
  end;
  if (CX<=0) or (CY<=0) then exit;
  
  if ((CX >lft) and (CX<rght)) and ((CY>top) and (CY<bttm)) then begin
     psx:=CX div btnw;
     psy:=CY div (btnh + btnttl);
     nom:=psy * cntx + psx+1;
     result:=nom;
  end;
end;

Procedure ToDisplayMTXButtons(cv : tcanvas; var btn : TMTXButtons);
var i : integer;
begin
  for i:=0 to BTN.BCNT-1 do begin
    if BTN.BTNSelects[i]
      then MTXButtonDraw(cv,i+1,BTN,BTN.CLBTNSEL,false)
      else MTXButtonDraw(cv,i+1,BTN,BTN.CLBTN,false);
  end;
  for i:=0 to BTN.FCNT-1 do begin
    if BTN.FBTNSelects[i]
      then MTXButtonDraw(cv,i+1,BTN,BTN.CLFBTN,true);
  end;
  if BTN.CurrBTN<>-1 then MTXButtonDraw(cv,BTN.CurrBTN,BTN,BTN.CLBTNSET,false);
  
end;

procedure InitMTXButtons(var btn : TMTXButtons);
begin
  BTN.BCNT:=32;
  BTN.FCNT:=2;
  BTN.NameForm :='';
  BTN.CNTX:=16;
  BTN.CNTY:=2;
  BTN.CNTFX:=1;
  BTN.CNTFY:=2;
  BTN.BTNW:=45;
  BTN.BTNH:=45;
  BTN.BTNTTLH:=0;
  BTN.TYPEBTN:=false;
  BTN.BTNRECT.Left:=0;
  BTN.BTNRECT.Top:=0;
  BTN.BTNRECT.Right:=0;
  BTN.BTNRECT.Bottom:=0;
  BTN.FNCRECT.Left:=0;
  BTN.FNCRECT.Top:=0;
  BTN.FNCRECT.Right:=0;
  BTN.FNCRECT.Bottom:=0;
  BTN.CNTRECT.Left:=0;
  BTN.CNTRECT.Top:=0;
  BTN.CNTRECT.Right:=0;
  BTN.CNTRECT.Bottom:=0;

  BTN.CLBTN:=clLime;
  BTN.CLFBTN:=clYellow;
  BTN.CLBTNDOWN:=clWhite;
  BTN.CLBTNSEL:=clYellow; //$000066ff;
  BTN.CLBTNSET:=clYellow;
  BTN.CLBTNLOC:=clAqua;
  BTN.CLTITLE:=$00802000;
  BTN.CLNAME:=clBlack;

  BTN.CBTN1.Visible:=false;
  BTN.CBTN1.Down:=false;
  BTN.CBTN1.X:=0;
  BTN.CBTN1.Y:=0;
  BTN.CBTN1.Width:=20;
  BTN.CBTN1.Heigh:=20;
  BTN.CBTN1.BitmapUp:=nil;
  BTN.CBTN1.BitmapDown:=nil;

  BTN.CBTN2.Visible:=false;
  BTN.CBTN2.Down:=false;
  BTN.CBTN2.X:=0;
  BTN.CBTN2.Y:=0;
  BTN.CBTN2.Width:=20;
  BTN.CBTN2.Heigh:=20;
  BTN.CBTN2.BitmapUp:=nil;
  BTN.CBTN2.BitmapDown:=nil;

  BTN.CBTN3.Visible:=false;
  BTN.CBTN3.Down:=false;
  BTN.CBTN3.X:=0;
  BTN.CBTN3.Y:=0;
  BTN.CBTN3.Width:=20;
  BTN.CBTN3.Heigh:=20;
  BTN.CBTN3.BitmapUp:=nil;
  BTN.CBTN3.BitmapDown:=nil;

  BTN.CBTN4.Visible:=false;
  BTN.CBTN4.Down:=false;
  BTN.CBTN4.X:=0;
  BTN.CBTN4.Y:=0;
  BTN.CBTN4.Width:=20;
  BTN.CBTN4.Heigh:=20;
  BTN.CBTN4.BitmapUp:=nil;
  BTN.CBTN4.BitmapDown:=nil;

  BTN.CBTN5.Visible:=false;
  BTN.CBTN5.Down:=false;
  BTN.CBTN5.X:=0;
  BTN.CBTN5.Y:=0;
  BTN.CBTN5.Width:=20;
  BTN.CBTN5.Heigh:=20;
  BTN.CBTN5.BitmapUp:=nil;
  BTN.CBTN5.BitmapDown:=nil;

  BTN.Logotip:=nil;
  BTN.LogoVisible:=false;

  SetLength(BTN.MTXPins,BTN.BCNT);
  for ips := 0 to BTN.BCNT - 1 do BTN.MTXPins[ips]:=ips+1;

  SetLength(BTN.BTNNames1,BTN.BCNT);
  for ips := 0 to BTN.BCNT - 1 do BTN.BTNNames1[ips]:='0';

  SetLength(BTN.BTNNames2,BTN.BCNT);
  for ips := 0 to BTN.BCNT - 1 do BTN.BTNNames2[ips]:='In-0';

  SetLength(BTN.BTNTitles,BTN.BCNT);
  for ips := 0 to BTN.BCNT - 1 do BTN.BTNTitles[ips]:='';

  SetLength(BTN.BTNLockeds,BTN.BCNT);
  for ips := 0 to BTN.BCNT - 1 do BTN.BTNLockeds[ips]:=false;

  SetLength(BTN.BTNSelects,BTN.BCNT);
  for ips := 0 to BTN.BCNT - 1 do BTN.BTNSelects[ips]:=false;

  SetLength(BTN.BTNEnables,BTN.BCNT);
  for ips := 0 to BTN.BCNT - 1 do BTN.BTNEnables[ips]:=false;

  SetLength(BTN.FBTNNames1,BTN.FCNT);
  for ips := 0 to BTN.FCNT - 1 do BTN.FBTNNames1[ips]:='';

  SetLength(BTN.FBTNNames2,BTN.FCNT);
  for ips := 0 to BTN.FCNT - 1 do BTN.FBTNNames2[ips]:='';

  SetLength(BTN.FBTNTitles,BTN.FCNT);
  for ips := 0 to BTN.FCNT - 1 do BTN.FBTNTitles[ips]:='';

  SetLength(BTN.FBTNSelects,BTN.FCNT);
  for ips := 0 to BTN.FCNT - 1 do BTN.FBTNSelects[ips]:=false;

  BTN.frmLeft:=10;
  BTN.frmTop:=35;
  BTN.frmRight:=10;
  BTN.frmBottom:=15;
  BTN.frmBTNFUNC:=10;

  BTN.FSizeTitle:=9;
  BTN.FSizeNames1:=9;
  BTN.FSizeNames2:=8;
  BTN.FSizeMiddle:=10;

  BTN.CurrBTN := -1;
end;

Initialization
Finalization

end.
