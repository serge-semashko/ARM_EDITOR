unit UMain;
                            
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer,  MMSystem, OpenGL, UCommon;

Const

//WM_DRAWTimeline = WM_APP + 9876;
WM_TRANSFER = WM_USER + 1;

type
//  PCompartido =^TCompartido;
//  TCompartido = record
//    Manejador1: Cardinal;
//    Manejador2: Cardinal;
//    Numero    : Integer;
//    Shift     : Double;
//    Cadena    : String[20];
//  end;

  TMyThread = class(TThread)
   private
     { Private declarations }
   protected
     procedure DoWork;
     procedure Execute; override;
   end;

 TForm1 = class(TForm)
    PanelControl: TPanel;
    PanelControlBtns: TPanel;
    PanelControlMode: TPanel;
    PanelControlClip: TPanel;
    PanelProject: TPanel;
    PanelClips: TPanel;
    PanelPlayList: TPanel;
    lbMode: TLabel;
    sbProject: TSpeedButton;
    sbClips: TSpeedButton;
    sbPlayList: TSpeedButton;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel10: TPanel;
    Splitter1: TSplitter;
    sbPredClip: TSpeedButton;
    Bevel1: TBevel;
    sbNextClip: TSpeedButton;
    GridProjects: TStringGrid;
    Panel11: TPanel;
    GridLists: TStringGrid;
    PanelPrepare: TPanel;
    PanelAir: TPanel;
    Label2: TLabel;
    Panel12: TPanel;
    GridClips: TStringGrid;
    Bevel2: TBevel;
    Bevel3: TBevel;
    imgButtonsProject: TImage;
    GridTimeLines: TStringGrid;
    imgButtonsControlProj: TImage;
    imgBlockProjects: TImage;
    lbProjectName: TLabel;
    lbDateStart: TLabel;
    lbDateEnd: TLabel;
    Panel1: TPanel;
    GridActPlayList: TStringGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    pnPrepareCTL: TPanel;
    pnMovie: TPanel;
    pnTypeMovie: TPanel;
    pnPrepareSong: TPanel;
    imgCTLPrepare1: TImage;
    imgTypeMovie: TImage;
    PnDevTL: TPanel;
    PnTextTL: TPanel;
    pnMediaTL: TPanel;
    imgDeviceTL: TImage;
    RichEdit1: TRichEdit;
    imgTextTL: TImage;
    imgMediaTL: TImage;
    imgTLNames: TImage;
    imgTimelines: TImage;
    lbSongName: TLabel;
    lbNomClips: TLabel;
    lbSongSinger: TLabel;
    lbClipName: TLabel;
    imgSongLock: TImage;
    imgCTLBottomL: TImage;
    imgpnlbtnspl: TImage;
    imgpnlbtnsclips: TImage;
    ApplicationEvents1: TApplicationEvents;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Bevel6: TBevel;
    lbEditor: TLabel;
    ImgDevices: TImage;
    imgEvents: TImage;
    lbClip: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lbClipSinger: TLabel;
    lbClipTotalDur: TLabel;
    lbClipNTK: TLabel;
    lbClipDur: TLabel;
    lbClipType: TLabel;
    lbClipSong: TLabel;
    lbClipPath: TLabel;
    lbClipComment: TLabel;
    lbPlayList1: TLabel;
    lbPLCLPComment: TLabel;
    Image1: TImage;
    Image2: TImage;
    OpenDialog1: TOpenDialog;
    Panel7: TPanel;
    lbCTLTimeCode: TLabel;
    imgCtlBottomR: TImage;
    Timer1: TTimer;
    imgLayer1: TImage;
    imgLayer2: TImage;
    lbpComment: TLabel;
    //lbPLName: TLabel;
    Panel8: TPanel;
    Panel9: TPanel;
    lbPlayerFile: TLabel;
    OpenDialog2: TOpenDialog;
    ImgLayer0: TImage;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    GridGRTemplate: TStringGrid;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel16: TPanel;
    Label1: TLabel;
    pnImageScreen: TPanel;
    Image3: TImage;
    lbActiveClipID: TLabel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Label13: TLabel;
    Label16: TLabel;
    lbMediaNTK: TLabel;
    lbMediaDuration: TLabel;
    lbMediaKTK: TLabel;
    lbMediaTotalDur: TLabel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Label18: TLabel;
    Label19: TLabel;
    lbMediaCurTK: TLabel;
    spDeleteTemplate: TSpeedButton;
    Timer2: TTimer;
    Label7: TLabel;
    InputPanel: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label8: TLabel;
    Label14: TLabel;
    SpeedButton1: TSpeedButton;
    lbTypeTC: TLabel;
    Bevel7: TBevel;
    Panel23: TPanel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Label15: TLabel;
    Panel24: TPanel;
    ImgButtonsPL: TImage;
    Panel25: TPanel;
    cbPlayLists: TComboBox;
    lbplclip: TLabel;
    Bevel4: TBevel;
    lbplsong: TLabel;
    lbplsinger: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    lbplmdur: TLabel;
    lbplntk: TLabel;
    lbpldur: TLabel;
    Label25: TLabel;
    lbplfulldur: TLabel;
    Label27: TLabel;
    lbplstrt: TLabel;
    lbplfile: TLabel;
    Label17: TLabel;
    lbclipfulldur: TLabel;
    Panel26: TPanel;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Label20: TLabel;
    lbclipactpl: TLabel;
    Bevel12: TBevel;
    lbplcomment: TLabel;
    sbSinhronization: TSpeedButton;
    lbusesclpidlst: TLabel;
    Bevel5: TBevel;
    Bevel13: TBevel;
    LBTimeCode1: TLabel;
    procedure GridListsMouseUpPlaylists(X, Y: Integer);
    procedure GridListsMouseUpTextTemplates(X, Y: Integer);
    procedure GridListsMouseUpGRTemplates(X, Y: Integer);
    //procedure AddPlayList;
    procedure sbProjectClick(Sender: TObject);
    procedure sbClipsClick(Sender: TObject);
    procedure sbPlayListClick(Sender: TObject);
    procedure lbModeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure sbListPlayListsClick(Sender: TObject);
    procedure sbListGraphTemplatesClick(Sender: TObject);
    procedure sbListTextTemplatesClick(Sender: TObject);
    procedure GridProjectsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Panel5Resize(Sender: TObject);
    procedure GridProjectsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridProjectsDblClick(Sender: TObject);
    procedure GridListsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridListsDblClick(Sender: TObject);
    procedure GridListsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgButtonsProjectMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridProjectsTopLeftChanged(Sender: TObject);
    procedure GridTimeLinesDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure imgButtonsControlProj1MouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridTimeLinesDblClick(Sender: TObject);
    procedure pnMovieResize(Sender: TObject);
    procedure imgButtonsControlProj1MouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure imgButtonsProjectMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCTLPrepare1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCTLPrepare1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgTLNamesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgpnlbtnsplMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgpnlbtnsplMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgpnlbtnsclipsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgpnlbtnsclipsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgDeviceTLMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgDeviceTLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgTLNamesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure imgMediaTLMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgMediaTLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridListsTopLeftChanged(Sender: TObject);
    procedure imgCTLBottomLMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure imgCTLBottomLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCtlBottomRMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCtlBottomRMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GridClipsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridClipsDblClick(Sender: TObject);
    procedure GridClipsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure GridClipsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridActPlayListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sbPredClipClick(Sender: TObject);
    procedure sbNextClipClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure imgLayer2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgLayer2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgLayer2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridClipsTopLeftChanged(Sender: TObject);
    procedure imgBlockProjectsClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridActPlayListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure imgTextTLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgTextTLMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
    procedure GridGRTemplateDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridGRTemplateMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgLayer2DblClick(Sender: TObject);
    procedure GridProjectsRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure GridProjectsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridListsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridClipsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridActPlayListMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgTypeMovieMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgTypeMovieMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridGRTemplateDblClick(Sender: TObject);
    procedure spDeleteTemplateClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RichEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ImgButtonsPLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonsPLMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure cbPlayListsChange(Sender: TObject);
    procedure sbSinhronizationClick(Sender: TObject);
    procedure GridTimeLinesTopLeftChanged(Sender: TObject);


  private
    { Private declarations }
    //Compartido : PCompartido;
    FicheroM   : THandle;
    procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
    // Обработчик сообщения WM_HOTKEY
    procedure WMHotKey(var Mess:TWMHotKey);message WM_HOTKEY;
    Procedure WMKeyDown(Var Msg:TWMKeyDown); Message WM_KeyDown;
    //procedure WMDRAWTimeline(var msg:TMessage); Message WM_DRAWTimeline;
    procedure WMEraseBackGround(var msg:TMessage); Message WM_EraseBkgnd;
    procedure WM_GETMINMAXINFO( var msg : TWMGETMINMAXINFO ); message wm_GetMinMaxInfo;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
    Compartido : PCompartido;
  end;

var
  Form1: TForm1;

  MyTimer : THRTimer;
  MyThread : TMyThread;
  PredDt, CurrDt, pStart1 : Double;


  mmResult : Integer;
  //strgrrect : TGridRect;

  procedure SetMediaButtons;
  procedure StartMyTimer;
  procedure StopMyTimer;
  Function ReadMyTimer : Double;
  procedure WaitingStart(wrd : string);
  procedure WaitingStop;

implementation

uses UInitForms, UGrid, UProject, UIMGButtons, UDelGridRow, UTimeline,
     UDrawTimelines, uimportfiles, uactplaylist, ugrtimelines, uwaiting, umyevents,
     uplaylists, UMyFiles, UTextTemplate, UMyMessage, UImageTemplate, uAirDraw,
     USubtitrs, USetTemplate, ugridsort, uwebserv ,ulkjson, uMyMediaSwitcher,
     ushifttl, ushortnum, umyinifile, uevswapbuffer, uLock, umyundo, UlistUsers,
     umyltc, usettc, UMyTextTemplate;

{$R *.dfm}
{$R bmpres.res}

procedure Tform1.Reciviendo(var Msg: TMessage);
begin
  //label1.Caption:=compartido^.Cadena;
  MyShiftOld := MyShift;
  MyShift := compartido^.Shift;
  compartido^.Cadena:='';
end;

procedure TForm1.WM_GETMINMAXINFO(var msg: TWMGETMINMAXINFO);
begin
  with msg.minmaxinfo^ do
  begin
    ptmaxposition.x := BorderWidth;
    ptmaxposition.y := BorderWidth;

    ptmaxsize.x := Screen.Width;
    ptmaxsize.y := Screen.Height;

    ptMinTrackSize.x:=Screen.Width;
    ptMinTrackSize.y:=Screen.Height;
    ptMaxTrackSize.x:=Screen.Width;
    ptMaxTrackSize.y:=Screen.Height;
  end;
  imgTypeMovie.Repaint;
end;

procedure TForm1.WMSysCommand(var Msg: TWMSysCommand);
begin
  if ((Msg.CmdType and $FFF0) = SC_MOVE) then begin
    Msg.Result := 0;
    Exit;
  end;
  inherited;
end;

//==============================================================================
//====         Процедуры работы с точным таймером         ======================
//==============================================================================

//procedure  TForm1.WMDRAWTimeline(var msg:TMessage);
//begin
  //MyPanelAir.SetValues;
//  MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, msg.WParam);
  //application.ProcessMessages;
     //if bmptimeline.Canvas.LockCount =0 then TLZone.DrawBitmap(bmptimeline);
      //if Form1.imgtimelines.Canvas.LockCount<>0 then exit;
  //TLZone.DrawBitmap(bmptimeline);
//  TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
//  if Form1.PanelAir.Visible then MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);

//end;

procedure TForm1.WMEraseBackGround(var msg:TMessage);
begin
  if mode=play then  InvalidateRect(form1.imgTimelines.Canvas.Handle, NIL, FALSE);
end;

procedure TimeCallBack(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); stdcall;
begin
  FWait.Position:=FWait.Position+1;
  FWait.Draw;
end;

procedure WaitingStart(wrd : string);
begin
  FWait.Position := 0;
  FWait.Draw;
  FWait.Repaint;
  FWait.Show;
  application.ProcessMessages;
  MyTimer.Waiting:=true;
