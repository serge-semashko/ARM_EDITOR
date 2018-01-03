program Transiver;

uses
  Forms,
  Trans in 'Trans.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
