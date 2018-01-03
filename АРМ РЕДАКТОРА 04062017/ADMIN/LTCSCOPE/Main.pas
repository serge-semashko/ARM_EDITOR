unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, MMSystem, Menus;

CONST
   WM_TRANSFER = WM_USER + 1;  // Определяем сообщение
   WM_MYICONNOTIFY = WM_USER + 777;


type
  PCompartido =^TCompartido;
  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero    : Integer;
    Shift     : Double;
    Cadena    : String[20];
  end;

(*  -------------------------------------- *)


type
  TData16 = array [0..127] of smallint;
  PData16 = ^TData16;
  TPointArr = array [0..127] of TPoint;
  PPointArr = ^TPointArr;
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PaintBox1: TPaintBox;
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    PopupMenu1: TPopupMenu;
    RestoreItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem1: TMenuItem;
    N2: TMenuItem;
    HideItem: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RestoreItemClick(Sender: TObject);
    procedure HideItemClick(Sender: TObject);
    procedure FileExitItem1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    ShownOnce: Boolean;
    Compartido : PCompartido;
    FicheroM   : THandle;
  public
    { Public declarations }
    procedure OnWaveIn(var Msg: TMessage); message MM_WIM_DATA;
    procedure WMICON(var msg: TMessage); message WM_MYICONNOTIFY;
    procedure WMSYSCOMMAND(var msg: TMessage); message WM_SYSCOMMAND;
    procedure RestoreMainForm;
    procedure HideMainForm;
    procedure CreateTrayIcon(n: Integer);
    procedure DeleteTrayIcon(n: Integer);
  end;

var
  Form1: TForm1;
  myShift : double = 0;
  myshiftsample : double = 0;
  oldShiftFrames : longint;
  counterror : integer = 0;
  bufframes : integer = 3;
  LastSample : integer = -1;
  CountSample : integer = 0;
  CountOnes : integer = 0;
  CountZero : integer = 0;
  ValueSample : byte = 0;
  buff1, buff2 : array[0..160] of byte;
  buffpos, buffact :integer;
  TCExists : boolean = false;
  IsFront : boolean = false;
  StartCount : boolean = false;

  WaveIn: hWaveIn;
  hBuf, hBuf1: THandle;
  BufHead1, bufHead2, BufHead3, bufHead4 : TWaveHdr;
  adr2 :pwavehdr;
  bufsize: integer;
  Bits16: boolean;
  p: PPointArr;
  stop: boolean = false;
  pred : integer = 0;
  curr : integer = 0;
  predzn, cnt, cnt1, cnt2 : integer;

  cntrec : longint;
  OneSample : integer;
  OneFrames : string;

  CloseApplication : boolean = false;

implementation
uses ShellApi, shlobj, registry;

{$R *.dfm}

function UniqueApp :Boolean;
Var HM :THandle;
begin
  HM:=CreateMutex(nil, False, PChar(Application.Title));
  Result:=GetLastError<>ERROR_ALREADY_EXISTS;
end;

Procedure AutoStartEnable;
var reg : tRegistry;
begin
  reg := TRegistry.Create();
  try
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) then begin
    reg.WriteString( Application.Title, Application.ExeName);
    reg.CloseKey();
  end;
  finally
    reg.Free;
  end;
end;

Procedure AutoStartDisable;
var reg : tRegistry;
begin
  reg := TRegistry.Create();
  try
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False) then begin
    reg.DeleteValue( Application.Title );
    reg.CloseKey();
  end;
  finally
    reg.Free;
  end;
end;

function CheckAutoStart : boolean;
var reg : tregistry;
begin
  result := false;
  reg := TRegistry.Create();
  try
  reg.RootKey := HKEY_CURRENT_USER;
  if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False) then begin
    if reg.ValueExists(Application.Title) then begin
      result := true;
    end;
    reg.CloseKey();
  end;
  finally
    reg.Free;
  end;
end;

procedure TForm1.WMICON(var msg: TMessage);
var
  P: TPoint;
begin
  case msg.LParam of
    WM_LBUTTONUP:
      begin
        GetCursorPos(p);
        SetForegroundWindow(Application.MainForm.Handle);
        PopupMenu1.Popup(P.X, P.Y);
      end;
    WM_LBUTTONDBLCLK: RestoreItemClick(Self);
  end;
end;

procedure TForm1.WMSYSCOMMAND(var msg: TMessage);
begin
  inherited;
  if (Msg.wParam = SC_MINIMIZE) then
    HideItemClick(Self);
end;

