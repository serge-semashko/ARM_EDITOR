unit ComPortUnit;

interface

uses Windows, SysUtils, Classes, MainUnit, Registry;
//RusErrorStr,

type
  //определим тип TComThread - наследника класса TThread
  TCommThread = class(TThread)
  private
    { Private declarations }
  //процедура, занимающаяся опросом порта
    Procedure QueryPort;
  protected
  //переопределим метод запуска потока
     Procedure Execute; override;
  end;

 Procedure StartService(BR : Cardinal);
 Procedure StopService;
 Procedure WriteStrToPort(Str:ansistring);
 Procedure WriteCharToPort(Ch:ansistring);
 function GetSerialPortNames(lst : TStrings) : string;

//глобальные переменные
Var
//необходимые переменные
CommThread:TCommThread; //наш поток, в котором будет работать процедура опроса порта
hPort:Integer;//дескриптор порта
//совсем не обязательные переменые, используемые для "украшения" приложения
SendBytes:Cardinal;  //количество переданных в порт байт
ReciveBytes:Cardinal;//количество считанных из порта байт
lstCommMes : tstrings;
CommDataRead : boolean = false;

implementation

function GetSerialPortNames(lst : TStrings) : string;
var
  reg: TRegistry;
  l, v: TStringList;
  n: integer;
begin
  l := TStringList.Create;
  v := TStringList.Create;
  reg := TRegistry.Create;
  lst.Clear;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM');
    //reg.OpenKey('HARDWARE\DEVICEMAP\SERIALCOMM', false);
    reg.GetValueNames(l);
    for n := 0 to l.Count - 1 do begin
      v.Add(reg.ReadString(l[n]));
      lst.Add(reg.ReadString(l[n]));
    end;
    Result := v.CommaText;
  finally
    reg.Free;
    l.Free;
    v.Free;
  end;
end;

Procedure StartComThread;
Begin {StartComThread}
  CommThread:=TCommThread.Create(False);
  If CommThread = Nil then begin {Nil}
    SysErrorMessage(GetLastError);
    fmMain.btnStop.Click;
    Exit;
  End; {Nil}
End; {StartComThread}

Procedure TCommThread.Execute;
Begin {Execute}
  Repeat
    QueryPort;//процедура опроса порта будет производиться пока поток не будет прекращен
  Until Terminated;
End;  {Execute}

Procedure TCommThread.QueryPort;
Var
  MyBuff:Array[0..1023] Of ansichar;//буфер для чтения данных
  ByteReaded:Cardinal; //количество считанных байт
  Str, s1, s2, lststr :ansistring;         //вспомогательная строка
  Status:DWord;       //статус устройства (модема)
  ipos : integer;
Begin {QueryPort}
  If Not GetCommModemStatus(hPort,Status) then begin
    SysErrorMessage(GetLastError);
    fmMain.btnStop.Click;
    Exit;
  end;  {ошибка при получении статуса модема}

