unit UPlayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, PasLibVlcUnit, vlcpl;

type

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TMouseActivate = (maDefault, maActivate, maActivateAndEat, maNoActivate, maNoActivateAndEat);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  TPlayerMode = (Stop, Play, Paused);



var
//Переменные для VLC Начало ++++++++++++++++++++++++++++++++++++++++++++++++++++

  //VLCPause : boolean = true;
  VLCDuration : int64;

//Переменные для VLC Окончание++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  hr: HRESULT = 1;                                    //задаем начальное значение ложь
  pCurrent, pDuration, pStart: Double;                // Текужее положение и длительность фильма
  OldParamPosition : longint = -1;                    //Старая позиция курсораэ
  VLCMode: TPlayerMode;                                  // режим воспроизведения
  Rate: Double;                                       // нормальная скорость воспроизведения
  FullScreen: boolean = false;                        //индикатор перехода в полноэкранный режим
  i: integer = 0;                                     // счетчик загруженных файлов
  FileName: string;                                   //имя файла
  xn, yn : integer;                                   //для хранения координат мыши
  mouse: tmouse;                                      //координаты мыши

  PNX : INTEGER;
  PNDOWN : BOOLEAN;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  procedure ClearVLCPlayer;
  function LoadVLCPlayer(FileName : string) : integer;
  //function GraphErrorToStr(err : integer) : string;
  procedure Player(FileName : string);
  procedure MediaSetPosition(Position : longint; replay : boolean; logplace : string);
  procedure MediaPlay;
  procedure MediaPause;
  procedure MediaStop;
  procedure MediaSlow(dlt : integer);
  procedure MediaFast(mng : integer);

implementation
uses umain, ucommon, ugrtimelines, umyfiles;


procedure ClearVLCPlayer;
begin
  VLCPlayer.Release;
end;

function LoadVLCPlayer(FileName : string) : integer;
begin
  result := 0;
  VLCmode := Paused;
  if (vlcplayer.p_li <> NIL) then begin
    vlcplayer.Load(PwideChar(UTF8Encode(FileName)));
    vlcmode := paused;

  end else begin
    vlcplayer.Create;
    if vlcplayer.Init(Form1.pnMovie.Handle)<>''
      then MessageDlg(VLCPlayer.error, mtError, [mbOK], 0)
      else begin
         vlcplayer.Load(PwideChar(UTF8Encode(FileName)));
         vlcmode := paused;
      end;
//    statusbar1.Panels[0].Text:=IntToStr(player.Duration);
//    statusbar1.Panels[2].Text:=IntToStr(player.width)+':'+IntToStr(player.height)+' '+player.aspect;
  end;
  //VLCPause:= true;
  //vlcplayer.Pause;
  MediaPause;
end;



procedure Player(FileName : string);
//процедура проигрывания файла
var Err : integer;
begin
  if libvlc_media_player_get_state(vlcplayer.p_mi)<>libvlc_Playing then begin
    if not FileExists(FileName) then begin
      ShowMessage('Файл не существует');
      exit;
    end;
//освобождаем канал воспроизведения
    Err := LoadVLCPlayer(FileName);
    If Err<>0 then begin
      //Showmessage(GraphErrorToStr(err));
      exit;
    end;
  end;
//Отображаем первый кадр
  Rate:=1;//pMediaPosition.get_Rate(Rate);
  //pMediaControl.Stop;
  //mode:=stop;
  //pMediaControl.Pause;
//  vlcplayer.Pause;
  vlcmode:=paused;
end;

//==============================================================================

//процедура изменения позиции проигрывания при изменении позиции ProgressBar (перемотка)
procedure MediaSetPosition(Position : longint; replay : boolean; logplace : string);
var ps, dur : int64;
    pdRate: Double;
    vlc_state : libvlc_state_t;
begin
  try
  //vlc_state := libvlc_media_player_get_state(VLCPlayer.p_li);
  if trim(Form1.lbPlayerFile.Caption)='' then exit;

  if libvlc_media_player_get_state(VLCPlayer.p_mi) = libvlc_Ended then begin
    if fileexists(Form1.lbPlayerFile.Caption) then
      LoadVLCPlayer(Form1.lbPlayerFile.Caption)
    else exit;
  end;
  ps := Position - TLParameters.Preroll;
  if ps < 0 then exit;
  vlcplayer.SetTime(ps*40);
  WriteLog('MAIN', 'UPlayer.MediaSetPosition (' + logplace + ') Position=' + FramesToStr(Position) + '|');
  except
  end;
end;

//процедура воспроизведения
procedure MediaPlay;
var dtc, ps : double;
    ps1, dlt, tc, fen : longint;
    vlc_state : libvlc_state_t;
