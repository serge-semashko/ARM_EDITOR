program webredis;

uses
  Forms,
  ipcthrd,
  mainsrv in 'mainsrv.pas' {HTTPSRVForm} ,
  System.Types,
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  Posix.Dlfcn, Posix.Fcntl, Posix.SysStat, Posix.SysTime, Posix.SysTypes,
  Posix.Locale,
{$ENDIF POSIX}
{$IFDEF PC_MAPPED_EXCEPTIONS}
  System.Internal.Unwinder,
{$ENDIF PC_MAPPED_EXCEPTIONS}
{$IFDEF MACOS}
  Macapi.Mach, Macapi.CoreServices, Macapi.CoreFoundation,
{$ENDIF MACOS}
  System.SysConst,
  dialogs;

// http in 'http.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(THTTPSRVForm, HTTPSRVForm);
  Application.Run;

end.
