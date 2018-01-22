unit UIMGButtons;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid;

Const
  MaxRows = 16;
  MaxCols = 16;

Type

  TButtonImage = (im123,imaddsong,imbook,imcut,imcopy,impaste1,impaste2,imdel,imdown,
                  imprint,imshift,imtrash,imtrim,imundo,imup,imuser,imnone);
  TImagePosition = (psLeft,psRight,psCenter);
  //TPosition = (psLeft,psRight,psCenter);

  TImgButton = Class(TObject)
    public
    Tag : integer;
    Row : integer;
    Image : TBitmap;
    ImagePosition : TImagePosition;
    Alignment : TImagePosition;
    Hint  : string;
    HintShow : boolean;
    Name :  string;
    Location : trect;
    Font : Tfont;
    FontHint : Tfont;
    Color : tcolor;
    Width : integer;
    Visible : boolean;
    Enable : boolean;
    Selection : boolean;
    Height : integer;
    Radius : integer;
    WidthBorder : integer;
    ColorBorder : tcolor;
    BackGround : tcolor;
    Procedure LoadBMPFromRes(imtype : TButtonImage);
    Procedure DrawButton(cv : tcanvas);
    constructor Create;
    destructor  Destroy; override;
  end;

  TBTNSRow = Class(TObject)
    public
    Tag : integer;
    Count : integer;
    Left : integer;
    Right : integer;
    Interval : integer;
    Top : integer;
    Bottom : integer;
    BackGround : tcolor;
    AutoSize : boolean;
    //Btns : Array[0..7] of TImgButton;
    Btns : Array of TImgButton;
    Procedure DrawRows(cv : tcanvas);
    Function AddButton(Name : string; image : TButtonImage) : Integer;
    constructor Create;
    destructor  Destroy; override;

  end;

  TBTNSPanel = Class(TObject)
    private
     procedure DrawHint(cv : tcanvas; ARow, ABtn : integer);
    public
     Count : integer;
     Enable : boolean;
     Top : integer;
     Bottom : integer;
     Left : integer;
     Right : integer;
     Interval : integer;
     BackGround : tcolor;
     AutoSize : boolean; //Зарезервировано
     HeightRow : integer;
     //Rows : Array[0..7] of TBTNSRow;
     Rows : Array of TBTNSRow;
     procedure Draw(cv : tcanvas);
     procedure Unselection;
     procedure Clear;
     function ClickButton(cv : tcanvas; X, Y : integer) : integer;
     procedure MouseMove(cv : tcanvas; X, Y : integer);
     function AddRow : integer;
     constructor Create;
     destructor  Destroy; override;
  end;

Var
    btnsctlleft,
    btnsctlright,
    btnsdevice,
    btnsmediatl,
    btnstexttl,
    btnsdevicepr,
    pnlprojects,
    pnlprojcntl,
    pnlbtnsclips,
    pnlbtnspl,
    btnspanel1 : TBTNSPanel;
    RowTemp, BtnTemp : integer;


implementation
uses ucommon;

constructor  TImgButton.Create;
begin
  inherited;
  Tag := 0;
  Row := 0;
  Image := TBitmap.Create;
  ImagePosition := psLeft;
  Alignment := psCenter;
  Hint  := '';
  HintShow := false;
  Name :=  '';
  Width := 40;
  Height := 30;
  Radius := 25;
  Location.Left := 0 ;
  Location.Right := Width;
  Location.Top := 0;
  Location.Bottom := Height;
  Font := TFont.Create;
  Font.Name := ProgrammFontName;
  Font.Size := ProgrammFontSize;
  Font.Color := ProgrammFontColor;
  Font.Style := Font.Style + [fsBold];
  FontHint := TFont.Create;
  FontHint.Name := ProgrammFontName;
  FontHint.Size := ProgrammFontSize;
  FontHint.Color := SmoothColor(clBlack, 32);//ProgrammFontColor;
  //FontHint.Style := FontHint.Style + [fsBold];
  Color := ProgrammColor;
  Visible := true;
  Enable := true;
  Selection := false;
  WidthBorder := 1;
  ColorBorder := Font.Color;
  BackGround :=ProgrammColor;
end;

