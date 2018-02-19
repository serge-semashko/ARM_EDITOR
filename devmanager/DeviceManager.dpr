program DeviceManager;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Form1},
  UDeviceManager in 'UDeviceManager.pas' {FrManager};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrManager, FrManager);
  Application.Run;
end.