end;

procedure WaitingStop;
begin
  MyTimer.Waiting:=false;
  FWait.Close;
end;



procedure TMyThread.Execute;
 begin
   //MyThread.Priority:=tpTimeCritical;
   {Если Вы хотите, чтобы процедура DoWork выполнялась лишь один раз - удалите цикл while}
   while not Terminated do
     Synchronize(DoWork);
 end;

procedure TMyThread.DoWork;
var curpos, delttm : longint;
    dbpr, dbcr, dps : double;
    db0, db1, db2, db3 : double;
    crpos : TEventReplay;
    CurrTemplate : string;
    dtt, dt, dts, dte, dtc : double;
    fcr, ftm, fst, fen : longint;
begin
  try
// Если ни одного клипа не загруженно в окно подготовки выходим из данного модуля
//   if trim(form1.lbActiveClipID.Caption)='' then exit;
// Анализируем состояние системы на предмет запуска по времени.
// Если установлена синхронизация по времени, ожидаем время запуска.
   if MySinhro<>chnone then begin
     //if mode<>play then Form1.lbCTLTimeCode.Caption:=MyDateTimeToStr(now-TimeCodeDelta);
     application.ProcessMessages;
     dtc := now-TimeCodeDelta;
     ftm := TimeToFrames(dtc);
     fen := MyStartPlay + (TLParameters.Finish-TLParameters.Start);
     if (MyStartPlay<>-1) and (ftm < MyStartPlay-125) and MyStartReady then form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor,64);
     if (MyStartPlay<>-1) and (ftm > MyStartPlay-125) and (ftm < MyStartPlay) and MyStartReady then begin
       form1.lbTypeTC.Font.Color := clLime;
       MyRemainTime := MyStartPlay - ftm;
       TLParameters.Position := TLParameters.Start;
       TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
       if Form1.PanelAir.Visible then begin
         MyPanelAir.AirEvents.Draw(Form1.ImgEvents.Canvas);
         MyPanelAir.AirDevices.Draw(Form1.ImgDevices.Canvas);
         MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, TLParameters.Position - TLParameters.ZeroPoint);
       end;
       application.ProcessMessages;
       MediaSetPosition(TLParameters.Position, false);
     end;
     if (MyStartPlay<=ftm) and (mode<>play) and MyStartReady then begin
       form1.lbTypeTC.Font.Color := ProgrammFontColor;
       MyRemainTime := -1;
       MyShiftOld := MyShift;
       MyStartReady := false;
       MediaStop;
       if ftm < fen then begin
         TLParameters.Position := TLParameters.Start + ftm-MyStartPlay;
         MediaSetPosition(TLParameters.Position, false);
         //SetProcessWorkingSetSize(GetCurrentProcess,$FFFFFFFF,$FFFFFFFF);
         MediaPlay;
       end;
       SetMediaButtons;
       mystartplay:=-1;
     end;
   end;
   if {(trim(form1.lbActiveClipID.Caption)<>'') and} MyStartReady then begin
     MyShiftDelta := MyShift - MyShiftOld;
     MyShiftOld := MyShift;
     if (MyShiftDelta<>0) and (mode=play) then begin
        if MyShiftDelta<0 then begin
          MyShiftDelta := - MyShiftDelta;
          fcr := TimeToFrames(MyShiftDelta);
          MediaStop;
          TLParameters.Position := TLParameters.Position + fcr;
          MediaSetPosition(TLParameters.Position, false);
          MediaPlay;
          //SetProcessWorkingSetSize(GetCurrentProcess,$FFFFFFFF,$FFFFFFFF);
          mystartplay:=-1;
        end else begin
          fcr := TimeToFrames(MyShiftDelta);
          MediaStop;
          TLParameters.Position := TLParameters.Position - fcr;
          MediaSetPosition(TLParameters.Position, false);
          //SetProcessWorkingSetSize(GetCurrentProcess,$FFFFFFFF,$FFFFFFFF);
          MediaPlay;
          mystartplay:=-1;
        end;
     end;
   end;
// Включаем или выключаем отображение времени запуска
   SetTypeTimeCode;

// Если запуск воспроизведения выполнен то отображаем движение тайм-линий.
   If MyTimer.Enable then begin

     CurrDt:=MyTimer.ReadTimer - PredDt;

     if not fileexists(Form1.lbPlayerFile.Caption) then begin
       TLParameters.Position:= MyDoubleToFrame(pStart +  MyTimer.ReadTimer * Rate);
       PredDt:=CurrDt;
        TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
       if mode=paused then exit;
     end else begin
       pMediaPosition.get_CurrentPosition(db1);
       pMediaPosition.get_Duration(db2);
       db3:=FramesToDouble(TLParameters.Finish - TLParameters.Preroll);
       if pStart1 > db2 then begin
         pMediaPosition.get_Rate(Rate);
         db0:=pStart1 + currDT * Rate;
       end else begin
         if db1 < db2 then begin
           db0:=db1;
           PredDT:=MyTimer.ReadTimer;
         end else begin
           pMediaPosition.get_Rate(Rate);
           db0 :=db2 + (MyTimer.ReadTimer - PredDt) * Rate;//SpeedMultiple;
         end;
       end;
       if db0>db3 then db0:=db3;
       TLParameters.Position:=TLParameters.Preroll + MyDoubleToFrame(db0);
      end;


     curpos:=TLParameters.Position - TLParameters.ZeroPoint;
     //Form1.lbCTLTimeCode.Caption:=MyDateTimeToStr(Now);
     //Form1.lbCTLTimeCode.Caption:=MyDateTimeToStr(now-TimeCodeDelta);
     if (not Form1.compartido^.State) and (MySinhro=chltc)
       then Form1.lbCTLTimeCode.Caption:='*' + MyDateTimeToStr(now-TimeCodeDelta)
       else Form1.lbCTLTimeCode.Caption:='' + MyDateTimeToStr(now-TimeCodeDelta);

     SetClipTimeParameters;
     application.ProcessMessages;

     MyPanelAir.SetValues;
     //MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, curpos);
     //===================
     //addVariable(1,'TimeCode',FramesToStr(curpos));
     application.ProcessMessages;
     //+++++++++++++++++++
     crpos := TLZone.TLEditor.CurrentEvents;
     if not Form1.PanelAir.Visible then begin
       if crpos.Number <> -1
         then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image)
         else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '');
       TemplateToScreen(crpos);
     end;
     if crpos.SafeZone
       then TLZone.DrawFlash(crpos.Number) else Form1.ImgLayer0.Canvas.FillRect(Form1.ImgLayer0.Canvas.ClipRect);

     TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);

     if Form1.PanelAir.Visible then begin
       //MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
       if MyDoubleToFrame(db0) mod 1 = 0 then begin
         MyPanelAir.AirEvents.Draw(Form1.ImgEvents.Canvas);
         MyPanelAir.AirDevices.Draw(Form1.ImgDevices.Canvas);
       end;
       MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, TLParameters.Position - TLParameters.ZeroPoint);
     end;
     application.ProcessMessages;

     if not fileexists(Form1.lbPlayerFile.Caption) then begin
       if TLParameters.Position >= TLparameters.Finish then begin
         TLParameters.Position := TLparameters.Finish;
         MediaPause;
         SetMediaButtons;
         MyStartReady:=false;
         exit;
       end;
     end else begin
       if (db0 >= db3) or (db0 < 0) then begin
         MediaPause;
         SetMediaButtons;
         MyStartReady:=false;
       end;
     end;
   end;
  except
  end;
end;

procedure StartMyTimer;
var dur : double;
begin
  PredDt:=0;
  MyTimer.StartTimer;
  PredDt:=MyTimer.ReadTimer;
  if fileexists(Form1.lbPlayerFile.Caption) then begin
    pMediaPosition.get_CurrentPosition(pStart);
    pMediaPosition.get_Duration(dur);
  end else begin
    pStart := FramesToDouble(TLParameters.Position);
    dur := FramesToDouble(TLParameters.Duration);
  end;
  pStart1:=0;
  if FramesToDouble(TLParameters.Position - TLParameters.Preroll) > dur
    then pStart1:=FramesToDouble(TLParameters.Position - TLParameters.Preroll);
end;

procedure StopMyTimer;
begin
  MyTimer.StopTimer;
end;

Function ReadMyTimer : Double;
begin
  result := MyTimer.ReadTimer;
end;

//==============================================================================

Procedure  TForm1.WMKeyDown(Var Msg:TWMKeyDown);
//выход из полноэкранного режима по кнопке ESC
begin
  if Msg.CharCode=VK_ESCAPE then
  begin
//      pVideoWindow.HideCursor(False); //показываем курсор
      //показываем плейлист, сплиттер, панель управления GroupBox
//      Form1.ListBox2.Visible:=True;
//      Form1.Splitter1.Visible:=True;
//      Form1.CheckBox1.Checked:=True;
//      Form1.GroupBox1.Visible:=True;
      //устанавливаем исходные параметры окна
//      Form1.BorderStyle:=bsSizeable;
//      Form1.windowState:= wsNormal;
//      Form1.FormStyle:=fsNormal;
      //задаем размеры окна вывода
      pVideoWindow.SetWindowPosition(0,0,pnMovie.ClientRect.Right,pnMovie.ClientRect.Bottom);
      FullScreen:=False;
end;
  inherited;
end;

procedure TForm1.WMHotKey(var Mess: TWMHotKey);
var hk, uns, res : integer;
    s : string;
begin
 hk := mess.HotKey;
 uns := mess.Unused;
 res := mess.Result;
 s := inttostr(res);
 inherited;
 //ShowMessage('Нажата горячая клавиша CTRL+F12');
end;

procedure TForm1.sbProjectClick(Sender: TObject);
begin
  SetMainGridPanel(projects);
end;

procedure TForm1.sbClipsClick(Sender: TObject);
begin
  SetMainGridPanel(clips);
end;