destructor TImgButton.Destroy;
begin
  FreeMem(@Tag);
  FreeMem(@Row);
  Image.Free;

  FreeMem(@ImagePosition);
  FreeMem(@Hint);
  FreeMem(@HintShow);
  FreeMem(@Name);
  FreeMem(@Width);
  FreeMem(@Height);
  FreeMem(@Radius);
  FreeMem(@Location);
  FreeMem(@Alignment);
  Font.Free;
  FontHint.Free;
  FreeMem(@Color);
  FreeMem(@Visible);
  FreeMem(@Enable);
  FreeMem(@Selection);
  FreeMem(@WidthBorder);
  FreeMem(@ColorBorder);
  FreeMem(@BackGround);
  inherited Destroy;
end;

procedure TImgButton.LoadBMPFromRes(imtype : TButtonImage);
begin
  Image.LoadFromResourceName(HInstance, 'Button' + inttostr(ord(imtype)+1));
  Image.Transparent:=true;
end;

function ImageRect(Rect : Trect; imp : TImagePosition) : Trect;
var X1,Y1,X2,Y2, EndImg, stp, dlt, wdth, delty, deltx : integer;
  bkgn, fnt, brd : tcolor;
  rt : trect;
begin
  wdth := Rect.Bottom-Rect.Top;
  delty:=(wdth div 5) div 2;
  wdth:=wdth - 2 * delty;

      case imp of
  psLeft   : deltx:=3*delty;
  psCenter : deltx:=(Rect.Right-Rect.Left-wdth) div 2;
  psRight  : deltx:=Rect.Right-3*delty-wdth;
      end;

  result.Left:=Rect.Left + deltx;
  result.Right:=Rect.Left + deltx + wdth;
  result.Top:=Rect.Top+delty;
  result.Bottom:=Rect.Bottom-delty;
end;

procedure TImgButton.DrawButton(cv : tcanvas);
var X1,Y1,X2,Y2, EndImg, stp, dlt, wdth, delty, deltx : integer;
  xhint, yhint : integer;
  bkgn, fnt, brd : tcolor;
  fntsz : integer;
  rt : trect;
  bmp : tbitmap;
  textrect : trect;
begin
  //Запоминаем параметры canvas
  bkgn := cv.Brush.Color;
  fnt := cv.Font.Color;
  brd := cv.Pen.Color;
  fntsz := cv.Font.Size;
  //Устанавливаем параметры canvas для кнопки
  cv.Brush.Color:=Color;
  cv.Font.Color:=Font.Color;
  cv.Font.Size:=Font.Size;
  cv.Font.Name:=Font.Name;
  cv.Font.Style:=Font.Style;
  cv.Pen.Color:=ColorBorder;
  cv.Pen.Width:=WidthBorder;
  //Параметры размещения кнопки
  X1:=Location.Left;
  Y1:=Location.Top;
  X2:=Location.Right;
  Y2:=Location.Bottom;
  //Если кнопка не отображается прячим ее и выходим
  if not Visible then begin
    cv.Brush.Color:=BackGround;
    cv.FillRect(Location);
    cv.Brush.Color:=bkgn;
    cv.Font.Color := fnt;
    cv.Pen.Color := brd;
    exit;
  end;
  //Если кнопка заблокирована установливаем требуемые параметры canvas
  if not Enable then begin
    cv.Brush.Color:=BackGround;
    cv.Pen.Color:=SmoothColor(cv.Pen.Color,128);
    cv.Font.Color:=SmoothColor(cv.Font.Color,128);
  end;
  //Если кнопка выбрана задаем её цвет для отрисовки
  If Selection then begin
    cv.Brush.Color:=SmoothColor(Color, 24);
    //cv.Pen.Color:=SmoothColor(cv.Pen.Color,);
    //cv.Font.Color:=SmoothColor(cv.Font.Color,128);
  end;
