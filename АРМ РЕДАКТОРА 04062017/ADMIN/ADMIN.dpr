program ADMIN;

uses
  Forms,
  UMain in 'UMain.pas' {Form1},
  UCommon in 'UCommon.pas',
  UGrid in 'UGrid.pas',
  UIMGButtons in 'UIMGButtons.pas',
  UNewUser in 'UNewUser.pas' {frNewUser},
  UInitForms in 'UInitForms.pas',
  UChose in 'UChose.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrNewUser, frNewUser);
  Application.Run;
end.
