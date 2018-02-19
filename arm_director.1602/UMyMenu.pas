unit UMyMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid, uwaiting, JPEG,
  Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend, PasLibVlcUnit,
  vlcpl;

type
  TMyComboBox = class
    rbtn : trect;
    rtxt : trect;
    Text : string;
    FontSize : integer;
    btnselect : boolean;
    txtselect : boolean;
    procedure   draw(cv : tcanvas);
    function    MouseMove(cv : tcanvas; X, Y : integer) : integer;
    function    MouseClick(cv : tcanvas; X, Y : integer) : integer;
    constructor Create(cv : tcanvas; Txt : string);
    destructor  destroy;
  end;

  TFindImg = class
    rtimg       : trect;
    rtext       : trect;
    direction   : boolean;
    Select      : boolean;
    Text        : string;
    imgselect   : boolean;
    txtselect   : boolean;
    procedure   draw(cv : tcanvas);
    function    MouseMove(cv : tcanvas; X, Y : integer) : integer;
    function    MouseClick(cv : tcanvas; X, Y : integer) : integer;
    constructor Create(cv : tcanvas; Txt : string);
    destructor  destroy;
  end;

  TMenuString = class
    Text        : string;
    Rect        : Trect;
    select      : boolean;
    result      : integer;
    procedure   Draw(dib : tfastdib);
    constructor create(Name : string; res : integer);
    destructor  destroy;
  end;

  TMyMenu = class
    count       : integer;
    rowheight   : integer;
    offset      : integer;
    Menus       : array of TMenuString;
    procedure   Add(Name : string; result : integer);
    procedure   Init(cv : tcanvas);
    procedure   Draw(cv : tcanvas);
    procedure   SetNotSelet;
    function    MouseMove(cv : tcanvas; X, Y : integer) : integer;
    function    MouseClick(cv : tcanvas; X, Y : integer) : integer;
    procedure   clear;
    constructor create;
    destructor  destroy;
  end;

Procedure CreateMainMenu;
procedure DrawMenuBitmap(spb : TSpeedButton);
procedure CreateInputPopUpMenu;
function ClickInputPopUpMenu(img : timage; Y : integer) : integer;

var MyMainMenu, InputPopUpMenu, MenuListFiles, TempMenu : TMyMenu;
    APlText, APlTime, ClpText, ClpTime : TFindImg;
    APLCurr : TMyComboBox;

implementation
uses UMain, UCommon;

constructor TMyComboBox.Create(cv : tcanvas; Txt : string);
var hght, wdth : integer;
begin
  hght:=cv.ClipRect.Bottom-cv.ClipRect.Top-10;
  wdth:=cv.ClipRect.Right-cv.ClipRect.Left-10;

  rbtn.Left:=cv.ClipRect.Right-5-hght;
  rbtn.Right:=cv.ClipRect.Right-5;
  rbtn.Top:=5;
  rbtn.Bottom:=rbtn.Top+hght;

  rtxt.Left:=5;
  rtxt.Right:=rbtn.Left;
  rtxt.Top:=5;
  rtxt.Bottom:=rbtn.Bottom;

  Text:='Пробный текст';
  btnselect:=false;
  txtselect:=false;
  fontsize:=18;
end;

destructor TMyComboBox.destroy;
begin
  freemem(@rbtn);
  freemem(@rtxt);
  freemem(@Text);
  freemem(@btnselect);
  freemem(@txtselect);
  freemem(@fontsize);
end;

procedure TMyComboBox.draw(cv : tcanvas);
var tmp : tfastdib;
   bl : boolean;
   psy : integer;
