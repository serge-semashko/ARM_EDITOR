unit mainsrv;

// fdgsdfgsdf
interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, HTTPSend, blcksock, winsock, Synautil,
    strutils, system.json, AppEvnts, Menus, inifiles, das_const, ipcthrd,
    TeEngine, Series, TeeProcs, Chart, VclTee.TeeGDIPlus, System.Generics.Collections;

type
    THTTPSRVForm = class(TForm)
        Panel1: TPanel;
        Timer1: TTimer;
        Memo2: TMemo;
        URLED: TEdit;
        SpeedButton1: TSpeedButton;
        Chart1: TChart;
        Series1: TLineSeries;
        Series2: TLineSeries;
        Series3: TLineSeries;
        Series4: TLineSeries;
        chartbox: TCheckBox;
        BitBtn1: TBitBtn;
        PopupMenu2: TPopupMenu;
        Restore1: TMenuItem;
        Minimize1: TMenuItem;
        quit1: TMenuItem;
        procedure FormCreate(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure terminate1Click(Sender: TObject);
        procedure Panel1Click(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormDestroy(Sender: TObject);
        procedure Restore1Click(Sender: TObject);
        procedure Minimize1Click(Sender: TObject);
        procedure quit1Click(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private
    protected
        procedure ControlWindow(var Msg: TMessage); message WM_SYSCOMMAND;
        procedure IconMouse(var Msg: TMessage); message WM_USER + 1;
    public
        procedure Ic(n: Integer; Icon: TIcon);
    end;

    TTCPHttpDaemon = class(TThread)
    private
        Sock: TTCPBlockSocket;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Execute; override;
    end;

    TTCPHttpThrd = class(TThread)
    private
        Sock: TTCPBlockSocket;
    public
        Headers: TStringList;
        InputData, OutputData: TMemoryStream;
        constructor Create(hsock: tSocket);
        destructor Destroy; override;
        procedure Execute; override;
        function ProcessHttpRequest(Request, URI: string): Integer;
    end;

    THardRec = packed record
        DateTimeSTR: array[0..5] of ansichar;
        UpdateCounter: int64;
        VersionSignature: array[0..5] of ansichar;
        JSONAll: array[0..1000000] of ansichar;
        JSONStore: array[0..1000000] of ansichar;
    end;

    PHardRec = ^THardRec;

var
    keys: TDictionary<ansistring, ansistring>;
    KeyNames: tstringlist;
    Keyvalues: tstringlist;
    JsonVars: tstringlist;
    PrevUpdates: Integer = 0;
    HardRec: PHardRec;
    testbuf: array[0..1000] of byte absolute HardRec;
    shared: tsharedmem;
    PortNum: Integer = 9090;
    textfromjson: string = '[]';
    currentData: string = '{}';
    testjson: string = '[{"time":"18:57:40","sbrkgu1":0,"sbrkgu2":0,"k1t6":272.73,"k1t12":295.05,"k1t13":288.41,"k1dt5t6":12.15,"k1dt3t4":2.73,"k1sbr":0,' + '"k1vanna":0,"k1bo1":0.37,"k1bo2":0,"k2t6":108.89,"k2t12":211.58,"k2t13":286.86,"k2dt5t6":-2.02,"k2dt3t4":-1.91,"k2sbr":0,"k2vanna":0,' + '"k2bo1":0,"k2bo2":58.79}]';
    starttime: double;
    HTTP: THTTPSend = nil;
    PrevUpdate: double = 0;
    HTTPsrv: TTCPHttpDaemon;
    HTTPSRVFORM: THTTPSRVForm;
    URL: string;
    intsum: Integer = 0;
    intcount: Integer = 0;
    maxint: Integer = 0;
    minint: Integer = 10000;
    lastReq: double;

implementation

uses
    shellapi;
{$R *.dfm}

procedure THTTPSRVForm.IconMouse(var Msg: TMessage);
var
    p: tpoint;
begin
    GetCursorPos(p); // Запоминаем координаты курсора мыши
    case Msg.LParam of  // Проверяем какая кнопка была нажата
        WM_LBUTTONUP, WM_LBUTTONDBLCLK: {Действия, выполняемый по одинарному или двойному щелчку левой кнопки мыши на значке. В нашем случае это просто активация приложения}
            begin
//        ShowWindow(Application.Handle, SW_SHOW); // Восстанавливаем кнопку программы
                ShowWindow(Handle, SW_SHOW); // Восстанавливаем окно программы
            end;
        WM_RBUTTONUP: {Действия, выполняемый по одинарному щелчку правой кнопки мыши}
            begin
                SetForegroundWindow(Handle);                   // Восстанавливаем программу в качестве переднего окна
                PopupMenu2.Popup(p.X, p.Y);  // Заставляем всплыть тот самый TPopUp о котором я говорил чуть раньше
                PostMessage(Handle, WM_NULL, 0, 0);
            end;
    end;
end;

procedure THTTPSRVForm.Minimize1Click(Sender: TObject);
begin
    ShowWindow(Handle, SW_hide); // Âîññòàíàâëèâàåì îêíî ïðîãðàììû
    application.Minimize;
end;

procedure THTTPSRVForm.Ic(n: Integer; Icon: TIcon);
var
    Nim: TNotifyIconData;
begin
    Nim.cbSize := SizeOf(Nim);
    with Nim do begin
        Wnd := Handle;
        uID := 1;
        uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
        hicon := Icon.Handle;
        uCallbackMessage := wm_user + 1;
        szTip := 'WEB-Shell interface server';
    end;
    case n of
        1:
            Shell_NotifyIcon(Nim_Add, @Nim);
        2:
            Shell_NotifyIcon(Nim_Delete, @Nim);
        3:
            Shell_NotifyIcon(Nim_Modify, @Nim);
    end;
end;

procedure THTTPSRVForm.ControlWindow(var Msg: TMessage);
begin
    if Msg.WParam = SC_MINIMIZE then begin
        ShowWindow(Handle, SW_HIDE);  // ???????? ?????????
//    ShowWindow(Application.Handle, SW_HIDE);  // ???????? ?????? ? TaskBar'?
    end
    else
        inherited;
end;

procedure THTTPSRVForm.Panel1Click(Sender: TObject);
begin
    HTTP := THTTPSend.Create;
    try
//    HTTP.ProxyHost := Edit8.Text;
//    HTTP.ProxyPort := Edit9.Text;
        HTTP.HTTPMethod('GET', URLED.text);
        Memo2.Lines.Assign(HTTP.Headers);
//    Memo3.Lines.LoadFromStream(HTTP.Document);
    finally
        HTTP.Free;
    end;
end;

procedure THTTPSRVForm.quit1Click(Sender: TObject);
begin
    halt;
end;

procedure THTTPSRVForm.Restore1Click(Sender: TObject);
begin
    ShowWindow(Handle, SW_SHOW);
end;

procedure THTTPSRVForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    ShowWindow(Handle, SW_hide);
    Action := caNone;

end;

procedure THTTPSRVForm.FormCreate(Sender: TObject);
var
    ff: tfilestream;
    str1: string;
    objFileName: string;
    strlist: TStringList;
begin

    starttime := now;
    while (now - starttime) * 24 * 3600 < 3 do
        Application.ProcessMessages;

    HTTPsrv := TTCPHttpDaemon.Create;
    lastReq := -1;
    Ic(1, Application.Icon);
    Timer1.Enabled := true;
    application.Minimize;

end;

procedure THTTPSRVForm.FormDestroy(Sender: TObject);
begin
    Ic(2, Application.Icon);
end;

procedure THTTPSRVForm.FormShow(Sender: TObject);
begin
    ShowWindow(Application.Handle, SW_HIDE);
    ShowWindow(Application.MainForm.Handle, SW_HIDE);

end;

constructor TTCPHttpDaemon.Create;
begin
    inherited Create(false);
    Sock := TTCPBlockSocket.Create;
    FreeOnTerminate := true;
    Priority := tpNormal;
end;

destructor TTCPHttpDaemon.Destroy;
begin
    Sock.free;
    inherited Destroy;
end;

procedure TTCPHttpDaemon.Execute;
var
    ClientSock: tSocket;
begin
  // writeTimeLog('open sock');
    with Sock do begin
        CreateSocket;
        setLinger(true, 10);
        bind('0.0.0.0', IntToStr(PortNum));
        listen;
    // writeTimeLog('Listen sock');
        repeat
            if terminated then
                break;
            if canread(1000) then begin
        // writeTimeLog('Client read sock');
                ClientSock := accept;
                if lastError = 0 then
                    TTCPHttpThrd.Create(ClientSock);
            end;
        until false;
    end;
end;

{ TTCPHttpThrd }

constructor TTCPHttpThrd.Create(hsock: tSocket);
begin
    writeTimeLog('TCPHttpThrd.Create');

    inherited Create(false);
    Sock := TTCPBlockSocket.Create;
    Headers := TStringList.Create;
    InputData := TMemoryStream.Create;
    OutputData := TMemoryStream.Create;
    Sock.socket := hsock;
    FreeOnTerminate := true;
    Priority := tpNormal;
end;

destructor TTCPHttpThrd.Destroy;
begin
    Sock.free;
    Headers.free;
    InputData.free;
    OutputData.free;
    inherited Destroy;
end;

procedure TTCPHttpThrd.Execute;
var
    b: byte;
    timeout: Integer;
    s: string;
    method, URI, protocol: string;
    size: Integer;
    X, n: Integer;
    resultcode: Integer;
begin
    writeTimeLog('123');
    timeout := 120000;
  // read request line
    s := Sock.RecvString(timeout);
    if Sock.lastError <> 0 then
        Exit;
    if s = '' then
        Exit;
    method := fetch(s, ' ');
    if (s = '') or (method = '') then
        Exit;
    URI := fetch(s, ' ');
    if URI = '' then
        Exit;
    protocol := fetch(s, ' ');
    Headers.Clear;
    size := -1;
  // read request headers
    if protocol <> '' then begin
        if pos('HTTP/', protocol) <> 1 then
            Exit;
        repeat
            s := Sock.RecvString(timeout);
            if Sock.lastError <> 0 then
                Exit;
            if s <> '' then
                Headers.add(s);
            if pos('CONTENT-LENGTH:', Uppercase(s)) = 1 then
                size := StrToIntDef(SeparateRight(s, ' '), -1);
        until s = '';
    end;
  // recv document...
    InputData.Clear;
    if size >= 0 then begin
        InputData.SetSize(size);
        X := Sock.RecvBufferEx(InputData.Memory, size, timeout);
        InputData.SetSize(X);
        if Sock.lastError <> 0 then
            Exit;
    end;
    OutputData.Clear;
    resultcode := ProcessHttpRequest(method, URI);
    Sock.SendString('HTTP/1.0 ' + IntToStr(resultcode) + CRLF);
    if protocol <> '' then begin
        Headers.add('Content-length: ' + IntToStr(OutputData.size));
        Headers.add('Connection: close');
        Headers.add('Date: ' + Rfc822DateTime(now));
        Headers.add('Server: Synapse HTTP server demo');
        Headers.add('');
        for n := 0 to Headers.count - 1 do
            Sock.SendString(Headers[n] + CRLF);
    end;
    if Sock.lastError <> 0 then
        Exit;
    Sock.SendBuffer(OutputData.Memory, OutputData.size);
    if lastReq > 0 then begin
        intsum := intsum + trunc((now - lastReq) * 24 * 3600 * 1000);
        inc(intcount);
        if (now - lastReq) * 24 * 3600 * 1000 > maxint then
            maxint := trunc((now - lastReq) * 24 * 3600 * 1000);
        if (now - lastReq) * 24 * 3600 * 1000 < minint then
            minint := trunc((now - lastReq) * 24 * 3600 * 1000);
    end;
    lastReq := now;
    Sock.CloseSocket;
end;

function TTCPHttpThrd.ProcessHttpRequest(Request, URI: string): Integer;
var
    l: TStringList;
    str1, str2,  resp: ansistring;
    str3 : string;
    stmp, jreq: string;
    amppos: Integer;
    json, json1: tjsonobject;
    i1, i2, i3: integer;
    keyname: ansistring;
    keyval: ansistring;
begin
  // sample of precessing HTTP request:
  // InputData is uploaded document, headers is stringlist with request headers.
  // Request is type of request and URI is URI of request
  // OutputData is document with reply, headers is stringlist with reply headers.
  // Result is result code
    result := 504;
    if Request = 'GET' then begin
        Headers.Clear;
        Headers.add('Content-type: Text/Html');
        l := TStringList.Create;
        try
            if (pos('callback=', URI) <> 0) then begin
                stmp := copy(URI, pos('callback=', URI) + 9, length(URI));
                amppos := pos('get_member', stmp);
                if amppos > 0 then
                    jreq := copy(stmp, 1, amppos - 2);
            end;
            resp := HardRec.JSONAll;
            if pos('GET_TLEDITOR', URI) <> 0 then begin
                str1 := HardRec.JSONStore;
                json := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(str1), 0) as TJSONObject;
                if json = nil then
                    resp := '{status:" Error TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(HardRec.JSONStore), 0)"}'
                else begin
                    json1 := tjsonobject(json.GetValue('TLEDITOR'));
                    if json1 = nil then
                        resp := '{status:" Error tjsonobject(json.GetValue(''TLEDITOR''))"}'
                    else
                        resp := json1.ToString;
                end;
            end;
            if pos('SET_', ansiuppercase(URI)) <> 0 then begin
                resp := 'errformat No = :' + URI;
                i1 := pos('=', URI);
                if i1 > 5 then begin
                    keyname := copy(URI, 6, i1 - 6);
                    str1 := copy(URI, i1+1, Length(URI));
                    while (str1[length(str1)] <> '}') and (length(str1) > 1) do
                        system.delete(str1, length(str1), 1);
                    json := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(str1), 0) as TJSONObject;
                    if json = nil then begin
                        resp := '{status:" Error TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(HardRec.JSONStore), 0)"}';
                        showmessage(resp);
                    end
                    else begin

                        keys.AddOrSetValue(keyname, str1);
                        resp := '{"status":"ok"}';
//                        showmessage('Ok size ='+IntTostr(length(json.ToString)));
                        json.Free;
                    end;
                end;
            end;

            resp := jreq + '(' + resp + ');';
            l.add(resp);
            l.SaveToStream(OutputData);
        finally
            l.free;
        end;
        result := 200;
    end;
end;

procedure THTTPSRVForm.SpeedButton1Click(Sender: TObject);
var
    jtype: string;
    jsonstr: string;
    i, id: Integer;
    r1, r2: double;
  // rl : tstringlist;
    offset, position, h, g: Integer;
    s: string;
    ff: tfilestream;
    r: array[0..255] of string;
    pointpos: Integer;
    resrecord: string;
    FullProgPath: PwideChar;
    str22: string;

    procedure SliceSeries(Chart: TChart; maxlen: Integer);
    var
        Ic: Integer;
    begin
        for Ic := 0 to Chart.SeriesCount - 1 do begin
            while Chart.Series[Ic].count > maxlen do
                Chart.Series[Ic].Delete(0);
        end;
    end;

var
    st: double;
begin
    caption := formatDateTime('dd/mm/yyyy HH:NN:SS', now) + formatDateTime(' Старт:dd/mm/yyyy HH:NN:SS', starttime);
    Timer1.Enabled := false;
    Application.ProcessMessages;
    while true do begin
        st := now;
        while (now - st) * 24 * 3600 * 1000 < 1 do begin
            sleep(1);
            Application.ProcessMessages;
        end;
        textfromjson := HardRec.JSONAll;
    // memo2.Lines.Clear;
    // memo2.Text:=textfromJson;
        if chartbox.Checked then begin
            if lastReq > 0 then begin
                if intcount > 0 then begin
                    if chartbox.Checked then
                        Series3.AddXY(now, intsum / intcount);
                end;
                if chartbox.Checked then
                    Series4.AddXY(now, HardRec.UpdateCounter - PrevUpdates);
                if chartbox.Checked then
                    Series1.AddXY(now, minint);
                if chartbox.Checked then
                    Series2.AddXY(now, maxint);

            end;
            SliceSeries(Chart1, 1000);
        end;
        PrevUpdates := HardRec.UpdateCounter;
        intsum := 0;
        intcount := 0;
        minint := 1000;
        maxint := 0;

    end;
    Timer1.Enabled := true;
end;

procedure THTTPSRVForm.terminate1Click(Sender: TObject);
begin
    halt;
end;

var
    jcount: Integer;
    str: string;

var
    ini: tinifile;

initialization
    shared := tsharedmem.Create('webredis tempore mutanur', sizeof(ThardRec) + 1000);

    HardRec := Pointer(Integer(shared.Buffer) + 100);

    if (HardRec.UpdateCounter <> 13131313) then begin
        fillchar(HardRec.JSONAll, 1000000, 0);
        HardRec.UpdateCounter := 13131313
    end;
    HardRec.UpdateCounter := 0;
    lastReq := now;
    keys := TDictionary<ansistring, ansistring>.Create();
//    varNames := tstringlist.Create;
//    Varvalues:= tstringlist.Create;

end.

