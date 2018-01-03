program WaveRecorder;

uses
  Forms,
  unit_main in 'unit_main.pas' {formMain},
  unit_property in 'unit_property.pas' {formProperty};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TformProperty, formProperty);
  Application.Run;
end.
