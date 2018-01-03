program ADMIN;

uses
  Forms,
  UMain in 'UMain.pas' {Form1},
  UGrid in 'UGrid.pas',
  UIMGButtons in 'UIMGButtons.pas',
  UCommon in 'UCommon.pas',
  UNewUser in 'UNewUser.pas' {frNewUser};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrNewUser, frNewUser);
  Application.Run;
end.