//------------------------------------------------------
  //Рисуем контур кнопки
  cv.RoundRect(X1,Y1,X2,Y2,Radius,Radius);

  stp := Location.Left;
  dlt := Location.Right - Location.Left;
  cv.Brush.Style:=bsClear;
  //Рисуем иконку кнопки если она задана
  if Image<>nil then begin
    rt := ImageRect(Location,ImagePosition);
    cv.StretchDraw(rt,Image);
    if ImagePosition=psRight then begin
      stp:=Location.Left;
      dlt:=rt.Left-Location.Left;
    end else begin
      stp:=rt.Right;
      dlt:=Location.Right - rt.Right ;
    end;
  end;

  if (dlt - 10) < cv.TextWidth(Name)
    then cv.Font.Size := DefineFontSizeW(cv, dlt -10, Name);
  if (dlt - 10) < cv.TextWidth(Name) then begin
    textrect.Left:=stp+5;
    textrect.Right:=stp + dlt - 10;
    textrect.Top:=Y1 + ((Height - cv.TextHeight(Name)) div 2);
    textrect.Bottom:=textrect.Top + cv.TextHeight(Name);
    bmp:=tbitmap.Create;
    bmp.Width:=cv.TextWidth(Name);
    bmp.Height:=cv.TextHeight(Name);
    bmp.Transparent:=true;
    bmp.Canvas.Font:=cv.Font;
    bmp.Canvas.Brush.Color:=cv.Brush.Color;
    //bmp.Canvas.Pen:=cv.Pen;
    bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
    //bmp.Canvas.Brush.Style:=bsClear;
    bmp.Canvas.TextOut(0,0,Name);
    //bmp.Canvas.TextRect(bmp.Canvas.ClipRect,0,0, Name);
    //cv.Brush.Style:=bsClear;
    //cv.CopyRect(textrect,bmp.Canvas,bmp.Canvas.ClipRect);
    cv.StretchDraw(textrect,bmp);
     bmp.Free;
    //cv.Font.Size:=DefineFontSizeW(cv, dlt, Name);
  end else begin
         case Alignment of
    psLeft   : cv.TextOut(stp + 4 ,Y1 + ((Height - cv.TextHeight(Name)) div 2),Name);
    psRight  : cv.TextOut(stp + 4 ,Y1 + ((Height - cv.TextHeight(Name)) div 2),Name);
    psCenter : cv.TextOut(stp + ((dlt - cv.TextWidth(Name)) div 2),Y1 + ((Height - cv.TextHeight(Name)) div 2),Name);
         end;
  end;
  //Востанавливаем параметры canvas
  cv.Brush.Style:=bsSolid;
  cv.Brush.Color:=bkgn;
  cv.Font.Color := fnt;
  cv.Pen.Color := brd;
  cv.Font.Size := fntsz;

end;

constructor TBTNSRow.Create;
var i : integer;
begin
  inherited;
  Tag:=0;
  Count:=0;
  Left:=10;
  Right:=10;
  Interval:=5;
  Top:=0;
  bottom:=30;
  BackGround :=ProgrammColor;
  AutoSize:=true;
 // For i:=0 to 7 do Btns[i]:=TImgButton.Create;
end;

destructor  TBTNSRow.Destroy;
var i : integer;
begin
  FreeMem(@Tag);
  FreeMem(@Count);
  FreeMem(@Left);
  FreeMem(@Right);
  FreeMem(@Interval);
 // For i:=7 downto 0 do FreeMem(@Btns[i]);
  FreeMem(@Btns);
  FreeMem(@BackGround);
  FreeMem(@Top);
  FreeMem(@Bottom);
  FreeMem(@AutoSize);
  inherited
end;

function TBTNSRow.AddButton(Name : string; image : TButtonImage) : integer;
begin
  count:=count+1;
  setlength(Btns,count);
  Btns[Count-1]:=TImgButton.Create;
  Btns[Count-1].Tag:=Count-1;
  Btns[Count-1].Row:=Tag;
  Btns[Count-1].BackGround:=BackGround;
  Btns[Count-1].Name:=Name;
  if image <> imnone
    then Btns[Count-1].LoadBMPFromRes(image)
    else Btns[Count-1].Image:=nil;
  result:=Count-1;
end;

procedure TBTNSRow.DrawRows(cv : tcanvas);
var i, wdth, btnwdth, interv : integer;
    X1,X2,Y1,Y2 : integer;
begin
  // Определяем интервалы и размер кнопок в зависимости от параметра AutoSize
  wdth := 0;
  if not AutoSize then begin
    for i:=0 to Count-1 do begin
      wdth:=wdth + Btns[i].Width;
    end;
    left := (cv.ClipRect.Right-cv.ClipRect.Left - wdth - interval * (Count-1)) div 2;
    right := left;
  end else begin
    btnwdth:=(cv.ClipRect.Right-cv.ClipRect.Left-left-right - interval*(Count-1)) div count;
  end;
  //Задаем параметры размещения кнопки и рисуем её
  X1:=Left;
  for i:=0 to Count-1 do begin
    Btns[i].Location.Top:=Top;
    Btns[i].Location.Bottom:=Bottom;
    Btns[i].Height:=Bottom-Top;
    Btns[i].Location.Left:=X1;
    if AutoSize then begin
      Btns[i].Location.Right:=X1+btnwdth;
    end else begin
      Btns[i].Location.Right:=X1+Btns[i].Width;
    end;
    X1:=Btns[i].Location.Right+Interval;
    Btns[i].DrawButton(cv);
  end;
