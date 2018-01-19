unit UImageTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ExtDlgs, Buttons, JPEG, StdCtrls;

type
  TRectSelection = (rct, lftp, tp, tprt, rt, rtbt, bt, btlf, lf, rempt);

  TMyRect = class(TObject)
    private
      X0, Y0 : integer;
      Down : boolean;
      Selection : TRectSelection;
    public
    Color : tcolor;
    Penwidth : integer;
    Left : integer;
    Top : integer;
    Width : integer;
    Height : integer;
    rectlftp : trect;
    recttp : trect;
    recttprt : trect;
    rectrt : trect;
    rectrtbt : trect;
    rectbt : trect;
    rectbtlf : trect;
    rectlf : trect;
    procedure MoveMouse(cv : tcanvas; X,Y : integer);
    procedure DownMouse(cv : tcanvas; X,Y : integer);
    procedure UpMouse(cv : tcanvas; X,Y : integer);
    procedure Draw(cv : tcanvas);
    procedure Resize(txt : string; Border : trect);
    function Rect : trect;
    constructor Create;
    destructor Destroy;  override;
  end;

  TFGRTemplate = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    ComboBox1: TComboBox;
    Panel4: TPanel;
    Bevel1: TBevel;
    Image2: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Layer1: TImage;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    procedure SetSizeLayer1;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Layer1Click(Sender: TObject);
    procedure Layer1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Layer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Layer1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    CRow : integer;
    CurrFilename : string;
    FileLoad : boolean;
  public
    { Public declarations }
    BKGN : tcolor;
  end;

var
  FGRTemplate: TFGRTemplate;
  ImgRect : TRect;
  bm: TBitMap;
  Msht : Real;

  MyRect : TMyRect;

  procedure DrawTemplate;
  procedure EditImageTamplate(ARow : integer);
  procedure LoadJpegFile1(cv : tcanvas; FileName : string);

implementation

uses umain, ucommon, umymessage, ugrid, uinitforms;

{$R *.dfm}