//читаем буфер из Com-порта
  FillChar(MyBuff,SizeOf(MyBuff),#0);
  If Not ReadFile(hPort,MyBuff,SizeOf(MyBuff),ByteReaded,nil) then begin
    SysErrorMessage(GetLastError);
    fmMain.btnStop.Click;
    Exit;
  end; {ошибка при чтении данных}

  If ByteReaded>0 then begin
    ReciveBytes:=ReciveBytes+ByteReaded;
    Str:=ansistring(MyBuff);
    s1:=Str;
    lststr:='';//lstCommMes.Clear;
    ipos:=Pos(#13#10,s1);
    while ipos<>0 do begin
      s2:=copy(s1,1,ipos-1);
      s1:=copy(s1,ipos+2,length(s1));
      lststr:=lststr+s2;//lstCommMes.Add(s2);
      ipos:=Pos(#13#10,s1);
    end;
    lststr:=lststr+s1;//lstCommMes.Add(s1);
    CommDataRead:=true;
    //fmMain.Memo1.Clear;
    //отправим строку на просмотр
    fmMain.Memo1.Text:=fmMain.Memo1.Text+lststr;//fmMain.Memo1.Lines.AddStrings(lstCommMes);
    //fmMain.Memo1.Text:=fmMain.Memo1.Text+ Str;
    //покажем количество считанных байтов
    fmMain.lbRecv.Caption:='recv: '+IntToStr(ReciveBytes)+' bytes...';
  End; {ByteReaded>0}
End; {QueryPort}

Procedure InitPort(BR : Cardinal);
Var
  DCB: TDCB;         //структура для хранения настроек порта
  CT: TCommTimeouts; //стркутура для хранения тайм-аутов
Begin {InitPort}
  hPort := CreateFile(Pchar(fmMain.cbComPort.Items.Strings[fmMain.cbComPort.ItemIndex]),
                        GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE,
                        nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  If (hPort < 0) Or Not SetupComm(hPort, 2048, 2048) Or Not GetCommState(hPort, DCB) then begin
    SysErrorMessage(GetLastError);
    fmMain.btnStop.Click;
    Exit;
  End;  {ошибка}

  GetCommState(hPort, DCB);
  DCB.BaudRate:=BR;//115200;             // скорость обмена
  DCB.Parity:=NoParity;           // нет контроля четности
  DCB.ByteSize:=8;                //байт из восьми бит
  DCB.StopBits:=ONESTOPBIT;        //биты данных

  If Not SetCommState(hPort, DCB) then begin {ошибка}
    SysErrorMessage(GetLastError);
    fmMain.btnStop.Click;
    Exit;
  End; {ошибка}

//устанавливаем параметры тайм-аутов
  If Not GetCommTimeouts(hPort, CT) then begin  {ошибка}
    SysErrorMessage(GetLastError);
    fmMain.btnStop.Click;
    Exit;
  End; {ошибка}
  //тайм-ауты
  CT.ReadTotalTimeoutConstant := 5;//50;
  CT.ReadIntervalTimeout := 5;//50;
  CT.ReadTotalTimeoutMultiplier := 1;
  CT.WriteTotalTimeoutMultiplier := 1;//10;
  CT.WriteTotalTimeoutConstant := 1;//10;

  If Not SetCommTimeouts(hPort, CT) then begin {ошибка}
    SysErrorMessage(GetLastError);
    fmMain.btnStop.Click;
    Exit;
  End; {ошибка}
End;{InitPort}

Procedure WriteStrToPort(Str:ansiString);
Var
  ByteWritten:Cardinal;
  MyBuff:Array[0..1023] Of ansiChar;
Begin {WriteStrToPort}
//готовим буфер для передачи
  FillChar(MyBuff,SizeOf(MyBuff),#0);
  Str:=Str+#13#10;
//StrPCopy(MyBuff,Str);
  StrLCopy(MyBuff, PansiChar(Str), Length(Str));
//передаем данные
  If Not WriteFile(hPort,MyBuff, Length(Str),ByteWritten,Nil) then begin
//If Not WriteFile(hPort,Str[1],2*Length(Str),ByteWritten,Nil) then begin
    SysErrorMessage(GetLastError);
    fmMain.btnStop.Click;
    Exit;
  End; {ошибка}
//считаем байтики
  SendBytes:=SendBytes+ByteWritten;
  fmMain.lbSend.Caption:='send: ' + IntToStr(SendBytes) + ' bytes...';
End; {WriteStrToPort}

Procedure WriteCharToPort(Ch:ansiString);
Var
  ByteWritten:Cardinal;
  s : ansistring;
  MyBuff:Array[0..1023] Of ansiChar;
Begin
//передаем данные
  s:=Ch;
  StrLCopy(MyBuff, PansiChar(S), Length(S));
  If Not WriteFile(hPort,MyBuff, Length(S),ByteWritten,Nil) then begin
    SysErrorMessage(GetLastError);
    fmMain.btnStop.Click;
    Exit;
  End; {ошибка}
//считаем байтики
  SendBytes:=SendBytes+ByteWritten;
  fmMain.lbSend.Caption:='send: ' + IntToStr(SendBytes) + ' bytes...';
End;

Procedure StopService;
Begin {StopService}
  CommThread.Terminate;
  CloseHandle(hPort); //закрываем порт
  CommThread.Free;    //"отпускаем" поток
End; {StopService}

Procedure StartService(BR : Cardinal);
Begin {StartService}
  InitPort(BR);       //инициализируем порт
  StartComThread; //запускаем поток
End;  {StartService}

initialization
lstCommMes:=tstringlist.Create;
lstCommMes.Clear;

finalization
lstCommMes.Free;

end.