end;

constructor TBTNSPanel.Create;
var i : integer;
begin
  inherited;
  Count:=0;
  Enable := true;
  Top := 10;
  Bottom := 10;
  Left := 10;
  Right := 10;
  Interval:=5;
  BackGround :=ProgrammColor;
  AutoSize := true;
  HeightRow := 30;
  //for i:=0 to 7 do Rows[i]:=TBTNSRow.Create;
end;

destructor  TBTNSPanel.Destroy;
var i : integer;
begin
  FreeMem(@Count);
  FreeMem(@Enable);
  FreeMem(@Top);
  FreeMem(@Bottom);
  FreeMem(@Left);
  FreeMem(@Right);
  FreeMem(@Interval);
  //for i:=7 to 0 do FreeMem(@Rows[i]);
  FreeMem(@Rows);
  FreeMem(@BackGround);
  FreeMem(@AutoSize);
  FreeMem(@HeightRow);
  inherited
end;

function TBTNSPanel.AddRow : integer;
begin
  count:=count+1;
  setlength(Rows,count);
  Rows[Count-1]:=TBTNSRow.Create;
  Rows[Count-1].Tag:=Count-1;
  Rows[Count-1].BackGround:=BackGround;
  Rows[Count-1].Left:=Left;
  Rows[Count-1].Right:=Right;
  result := Count-1;
end;

procedure TBTNSPanel.Draw(cv : tcanvas);
var i, sz, YSize, hght, tint : integer;
begin
  //Заливаем панель фоновым цветом
  cv.Brush.Color:=BackGround;
  cv.FillRect(cv.ClipRect);
  //Определяем размер панели по вертикали
  YSize := cv.ClipRect.Bottom - cv.ClipRect.Top;
  //Вычисляем сколько место по горизонтали требуется создаваемой панели
  hght:=Top + HeightRow*Count + Interval*(Count-1) + Bottom;
  //Подгоняем параметры кнопок под размер панели
  if YSize < hght then begin
     sz:= (YSize - Top - Bottom) div Count;
     if sz <= HeightRow then begin
       Interval:= HeightRow div 10;
       HeightRow:=HeightRow-Interval;
     end else begin
       Interval:=HeightRow-sz;
     end;
  end;
  //Задаем верхнию и нижнию границы для каждой строки
  tint:=Top;
  for i:=0 to Count-1 do begin
    Rows[i].Top:=tint;
    Rows[i].Bottom:=Rows[i].Top+HeightRow;
    Rows[i].DrawRows(cv);
    tint:=Rows[i].Bottom+Interval;
  end;

end;

procedure TBTNSPanel.Clear;
var i, j : integer;
begin
  if count <= 0 then exit;
  for i:=Count-1 downto 0 do begin
    for j:=Rows[i].Count-1 downto 0 do begin
       Rows[i].Btns[j].FreeInstance;
    end;
    setlength(Rows[i].Btns,0);
    Rows[i].FreeInstance;
  end;
  setlength(Rows,0);
  Count:=0;
end;

function TBTNSPanel.ClickButton(cv : tcanvas; X, Y : integer) : integer;
var i, j, k, cnt : integer;
begin
  result:=-1;
  if not Enable then exit;
  cnt:=0;
  for i:=0 to Count-1 do begin
    for j:=0 to Rows[i].Count-1 do begin
      if (X > Rows[i].Btns[j].Location.Left) and (X < Rows[i].Btns[j].Location.Right)
         and (Y > Rows[i].Btns[j].Location.Top) and (Y < Rows[i].Btns[j].Location.Bottom)
      then begin
        if not Rows[i].Btns[j].Visible then exit;
        if not Rows[i].Btns[j].Enable then exit;
        for k:=0 to i-1 do cnt:=cnt + Rows[k].Count;
        result:=cnt + j;
        Unselection;
        draw(cv);
        exit;
      end;
    end;
  end;
end;

Procedure TBTNSPanel.Unselection;
var i, j : integer;
begin
  for i:=0 to count-1
    do for j:=0 to Rows[i].Count-1 do Rows[i].Btns[j].Selection:=false;
end;

procedure TBTNSPanel.DrawHint(cv : tcanvas; ARow, ABtn : integer);
var X1,Y1,X2,Y2, EndImg, stp, dlt, wdth, delty, deltx : integer;
  xhint, yhint : integer;
  bkgn, fnt, brd : tcolor;
  fntsz : integer;
  rt : trect;