procedure EditImageTamplate(ARow : integer);
begin
  if trim(TempGRTemplates) = '' then TempGRTemplates:='TMP' + createunicumname + '.gtmp';
  FGRTemplate.Image1.Canvas.Brush.Style:=bsSolid;
  FGRTemplate.Image1.Canvas.Brush.Color:=FGRTemplate.BKGN;
  FGRTemplate.Image1.Canvas.FillRect(FGRTemplate.Image1.Canvas.ClipRect);
  FGRTemplate.Image1.Repaint;
  FGRTemplate.CRow:=ARow;
  if FGRTemplate.CRow = -1 then begin
    FGRTemplate.CurrFilename := '';
    FGRTemplate.Label2.Caption := 'Новый шаблон';
    FGRTemplate.FileLoad := false;
    FGRTemplate.Edit1.Text:='';
    FGRTemplate.Image1.Canvas.FillRect(FGRTemplate.Image1.Canvas.ClipRect);
    FGRTemplate.Image2.Canvas.FillRect(FGRTemplate.Image2.Canvas.ClipRect);
  end else begin
    FGRTemplate.CurrFilename := (Form1.GridLists.Objects[0,FGRTemplate.CRow] as TGridRows).MyCells[1].ReadPhrase('File');
    FGRTemplate.Edit1.Text:=(Form1.GridLists.Objects[0,FGRTemplate.CRow] as TGridRows).MyCells[2].ReadPhrase('Template');
    FGRTemplate.Label2.Caption := 'Редактирование шаблона';
    if fileexists(AppPath + dirimages + '\' + FGRTemplate.CurrFilename) then begin

      //FGRTemplate.image1.Picture.Bitmap.Canvas.FillRect(FGRTemplate.Image1.Canvas.ClipRect);
      LoadJpegFile1(FGRTemplate.Image1.Canvas,AppPath + dirimages + '\' + FGRTemplate.CurrFilename);
      FGRTemplate.Label2.Caption := FGRTemplate.CurrFilename;
      FGRTemplate.FileLoad := true;
    end;
    //MyRect.Resize(FGRTemplate.ComboBox1.Text,FGRTemplate.Layer1.Canvas.ClipRect);
    MyRect.Left:=imgRect.Left;
    MyRect.Top:=imgRect.Top;
    MyRect.Width:=imgRect.Right-imgrect.Left;
    MyRect.Height:=imgRect.Bottom-imgrect.Top;
    MyRect.Draw(FGRTemplate.Layer1.Canvas);
    DrawTemplate;
  end;
  FGRTemplate.ShowModal;
  if FGRTemplate.ModalResult=mrOk then begin
  end;
end;

procedure SaveToJpegFile(FileName : string);
var
   oJPEG : TJPEGImage;
   img, bmp : tbitmap;
   rt : trect;
begin
  bmp := tbitmap.Create;
  try
  if FGRTemplate.ComboBox1.Text='16x9' then begin
    bmp.Width:=1920;
    bmp.Height:=1080;
  end else begin
    bmp.Width:=1440;
    bmp.Height:=1080;
  end;
  img := TBitmap.Create;
  try
  img.PixelFormat:=pf24bit;
  img.Width:=trunc(MyRect.Width * Msht);
  img.Height:=trunc(MyRect.Height * Msht);
  rt.Left:=trunc((MyRect.Left - ImgRect.Left) * Msht);
  rt.Right:=rt.Left + img.Width;
  rt.Top:=trunc((MyRect.Top - ImgRect.Top) * Msht);
  rt.Bottom:=rt.Top + img.Height;
  bitblt(img.Canvas.Handle, 0, 0, img.Width, img.Height,bm.Canvas.Handle, rt.Left, rt.Top , SRCCOPY);
  bmp.Canvas.StretchDraw(bmp.Canvas.ClipRect,img);
  oJPEG := TJPEGImage.Create;
  try
    oJPEG.Assign(bmp);
    oJPEG.SaveToFile(FileName);
  finally
    oJPEG.Free;
  end
  finally
    img.Free;
  end;
  finally
    bmp.Free;
  end;
end;

function WidthFromHeight(txt : string; hgh : integer) : integer;
begin
  if trim(txt) = '16x9' then result:=trunc(hgh / 9 * 16);
  if trim(txt) = '4x3' then result:=trunc(hgh / 3 * 4);
end;

function HeightFromWidth(txt : string; wdt : integer) : integer;
begin
  if trim(txt) = '16x9' then result:=trunc(wdt / 16 * 9);
  if trim(txt) = '4x3' then result:=trunc(wdt / 4 * 3);
end;

procedure TMyRect.Resize(txt : string; Border : trect);
var mtp, mlf, mrt, mbt, wdt, hgh, mwdt, mhgh : integer;
begin
  //mhgh:=Height;
  mwdt:=Width;
  mhgh := heightfromwidth(txt, mwdt);
  if mhgh < Height then begin
    Height:=mhgh;
    exit;
  end;
  if Top + mhgh > Border.Bottom then begin
    Height:=Border.Bottom - Top;
    mwdt:=widthfromheight(txt, Height);
    Left:=Left + (Width - mwdt) div 2;
    Width := mwdt;
    exit;
  end;
  Height:=mhgh;
end;

Constructor TMyRect.Create;
begin
  inherited;
  Color := $929292;//clOlive;
  PenWidth := 2;
  Left := 0;
  Top := 0;
  Width := 160;
  Height := 90;

  rectlftp.Left := 0;
  rectlftp.Right := 0;
  rectlftp.Top := 0;
  rectlftp.Bottom := 0;

  recttp.Left := 0;
  recttp.Right := 0;
  recttp.Top := 0;
  recttp.Bottom := 0;

  recttprt.Left := 0;
  recttprt.Right := 0;
  recttprt.Top := 0;
  recttprt.Bottom := 0;

  rectrt.Left := 0;
  rectrt.Right := 0;
  rectrt.Top := 0;
  rectrt.Bottom := 0;

  rectrtbt.Left := 0;
  rectrtbt.Right := 0;
  rectrtbt.Top := 0;
  rectrtbt.Bottom := 0;

  rectbt.Left := 0;
  rectbt.Right := 0;
  rectbt.Top := 0;
  rectbt.Bottom := 0;

  rectbtlf.Left := 0;
  rectbtlf.Right := 0;
  rectbtlf.Top := 0;
  rectbtlf.Bottom := 0;

  rectlf.Left := 0;
  rectlf.Right := 0;
  rectlf.Top := 0;
  rectlf.Bottom := 0;

end;

Destructor TMyRect.Destroy;
begin
  FreeMem(@Color);
  FreeMem(@PenWidth);
  FreeMem(@Left);
  FreeMem(@Top);
  FreeMem(@Width);
  FreeMem(@Height);
  FreeMem(@rectlftp);
  FreeMem(@recttp);
  FreeMem(@recttprt);
  FreeMem(@rectrt);
  FreeMem(@rectrtbt);
  FreeMem(@rectbt);
  FreeMem(@rectbtlf);
  FreeMem(@rectlf);
  inherited;
end;

function TMyRect.Rect : TRect;
var mwdt, mhgh  : integer;
begin
  Resize(FGRTemplate.ComboBox1.Text, FGRTemplate.Layer1.Canvas.ClipRect);
  Result.Left:=Left;
  Result.Top:=Top;
  Result.Right:=Result.Left + Width;
  Result.Bottom:=Result.Top + Height;
end;

procedure TMyRect.Draw(cv : tcanvas);
var pw, ph : integer;
begin
  pw := Width div 2;
  ph := Height div 2;

  //SetSizeLayer1;
  cv.FillRect(cv.ClipRect);
  //cv.Pen.Color := Color;
  cv.Pen.Color:=SmoothColor(FGRTemplate.Image1.Canvas.Pixels[Left,top],128);
  cv.Pen.Width := PenWidth;
  cv.Rectangle(MyRect.Rect);

  rectlftp.Left := Left - 2;
  rectlftp.Right := Left + 4;
  rectlftp.Top := Top - 2;
  rectlftp.Bottom := Top + 4;
  cv.Rectangle(rectlftp);

  recttp.Left := Left + pw - 3;
  recttp.Right := Left + pw + 3;
  recttp.Top := Top - 2;
  recttp.Bottom := Top + 4;
  cv.Rectangle(recttp);

  recttprt.Left := Left + Width - 4;
  recttprt.Right := Left + Width + 2;
  recttprt.Top := Top - 2;
  recttprt.Bottom := Top + 4;
  cv.Rectangle(recttprt);

  rectrt.Left := Left + Width - 4;
  rectrt.Right := Left + Width + 2;
  rectrt.Top := Top + ph - 3;
  rectrt.Bottom := Top + ph + 3;
  cv.Rectangle(rectrt);

  rectrtbt.Left := Left + Width - 4;
  rectrtbt.Right := Left + Width + 2;
  rectrtbt.Top := Top + Height - 4;
  rectrtbt.Bottom := Top + Height + 2;
  cv.Rectangle(rectrtbt);

  rectbt.Left := Left + pw - 4;
  rectbt.Right := Left + pw + 2;
  rectbt.Top := Top + Height - 4;
  rectbt.Bottom := Top + Height + 2;
  cv.Rectangle(rectbt);

  rectbtlf.Left := Left - 2;
  rectbtlf.Right := Left + 4;
  rectbtlf.Top := Top + Height - 4;
  rectbtlf.Bottom := Top + Height + 2;
  cv.Rectangle(rectbtlf);

  rectlf.Left := Left - 2;
  rectlf.Right := Left + 4;
  rectlf.Top := Top + ph - 4;
  rectlf.Bottom := Top + ph + 2;
  cv.Rectangle(rectlf);

end;

function PointInRect(Rect : trect; X,Y : integer) : boolean;
begin
  result := false;
  if (X >= Rect.Left) and (X <= Rect.Right) and (Y  <= Rect.Bottom) and (Y >= Rect.Top) then result:=true;
end;

function GetSizeRect(txt : string; wdt, hgh : integer) : tpoint;
begin
  if wdt > hgh then begin
    Result.X:=wdt;
    Result.Y:=heightfromwidth(FGRTemplate.ComboBox1.Text, wdt);
  end else begin
    Result.Y:=hgh;
    Result.X:=widthfromheight(FGRTemplate.ComboBox1.Text, hgh);
  end;
end;

procedure TMyRect.MoveMouse(cv : tcanvas; X,Y : integer);
var  mlf, mtp, mrt, mbt, mwdt, mhgh, dltx, dlty, dltx1, dlty1 : integer;
     pt : tpoint;
begin
    if not Down then begin
      FGRTemplate.Layer1.Cursor:=crDefault;
      if PointInRect(Rect,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeAll;
      if PointInRect(rectlftp,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNWSE;
      if PointInRect(recttp,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNS;
      if PointInRect(recttprt,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNESW;
      if PointInRect(rectrt,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeWE;
      if PointInRect(rectrtbt,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNWSE;
      if PointInRect(rectbt,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNS;
      if PointInRect(rectbtlf,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeNESW;
      if PointInRect(rectlf,X,Y) then FGRTemplate.Layer1.Cursor:=crSizeWE;
    end else begin
      if X < cv.ClipRect.Left then X := cv.ClipRect.Left;
      if X > cv.ClipRect.Right then X := cv.ClipRect.Right;
      if Y < cv.ClipRect.Top then Y := cv.ClipRect.Top;
      if Y > cv.ClipRect.Bottom then Y := cv.ClipRect.Bottom;
      dltx := X - X0;
      dlty := Y - Y0;

           case Selection of
      rct   : begin
                mlf := Left + dltx;
                mtp := Top + dlty;
                if mlf < cv.ClipRect.Left then mlf := cv.ClipRect.Left;
                if mtp < cv.ClipRect.Top then mtp := cv.ClipRect.Top;
                if mlf + Width > cv.ClipRect.Right then mlf := Left;
                if mtp + Height > cv.ClipRect.Bottom then mtp := Top;
                Left:=mlf;
                Top:=mtp;
              end;
      lftp  : begin
                mrt := Left + Width;
                mbt := Top + Height;
                pt:=GetSizeRect(FGRTemplate.ComboBox1.Text, mrt - X, mbt - Y);
                mwdt:=pt.X;
                mhgh:=pt.Y;
                Left:=mrt - mwdt;
                Top:=mbt - mhgh;
                Width:=mwdt;
                Height:=mhgh;
              end;
      tp    : begin
                mbt := Top + Height;
                mtp := Y;
                mhgh := mbt - Y;
                mwdt := widthfromheight(FGRTemplate.ComboBox1.Text, mhgh);
                if mwdt > (cv.ClipRect.Right-cv.ClipRect.Left) then begin
                  mwdt := (cv.ClipRect.Right-cv.ClipRect.Left);
                  mhgh := heightfromwidth(FGRTemplate.ComboBox1.Text, mwdt);
                  mtp:=mbt-mhgh;
                end;
                if (X - mwdt div 2) < cv.ClipRect.Left
                  then mlf := cv.ClipRect.Left else mlf := X - mwdt div 2;
                if (X + mwdt div 2) > cv.ClipRect.Right
                  then mlf := cv.ClipRect.Right - mwdt;
                Left:=mlf;
                Top:=mtp;
                Width:=mwdt;
                Height:=mhgh;
              end;
      tprt  : begin
                mbt:=Top+Height;
                mlf:=Left;
                pt:=GetSizeRect(FGRTemplate.ComboBox1.Text, X - mlf, mbt - Y);
                mwdt:=pt.X;
                mhgh:=pt.Y;
                Left:=mlf;
                Top:=mbt - mhgh;
                Width:=mwdt;
                Height:=mhgh;
              end;
      rt    : begin
                mlf := Left;
                mwdt := X - Left;
                mhgh := heightfromwidth(FGRTemplate.ComboBox1.Text, mwdt);
                if mhgh > (cv.ClipRect.Right-cv.ClipRect.Left) then begin
                  mhgh := (cv.ClipRect.Right-cv.ClipRect.Left);
                  mwdt := widthfromheight(FGRTemplate.ComboBox1.Text, mhgh);
                end;
                if (Y - mhgh div 2) < cv.ClipRect.Top
                  then mtp := cv.ClipRect.Top else mtp := Y - mhgh div 2;
                if (Y + mhgh div 2) > cv.ClipRect.Bottom
                  then mtp := cv.ClipRect.Bottom - mhgh;
                Left:=mlf;
                Top:=mtp;
                Width:=mwdt;
                Height:=mhgh;
              end;
      rtbt  : begin
                pt:=GetSizeRect(FGRTemplate.ComboBox1.Text, X - Left, Y - Top);
                Width:=pt.X;
                Height:=pt.Y;
              end;
      bt    : begin
                mhgh:=Y-Top;
                mwdt := widthfromheight(FGRTemplate.ComboBox1.Text, mhgh);
                if mwdt > (cv.ClipRect.Right-cv.ClipRect.Left) then begin
                  mwdt := (cv.ClipRect.Right-cv.ClipRect.Left);
                  mhgh := heightfromwidth(FGRTemplate.ComboBox1.Text, mwdt);
                end;
                if (X - mwdt div 2) < cv.ClipRect.Left
                  then mlf := cv.ClipRect.Left else mlf := X - mwdt div 2;
                if (X + mwdt div 2) > cv.ClipRect.Right
                  then mlf := cv.ClipRect.Right - mwdt;
                Left:=mlf;
                Width:=mwdt;
                Height:=mhgh;
              end;
      btlf  : begin
                //mtp:=Top;
                mrt:=Left+Width;
                pt:=GetSizeRect(FGRTemplate.ComboBox1.Text, mrt - X, Y - Top);
                mwdt:=pt.X;
                mhgh:=pt.Y;
                Left:=mrt - mwdt;
                Width:=mwdt;
                Height:=mhgh;
              end;
      lf    : begin
                mrt:=Left+Width;
                mwdt := mrt - X;
                mhgh := heightfromwidth(FGRTemplate.ComboBox1.Text, mwdt);
                if mhgh > (cv.ClipRect.Right-cv.ClipRect.Left) then begin
                  mhgh := (cv.ClipRect.Right-cv.ClipRect.Left);
                  mwdt := widthfromheight(FGRTemplate.ComboBox1.Text, mhgh);
                end;
                if (Y - mhgh div 2) < cv.ClipRect.Top
                  then mtp := cv.ClipRect.Top else mtp := Y - mhgh div 2;
                if (Y + mhgh div 2) > cv.ClipRect.Bottom
                  then mtp := cv.ClipRect.Bottom - mhgh;
                Left:=mrt-mwdt;
                Top:=mtp;
                Width:=mwdt;
                Height:=mhgh;
              end;
      rempt : exit;
           end;


      Draw(cv);
      DrawTemplate;

      X0:=X;
      Y0:=Y;
    end;
end;

procedure TMyRect.DownMouse(cv : tcanvas; X,Y : integer);
begin
  Selection:=rempt;
  if PointInRect(Rect,X,Y) then Selection:=rct;
  if PointInRect(rectlftp,X,Y) then Selection:=lftp;
  if PointInRect(recttp,X,Y) then Selection:=tp;
  if PointInRect(recttprt,X,Y) then Selection:=tprt;
  if PointInRect(rectrt,X,Y) then Selection:=rt;
  if PointInRect(rectrtbt,X,Y) then Selection:=rtbt;
  if PointInRect(rectbt,X,Y) then Selection:=bt;
  if PointInRect(rectbtlf,X,Y) then Selection:=btlf;
  if PointInRect(rectlf,X,Y) then Selection:=lf;
  Down:=true;
  X0:=X;
  Y0:=Y;
end;

procedure TMyRect.UpMouse(cv : tcanvas; X,Y : integer);
begin
  Down:=false;
  Selection:=rempt;
end;

procedure DrawTemplate;
var rt : trect;
    img : tbitmap;
begin
  img := tbitmap.Create;
  img.PixelFormat:=pf24bit;

  img.Width:=trunc(MyRect.Width * Msht);
  img.Height:=trunc(MyRect.Height * Msht);
  rt.Left:=trunc((MyRect.Left - ImgRect.Left) * Msht);
  rt.Right:=rt.Left + img.Width;

  rt.Top:=trunc((MyRect.Top - ImgRect.Top) * Msht);
  rt.Bottom:=rt.Top + img.Height;

  bitblt(img.Canvas.Handle, 0, 0, img.Width, img.Height,bm.Canvas.Handle, rt.Left, rt.Top , SRCCOPY);
  FGRTemplate.Image2.Canvas.StretchDraw(FGRTemplate.Image2.Canvas.ClipRect,img);
  img.Destroy;
end;

procedure InitRectFrame(text : string);
var wdth, hght, dlt : integer;
    mnx, mny : integer;
begin
  if text='16x9' then begin
    mnx := 16;
    mny := 9;
  end;

  if text='4x3' then begin
    mnx := 4;
    mny := 3;
  end;

  wdth := ImgRect.Right-ImgRect.Left;
  hght := ImgRect.Bottom - ImgRect.Top;

  if wdth >= hght then begin
     dlt := wdth div mnx * mny;
     if dlt < hght then hght:=dlt else wdth:=hght div mny * mnx;
  end else begin
     dlt := hght div mny * mnx;
     if dlt < wdth then wdth:=dlt else hght:=wdth div mnx * mny;
  end;

end;

Procedure SetSizeFrame(text : string);
var wdth, hght : integer;
begin
    //FGRTemplate.Bevel1.Top:=FGRTemplate.Panel4.Top+5;
    if text='16x9' then begin
      FGRTemplate.Bevel1.Width:=FGRTemplate.Panel4.Width-10;
      FGRTemplate.Bevel1.Height:=trunc(FGRTemplate.Bevel1.Width / 16 * 9);
      FGRTemplate.Bevel1.Left:=5;
      FGRTemplate.Bevel1.Top:={FGRTemplate.Panel4.Top + }((FGRTemplate.Panel4.Height - FGRTemplate.Bevel1.Height) div 2);
    end;
    if text='4x3' then begin
      FGRTemplate.Bevel1.Height:=FGRTemplate.Panel4.Height-10;
      FGRTemplate.Bevel1.Width:=trunc(FGRTemplate.Bevel1.Height / 3 * 4);
      FGRTemplate.Bevel1.Top:=5;
      FGRTemplate.Bevel1.Left:=FGRTemplate.Panel4.left + ((FGRTemplate.Panel4.Width - FGRTemplate.Bevel1.Width) div 2);
    end;
    FGRTemplate.Image2.Left:=FGRTemplate.Bevel1.Left+5;
    FGRTemplate.Image2.Width:=FGRTemplate.Bevel1.Width - 10;
    FGRTemplate.Image2.Top:=FGRTemplate.Bevel1.Top+5;
    FGRTemplate.Image2.Height:=FGRTemplate.Bevel1.Height -10;
    FGRTemplate.Image2.Picture.Bitmap.Width:=FGRTemplate.Image2.Width;
    FGRTemplate.Image2.Picture.Bitmap.Height:=FGRTemplate.Image2.Height;
end;

procedure DrawPicture(cv : tcanvas; bmp : TBitmap);
var
  wdth,hght,bwdth,bhght : integer;
  dlt : real;
begin
  //bwdth := bmp.Width;
  //bhght := bmp.Height;
  //cv.Brush.Color:=;
  cv.FillRect(cv.ClipRect);
  wdth := cv.ClipRect.Right - cv.ClipRect.Left;
  hght := cv.ClipRect.Bottom - cv.ClipRect.Top;
  if bmp.Width >= bmp.Height then begin
    Msht:=bmp.Width / wdth;
    if hght * Msht < bmp.Height then Msht := bmp.Height / hght;
  end else begin
    Msht:=bmp.Height / hght;
    if wdth * Msht < bmp.Width then Msht := bmp.Width / wdth;
  end;

  bwdth:=round(bmp.Width / Msht);
  bhght:=round(bmp.Height / Msht);
  imgRect.Left:=cv.ClipRect.Left + ((wdth - bwdth) div 2);
  imgRect.Right:=imgRect.Left + bwdth;
  imgRect.Top:=cv.ClipRect.Top + ((hght - bhght) div 2);
  imgRect.Bottom:=imgRect.Top + bhght;
  cv.StretchDraw(imgRect, bmp);
end;

procedure TFGRTemplate.SetSizeLayer1;
begin
  with FGRTemplate do begin
    Layer1.Left:=Image1.Left;
    Layer1.Width:=Image1.Width;
    Layer1.Top:=Image1.Top;
    Layer1.Height:=Image1.Height;
    Image1.Picture.Bitmap.Width:=Image1.Width;
    Image1.Picture.Bitmap.Height:=Image1.Height;
    Layer1.Picture.Bitmap.Width:=Layer1.Width;
    Layer1.Picture.Bitmap.Height:=Layer1.Height;
    Layer1.Canvas.Brush.Style:=bsClear;
    Layer1.Canvas.Brush.Color:=Layer1.Picture.Bitmap.TransparentColor;
    Layer1.Canvas.FillRect(Layer1.Canvas.ClipRect);
  end;
end;

procedure TFGRTemplate.FormCreate(Sender: TObject);
begin
  InitImageTemplate;
  MyRect:=TMyRect.Create;
  MyRect.Left:=50;
  MyRect.Top:=50;
  MyRect.Width:=320;
  MyRect.Height:=heightfromwidth(ComboBox1.Text, MyRect.Width);
  bm := TBitMap.Create;
  bm.PixelFormat := pf24bit;
  SetSizeFrame(ComboBox1.Text);
  SetSizeLayer1;
  MyRect.Draw(Layer1.Canvas);
end;

procedure TFGRTemplate.FormResize(Sender: TObject);
begin
  Image1.Picture.Bitmap.Width:=Image1.Width;
  Image1.Picture.Bitmap.Height:=Image1.Height;
  Image1.Canvas.Brush.Color:=BKGN;
  SetSizeLayer1;
  if bm.Width > 0 then begin
    DrawPicture(Image1.Canvas, bm);
    InitRectFrame(ComboBox1.Text);
    Image1.Canvas.Brush.Style:=bsClear;
    Image1.Canvas.Pen.Width:=2;
    Image1.Canvas.Pen.Color:=clGray;
    DrawTemplate;
  end;
end;

procedure LoadJpegFile1(cv : tcanvas; FileName : string);
var
  JpegIm: TJpegImage;
  wdth,hght,bwdth,bhght : integer;
  dlt : real;
begin
  try
    bm.FreeImage;
    JpegIm := TJpegImage.Create;
    JpegIm.LoadFromFile(FileName);
    bm.Assign(JpegIm);
    DrawPicture(cv, bm);
    cv.Brush.Style:=bsClear;
    DrawTemplate;
    JpegIm.Destroy;
  except
  end;
end;


procedure TFGRTemplate.SpeedButton1Click(Sender: TObject);
begin
  If opendialog1.Execute then begin
     //Image1.Canvas.Brush.Style:=bsSolid;
     //Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
     //Image1.Repaint;
     //image1.Picture.Bitmap.Canvas.FillRect(Image1.Canvas.ClipRect);
     LoadJpegFile1(Image1.Canvas,OpenDialog1.FileName);
     FileLoad := true;
     Layer1.Canvas.Brush.Style:=bsSolid;
     Layer1.Canvas.Pen.Mode:=pmCopy;
     Layer1.Canvas.FillRect(Layer1.Canvas.ClipRect);
     MyRect.Draw(Layer1.Canvas);
     MyRect.Resize(ComboBox1.Text,Layer1.Canvas.ClipRect);
     MyRect.Draw(Layer1.Canvas);
  end;
end;

procedure TFGRTemplate.FormDestroy(Sender: TObject);
begin
  bm.Destroy;
end;

procedure TFGRTemplate.ComboBox1Change(Sender: TObject);
begin
  SetSizeFrame(ComboBox1.Text);
  MyRect.Resize(ComboBox1.Text,Layer1.Canvas.ClipRect);
  MyRect.Draw(Layer1.Canvas);
  if bm.Width > 0 then begin
    DrawPicture(Image1.Canvas, bm);
    InitRectFrame(ComboBox1.Text);
    DrawTemplate;
    Layer1.Canvas.Refresh;
  end;
end;


procedure TFGRTemplate.Layer1Click(Sender: TObject);
begin
  MyRect.Draw(Layer1.Canvas);
end;

procedure TFGRTemplate.Layer1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MyRect.UpMouse(Layer1.Canvas, X, Y);
end;

procedure TFGRTemplate.Layer1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MyRect.DownMouse(Layer1.Canvas, X, Y);
end;

procedure TFGRTemplate.Layer1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var dltx, dlty : integer;
    nm : string;
begin
  MyRect.MoveMouse(Layer1.Canvas, X,Y);
end;

procedure TFGRTemplate.SpeedButton2Click(Sender: TObject);
var rw : integer;
    nm : string;
    fs : tfilestream;
begin
  if not FileLoad then begin
    MyTextMessage('','Шаблон не содержит графических данных',1);
    ActiveControl:=Edit1;
    exit;
  end;
  if trim(Edit1.Text) = '' then begin
    MyTextMessage('','Не заданы текстовые данные',1);
    ActiveControl:=Edit1;
    exit;
  end;
  if CRow=-1 then begin
    rw := GridAddRow(Form1.GridLists, RowGridListGR);
    IDGRTmp := IDGRTmp + 1;
    (Form1.GridLists.Objects[0,rw] as TGridRows).ID:=IDGRTmp;
    (Form1.GridLists.Objects[0,rw] as TGridRows).MyCells[1].UpdatePhrase('File',createunicumname + '.jpeg');
    (Form1.GridLists.Objects[0,rw] as TGridRows).MyCells[2].UpdatePhrase('File',createunicumname + '.jpeg');
    (Form1.GridLists.Objects[0,rw] as TGridRows).MyCells[2].UpdatePhrase('Template',Trim(Edit1.Text));
    nm := AppPath + DirImages + '\' + createunicumname + '.jpeg';
    SaveToJpegFile(nm);
    (Form1.GridLists.Objects[0,rw] as TGridRows).MyCells[1].LoadJpeg(nm,Form1.GridLists.ColWidths[1],Form1.GridLists.RowHeights[rw]);
    Edit1.Text:='';
    if MyTextMessage('','Шаблон сохранен. Для выхода нажмите [Да], для продолжения создания шаблонов нажмите [Нет].',2)
      then ModalResult:=mrOk;
  end else begin
    (Form1.GridLists.Objects[0,CRow] as TGridRows).MyCells[2].UpdatePhrase('Template',Trim(Edit1.Text));
    if FileExists(AppPath + DirImages + '\' + CurrFilename)
      then renamefile(AppPath + DirImages + '\' + CurrFilename, AppPath + DirImages + '\Temp.tmp');
    SaveToJpegFile(AppPath + DirImages + '\' + CurrFilename);
    (Form1.GridLists.Objects[0,CRow] as TGridRows).MyCells[1].LoadJpeg(AppPath + DirImages + '\' + CurrFilename
                                                                     ,Form1.GridLists.ColWidths[1],Form1.GridLists.RowHeights[rw]);
    if FileExists(AppPath + DirImages + '\Temp.tmp') then DeleteFile(AppPath + DirImages + '\Temp.tmp');
    ModalResult:=mrOk;
  end

end;

procedure TFGRTemplate.SpeedButton3Click(Sender: TObject);
begin
  Modalresult:=mrOk;
end;

end.


