program ComPortService;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {fmMain},
  ComPortUnit in 'ComPortUnit.pas',
  RusErrorStr in 'RusErrorStr.pas',
  UPortOptions in 'UPortOptions.pas' {Form1},
  UDCB in 'UDCB.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
