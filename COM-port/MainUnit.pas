unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TfmMain = class(TForm)
    btnStart: TButton;
    btnSend: TButton;
    Memo1: TMemo;
    btnStop: TButton;
    lbSend: TLabel;
    lbRecv: TLabel;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edWriteStr: TMemo;
    cbSendChar: TCheckBox;
    cbComPort: TComboBox;
    SpeedButton1: TSpeedButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure edWriteStrKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;


implementation

uses ComPortUnit, UMTXButton, UMTXInput;

{$R *.DFM}

procedure TfmMain.btnStartClick(Sender: TObject);
var BR : Cardinal;
begin
//запускаем службу
BR := strtoint(combobox1.Items[Combobox1.ItemIndex]);
StartService(BR);
//кнопочки, лампочки :)
btnStart.Enabled:=False;
btnStop.Enabled:=True;
btnSend.Enabled:=True;
//btnMTX.Enabled:=True;
//bbClose.Enabled:=False;
Memo1.Lines.Clear;
Memo1.Lines.Add('COM-port service started...');
SendBytes:=0;
ReciveBytes:=0;
lbSend.Caption:='send: '+IntToStr(SendBytes)+' bytes...';
lbRecv.Caption:='recv: '+IntToStr(ReciveBytes)+' bytes...';
end;

procedure TfmMain.btnSendClick(Sender: TObject);
begin
//пишем в порт
WriteStrToPort(edWriteStr.Text);
end;

procedure TfmMain.btnStopClick(Sender: TObject);
begin
//кнопочки, лампочки :)
//fmMTX.Timer1.Enabled:=false;
Memo1.Lines.Add('COM-port service stoped...');
btnStop.Enabled:=False;
btnSend.Enabled:=False;
btnStart.Enabled:=True;
//btnMTX.Enabled:=false;
//bbClose.Enabled:=True;

//останавливаем службу
StopService;
end;

procedure TfmMain.edWriteStrKeyPress(Sender: TObject; var Key: Char);
begin
  if cbSendChar.Checked then begin
     WriteCharToPort(Key);
     //application.ProcessMessages;
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  lbrecv.Caption := GetSerialPortNames(cbComPort.Items);
  if cbComPort.Items.Count>0 then cbComPort.ItemIndex:=0;
end;

procedure TfmMain.SpeedButton1Click(Sender: TObject);
var lpcc : _COMMCONFIG;
    sz : dword;
begin
  GetCommConfig(hport,&lpcc,sz);
  CommConfigDialog(PChar(cbComPort.Items.Strings[cbComPort.ItemIndex]),Handle, &lpcc);
  SetCommConfig(hport,&lpcc,SizeOf(lpcc));
end;

end.