begin
  tmp := tfastdib.Create;
  try
    tmp.SetSize(cv.ClipRect.Right-cv.ClipRect.Left,cv.ClipRect.Bottom-cv.ClipRect.Top,32);
    tmp.Clear(TColorToTfcolor(ProgrammColor));
    tmp.SetBrush(bs_solid,0,colortorgb(ProgrammColor));
    tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
    tmp.SetTransparent(true);
    tmp.SetPen(ps_Solid,2,ColorToRGB(Form1.Font.Color));
    bl := btnselect;
    if btnselect then begin
      tmp.SetBrush(bs_solid,0,smoothcolor(colortorgb(ProgrammColor),32));
    end else begin
      tmp.SetBrush(bs_solid,0,colortorgb(ProgrammColor));
    end;
    tmp.FillRect(rbtn);
    tmp.Rectangle(rbtn.Left,rbtn.Top,rbtn.Right,rbtn.Bottom);
    psy :=rbtn.Top + (rbtn.Bottom-rbtn.Top) div 2;

    tmp.SetPen(ps_Solid,1,ColorToRGB(Form1.Font.Color));

    tmp.MoveTo(rbtn.Left+4, psy-5);
    tmp.LineTo(rbtn.Right-5, psy-5);
    tmp.MoveTo(rbtn.Left+4, psy);
    tmp.LineTo(rbtn.Right-5, psy);
    tmp.MoveTo(rbtn.Left+4, psy+5);
    tmp.LineTo(rbtn.Right-5, psy+5);


    if txtselect then begin
      tmp.SetBrush(bs_solid,0,smoothcolor(colortorgb(ProgrammColor),32));
    end else begin
      tmp.SetBrush(bs_solid,0,colortorgb(ProgrammColor));
    end;
    tmp.FillRect(rtxt);
    tmp.Rectangle(rtxt.Left,rtxt.Top,rtxt.Right,rtxt.Bottom);
    tmp.SetTextColor(ColorToRGB(Form1.Font.Color));
    tmp.SetFont(Form1.Font.Name,fontsize);
    tmp.DrawText(Text,rect(rtxt.Left+5,rtxt.Top,rtxt.Right,rtxt.Bottom),DT_VCENTER or DT_SINGLELINE);
    tmp.SetTransparent(false);
    tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
    cv.Refresh;
  finally
    tmp.Free;
    tmp:=nil;
  end;
end;

function TMyComboBox.MouseMove(cv : tcanvas; X, Y : integer) : integer;
begin
  result:=-1;
  btnselect:=false;
  txtselect:=false;
  if (X>rbtn.Left+1) and (X<rbtn.Right-1) and (Y>rbtn.Top+1) and (Y<rbtn.Bottom-1)
  then begin
    btnselect:=true;
    result := 0;
    exit;
  end;
  if (X>rtxt.Left+1) and (X<rtxt.Right-1) and (Y>rtxt.Top+1) and (Y<rtxt.Bottom-1)
  then begin
    txtselect:=true;
    result := 1;
  end;
end;

function TMyComboBox.MouseClick(cv : tcanvas; X, Y : integer) : integer;
begin
  result:=-1;
  btnselect:=false;
  txtselect:=false;
  if (X>rbtn.Left+1) and (X<rbtn.Right-1) and (Y>rbtn.Top+1) and (Y<rbtn.Bottom-1)
  then begin
    btnselect:=true;
    result := 0;
    exit;
  end;
  if (X>rtxt.Left+1) and (X<rtxt.Right-1) and (Y>rtxt.Top+1) and (Y<rtxt.Bottom-1)
  then begin
    txtselect:=true;
    result := 1;
  end;
end;

constructor TFindImg.Create(cv : tcanvas; Txt : string);
var ht : integer;
begin
  ht:=cv.ClipRect.Bottom-cv.ClipRect.Top;
  rtimg.Left   :=2;
  rtimg.Top    :=(cv.ClipRect.Bottom-cv.ClipRect.Top - 20) div 2;
  rtimg.Right  :=rtimg.Left + 18;
  rtimg.Bottom :=rtimg.Top + 18;
  rtext.Left   :=rtimg.Right;
  rtext.Top    :=rtimg.Top;
  rtext.Right  :=cv.ClipRect.Right;
  rtext.Bottom :=rtimg.Bottom;
  direction    := true;
  Select       := false;
  Text         := Txt;
  imgselect    := false;
  txtselect    := false;
end;

destructor  TFindImg.destroy;
begin
  freemem(@rtimg);
  freemem(@rtext);
  freemem(@direction);
  freemem(@Select);
  freemem(@Text);
  freemem(@imgselect);
  freemem(@txtselect);
end;

procedure   TFindImg.draw(cv : tcanvas);
var tmp : tfastdib;
    poli : array of tpoint;