begin
  if ARow > Count-1 then exit;
  if ARow < 0 then exit;
  if ABtn > Rows[ARow].Count-1 then exit;
  if ABtn < 0 then exit;
  if not Rows[ARow].Btns[ABtn].Selection then exit;
  
  //Запоминаем параметры canvas
  bkgn := cv.Brush.Color;
  fnt := cv.Font.Color;
  brd := cv.Pen.Color;
  fntsz := cv.Font.Size;

  with Rows[ARow].Btns[ABtn] do begin
    if not Visible then exit;
    if not Enable then exit;
    //Устанавливаем параметры canvas для кнопки
    cv.Brush.Color:=Color;
    cv.Font.Color:=Font.Color;
    cv.Font.Size:=Font.Size;
    cv.Font.Style:=Font.Style;
    cv.Pen.Color:=ColorBorder;
    cv.Pen.Width:=WidthBorder;

    //Параметры размещения кнопки
    X1:=Location.Left;
    Y1:=Location.Top;
    X2:=Location.Right;
    Y2:=Location.Bottom;

    //Рисуем Hint если кнопка Selection
    IF HintShow and Selection then begin
      cv.Font.Size:=FontHint.Size;
      xhint:=X1 + ((X2-X1 - cv.TextWidth(Hint)) div 2);
      if xhint < cv.ClipRect.Left then xhint:=cv.ClipRect.Left+1;
      if xhint + cv.TextWidth(Hint) > cv.ClipRect.Right then xhint:=cv.ClipRect.Right-cv.TextWidth(Hint)-2;
      if Row=0 then begin
        yhint:=Y1-cv.TextHeight(Hint)- 2;
        if yhint < cv.ClipRect.Top then yhint:=Y2+2;
      end else yhint:=Y2+2;
      if yhint + cv.TextHeight(Hint) > cv.ClipRect.Bottom then yhint:=Y1-cv.TextHeight(Hint)- 2;
      cv.Brush.Color:=$dcf0f0;//SmoothColor(clWhite, 2);
      cv.Pen.Color := $dcf0f0;//SmoothColor($dcf0f0, 32);
      //cv.Pen.Width:=2;
      cv.Rectangle(xhint-1,yhint,xhint + 1 + cv.TextWidth(Hint),yhint + 1 + cv.TextHeight(Hint));//BackGround;
      cv.Brush.Style:=bsClear;
      cv.Font.Color:=FontHint.Color;
      cv.TextOut(xhint,yhint-1, Hint);
    end;
  end;
  //Востанавливаем параметры canvas
  cv.Brush.Style:=bsSolid;
  cv.Brush.Color:=bkgn;
  cv.Font.Color := fnt;
  cv.Pen.Color := brd;
  cv.Font.Size := fntsz;
end;

procedure TBTNSPanel.MouseMove(cv : tcanvas; X, Y : integer);
var i, j, k, cnt, ARow, ABtn : integer;
    sel : boolean;
begin
  cnt:=0;
  sel := false;
  for i:=0 to Count-1 do begin
    for j:=0 to Rows[i].Count-1 do begin
      Unselection;
      if (X > Rows[i].Btns[j].Location.Left) and (X < Rows[i].Btns[j].Location.Right)
         and (Y > Rows[i].Btns[j].Location.Top) and (Y < Rows[i].Btns[j].Location.Bottom)
      then begin
        if Rows[i].Btns[j].Visible and Rows[i].Btns[j].Enable then begin
          Rows[i].Btns[j].Selection:=true;
          sel := true;
          break;
        end;
        if sel then break;
      end;
      if sel then break;
    end;
    if sel then break;
  end;
  Draw(cv);
  DrawHint(cv, i, j);
end;

Initialization
  ProgrammFontName:='Times New Roman';
//Панель устройств в окне создания тайм-линий
   btnsdevice:=tbtnspanel.Create;
   btnsdevice.BackGround:=FormsColor;
//Панель устройста в окне подготовки
   btnsdevicepr:=tbtnspanel.Create;
   btnsdevicepr.BackGround:=ProgrammColor;