begin
  //vlc_state:=libvlc_media_player_get_state(vlcplayer.p_mi);
  if vlcplayer.p_mi<>nil then begin
    if libvlc_media_player_get_state(vlcplayer.p_mi)=libvlc_Paused then begin
      StartMyTimer;
      vlcmode := play;
      vlcplayer.Play;
      StartMyTimer;
      exit;
    end ;
  end;

  dtc := now - TimeCodeDelta;
  tc := TimeToFrames(dtc);
  fen := TLParameters.Finish - TLParameters.Start;
  if MyStartPlay + fen < tc then MyStartPlay:=-1;
  if tc < MyStartPlay then MyStartPlay:=-1;
  if MyStartPlay=-1 then begin
    MyStartPlay:=TimeToFrames(dtc);
    form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor,72);
    form1.lbTypeTC.Caption := 'Старт в (' + trim(FramesToStr(MyStartPlay)) + ')';
  end;
  dlt := tc - MyStartPlay;

  if fileexists(Form1.lbPlayerFile.Caption) then begin
    if Form1.MySynhro.Checked then begin
      if (dlt>0) and (dlt<TLParameters.Finish-TLParameters.Start) then begin
        ps1 :=TLParameters.Start-TLparameters.Preroll + dlt;
        vlcplayer.SetTime(ps1*40);
      end;
    end;
  end else begin
    if Form1.MySynhro.Checked then begin
      if (dlt>0) and (dlt<=TLParameters.Finish-TLParameters.Start) then begin
        TLParameters.Position := TLParameters.Start + dlt;
      end;
    end;
  end;
  vlcmode := play;
  vlcplayer.play;
  WriteLog('MAIN', 'UPlayer.MediaPlay mode=play| Текущее время=' + framestostr(tc) + '  Время старта='  + framestostr(MyStartPlay) + '  Время окончания=' + framestostr(fen));
  StartMyTimer; //###### Warming
end;

//процедура паузы
procedure MediaPause;
begin
 //Проверяем идет ли воспроизведение
 if VLCPlayer.p_mi <> nil then begin
 //if not fileexists(Form1.lbPlayerFile.Caption) then exit;
   if libvlc_media_player_get_state(vlcplayer.p_mi)=libvlc_Playing then begin
     if fileexists(Form1.lbPlayerFile.Caption) then vlcplayer.Pause;
     vlcplayer.Pause;
     vlcmode:=paused;//устанавливаем playmode -> пауза
   //  WriteLog('MAIN', 'UPlayer.MediaPause mode=paused | Файл : ' + Form1.lbPlayerFile.Caption);
   //  StopMyTimer; //###### Warming
   end;
 end;
// end else begin
 //vlcmode:=paused;//устанавливаем playmode -> пауза
 WriteLog('MAIN', 'UPlayer.MediaPause mode=paused | Файл : Пусто');
 StopMyTimer;
 //end else begin
 //end;
end;

//процедура остановки
procedure MediaStop;
begin
//Проверяем идет ли воспроизведение
 if VLCPlayer.p_mi = nil then exit;
 if libvlc_media_player_get_state(vlcplayer.p_mi)=libvlc_Playing then
 begin
   StopMyTimer;
   if fileexists(Form1.lbPlayerFile.Caption) then vlcplayer.Pause;
   vlcmode:=paused;//Stop;
   WriteLog('MAIN', 'UPlayer.MediaStop mode=stop|');
   //задаем начальное положение проигравания
   //pMediaPosition.put_CurrentPosition(0);
   //TLZone.Position:=TLZone.TLScaler.Preroll + TLZone.TLScaler.Start;
   //TLZone.StopPosition:=TLZone.Position;
   TLZone.DrawTimelines(form1.imgtimelines.Canvas,bmptimeline);
 end;
end;

//процедура замедленного воспроизведения
procedure MediaSlow(dlt : integer);
var  pdRate: Double;
begin
 if vlcmode=play then begin
   if not fileexists(Form1.lbPlayerFile.Caption) then begin
     Rate := Rate/dlt;
     pStart := FramesToDouble(TLParameters.Position);
     application.ProcessMessages;
     exit;
   end;
   //читаем текущую скорость
   //pMediaPosition.get_Rate(pdRate);

   pdRate:=libvlc_media_player_get_rate(vlcplayer.p_mi);
   //уменьшаем ее в dlt раз
   //pMediaPosition.put_Rate(pdRate/dlt);
   libvlc_media_player_set_rate(vlcplayer.p_mi, pdRate/dlt);
   WriteLog('MAIN', 'UPlayer.MediaSlow Rate=' + FloatToStr(pdRate/dlt) +'|');
   application.ProcessMessages;
 end;
end;

//процедура ускоренного воспроизведения
procedure MediaFast(mng : integer);
var  pdRate: Double;
begin
 if vlcmode=play then  begin
   if not fileexists(Form1.lbPlayerFile.Caption) then begin
     Rate := Rate*mng;
     pStart := FramesToDouble(TLParameters.Position);
     application.ProcessMessages;
     exit;
   end;
   //читаем текущую скорость
   //pMediaPosition.get_Rate(pdRate);
   pdRate:=libvlc_media_player_get_rate(vlcplayer.p_mi);
   //увеличиваем ее в mng раз
   //pMediaPosition.put_Rate(pdRate*mng);
   libvlc_media_player_set_rate(vlcplayer.p_mi, pdRate*mng);
   WriteLog('MAIN', 'UPlayer.MediaFast Rate=' + FloatToStr(pdRate*mng) +'|');
   application.ProcessMessages;
 end;
end;

end.
