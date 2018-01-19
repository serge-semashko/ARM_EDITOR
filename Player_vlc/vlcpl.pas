unit vlcpl;
interface
uses PasLibVlcUnit,windows,classes,sysutils,forms;
type
TvlcPl = class
    public
    error :string;
    width :longword;
    Height:longWord;
    Aspect :string;
    Duration : int64;
    p_li : libvlc_instance_t_ptr;
    p_mi : libvlc_media_player_t_ptr;
    winhandle :hwnd;
    Constructor Create;
    Function Init(whandle:hwnd):string;
    Function Stop:Integer;
    Function SetTime(Time:int64):integer;
    Function Release:integer;
    Function Play:integer;
    Function Load(fileName: WideString):string;
    Function Pause:integer;
    Function Time:int64;

end;

implementation
Constructor TVlcPl.Create;
begin
 inherited create;
 aspect:='';
 p_mi:=nil;
 p_li:=nil;
 error:='';
end;

Function TVlcPl.init;
begin
  winhandle := whandle;
  libvlc_dynamic_dll_init();

  if (libvlc_dynamic_dll_error <> '') then
  begin
    Error:=libvlc_dynamic_dll_error;
    result:=error;
    exit;
  end;

  with TArgcArgs.Create([
    libvlc_dynamic_dll_path,
    '--intf=dummy',
    '--ignore-config',
    '--quiet',
    '--no-video-title-show',
    '--no-video-on-top'
  ]) do
  begin
    p_li := libvlc_new(ARGC, ARGS);
  if (libvlc_dynamic_dll_error <> '') then
  begin
    Error:=libvlc_dynamic_dll_error;
    result:=error;
    exit;
  end;
    Free;
  end;
  p_mi := NIL;
  result:='';
end;


function TvlcPl.Load(fileName: WideString): string;
var
  p_md : libvlc_media_t_ptr;
  histstate :string;
  i1 : integer;
  TD:libvlc_track_description_t_ptr;
  vlc_state :   libvlc_state_t;
begin
  if (p_mi <> NIL) then
  begin
    libvlc_media_player_stop(p_mi);
    libvlc_media_player_release(p_mi);
    p_mi := NIL;
  end;
//  p_md := libvlc_media_new_path(p_li, PAnsiChar(UTF8Encode(fileName)));
  p_md := libvlc_media_new_path(p_li, PAnsiChar(fileName));
  if (p_md <> NIL) then
  begin
    p_mi := libvlc_media_player_new_from_media(p_md);
    if (p_mi <> NIL) then
    begin
      libvlc_video_set_key_input(p_mi, 0);
      libvlc_video_set_mouse_input(p_mi,0 );
      libvlc_media_player_set_display_window(p_mi, winHandle);

    end;
    libvlc_media_release(p_md);
  end;
  libvlc_media_player_play(p_mi);

  histstate := '';
//    libvlc_state_t = (
//    libvlc_NothingSpecial, // 0,
//    libvlc_Opening,        // 1,
//    libvlc_Buffering,      // 2,
//    libvlc_Playing,        // 3,
//    libvlc_Paused,         // 4,
//    libvlc_Stopped,        // 5,
//    libvlc_Ended,          // 6,
//    libvlc_Error           // 7
//);

  vlc_state := libvlc_media_player_get_state(p_mi);
  while (libvlc_media_player_get_state(p_mi)<>libvlc_Playing) do begin
    sleep(1);
    application.processmessages;
    vlc_state := libvlc_media_player_get_state(p_mi);
  end;
  result:=histstate;
  if length(histstate)>255 then exit;
   Duration:=libvlc_media_player_get_length(p_mi);
   libvlc_video_get_size(p_mi,0,width,height);
   aspect:=libvlc_video_get_aspect_ratio(p_mi)+'/ '+libvlc_video_get_crop_geometry(p_mi)+'/'+
      IntToStr(libvlc_video_get_track_count(p_mi));
   td := libvlc_video_get_track_description(p_mi);
   aspect:=aspect+'/'+UTF8decode(td.psz_name);

   libvlc_media_player_pause(p_mi);
end;

function TvlcPl.Pause: integer;
begin
   libvlc_media_player_pause(p_mi);
end;

function TvlcPl.Play: integer;
begin
    libvlc_media_player_play(p_mi);
end;


function TvlcPl.Time: int64;
begin
// Duration:=libvlc_media_player_get_length(p_mi);
 result:=libvlc_media_player_get_time(p_mi);
end;

function TvlcPl.Release: integer;
begin
  if (p_li <> NIL) then
  begin
    Stop;
    libvlc_release(p_li);
    p_li := NIL;
  end;
  result:=0;
end;

function TvlcPl.SetTime(Time: int64): integer;
begin
  libvlc_media_player_set_time(p_mi,Time);

end;

function TvlcPl.Stop: Integer;
begin
  if (p_mi <> NIL) then
  begin
    libvlc_media_player_stop(p_mi);
    libvlc_media_player_release(p_mi);
    p_mi := NIL;
  end;
end;

end.
