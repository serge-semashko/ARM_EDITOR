unit UMyMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFMyMessage = class(TForm)
    spbYes: TSpeedButton;
    spbNot: TSpeedButton;
    Label1: TLabel;
    procedure spbYesClick(Sender: TObject);
    procedure spbNotClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMyMessage: TFMyMessage;

function  MyTextMessage(Title,Msg : string; btns : integer) : boolean;

implementation

uses uinitforms;

{$R *.dfm}

function MyTextMessage(Title,Msg : string; btns : integer) : boolean;
begin
  result:=false;
  if btns=1 then begin
     FMyMessage.spbNot.Visible:=false;
     FMyMessage.spbYes.Caption:='Ок';
     FMyMessage.spbYes.Left:=(FMyMessage.Width - FMyMessage.spbYes.Width) div 2;
  end else begin
     FMyMessage.spbNot.Visible:=True;
     FMyMessage.spbYes.Caption:='Да';
     FMyMessage.spbYes.Left:=FMyMessage.Width div 2 - FMyMessage.spbYes.Width - 1;
     FMyMessage.spbNot.Left:=FMyMessage.Width div 2 + 1;
  end;
  if trim(Title)='' then FMyMessage.Caption:='Сообщение' else FMyMessage.Caption:=trim(Title);
  FMyMessage.Label1.Caption := trim(Msg);
  FMyMessage.ShowModal;
  if FMyMessage.ModalResult = mrOk then begin
    Result := true;
  end;
end;

procedure TFMyMessage.spbYesClick(Sender: TObject);
begin
  Modalresult:=mrOk;
end;

procedure TFMyMessage.spbNotClick(Sender: TObject);
begin
  Modalresult:=mrCancel;
end;

procedure TFMyMessage.FormCreate(Sender: TObject);
begin
  InitMyMessage;
end;

procedure TFMyMessage.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=13 then ModalResult:=mrOk;
  if Key=27 then ModalResult:=mrCancel;
end;

end.
