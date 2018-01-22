unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses PsAPI, TlHelp32;
{$R *.dfm}
function GetThreadsInfo(PID:Cardinal): Boolean;
  var
    SnapProcHandle: THandle;
    NextProc      : Boolean;
    ThreadEntry  : TThreadEntry32;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0); //Создаем снэпшот всех существующих потоков
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
        ThreadEntry.dwSize := SizeOf(ThreadEntry);
        NextProc := Thread32First(SnapProcHandle, ThreadEntry);//получаем первый поток
        while NextProc do begin
          if ThreadEntry.th32OwnerProcessID = PID then begin //проверка на принадлежность к процессу
              Writeln('Thread ID      ' + inttohex(ThreadEntry.th32ThreadID, 8));
              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
              Writeln('');
          end;
          NextProc := Thread32Next(SnapProcHandle, ThreadEntry);//получаем следующий поток
        end;
      finally
        CloseHandle(SnapProcHandle);//освобождаем снэпшот
      end;
  end;
procedure TForm1.SpeedButton1Click(Sender: TObject);
function GetThreadsInfo(PID:Cardinal): Boolean;
  var
    SnapProcHandle: THandle;
    NextProc      : Boolean;
    ThreadEntry  : TThreadEntry32;
    infostr : string;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0); //Создаем снэпшот всех существующих потоков
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
            infostr := '';
        ThreadEntry.dwSize := SizeOf(ThreadEntry);
        NextProc := Thread32First(SnapProcHandle, ThreadEntry);//получаем первый поток
        while NextProc do begin
          if ThreadEntry.th32OwnerProcessID = PID then begin //проверка на принадлежность к процессу
//              Writeln('Thread ID      ' + inttohex(ThreadEntry.th32ThreadID, 8));
              infostr := infostr +('Thread ID      ' + inttohex(ThreadEntry.th32ThreadID, 8));
//              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
              infostr := infostr +(' base priority  ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
              infostr := infostr +(' delta priority ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('');
                memo1.Lines.Add(infostr);
                infostr := '';
          end;
          NextProc := Thread32Next(SnapProcHandle, ThreadEntry);//получаем следующий поток
        end;
      finally
        CloseHandle(SnapProcHandle);//освобождаем снэпшот
      end;
  end;

begin
 memo1.Clear;
 GetThreadsInfo(GetCurrentProcessId);

end;

end.