procedure TForm1.HideMainForm;
begin
  Application.ShowMainForm := False;
  ShowWindow(Application.Handle, SW_HIDE);
  ShowWindow(Application.MainForm.Handle, SW_HIDE);
end;

procedure TForm1.RestoreMainForm;
var
  i, j: Integer;
begin
  Application.ShowMainForm := True;
  ShowWindow(Application.Handle, SW_RESTORE);
  ShowWindow(Application.MainForm.Handle, SW_RESTORE);
  if not ShownOnce then
  begin
    for I := 0 to Application.MainForm.ComponentCount - 1 do
      if Application.MainForm.Components[I] is TWinControl then
        with Application.MainForm.Components[I] as TWinControl do
          if Visible then
          begin
            ShowWindow(Handle, SW_SHOWDEFAULT);
            for J := 0 to ComponentCount - 1 do
              if Components[J] is TWinControl then
                ShowWindow((Components[J] as TWinControl).Handle,
                  SW_SHOWDEFAULT);
          end;
    ShownOnce := True;
  end;

end;

procedure TForm1.CreateTrayIcon(n: Integer);
var
  nidata: TNotifyIconData;
begin
  with nidata do
  begin
    cbSize := SizeOf(TNotifyIconData);
    Wnd := Self.Handle;
    uID := 1;
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uCallBackMessage := WM_MYICONNOTIFY;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, Application.Title);
  end;
  Shell_NotifyIcon(NIM_ADD, @nidata);
end;

procedure TForm1.DeleteTrayIcon(n: Integer);
var
  nidata: TNotifyIconData;
begin
  with nidata do
  begin
    cbSize := SizeOf(TNotifyIconData);
    Wnd := Self.Handle;
    uID := 1;
  end;
  Shell_NotifyIcon(NIM_DELETE, @nidata);
end;

function iskeyword(abuff, posi : integer) : boolean;
begin
  result := false;
  if posi<15 then exit;
  if abuff=1 then begin
    if (buff1[posi]=1) and (buff1[posi-1]=0) and (buff1[posi-2]=1) and (buff1[posi-3]=1)
      and (buff1[posi-4]=1) and (buff1[posi-5]=1) and (buff1[posi-6]=1) and (buff1[posi-7]=1)
      and (buff1[posi-8]=1) and (buff1[posi-9]=1) and (buff1[posi-10]=1) and (buff1[posi-11]=1)
      and (buff1[posi-12]=1) and (buff1[posi-13]=1) and (buff1[posi-14]=0) and (buff1[posi-15]=0)
    then result := true;
  end else begin
    if (buff2[posi]=1) and (buff2[posi-1]=0) and (buff2[posi-2]=1) and (buff2[posi-3]=1)
      and (buff2[posi-4]=1) and (buff2[posi-5]=1) and (buff2[posi-6]=1) and (buff2[posi-7]=1)
      and (buff2[posi-8]=1) and (buff2[posi-9]=1) and (buff2[posi-10]=1) and (buff2[posi-11]=1)
      and (buff2[posi-12]=1) and (buff2[posi-13]=1) and (buff2[posi-14]=0) and (buff2[posi-15]=0)
    then result := true;
  end;
end;

function ShiftToFrames(shift : double) : longint;
var hh, mm, ss, ms : word;
begin
   decodetime(shift,hh,mm,ss,ms);
   result := (hh*3600 + mm*60 + ss)*25 + trunc(ms/40);
end;

function DataToInt(b0,b1,b2,b3 : byte) : byte;
var bt : byte;
begin
   bt := 0;
   if b0<>0 then bt:=bt or 1;
   if b1<>0 then bt:=bt or 2;
   if b2<>0 then bt:=bt or 4;
   if b3<>0 then bt:=bt or 8;
   result := bt;
end;

function selecttimecode(abuff,posi : integer) : double;
var h1,h2,m1,m2,s1,s2,f1,f2 : byte;
    hh,mm,ss,ms : integer;
