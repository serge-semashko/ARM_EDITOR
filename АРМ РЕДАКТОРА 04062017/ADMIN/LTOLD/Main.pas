unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, MMSystem;


type
  TData16 = array [0..127] of smallint;
  PData16 = ^TData16;
  TPointArr = array [0..127] of TPoint;
  PPointArr = ^TPointArr;
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    TrackBar1: TTrackBar;
    PaintBox1: TPaintBox;
    Label1: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     procedure OnWaveIn(var Msg: TMessage); message MM_WIM_DATA;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
var
  WaveIn: hWaveIn;
  hBuf, hBuf1: THandle;
  BufHead1, bufHead2, BufHead3, bufHead4 : TWaveHdr;
  adr2 :pwavehdr;
  bufsize: integer;
  Bits16: boolean;
  p: PPointArr;
  stop: boolean = false;
  pred, predzn, curr, cnt, cnt1, cnt2 : integer;

procedure TForm1.Button1Click(Sender: TObject);
var
  header: TWaveFormatEx;
  BufLen: word;
  buf, buf1: pointer;

begin
  label1.Caption:=inttostr(1 shl 16);
  memo1.Clear;
  BufSize := TrackBar1.Position * 500 + 100; { Размер буфера }
  with header do
  begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := 1; { количество каналов }
    nSamplesPerSec := 48000; { частота }
    wBitsPerSample := 16; { 8 / 16 бит }
    nBlockAlign := nChannels * (wBitsPerSample div 8);
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
    cbSize := 0;
  end;
  WaveInOpen(Addr(WaveIn), WAVE_MAPPER, addr(header), Form1.Handle, 0, CALLBACK_WINDOW);
  BufLen := header.nBlockAlign * BufSize;
  hBuf := GlobalAlloc(GMEM_MOVEABLE and GMEM_SHARE, BufLen);
  hBuf1 := GlobalAlloc(GMEM_MOVEABLE and GMEM_SHARE, BufLen);
  Buf := GlobalLock(hBuf);
  Buf1 := GlobalLock(hBuf1);
  with BufHead1 do
  begin
    lpData := Buf;
    dwBufferLength := BufLen;
    dwFlags := WHDR_BEGINLOOP;
  end;
  with BufHead2 do
  begin
    lpData := Buf1;
    dwBufferLength := BufLen;
    dwFlags := WHDR_BEGINLOOP;
  end;
//  with BufHead3 do
//  begin
//    lpData := Buf;
//    dwBufferLength := BufLen;
//    dwFlags := WHDR_BEGINLOOP;
//  end;
//  with BufHead4 do
//  begin
//    lpData := Buf;
//    dwBufferLength := BufLen;
//    dwFlags := WHDR_BEGINLOOP;
//  end;
  adr2:=@BufHead1;
  WaveInPrepareHeader(WaveIn, Addr(BufHead1), sizeof(BufHead1));
  WaveInPrepareHeader(WaveIn, Addr(BufHead2), sizeof(BufHead2));
  //WaveInPrepareHeader(WaveIn, Addr(BufHead3), sizeof(BufHead3));
  //WaveInPrepareHeader(WaveIn, Addr(BufHead4), sizeof(BufHead4));
  WaveInAddBuffer(WaveIn, addr(BufHead1), sizeof(BufHead1));
  GetMem(p, BufSize * sizeof(TPoint));
  stop := true;
  WaveInStart(WaveIn);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if stop = false then
    Exit;
  stop := false;
  while not stop do
    Application.ProcessMessages;
  stop := false;
  WaveInReset(WaveIn);
  WaveInUnPrepareHeader(WaveIn, addr(BufHead1), sizeof(BufHead1));
  WaveInUnPrepareHeader(WaveIn, addr(BufHead2), sizeof(BufHead2));
  //WaveInUnPrepareHeader(WaveIn, addr(BufHead3), sizeof(BufHead3));
  //WaveInUnPrepareHeader(WaveIn, addr(BufHead4), sizeof(BufHead4));
  WaveInClose(WaveIn);
  GlobalUnlock(hBuf);
  GlobalFree(hBuf);
  GlobalUnlock(hBuf1);
  GlobalFree(hBuf1);
  FreeMem(p, BufSize * sizeof(TPoint));
end;

procedure TForm1.OnWaveIn;
var
  i: integer;
  data16: PData16;
  h: integer;
  XScale, YScale: single;
  strs : string;
  temp: pWaveHdr;
begin
  temp:=adr2;
  if adr2=@BufHead1 then adr2:=@BufHead2
  else adr2:=@BufHead1;
  if stop then
    WaveInAddBuffer(WaveIn, adr2, SizeOf(TWaveHdr))
  else begin
    stop := true;
    exit;
  end;
  h := PaintBox1.Height;
  XScale := PaintBox1.Width / BufSize;
  strs:='';
  data16 := PData16(PWaveHdr(Msg.lParam)^.lpData);
  YScale := h / (1 shl 16);
  for i := 0 to BufSize - 1 do begin
    p^[i] := Point(round(i * XScale), round(h / 2 - data16^[i] * YScale));
    if (p^[i].Y > (h/2)) then curr:=1 else curr:=0;
    if pred=curr then cnt:=cnt+1
    else begin
      if cnt > 20 then begin
        strs:=strs+'0';
        predzn:=0;
        cnt:=0
      end else begin
        if predzn=0 then predzn:=1
        else begin
          strs:=strs+'1';
          predzn:=0;
        end;
        cnt:=0;
      end;
      pred:=curr;
    end;
  end;
  with PaintBox1.Canvas do
  begin
    Brush.Color := clWhite;
    FillRect(ClipRect);
    Polyline(Slice(p^, BufSize));
  end;

  memo1.Text:=memo1.Text + strs + '  |  ';
  //application.ProcessMessages;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Button2.Click;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if stop then
  begin
    Button2.Click;
    Button1.Click;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TrackBar1.OnChange := CheckBox1Click;
  Button1.Caption := 'Start';
  Button2.Caption := 'Stop';
  pred:=0;
  cnt:=0;
  predzn:=0;
  cnt1:=0
end;

end.
