program MyPrint;

uses
  Forms,
  UMyPrint in '������\UMyPrint.pas' {frMyPrint},
  MyData in '������\MyData.pas',
  UPageSetup in '������\UPageSetup.pas' {FPage};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrMyPrint, frMyPrint);
  Application.CreateForm(TFPage, FPage);
  Application.Run;
end.
