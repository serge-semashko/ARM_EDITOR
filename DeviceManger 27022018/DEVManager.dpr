program DEVManager;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {fmMain},
  ComPortUnit in 'ComPortUnit.pas',
  RusErrorStr in 'RusErrorStr.pas',
  UPortOptions in 'UPortOptions.pas' {frOptions},
  UDCB in 'UDCB.pas' {Form2},
  UMyChars in 'UMyChars.pas' {Form3},
  UMyWork in 'UMyWork.pas' {FrMyWork},
  UAddCommand in 'UAddCommand.pas' {FrAddCommand},
  UMySetTC in 'UMySetTC.pas' {FrSetTC},
  UMyInitFile in 'UMyInitFile.pas',
  UCommon in 'UCommon.pas',
  UMyInfo in 'UMyInfo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfrOptions, frOptions);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TFrMyWork, FrMyWork);
  Application.CreateForm(TFrAddCommand, FrAddCommand);
  Application.CreateForm(TFrSetTC, FrSetTC);
  Application.Run;
end.
