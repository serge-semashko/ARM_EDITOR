unit main;

interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus,
  PasLibVlcUnit, vlcpl, StdCtrls, ComCtrls, Vcl.Buttons;

const
  libvlc_state: array [0 .. 7] of string = ('libvlc_NothingSpecial',
    'libvlc_Opening', 'libvlc_Buffering', 'libvlc_Playing', 'libvlc_Paused',
    'libvlc_Stopped', 'libvlc_Ended', 'libvlc_Error');

type
  TMainForm = class(TForm)
    OpenDialog: TOpenDialog;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuFileQuit: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    Load1: TMenuItem;
    Pause1: TMenuItem;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    Forward1: TMenuItem;
    Backward1: TMenuItem;
    Begin1: TMenuItem;
    End1: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure MenuPlayClick(Sender: TObject);
    procedure MenuFileQuitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Load1Click(Sender: TObject);
    procedure Pause1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Forward1Click(Sender: TObject);
    procedure Backward1Click(Sender: TObject);
    procedure Begin1Click(Sender: TObject);
    procedure End1Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    p_li: libvlc_instance_t_ptr;
    p_mi: libvlc_media_player_t_ptr;
    procedure PlayerInit();
    procedure PlayerPlay(fileName: WideString);
    procedure PlayerStop();
    procedure PlayerDestroy();
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Player: tvlcpl;

implementation

{$R *.dfm}

procedure TMainForm.PlayerInit();
begin
end;

procedure TMainForm.PlayerPlay(fileName: WideString);
begin
end;

procedure TMainForm.PlayerStop();
begin
  Player.Stop;
end;

procedure TMainForm.SpeedButton6Click(Sender: TObject);
begin
 Player.setRate(2);

end;

procedure TMainForm.SpeedButton7Click(Sender: TObject);
begin
 Player.setRate(0.5);
end;

procedure TMainForm.SpeedButton8Click(Sender: TObject);
begin
 Player.setRate(1);

end;

procedure TMainForm.PlayerDestroy();
begin
  Player.release;
end;

procedure TMainForm.Backward1Click(Sender: TObject);
var
  mlen: int64;
begin
  Player.setTime(Player.Time - 5000);

end;

procedure TMainForm.Begin1Click(Sender: TObject);
begin
  // ����� � ������������
  Player.setTime(0);
end;

procedure TMainForm.End1Click(Sender: TObject);
var
  mlen: int64;

begin
  if not(libvlc_media_player_get_state(Player.p_mi) = libvlc_Paused) then
    Player.Pause;
  Pause1.Checked := true;
  Player.setTime(Player.Duration - 100);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Player.release;
  Player.Destroy;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Player := tvlcpl.Create;
  if Player.Init(Panel2.Handle) <> '' then
  begin
    MessageDlg(Player.error, mtError, [mbOK], 0);
    exit;
  end;
end;

procedure TMainForm.MenuPlayClick(Sender: TObject);
begin
  Player.Play;
end;

procedure TMainForm.MenuFileQuitClick(Sender: TObject);
begin
  Player.Destroy;
  Close();
end;

procedure TMainForm.Load1Click(Sender: TObject);
begin
  Pause1.Checked := true;
  if (Player.p_li <> NIL) then
  begin
    if OpenDialog.Execute() then
    begin
      Player.Load(PwideChar(UTF8Encode(OpenDialog.fileName)));
      StatusBar1.Panels[0].Text := IntToStr(Player.Duration);
      StatusBar1.Panels[2].Text := IntToStr(Player.width) + ':' +
        IntToStr(Player.height) + ' ' + Player.aspect;
    end;
  end;
end;

procedure TMainForm.Pause1Click(Sender: TObject);
begin
  // ������������ � ����� ��� �������
  Player.Pause;
  Pause1.Checked := not Pause1.Checked;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  vlc_state: libvlc_state_t;
  msg: string;
begin
  if Player.p_mi <> nil then
  begin
    vlc_state := libvlc_media_player_get_state(Player.p_mi);
    msg := libvlc_state[integer(vlc_state)];
    StatusBar1.Panels[1].Text := IntToStr(Player.Time);
    StatusBar1.Panels[3].Text := msg;
    if (libvlc_media_player_will_play(Player.p_mi) = 1) then
      StatusBar1.Panels[5].Text := 'Will play'
    else
      StatusBar1.Panels[5].Text := 'unWill play';
    if (libvlc_media_player_is_seekable(Player.p_mi) = 1) then
      StatusBar1.Panels[4].Text := 'Seekable'
    else
      StatusBar1.Panels[4].Text := 'unSeekable';
      if Player.PlayerReady
         then StatusBar1.Panels[4].Text := 'ready '+StatusBar1.Panels[4].Text
         else StatusBar1.Panels[4].Text := 'not ready '+StatusBar1.Panels[4].Text;

  end;
end;

procedure TMainForm.Forward1Click(Sender: TObject);
begin
  // ����� � ������������
  Player.setTime(Player.Time + 5000);
end;

end.