begin
  tmp := tfastdib.Create;
  try
    tmp.SetSize(cv.ClipRect.Right-cv.ClipRect.Left,cv.ClipRect.Bottom-cv.ClipRect.Top,32);
    tmp.Clear(TColorToTfcolor(ProgrammColor));
    tmp.SetBrush(bs_solid,0,colortorgb(ProgrammColor));
    tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
    tmp.SetTransparent(true);
    tmp.SetPen(ps_Solid,2,ColorToRGB(Form1.Font.Color));
    if imgselect then begin
      tmp.SetBrush(bs_solid,0,smoothcolor(colortorgb(ProgrammColor),32));
    end else begin
      tmp.SetBrush(bs_solid,0,colortorgb(ProgrammColor));
    end;
    tmp.FillRect(rtimg);
    tmp.Rectangle(rtimg.Left,rtimg.Top,rtimg.Right,rtimg.Bottom);
    tmp.SetPen(ps_Solid,1,ColorToRGB(Form1.Font.Color));
    if txtselect then begin
      tmp.SetBrush(bs_solid,0,smoothcolor(colortorgb(ProgrammColor),32));
    end else begin
      tmp.SetBrush(bs_solid,0,colortorgb(ProgrammColor));
    end;
    tmp.FillRect(rtext);
    tmp.Rectangle(rtext.Left,rtext.Top,rtext.Right,rtext.Bottom);
    tmp.SetTextColor(ColorToRGB(Form1.Font.Color));
    tmp.SetFont(Form1.Font.Name,rtimg.Bottom-rtimg.Top-2);
    tmp.DrawText(Text,rtext,DT_CENTER);
    //if select then begin
      setlength(Poli,3);
      if direction then begin
        poli[0].X:=rtimg.Left+3;
        poli[0].Y:=rtimg.Top+5;
        poli[1].X:=rtimg.Right-4;
        poli[1].Y:=rtimg.Top+5;
        poli[2].X:=rtimg.Left+8;//(rtimg.Right-rtimg.Left) div 2;
        poli[2].Y:=rtimg.Bottom-6;
      end else begin
        poli[0].X:=rtimg.Left+8;//(rtimg.Right-rtimg.Left) div 2;
        poli[0].Y:=rtimg.Top+5;
        poli[1].X:=rtimg.Left+3;
        poli[1].Y:=rtimg.Bottom-6;
        poli[2].X:=rtimg.Right-4;
        poli[2].Y:=rtimg.Bottom-6;
      end;
    //end;
    if select then begin
      tmp.SetPen(ps_Solid,1,ColorToRGB(Form1.Font.Color));
      tmp.SetBrush(bs_solid,0,colortorgb(Form1.Font.Color));
    end else begin
      tmp.SetPen(ps_Solid,1,colortorgb(smoothcolor(ProgrammColor,64)));
      tmp.SetBrush(bs_solid,0,colortorgb(smoothcolor(ProgrammColor,64)));
    end;
    tmp.Polygon(poli);
    tmp.SetTransparent(false);
    tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
    cv.Refresh;
  finally
    tmp.Free;
    tmp:=nil;
  end;
end;

function TFindImg.MouseMove(cv : tcanvas; X, Y : integer) : integer;
begin
  result:=-1;
  imgselect:=false;
  txtselect:=false;
  if (X>rtimg.Left+1) and (X<rtimg.Right-1) and (Y>rtimg.Top+1) and (Y<rtimg.Bottom-1)
  then begin
    imgselect:=true;
    result := 0;
    exit;
  end;
  if (X>rtext.Left+1) and (X<rtext.Right-1) and (Y>rtext.Top+1) and (Y<rtext.Bottom-1)
  then begin
    txtselect:=true;
    result := 1;
  end;
end;

function TFindImg.MouseClick(cv : tcanvas; X, Y : integer) : integer;
begin
  result:=-1;
  imgselect:=false;
  txtselect:=false;
  if (X>rtimg.Left+1) and (X<rtimg.Right-1) and (Y>rtimg.Top+1) and (Y<rtimg.Bottom-1)
  then begin
    imgselect:=true;
    result := 0;
    exit;
  end;
  if (X>rtext.Left+1) and (X<rtext.Right-1) and (Y>rtext.Top+1) and (Y<rtext.Bottom-1)
  then begin
    txtselect:=true;
    result := 1;
  end;
end;