procedure TForm1.sbPlayListClick(Sender: TObject);
var i, ps, j : integer;
begin
  cbPlayLists.Clear;
  for i:=1 to GridLists.RowCount-1 do begin
    cbPlayLists.Items.Add((GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Name'));
    j := cbPlayLists.Items.Count-1;
    if not (cbPlayLists.Items.Objects[j] is TMyListBoxObject) then cbPlayLists.Items.Objects[j] := TMyListBoxObject.Create;
    (cbPlayLists.Items.Objects[j] as TMyListBoxObject).ClipId := (GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
  end;
  ps:=findgridselection(GridLists,2);
  if ps<>-1 then cbPlayLists.ItemIndex:=ps-1;

  if trim(lbActiveClipID.Caption) <> '' then SaveClipEditingToFile(trim(lbActiveClipID.Caption));
  if not SetMainGridPanel(actplaylist) then exit;
  //if secondarygrid<>playlists then exit;
  if ps<>-1 then begin

  //(GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark
  //  := Not (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark;
    SetPlaylistBlocking(ps);
    Image1.Repaint;
  end;
  GridActvePLToPanel(GridActPlayList.Row);
end;

procedure TForm1.lbModeClick(Sender: TObject);
begin
  CurrentMode:=not CurrentMode;
//  UpdatePanelPrepare;
//  UpdatePanelAir;
  if CurrentMode then begin
    lbMode.Caption:='Эфир';
    lbMode.Font.Color:=clRed;
  end else begin
    lbMode.Caption:='Подготовка';
    lbMode.Font.Color:=ProgrammFontColor;
    CurrentImageTemplate := '@#@4445';
  end;
  Label2Click(nil);
  Form1.Repaint;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i, ps : integer;
    ext, nm : string;
begin
  bmpEvents := TBitmap.Create;
  bmpAirDevices := TBitmap.Create;
//++++++++++++++++++++++++++++++++++++++++++
  { Посмотрим, существует ли файл }
  FicheroM:=OpenFileMapping(FILE_MAP_ALL_ACCESS, False,'MiFichero');
  { Если нет, то ошибка }
  if FicheroM = 0 then  FicheroM:=CreateFileMapping( $FFFFFFFF,nil,PAGE_READWRITE,0,SizeOf(TCompartido),'MiFichero');
  // если создается файл, заполним его нулями
  if FicheroM=0 then raise Exception.Create( 'Не удалось создать файл'+'/Ошибка при создании файла');
  Compartido:=MapViewOfFile(FicheroM,FILE_MAP_WRITE,0,0,0);
  compartido^.Manejador2:=Handle;
  compartido^.Cadena:='request';
//++++++++++++++++++++++++++++++++++++++++++

  CreateDirectories('');
  ReadMyIniFile;
  if MainWindowStayOnTop then begin
    Form1.FormStyle := fsStayOnTop;
    Form1.WindowState := wsNormal;
  end else begin
    Form1.FormStyle := fsNormal;
    Form1.WindowState := wsMaximized;
  end;
  ExecTaskOnDelete;
  InputInSystem;
//  RegisterHotKey(Handle, Ord('1'),0, Ord('1'));
//  RegisterHotKey(Handle, 2001 ,MOD_ALT,vk_F12);
  FWait := TFWaiting.Create(nil);
  InitMainForm;
  InitPanelControl;
  InitPanelClips;
  InitPanelPlayList;
  InitPanelProject;
  InitPanelPrepare;
  InitPanelAir;
  self.imgTimelines.Parent.DoubleBuffered:=true;
  self.imgLayer0.Parent.DoubleBuffered:=true;
  self.imgLayer1.Parent.DoubleBuffered:=true;
  self.imgLayer2.Parent.DoubleBuffered:=true;
  self.imgTLNames.Parent.DoubleBuffered:=true;
  form1.Repaint;
  CoInitialize(nil);// инициализировать OLE
  bmpTimeline := TBitmap.Create;
  bmpTimeline.PixelFormat := pf32bit;
  //bmpEvents := TBitmap.Create;
  //bmpAirDevices := TBitmap.Create;
  MyTimer:=THRTimer.Create;
  MyThread:=TMyThread.Create(False);
  MyThread.Priority:=tpTimeCritical;//tpHighest;
  LoadGridFromFile(AppPath + DirProjects + '\' + 'ListProjects.prjt', GridProjects);
  ps := findgridselection(GridProjects, 2);
  if ps<>-1
    then Label15.Caption:= 'Список плей-листов проекта (' + (GridProjects.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('Project') + ')'
    else Label15.Caption:= 'Список плей-листов проекта';
  SecondaryGrid:=playlists;
  loadoldproject;
  UpdateProjectPathes(ProjectNumber);
  MyStartPlay:= -1;
  MyStartReady := false;
//  if FileExists(pathlists + '\Timelines.lst')
//    then LoadGridTimelinesFromFile(pathlists + '\Timelines.lst', Form1.GridTimeLines)
end;

procedure TForm1.Label2Click(Sender: TObject);
var hght, tp : integer;
    strs : string;
    crpos : teventreplay;
begin
//Закрываем панели проектов, клипов, и плей-листа
  if trim(lbActiveClipID.Caption)='' then LoadDefaultClipToPlayer;
  PanelProject.Visible:=false;
  PanelClips.Visible:=false;
  PanelPlayList.Visible:=false;
  sbProject.Font.Style:=sbProject.Font.Style - [fsBold,fsUnderline];
  sbClips.Font.Style:=sbClips.Font.Style - [fsBold]; //,fsUnderline
  sbPlayList.Font.Style:=sbPlayList.Font.Style - [fsBold]; //,fsUnderline
//В зависимости от заданного режима открываем панели подготовки и эфира
  if CurrentMode then begin
    PanelPrepare.Visible:=true;//false;
    PanelAir.Visible:=true;
  end else begin
    PanelAir.Visible:=false;
    PanelPrepare.Visible:=true;
  end;
//Обнавляем панель подготовки
  UpdatePanelPrepare;
//Если панель подготовки видна, то проверяем нужно ли отображать графический шаблон и выводим его на экран.
  if PanelPrepare.Visible then begin
    crpos := TLZone.TLEditor.CurrentEvents;
    if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image);
    TemplateToScreen(crpos);
    if pnImageScreen.Visible then Image3.Repaint;
  end;
// Если клип не воспроизводится, то перерисовываем тайм-линии в памяти, иначе если режим эфира отриосвываем события.
  if mode<>play then TLZone.DrawBitmap(bmptimeline)
  else begin
    if Form1.PanelAir.Visible then begin
      MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas,TLZone.TLEditor.Index);
      MyPanelAir.SetValues;
      MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
    end;
    //TLZone.TLEditor.UpdateScreen(bmptimeline.Canvas);
  end;
//Выводим диапазон отображения тайм-линий на экран, перерисовываем курсор
  TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
  TLZone.DrawLayer2(imgLayer2.Canvas);
  //InvalidateRect(form1.imgLayer2.Canvas.Handle, NIL, FALSE ) ;
//Переопределяем высотв отбражения тайм-линий и перериовываем названия тайм-линий
  TLHeights.Height;
  ZoneNames.Draw(imgTLNames.Canvas,GridTimelines, true);
//Задаем принудительную перерисовку зон имен тайм-линий и тайм-линий.
  imgTLNames.Repaint;
  imgtimelines.Repaint;
end;

procedure TForm1.sbListPlayListsClick(Sender: TObject);
var i : integer;
begin
  
end;

procedure TForm1.sbListGraphTemplatesClick(Sender: TObject);
var i : integer;
begin
  
end;

procedure TForm1.sbListTextTemplatesClick(Sender: TObject);
var i : integer;
begin

end;

procedure TForm1.GridProjectsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  GridDrawMyCell(GridProjects, ACol, ARow, Rect);
end;

procedure TForm1.Panel5Resize(Sender: TObject);
var hght : integer;
begin
  hght:=imgButtonsProject.Height + Splitter1.Height+panel11.Height;
  If panel5.Height < hght then panel5.Height := hght;
  //SetGridProjects;
end;

procedure TForm1.GridProjectsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i, lft, rgt, cl, ps, cnt : integer;
begin
  i := GridColX(GridProjects,X);
  if GridClickRow(GridProjects, Y)=0 then exit;
  if GridProjects.Objects[0,GridProjects.Row] is TGridRows then begin
    if i=3 then begin
      if (RowDownGridProject<>GridProjects.Row) and (RowDownGridProject>0) and (GridProjects.Row>0) then begin
        TempGridRow.Clear;
        TempGridRow.Assign((GridProjects.Objects[0,RowDownGridProject] as TGridRows));
        if GridProjects.Row < RowDownGridProject then begin
          for cnt:=RowDownGridProject downto GridProjects.Row+1 do begin
            (GridProjects.Objects[0,cnt] as TGridRows).Assign((GridProjects.Objects[0,cnt-1] as TGridRows));
          end;
        end else begin
          for cnt:=RowDownGridProject to GridProjects.Row-1 do begin
            (GridProjects.Objects[0,cnt] as TGridRows).Assign((GridProjects.Objects[0,cnt+1] as TGridRows));
          end;
        end;
        (GridProjects.Objects[0,GridProjects.Row] as TGridRows).Assign(TempGridRow);
        GridProjects.Repaint;
        RowDownGridProject:=-1;
      end;
      if DblClickProject then begin
          if GridProjects.Row > 0 then begin
            if (GridProjects.Objects[0,GridProjects.Row] is TGridRows) then begin
              if (GridProjects.Objects[0,GridProjects.Row] as TGridRows).ID=0
                then CreateProject(-1)
                else CreateProject(GridProjects.Row);
           end;
         end;
       end;
      DblClickProject:=false;
      GridProjects.Repaint;
      exit;
    end;
    if (GridProjects.Objects[0,GridProjects.Row] as TGridRows).ID<=0 then exit;
      case i of
  0,1: (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[i].Mark:=not (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[i].Mark;
    2: begin
         ps := findgridselection(form1.gridprojects, 2);
         if ps<>-1 then if MyTextMessage('Вопрос', 'Сохранить текущий проект?',2) then begin
           saveoldproject;
           //lbPLName.Caption:='';
         end;
         for i:=1 to GridProjects.RowCount-1 do (GridProjects.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
         (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[2].Mark:=true;
         loadoldproject;
         ProjectToPanel(GridProjects.Row);

         ps := findgridselection(GridProjects, 2);
         if ps<>-1
           then Label15.Caption:= 'Список плей-листов проекта (' + (GridProjects.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('Project') + ')'
           else Label15.Caption:= 'Список плей-листов проекта';
       end;
      end; //case
  end;//if
  SetProjectBlocking(GridProjects.Row);
  GridProjects.Repaint;
end;

procedure TForm1.GridProjectsDblClick(Sender: TObject);
begin
  DblClickProject:=true;
end;

procedure TForm1.GridListsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  //GridDrawCell(GridLists, SecondaryGrid, ACol, ARow, Rect, State);
  GridDrawMyCell(GridLists, ACol, ARow, Rect);
end;

procedure TForm1.GridListsDblClick(Sender: TObject);
begin
  DblClickLists:=true;
end;

procedure TForm1.GridListsMouseUpPlaylists(X, Y: Integer);
var i, lft, rgt, cl, cnt, ps : integer;
    clpid : string;
begin
  i := GridColX(GridLists,X);
  if (GridLists.RowCount=2) and (GridLists.Row=1) and ((GridLists.Objects[0,1] as TGridRows).ID = -1) then exit;
  if GridLists.Objects[0,GridLists.Row] is TGridRows then begin
    if i=3 then begin
//=========================================
      if (RowDownGridLists<>GridLists.Row) and (RowDownGridLists>0) and (GridLists.Row>0) then begin
        TempGridRow.Clear;
        TempGridRow.Assign((GridLists.Objects[0,RowDownGridLists] as TGridRows));
        if GridLists.Row < RowDownGridLists then begin
          for cnt:=RowDownGridLists downto GridLists.Row+1 do begin
            (GridLists.Objects[0,cnt] as TGridRows).Assign((GridLists.Objects[0,cnt-1] as TGridRows));
          end;
        end else begin
          for cnt:=RowDownGridLists to GridLists.Row-1 do begin
            (GridLists.Objects[0,cnt] as TGridRows).Assign((GridLists.Objects[0,cnt+1] as TGridRows));
          end;
        end;
        (GridLists.Objects[0,GridLists.Row] as TGridRows).Assign(TempGridRow);
        GridLists.Repaint;
      end;
      RowDownGridLists:=-1;
//=========================================
      if DblClickLists then begin
          if GridLists.Row > 0 then begin
            if (GridLists.Objects[0,GridLists.Row] is TGridRows) then begin
              if (GridLists.Objects[0,GridLists.Row] as TGridRows).ID=0
                then EditPlayList(-1)
                else EditPlayList(GridLists.Row);
           end;
         end;
       end;
      DblClickLists:=false;
      GridLists.Repaint;
      exit;
    end;
    if (GridLists.Objects[0,GridLists.Row] as TGridRows).ID<=0 then exit;
      case i of
  0,1: (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[i].Mark:=not (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[i].Mark;
    2: begin
         for i:=1 to GridLists.RowCount-1 do (GridLists.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
         (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[2].Mark:=true;
         ps := cbPlayLists.ItemIndex;
         if (cbPlayLists.Items.Objects[ps] is TMyListBoxObject) then begin
           clpid := trim((cbPlayLists.Items.Objects[ps] as TMyListBoxObject).ClipID);
           if clpid<>'' then SaveGridToFile(clpid,GridActPlayList);
         end;
         cbPlayLists.Clear;
         for i:=1 to GridLists.RowCount-1 do begin
           cbPlayLists.Items.Add((GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Name'));
           ps := cbPlayLists.Items.Count-1;
           if not (cbPlayLists.Items.Objects[ps] is TMyListBoxObject) then cbPlayLists.Items.Objects[ps] := TMyListBoxObject.Create;
           (cbPlayLists.Items.Objects[ps] as TMyListBoxObject).ClipId := (GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
         end;
         ps:=GridLists.Row;//findgridselection(GridLists,2);
         //cbPlayLists.ItemIndex:=ps-1;
         //cbPlayListsChange(nil);
         if ps<>-1 then begin
           cbPlayLists.ItemIndex:=ps-1;
           cbPlayListsChange(nil);
         //  cbPlayLists.ItemIndex:=ps-1;
         //  //PlaylistToPanel(GridLists.Row);
         //  if FileExists(PathPlayLists + '\' + (cbPlayLists.Items.Objects[ps-1] as TMyListBoxObject).ClipId) then begin
         //    LoadGridFromFile(PathPlayLists + '\' + Form1.lbPLName.Caption, GridActPlayList);
         //    CheckedActivePlayList;
          // end;
         end else GridClear(GridActPlayList, RowGridClips);
         if DblClickLists then begin
           DblClickLists:=false;
           sbPlayListClick(nil);
         end;
       end;
      end; //case
  end;//if
  gridlists.Repaint;
end;

procedure TForm1.GridListsMouseUpTextTemplates(X, Y: Integer);
var i, lft, rgt, cl, cnt : integer;
begin
  i := GridColX(GridLists,X);
  if GridLists.Objects[0,GridLists.Row] is TGridRows then begin
    if i=1 then begin
      //=========================================
      if (RowDownGridLists<>GridLists.Row) and (RowDownGridLists>0) and (GridLists.Row>0) then begin
        TempGridRow.Clear;
        TempGridRow.Assign((GridLists.Objects[0,RowDownGridLists] as TGridRows));
        if GridLists.Row < RowDownGridLists then begin
          for cnt:=RowDownGridLists downto GridLists.Row+1 do begin
            (GridLists.Objects[0,cnt] as TGridRows).Assign((GridLists.Objects[0,cnt-1] as TGridRows));
          end;
        end else begin
          for cnt:=RowDownGridLists to GridLists.Row-1 do begin
            (GridLists.Objects[0,cnt] as TGridRows).Assign((GridLists.Objects[0,cnt+1] as TGridRows));
          end;
        end;
        (GridLists.Objects[0,GridLists.Row] as TGridRows).Assign(TempGridRow);
        GridLists.Repaint;
      end;
      RowDownGridLists:=-1;
      //=========================================
      if DblClickLists then begin
          if GridLists.Row > 0 then begin
            if (GridLists.Objects[0,GridLists.Row] is TGridRows) then begin
              if (GridLists.Objects[0,GridLists.Row] as TGridRows).ID=0
                then TextTemplate(-1, false,'')
                else TextTemplate(GridLists.Row, false,'');
           end;
         end;
       end;
      DblClickLists:=false;
      GridLists.Repaint;
      exit;
    end;
    if (GridLists.Objects[0,GridLists.Row] as TGridRows).ID<=0 then exit;
      case i of
    0: (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[i].Mark:=not (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[i].Mark;
    //1: begin
    //     for i:=1 to GridLists.RowCount-1 do (GridLists.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
    //     (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[2].Mark:=true;
    //     PlaylistToPanel(GridLists.Row);
    //   end;
      end; //case
  end;//if
  gridlists.Repaint;
end;

procedure TForm1.GridListsMouseUpGRTemplates(X, Y: Integer);
var i, lft, rgt, cl, cnt : integer;
begin
  i := GridColX(GridLists,X);
  if GridLists.Objects[0,GridLists.Row] is TGridRows then begin
    if i=2 then begin
      //=========================================
      if (RowDownGridLists<>GridLists.Row) and (RowDownGridLists>0) and (GridLists.Row>0) then begin
        TempGridRow.Clear;
        TempGridRow.Assign((GridLists.Objects[0,RowDownGridLists] as TGridRows));
        if GridLists.Row < RowDownGridLists then begin
          for cnt:=RowDownGridLists downto GridLists.Row+1 do begin
            (GridLists.Objects[0,cnt] as TGridRows).Assign((GridLists.Objects[0,cnt-1] as TGridRows));
          end;
        end else begin
          for cnt:=RowDownGridLists to GridLists.Row-1 do begin
            (GridLists.Objects[0,cnt] as TGridRows).Assign((GridLists.Objects[0,cnt+1] as TGridRows));
          end;
        end;
        (GridLists.Objects[0,GridLists.Row] as TGridRows).Assign(TempGridRow);
        GridLists.Repaint;
      end;
      RowDownGridLists:=-1;
      //=========================================
      if DblClickLists then begin
          if GridLists.Row > 0 then begin
            if (GridLists.Objects[0,GridLists.Row] is TGridRows) then begin
              if (GridLists.Objects[0,GridLists.Row] as TGridRows).ID=0
                then EditImageTamplate//(-1)
                else EditImageTamplate;//(GridLists.Row);
           end;
         end;
       end;
      DblClickLists:=false;
      GridLists.Repaint;
      exit;
    end;
    if (GridLists.Objects[0,GridLists.Row] as TGridRows).ID<=0 then exit;
      case i of
    0: (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[i].Mark:=not (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[i].Mark;
    //1: begin
    //     for i:=1 to GridLists.RowCount-1 do (GridLists.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
    //     (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[2].Mark:=true;
    //     PlaylistToPanel(GridLists.Row);
    //   end;
      end; //case
  end;//if
  gridlists.Repaint;
end;

procedure TForm1.GridListsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  GridListsMouseUpPlaylists(X, Y);
  SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
end;

procedure TForm1.imgButtonsProjectMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i : integer;
begin
  if Button<>mbLeft then exit;
  i:=pnlprojects.ClickButton(imgButtonsProject.Canvas,x,y);
  ButtonsControlProjects(i);
end;

procedure TForm1.GridProjectsTopLeftChanged(Sender: TObject);
begin
  GridProjects.LeftCol:=0;
end;

procedure TForm1.GridTimeLinesDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  GridDrawCellTimeline(GridTimeLines, ACol, ARow, Rect, State);
end;

procedure TForm1.GridTimeLinesTopLeftChanged(Sender: TObject);
var clrw : integer;
begin
  clrw := GridTimelines.Height div Gridtimelines.DefaultRowHeight;
  if (Gridtimelines.DefaultRowHeight * Gridtimelines.RowCount) < GridTimelines.Height
    then Gridtimelines.TopRow:=1;

end;

procedure TForm1.imgButtonsControlProj1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var s:string;
    i, res, ps, cnt : integer;
    nm : string;
    id : longint;
    cntmrk, cntdel : integer;
begin
  if Button<>mbLeft then exit;
  res := pnlprojcntl.ClickButton(imgButtonsControlProj.canvas,x,y);
  ButtonControlLists(res);
end;

procedure TForm1.GridTimeLinesDblClick(Sender: TObject);
begin
  EditTimeline(GridTimeLines.Selection.Top);
  GridTimeLines.Repaint;
end;

procedure TForm1.pnMovieResize(Sender: TObject);
begin
  if not fileexists(Form1.lbPlayerFile.Caption) then exit;
  pnMovie.Width:=(pnMovie.Height div 9) * 16;
  if mode=play then begin
    pVideoWindow.SetWindowPosition(0,0,pnMovie.ClientRect.Right,pnMovie.ClientRect.Bottom);
  end;
end;

procedure TForm1.imgButtonsControlProj1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var pos:integer;
begin
  pnlprojcntl.MouseMove(imgButtonsControlProj.Canvas,x,y);

end;

procedure TForm1.imgButtonsProjectMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var pos : integer;
begin
  pnlprojects.MouseMove(imgButtonsProject.Canvas,x,y);

end;

procedure TForm1.imgCTLPrepare1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, j, res, ps : integer;
    crpos : teventreplay;
    tmpos : longint;
    bl : boolean;
begin
  res := btnspanel1.ClickButton(imgCTLPrepare1.Canvas,X,Y);
  ControlButtonsPrepare(res);
end;

procedure TForm1.imgCTLPrepare1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  btnspanel1.MouseMove(imgCTLPrepare1.Canvas, X, Y);
end;

procedure TForm1.imgTLNamesMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res : TTLNResult;
    s: string;
begin
   imgTLNames.Canvas.Lock;
   SaveToUNDO;
   res := ZoneNames.ClickTTLNames(imgTLNames.Canvas, Form1.GridTimeLines, X, Y);
   ZoneNames.Draw(imgTLNames.Canvas,Form1.GridTimeLines,false);
   imgTLNames.Canvas.Unlock
end;

procedure TForm1.imgpnlbtnsplMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  pnlbtnspl.MouseMove(imgpnlbtnspl.Canvas,X,Y);
end;

procedure TForm1.imgpnlbtnsplMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i, res : integer;
begin
  res := pnlbtnspl.ClickButton(imgpnlbtnspl.Canvas,x,y);
  ButtonsControlPlayList(res);
end;

procedure TForm1.imgpnlbtnsclipsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlbtnsclips.MouseMove(imgpnlbtnsclips.canvas,x,y);
end;

procedure TForm1.imgpnlbtnsclipsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, res : integer;
    nm : string;
    ps, cntmrk, cntdel : integer;
begin
  res:=pnlbtnsclips.ClickButton(imgpnlbtnsclips.canvas,x,y);
  ButtonsControlClipsPanel(res);
end;

procedure TForm1.imgDeviceTLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnsdevicepr.MouseMove(imgDeviceTL.Canvas,X,Y);
end;

procedure TForm1.imgDeviceTLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res, ps : integer;
    crpos : teventreplay;
begin
  if Button<>mbLeft then exit;
  //if trim(Label2.Caption)='' then exit;
  ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
  if TLZone.Timelines[ps].Block then begin
    frLock.ShowModal;
    exit;
  end;
  SaveToUNDO;
  res := btnsdevicepr.ClickButton(imgDeviceTL.Canvas,X,Y);
  if res=-1 then exit;
  InsertEventToEditTimeline(res);
  crpos := TLZone.TLEditor.CurrentEvents;
  if crpos.Number <> -1
    then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image)
    else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '');
  TemplateToScreen(crpos);
end;

procedure TForm1.imgTLNamesMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MouseInLayer2 := false;
  ZoneNames.MoveMouse(imgTLNames.Canvas,Form1.GridTimeLines, X, Y);
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
var rs, res : integer;
    s: string;
begin
  if Msg.Message=WM_KEYUP  then begin
    rs:=Msg.lParam;
    res:=Msg.wParam;
    s:=inttostr(res);
  end;
  if Msg.Message=WM_MOUSEWHEEL then begin
    if Msg.lParam<0 then begin
       s:=inttostr(res);
    end else begin
      if mode=play then exit;
      if MouseInLayer2 then begin
        if Msg.wParam >0 then ControlPlayerFastSlow(3) else ControlPlayerFastSlow(0);
        TLZone.TLEditor.EventsSelectFalse;
        TLZone.TLEditor.AllSelectFalse;
        TLZone.DrawTimelines(imgtimelines.Canvas, bmptimeline);
        //application.ProcessMessages;
        imgtimelines.Repaint;
      end;
    end
 end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//  UnregisterHotKey(Handle, Ord('1'));
//  UnregisterHotKey(Handle, 2001);
  CoUninitialize;// деинициализировать OLE
  bmpTimeline.Free;
  bmpEvents.Free;
  bmpAirDevices.Free;
  GridTimelines.FreeOnRelease;
  UnmapViewOfFile(Compartido);
  CloseHandle(FicheroM);
end;

procedure TForm1.imgMediaTLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnsmediatl.MouseMove(imgMediaTL.Canvas, X, Y);
end;

procedure TForm1.imgMediaTLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var ps, res : integer;
    crpos : teventreplay;
begin
  res := btnsmediatl.ClickButton(imgMediaTL.Canvas, X, Y);
  ButtonsControlMedia(res);
end;


procedure TForm1.GridListsTopLeftChanged(Sender: TObject);
begin
  GridLists.LeftCol:=0;
end;

procedure TForm1.imgCTLBottomLMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  btnsctlleft.MouseMove(imgCTLBottomL.Canvas, X, Y);
end;

procedure SetMediaButtons;
var i : integer;
begin
  if (mode=play) then begin
    for i:=0 to 3 do btnsctlleft.Rows[0].Btns[i].Visible:=false;
    btnsctlleft.Rows[0].Btns[5].LoadBMPFromRes(impause);
  end else begin
    for i:=0 to 3 do btnsctlleft.Rows[0].Btns[i].Visible:=true;
    btnsctlleft.Rows[0].Btns[5].LoadBMPFromRes(imforward);
  end;
  btnsctlleft.Draw(Form1.imgCTLBottomL.Canvas);
end;

procedure TForm1.imgCTLBottomLMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, res :integer;
    crpos : teventreplay;
    posi : longint;
begin

  res := btnsctlleft.ClickButton(imgCTLBottomL.Canvas, X, Y);
     case res of
  0..3 :ControlPlayerTransmition(res);
  5 : begin
        if mode<>play then begin
          //if Not FileExists(lbPlayerFile.Caption) then begin
          //  MyTextMessage('Сообщение','Не найден ассоциируемый с клипом файл:' +#10#13
          //  + lbPlayerFile.Caption + #10#13 + 'возможно файл был удален с диска.',1);
          //  EraseClipInWinPrepare(lbActiveClipID.Caption);
          //  mode:=paused;
          //  MediaPause;
          //  exit;
          //end;
          TLZone.TLEditor.AllSelectFalse;
          TLZone.TLEditor.EventsSelectFalse;
          TLZone.TLEDitor.UpdateScreen(bmptimeline.Canvas);
          //TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
        end;
        //if trim(Form1.lbPlayerFile.Caption)='' then exit;
        if panelprepare.visible then ActiveControl:=panelprepare;
        ControlPlayer;
      end;
     end; //case
end;

procedure TForm1.imgCtlBottomRMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var res :integer;
    crpos : teventreplay;
begin
  res := btnsctlright.ClickButton(imgCTLBottomR.Canvas, X, Y);
  ControlPlayerFastSlow(res);
end;

procedure TForm1.imgCtlBottomRMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  btnsctlright.MouseMove(imgCTLBottomR.Canvas, X, Y);
end;

procedure TForm1.GridClipsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  GridDrawMyCell(GridClips, ACol, ARow, Rect);
end;

procedure TForm1.GridClipsDblClick(Sender: TObject);
begin
   DblClickClips:=true;
end;

procedure TForm1.GridClipsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GridClipsToPanel(ARow);
end;

procedure TForm1.GridClipsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i, lft, rgt, cl, cnt, rw : integer;
    txt, clpid : string;
    ps : tpoint;
begin
  i := GridColX(GridClips,X);
  rw := GridClickRow(GridClips, Y);
  if rw=0 then exit;
  if Button=mbRight then begin
    if (rw <> -1) and (rw <> 0) then begin
      GridClips.Row := GridClips.TopRow + rw-1;
      frSetTC.Top:=(Form1.Height-Form1.ClientHeight - 2*Form1.BevelWidth) + Form1.PanelControl.Height + GridClips.RowHeights[0] + (GridClips.Row-1)*GridClips.RowHeights[GridClips.Row] -5;
      if (frSetTC.Top + frSetTC.Height > Form1.Height) then frSetTC.Top:= Form1.Height - frSetTC.Height;
      frSetTC.Left := GridClips.Left + X;
      if (frSetTC.Left + frSetTC.Width +10> Form1.Width) then frSetTC.Left := Form1.Width - frSetTC.Width - 10;
      //GridClips.Left + GridClips.Width div 2;
      txt := (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('TypeMedia');
      clpid := (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID');
      txt := trim(SetTimeCode(txt));
      (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].updatephrase('TypeMedia',txt);
      if (trim(lbActiveClipID.Caption)=trim(clpid)) and (txt<>'') then begin
        MyStartPlay:=StrTimeCodeToFrames(txt);
        MyStartReady:=true;
      end;
      ps := (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].PositionName('TypeMedia');
      (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].Rows[ps.x].Phrases[ps.y].SubFontColor:=clLime;
      (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].updatephrase('TypeTTL','Время старта:');
    end;
    Form1.GridClips.Repaint;
    exit;
  end;
  if GridClips.Objects[0,GridClips.Row] is TGridRows then begin
    if i=3 then begin
//=========================================
      if (RowDownGridClips<>GridClips.Row) and (RowDownGridClips>0) and (GridClips.Row>0) then begin
        TempGridRow.Clear;
        TempGridRow.Assign((GridClips.Objects[0,RowDownGridClips] as TGridRows));
        if GridClips.Row < RowDownGridClips then begin
          for cnt:=RowDownGridClips downto GridClips.Row+1 do begin
            (GridClips.Objects[0,cnt] as TGridRows).Assign((GridClips.Objects[0,cnt-1] as TGridRows));
            UpdateClipDataInWinPrepare(GridClips, cnt, (GridClips.Objects[0,cnt] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
          end;
        end else begin
          for cnt:=RowDownGridClips to GridClips.Row-1 do begin
            (GridClips.Objects[0,cnt] as TGridRows).Assign((GridClips.Objects[0,cnt+1] as TGridRows));
            UpdateClipDataInWinPrepare(GridClips, cnt, (GridClips.Objects[0,cnt] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
          end;
        end;
        (GridClips.Objects[0,GridClips.Row] as TGridRows).Assign(TempGridRow);
        UpdateClipDataInWinPrepare(GridClips, GridClips.Row,
                                   (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
        GridClips.Repaint;
      end;
      RowDownGridClips:=-1;
      //GridClipsToPanel(GridClips.Row);
//=========================================
      if DblClickClips then begin
          if GridClips.Row > 0 then begin
            if (GridClips.Objects[0,GridClips.Row] is TGridRows) then begin
                if (GridClips.Objects[0,GridClips.Row] as TGridRows).ID=0
                  then EditClip(-1)
                  else begin
                    EditClip(GridClips.Row);
                    UpdateClipDataInWinPrepare(GridClips, GridClips.Row, (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
                  end;
              SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
           end;
         end;
       end;
      DblClickClips:=false;
      CheckedActivePlayList;
      GridClipsToPanel(GridClips.Row);
      exit;
    end;
    if (GridClips.Objects[0,GridClips.Row] as TGridRows).ID<=0 then exit;
      case i of
  0,1: (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[i].Mark:=not (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[i].Mark;
    2: if (GridClips.Objects[0,GridClips.Row] is TGridRows) then PlayClipFromClipsList;
         //if (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhraseColor('Clip')=PhraseErrorColor
         //       then begin
                 // txt := (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('File');
                 // if not MyTextMessage('Вопрос','Не найден соответсвующий клипу файл' + #10#13 + '''' +
                 //                       txt + '''' + #10#13 + 'ассоциировать клип с файлом на диске?',2) then exit;
                 // ReloadClipInList(GridClips, GridClips.Row)
         //        PlayClipFromClipsList;
         //       end else PlayClipFromClipsList;
      end; //case
    PredClipID := (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    CheckedActivePlayList;
    GridClipsToPanel(GridClips.Row);
  end;//if
end;

procedure TForm1.GridActPlayListDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  GridDrawMyCell(GridActPlayList, ACol, ARow, Rect);
end;

//end;

procedure TForm1.sbPredClipClick(Sender: TObject);
begin
  if trim(Form1.lbActiveClipID.Caption)='' then exit;
  //SetProcessWorkingSetSize(GetCurrentProcess,$FFFFFFFF,$FFFFFFFF);
  LoadPredClipToPlayer;
end;

procedure TForm1.sbNextClipClick(Sender: TObject);
begin
  if trim(Form1.lbActiveClipID.Caption)='' then exit;
  //SetProcessWorkingSetSize(GetCurrentProcess,$FFFFFFFF,$FFFFFFFF);
  LoadNextClipToPlayer;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var hh, mm, ss, ms : word;
    dt, tm : double;
    step : real;
begin
  MyShift := compartido^.Shift;
  TCExists := compartido^.State;
  if not PanelPrepare.Visible then begin
    LBTimeCode1.Visible:=true;
    if (not compartido^.State) and (MySinhro=chltc)
      then LBTimeCode1.Caption:='*' + MyDateTimeToStr(now-TimeCodeDelta)
      else LBTimeCode1.Caption:='' + MyDateTimeToStr(now-TimeCodeDelta);
  end else LBTimeCode1.Visible:=false;
  if mode<>play then begin
    if (not compartido^.State) and (MySinhro=chltc)
      then lbCTLTimeCode.Caption:='*' + MyDateTimeToStr(now-TimeCodeDelta)
      else lbCTLTimeCode.Caption:='' + MyDateTimeToStr(now-TimeCodeDelta);
    //lbCTLTimeCode.Caption:=MyDateTimeToStr(now-TimeCodeDelta);
  end;
end;

procedure TForm1.imgLayer2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var crpos : teventreplay;
    rightlimit : longint;
    step : real;
begin
  try
  try
  if TLParameters.Position<TLParameters.Preroll then begin
    TLParameters.Position:=TLParameters.Preroll;
    //TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
    exit;
  end;
  rightlimit := TLParameters.Preroll + TLParameters.Duration + TLParameters.Postroll
                - (TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame)
                + TLParameters.MyCursor div TLParameters.FrameSize;
  if TLParameters.Position > rightlimit then begin
    TLParameters.Position:=rightlimit;
    //TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
    exit;
  end;
  if (TLZone.DownTimeline) and (mode<>play) then begin
      if not PanelAir.Visible then begin
      crpos := TLZone.TLEditor.CurrentEvents;
      if crpos.Number <> -1
        then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image)
        else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '');
      TemplateToScreen(crpos);
      Image3.Repaint;
    end;
  end;

  if (TLZone.DownViewer) and (mode<>play) then begin
      step := trunc((TLParameters.Finish -TLParameters.Start)/form1.imgtimelines.Width);
      TLParameters.Position:=TLParameters.Position + trunc((X - TLZone.XViewer)*step);
      TLZone.DrawTimelines(form1.imgtimelines.Canvas,bmptimeline);
      TLZone.XViewer:=X;
      SetClipTimeParameters;
      crpos := TLZone.TLEditor.CurrentEvents;
      if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image);
      TemplateToScreen(crpos);
      if Form1.pnImageScreen.Visible then Form1.Image3.Repaint;
      MediaSetPosition(TLParameters.Position, false);
      TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
      MediaPause;
      SetClipTimeParameters;
      MyPanelAir.SetValues;
      if Form1.PanelAir.Visible then begin
        MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
        Form1.ImgDevices.Repaint;
        Form1.ImgEvents.Repaint;
      end;
      Form1.imgtimelines.Repaint;
      exit;
  end;

  SetClipTimeParameters;

  TLZone.MoveMouseTimeline(imgLayer2.Canvas, Shift, X, Y);

  finally
  end;
  except
  end;
end;

procedure TForm1.imgLayer2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  TLZone.DownZoneTimeLines(imgLayer2.Canvas, Button, Shift, X, Y);
end;

procedure TForm1.imgLayer2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if panelprepare.Visible then ActiveControl:=panelprepare;
  TLZone.UPZoneTimeline(imgLayer2.Canvas, Button, Shift, X, Y);
end;

procedure TForm1.GridClipsTopLeftChanged(Sender: TObject);
begin
  GridClips.LeftCol:=0;
end;

procedure TForm1.imgBlockProjectsClick(Sender: TObject);
var ps : integer;
begin
  ps:=findgridselection(GridProjects,2);
  if ps<>-1 then begin
    (GridProjects.Objects[0,ps] as TGridRows).MyCells[0].Mark
      := Not (GridProjects.Objects[0,ps] as TGridRows).MyCells[0].Mark;
    SetProjectBlocking(ps);
    GridProjects.Repaint;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
var ps : integer;
begin
//  if secondarygrid<>playlists then exit;
//  ps:=findgridselection(GridLists,2);
//  if ps<>-1 then begin
//    (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark
//      := Not (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark;
//    SetPlaylistBlocking(ps);
//    GridLists.Repaint;
//  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i, oldcount : integer;
    clpid : string;
begin
  //if mode=play then
  MediaStop;
  if trim(lbActiveClipID.Caption)<>'' then SaveClipEditingToFile(trim(lbActiveClipID.Caption))
  else begin
//+++++++++++++++++++++++++++++++++++++
    if PanelPrepare.Visible then begin
      for i:=0 to TLZone.Count-1 do begin
        if TLZone.Timelines[i].Count > 0 then begin
          if MyTextMessage('Вопрос','Сохранить редактируемые данные в списке клипов?',2) then begin
            FImportFiles.edTotalDur.Text:=trim(FramesToStr(DefaultClipDuration));
            FImportFiles.edNTK.Text:=trim(FramesToStr(TLParameters.Start-TLParameters.Preroll));
            FImportFiles.EdDur.Text:=trim(FramesToStr(TLParameters.Finish-TLParameters.Start));
            FImportFiles.ExternalValue := true;
            oldcount := Form1.GridClips.RowCount;
            EditClip(-100);
            if oldcount<Form1.GridClips.RowCount then begin
              clpid := (form1.GridClips.Objects[0,Form1.GridClips.RowCount-1] as TGridRows).MyCells[3].ReadPhrase('ClipID');
              SaveClipEditingToFile(trim(clpid));
            end;
          end;
          break;
        end;
      end;
    end;
//+++++++++++++++++++++++++++++++++++++

  end;
  SaveGridToFile(AppPath + DirProjects + '\' + 'ListProjects.prjt', GridProjects);
  saveoldproject;
  DeleteFilesMask(PathTemp, '*.*');
  ClearUNDO;
  WriteMyIniFile;
  //application.Terminate;
end;

procedure TForm1.GridActPlayListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, lft, rgt, cl, cnt, rw : integer;
    txt, clpid : string;
    ps : tpoint;
begin
  i := GridColX(GridActPlayList,X);

  rw := GridClickRow(GridActPlayList, Y);
  if rw=0 then exit;

//++++++++++++++++++++++++++++++
  if Button=mbRight then begin
    if (rw <> -1) and (rw <> 0) then begin
      GridActPlayList.Row := GridActPlayList.TopRow + rw-1;
      frSetTC.Top:=(Form1.Height-Form1.ClientHeight - 2*Form1.BevelWidth) + Form1.PanelControl.Height + GridActPlayList.RowHeights[0]
                    + (GridActPlayList.Row-1)*GridActPlayList.RowHeights[GridActPlayList.Row] -5;
      if (frSetTC.Top + frSetTC.Height > Form1.Height) then frSetTC.Top:= Form1.Height - frSetTC.Height;
      frSetTC.Left := GridActPlayList.Left + X;
      if (frSetTC.Left + frSetTC.Width +10> Form1.Width) then frSetTC.Left := Form1.Width - frSetTC.Width - 10;
      txt := (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhrase('TypeMedia');
      clpid := (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID');
      txt := trim(SetTimeCode(txt));
      (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].updatephrase('TypeMedia',txt);
      if (trim(lbActiveClipID.Caption)=trim(clpid)) and (txt<>'') then begin
        MyStartPlay:=StrTimeCodeToFrames(txt);
        MyStartReady:=true;
      end;  
      (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].updatephrase('TypeMedia',txt);
      ps := (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].PositionName('TypeMedia');
      (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].Rows[ps.x].Phrases[ps.y].SubFontColor:=clLime;
      (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].updatephrase('TypeTTL','Время старта:');
      For i:=1 to GridClips.RowCount-1 do begin
        if Trim((GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID'))=trim(clpid) then begin
          (GridClips.Objects[0,i] as TGridRows).MyCells[3].updatephrase('TypeMedia',txt);
          break;
        end;
      end;
    end;
    Form1.GridActPlayList.Repaint;
    exit;
  end;
//++++++++++++++++++++++++++++++


  if GridActPlayList.Objects[0,GridActPlayList.Row] is TGridRows then begin
    if (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).ID<=0 then exit;
      case i of
    1: (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[i].Mark:=not (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[i].Mark;
    2: if (GridActPlayList.Objects[0,GridActPlayList.Row] is TGridRows) then begin
         //if (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhraseColor('Clip')=PhraseErrorColor then begin
         //  txt := (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhrase('File');
         //  if MyTextMessage('Вопрос','Не найден соответсвующий клипу файл' + #10#13 + '''' +
         //                    txt + '''' + #10#13 + 'перейти в список клипов, чтобы' + #10#13 +
         //                    'ассоциировать клип с файлом на диске?',2)
         //     then SetMainGridPanel(clips) else exit;
         //end else
         PlayClipFromActPlaylist;
       end;
    3: begin
         if (RowDownGridActPlayList<>GridActPlayList.Row) and (RowDownGridActPlayList>0) and (GridActPlayList.Row>0) then begin
           TempGridRow.Clear;
           TempGridRow.Assign((GridActPlayList.Objects[0,RowDownGridActPlayList] as TGridRows));
           if GridActPlayList.Row < RowDownGridActPlayList then begin
             for cnt:=RowDownGridActPlayList downto GridActPlayList.Row+1 do begin
               (GridActPlayList.Objects[0,cnt] as TGridRows).Assign((GridActPlayList.Objects[0,cnt-1] as TGridRows));
               UpdateClipDataInWinPrepare(GridActPlayList, cnt, (GridActPlayList.Objects[0,cnt] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
             end;
           end else begin
             for cnt:=RowDownGridActPlayList to GridActPlayList.Row-1 do begin
               (GridActPlayList.Objects[0,cnt] as TGridRows).Assign((GridActPlayList.Objects[0,cnt+1] as TGridRows));
               UpdateClipDataInWinPrepare(GridActPlayList, cnt, (GridActPlayList.Objects[0,cnt] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
             end;
           end;
           (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).Assign(TempGridRow);
           UpdateClipDataInWinPrepare(GridActPlayList, GridActPlayList.Row,
                                   (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
           GridActPlayList.Repaint;
         end;
         if GridActPlayList.Row > 0 then GridActvePLToPanel(GridActPlayList.Row);
         RowDownGridActPlayList:=-1;
       end;
      end;
  end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var  i, ps, ARow, cnt, cnt1 : integer;
     crpos : teventreplay;
     strp, endp : longint;
     txt, txt1, txt2 : string;
begin
  IF InputPanel.Visible then begin
    if Key=VK_RETURN then SpeedButton1Click(nil);
    exit;
  end;
//Клавиши переключения доступные во всех окнах
  If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 81) then begin
    if Form1.ActiveControl = RichEdit1 then exit;
    SetMainGridPanel(projects);  //Shift + Q
    exit;
  end;
  If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 87) then begin
    if Form1.ActiveControl = RichEdit1 then exit;
    SetMainGridPanel(clips); //Shift + W
    exit;
  end;
  If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 69) then begin
    if Form1.ActiveControl = RichEdit1 then exit;
    sbPlayListClick(nil);
  end;
  If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 84) then begin
    if Form1.ActiveControl = RichEdit1 then exit;
    CurrentMode:=true;       //Shift + T
    lbMode.Caption:='Эфир';
    lbMode.Font.Color:=clRed;
    Label2Click(nil);
    Form1.Repaint;
    exit;
  end;
  If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 82) then begin
    if Form1.ActiveControl = RichEdit1 then exit;
    CurrentMode:=false;      //Shift + R
    lbMode.Caption:='Подготовка';
    lbMode.Font.Color:=ProgrammFontColor;
    CurrentImageTemplate := '@#@4433';
    Label2Click(nil);
    Form1.Repaint;
    exit;
  end;
(*  If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 81) then begin
    SetMainGridPanel(projects);
    exit;
  end; *)

//Клавиши доступные во окне подготовки
  if PanelPrepare.Visible then begin
    if ActiveControl=RichEdit1 then exit;
    If Key=32 then begin
      try
        //if Rate<>1 then Rate:=1;
        ControlPlayer;
      except
        MyTextMessage('','В плейер не загружен клип для воспроизведения.',1);
      end;
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 187) then begin
       TLHeights.StepPlus;
       //TLHeights.StepMinus;
      TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
      TLZone.DrawBitmap(bmptimeline);
      Form1.imgTimelines.Canvas.Lock;
      Form1.imgTimelines.Canvas.FillRect(Form1.imgTimelines.Canvas.ClipRect);
      TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
      InvalidateRect( Form1.imgTimelines.Canvas.Handle, NIL, FALSE ) ;
      Form1.imgTimelines.Canvas.UnLock;
      TLZone.DrawLayer2(Form1.imgLayer2.Canvas);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 189) then begin
      //TLHeights.StepPlus;
      TLHeights.StepMinus;
      TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
      TLZone.DrawBitmap(bmptimeline);
      Form1.imgTimelines.Canvas.Lock;
      Form1.imgTimelines.Canvas.FillRect(Form1.imgTimelines.Canvas.ClipRect);
      TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
      InvalidateRect( Form1.imgTimelines.Canvas.Handle, NIL, FALSE ) ;
      Form1.imgTimelines.Canvas.UnLock;
      TLZone.DrawLayer2(Form1.imgLayer2.Canvas);
      exit;
    end;

    If (ssCtrl In Shift) and (not (ssAlt In Shift)) and (not (ssShift In Shift)) and (Key = 79) then begin
      // CTRL + O установить ноль на ТЛ.
      ButtonsControlMedia(1);
      exit;
    end;

    If (ssAlt In Shift) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 77) then begin
      if mode<>play then SetLTC;
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 90) then begin
      ControlButtonsPrepare(9); //Ctrl + Z
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = VK_LEFT) then begin
      if mode<>play then ControlPlayerFastSlow(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = VK_LEFT) then begin
      ControlPlayerTransmition(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = VK_LEFT) then begin
      if mode<>play then ControlPlayerFastSlow(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 188) then begin
      if mode=play then ControlPlayerFastSlow(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 188) then begin
      if mode=play then ControlPlayerFastSlow(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = VK_RIGHT) then begin
      if mode<>play then ControlPlayerFastSlow(2);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = VK_RIGHT) then begin
      ControlPlayerTransmition(2);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = VK_RIGHT) then begin
      if mode<>play then ControlPlayerFastSlow(3);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 190) then begin
      if mode=play then ControlPlayerFastSlow(2);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 190) then begin
      if mode=play then ControlPlayerFastSlow(3);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = VK_HOME) then begin
      ControlPlayerTransmition(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = VK_END) then begin
      ControlPlayerTransmition(3);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = VK_HOME) then begin
      SaveToUNDO;
      TLParameters.Position:=TLParameters.Preroll; //TLParameters.ZeroPoint;
      crpos := TLZone.TLEditor.CurrentEvents;
      if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image);
      TemplateToScreen(crpos);
      if pnImageScreen.Visible then Image3.Repaint;
      MediaSetPosition(TLParameters.Position, false);
      TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
      MediaPause;
      SetClipTimeParameters;
      MyPanelAir.SetValues;
      if Form1.PanelAir.Visible then begin
        MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
        Form1.ImgDevices.Repaint;
        Form1.ImgEvents.Repaint;
      end;
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = VK_END) then begin
      SaveToUNDO;
      TLParameters.Position:=TLParameters.Preroll + TLParameters.Duration;
      crpos := TLZone.TLEditor.CurrentEvents;
      if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image);
      TemplateToScreen(crpos);
      if pnImageScreen.Visible then Image3.Repaint;
      MediaSetPosition(TLParameters.Position, false);
      TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
      MediaPause;
      SetClipTimeParameters;
      MyPanelAir.SetValues;
      if Form1.PanelAir.Visible then begin
        MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
        Form1.ImgDevices.Repaint;
        Form1.ImgEvents.Repaint;
      end;
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 88) then begin
      ControlButtonsPrepare(5);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 67) then begin
      ControlButtonsPrepare(6);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 67) then begin
      ControlButtonsPrepare(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 86) then begin
      ControlButtonsPrepare(7);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = VK_DELETE) then begin
      ControlButtonsPrepare(8);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 86) then begin
      ControlButtonsPrepare(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 83) then begin
      ControlButtonsPrepare(2);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 68) then begin
      ControlButtonsPrepare(3);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 65) then begin
      if Form1.ActiveControl = RichEdit1 then exit;
      sbPredClipClick(nil);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 83) then begin
      if Form1.ActiveControl = RichEdit1 then exit;
      sbNextClipClick(nil);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 68) then begin
      if Form1.ActiveControl = RichEdit1 then exit;
      MyMediaSwitcher.Select:=0;
      SwitcherVideoPanels(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 70) then begin
      if Form1.ActiveControl = RichEdit1 then exit;
      MyMediaSwitcher.Select:=1;
      SwitcherVideoPanels(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 71) then begin
      if Form1.ActiveControl = RichEdit1 then exit;
      CheckBox1.Checked:= not CheckBox1.Checked;
      CheckBox1Click(nil);
      exit;
    end;

    if pnMediaTL.Visible then begin

      //If (ssAlt In Shift) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 90) then begin
      //  ButtonsControlMedia(1);
      //  exit;
      //end;

      If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 77) then begin
        ButtonsControlMedia(4);
        exit;
      end;

      If (ssAlt In Shift) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 77) then begin
        ButtonsControlMedia(5);
        exit;
      end;

    end;



    if pnTextTL.Visible then begin

      If (ssAlt In Shift) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 67) then begin
        crpos := TLZone.TLEditor.CurrentEvents;
        if crpos.Number<>-1 then begin
          SaveToUNDO;
          ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
          txt := TLZone.TLEditor.Events[crpos.Number].ReadPhraseText('Text');
          endp := TLZone.TLEditor.Events[crpos.Number].Finish;
          cnt := trunc((endp - TLZone.TLEditor.Events[crpos.Number].Start)*TLParameters.FrameSize / length(txt)) ;
          cnt1 := trunc((TLParameters.Position - TLZone.TLEditor.Events[crpos.Number].Start)*TLParameters.FrameSize / cnt) ;
          txt1:='';
          for i:=1 to cnt1 do txt1:=txt1 + txt[i];
          txt2:='';
          for i:=cnt1+1 to length(txt) do txt2:=txt2 + txt[i];
          TLZone.TLEditor.Events[crpos.Number].Finish:=TLParameters.Position;
          ARow:=TLZone.TLEditor.AddEvent(TLParameters.Position,ps+1,0);
          TLZone.TLEditor.Events[ARow].Assign(TLZone.TLEditor.Events[crpos.Number]);
          TLZone.TLEditor.Events[crpos.Number].SetPhraseText('Text',trim(txt1));
          TLZone.TLEditor.Events[ARow].Start:=TLParameters.Position;
          TLZone.TLEditor.Events[ARow].Finish:=endp;
          TLZone.TLEditor.Events[ARow].SetPhraseText('Text',trim(txt2));
          TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
          TLZone.TLEditor.UpdateScreen(bmptimeline.Canvas);
          TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas, ps, TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
          TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
          imgtimelines.Repaint;
        end;
        exit;
      end;

    end;

//таблицу кодов клавиш клавиатуры
//
//VK_LBUTTON -Левая клавиша мыши
//VK_RBUTTON - Правая клавиша мыши
//VK_MBUTTON - Средняя клавиша мыши (скрол)
//VK_BACK - Backspace (<--)
//VK_TAB - Tab (Табуляция)
//VK_RETURN - Enter(Ввод)
//VK_SHIFT - Shift(Шифт)
//VK_CONTROL - Ctrl
//VK_MENU - Alt
//VK_PAUSE - Pause Break
//VK_CAPITAL - Caps Lock
//VK_ESCAPE - Esc
//VK_SPACE - Space bar(Пробел)
//VK_PRIOR - Page Up
//VK_NEXT - Page Down
//VK_END - End
//VK_HOME - Home
//VK_LEFT - Left Arrow (Стрелочка влево)
//VK_UP - Up Arrow (Стрелочка вверх)
//VK_RIGHT - Right Arrow (Стрелочка вправо)
//VK_DOWN - Down Arrow (Стрелочка вниз)
//VK_SNAPSHOT - Print Screen
//VK_INSERT - Insert
//VK_DELETE - Delete
//VK_LWIN - Left Windows (Левая кнопочка Windows)
//VK_RWIN - Right Windows (Правая кнопочка Windows)
//
//
//Цыфровая клавиатура. Кнопка соответствует цифре в конце названия
//
//VK_NUMPAD0 - 0
//VK_NUMPAD1 - 1
//VK_NUMPAD2 - 2
//VK_NUMPAD3 - 3
//VK_NUMPAD4 - 4
//VK_NUMPAD5 - 5
//VK_NUMPAD6 - 6
//VK_NUMPAD7 - 7
//VK_NUMPAD8 - 8
//VK_NUMPAD9 - 9
//VK_MULTIPLY - Multiply (* Умножение)
//VK_ADD - Add (+ плюс)
//VK_SEPARATOR - Separator ()
//VK_SUBTRACT - Subtract()
//VK_DECIMAL - Decimal(- минус)
//VK_DIVIDE - Divide (/ деление)
//
//Функциональные клавиши
//
//VK_F1 - F1
//VK_F2 - F2
//VK_F3 - F3
//VK_F4 - F4
//VK_F5 - F5
//VK_F6 -F6
//VK_F7 -F7
//VK_F8 - F8
//VK_F9 - F9
//VK_F10 - F10
//VK_F11 - F11
//VK_F12 - F12
//
//VK_NUMLOCK - Num Lock
//VK_SCROLL - Scroll Lock
//VK_LSHIFT - Left Shift (Левый шифт)
//VK_RSHIFT - Right Shift (Правый шифт)
//VK_LCONTROL - Left Ctrl (Левый Ctrl)
//VK_RCONTROL - Right Ctrl (Правый Ctrl)
//VK_LMENU - Left Alt (Левый Alt)
//VK_RMENU - Right Alt (Правый Alt)

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 73) then begin
      if TLParameters.Position < TLParameters.Finish then begin
        SaveToUNDO;
        TLParameters.Start := TLParameters.Position;
        TLZone.DrawBitmap(bmptimeline);
        TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
        //TLZone.DrawCursorStart(imgLayer1.Canvas);
        imgtimelines.Repaint;
        imgLayer1.repaint;
      end;
      exit;
    end;


    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 79) then begin
      if TLParameters.Position > TLParameters.Start then begin
        SaveToUNDO;
        TLParameters.Finish := TLParameters.Position;
        TLZone.DrawBitmap(bmptimeline);
        TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
        //TLZone.DrawCursorEnd(imgLayer1.Canvas);
        imgtimelines.Repaint;
        imgLayer1.repaint;
      end;
      exit;
    end;

    If (ssCtrl In Shift) And (Key in [49..57,97..105]) then begin
      SaveToUNDO;
      if key >= 97
        then InsertEventToEditTimeline(Key - 87)
        else InsertEventToEditTimeline(Key - 39);
      exit;
    end;

    If (ssCtrl In Shift) And ((Key=48) or (Key=96)) then begin
      SaveToUNDO;
      InsertEventToEditTimeline(19);
      exit;
    end;

    If (ssShift In Shift) And (Key in [49..57,97..105]) then begin
      SaveToUNDO;
      if Key >= 97
        then InsertEventToEditTimeline(Key - 77)
        else InsertEventToEditTimeline(Key - 29);
      exit;
    end;

    If (ssShift In Shift) And ((Key=48) or (Key=96)) then begin
      SaveToUNDO;
      InsertEventToEditTimeline(29);
      exit;
    end;

    If (ssAlt In Shift) And ((Key=49) or (Key=97)) then begin
      SaveToUNDO;
      InsertEventToEditTimeline(30);
      exit;
    end;

    If (ssAlt In Shift) And ((Key=50) or (Key=98)) then begin
      SaveToUNDO;
      InsertEventToEditTimeline(31);
      exit;
    end;

    If Key in [49..57,97..105] then begin
      SaveToUNDO;
      if Key >= 97
        then InsertEventToEditTimeline(Key - 97)
        else InsertEventToEditTimeline(Key - 49);
      exit;
    end;

    If (Key=48) or (Key=96) then begin
      SaveToUNDO;
      InsertEventToEditTimeline(9);
      exit;
    end;
  end;

//Кнопки панели Список клипов

  if PanelClips.Visible then begin

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 73) then begin
      ButtonsControlClipsPanel(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 78) then begin
      ButtonsControlClipsPanel(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 80) then begin
      ButtonsControlClipsPanel(2);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 83) then begin
      ButtonsControlClipsPanel(3);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 76) then begin
      ButtonsControlClipsPanel(4);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = VK_DELETE) then begin
      ButtonsControlClipsPanel(5);
      exit;
    end;

  end;

//Кнопки панели Активный плей-лист

  if PanelPlayList.Visible then begin

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 78) then begin
      ButtonsControlPlayList(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 82) then begin
      ButtonsControlPlayList(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = VK_DELETE) then begin
      ButtonsControlPlayList(2);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 80) then begin
      ButtonsControlPlayList(3);
      exit;
    end;

  end;

