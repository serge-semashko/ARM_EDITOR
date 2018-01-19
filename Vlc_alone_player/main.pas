unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    btnPlay: TSpeedButton;
    btnStop: TSpeedButton;
    SpeedButton3: TSpeedButton;
    toolPanel: TPanel;
    Panel1: TPanel;
    od1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPlayClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  plibvlc_instance_t = type Pointer;
  plibvlc_media_player_t = type Pointer;
  plibvlc_media_t = type Pointer;

var
  Form1: TForm1;

var
  libvlc_media_new_path: function(p_instance: plibvlc_instance_t;
    path: PAnsiChar): plibvlc_media_t; cdecl;
  libvlc_media_new_location: function(p_instance: plibvlc_instance_t;
    psz_mrl: PAnsiChar): plibvlc_media_t; cdecl;
  libvlc_media_player_new_from_media: function(p_media: plibvlc_media_t)
    : plibvlc_media_player_t; cdecl;
  libvlc_media_player_set_hwnd
    : procedure(p_media_player: plibvlc_media_player_t;
    drawable: Pointer); cdecl;
  libvlc_media_player_play: procedure(p_media_player
    : plibvlc_media_player_t); cdecl;
  libvlc_media_player_stop: procedure(p_media_player
    : plibvlc_media_player_t); cdecl;
  libvlc_media_player_release
    : procedure(p_media_player: plibvlc_media_player_t); cdecl;
  libvlc_media_player_is_playing
    : function(p_media_player: plibvlc_media_player_t): Integer; cdecl;
  libvlc_media_release: procedure(p_media: plibvlc_media_t); cdecl;
  libvlc_new: function(argc: Integer; argv: PAnsiChar)
    : plibvlc_instance_t; cdecl;
  libvlc_release: procedure(p_instance: plibvlc_instance_t); cdecl;

  vlcLib: Integer;
  vlcInstance: plibvlc_instance_t;
  vlcMedia: plibvlc_media_t;
  vlcMediaPlayer: plibvlc_media_player_t;

implementation

{$R *.dfm}

// -----------------------------------------------------------------------------
// Read registry to get VLC installation path
// -----------------------------------------------------------------------------
function GetVLCLibPath: String;
var
  Handle: HKEY;
  RegType: Integer;
  DataSize: Cardinal;
  Key: PWideChar;
begin
  Result := '';
  Key := 'Software\VideoLAN\VLC';
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, Key, 0, KEY_READ, Handle) = ERROR_SUCCESS
  then
  begin
    if RegQueryValueEx(Handle, 'InstallDir', nil, @RegType, nil, @DataSize) = ERROR_SUCCESS
    then
    begin
      SetLength(Result, DataSize);
      RegQueryValueEx(Handle, 'InstallDir', nil, @RegType, PByte(@Result[1]),
        @DataSize);
      Result[DataSize] := '\';
    end
    else
      Showmessage('Error on reading registry');
    RegCloseKey(Handle);
    Result := String(PChar(Result));
  end;
end;

// -----------------------------------------------------------------------------
// Load libvlc library into memory
// Next, load library libvlc.dll into memory
// -----------------------------------------------------------------------------
function LoadVLCLibrary(APath: string): Integer;
begin
  Result := LoadLibrary(PWideChar(APath + '\libvlccore.dll'));
  Result := LoadLibrary(PWideChar(APath + '\libvlc.dll'));
end;

//Get address of libvlc functions
//This will get address of libvlc functions. Only neccessary functions loaded for this sample code, please refer to libvlc document if you need more functions

// -----------------------------------------------------------------------------
function GetAProcAddress(handle: integer; var addr: Pointer; procName: string; failedList: TStringList): integer;
begin
  addr := GetProcAddress(handle, PWideChar(procName));
  if Assigned(addr) then Result := 0
  else begin
    if Assigned(failedList) then failedList.Add(procName);
    Result := -1;
  end;
end;