begin
  try
  result := -1;
  if posi<79 then exit;
  if abuff=1 then begin
    h1:=DataToInt(buff1[posi-23],buff1[posi-22],0,0);
    h2:=DataToInt(buff1[posi-31],buff1[posi-30],buff1[posi-29],buff1[posi-28]);
    m1:=DataToInt(buff1[posi-39],buff1[posi-38],buff1[posi-37],0);
    m2:=DataToInt(buff1[posi-47],buff1[posi-46],buff1[posi-45],buff1[posi-44]);
    s1:=DataToInt(buff1[posi-55],buff1[posi-54],buff1[posi-53],0);
    s2:=DataToInt(buff1[posi-63],buff1[posi-62],buff1[posi-61],buff1[posi-60]);
    f1:=DataToInt(buff1[posi-71],buff1[posi-70],0,0);
    f2:=DataToInt(buff1[posi-79],buff1[posi-78],buff1[posi-77],buff1[posi-76]);
  end else begin
    h1:=DataToInt(buff2[posi-23],buff2[posi-22],0,0);
    h2:=DataToInt(buff2[posi-31],buff2[posi-30],buff2[posi-29],buff2[posi-28]);
    m1:=DataToInt(buff2[posi-39],buff2[posi-38],buff2[posi-37],0);
    m2:=DataToInt(buff2[posi-47],buff2[posi-46],buff2[posi-45],buff2[posi-44]);
    s1:=DataToInt(buff2[posi-55],buff2[posi-54],buff2[posi-53],0);
    s2:=DataToInt(buff2[posi-63],buff2[posi-62],buff2[posi-61],buff2[posi-60]);
    f1:=DataToInt(buff2[posi-71],buff2[posi-70],0,0);
    f2:=DataToInt(buff2[posi-79],buff2[posi-78],buff2[posi-77],buff2[posi-76]);
  end;
  //result := h1+h2+':'+m1+m2+':'+s1+s2+':'+f1+f2;
  hh:= h1*10+h2;
  mm:= m1*10+m2;
  ss:= s1*10+s2;
  ms:= f1*10+f2;
  if (hh<=24) and (hh>=0) and (mm<=59) and (mm>=0) and (ss<=59) and (ss>=0) and
     (ms<=24) and (ms>=0) then result := EncodeTime(hh, mm, ss, ms*40);
  except
    result := -1;
  end;
end;

procedure clearbuff(abuff : integer);
var i : integer;
begin
  if abuff=1 then begin
    for i:=0 to high(buff1)-1 do buff1[i]:=0;
  end else begin
    for i:=0 to high(buff2)-1 do buff2[i]:=0;
  end;
end;

function adddatainbuff(smpl : byte) : double;
begin
  result:=-1;
  if buffact=1 then begin
    buff1[buffpos]:=smpl;
    if iskeyword(1,buffpos) then begin
      result:=selecttimecode(1,buffpos);
      clearbuff(1);
      buffpos:=0;
      buffact:=2;
      exit;
    end;
    buffpos:=buffpos+1;
    if buffpos >= high(buff1) then begin
      buffpos:=0;
      buffact:=2;
      clearbuff(1);
      exit;
    end;
  end else begin
    buff2[buffpos]:=smpl;
    if iskeyword(2,buffpos) then begin
      result:=selecttimecode(2,buffpos);
      clearbuff(2);
      buffpos:=0;
      buffact:=1;
      exit;
    end;
    buffpos:=buffpos+1;
    if buffpos >= high(buff2) then begin
      buffpos:=0;
      buffact:=1;
      clearbuff(2);
      exit;
    end;
  end;
end;

function findkeyword(smpl : byte) : boolean;
begin
  result := false;
  buff1[buffpos]:=smpl;
  if iskeyword(1,buffpos) then begin
      result:=true;
      clearbuff(1);
      buffpos:=0;
      buffact:=1;
      exit;
    end;
    buffpos:=buffpos+1;
    if buffpos >= high(buff1) then begin
      buffpos:=0;
      clearbuff(1);
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  header: TWaveFormatEx;
  BufLen: word;
  buf, buf1: pointer;

begin
  label1.Caption:=inttostr(1 shl 16);
  label2.Caption:='0';
  cntrec:=0;
  memo1.Clear;
  //BufSize := 5000;//TrackBar1.Position * 500 + 100; { Размер буфера }
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
  bufsize := trunc(header.nSamplesPerSec / 25) * BufFrames;
  OneSample := trunc((header.nSamplesPerSec / 25) / 80) - 1;

  WaveInOpen(Addr(WaveIn), WAVE_MAPPER, addr(header), Form1.Handle, 0, CALLBACK_WINDOW);
  BufLen := header.nBlockAlign * BufSize;
  hBuf := GlobalAlloc(GMEM_FIXED or GMEM_NOCOMPACT or GMEM_NODISCARD, BufLen);
  hBuf1 := GlobalAlloc(GMEM_FIXED or GMEM_NOCOMPACT or GMEM_NODISCARD, BufLen);

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

  adr2:=@BufHead1;
  WaveInPrepareHeader(WaveIn, Addr(BufHead1), sizeof(BufHead1));
  WaveInPrepareHeader(WaveIn, Addr(BufHead2), sizeof(BufHead2));
  WaveInAddBuffer(WaveIn, addr(BufHead1), sizeof(BufHead1));
  GetMem(p, BufSize * sizeof(TPoint));
  stop := false;
  WaveInStart(WaveIn);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if stop then exit;
  stop := true;
  WaveInReset(WaveIn);
  WaveInUnPrepareHeader(WaveIn, addr(BufHead1), sizeof(BufHead1));
  WaveInUnPrepareHeader(WaveIn, addr(BufHead2), sizeof(BufHead2));
  WaveInClose(WaveIn);
  GlobalUnlock(hBuf);
  GlobalFree(hBuf);
  GlobalUnlock(hBuf1);
  GlobalFree(hBuf1);
  FreeMem(p, BufSize * sizeof(TPoint));
