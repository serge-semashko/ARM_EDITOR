program Project1;

uses
  Forms,
  USimple in '..\..\..\..\Simple\USimple.pas' {Form1},
  MediaInfoDll in 'MediaInfoDLL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
