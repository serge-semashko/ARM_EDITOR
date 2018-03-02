program DeviceManager;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FrMain},
  uwebget in 'uwebget.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrMain, FrMain);
  Application.Run;
end.
