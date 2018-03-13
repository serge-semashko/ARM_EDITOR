unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ComCtrls, StdCtrls, Buttons, DirectShow9, ActiveX;

type

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TMouseActivate = (maDefault, maActivate, maActivateAndEat, maNoActivate, maNoActivateAndEat);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  TPlayerMode = (Stop, Play, Paused); // ����� ���������������
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Timer1: TTimer;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Splitter1: TSplitter;
    Timer2: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    ListBox2: TListBox;
    TrackBar1: TTrackBar;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    SpeedButton6: TSpeedButton;
    Panel4: TPanel;
    N1: TMenuItem;
    N3: TMenuItem;
    Panel5: TPanel;
    procedure Initializ;
    procedure Player;
    procedure AddPlayList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ProgressBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1Resize(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer2Timer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox2MouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure ListBox2Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Panel5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    
  private
  { Private declarations }
  //��������� ��������� ��������� �� ����������
  Procedure WMKeyDown(Var Msg:TWMKeyDown); Message WM_KeyDown;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  hr: HRESULT = 1; //������ ��������� �������� ����
  pCurrent, pDuration: Double;// ������� ��������� � ������������ ������
  Mode: TPlayerMode; // ����� ���������������
  Rate: Double;// ���������� �������� ���������������
  FullScreen: boolean = false; //��������� �������� � ������������� �����
  i: integer = 0;// ������� ����������� ������
  FileName: string;//��� �����
  xn, yn : integer; //��� �������� ��������� ����
  mouse: tmouse; //���������� ����

  //���������� ��� ���������� � ���������� ������
  pGraphBuilder        : IGraphBuilder         = nil; //��� ����
  pMediaControl        : IMediaControl         = nil; //���������� ������
  pMediaEvent          : IMediaEvent           = nil; //���������� �������
  pVideoWindow         : IVideoWindow          = nil; //������ ���� ��� ������
  pMediaPosition       : IMediaPosition        = nil; //������� ������������
  pBasicAudio          : IBasicAudio           = nil; //���������� ������


  PNX : INTEGER;
  PNDOWN : BOOLEAN;

implementation

{$R *.dfm}

procedure TForm1.Initializ;
//��������� ���������� �����
begin
//����������� ������������ ����������
  if Assigned(pMediaPosition) then pMediaPosition := nil;
  if Assigned(pBasicAudio) then pBasicAudio  := nil;
  if Assigned(pVideoWindow) then pVideoWindow := nil;
  if Assigned(pMediaEvent) then pMediaEvent := nil;
  if Assigned(pMediaControl) then pMediaControl := nil;
  if Assigned(pGraphBuilder) then pGraphBuilder := nil;
//�������� ��������� ���������� �����
  hr := CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, pGraphBuilder);
  if hr<>0 then begin
    ShowMessage('�� ������� ������� ����');
    exit;
  end;
//�������� ��������� ����������
  hr := pGraphBuilder.QueryInterface(IID_IMediaControl, pMediaControl);
  if hr<>0 then begin
    ShowMessage('�� ������� �������� ��������� IMediaControl');
    exit;
  end;
//�������� ��������� �������
   hr := pGraphBuilder.QueryInterface(IID_IMediaEvent, pMediaEvent);
   if hr<>0 then begin
    ShowMessage('�� ������� �������� ��������� �������');
    exit;
  end;
//�������� ��������� ���������� ����� ������ �����
  hr := pGraphBuilder.QueryInterface(IID_IVideoWindow, pVideoWindow);
  if hr<>0 then begin
    ShowMessage('�� ������� �������� IVideoWindow');
    exit;
  end;
//�������� ��������� ���������� ������
   hr := pGraphBuilder.QueryInterface(IBasicAudio, pBasicAudio);
  if hr<>0 then begin
    ShowMessage('�� ������� �������� ����� ���������');
    exit;
  end;
//�������� ���������  ���������� �������� ������������
  hr := pGraphBuilder.QueryInterface(IID_IMediaPosition, pMediaPosition);
   if hr<>0 then begin
    ShowMessage('�� ������� �������� ��������� ���������� ��������');
    exit;
  end;
//��������� ���� ��� ������������
  hr := pGraphBuilder.RenderFile(StringToOleStr(PChar(filename)), '');
  if hr<>0 then begin
    ShowMessage('�� ������� ������������ ����');
    exit;
  end;

//����������� ������ � ����� �� ������
   pVideoWindow.Put_Owner(Panel1.Handle);//������������� "���������" ����, � ����� ������ Panel1
   pVideoWindow.Put_WindowStyle(WS_CHILD OR WS_CLIPSIBLINGS);//����� ����
   pVideoWindow.put_MessageDrain(Panel1.Handle);//��������� ��� Panel1 ����� �������� ��������� ����� ����
   pVideoWindow.SetWindowPosition(0,0,Panel1.ClientRect.Right,Panel1.ClientRect.Bottom); //�������
end;


procedure TForm1.Player;
//��������� ������������ �����
begin
if mode<>paused then begin
//��������� ���������� �� ���� ����������� �� PlayList
//���� ���� �� ����������, �� �������
if not FileExists(FileName) then begin ShowMessage('���� �� ����������');exit;end;
//����������� ����� ���������������
Initializ;
end;
//��������� ��������� ������������
pMediaControl.Run;
//�������� �������� ���������������
pMediaPosition.get_Rate(Rate);
//����������� ��������� ����� ��� �������������� �����
Form1.Caption:=ExtractFileName(FileName);
//������������� ����� ��������������� PlayMode - play
mode:=play;
end;


Procedure  TForm1.WMKeyDown(Var Msg:TWMKeyDown);
//����� �� �������������� ������ �� ������ ESC
begin
  if Msg.CharCode=VK_ESCAPE then
  begin
      pVideoWindow.HideCursor(False); //���������� ������
      //���������� ��������, ��������, ������ ���������� GroupBox
      Form1.ListBox2.Visible:=True;
      Form1.Splitter1.Visible:=True;
      Form1.CheckBox1.Checked:=True;
      Form1.GroupBox1.Visible:=True;
      //������������� �������� ��������� ����
      Form1.BorderStyle:=bsSizeable;
      Form1.windowState:= wsNormal;
      Form1.FormStyle:=fsNormal;
      //������ ������� ���� ������
      pVideoWindow.SetWindowPosition(0,0,Panel1.ClientRect.Right,Panel1.ClientRect.Bottom);
      FullScreen:=False;
end;
  inherited;
end;

//��������� �������� ������ � ��������
procedure TForm1.AddPlayList;
var
 j: Integer;
begin
OpenDialog1.Options:=[ofHideReadOnly,ofAllowMultiSelect,ofEnableSizing];
OpenDialog1.Title  := '�������� ������';
//������ ��� ������
OpenDialog1.Filter := '����� ����������� |*.mp3;*.wma;*.wav;*.vob;*.avi;*.mpg;*.mp4;*.mov;*.mpeg;*.flv;*.wmv;*.qt;|��� �����|*.*';
//��������� ���� PlayList �� ������ �� ���������� ����� ������� ������
//����� ������������� ����� ������ 0 (������ ������� � PlayList)
if listbox2.Count<>0 then i:=ListBox2.ItemIndex else i:=0;
//������ �������� �����
if not OpenDialog1.Execute then exit;
  Begin
   For j:=0 to OpenDialog1.Files.Count -1 do
    Begin
      ListBox2.Items.Add(ExtractFileName(OpenDialog1.Files.Strings[j]));
      ListBox1.Items.Add(OpenDialog1.Files.Strings[j]);
    End;
  End;
     //���������� ��� ����� ������� ������ � ���������
     Filename:=ListBox1.Items.Strings[i];
     //�������� ��� ������ � PlayList
     ListBox1.ItemIndex:=i;
     ListBox2.ItemIndex:=i;
end;


procedure TForm1.CheckBox1Click(Sender: TObject);
//���������� ��� �������� ��������
begin
if Form1.CheckBox1.Checked=True then
                                      begin
                                         Form1.ListBox2.Visible:=True;
                                         Form1.Splitter1.Visible:=True;
                                      end
                                else  begin
                                         Form1.ListBox2.Visible:=False;
                                         Form1.Splitter1.Visible:=False;
                                      end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CoInitialize(nil);// ���������������� OLE
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  CoUninitialize;// ������������������ OLE
end;


procedure TForm1.ListBox2Click(Sender: TObject);
begin
//������������� ���������� ������� � ���������� ��� ������
i:=ListBox2.Itemindex;
ListBox1.Itemindex:=i;
end;

procedure TForm1.ListBox2DblClick(Sender: TObject);
begin
//�������� ���� �� ��������� ��� ������� ����� ��� ���������������
 i:=ListBox2.Itemindex;
 ListBox1.Itemindex:=i;
 Filename:=ListBox1.Items.Strings[i];
 mode:=stop;
 //�������� ��������� ������������ �����
 player;
end;

