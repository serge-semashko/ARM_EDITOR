unit ComPortUnit;

interface

uses Windows, Forms, SysUtils, Classes, MainUnit, Dialogs, Registry;
// RusErrorStr,

type
    // ��������� ��� TComThread - ���������� ������ TThread
    TCommThread = class(TThread)
    private
        { Private declarations }
        // ���������, ������������ ������� �����
        Procedure QueryPort;
    protected
        // ������������� ����� ������� ������

        Procedure Execute; override;
    end;

function StartService: boolean;
Procedure StopService;
Procedure WriteStrToPort(Str: ansistring);
Procedure WriteCharToPort(Ch: ansistring);
Procedure WriteBuffToPort(cnt: Cardinal);
function GetSerialPortNames(lst: TStrings): string;

// ���������� ����������
Var
    // ����������� ����������
    CommThreadExists: boolean = false;
    CommThread: TCommThread;
    // ��� �����, � ������� ����� �������� ��������� ������ �����
    hPort: Integer; // ���������� �����
    // ������ �� ������������ ���������, ������������ ��� "���������" ����������
    SendBytes: Cardinal; // ���������� ���������� � ���� ����
    ReciveBytes: Cardinal; // ���������� ��������� �� ����� ����
    lstCommMes: TStrings;
    CommDataRead: boolean = false;
    InBuff: array [0 .. 1023] of ansichar;

implementation

uses UMyInitFile, UCommon, umyinfo;

function GetSerialPortNames(lst: TStrings): string;
var
    reg: TRegistry;
    l: TStringList;
    n: Integer;
begin
    l := TStringList.Create;
    reg := TRegistry.Create;
    lst.Clear;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM');
        reg.GetValueNames(l);
        for n := 0 to l.Count - 1 do
        begin
            lst.Add(reg.ReadString(l[n]));
        end;
        Result := lst.CommaText;
    finally
        reg.Free;
        l.Free;
    end;
end;

Procedure StartComThread;
Begin { StartComThread }
    CommThread := TCommThread.Create(false);
    If CommThread = Nil then
    begin { Nil }
        SysErrorMessage(GetLastError);
        StopService;
        Exit;
    End; { Nil }
    CommThreadExists := true;
End; { StartComThread }

Procedure TCommThread.Execute;
Begin { Execute }
    try
        if PortRSStoped then
            Exit;
        while not Terminated do
        begin
            sleep(1);
            QueryPort;
        end;
        // Repeat
        // QueryPort;//��������� ������ ����� ����� ������������� ���� ����� �� ����� ���������
        // Until Terminated;
    except
    end;
End; { Execute }

Procedure TCommThread.QueryPort;
Var
    MyBuff: Array [0 .. 1023] Of ansichar; // ����� ��� ������ ������
    ByteReaded: Cardinal; // ���������� ��������� ����
    Str, s1, s2, lststr: ansistring; // ��������������� ������
    Status: DWord; // ������ ���������� (������)
    ipos, i: Integer;
    stat: TComStat;
    commErrors: DWord;