//Панель Текст в окне подготовки btnstexttl
   btnstexttl:=tbtnspanel.Create;
   btnstexttl.BackGround:=ProgrammColor;
   btnstexttl.Left:=10;
   btnstexttl.Right:=10;
   btnstexttl.Top:=60;
   btnstexttl.Bottom:=0;
   btnstexttl.HeightRow:=35;
   RowTemp:=btnstexttl.AddRow;
   btnstexttl.Rows[RowTemp].AutoSize:=true;
   BtnTemp:=btnstexttl.Rows[RowTemp].AddButton('In',imnone);
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].Width:=300;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].Font.Color:=clWhite;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=clWhite;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].Hint:='Установить точку начала субтиров.';
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

   BtnTemp:=btnstexttl.Rows[RowTemp].AddButton('Out',imnone);
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].Width:=300;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].Font.Color:=clWhite;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=clWhite;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].Hint:='Установить точку окончания субтиров.';
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

   BtnTemp:=btnstexttl.Rows[RowTemp].AddButton('Субтитры',imnone);
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].Font.Color:=clWhite;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=clWhite;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].Hint:='Загрузить субтитры из внешнего файла.';
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   btnstexttl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
   //btnstexttl.Rows[RowTemp].Btns[BtnTemp].Visible:=false;

//Панель медиа в окне подготовки
   btnsmediatl:=tbtnspanel.Create;
   btnsmediatl.BackGround:=ProgrammColor;
   btnsmediatl.Left:=10;
   btnsmediatl.Right:=10;
   btnsmediatl.Top:=10;
   btnsmediatl.Bottom:=10;
   btnsmediatl.HeightRow:=35;

   RowTemp:=btnsmediatl.AddRow;
   BtnTemp:=btnsmediatl.Rows[RowTemp].AddButton('Перегрузить файл',imnone);
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Hint:='Загрузить повторно исходный файл.';
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Font.Color:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psLeft;
  // btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;

   BtnTemp:=btnsmediatl.Rows[RowTemp].AddButton('Перегрузить',imaddsong);
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Font.Color:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psLeft;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Visible:=false;

   RowTemp:=btnsmediatl.AddRow;
   BtnTemp:=btnsmediatl.Rows[RowTemp].AddButton('Маркер +',imnone);
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Hint:='Установить маркер.';
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Font.Color:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psLeft;
  // btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;

   BtnTemp:=btnsmediatl.Rows[RowTemp].AddButton('Маркер -',imnone);
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Hint:='Удалить маркер.';
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Font.Color:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psLeft;
   //btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;

   RowTemp:=btnsmediatl.AddRow;
   BtnTemp:=btnsmediatl.Rows[RowTemp].AddButton('НТК',imnone);
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Hint:='Установить начальный тайм-код.';
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Font.Color:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psLeft;
  // btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;

   BtnTemp:=btnsmediatl.Rows[RowTemp].AddButton('КТК',imnone);
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Hint:='Установить конечный тайм-код.';
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Font.Color:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=clWhite;
   btnsmediatl.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psLeft;
  // btnsmediatl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;

// Панель управляющих кнопок окна подготовки
   btnspanel1:=tbtnspanel.Create;
   btnspanel1.Top:=30;
   btnspanel1.Interval:=10;
   //btnspanel1.AutoSize:=false;
   //btnspanel1.BackGround;                // TButtonImage = (im123,imaddsong,imbook,imcut,imcopy,impaste1,impaste2,imdel,imdown,
                                           // imprint,imshift,imtrash,imtrim,imundo,imup,imuser,imnone);

    RowTemp:=btnspanel1.AddRow;
    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',imtrim);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='Обрезать событие слева.';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',imshift);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='Сдвинуть на заданный интервал.';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',imshift);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Visible:=false;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',im123);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='Присвоить короткие номера.';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',imprint);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='Вывести данные на печать.';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    RowTemp:=btnspanel1.AddRow;
    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',imcut);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='Вырезать.';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',imcopy);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='Копировать.';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',impaste1);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='Вставить.';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',imtrash);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='Удалить.';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=btnspanel1.Rows[RowTemp].AddButton('',imundo);
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].Hint:='Отменить действие.';
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnspanel1.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

