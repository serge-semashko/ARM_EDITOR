unit UPlayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX;

type

  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TMouseActivate = (maDefault, maActivate, maActivateAndEat, maNoActivate,
    maNoActivateAndEat);
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  TPlayerMode = (Stop, Play, Paused);

var
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  hr: HRESULT = 1; // задаем начальное значение ложь
  pCurrent, pDuration, pStart: Double;
  // Текужее положение и длительность фильма
  Mode: TPlayerMode; // режим воспроизведения
  Rate: Double; // нормальная скорость воспроизведения
  FullScreen: boolean = false; // индикатор перехода в полноэкранный режим
  i: integer = 0; // счетчик загруженных файлов
  FileName: string; // имя файла
  xn, yn: integer; // для хранения координат мыши
  mouse: tmouse; // координаты мыши

  // интерфейсы для построения и управления графом
  pGraphBuilder: IGraphBuilder = nil; // сам граф
  pMediaControl: IMediaControl = nil; // управление графом
  pMediaEvent: IMediaEvent = nil; // обработчик событий
  pVideoWindow: IVideoWindow = nil; // задает окно для вывода
  pMediaPosition: IMediaPosition = nil; // позиция проигрывания
  pBasicAudio: IBasicAudio = nil; // управление звуком

  PNX: integer;
  PNDOWN: boolean;
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure ClearGraph;
function CreateGraph(FileName: string): integer;
function GraphErrorToStr(err: integer): string;
procedure Player(FileName: string; pn: Tpanel);
procedure PlayerWindow(pn: Tpanel);
procedure MediaSetPosition(Position: longint; replay: boolean; place: string);
procedure MediaPlay;
procedure MediaPause;
procedure MediaStop;
procedure MediaSlow(dlt: integer);
procedure MediaFast(mng: integer);

implementation

uses umain, ucommon, ugrtimelines, umyfiles;

procedure PlayerWindow(pn: Tpanel);
begin
  // располагаем окошко с видео на панель
  pVideoWindow.Put_Owner(pn.Handle);
  // Устанавливаем "владельца" окна, в нашем случае Panel1
  pVideoWindow.Put_WindowStyle(WS_CHILD OR WS_CLIPSIBLINGS); // Стиль окна
  pVideoWindow.put_MessageDrain(pn.Handle);
  // указываем что Panel1 будет получать сообщения видео окна
  pVideoWindow.SetWindowPosition(0, 0, pn.ClientRect.Right,
    pn.ClientRect.Bottom); // размеры
end;

procedure ClearGraph;
begin
  if Assigned(pMediaPosition) then
    pMediaPosition := nil;
  if Assigned(pBasicAudio) then
    pBasicAudio := nil;
  if Assigned(pVideoWindow) then
    pVideoWindow := nil;
  if Assigned(pMediaEvent) then
    pMediaEvent := nil;
  if Assigned(pMediaControl) then
    pMediaControl := nil;
  if Assigned(pGraphBuilder) then
    pGraphBuilder := nil;
end;

function CreateGraph(FileName: string): integer;
begin
  result := 0;
  // освобождаем подключенные интерфейсы
  ClearGraph;
  // получаем интерфейс построения графа
  hr := CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER,
    IID_IGraphBuilder, pGraphBuilder);
  if hr <> 0 then
  begin
    result := 1;
    exit;
  end;
  // получаем интерфейс управления
  hr := pGraphBuilder.QueryInterface(IID_IMediaControl, pMediaControl);
  if hr <> 0 then
  begin
    result := 2;
    exit;
  end;
  // получаем интерфейс событий
  hr := pGraphBuilder.QueryInterface(IID_IMediaEvent, pMediaEvent);
  if hr <> 0 then
  begin
    result := 3;
    exit;
  end;
  // получаем интерфейс управления окном вывода видео
  hr := pGraphBuilder.QueryInterface(IID_IVideoWindow, pVideoWindow);
  if hr <> 0 then
  begin
    result := 4;
    exit;
  end;
  // получаем интерфейс управления звуком
  hr := pGraphBuilder.QueryInterface(IBasicAudio, pBasicAudio);
  if hr <> 0 then
  begin
    result := 5;
    exit;
  end;
  // получаем интерфейс  управления позицией проигрывания
  hr := pGraphBuilder.QueryInterface(IID_IMediaPosition, pMediaPosition);
  if hr <> 0 then
  begin
    result := 6;
    exit;
  end;
  // загружаем файл для проигрывания
  hr := pGraphBuilder.RenderFile(StringToOleStr(PChar(FileName)), '');
  if hr <> 0 then
  begin
    result := 7;
    exit;
  end;