Begin { QueryPort }
    try
        If Not GetCommModemStatus(hPort, Status) then
        begin
            SysErrorMessage(GetLastError);
            if CommThread <> nil then
                StopService;
            Port422Init := false; // fmMain.btnStop.Click;
            Exit;
        end; { ������ ��� ��������� ������� ������ }

        // ��������� ���� �� ������� ��� ������. stat.cbInQue - ���������� ������ � �������
        if not PortRSStoped then
        begin
            if not ClearCommError(hPort, commErrors, @stat) then
                RaiseLastwin32error;
            If stat.cbInQue < 1 Then
                Exit;
            // ������ ����� �� Com-�����
            FillChar(MyBuff, SizeOf(MyBuff), #0);
            If Not ReadFile(hPort, MyBuff, SizeOf(MyBuff), ByteReaded, nil) then
            begin
                SysErrorMessage(GetLastError);
                if CommThread <> nil then
                    StopService;
                Port422Init := false; // fmMain.btnStop.Click;
                Exit;
            end; { ������ ��� ������ ������ }

            If ByteReaded > 0 then
            begin
                ReciveBytes := ReciveBytes + ByteReaded;
                // Str:='<' + ansistring(MyBuff) +'>';
                // str:='';
                for i := 0 to ByteReaded - 1 do
                    Str := Str + inttohex(ord(MyBuff[i]));

                s1 := Str;
                lststr := ''; // lstCommMes.Clear;
                lststr := lststr + s1; // lstCommMes.Add(s1);
                CommDataRead := true;
                // �������� ������ �� ��������

                // fmMain.Memo1.Text:=fmMain.Memo1.Text+#13#10+lststr;//fmMain.Memo1.Lines.AddStrings(lstCommMes);
                infoport.SetData(9, infoport.Options[8].Text);
                infoport.SetData(8, infoport.Options[7].Text);
                infoport.SetData(7, Str);
                infoport.SetData(6, MyDateTimeToStr(now));
                infoport.SetData(12, inttostr(ReciveBytes));
                // fmMain.lbRecv.Caption:='recv: '+IntToStr(ReciveBytes)+' bytes...';
            End; { ByteReaded>0 }
            // application.ProcessMessages;
        end;
    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End; { QueryPort }

function InitPort: boolean;
Var
    DCB: TDCB; // ��������� ��� �������� �������� �����
    CT: TCommTimeouts; // ��������� ��� �������� ����-�����
    lpcc: _COMMCONFIG;
    sz: DWord;
Begin { InitPort }
    try
        try
            Result := true;
            hPort := CreateFile(Pchar(port422name), GENERIC_READ or
              GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
              OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

            If (hPort < 0) Or Not SetupComm(hPort, 2048, 2048) Or
              Not GetCommState(hPort, DCB) then
            begin
                SysErrorMessage(GetLastError);
                StopService;
                Result := false;
                Exit;
            End; { ������ }

            GetCommState(hPort, DCB);

            // Port422Flow : string = '���';

            if trim(Port422Speed) = '' then
                DCB.BaudRate := 38400
            else
                DCB.BaudRate := StrToInt(Port422Speed);
            if trim(Port422Bits) = '' then
                DCB.ByteSize := 8
            else
                DCB.ByteSize := StrToInt(Port422Bits);
            if trim(Port422Parity) = '' then
                DCB.Parity := 1
            else if ansilowercase(trim(Port422Parity)) = '�����' then
                DCB.Parity := 1
            else if ansilowercase(trim(Port422Parity)) = '���' then
                DCB.Parity := 0
            else if ansilowercase(trim(Port422Parity)) = '���' then
                DCB.Parity := 2
            else if ansilowercase(trim(Port422Parity)) = '������' then
                DCB.Parity := 3
            else if ansilowercase(trim(Port422Parity)) = '������' then
                DCB.Parity := 4;

            if trim(Port422Stop) = '' then
                DCB.StopBits := 0
            else if ansilowercase(trim(Port422Stop)) = '1' then
                DCB.StopBits := 0
            else if ansilowercase(trim(Port422Stop)) = '1.5' then
                DCB.StopBits := 1
            else if ansilowercase(trim(Port422Stop)) = '2' then
                DCB.StopBits := 2;

            if trim(Port422Flow) = '' then
                DCB.Flags := DCB.Flags or $00000011
            else if ansilowercase(trim(Port422Flow)) = '���' then
                DCB.Flags := DCB.Flags and $00000011
            else if ansilowercase(trim(Port422Flow)) = 'XOn/XOff' then
                DCB.Flags := DCB.Flags and $00000311
            else if ansilowercase(trim(Port422Flow)) = '����������' then
                DCB.Flags := DCB.Flags and $00002015;


            // fmMain.StatusBar1.Panels[0].Text:=StringParameters(DCB.BaudRate,DCB.ByteSize,DCB.StopBits,DCB.Parity,DCB.Flags);

            If Not SetCommState(hPort, DCB) then
            begin { ������ }
                SysErrorMessage(GetLastError);
                StopService;
                Result := false;
                Exit;
            End; { ������ }

            // ������������� ��������� ����-�����
            If Not GetCommTimeouts(hPort, CT) then
            begin { ������ }
                SysErrorMessage(GetLastError);
                StopService;
                Result := false;
                Exit;
            End; { ������ }
            // ����-����
            CT.ReadTotalTimeoutConstant := 5; // 50;
            CT.ReadIntervalTimeout := 5; // 50;
            CT.ReadTotalTimeoutMultiplier := 1;
            CT.WriteTotalTimeoutMultiplier := 1; // 10;
            CT.WriteTotalTimeoutConstant := 1; // 10;

            If Not SetCommTimeouts(hPort, CT) then
            begin { ������ }
                SysErrorMessage(GetLastError);
                StopService;
                Result := false;
                Exit;
            End; { ������ }
        except
            MessageDlg('������ ��������� � ����� ' + port422name + '.',
              mtInformation, [mbOk], 0, mbOk);
            Result := false;
        end;
    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End; { InitPort }

Procedure WriteStrToPort(Str: ansistring);
Var
    ByteWritten: Cardinal;
    MyBuff: Array [0 .. 1023] Of ansichar;
Begin { WriteStrToPort }
    try
        FillChar(MyBuff, SizeOf(MyBuff), #0);
        StrLCopy(MyBuff, PansiChar(Str), Length(Str));

        infoport.SetData(1, MyDateTimeToStr(now));
        infoport.SetData(4, infoport.Options[3].Text);
        infoport.SetData(3, infoport.Options[2].Text);

        // �������� ������
        If Not WriteFile(hPort, MyBuff, Length(Str), ByteWritten, Nil) then
        begin
            SysErrorMessage(GetLastError);
            StopService;
            infoport.SetData(2, '������ ��������');
            Exit;
        End; { ������ }
        // ������� �������
        infoport.SetData(2, Str);
        SendBytes := SendBytes + ByteWritten;
        infoport.SetData(11, inttostr(SendBytes));
    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End; { WriteStrToPort }

Procedure WriteBuffToPort(cnt: Cardinal);
Var
    ByteWritten: Cardinal;
    stri: string;
    i: Integer;
Begin { WriteStrToPort }
    // �������� ������
    try
        infoport.SetData(1, MyDateTimeToStr(now));
        infoport.SetData(4, infoport.Options[3].Text);
        infoport.SetData(3, infoport.Options[2].Text);
        If Not WriteFile(hPort, InBuff, cnt, ByteWritten, Nil) then
        begin
            SysErrorMessage(GetLastError);
            StopService;
            infoport.SetData(2, '������ ��������');
            Exit;
        End; { ������ }
        // ������� �������
        stri := '';
        for i := 0 to cnt - 1 do
            stri := stri + inttohex(ord(InBuff[i]));
        infoport.SetData(2, stri);
        SendBytes := SendBytes + ByteWritten;
        infoport.SetData(11, inttostr(SendBytes));
        // fmMain.lbSend.Caption:='send: ' + IntToStr(SendBytes) + ' bytes...';

    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End; { WriteStrToPort }

Procedure WriteCharToPort(Ch: ansistring);
Var
    len, ByteWritten: Cardinal;
    s: ansistring;
    MyBuff: Array [0 .. 1023] Of ansichar;
    i: Integer;
Begin
    try
        // �������� ������
        s := Ch;
        len := Length(s);
        // for i:=1 to len do MyBuff[i-1]:=s[i];

        StrLCopy(MyBuff, PansiChar(s), Length(s));
        len := Length(s);

        infoport.SetData(1, MyDateTimeToStr(now));
        infoport.SetData(4, infoport.Options[3].Text);
        infoport.SetData(3, infoport.Options[2].Text);

        If Not WriteFile(hPort, MyBuff, len, ByteWritten, Nil) then
        begin
            SysErrorMessage(GetLastError);
            StopService;
            infoport.SetData(2, '������ ��������');
            Exit;
        End; { ������ }
        infoport.SetData(2, s);
        // application.ProcessMessages;
        // ������� �������
        SendBytes := SendBytes + ByteWritten;
        infoport.SetData(11, inttostr(SendBytes));
        // fmMain.lbSend.Caption:='send: ' + IntToStr(SendBytes) + ' bytes...';
    except
        if CommThread <> nil then
            StopService;
        Port422Init := false;
    end;
End;

Procedure StopService;
Begin { StopService }
    try
        if PortRSStoped then
            Exit;
        PortRSStoped := true;

        // fmMain.Memo1.Lines.Add('COM-port service stoped...');
        CommThread.Terminate;
        CloseHandle(hPort); // ��������� ����
        CommThreadExists := false;
        if CommThread <> nil then
            CommThread.Free;
        CommThread := nil; // "���������" �����
    except

    end;
End; { StopService }

function StartService: boolean;
var
    bl: boolean;
Begin { StartService }
    try
        Result := InitPort;
        if Result then
        begin
            StartComThread;
            // ���� ���� ��������������������, �� ��������� �����
            PortRSStoped := false;
        end;
        // fmMain.Memo1.Lines.Clear;
        // fmMain.Memo1.Lines.Add('COM-port service started...');
        SendBytes := 0;
        ReciveBytes := 0;
        infoport.SetData(11, inttostr(SendBytes));
        infoport.SetData(12, inttostr(ReciveBytes));
        // fmMain.lbSend.Caption:='send: '+IntToStr(SendBytes)+' bytes...';
        // fmMain.lbRecv.Caption:='recv: '+IntToStr(ReciveBytes)+' bytes...';
    except
    end;
End; { StartService }

initialization

lstCommMes := TStringList.Create;
lstCommMes.Clear;

finalization

lstCommMes.Free;

end.