end;

function TwoInt(vl : word) : string;
begin
  if vl<=9 then result := '0' + inttostr(vl) else result := inttostr(vl);
end;

procedure TForm1.OnWaveIn;
var
  i, j, k: integer;
  data16: PData16;
  h: integer;
  XScale, YScale: single;
  strs, txt : string;
  temp: pWaveHdr;
  recorded, bfs, currshift : longint;
  Ampl : integer;
  MyTime : double;
  hh, mm, ss, ms : word;
  dt, tm : double;
  poskey : integer;
  buftc : array[0..1999] of tpoint;
  xscl : real;
begin
  application.ProcessMessages;
  temp:=adr2;
  if adr2=@BufHead1 then adr2:=@BufHead2 else adr2:=@BufHead1;
  if not stop then
    WaveInAddBuffer(WaveIn, adr2, SizeOf(TWaveHdr))
  else begin
    stop := true;
    exit;
  end;
  recorded:=adr2.dwBytesRecorded;
  cntrec:=cntrec + recorded;
  label2.Caption:='Тайм-код отсутствует';//inttostr(cntrec);
  myshiftsample := -1;
  if checkbox1.Checked then begin
    h := PaintBox1.Height;
    XScale := PaintBox1.Width / BufSize;
    //XScale := PaintBox1.Width / 2000;
  end else h := 100;
  strs:='';
  data16 := PData16(PWaveHdr(Msg.lParam)^.lpData);
  YScale := h / (1 shl 16);
  for i := 0 to BufSize - 1 do begin
    Ampl := round(h / 2 - data16^[i] * YScale);
    if checkbox1.Checked then p^[i] := Point(round(i * XScale), Ampl);
    if (Ampl > (h div 2)) then curr:=1 else curr:=0;
    ValueSample:=255;
    if curr<>pred then begin
      countsample := countones + countzero;
      if ( countsample < onesample-2) then begin
        if curr=1 then countones:=countones+1 else countzero:=countzero+1;
      end else begin
        if (countzero>=onesample-2) or (countones>=onesample-2)
          then begin
            ValueSample:=0;
          end else begin
            ValueSample:=1;
          end;
          if curr=1 then begin
            countones:=1;
            countzero:=0;
          end else begin
            countones:=0;
            countzero:=1;
          end;
      end;
    end else begin
      if curr=1 then countones:=countones+1 else countzero:=countzero+1;
    end;
    pred:=curr;
    poskey:=-1;
    if ValueSample<>255 then begin
      strs := strs + inttostr(ValueSample);
      if not TCExists then begin
        if findkeyword(ValueSample) then TCExists := true;
      end else begin
        //txt := adddatainbuff(ValueSample);
        MyTime := adddatainbuff(ValueSample);
        //if (trim(txt)<>'') and (trim(txt)<>'00:00:00:00') then begin
        if MyTime<>-1 then begin
          poskey := i;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if checkbox1.Checked then begin
    if poskey<>-1 then begin
      if i> 1999 then begin
        k:=0;
        xscl := PaintBox1.Width / 2000;
        for j:=i -1999 to i do begin
          buftc[k]:= Point(round(k * xscl), p^[j].Y);
          k:=k+1;
        end;
      end;
      with PaintBox1.Canvas do begin
        Brush.Color := clWhite;
        FillRect(ClipRect);
        //bfs := OneSample*81;
        //Polyline(Slice(p^, BufSize));
        Polyline(Slice(buftc, 1999));
      end;
    end;
  end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



          dt := Now;
          myshiftsample := dt - (Trunc(dt) + myTime);
          DecodeTime(MyTime,hh,mm,ss,ms);
          txt := TwoInt(hh) + ':' + TwoInt(mm) + ':' + TwoInt(ss) + ':' + TwoInt(trunc(ms/40));
          Form1.Label2.Caption:=txt;
          if checkbox2.Checked then begin
            memo1.Lines.Insert(0,txt);
            if memo1.Lines.Count=26 then memo1.Lines.Delete(25);
          end;
          application.ProcessMessages;
        end;
      end;
    end;
  end;

  if myshiftsample<>-1 then begin
    currshift := ShiftToFrames(myshiftsample);
    if currshift<>oldshiftframes then begin
      counterror := counterror + 1;
      if counterror > 10 then begin
        Compartido^.Shift :=myshiftsample;
        if compartido^.Manejador2 <> 0 then PostMessage(Compartido^.Manejador2, WM_TRANSFER,0, 0);
        counterror:=0;
        oldshiftframes:=currshift;
      end;
    end else begin
     if trim(Compartido^.Cadena)='request' then begin
       Compartido^.Shift :=myshiftsample;
       if compartido^.Manejador2 <> 0 then PostMessage(Compartido^.Manejador2, WM_TRANSFER,0, 0);
     end;
     counterror:=0;
     oldshiftframes:=currshift;
    end;
  end;