end;

function GraphErrorToStr(err: integer): string;
begin
  result := '';
  case err of
    1:
      result := 'Не удается создать граф';
    2:
      result := 'Не удается получить интерфейс IMediaControl';
    3:
      result := 'Не удается получить интерфейс событий';
    4:
      result := 'Не удается получить IVideoWindow';
    5:
      result := 'Не удается получить аудио интерфейс';
    6:
      result := 'Не удается получить интерфейс управления позицией';
    7:
      result := 'Не удается прорендерить файл';
  end; // case
end;

procedure Player(FileName: string; pn: Tpanel);
// процедура проигрывания файла
var
  err: integer;
begin
  if Mode <> Paused then
  begin
    if not FileExists(FileName) then
    begin
      ShowMessage('Файл не существует');
      exit;
    end;
    // освобождаем канал воспроизведения
    err := CreateGraph(FileName);
    If err <> 0 then
    begin
      ShowMessage(GraphErrorToStr(err));
      exit;
    end;
    PlayerWindow(pn);
  end;
  // Отображаем первый кадр
  pMediaPosition.get_Rate(Rate);
  // pMediaControl.Stop;
  // mode:=stop;
  pMediaControl.Pause;
  Mode := Paused;
end;

// ==============================================================================

// процедура изменения позиции проигрывания при изменении позиции ProgressBar (перемотка)
procedure MediaSetPosition(Position: longint; replay: boolean; place: string);
var
  ps: longint;
  pdRate: Double;
begin
  if not FileExists(Form1.lbPlayerFile.Caption) then
    exit;
  if hr = 0 then
  begin
    ps := Position - TLParameters.Preroll;
    if ps < 0 then
      exit;
    // pMediaControl.Stop;
    pMediaControl.Pause;
    pMediaPosition.get_Rate(pdRate);
    pMediaPosition.put_CurrentPosition(FramesToDouble(ps));
    pMediaPosition.put_Rate(pdRate);
    WriteLog('MAIN', 'UPlayer.MediaSetPosition (' + place + ') Position=' +
      FramesToStr(Position) + '|');
    // if replay then pMediaControl.Run;
    // mode:=play;
  end;
end;

// процедура воспроизведения
procedure MediaPlay;
var
  dtc, ps: Double;
  dlt, tc, fen: longint;