// -----------------------------------------------------------------------------
// Get address of libvlc functions
// This will get address of libvlc functions.
// Only neccessary functions loaded for this sample code, please refer to libvlc document if you need more functions
// -----------------------------------------------------------------------------
function LoadVLCFunctions(vlcHandle: integer; failedList: TStringList): Boolean;
begin
  GetAProcAddress(vlcHandle, @libvlc_new, 'libvlc_new', failedList);
  GetAProcAddress(vlcHandle, @libvlc_media_new_location, 'libvlc_media_new_location', failedList);
  GetAProcAddress(vlcHandle, @libvlc_media_player_new_from_media, 'libvlc_media_player_new_from_media', failedList);
  GetAProcAddress(vlcHandle, @libvlc_media_release, 'libvlc_media_release', failedList);
  GetAProcAddress(vlcHandle, @libvlc_media_player_set_hwnd, 'libvlc_media_player_set_hwnd', failedList);
  GetAProcAddress(vlcHandle, @libvlc_media_player_play, 'libvlc_media_player_play', failedList);
  GetAProcAddress(vlcHandle, @libvlc_media_player_stop, 'libvlc_media_player_stop', failedList);
  GetAProcAddress(vlcHandle, @libvlc_media_player_release, 'libvlc_media_player_release', failedList);
  GetAProcAddress(vlcHandle, @libvlc_release, 'libvlc_release', failedList);
  GetAProcAddress(vlcHandle, @libvlc_media_player_is_playing, 'libvlc_media_player_is_playing', failedList);
  GetAProcAddress(vlcHandle, @libvlc_media_new_path, 'libvlc_media_new_path', failedList);
  // if all functions loaded, result is an empty list, otherwise result is a list of functions failed
  Result := failedList.Count = 0;
end;

procedure TForm1.btnPlayClick(Sender: TObject);
var
 filename : ansistring;
begin
  // create new vlc instance
  if not od1.execute then exit;
  vlcInstance := libvlc_new(0, nil);
  // create new vlc media from file
  filename := od1.filename;
  vlcMedia := libvlc_media_new_path(vlcInstance, pansichar(filename));

  // if you want to play from network, use libvlc_media_new_location instead
  // vlcMedia := libvlc_media_new_location(vlcInstance, 'udp://@225.2.1.27:5127');

  // create new vlc media player
  vlcMediaPlayer := libvlc_media_player_new_from_media(vlcMedia);

  // now no need the vlc media, free it
  libvlc_media_release(vlcMedia);

  // play video in a TPanel, if not call this routine, vlc media will open a new window
  libvlc_media_player_set_hwnd(vlcMediaPlayer, Pointer(Panel1.Handle));

  // play media
  libvlc_media_player_play(vlcMediaPlayer);

end;
procedure TForm1.btnStopClick(Sender: TObject);
begin
  if not Assigned(vlcMediaPlayer) then begin
    Showmessage('Not playing');
    Exit;
  end;
  // stop vlc media player
  libvlc_media_player_stop(vlcMediaPlayer);
  // and wait until it completely stops
  while libvlc_media_player_is_playing(vlcMediaPlayer) = 1 do begin
    Sleep(100);
  end;
  // release vlc media player
  libvlc_media_player_release(vlcMediaPlayer);
  vlcMediaPlayer := nil;

  // release vlc instance
  libvlc_release(vlcInstance);
end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // unload vlc library
  FreeLibrary(vlclib);
end;

procedure TForm1.FormCreate(Sender: TObject);
var sL: TStringList;
begin
  // load vlc library
  vlclib := LoadVLCLibrary(GetVLCLibPath());
  if vlclib = 0 then begin
    Showmessage('Load vlc library failed');
    Exit;
  end;
  // sL will contains list of functions fail to load
  sL := TStringList.Create;
  if not LoadVLCFunctions(vlclib, sL) then begin
    Showmessage('Some functions failed to load : ' + #13#10 + sL.Text);
    FreeLibrary(vlclib);
    sL.Free;
    Exit;
  end;
  sL.Free;
end;
procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
 libvlc_media_player_pause(p_mi);
end;

end.
