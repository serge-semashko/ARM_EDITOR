unit UPlayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX;

type

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TMouseActivate = (maDefault, maActivate, maActivateAndEat, maNoActivate, maNoActivateAndEat);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  TPlayerMode = (Stop, Play, Paused);



var
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  hr: HRESULT = 1;                                    //задаем начальное значение ложь
  pCurrent, pDuration, pStart: Double;                // Текужее положение и длительность фильма
  Mode: TPlayerMode;                                  // режим воспроизведения
  Rate: Double;                                       // нормальная скорость воспроизведения
  FullScreen: boolean = false;                        //индикатор перехода в полноэкранный режим
  i: integer = 0;                                     // счетчик загруженных файлов
  FileName: string;                                   //имя файла
  xn, yn : integer;                                   //для хранения координат мыши
  mouse: tmouse;                                      //координаты мыши

  //интерфейсы для построения и управления графом
  pGraphBuilder        : IGraphBuilder         = nil; //сам граф
  pMediaControl        : IMediaControl         = nil; //управление графом
  pMediaEvent          : IMediaEvent           = nil; //обработчик событий
  pVideoWindow         : IVideoWindow          = nil; //задает окно для вывода
  pMediaPosition       : IMediaPosition        = nil; //позиция проигрывания
  pBasicAudio          : IBasicAudio           = nil; //управление звуком


  PNX : INTEGER;
  PNDOWN : BOOLEAN;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  procedure ClearGraph;
  function CreateGraph(FileName : string) : integer;
  function GraphErrorToStr(err : integer) : string;
  procedure Player(FileName : string; pn : Tpanel);
  procedure PlayerWindow(pn : tpanel);
  procedure MediaSetPosition(Position : longint; replay : boolean);
  procedure MediaPlay;
  procedure MediaPause;
  procedure MediaStop;
  procedure MediaSlow(dlt : integer);
  procedure MediaFast(mng : integer);

implementation
uses umain, ucommon, ugrtimelines;

procedure PlayerWindow(pn : tpanel);
begin
  //располагаем окошко с видео на панель
   pVideoWindow.Put_Owner(pn.Handle);//Устанавливаем "владельца" окна, в нашем случае Panel1
   pVideoWindow.Put_WindowStyle(WS_CHILD OR WS_CLIPSIBLINGS);//Стиль окна
   pVideoWindow.put_MessageDrain(pn.Handle);//указываем что Panel1 будет получать сообщения видео окна
   pVideoWindow.SetWindowPosition(0,0,pn.ClientRect.Right,pn.ClientRect.Bottom); //размеры
end;

procedure ClearGraph;
begin
  if Assigned(pMediaPosition) then pMediaPosition := nil;
  if Assigned(pBasicAudio) then pBasicAudio  := nil;
  if Assigned(pVideoWindow) then pVideoWindow := nil;
  if Assigned(pMediaEvent) then pMediaEvent := nil;
  if Assigned(pMediaControl) then pMediaControl := nil;
  if Assigned(pGraphBuilder) then pGraphBuilder := nil;
end;

function CreateGraph(FileName : string) : integer;
begin
  result := 0;
  //освобождаем подключенные интерфейсы
  ClearGraph;
//получаем интерфейс построения графа
  hr := CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, pGraphBuilder);
  if hr<>0 then begin
    result := 1;
    exit;
  end;
//получаем интерфейс управления
  hr := pGraphBuilder.QueryInterface(IID_IMediaControl, pMediaControl);
  if hr<>0 then begin
    result := 2;
    exit;
  end;
//получаем интерфейс событий
   hr := pGraphBuilder.QueryInterface(IID_IMediaEvent, pMediaEvent);
   if hr<>0 then begin
    result := 3;
    exit;
  end;
//получаем интерфейс управления окном вывода видео
  hr := pGraphBuilder.QueryInterface(IID_IVideoWindow, pVideoWindow);
  if hr<>0 then begin
    result := 4;
    exit;
  end;