// Панель кнопок проект
    pnlprojects:=TBTNSPanel.Create;
    pnlprojects.Top:=25;
    pnlprojects.Left:=10;
    pnlprojects.Right:=10;
    pnlprojects.BackGround:=ProgrammColor;
    pnlprojects.Interval:=5;
    pnlprojects.HeightRow:=30;

    RowTemp:=pnlprojects.AddRow;

    BtnTemp:=pnlprojects.Rows[RowTemp].AddButton('Новый', imbook);
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].Hint:='Создать новый проект';
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=pnlprojects.Rows[RowTemp].AddButton('Удалить', imdel);
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].Hint:='Удалить проект/проекты';
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    RowTemp:=pnlprojects.AddRow;

    BtnTemp:=pnlprojects.Rows[RowTemp].AddButton('Копировать', imcopy);
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].Hint:='Создать копию проекта';
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=pnlprojects.Rows[RowTemp].AddButton('Сортировать', imup);
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].Hint:='Сортировать список проектов';
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    pnlprojects.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

// Понель кнопок управления проектом
   pnlprojcntl:=TBTNSPanel.Create;
   pnlprojcntl.Top:=20;
   pnlprojcntl.Left:=10;
   pnlprojcntl.Right:=10;
   pnlprojcntl.BackGround:=ProgrammColor;
   pnlprojcntl.Interval:=5;
   pnlprojcntl.HeightRow:=30;

   RowTemp:=pnlprojcntl.AddRow;

   BtnTemp:=pnlprojcntl.Rows[RowTemp].AddButton('Tайм-линия', imbook);
   pnlprojcntl.Rows[RowTemp].Btns[BtnTemp].Hint:='Добавить тайм-линию';

   BtnTemp:=pnlprojcntl.Rows[RowTemp].AddButton('Тайм-линию', imtrash);
   pnlprojcntl.Rows[RowTemp].Btns[BtnTemp].Hint:='Удалить тайм-линию';

   RowTemp:=pnlprojcntl.AddRow;
   BtnTemp:=pnlprojcntl.Rows[RowTemp].AddButton('Добавить', imbook);
   pnlprojcntl.Rows[RowTemp].Btns[BtnTemp].Hint:='Добавить в список новый элемент';
   BtnTemp:=pnlprojcntl.Rows[RowTemp].AddButton('Удалить', imtrash);
   pnlprojcntl.Rows[RowTemp].Btns[BtnTemp].Hint:='Удалить из списка элемент';
   //BtnTemp:=pnlprojcntl.Rows[RowTemp].AddButton('Редактировать', imup);
   //pnlprojcntl.Rows[RowTemp].Btns[BtnTemp].Hint:='Редактировать выбранный элемент';
   RowTemp:=pnlprojcntl.AddRow;
   BtnTemp:=pnlprojcntl.Rows[RowTemp].AddButton('Сохранить', imcopy);
   pnlprojcntl.Rows[RowTemp].Btns[BtnTemp].Hint:='Сохранить сделанные изменения';
   BtnTemp:=pnlprojcntl.Rows[RowTemp].AddButton('Сортировать', imup);
   pnlprojcntl.Rows[RowTemp].Btns[BtnTemp].Hint:='Сортировать список';

// Понель кнопок управления клипами
   pnlbtnsclips:=TBTNSPanel.Create;
   pnlbtnsclips.Top:=20;
   pnlbtnsclips.Left:=5;
   pnlbtnsclips.Right:=5;
   pnlbtnsclips.BackGround:=ProgrammColor;
   pnlbtnsclips.Interval:=5;
   pnlbtnsclips.HeightRow:=30;

   RowTemp:=pnlbtnsclips.AddRow;

   BtnTemp:=pnlbtnsclips.Rows[RowTemp].AddButton('Импорт', imbook);
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Hint:='Импортировать медиа файл в систему';
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

   BtnTemp:=pnlbtnsclips.Rows[RowTemp].AddButton('Удалить', imtrash);
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Hint:='Удалить тайм-линию';
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

   RowTemp:=pnlbtnsclips.AddRow;
   BtnTemp:=pnlbtnsclips.Rows[RowTemp].AddButton('Воспроизвести', imaddsong);
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Hint:='Загрузить клип в окно подготовки';
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

   BtnTemp:=pnlbtnsclips.Rows[RowTemp].AddButton('Сортировать', imdown);
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Hint:='Отсортировать списк клипов';
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

   RowTemp:=pnlbtnsclips.AddRow;

   BtnTemp:=pnlbtnsclips.Rows[RowTemp].AddButton('Загрузить в плей-лист', imaddsong);
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Hint:='Загрузить клип/клипы в активный плей-лист';
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
   pnlbtnsclips.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

