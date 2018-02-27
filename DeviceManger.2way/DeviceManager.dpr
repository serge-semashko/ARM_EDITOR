program DeviceManager;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Form1},
  uwebget in 'uwebget.pas',
  blcksock in 'blcksock.pas',
  httpsend in 'httpsend.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
