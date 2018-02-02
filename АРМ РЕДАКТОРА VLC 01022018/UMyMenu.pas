unit UMyMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid, uwaiting, JPEG,
  Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend, PasLibVlcUnit,
  vlcpl;

Procedure CreateMainMenu(img : timage; Y : integer);
function ClickMainMenu(Y : integer) : integer;
procedure DrawMenuBitmap(spb : TSpeedButton);
procedure CreateInputPopUpMenu(img : timage; Y : integer);
function ClickInputPopUpMenu(img : timage; Y : integer) : integer;

implementation
uses UMain, UCommon;

function ClickInputPopUpMenu(img : timage; Y : integer) : integer;
begin
  result:=-1;
  if (Y>0) and (Y < (img.Height div 2)) then result:=0 else result:=1;
end;

procedure CreateInputPopUpMenu(img : timage; Y : integer);
var rt : trect;
    stri : widestring;
    ps : integer;
begin
  rt.Left:=img.Canvas.ClipRect.Left;
  rt.Right:=img.Canvas.ClipRect.Right;
  if Y>0 then begin
   if Y > (img.Height div 2) then begin
     ps:=2;
     rt.Top:=img.Height div 2;
     rt.Bottom:=img.Canvas.ClipRect.Bottom;
   end else begin
     ps:=1;
     rt.Top:=img.Canvas.ClipRect.Top;
     rt.Bottom:=rt.Top + img.Height div 2;
   end;
  end else ps:=-1;
  img.Picture.Bitmap.Width:=img.Width;
  img.Picture.Bitmap.Height:=img.Height;
  img.Canvas.Brush.Style:=bsSolid;
  img.Canvas.Brush.Color := ProgrammColor;
  img.Canvas.FillRect(img.Canvas.ClipRect);
  if ps>0 then begin
    img.Canvas.Brush.Color := SmoothColor(ProgrammColor,48);
    img.Canvas.FillRect(rt);
    img.Canvas.Brush.Color := ProgrammColor;
  end;
  img.Canvas.Font.Name := ProgrammFontName;
  img.Canvas.Font.Color := ProgrammFontColor;
  img.Canvas.Font.Size  := ProgrammFontSize;
  img.Canvas.Pen.Style := psSolid;
  img.Canvas.Pen.Width := 2;
  img.Canvas.Pen.Color := ProgrammFontColor;
  img.Canvas.Brush.Style:=bsClear;

  rt.Left   := img.Canvas.ClipRect.Left+5;
  rt.Right  := img.Canvas.ClipRect.Right-5;
  rt.Top    := img.Canvas.ClipRect.Top;
  rt.Bottom := rt.Top + (img.Height div 2);
  stri := 'Íîâûé ïğîåêò';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  rt.Top    := rt.Bottom;
  rt.Bottom := img.Canvas.ClipRect.Bottom;
  stri := 'Îòêğûòü ñîõğàíåííûé';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
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
    //spb.Glyph.Width:=30;
    //spb.Glyph.Height:=30;
    //spb.Glyph.Canvas.CopyRect(spb.Glyph.Canvas.ClipRect,bmp.Canvas,bmp.Canvas.ClipRect);
  finally
    bmp.Free;
  end;
end;

Procedure CreateMainMenu(img : timage; Y : integer);
var rt, rts : trect;
    stri : widestring;
    ps : integer;
