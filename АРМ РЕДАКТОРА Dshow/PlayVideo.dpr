program PlayVideo;

uses
  Forms,
  main in 'main.pas' {Form1},
  DirectShow9 in 'DirectShow9.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
