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


implementation

end.