constructor TMyMenu.create;
begin
  Count     :=0;
  rowheight := 22;
  offset    := 5;
end;

procedure TMyMenu.Clear;
var i : integer;
begin
  rowheight := 22;
  offset    := 5;
  for i:=Count-1 downto 0 do begin
    Menus[Count-1].FreeInstance;
    Count:=Count-1;
    setlength(Menus,Count);
  end;
  Count:=0;
end;

procedure   TMyMenu.Add(Name : string; result : integer);
begin
  Count := Count + 1;
  setlength(Menus,Count);
  Menus[Count-1] := TMenuString.create(Name, result);
end;

procedure   TMyMenu.Init(cv : tcanvas);
var i, wdth, hght, ps, hrw : integer;
begin
  wdth := cv.ClipRect.Right - cv.ClipRect.Left - 2*offset;
  hght := cv.ClipRect.Bottom - cv.ClipRect.Top - 2*offset;
  hrw := rowheight;
  if rowheight*count > hght then hrw := hght div Count;
  ps:=offset;
  for i:=0 to Count-1 do begin
    Menus[i].Rect.Top:=ps;
    Menus[i].Rect.Bottom:=Menus[i].Rect.Top + hrw;
    Menus[i].Rect.Left:=offset+5;
    Menus[i].Rect.Right:=offset+wdth-5;
    ps:=Menus[i].Rect.Bottom;
  end;
end;

procedure   TMyMenu.Draw(cv : tcanvas);
var tmp : tfastdib;
    i : integer;
    rt: trect;
begin
   init(cv);
   tmp := tfastdib.Create;
   try
     tmp.SetSize(cv.ClipRect.Right-cv.ClipRect.Left,cv.ClipRect.Bottom-cv.ClipRect.Top,32);
     tmp.Clear(TColorToTfcolor(Form1.Color));
     tmp.SetBrush(bs_solid,0,colortorgb(Form1.Color));
     tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
     tmp.SetTransparent(true);
     tmp.SetPen(ps_Solid,1,ColorToRGB(Form1.Font.Color));
     for i:=0 to Count-1 do Menus[i].Draw(tmp);
     tmp.SetTransparent(false);
     tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
     cv.Refresh;
   finally
     tmp.Free;
   end;
end;

procedure TMyMenu.SetNotSelet;
var i : integer;
begin
  for i:=0 to count-1 do Menus[i].select:=false;

end;

function TMyMenu.MouseMove(cv : tcanvas; X, Y : integer) : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to count-1 do begin
    if (Y>menus[i].Rect.Top+5) and (Y<menus[i].Rect.Bottom-5) then begin
      if trim(menus[i].Text)='-' then begin
        result:=menus[i].result;
        menus[i].select:=false;
        exit;
      end;
      menus[i].select:=true;
      result := menus[i].result;
      exit;
    end else menus[i].select:=false;
  end;
end;

function TMyMenu.MouseClick(cv : tcanvas; X, Y : integer) : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to count-1 do begin
    if (Y>menus[i].Rect.Top+5) and (Y<menus[i].Rect.Bottom-5) then begin
      if trim(menus[i].Text)='-' then begin
        result:=menus[i].result;
        menus[i].select:=false;
        exit;
      end;
      menus[i].select:=false;
      result := menus[i].result;
      exit;
    end else menus[i].select:=false;
  end;
end;

destructor  TMyMenu.destroy;
begin
  clear;
  freemem(@Count);
  freemem(@RowHeight);
  freemem(@Offset);
  freemem(@Menus);
end;

constructor TMenuString.create(Name : string; res : integer);
begin
  Text        := Name;
  Rect.Left   := 0;
  Rect.Top    := 0;
  Rect.Right  := 0;
  Rect.Bottom := 0;
  select      := false;
  result      := res;
end;

destructor TMenuString.destroy;
begin
  freemem(@Text);
  freemem(@Rect);
  freemem(@select);
  freemem(@Result);
end;

