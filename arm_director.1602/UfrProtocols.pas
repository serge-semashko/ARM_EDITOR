unit UfrProtocols;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TFrProtocols = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrProtocols: TFrProtocols;

procedure SetProtocol;

implementation

{$R *.dfm}

procedure SetProtocol;
begin
  FrProtocols.ShowModal;
  if FrProtocols.ModalResult=mrOk then begin

  end;
end;

end.
