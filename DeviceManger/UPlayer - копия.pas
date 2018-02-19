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
  hr: HRESULT = 1;                                    //������ ��������� �������� ����
  pCurrent, pDuration, pStart: Double;                // ������� ��������� � ������������ ������
  Mode: TPlayerMode;                                  // ����� ���������������
  Rate: Double;                                       // ���������� �������� ���������������
  FullScreen: boolean = false;                        //��������� �������� � ������������� �����
  i: integer = 0;                                     // ������� ����������� ������
  FileName: string;                                   //��� �����
  xn, yn : integer;                                   //��� �������� ��������� ����
  mouse: tmouse;                                      //���������� ����

  //���������� ��� ���������� � ���������� ������
  pGraphBuilder        : IGraphBuilder         = nil; //��� ����
  pMediaControl        : IMediaControl         = nil; //���������� ������
  pMediaEvent          : IMediaEvent           = nil; //���������� �������
  pVideoWindow         : IVideoWindow          = nil; //������ ���� ��� ������
  pMediaPosition       : IMediaPosition        = nil; //������� ������������
  pBasicAudio          : IBasicAudio           = nil; //���������� ������


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
  //����������� ������ � ����� �� ������
   pVideoWindow.Put_Owner(pn.Handle);//������������� "���������" ����, � ����� ������ Panel1
   pVideoWindow.Put_WindowStyle(WS_CHILD OR WS_CLIPSIBLINGS);//����� ����
   pVideoWindow.put_MessageDrain(pn.Handle);//��������� ��� Panel1 ����� �������� ��������� ����� ����
   pVideoWindow.SetWindowPosition(0,0,pn.ClientRect.Right,pn.ClientRect.Bottom); //�������
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
  //����������� ������������ ����������
  ClearGraph;
//�������� ��������� ���������� �����
  hr := CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, pGraphBuilder);
  if hr<>0 then begin
    result := 1;
    exit;
  end;
//�������� ��������� ����������
  hr := pGraphBuilder.QueryInterface(IID_IMediaControl, pMediaControl);
  if hr<>0 then begin
    result := 2;
    exit;
  end;
//�������� ��������� �������
   hr := pGraphBuilder.QueryInterface(IID_IMediaEvent, pMediaEvent);
   if hr<>0 then begin
    result := 3;
    exit;
  end;
//�������� ��������� ���������� ����� ������ �����
  hr := pGraphBuilder.QueryInterface(IID_IVideoWindow, pVideoWindow);
  if hr<>0 then begin
    result := 4;
    exit;
  end;
//�������� ��������� ���������� ������
   hr := pGraphBuilder.QueryInterface(IBasicAudio, pBasicAudio);
  if hr<>0 then begin
    result := 5;
    exit;
  end;
//�������� ���������  ���������� �������� ������������
  hr := pGraphBuilder.QueryInterface(IID_IMediaPosition, pMediaPosition);
   if hr<>0 then begin
    result := 6;
    exit;
  end;
//��������� ���� ��� ������������
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
  1: result := '�� ������� ������� ����';
  2: result := '�� ������� �������� ��������� IMediaControl';
  3: result := '�� ������� �������� ��������� �������';
  4: result := '�� ������� �������� IVideoWindow';
  5: result := '�� ������� �������� ����� ���������';
  6: result := '�� ������� �������� ��������� ���������� ��������';
  7: result := '�� ������� ������������ ����';
       end; //case
end;

procedure Player(FileName : string; pn : Tpanel);
//��������� ������������ �����
var Err : integer;
begin
  if mode<>paused then begin
    if not FileExists(FileName) then begin
      ShowMessage('���� �� ����������');
      exit;
    end;
//����������� ����� ���������������
    Err := CreateGraph(FileName);
    If Err<>0 then begin
      Showmessage(GraphErrorToStr(err));
      exit;
    end;
    PlayerWindow(pn);
  end;
//���������� ������ ����
  pMediaPosition.get_Rate(Rate);
  pMediaControl.Stop;
  mode:=stop;
end;

//==============================================================================

//��������� ��������� ������� ������������ ��� ��������� ������� ProgressBar (���������)
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

//��������� ���������������
procedure MediaPlay;
begin
  if mode=play then begin pMediaPosition.put_Rate(Rate);exit;end ;
  pMediaControl.Run;
  pMediaPosition.get_Rate(Rate);
  mode := play;
  //Form1.Timer1.Enabled:=true;
  StartMyTimer; //###### Warming
end;

//��������� �����
procedure MediaPause;
begin
 //��������� ���� �� ���������������
 if mode=play then
 begin
   pMediaControl.Pause;
   mode:=paused;//������������� playmode -> �����
   Form1.Timer1.Enabled:=false;
   StopMyTimer; //###### Warming
   //TLZone.StopPosition:=TLZone.Position;
 end;
end;

//��������� ���������
procedure MediaStop;
begin
//��������� ���� �� ���������������
 if mode=play then
 begin
   Form1.Timer1.Enabled:=false;
   StopMyTimer; //###### Warming
   pMediaControl.Stop;
   mode:=Stop;//������������� playmode -> ����
   //������ ��������� ��������� ������������
   //pMediaPosition.put_CurrentPosition(0);
   //TLZone.Position:=TLZone.TLScaler.Preroll + TLZone.TLScaler.Start;
   //TLZone.StopPosition:=TLZone.Position;
   TLZone.DrawTimelines(form1.imgtimelines.Canvas,bmptimeline);
 end;
end;

//��������� ������������ ���������������
procedure MediaSlow(dlt : integer);
var  pdRate: Double;
begin
if mode=play then
 begin
 //������ ������� ��������
 pMediaPosition.get_Rate(pdRate);
 //��������� �� � dlt ���
 pMediaPosition.put_Rate(pdRate/dlt);
 end;
end;

//��������� ����������� ���������������
procedure MediaFast(mng : integer);
var  pdRate: Double;
begin
if mode=play then
 begin
 //������ ������� ��������
 pMediaPosition.get_Rate(pdRate);
 //����������� �� � mng ���
 pMediaPosition.put_Rate(pdRate*mng);
 end;
end;

end.