//  if checkbox1.Checked then begin
//    if poskey<>-1 then begin
//      if i> 1999 then begin
//        k:=0;
//        for j:=i to i - 1999 do begin
//          buftc[1999-k]:=p^[j];
//          k:=k+1;
//        end;
//      end;
//      with PaintBox1.Canvas do begin
//        Brush.Color := clWhite;
//        FillRect(ClipRect);
//        //bfs := OneSample*81;
//        //Polyline(Slice(p^, BufSize));
//        Polyline(Slice(buftc, 1999));
//      end;
//    end;
//  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Button2.Click;
    { закрываем файл }
  UnmapViewOfFile(Compartido);
   { закрыли ссылку на него }
  CloseHandle(FicheroM);
  DeleteTrayIcon(1);
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
var bl : boolean;
begin
 if not UniqueApp then Application.Terminate;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// создаем память для файла
  { Посмотрим, существует ли файл }
  FicheroM:=OpenFileMapping(FILE_MAP_ALL_ACCESS, False,'MiFichero');
  { Если нет, то ошибка }
  if FicheroM = 0 then  FicheroM:=CreateFileMapping( $FFFFFFFF,nil,PAGE_READWRITE,0,SizeOf(TCompartido),'MiFichero');
// если создается файл, заполним его нулями
  if FicheroM=0 then raise Exception.Create( 'Не удалось создать файл'+'/Ошибка при создании файла');
  Compartido:=MapViewOfFile(FicheroM,FILE_MAP_WRITE,0,0,0);
// запись данных в файл памяти
  Compartido^.Manejador1:=Handle;
  Compartido^.Numero:=777;
  Compartido^.Shift := Now;
  Compartido^.Cadena:='LTC-Detector';
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ShownOnce := False;
  CreateTrayIcon(1);
  //HideItemClick(nil);
  //HideItem.Enabled := False;
  //Form1.WindowState:=wsMinimized;
  //Application.ShowMainForm := False;
  //ShowWindow(Application.Handle, SW_HIDE);
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Button1.Caption := 'Старт';
  Button2.Caption := 'Стоп';
  pred:=0;
  cnt:=0;
  predzn:=0;
  cnt1:=0;
  checkbox3.Checked := CheckAutoStart;
  //if bl then checkbox3.Checked:=true else checkbox1.Checked:=false;;
  if CheckBox3.checked then begin
    Form1.WindowState:=wsMinimized;
    Application.ShowMainForm := False;
    ShowWindow(Application.Handle, SW_HIDE);
    HideItem.Enabled := False;
    Button1Click(nil);
  end;
end;

procedure TForm1.RestoreItemClick(Sender: TObject);
begin
  RestoreMainForm;
  RestoreItem.Enabled := False;
  HideItem.Enabled := True;
end;

procedure TForm1.HideItemClick(Sender: TObject);
begin
  HideMainForm;
  CreateTrayIcon(1);
  HideItem.Enabled := False;
  RestoreItem.Enabled := True;
end;

procedure TForm1.FileExitItem1Click(Sender: TObject);
begin
   CloseApplication := true;
   Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not CloseApplication then begin
    Action := caNone;
    HideItemClick(nil);
    exit;
  end;
  if CheckBox3.Checked then begin
    if not CheckAutoStart then AutoStartEnable;
  end else begin
    if CheckAutoStart then AutoStartDisable;
  end;
end;

end.