begin
  ps:=-1;
  if Y > 5 then begin
    ps := (Y - 5) div 25;
    rts.Left   := img.Canvas.ClipRect.Left+5;
    rts.Right  := img.Canvas.ClipRect.Right-5;
    rts.Top    := 7 + ps*25;
    rts.Bottom := rts.Top + 20;
  end;
  img.Height:= 285;
  img.Picture.Bitmap.Width:=img.Width;
  img.Picture.Bitmap.Height:=img.Height;
  img.Canvas.Brush.Style:=bsSolid;
  img.Canvas.Brush.Color := ProgrammColor;
  img.Canvas.FillRect(img.Canvas.ClipRect);
  if ps>=0 then begin
    img.Canvas.Brush.Color := SmoothColor(ProgrammColor,48);
    img.Canvas.FillRect(rts);
    img.Canvas.Brush.Color := ProgrammColor;
  end;
  img.Canvas.Font.Name := ProgrammFontName;
  img.Canvas.Font.Color := ProgrammFontColor;
  img.Canvas.Font.Size  := ProgrammFontSize;
  img.Canvas.Pen.Style := psSolid;
  img.Canvas.Pen.Width := 2;
  img.Canvas.Pen.Color := ProgrammFontColor;
  img.Canvas.Brush.Style:=bsClear;
  img.Canvas.Rectangle(img.Canvas.ClipRect);
  img.Canvas.Pen.Width := 1;
  rt.Left   := img.Canvas.ClipRect.Left+10;
  rt.Right  := img.Canvas.ClipRect.Right-10;
  rt.Top    := img.Canvas.ClipRect.Top + 5;
  rt.Bottom := rt.Top + 25;
  stri := 'Íîâûé ïğîåêò';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Îòêğûòü ïğîåêò';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  img.Canvas.MoveTo(rt.Left,rt.Bottom);
  img.Canvas.LineTo(rt.Right,rt.Bottom);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Ñîõğàíèòü';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Ñîõğàíèòü êàê';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  img.Canvas.MoveTo(rt.Left,rt.Bottom);
  img.Canvas.LineTo(rt.Right,rt.Bottom);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Òåêñòîâûå øàáëîíû';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Ãğàôè÷åñêèå øàáëîíû';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  img.Canvas.MoveTo(rt.Left,rt.Bottom);
  img.Canvas.LineTo(rt.Right,rt.Bottom);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Äîáàâèòü òàéì-ëèíèş';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Óäàëèòü òàéì-ëèíèş';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Ğåäàêòèğîâàòü òàéì-ëèíèş';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  img.Canvas.MoveTo(rt.Left,rt.Bottom);
  img.Canvas.LineTo(rt.Right,rt.Bottom);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Ñïèñîê ãîğÿ÷èõ êëàâèø';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
  img.Canvas.MoveTo(rt.Left,rt.Bottom);
  img.Canvas.LineTo(rt.Right,rt.Bottom);
  rt.Top    := rt.Bottom;
  rt.Bottom := rt.Top + 25;
  stri := 'Âûõîä';
  DrawText(img.Canvas.Handle,stri,length(stri),rt,DT_VCENTER or DT_SINGLELINE);
end;

function ClickMainMenu(Y : integer) : integer;
begin
  result:=-1;
  if (Y>5) and (Y<30) then begin
    result:=0; //íîâûé
    exit;
  end;
  if (Y>30) and (Y<55) then begin
    result:=1; //îòêğûòü
    exit;
  end;
  if (Y>55) and (Y<80) then begin
    result:=2; //ñîõğàíèòü
    exit;
  end;
  if (Y>80) and (Y<105) then begin
    result:=3; //ñîõğàíèòü êàê
    exit;
  end;
  if (Y>105) and (Y<130) then begin
    result:=4; //òåêñòîâûå øàáëîíû
    exit;
  end;
  if (Y>130) and (Y<155) then begin
    result:=5; //ãğàôè÷åñêèå øàáëîíû
    exit;
  end;
  if (Y>155) and (Y<180) then begin
    result:=6; //Äîáàâèò òàéì-ëèíèş
    exit;
  end;
  if (Y>180) and (Y<205) then begin
    result:=7; //óäàëèòü òàéì-ëèíèş
    exit;
  end;
  if (Y>205) and (Y<230) then begin
    result:=8; //ğåäàêòèğîâà òàéì-ëèíèş
    exit;
  end;
  if (Y>230) and (Y<255) then begin
    result:=9; //âûõîä
    exit;
  end;
  if (Y>255) and (Y<280) then begin
    result:=10; //âûõîä
    exit;
  end;
end;

end.
