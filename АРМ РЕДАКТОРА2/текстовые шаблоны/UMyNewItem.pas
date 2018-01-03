unit UMyNewItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TfrMyNewItem = class(TForm)
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frMyNewItem: TfrMyNewItem;

function MyNewTextTemplate(rw : integer) : string;

implementation
uses umynewlist;
{$R *.dfm}

function MyNewTextTemplate(rw : integer) : string;
begin
  if rw=-1 then frMyNewItem.Edit1.Text := '' else frMyNewItem.Edit1.Text:=frnewlist.ListBox1.Items.Strings[rw];
  result := frMyNewItem.Edit1.Text;
  frMyNewItem.ShowModal;
  if frMyNewItem.ModalResult = mrok then begin
    result := trim(frMyNewItem.Edit1.Text);
  end;
end;

procedure TfrMyNewItem.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrok;
end;

procedure TfrMyNewItem.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrcancel;
end;

end.