//��������� ������ PopupMenu ��� ������� ������ ������� ���� �� ��������� (ListBox)
procedure TForm1.ListBox2MouseActivate(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
var
point : TPoint;
begin
  if (Button = mbRight) then
  // ������ ������ ����
  begin
    point.X := X;
    point.Y := Y;
    i := ListBox2.ItemAtPos(point, true);
    // �������� ������
    ListBox1.ItemIndex:=i;
    ListBox2.ItemIndex:=i;
      if i >= 0 then
    // ���� �������� �� ����� ������
    begin
    // ��������� ����
     PopupMenu1.Popup(ListBox2.ClientOrigin.X + X, ListBox2.ClientOrigin.Y + Y);
    end;
end;
end;

//��������� �������� ������� � ���������
procedure TForm1.N1Click(Sender: TObject);
begin
//������� ���������
ListBox1.Clear;
ListBox2.Clear;
end;

procedure TForm1.N2Click(Sender: TObject);
//�������� ������
begin
ListBox1.DeleteSelected;
ListBox2.DeleteSelected;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
//�������� ��������� �������� ���������
  AddPlayList;
end;

//��������� �������� � ������������� ����� � �������
procedure TForm1.Panel1DblClick(Sender: TObject);
var
Rct: TRect;
begin
if hr <> 0 then exit; //���� ���� �� �������� �������
pVideoWindow.HideCursor(False); //���������� ������
if FullScreen=False then begin
//�������� ��������, �������� � ������ ����������
Form1.ListBox2.Visible:=False;
Form1.Splitter1.Visible:=false;
Form1.GroupBox1.Visible:=false;
//������������� ��������� �����
Form1.BorderStyle:=bsNone; //��� �������
Form1.FormStyle :=fsstayOnTop; //������ ����
Form1.windowState:= wsMaximized;// �� ���� �����
//������������� ����� ����� �� ��� ������ ������
pVideoWindow.SetWindowPosition(0,0,screen.Width,screen.Height);
FullScreen:=True;
end
else begin
// ��������������� �������� ��� ������ �� �������������� ������
if form1.CheckBox1.Checked=true then  Form1.ListBox2.Visible:=True;
Form1.GroupBox1.Visible:=True;
Form1.Splitter1.Visible:=True;
Form1.BorderStyle:=bsSizeable;
Form1.windowState:= wsNormal;
Form1.FormStyle:=fsNormal;
pVideoWindow.SetWindowPosition(0,0,Panel1.ClientRect.Right,Panel1.ClientRect.Bottom);
FullScreen:=False;
end;
end;

//��������� ����������� ��������� � ������ ���������� ��� ��������� �� ��� ����
procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//������� ���� ����� �� �������������
if FullScreen<>True then Exit;
//�������� �������� ���� ������ ���� � ���� ������
if (mouse.CursorPos.X<panel1.Width) and (ListBox2.Visible=True) then
begin
Form1.ListBox2.Visible:=False;
Form1.Splitter1.Visible:=False;
end;
//���������� �������� ��� ��������� �� ��� ��������� ����, ���� �� ��� �������
if (mouse.CursorPos.X>=panel1.Width-ListBox2.Width) and (ListBox2.Visible=False) then
begin
if form1.CheckBox1.Checked=true then
  begin
    Form1.ListBox2.Visible:=True;
    Form1.Splitter1.Visible:=True;
  end;
end;

//���������� � ������� ���������� �������������
if (mouse.CursorPos.Y<panel1.Height) and (groupbox1.Visible=True) then
begin
groupbox1.Visible:=false;
end;

if (mouse.CursorPos.Y>=panel1.Height-groupbox1.Height) and (groupbox1.Visible=False) then
begin
groupbox1.Visible:=True;
end;
end;

//��������� ��������� ������� ���� ������������ ��� ��������� �������� ������
procedure TForm1.Panel1Resize(Sender: TObject);
begin
 if mode=play then
 begin
 pVideoWindow.SetWindowPosition(0,0,Panel1.ClientRect.Right,Panel1.ClientRect.Bottom);
end;
end;

//��������� ��������� ������� ������������ ��� ��������� ������� ProgressBar (���������)
procedure TForm1.ProgressBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p: real;
begin
if hr = 0 then  begin
  if ssleft in shift then //���� ������ ����� ������ ����
  begin
    p:=ProgressBar1.Max/ProgressBar1.Width;
    ProgressBar1.Position:=round(x*p);
    pMediaControl.Stop;
    pMediaPosition.put_CurrentPosition(ProgressBar1.Position);
    pMediaControl.Run;
    mode:=play;
  end;
end;
end;

//��������� ���������������
procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  //��������� ���� ��������������� ��� ���� �� �������������
  //���������� �������� ��������������� � �������
  if mode=play then begin pMediaPosition.put_Rate(Rate);exit;end ;
  Player;
end;

//��������� �����
procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 //��������� ���� �� ���������������
 if mode=play then
 begin
   pMediaControl.Pause;
   mode:=paused;//������������� playmode -> �����
 end;
end;

//��������� ���������
procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
//��������� ���� �� ���������������
 if mode=play then
 begin
   pMediaControl.Stop;
   mode:=Stop;//������������� playmode -> ����
   //������ ��������� ��������� ������������
   pMediaPosition.put_CurrentPosition(0);
 end;
end;

//��������� ������������ ���������������
procedure TForm1.SpeedButton4Click(Sender: TObject);
var  pdRate: Double;
begin
if mode=play then
 begin
 //������ ������� ��������
 pMediaPosition.get_Rate(pdRate);
 //��������� �� � ��� ����
 pMediaPosition.put_Rate(pdRate/2);
 end;
end;

//��������� ����������� ���������������
procedure TForm1.SpeedButton5Click(Sender: TObject);
var  pdRate: Double;
begin
if mode=play then
 begin
 //������ ������� ��������
 pMediaPosition.get_Rate(pdRate);
 //����������� �� � ��� ����
 pMediaPosition.put_Rate(pdRate*2);
 end;
end;


procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
//�������� ��������� �������� ���������
  AddPlayList;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
var
TrackLen, TrackPos: Double;
ValPos: Double;
ValLen: Double;
plVolume:Longint;
db  : integer;
begin
//������� �����
Panel4.Caption:=TimeToStr(SysUtils.Time);
//��������� ����� ���������������, ���� �� Play �� �������
if hr <> 0 then Exit;
//����� ������������ ������
//��������� ��� ����� ������ � ��������
pMediaPosition.get_Duration(pDuration);
//������ ������������ ��������� ProgressBar
ProgressBar1.Max:=round(pDuration);
//��������� ������� ������ ������ �� ������ ���������������
pMediaPosition.get_CurrentPosition(pCurrent);
//������ ������� ��������� ProgressBar
ProgressBar1.Position:=round(pCurrent);
 //��������������� ���������� ������
//���� ����� ������������ ����� ����� ������ �� �������,
if pCurrent=pDuration then
begin
//�� �������� ��������� ������ �� ���������
if i<ListBox2.Items.Count-1 then
   begin
    inc(i);
 Filename:=ListBox1.Items.Strings[i];
 ListBox1.ItemIndex:=i;
 ListBox2.ItemIndex:=i;
    mode:=stop;
    player;
   end
//���� ���� ���������� - �������
   else exit;
end;

//��������� ���������, ��������� �������� �� -10000 �� 0
//� ��������� ��� ����� ������������� ���� �������� ������� ������������ ������ � ����� �����
//pBasicAudio.put_Volume(TrackBar1.Position*100-10000);

//��� ���� ������� ������������� ���������. ����� ������� ������������� �����
plVolume:= (65535 * TrackBar1.Position) div 100;
//��������� �������������� ������ ���������
db:= trunc(33.22 * 100 * ln((plVolume+1e-6)/65535)/ln(10));
pBasicAudio.put_Volume(db);


//������ ���������� �������
TrackLen:=pDuration;
TrackPos:=pCurrent;
//��������� ������� � ����
ValPos:=TrackPos / (24 * 3600);
ValLen:=TrackLen / (24 * 3600);
//������� ������ � ������� �� ����� � Label1 � Label2
Label2.Caption:=FormatDateTime('hh:mm:ss',ValPos);
Label3.Caption:=FormatDateTime('hh:mm:ss',ValLen);
end;

//��������� ������� ������� � ������������� ������
procedure TForm1.Timer2Timer(Sender: TObject);
begin
if FullScreen<>True then Exit;
//��������� ��������� ������� � ���� �� �� ����������
//�� ������ ��������� ������ ��� �� ���� �����, �� �������� ������ ����� ����������
if ((xn-5)<=mouse.CursorPos.X) and ((yn-5)<=mouse.CursorPos.Y) and ((xn+5)>=mouse.CursorPos.X) and ((yn+5)>=mouse.CursorPos.Y)then
pVideoWindow.HideCursor(true)  else pVideoWindow.HideCursor(False);
//���������� ���������� �������
xn:=mouse.CursorPos.X;
yn:=mouse.CursorPos.Y;
end;

procedure TForm1.Panel5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   PNDOWN := TRUE;
   PNX:=X;
end;

procedure TForm1.Panel5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PNDOWN := false;
end;

procedure TForm1.Panel5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   IF PNDOWN then begin
     if X < PNX then SpeedButton4.OnClick(nil);
     if X > PNX then SpeedButton5.OnClick(nil);
     PNX:=X;
   end;
end;

end.
