unit USetProcent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrSetProcent = class(TForm)
    ListBox1: TListBox;
    procedure Label1Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frSetProcent: TfrSetProcent;
  MyResult: integer;

procedure SetProcent(X, Y: integer);

implementation

{$R *.dfm}

uses umain, ucommon, ugrtimelines;

procedure SetProcent(X, Y: integer);
begin
  frSetProcent.Top := Y;
  frSetProcent.Left := X;
  case TLParameters.FrameSize of
    1:
      frSetProcent.ListBox1.ItemIndex := 0;
    2:
      frSetProcent.ListBox1.ItemIndex := 1;
    3:
      frSetProcent.ListBox1.ItemIndex := 2;
    4:
      frSetProcent.ListBox1.ItemIndex := 3;
    5, 6:
      frSetProcent.ListBox1.ItemIndex := 4;
    7:
      frSetProcent.ListBox1.ItemIndex := 6;
  else
    frSetProcent.ListBox1.ItemIndex := 7;
  end;
  frSetProcent.ShowModal;
  if frSetProcent.ModalResult = mrOk then
  begin
  end;
end;

procedure TfrSetProcent.Label1Click(Sender: TObject);
begin
  TLParameters.FrameSize := 1;
  ModalResult := mrOk;
end;

procedure TfrSetProcent.Label7Click(Sender: TObject);
begin
  TLParameters.FrameSize := 2;
  ModalResult := mrOk;
end;

procedure TfrSetProcent.Label6Click(Sender: TObject);
begin
  TLParameters.FrameSize := 3;
  ModalResult := mrOk;
end;

procedure TfrSetProcent.Label5Click(Sender: TObject);
begin
  TLParameters.FrameSize := 4;
  ModalResult := mrOk;
end;

procedure TfrSetProcent.Label4Click(Sender: TObject);
begin
  TLParameters.FrameSize := 5;
  ModalResult := mrOk;
end;

procedure TfrSetProcent.Label3Click(Sender: TObject);
begin
  TLParameters.FrameSize := 7;
  ModalResult := mrOk;
end;

procedure TfrSetProcent.Label2Click(Sender: TObject);
begin
  TLParameters.FrameSize := 10;
  ModalResult := mrOk;
end;

procedure TfrSetProcent.ListBox1Click(Sender: TObject);
var
  i: integer;
begin
  For i := 0 to ListBox1.Items.Count - 1 do
  begin
    if ListBox1.Selected[i] then
    begin
      Case i of
        0:
          TLParameters.FrameSize := 1;
        1:
          TLParameters.FrameSize := 2;
        2:
          TLParameters.FrameSize := 3;
        3:
          TLParameters.FrameSize := 4;
        4:
          TLParameters.FrameSize := 5;
        5:
          TLParameters.FrameSize := 7;
        6:
          TLParameters.FrameSize := 10;
      End;
      break;
    end
  end;
  ModalResult := mrOk;
end;

procedure TfrSetProcent.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  Case Key of
    #13:
      ListBox1Click(nil);
    #27:
      ModalResult := mrCancel;
  End;
end;

end.
