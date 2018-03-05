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
//���������� ��� VLC ������ ++++++++++++++++++++++++++++++++++++++++++++++++++++

  //VLCPause : boolean = true;
  VLCDuration : int64;

//���������� ��� VLC ���������++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  hr: HRESULT = 1;                                    //������ ��������� �������� ����
  pCurrent, pDuration, pStart: Double;                // ������� ��������� � ������������ ������
  OldParamPosition : longint = -1;                    //������ ������� ��������
  VLCMode: TPlayerMode;                                  // ����� ���������������
  Rate: Double;                                       // ���������� �������� ���������������
  FullScreen: boolean = false;                        //��������� �������� � ������������� �����
  i: integer = 0;                                     // ������� ����������� ������
  FileName: string;                                   //��� �����
  xn, yn : integer;                                   //��� �������� ��������� ����
  mouse: tmouse;                                      //���������� ����

  PNX : INTEGER;
  PNDOWN : BOOLEAN;


implementation

end.