begin
  if Mode = Play then
  begin
    pMediaPosition.put_Rate(Rate);
    exit;
  end;

  dtc := now - TimeCodeDelta;
  tc := TimeToFrames(dtc);
  fen := TLParameters.Finish - TLParameters.Start;
  if MyStartPlay + fen < tc then
    MyStartPlay := -1;
  if tc < MyStartPlay then
    MyStartPlay := -1;
  if MyStartPlay = -1 then
  begin
    MyStartPlay := TimeToFrames(dtc);
    Form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor, 72);
    Form1.lbTypeTC.Caption := 'Старт в (' +
      trim(FramesToStr(MyStartPlay)) + ')';
  end;
  dlt := tc - MyStartPlay;

  if FileExists(Form1.lbPlayerFile.Caption) then
  begin
    pMediaControl.Run;
    pMediaPosition.get_Rate(Rate);
    pMediaPosition.put_Rate(Rate);
    if Form1.MySynhro.Checked then
    begin
      if (dlt > 0) and (dlt < TLParameters.Finish - TLParameters.Start) then
      begin
        ps := FramesToDouble(TLParameters.Start - TLParameters.Preroll + dlt);
        pMediaPosition.put_CurrentPosition(ps);
      end;
    end;
  end
  else
  begin
    if Form1.MySynhro.Checked then
    begin
      if (dlt > 0) and (dlt <= TLParameters.Finish - TLParameters.Start) then
      begin
        TLParameters.Position := TLParameters.Start + dlt;
      end;
    end;
  end;
  Mode := Play;
  WriteLog('MAIN', 'UPlayer.MediaPlay mode=play| Текущее время=' +
    FramesToStr(tc) + '  Время старта=' + FramesToStr(MyStartPlay) +
    '  Время окончания=' + FramesToStr(fen));
  StartMyTimer; // ###### Warming
end;

// процедура паузы
procedure MediaPause;
begin
  // Проверяем идет ли воспроизведение
  if Mode = Play then
  begin
    if FileExists(Form1.lbPlayerFile.Caption) then
    begin;
      pMediaPosition.get_Rate(Rate);
      pMediaPosition.put_Rate(Rate);
      pMediaControl.Pause;
    end;
    Mode := Paused; // устанавливаем playmode -> пауза
    WriteLog('MAIN', 'UPlayer.MediaPause mode=paused|');
    StopMyTimer; // ###### Warming
  end;
end;

// процедура остановки
procedure MediaStop;
begin
  // Проверяем идет ли воспроизведение
  if Mode = Play then
  begin
    // Form1.Timer1.Enabled:=false;
    StopMyTimer; // ###### Warming
    if FileExists(Form1.lbPlayerFile.Caption) then
      pMediaControl.Stop;
    Mode := Stop; // устанавливаем playmode -> стоп
    WriteLog('MAIN', 'UPlayer.MediaStop mode=stop|');
    // задаем начальное положение проигравания
    // pMediaPosition.put_CurrentPosition(0);
    // TLZone.Position:=TLZone.TLScaler.Preroll + TLZone.TLScaler.Start;
    // TLZone.StopPosition:=TLZone.Position;
    TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmptimeline);
  end;
end;

// процедура замедленного воспроизведения
procedure MediaSlow(dlt: integer);
var
  pdRate: Double;
begin
  if Mode = Play then
  begin
    if not FileExists(Form1.lbPlayerFile.Caption) then
    begin
      Rate := Rate / dlt;
      pStart := FramesToDouble(TLParameters.Position);
      application.ProcessMessages;
      exit;
    end;
    // читаем текущую скорость
    pMediaPosition.get_Rate(pdRate);
    // уменьшаем ее в dlt раз
    pMediaPosition.put_Rate(pdRate / dlt);
    WriteLog('MAIN', 'UPlayer.MediaSlow Rate=' +
      FloatToStr(pdRate / dlt) + '|');
    application.ProcessMessages;
  end;
end;

// процедура ускоренного воспроизведения
procedure MediaFast(mng: integer);
var
  pdRate: Double;
begin
  if Mode = Play then
  begin
    if not FileExists(Form1.lbPlayerFile.Caption) then
    begin
      Rate := Rate * mng;
      pStart := FramesToDouble(TLParameters.Position);
      application.ProcessMessages;
      exit;
    end;
    // читаем текущую скорость
    pMediaPosition.get_Rate(pdRate);
    // увеличиваем ее в mng раз
    pMediaPosition.put_Rate(pdRate * mng);
    WriteLog('MAIN', 'UPlayer.MediaFast Rate=' +
      FloatToStr(pdRate * mng) + '|');
    application.ProcessMessages;
  end;
end;

end.