//получаем интерфейс управления звуком
   hr := pGraphBuilder.QueryInterface(IBasicAudio, pBasicAudio);
  if hr<>0 then begin
    result := 5;
    exit;
  end;
//получаем интерфейс  управления позицией проигрывания
  hr := pGraphBuilder.QueryInterface(IID_IMediaPosition, pMediaPosition);
   if hr<>0 then begin
    result := 6;
    exit;
  end;
//загружаем файл для проигрывания
  hr := pGraphBuilder.RenderFile(StringToOleStr(PChar(filename)), '');
  if hr<>0 then begin
    result := 7;
    exit;
  end;
end;

function GraphErrorToStr(err : integer) : string;
begin
  result := '';
       case err of
  1: result := 'Не удается создать граф';
  2: result := 'Не удается получить интерфейс IMediaControl';
  3: result := 'Не удается получить интерфейс событий';
  4: result := 'Не удается получить IVideoWindow';
  5: result := 'Не удается получить аудио интерфейс';
  6: result := 'Не удается получить интерфейс управления позицией';
  7: result := 'Не удается прорендерить файл';
       end; //case
end;

procedure Player(FileName : string; pn : Tpanel);
//процедура проигрывания файла
var Err : integer;
begin
  if mode<>paused then begin
    if not FileExists(FileName) then begin
      ShowMessage('Файл не существует');
      exit;
    end;
//освобождаем канал воспроизведения
    Err := CreateGraph(FileName);
    If Err<>0 then begin
      Showmessage(GraphErrorToStr(err));
      exit;
    end;
    PlayerWindow(pn);
  end;
//Отображаем первый кадр
  pMediaPosition.get_Rate(Rate);
  pMediaControl.Stop;
  mode:=stop;
end;

//==============================================================================

//процедура изменения позиции проигрывания при изменении позиции ProgressBar (перемотка)
procedure MediaSetPosition(Position : longint; replay : boolean);
var ps : longint;
begin
  if hr = 0 then  begin
    ps := Position - TLParameters.Preroll;
    if ps < 0 then exit;
    pMediaControl.Stop;
    pMediaPosition.put_CurrentPosition(FramesToDouble(ps));
    if replay then pMediaControl.Run;
    mode:=play;
  end;
end;

//процедура воспроизведения
procedure MediaPlay;
begin
  if mode=play then begin pMediaPosition.put_Rate(Rate);exit;end ;
  pMediaControl.Run;
  pMediaPosition.get_Rate(Rate);
  mode := play;
  //Form1.Timer1.Enabled:=true;
  StartMyTimer; //###### Warming
end;

//процедура паузы
procedure MediaPause;
begin
 //Проверяем идет ли воспроизведение
 if mode=play then
 begin
   pMediaControl.Pause;
   mode:=paused;//устанавливаем playmode -> пауза
   Form1.Timer1.Enabled:=false;
   StopMyTimer; //###### Warming
   //TLZone.StopPosition:=TLZone.Position;
 end;
end;

//процедура остановки
procedure MediaStop;
begin
//Проверяем идет ли воспроизведение
 if mode=play then
 begin
   Form1.Timer1.Enabled:=false;
   StopMyTimer; //###### Warming
   pMediaControl.Stop;
   mode:=Stop;//устанавливаем playmode -> стоп
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
if mode=play then
 begin
 //читаем текущую скорость
 pMediaPosition.get_Rate(pdRate);
 //уменьшаем ее в dlt раз
 pMediaPosition.put_Rate(pdRate/dlt);
 end;
end;

//процедура ускоренного воспроизведения
procedure MediaFast(mng : integer);
var  pdRate: Double;
begin
if mode=play then
 begin
 //читаем текущую скорость
 pMediaPosition.get_Rate(pdRate);
 //увеличиваем ее в mng раз
 pMediaPosition.put_Rate(pdRate*mng);
 end;
end;

end.
