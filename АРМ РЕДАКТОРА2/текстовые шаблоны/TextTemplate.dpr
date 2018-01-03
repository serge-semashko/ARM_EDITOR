program TextTemplate;

uses
  Forms,
  UMyTextTemplate in 'UMyTextTemplate.pas' {frMyTextTemplate},
  UMyNewList in 'UMyNewList.pas' {frNewList};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrMyTextTemplate, frMyTextTemplate);
  Application.CreateForm(TfrNewList, frNewList);
  Application.Run;
end.