// Панель кнопок плей-листа
    pnlbtnspl:=TBTNSPanel.Create;
    pnlbtnspl.Top:=40;
    pnlbtnspl.Left:=5;
    pnlbtnspl.Right:=5;
    pnlbtnspl.BackGround:=ProgrammColor;
    pnlbtnspl.Interval:=5;
    pnlbtnspl.HeightRow:=30;

    RowTemp:=pnlbtnspl.AddRow;

    BtnTemp:=pnlbtnspl.Rows[RowTemp].AddButton('Клипы', imbook);
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Hint:='Добавить клип/клипы в плей-лист';
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=pnlbtnspl.Rows[RowTemp].AddButton('Удалить', imtrash);
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Hint:='Удалить клип/клипы из плей-листа';
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    RowTemp:=pnlbtnspl.AddRow;

    BtnTemp:=pnlbtnspl.Rows[RowTemp].AddButton('Вниз', imdown);
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Hint:='Переместить на позицию вниз';
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    BtnTemp:=pnlbtnspl.Rows[RowTemp].AddButton('Вверх', imup);
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Hint:='Переместить на позицию вверх';
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

    RowTemp:=pnlbtnspl.AddRow;

    BtnTemp:=pnlbtnspl.Rows[RowTemp].AddButton('Воспроизвести', imaddsong);
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Hint:='Загрузить клип в окно подготовки';
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Alignment:=psLeft;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

//    BtnTemp:=pnlbtnspl.Rows[RowTemp].AddButton('', imCut);
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Hint:='Вырезать';
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
//
//    BtnTemp:=pnlbtnspl.Rows[RowTemp].AddButton('', imcopy);
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Hint:='Копировать в буфер обмена';
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
//
//    BtnTemp:=pnlbtnspl.Rows[RowTemp].AddButton('', impaste1);
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].Hint:='Вставить из буфера обмена';
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
//    pnlbtnspl.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;

// Панель запуска\останова медиа-плейра
   btnsctlleft := TBTNSPanel.Create;
   btnsctlleft.Top:=5;
   btnsctlleft.Bottom:=5;
   btnsctlleft.Left:=20;
   btnsctlleft.Right:=40;
   btnsctlleft.BackGround:=ProgrammColor;
   btnsctlleft.Interval:=1;
   btnsctlleft.HeightRow:=30;

   RowTemp:=btnsctlleft.AddRow;

    BtnTemp:=btnsctlleft.Rows[RowTemp].AddButton('', imCut);
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].Hint:='Перейти в начало';
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlleft.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;

    BtnTemp:=btnsctlleft.Rows[RowTemp].AddButton('', imdel);
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].Hint:='Перейти на соьытие влево';
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlleft.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;

    BtnTemp:=btnsctlleft.Rows[RowTemp].AddButton('', imCut);
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].Hint:='Перейти на событие вправо';
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlleft.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;

    BtnTemp:=btnsctlleft.Rows[RowTemp].AddButton('', imCut);
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].Hint:='Перейти в конец';
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlleft.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;

    BtnTemp:=btnsctlleft.Rows[RowTemp].AddButton('', imCut);
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].Visible:=false;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].Hint:='В начало';
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlleft.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;

    BtnTemp:=btnsctlleft.Rows[RowTemp].AddButton('', imaddsong);
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].Hint:='Воспроизвести медиа';
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlleft.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;


// Панель управления скоростью воспроизведения
   btnsctlright := TBTNSPanel.Create;
   btnsctlright.Top:=5;
   btnsctlright.Bottom:=5;
   btnsctlright.Left:=50;
   btnsctlright.Right:=50;
   btnsctlright.BackGround:=ProgrammColor;
   btnsctlright.Interval:=0;
   btnsctlright.HeightRow:=30;

   RowTemp:=btnsctlright.AddRow;

    BtnTemp:=btnsctlright.Rows[RowTemp].AddButton('', imCut);
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].Hint:='Перейти в начало';
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlright.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;

    BtnTemp:=btnsctlright.Rows[RowTemp].AddButton('', imdel);
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].Hint:='Перейти на соьытие влево';
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlright.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;

    BtnTemp:=btnsctlright.Rows[RowTemp].AddButton('', imCut);
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].Hint:='Перейти на событие вправо';
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlright.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;

    BtnTemp:=btnsctlright.Rows[RowTemp].AddButton('', imCut);
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].Hint:='Перейти в конец';
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
   // btnsctlright.Rows[RowTemp].Btns[BtnTemp].HintShow:=true;
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].FontHint.Size:=8;
    btnsctlright.Rows[RowTemp].Btns[BtnTemp].ColorBorder:=pnlbtnspl.BackGround;

end.