//Кнопки панели Проектов

  if panelproject.Visible then begin
    //Управление проектами
    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 78) then begin
      ButtonsControlProjects(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 68) then begin
      ButtonsControlProjects(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 67) then begin
      ButtonsControlProjects(2);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 83)  then begin
      ButtonsControlProjects(3);
      exit;
    end;

    If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (ssShift In Shift) and (Key = 66) then begin
      imgBlockProjectsClick(nil);
      exit;
    end;

    //Управление списками листов

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 84) then begin
      GridTimeLinesDblClick(nil);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 187) then begin
      ButtonControlLists(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 189) then begin
      ButtonControlLists(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 78) then begin
      ButtonPlaylLists(0);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 68) then begin
      ButtonPlaylLists(1);
      exit;
    end;

    If (not (ssAlt In Shift)) and (ssCtrl In Shift) and (not (ssShift In Shift)) and (Key = 83) then begin
      ButtonControlLists(6);
      exit;
    end;

    If (ssAlt In Shift) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 83) then begin
      ButtonPlaylLists(2);
      exit;
    end;

    //Управление выбором списков плейлистов и шаблонов.

    //If (ssAlt In Shift) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 80) then begin
    //  SetSecondaryGrid(playlists);
    //  exit;
    //end;

    If (ssAlt In Shift) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 71) then begin
      EditImageTamplate;
      exit;
    end;

    If (ssAlt In Shift) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = 84) then begin
      MyTextTemplateOptions;
      exit;
    end;

    if ActiveControl = GridProjects then begin
      If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = VK_RETURN) then begin
        ps := findgridselection(form1.gridprojects, 2);
        if ps=GridProjects.Row then exit;
        if ps<>-1 then if MyTextMessage('Вопрос', 'Сохранить текущий проект?',2) then begin
          saveoldproject;
          //lbPLName.Caption:='';
        end;
        for i:=1 to GridProjects.RowCount-1 do (GridProjects.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
        (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[2].Mark:=true;
        loadoldproject;
        ProjectToPanel(GridProjects.Row);
        exit;
      end;
    end;

    if (ActiveControl = GridLists) and (SecondaryGrid = playlists) then begin
      If (not (ssAlt In Shift)) and (not (ssCtrl In Shift)) and (not (ssShift In Shift)) and (Key = VK_RETURN) then begin
        ps := findgridselection(form1.gridlists, 2);
        if ps = GridLists.Row then begin
          sbPlayListClick(nil);
          exit;
        end;
        for i:=1 to GridLists.RowCount-1 do (GridLists.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
         (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[2].Mark:=true;
         PlaylistToPanel(GridLists.Row);

         if cbPlayLists.ItemIndex<>-1 then begin
           txt := (cbPlayLists.Items.Objects[cbPlayLists.ItemIndex] as TMyListBoxObject).ClipId;
           if FileExists(PathPlayLists + '\' + txt) then begin
             LoadGridFromFile(PathPlayLists + '\' + txt, GridActPlayList);
             CheckedActivePlayList;
           end else GridClear(GridActPlayList, RowGridClips);
         end;

        GridLists.Repaint;
        exit;
      end;
    end;

  end;


//If ((ssCtrl In Shift) And (Key=Ord('t'))) Then //Ctrl+t
//If ((ssAlt In Shift) And (Key=Ord('t'))) Then //Alt+t
//If ((ssShift In Shift) And (Key=Ord('t'))) Then //Shift+t
//If ((ssShift In Shift) And (ssCtrl In Shift) And (Key=Ord('t'))) Then //Ctrl+Shift+t
end;

procedure TForm1.imgTextTLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var ps, res : integer;
begin
  //if trim(Label2.Caption)='' then exit;

  ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
  if TLZone.Timelines[ps].Block then begin
    frLock.ShowModal;
    exit;
  end;
  SaveToUNDO;
  TextRichSelect := false;
  ActiveControl:=panel8;
  res:=btnstexttl.ClickButton(imgTextTL.Canvas,X,Y);
       case res of
  0: begin
       InsertEventToEditTimeline(-1);
       ActiveControl:=panel8;
     end;
  1: begin
     end;
  2: begin
       LoadSubtitrs;
       TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
       form1.imgLayer0.repaint;
       TLZone.DrawBitmap(bmptimeline);
       TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
       imgtimelines.Repaint;
       form1.Repaint;
     end;
       end;
end;

procedure TForm1.imgTextTLMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  btnstexttl.MouseMove(imgTextTL.Canvas,X,Y);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then begin
    GridGRTemplate.Visible:=true;
    Panel16.Visible:=true;
    CheckBox2.Visible:=true;
    spDeleteTemplate.Visible:=true;
  end else begin
    GridGRTemplate.Visible:=false;
    Panel16.Visible:=false;
    CheckBox2.Visible:=false;
    spDeleteTemplate.Visible:=false;
  end;
  if Sender<>nil then ActiveControl := PanelPrepare;
end;

procedure TForm1.GridGRTemplateDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  GridDrawMyCell(GridGRTemplate, ACol, ARow, Rect);
end;

procedure TForm1.GridGRTemplateMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, j, rw, ps, evst : integer;
    bl : boolean;
    txt, flnm : string;
    crpos : teventreplay;
begin
  ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
  if TLZone.Timelines[ps].Block then begin
    frLock.ShowModal;
    exit;
  end;
  SaveToUNDO;
  if (TLzone.TLEditor.TypeTL=tltext) or (TLzone.TLEditor.TypeTL=tlmedia) then exit;
  //rw := RowGridGrTemplateSelect;
  crpos := TLZone.TLEditor.CurrentEvents;
  rw := GridClickRow(GridGRTemplate,Y);
  if rw=-1 then exit;
  if not DblClickGridGRTemplate then exit;
  if GridGRTemplate.Objects[0,rw] is TGridRows then begin
    DblClickGridGRTemplate := false;
    with (GridGRTemplate.Objects[0,rw] as TGridRows) do begin
      for j := 0 to GridGRTemplate.RowCount-1
        do (GridGRTemplate.Objects[0,j] as TGridRows).MyCells[0].Mark:=false;
      MyCells[0].Mark:=true;
      MyCells[0].ColorTrue:=clRed;
      txt := MyCells[Count-1].ReadPhrase('Template');
      flnm := MyCells[Count-1].ReadPhrase('File');
    end;
    bl:=false;
    if mode<>play then begin
      for i:=0 to TLzone.TLEditor.Count-1 do begin
        if TLzone.TLEditor.Events[i].Select then begin
          if not CheckBox2.Checked then TLzone.TLEditor.Events[i].SetPhraseText('Text',txt);
          TLzone.TLEditor.Events[i].SetPhraseCommand('Text',flnm);
          if i=crpos.Number then begin
            crpos := TLZone.TLEditor.CurrentEvents;
            TemplateToScreen(crpos);
          end;
          bl:=true;
        end;
      end;
    end;
    if not bl then begin
      for i:=0 to TLzone.TLEditor.Count-1 do begin
        if (TLzone.TLEditor.Events[i].Start<=TLParameters.Position) and (TLzone.TLEditor.Events[i].Finish>TLParameters.Position)
        then begin
          if not CheckBox2.Checked then TLzone.TLEditor.Events[i].SetPhraseText('Text',txt);
          TLzone.TLEditor.Events[i].SetPhraseCommand('Text',flnm);
          if mode<>play then begin
            crpos := TLZone.TLEditor.CurrentEvents;
            TemplateToScreen(crpos);
          end;
          break;
        end;
      end;
    end;
  end;
  ps:=TLzone.FindTimeline(TLzone.TLEditor.IDTimeline);
  TLzone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
  evst := TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame);
  //TLzone.TLEditor.DrawEditor(bmptimeline.Canvas,evst);
  TLZone.TLEDitor.UpdateScreen(bmptimeline.Canvas);
  TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps, evst);
  if mode<>play then TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
  gridGRTemplate.Repaint;
end;

procedure TForm1.imgLayer2DblClick(Sender: TObject);
begin
   if TLZone.TLEditor.isZoneEditor
     then TLZone.TLEditor.DoubleClick:=true
     else TLZone.TLEditor.DoubleClick:=false;
end;

procedure TForm1.GridProjectsRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
var ins, ine : integer;
  s : string;
begin
  ins := FromIndex;
  ine := ToIndex;
  s:=inttostr(ToIndex);
end;

procedure TForm1.GridProjectsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i : integer;
    s: string;
begin
  RowDownGridProject := GridProjects.Row;
end;

procedure TForm1.GridListsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RowDownGridLists := GridLists.Row;
end;

procedure TForm1.GridClipsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RowDownGridClips := GridClips.Row;
end;

procedure TForm1.GridActPlayListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  RowDownGridActPlayList := GridActPlayList.Row;
end;

procedure TForm1.imgTypeMovieMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MyMediaSwitcher.MouseMove(imgTypeMovie.Canvas, X, Y);
  MyMediaSwitcher.Draw(imgTypeMovie.Canvas);
  imgTypeMovie.Repaint;
end;

procedure TForm1.imgTypeMovieMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res : integer;
    crpos : teventreplay;
begin
  res := MyMediaSwitcher.MouseClick(imgTypeMovie.Canvas, X, Y);
  SwitcherVideoPanels(res);
//       case res of
//  0: begin
//       pnImageScreen.Visible := false;
//     end;
//  1: begin
//       pnImageScreen.Left := pnMovie.Left;
//       pnImageScreen.Top := pnMovie.Top;
//       pnImageScreen.Width := pnMovie.Width;
//       pnImageScreen.Height := pnMovie.Height;
//       pnImageScreen.Visible := true;
//       crpos := TLZone.TLEditor.CurrentEvents;
//       if crpos.Number <> -1
//         then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image)
//         else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '');
//       TemplateToScreen(crpos);
//     end;
//       end;
//  imgTypeMovie.Repaint;
end;

procedure TForm1.GridGRTemplateDblClick(Sender: TObject);
begin
  DblClickGridGRTemplate := true;
end;

procedure TForm1.spDeleteTemplateClick(Sender: TObject);
var i, ps : integer;
    bl : boolean;
    txt, flnm : string;
begin
  if (TLzone.TLEditor.TypeTL=tltext) or (TLzone.TLEditor.TypeTL=tlmedia) then exit;
  ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
  if TLZone.Timelines[ps].Block then begin
    frLock.ShowModal;
    exit;
  end;
  SaveToUNDO;
  bl:=false;
  if mode <> play then begin
    for i:=0 to TLzone.TLEditor.Count-1 do begin
      if TLzone.TLEditor.Events[i].Select then begin
        TLzone.TLEditor.Events[i].SetPhraseCommand('Text','');
        bl:=true;
      end;
    end;
  end;  
  if not bl then begin
    for i:=0 to TLzone.TLEditor.Count-1 do begin
      if (TLzone.TLEditor.Events[i].Start<=TLParameters.Position)
          and (TLzone.TLEditor.Events[i].Finish>TLParameters.Position) then begin
        TLzone.TLEditor.Events[i].SetPhraseCommand('Text','');
        break;
      end;
    end;
  end;
  for i:=1 to GridGRTemplate.RowCount-1
    do if GridGRTemplate.Objects[0,i] is TGridRows
         then (GridGRTemplate.Objects[0,i] as TGridRows).MyCells[0].Mark:=false;
  ps:=TLzone.FindTimeline(TLzone.TLEditor.IDTimeline);
  TLzone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
  //TLzone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
  TLZone.TLEDitor.UpdateScreen(bmptimeline.Canvas);
  TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,0);
  if mode<>play then TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
  gridGRTemplate.Repaint;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  Form1.image2.Canvas.FillRect(Form1.image2.Canvas.ClipRect);
  (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[0].Mark := not (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[0].Mark;
  if (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[0].Mark
    then LoadBMPFromRes(Form1.image2.Canvas,Form1.image2.Canvas.ClipRect,30,30,'Lock')
    else LoadBMPFromRes(Form1.image2.Canvas,Form1.image2.Canvas.ClipRect,30,30,'Unlock');
  GridClips.Repaint;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var ps : integer;
begin
  if PanelPrepare.Visible then begin
    if trim(Form1.lbActiveClipID.Caption)='' then exit;
    if key=32 then exit;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    if TLZone.Timelines[ps].Block then frLock.ShowModal;
    //Timer2.Enabled:=true;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
var ps : integer;
    crpos : teventreplay;
begin
  if InputPanel.Visible then begin
    InputPanel.Left:=0;
    InputPanel.Width:=Form1.ClientWidth;
    InputPanel.Top:=0;
    InputPanel.Height:=Form1.ClientHeight;
  end;

  if PanelPrepare.Visible then begin
    UpdatePanelPrepare;
    crpos := TLZone.TLEditor.CurrentEvents;
    MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image);
    CurrentImageTemplate:='@@33@@';
    TemplateToScreen(crpos);
    if pnImageScreen.Visible then Image3.Repaint;
    exit;
  end;
  if PanelProject.Visible then begin
    imgButtonsControlProj.Picture.Bitmap.Height:=imgButtonsControlProj.Height;
    pnlprojcntl.Draw(imgButtonsControlProj.Canvas);
  end;
end;

procedure TForm1.RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  TextRichSelect := true;
end;

procedure TForm1.RichEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=32) and (not TextRichSelect) then begin
    key:=32;
    exit;
  end;
  if Key=13 then begin
    TextRichSelect := false;
    InsertEventToEditTimeline(-1);
    ActiveControl:=panel8;
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  If ListUsers.UserExists(Edit1.Text,Edit2.Text) then begin
    CurrentUser := Edit1.Text;
    lbEditor.Caption    := CurrentUser;
    InputPanel.Visible:=false
  end else MyTextMessage('Предупреждение','Неправильно заданы имя пользователя и/или пароль.',1);
end;

procedure TForm1.ImgButtonsPLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button<>mbLeft then exit;
  i:=pnlplaylsts.ClickButton(ImgButtonsPL.Canvas,x,y);
  ButtonPlaylLists(i);
end;

procedure TForm1.ImgButtonsPLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  pnlplaylsts.MouseMove(ImgButtonsPL.Canvas,x,y);
end;

procedure TForm1.cbPlayListsChange(Sender: TObject);
var FLName : string;
    i : integer;
begin

  if not (cbPlayLists.Items.Objects[cbPlayLists.ItemIndex] is TMyListBoxObject) then exit;
  FLName := (cbPlayLists.Items.Objects[cbPlayLists.ItemIndex] as TMyListBoxObject).ClipId;
  for i:=1 to GridLists.RowCount-1 do (GridLists.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
  (GridLists.Objects[0,cbPlayLists.ItemIndex+1] as TGridRows).MyCells[2].Mark:=true;
  lbplcomment.Caption := (GridLists.Objects[0,cbPlayLists.ItemIndex+1] as TGridRows).MyCells[3].ReadPhrase('Comment');
  if FileExists(PathPlayLists + '\' + FLName) then begin
    LoadGridFromFile(PathPlayLists + '\' + FLName, GridActPlayList);
    CheckedActivePlayList;
  end else GridClear(GridActPlayList, RowGridClips);
  GridActvePLToPanel(GridActPlayList.Row);
  if PanelPlayList.Visible then ActiveControl:=GridActPlayList;
  if cbPlayLists.ItemIndex<>-1
    then Form1.lbClipActPL.Caption := cbPlayLists.Items.Strings[cbPlayLists.ItemIndex]
    else Form1.lbClipActPL.Caption := '';
  GridActPlayList.Repaint;
  lbusesclpidlst.Caption := 'Плай-лист: ' + trim(cbPlayLists.Text);
end;

procedure TForm1.sbSinhronizationClick(Sender: TObject);
begin
  SetLTC;
end;

end.



