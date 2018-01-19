unit main;

interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus,
  PasLibVlcUnit,vlcpl, StdCtrls, ComCtrls;
const
 libvlc_state :array[0..7] of string= (
    'libvlc_NothingSpecial',
    'libvlc_Opening',
    'libvlc_Buffering',
    'libvlc_Playing',
    'libvlc_Paused',
    'libvlc_Stopped',
    'libvlc_Ended',
    'libvlc_Error');

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
  private
    p_li : libvlc_instance_t_ptr;
    p_mi : libvlc_media_player_t_ptr;
    procedure PlayerInit();
    procedure PlayerPlay(fileName: WideString);
    procedure PlayerStop();
    procedure PlayerDestroy();
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Player :tvlcpl;
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
 player.Stop;
end;

procedure TMainForm.PlayerDestroy();
begin
  player.release;
end;

procedure TMainForm.Backward1Click(Sender: TObject);
var
 mlen :int64;
begin
 if (libvlc_media_player_get_state(Player.p_mi) = libvlc_Ended) then begin
      player.Load(PwideChar(UTF8Encode(OpenDialog.fileName)));
       mlen := libvlc_media_player_get_length(player.p_mi);
       pause1.Checked:= true;

      player.setTime( mlen);
 end;
 player.setTime( player.Time - 5000);

end;

procedure TMainForm.Begin1Click(Sender: TObject);
begin
//время в милисекундах
 if (libvlc_media_player_get_state(Player.p_mi) = libvlc_Ended) then begin
      player.Load(PwideChar(UTF8Encode(OpenDialog.fileName)));
      pause1.Checked:= true;
 end;

 player.setTime( 0);
end;

procedure TMainForm.End1Click(Sender: TObject);
var
 mlen : int64;

begin
 mlen := libvlc_media_player_get_length(player.p_mi);
                 //время в милисекундах
 if not (libvlc_media_player_get_state(Player.p_mi) = libvlc_Paused) then
    player.Pause;
 pause1.Checked:= true;
 player.setTime( mlen-100);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Player.Release;
  Player.Destroy;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Player:=TVlcPl.Create;
  if player.Init(panel2.Handle)<>'' then begin
    MessageDlg(Player.error, mtError, [mbOK], 0);
    exit;
  end;
end;

procedure TMainForm.MenuPlayClick(Sender: TObject);
begin
 player.Play;
end;

procedure TMainForm.MenuFileQuitClick(Sender: TObject);
begin
  player.Destroy;
  Close();
end;

procedure TMainForm.Load1Click(Sender: TObject);
begin
 pause1.Checked:= true;
  if (player.p_li <> NIL) then
  begin
    if OpenDialog.Execute() then
    begin
      player.Load(PwideChar(UTF8Encode(OpenDialog.fileName)));
      statusbar1.Panels[0].Text:=IntToStr(player.Duration);
      statusbar1.Panels[2].Text:=IntToStr(player.width)+':'+IntToStr(player.height)+' '+player.aspect;
    end;
  end;
end;

procedure TMainForm.Pause1Click(Sender: TObject);
begin
//переключение в паузу илт обратно
player.Pause;
pause1.Checked:=not pause1.Checked;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
 vlc_state : libvlc_state_t;
 msg : string;
begin
 if player.p_mi<>nil then begin
  vlc_state := libvlc_media_player_get_state(player.p_mi);
  msg := libvlc_state[integer(vlc_state)];
   statusbar1.Panels[1].Text:=IntToStr(player.Time);
   statusbar1.Panels[3].Text:=msg;
   if (libvlc_media_player_will_play(player.p_mi)  = 1) then
      statusbar1.Panels[5].Text:='Will'
      else statusbar1.Panels[5].Text:='unWill';
   if (libvlc_media_player_is_seekable(player.p_mi)= 1) then
      statusbar1.Panels[4].Text:='Seekable'
      else statusbar1.Panels[4].Text:='unSeekable';
 end;
end;

procedure TMainForm.Forward1Click(Sender: TObject);
begin
//время в милисекундах
 player.setTime( player.Time+5000);
end;

end.