procedure TMenuString.Draw(dib : tfastdib);
begin
  dib.SetTextColor(colortorgb(Form1.Font.Color));
  dib.SetFont(Form1.Font.Name,MTFontSize);//Rect.Bottom-Rect.Top-4);
  if trim(Text)='-' then begin
    dib.SetBrush(bs_solid,0,colortorgb(Form1.Color));
    dib.FillRect(Rect);
    dib.SetPen(ps_Solid,1,colortorgb(Form1.Font.Color));
    dib.MoveTo(Rect.Left,Rect.Top + (Rect.Bottom-Rect.Top) div 2);
    dib.LineTo(Rect.Right,Rect.Top + (Rect.Bottom-Rect.Top) div 2);
  end else begin
    if select
      then dib.SetBrush(bs_solid,0,colortorgb(smoothcolor(Form1.Color,48)))
      else dib.SetBrush(bs_solid,0,colortorgb(Form1.Color));
    dib.FillRect(Rect);
    dib.DrawText(Text,Rect,DT_VCENTER);
  end;
end;

function ClickInputPopUpMenu(img : timage; Y : integer) : integer;
begin
  result:=-1;
  if (Y>0) and (Y < (img.Height div 2)) then result:=0 else result:=1;
end;

procedure CreateInputPopUpMenu;
begin
  InputPopUpMenu := TMyMenu.create;
  InputPopUpMenu.Add('Новый проект',0);
  InputPopUpMenu.Add('Открыть проект',1);
  InputPopUpMenu.offset := 0;
  InputPopUpMenu.rowheight := 20;
  Form1.Image4.Height:=InputPopUpMenu.count*InputPopUpMenu.rowheight;
  Form1.Image4.Width:=170;
  Form1.Image4.Picture.Bitmap.Height:=Form1.Image4.Height;
  Form1.Image4.Picture.Bitmap.Width:=Form1.Image4.Width;
  Form1.Image4.Repaint;
  InputPopUpMenu.Draw(Form1.Image4.Canvas);
end;

procedure DrawMenuBitmap(spb : TSpeedButton);
var bmp : tbitmap;
    i : integer;
begin
  bmp := tbitmap.Create;
  try
    bmp.Width:=30;
    bmp.Height:=30;
    bmp.Canvas.Brush.Style:=bsSolid;
    bmp.Canvas.Brush.Color := ProgrammColor;
    bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
    bmp.Canvas.Pen.Style := psSolid;
    bmp.Canvas.Pen.Width := 2;
    bmp.Canvas.Pen.Color := ProgrammFontColor;
    for i:=1 to 3 do begin
      bmp.Canvas.MoveTo(5, trunc(i*7.5));
      bmp.Canvas.LineTo(24, trunc(i*7.5));
    end;
    spb.Glyph.Assign(bmp);
  finally
    bmp.Free;
  end;
end;

Procedure CreateMainMenu;
begin
  MyMainMenu := TMyMenu.create;
  MyMainMenu.Add('Новый проект',0);
  MyMainMenu.Add('Открыть проект',1);
  MyMainMenu.Add('Переименовать проект',12);
  MyMainMenu.Add('-',-1);
  MyMainMenu.Add('Сохранить',2);
  MyMainMenu.Add('Сохранить как',3);
  MyMainMenu.Add('-',-1);
  MyMainMenu.Add('Текстовые шаблоны',4);
  MyMainMenu.Add('Графические шаблоны',5);
  MyMainMenu.Add('-',-1);
  MyMainMenu.Add('Добавить тайм-линию',6);
  MyMainMenu.Add('Удалить тайм-линию',7);
  MyMainMenu.Add('Редактировать тайм-линию',8);
  MyMainMenu.Add('-',-1);
  MyMainMenu.Add('Список горячих клавиш',9);
  MyMainMenu.Add('Настройки',11);
  MyMainMenu.Add('-',-1);
  MyMainMenu.Add('Выход',10);
  Form1.pnMainMenu.Height:=MyMainMenu.count * MyMainMenu.rowheight + 4;
  Form1.pnMainMenu.Width:=222;//MyMainMenu.count * MyMainMenu.rowheight + 4;
  Form1.ImgMainMenu.Height:=Form1.pnMainMenu.Height-2;
  Form1.ImgMainMenu.Width:=220;
  Form1.ImgMainMenu.Picture.Bitmap.Height:=Form1.ImgMainMenu.Height;
  Form1.ImgMainMenu.Picture.Bitmap.Width:=220;
  Form1.pnMainMenu.Repaint;
  myMainMenu.Draw(Form1.imgMainMenu.Canvas);
end;

end.
