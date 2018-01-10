unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, (*UPlayer,*) PasLibVlcUnit, vlcpl, UHRTimer,  MMSystem;

Const

WM_DRAWTimeline = WM_APP + 9876;          //Warning

type

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
    sbListPlayLists: TSpeedButton;
    sbListGraphTemplates: TSpeedButton;
    sbListTextTemplates: TSpeedButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
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
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lbClipSinger: TLabel;
    lbClipRegistr: TLabel;
    lbClipStopUse: TLabel;
    lbClipTotalDur: TLabel;
    lbClipNTK: TLabel;
    lbClipDur: TLabel;
    lbClipType: TLabel;
    lbClipSong: TLabel;
    lbClipPath: TLabel;
    lbClipComment: TLabel;
    lbPlayList: TLabel;
    lbPLComment: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lbPLCreate: TLabel;
    lbPLEnd: TLabel;
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
    lbPLName: TLabel;
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
    procedure Panel10Resize(Sender: TObject);
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


  private
    { Private declarations }
    p_li : libvlc_instance_t_ptr;
    p_mi : libvlc_media_player_t_ptr;
    //procedure PlayerInit();
    //procedure PlayerPlay(fileName: WideString);
    procedure PlayerStop();
    procedure PlayerDestroy();
    // Обработчик сообщения WM_HOTKEY
    procedure WMHotKey(var Mess:TWMHotKey);message WM_HOTKEY;
    //Procedure WMKeyDown(Var Msg:TWMKeyDown); Message WM_KeyDown;
    procedure WMDRAWTimeline(var msg:TMessage); Message WM_DRAWTimeline;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  MyTimer : THRTimer;
  MyThread : TMyThread;
  PredDt, CurrDt : Double;

  Player :tvlcpl;

  mmResult : Integer;
  //strgrrect : TGridRect;

  procedure SetMediaButtons;
  procedure StartMyTimer;
  procedure StopMyTimer;
  Function ReadMyTimer : Double;
  procedure WaitingStart(wrd : string);
  procedure WaitingStop;

implementation

uses UInitForms, UCommon, UGrid, UProject, UIMGButtons, UDelGridRow, UTimeline,
     UDrawTimelines, uimportfiles, uactplaylist, ugrtimelines, uwaiting, umyevents,
     uplaylists, UMyFiles, UTextTemplate, UMyMessage, UImageTemplate, uAirDraw,
     USubtitrs, USetTemplate, ugridsort, uwebserv ,ulkjson;

{$R *.dfm}
{$R bmpres1.res}

//==============================================================================
//====         Процедуры работы с точным таймером         ======================
//==============================================================================

procedure TForm1.PlayerStop();
begin
 player.Stop;
end;

procedure TForm1.PlayerDestroy();
begin
  player.release;
end;

procedure  TForm1.WMDRAWTimeline(var msg:TMessage);
begin
  //MyPanelAir.SetValues;
  MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, msg.WParam);
  //application.ProcessMessages;
     //if bmptimeline.Canvas.LockCount =0 then TLZone.DrawBitmap(bmptimeline);
      //if Form1.imgtimelines.Canvas.LockCount<>0 then exit;
  //TLZone.DrawBitmap(bmptimeline);
  TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
  if Form1.PanelAir.Visible then MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);

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
   {Если Вы хотите, чтобы процедура DoWork выполнялась лишь один раз - удалите цикл while}
   while not Terminated do
     Synchronize(DoWork);
 end;

procedure TMyThread.DoWork;
var curpos, delttm : longint;
    dps : double;
    db0, db1, db2, db3 : double;
    crpos : integer;
    CurrTemplate : string;
begin
  try
   If MyTimer.Waiting then begin
       FWait.Position:=FWait.Position+1;
       FWait.Draw;
       application.ProcessMessages;
     exit;
   end;
   If MyTimer.Enable then begin
      CurrDt:=MyTimer.ReadTimer - PredDt;
      delttm:=trunc((CurrDT-PredDT) * 1000);
      While delttm < 20 do begin
        CurrDt:=MyTimer.ReadTimer - PredDt;
        delttm:=trunc((CurrDT-PredDT) * 1000);
        application.ProcessMessages;
      end;
      //if delttm < 40 then exit;
      //PredDT:=CurrDT;
      TLParameters.Position:=TLParameters.StopPosition + MyDoubleToFrame(CurrDt);
      if mode=play then begin
//Warning        if TLParameters.Position<TLParameters.Preroll then pMediaControl.Pause else pMediaControl.Run;
//Warning        pMediaPosition.get_CurrentPosition(dps);
        if TLParameters.Position<TLParameters.Preroll then player.Pause else player.Play;
        dps := player.Time;
        if pStart >= dps then exit;
      end;

      curpos:=TLParameters.Position - TLParameters.ZeroPoint;
      Form1.lbCTLTimeCode.Caption:=FramesToStr(curpos);
      MyPanelAir.SetValues;
      MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, curpos);
      //===================
      //addVariable(0,'A0',FramesToStr(curpos));
      //addVariable(1,'A1',FramesToStr(curpos));
      addVariable(1,'A1','dddd');
      //addVariable(2,'A3',FramesToStr(curpos));
      //addVariable(3,'A4',FramesToStr(curpos));
      //+++++++++++++++++++
      crpos := TLZone.TLEditor.CurrentEvents;
      if crpos <> -1 then begin
        CurrTemplate := TLZone.TLEditor.Events[crpos].ReadPhraseCommand('Text');
        MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', CurrTemplate);
        if Form1.pnImageScreen.Visible then begin
          if Trim(CurrTemplate)<>'' then begin
            if FileExists(PathTemplates + '\' + CurrTemplate)
              then Form1.Image3.Picture.LoadFromFile(PathTemplates + '\' + CurrTemplate);
          end;
        end;
      end;

      //+++++++++++++++++++

      //SendMessage(Form1.Handle,WM_DRAWTimeline,curpos,0);
      application.ProcessMessages;
      //if bmptimeline.Canvas.LockCount =0 then TLZone.DrawBitmap(bmptimeline);
      //if Form1.imgtimelines.Canvas.LockCount<>0 then exit;
      TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
      if Form1.PanelAir.Visible then MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);

//Warning      pMediaPosition.get_CurrentPosition(db1);
      db1 := player.Time;
//Warning      pMediaPosition.get_Duration(db2);
      db2 := player.Duration;
      db3:=FramesToDouble(TLParameters.Finish - TLParameters.Preroll);
      if db1<db2 then db0:=db1 else db0:=FramesToDouble(TLParameters.Position - TLParameters.Preroll);
      if db0>=db3 then begin
//Warning        MediaStop;
        player.Pause;
        SetMediaButtons;
        //Timer1.Enabled:=false;
      end;
   end;
  except
  end; 
end;

procedure StartMyTimer;
begin
  PredDt:=0;
  TLParameters.StopPosition:=TLParameters.Position;
  MyTimer.StartTimer;
  PredDt:=MyTimer.ReadTimer;
  pStart:=player.Time;
//Warning  pMediaPosition.get_CurrentPosition(pStart);
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
//Warning
(*Procedure  TForm1.WMKeyDown(Var Msg:TWMKeyDown);
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

//Warning      pVideoWindow.SetWindowPosition(0,0,pnMovie.ClientRect.Right,pnMovie.ClientRect.Bottom);
//Warning      FullScreen:=False;
end;
  inherited;
end; *)

procedure TForm1.WMHotKey(var Mess: TWMHotKey);
var hk, uns, res : integer;
    s : string;
begin
 //MessageBeep(0);

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
var ps : integer;
begin
  SetMainGridPanel(actplaylist);
  if secondarygrid<>playlists then exit;
  ps:=findgridselection(GridLists,2);
  if ps<>-1 then begin
    //(GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark
    //  := Not (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark;
    SetPlaylistBlocking(ps);
    Image1.Repaint;
  end;
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
  end;
  Label2Click(nil);
  Form1.Repaint;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i, ps : integer;
    ext, nm : string;
begin
  CreateDirectories('');
  ExecTaskOnDelete;
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
  form1.Repaint;
//Warning  CoInitialize(nil);// инициализировать OLE

   Player:=TVlcPl.Create;
   if player.Init(pnMovie.Handle)<>'' then MyTextMessage('Ошибка',Player.error, 1);

  bmpTimeline := TBitmap.Create;
  bmpEvents := TBitmap.Create;
  MyTimer:=THRTimer.Create;
  MyThread:=TMyThread.Create(False);
  //MyThread.Priority:=tpTimeCritical;//tpHighest;
  //MyThread.Priority:=tpHighest;
  LoadGridFromFile(AppPath + DirProjects + '\' + 'ListProjects.prjt', GridProjects);
  loadoldproject;

end;

procedure TForm1.Label2Click(Sender: TObject);
var hght, tp : integer;
    strs : string;
begin
  PanelProject.Visible:=false;
  PanelClips.Visible:=false;
  PanelPlayList.Visible:=false;
  sbProject.Font.Style:=sbProject.Font.Style - [fsBold,fsUnderline];
  sbClips.Font.Style:=sbClips.Font.Style - [fsBold]; //,fsUnderline
  sbPlayList.Font.Style:=sbPlayList.Font.Style - [fsBold]; //,fsUnderline
  if CurrentMode then begin
    PanelPrepare.Visible:=true;//false;
    PanelAir.Visible:=true;
  end else begin
    PanelAir.Visible:=false;
    PanelPrepare.Visible:=true;
  end;
  UpdatePanelPrepare;

  TLZone.DrawBitmap(bmptimeline);
  TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
  TLZone.DrawLayer2(imgLayer2.Canvas);
  Form1.Repaint;
end;

procedure TForm1.sbListPlayListsClick(Sender: TObject);
var i : integer;
begin
  SetSecondaryGrid(playlists);
end;

procedure TForm1.sbListGraphTemplatesClick(Sender: TObject);
var i : integer;
begin
  SetSecondaryGrid(grtemplate);
end;

procedure TForm1.sbListTextTemplatesClick(Sender: TObject);
var i : integer;
begin
  SetSecondaryGrid(txttemplate);
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
           lbPLName.Caption:='';
         end;
         for i:=1 to GridProjects.RowCount-1 do (GridProjects.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
         (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[2].Mark:=true;
         loadoldproject;
         ProjectToPanel(GridProjects.Row);
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

procedure TForm1.Panel10Resize(Sender: TObject);
begin
 // InitGridLists(playlists);
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
var i, lft, rgt, cl, cnt : integer;
begin
  i := GridColX(GridLists,X);
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
         PlaylistToPanel(GridLists.Row);
         if FileExists(PathPlayLists + '\' + Form1.lbPLName.Caption) then begin
           LoadGridFromFile(PathPlayLists + '\' + Form1.lbPLName.Caption, GridActPlayList);
           CheckedActivePlayList;
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
                then EditImageTamplate(-1)
                else EditImageTamplate(GridLists.Row);
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
        case SecondaryGrid of
  playlists   : begin
                  GridListsMouseUpPlaylists(X, Y);
                  SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                end;
  grtemplate  : begin
                 GridListsMouseUpGrTemplates(X, Y);
                 SaveGridToFile(PathTemp + '\ImageTemplates.lst', GridLists);
                end;
  txttemplate : begin
                 GridListsMouseUpTextTemplates(X, Y);
                 SaveGridToFile(PathTemp + '\TextTemplates.lst', GridLists);
                end;
       end; //case
end;

procedure TForm1.imgButtonsProjectMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, ps, setpos : integer;
    s, fp, msg, cmnt, edt : string;
    SDir, TDir : string;
begin

  if Button<>mbLeft then exit;
  i:=pnlprojects.ClickButton(imgButtonsProject.Canvas,x,y);
       case i of
  0: CreateProject(-1);
  1: begin
       ps := findgridselection(gridprojects, 2);
       if CountGridMarkedRows(GridProjects, 1, 1)<>0 then begin
         if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные проекты?',2) then exit;
         if ps > 0 then begin
           if (GridProjects.Objects[0,ps] as TGridRows).MyCells[1].Mark
             then if not MyTextMessage('Вопрос','Вы действительно хотите удалить текущий проект?',2)
                   then (GridProjects.Objects[0,ps] as TGridRows).MyCells[1].Mark := false;
         end;
         For i:=GridProjects.RowCount-1 downto 1 do begin
           if (GridProjects.Objects[0,i] as TGridRows).MyCells[1].Mark then begin
             s := (GridProjects.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
             MyGridDeleteRow(GridProjects, i, RowGridProject);
             if Trim(s)<>'' then begin
               ProjectNumber:='';
               if not KillDir(AppPath + DirProjects + '\' + s) then SetTaskOnDelete(s);
             end;
           end;
         end;
       end else begin
         if ps=gridprojects.Row then begin
           if not MyTextMessage('Вопрос','Вы действительно хотите удалить текущий проект?',2) then exit;
         end else if not MyTextMessage('Вопрос','Вы действительно хотите удалить проект?',2) then exit;
         s := (GridProjects.Objects[0,gridprojects.Row] as TGridRows).MyCells[3].ReadPhrase('Note');
         MyGridDeleteRow(GridProjects, GridProjects.Row, RowGridProject);
         if Trim(s)<>'' then begin
           ProjectNumber:='';
           if not KillDir(AppPath + DirProjects + '\' + s) then SetTaskOnDelete(s);
         end;
       end;
       initnewproject;
       ps := findgridselection(gridprojects, 2);
       if ps > 0 then loadoldproject;
     end;
  2: begin
       ps := findgridselection(gridprojects, 2);
       if  (GridProjects.Row > 0) and (GridProjects.Row < GridProjects.RowCount) then begin
         s := (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[3].ReadPhrase('Note');
         if trim(s) = '' then exit;
         msg := (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[3].ReadPhrase('Project');
         cmnt := (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[3].ReadPhrase('Comment');
         edt := (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[3].ReadPhrase('EndDate');
         if MyTextMessage('Вопрос','Создать копию проекта ''' + msg + '''?',2) then begin
           if ps = GridProjects.Row
            then if MyTextMessage('Вопрос','Копируется текущий проект. Сохранить сделанные изменения?',2)
                    then saveoldproject;

           msg := GridCreateCopyName(GridProjects, 3, 'Project', msg);
           setpos := AddNewProject(msg, cmnt, edt);
           CreateDirectories(ProjectNumber);

           SDir := AppPath + DirProjects + '\' + s + '\' + DirLists;
           FullDirectoryCopy(SDir, pathlists, false, true);

           SDir := AppPath + DirProjects + '\' + s + '\' + DirTemplates;
           FullDirectoryCopy(SDir, pathtemplates, false, true);

           SDir := AppPath + DirProjects + '\' + s + '\' + DirClips;
           FullDirectoryCopy(SDir, pathclips, false, true);

           SDir := AppPath + DirProjects + '\' + s + '\' + DirPlayLists;
           FullDirectoryCopy(SDir, pathplaylists, false, true);

           SDir := AppPath + DirProjects + '\' + s + '\' + DirTemp;
           FullDirectoryCopy(SDir, pathtemp, false, true);

           for i:=1 to GridProjects.RowCount-1 do (GridProjects.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
           (GridProjects.Objects[0,GridProjects.Row] as TGridRows).MyCells[2].Mark:=true;
           loadoldproject;
           ProjectToPanel(GridProjects.Row);

           Form1.ActiveControl:=Form1.GridProjects;
         end;
       end;
     end;
  3: begin
       SortMyListClear;
       SortMyList[0].Name:='Проекты';
       SortMyList[0].Field:='Project';
       SortMyList[0].TypeData:=tstext;
       SortMyList[1].Name:='Дата регистрации';
       SortMyList[1].Field:='ImportDate';
       SortMyList[1].TypeData:=tsdate;
       SortMyList[2].Name:='Дата окончания';
       SortMyList[2].Field:='EndDate';
       SortMyList[2].TypeData:=tsdate;
       GridSort(GridProjects, 1, 3);
       //SortGridAlphabet(GridProjects, 1, 3, 'Project' , false);
     end;
       end;
  GridProjects.Repaint;
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

procedure TForm1.imgButtonsControlProj1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var s:string;
    i, res, ps, cnt : integer;
    nm : string;
begin
  if Button<>mbLeft then exit;
   res := pnlprojcntl.ClickButton(imgButtonsControlProj.canvas,x,y);
   case res of
 0 : begin
       EditTimeline(-1);
       GridTimelines.Repaint;
     end;
 1 : begin
       DeleteTimeline(GridTimelines.Selection.Top);
       GridTimelines.Repaint;
     end;
 2 : begin
       ps := findgridselection(form1.gridprojects, 2);
       if ps=-1 then exit;
             case SecondaryGrid of
       playlists   : begin
                       EditPlaylist(-1);
                       SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                     end;
       grtemplate  : begin
                       EditImageTamplate(-1);
                       SaveGridToFile(PathTemp + '\ImageTemplates.lst', GridLists);
                       GridImageReload(GridLists);
                       updategridtemplate := true;
                     end;
       txttemplate : begin
                       TextTemplate(-1,false,'');
                       SaveGridToFile(PathTemp + '\TextTemplates.lst', GridLists);
                     end;
             end;
       GridLists.Repaint;
     end;
 3 : begin
             case SecondaryGrid of
       playlists   : begin
                       ps := findgridselection(gridlists, 2);
                       if CountGridMarkedRows(GridLists, 1, 1)<>0 then begin
                         if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные плей-листы?',2) then exit;
                         if ps>0 then begin
                           if (GridLists.Objects[0,ps] as TGridRows).MyCells[1].Mark then begin
                             if MyTextMessage('Вопрос', 'Вы действительно хотите удалить активный плей-лист?',2) then begin
                               (GridLists.Objects[0,ps] as TGridRows).MyCells[2].Mark:=false;
                               lbPlaylist.Caption:='';
                               lbPLComment.Caption:='';
                               lbPLCreate.Caption:='';
                               lbPLEnd.Caption:='';
                               GridClear(GridActPlayList,RowGridClips);
                             end;
                           end;
                         end;
                         for i:=GridLists.RowCount-1 downto 1 do begin
                           if (GridLists.Objects[0,i] as TGridRows).MyCells[1].Mark then begin
                               nm := (GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
                               nm := PathPlaylists + '\PL' + trim(nm) + '.plst';
                               if fileexists(nm) then DeleteFile(nm);
                               MyGridDeleteRow(GridLists, i, RowGridListPL);
                               //SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                           end;
                         end;
                         SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                       end else begin
                         //ps := findgridselection(gridlists, 2);
                         if ps=GridLists.Row then begin
                           if MyTextMessage('Вопрос', 'Вы действительно хотите удалить активный плей-лист?',2) then begin
                             nm := (GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
                             nm := PathPlaylists + '\PL' + trim(nm) + '.plst';
                             if fileexists(nm) then DeleteFile(nm);
                             MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                             SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                             lbPlaylist.Caption:='';
                             lbPLComment.Caption:='';
                             lbPLCreate.Caption:='';
                             lbPLEnd.Caption:='';
                             GridClear(GridActPlayList,RowGridClips);
                           end;
                         end else begin
                           if MyTextMessage('Вопрос', 'Вы действительно хотите удалить плей-лист?',2) then begin
                             nm := (GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
                             nm := PathPlaylists + '\PL' + trim(nm) + '.plst';
                             if fileexists(nm) then DeleteFile(nm);
                             MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                             SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                           end;
                         end;
                       end;//if1
                     end;
       grtemplate  : begin
                       if CountGridMarkedRows(GridLists, 1, 0)<>0 then begin
                         if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные шаблоны?',2) then exit;
                         For i:=GridLists.RowCount-1 downto 1 do begin
                           if (GridLists.Objects[0,i] as TGridRows).MyCells[0].Mark then begin
                             nm := (GridLists.Objects[0,i] as TGridRows).MyCells[2].ReadPhrase('File');
                             nm := PathTemplates + '\' + trim(nm);
                             if fileexists(nm) then DeleteFile(nm);
                             MyGridDeleteRow(GridLists, i, RowGridListGR);
                           end;
                         end;
                         updategridtemplate := true;
                         SaveGridToFile(PathTemp + '\ImageTemplates.lst', GridLists);
                       end else begin
                         if MyTextMessage('Вопрос', 'Вы действительно хотите удалить графический шаблон?',2) then begin
                           nm := (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[2].ReadPhrase('File');
                           nm := PathTemplates + '\' + trim(nm);
                           if fileexists(nm) then DeleteFile(nm);
                           MyGridDeleteRow(GridLists, GridLists.Row, RowGridListGR);
                           updategridtemplate := true;
                           SaveGridToFile(PathTemp + '\ImageTemplates.lst', GridLists);
                         end;
                       end;
                     end;
       txttemplate : begin
                       if CountGridMarkedRows(GridLists, 1, 0)<>0 then begin
                         if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные шаблоны?',2) then exit;
                         For i:=GridLists.RowCount-1 downto 1 do begin
                           if (GridLists.Objects[0,i] as TGridRows).MyCells[0].Mark
                             then MyGridDeleteRow(GridLists, i, RowGridListTxt);
                         end;
                         SaveGridToFile(PathTemp + '\TextTemplates.lst', GridLists);
                       end else begin
                         if MyTextMessage('Вопрос', 'Вы действительно хотите удалить текстовый шаблон?',2) then begin
                           MyGridDeleteRow(GridLists, GridLists.Row, RowGridListTxt);
                           SaveGridToFile(PathTemp + '\TextTemplates.lst', GridLists);
                         end;
                       end;
                     end;
             end;
       GridLists.Repaint;
     end;
 4 : begin
       SaveGridToFile(AppPath + DirProjects + '\' + 'ListProjects.prjt', GridProjects);
       saveoldproject;
       //ps := findgridselection(gridprojects, 2);
       //if ps > 0 then nm:=(gridprojects.Objects[0,ps] as tgridrows).MyCells[3].ReadPhrase('Note');
       //if trim(nm)<>'' then SaveProjectToDisk(nm);
     end;
 5 : begin
             case SecondaryGrid of
       playlists   : begin
                       SortMyListClear;
                       SortMyList[0].Name:='Плей-листы';
                       SortMyList[0].Field:='Name';
                       SortMyList[0].TypeData:=tstext;
                       SortMyList[1].Name:='Дата регистрации';
                       SortMyList[1].Field:='ImportDate';
                       SortMyList[1].TypeData:=tsdate;
                       SortMyList[2].Name:='Дата окончания';
                       SortMyList[2].Field:='EndDate';
                       SortMyList[2].TypeData:=tsdate;
                       GridSort(GridLists, 1, 3);
                     end;
       grtemplate  : begin
                       SortMyListClear;
                       SortMyList[0].Name:='Плей-листы';
                       SortMyList[0].Field:='Template';
                       SortMyList[0].TypeData:=tstext;
                       //SortMyList[1].Name:='Дата регистрации';
                       //SortMyList[1].Field:='ImportDate';
                       //SortMyList[1].TypeData:=tsdate;
                       //SortMyList[2].Name:='Дата окончания';
                       //SortMyList[2].Field:='EndDate';
                       //SortMyList[2].TypeData:=tsdate;
                       GridSort(GridLists, 1, 2);
                     end;
       txttemplate : begin
                       SortMyListClear;
                       SortMyList[0].Name:='Плей-листы';
                       SortMyList[0].Field:='Template';
                       SortMyList[0].TypeData:=tstext;
                       //SortMyList[1].Name:='Дата регистрации';
                       //SortMyList[1].Field:='ImportDate';
                       //SortMyList[1].TypeData:=tsdate;
                       //SortMyList[2].Name:='Дата окончания';
                       //SortMyList[2].Field:='EndDate';
                       //SortMyList[2].TypeData:=tsdate;
                       GridSort(GridLists, 1, 1);
                     end;
             end;
       GridLists.Repaint;

     end;
    end; //case
    //DrawPanelButtons(imgButtonsControlProj.Canvas, IMGPanelProjectControl,-1);
    //GridTimelines.Repaint;
end;

procedure TForm1.GridTimeLinesDblClick(Sender: TObject);
begin
  EditTimeline(GridTimeLines.Selection.Top);
  GridTimeLines.Repaint;
end;

procedure TForm1.pnMovieResize(Sender: TObject);
begin
//Warning  pnMovie.Width:=(pnMovie.Height div 9) * 16;
//Warning  if mode=play then begin
//Warning    pVideoWindow.SetWindowPosition(0,0,pnMovie.ClientRect.Right,pnMovie.ClientRect.Bottom);
//Warning  end;
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
var i, res, ps : integer;
begin
  res := btnspanel1.ClickButton(imgCTLPrepare1.Canvas,X,Y);
       case res of
  0    : begin
            //AddPlayList;
         end;
  1    : begin
            res:=res;
         end;
  8    : begin
           for i:=TLZone.TLEditor.Count-1 downto 0
             do if TLZone.TLEditor.Events[i].Select then TLZone.TLEditor.DeleteEvent(i);
             ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
             TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
             TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas);
             TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps);
             TLZone.DrawTimelines(imgTimelines.Canvas,bmpTimeline);
         end;
  2..7,9..15 : begin
            res:=res;
          end;
       end;

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

       ZoneNames.ClickTTLNames(imgTLNames.Canvas, Form1.GridTimeLines, X, Y);
       case res.ID of
-1 :    begin
          s:=inttostr(res.ID);
        end;
0..1  : begin
          s:=inttostr(res.ID);
        end;
2..15 : begin
          s:=inttostr(res.ID);
         end;
       end;//case

       ZoneNames.Draw(imgTLNames.Canvas,Form1.GridTimeLines,false);
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
          case res of
  0: begin
       SetMainGridPanel(clips);
     end;
  1: begin
      //===================
       if CountGridMarkedRows(GridActPlayList, 1, 1)<>0 then begin
         if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные клипы из плей листа?',2) then exit;
         For i:=GridActPlayList.RowCount-1 downto 1 do begin
           if (GridActPlayList.Objects[0,i] as TGridRows).MyCells[1].Mark
             then MyGridDeleteRow(GridActPlayList, i, RowGridClips);
         end;
      //===================
       end else begin
          if MyTextMessage('Вопрос', 'Вы действительно хотите удалить выбранный клип?',2)
            then MyGridDeleteRow(GridActPlayList, GridActPlayList.Row, RowGridClips);
       end;
       if trim(lbPLName.Caption)<>'' then SaveGridToFile(PathPlayLists + '\' + lbPLName.Caption, GridActPlayList);
     end;
  2: if (GridActPlayList.Row < GridActPlayList.RowCount-1) and (GridActPlayList.Row > 0) then begin
       TempGridRow.Clear;
       TempGridRow.Assign((GridActPlayList.Objects[0,GridActPlayList.Row+1] as TGridRows));
       (GridActPlayList.Objects[0,GridActPlayList.Row+1] as TGridRows).Assign((GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows));
       (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).Assign(TempGridRow);
       GridActPlayList.Row := GridActPlayList.Row + 1;
       GridActPlayList.Repaint;
     end;
  3: if (GridActPlayList.Row <= GridActPlayList.RowCount-1) and (GridActPlayList.Row > 1) then begin
       TempGridRow.Clear;
       TempGridRow.Assign((GridActPlayList.Objects[0,GridActPlayList.Row-1] as TGridRows));
       (GridActPlayList.Objects[0,GridActPlayList.Row-1] as TGridRows).Assign((GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows));
       (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).Assign(TempGridRow);
       GridActPlayList.Row := GridActPlayList.Row - 1;
       GridActPlayList.Repaint;
     end;
  4: PlayClipFromActPlaylist;
          end;//case
  GridActPlayList.Repaint;
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
begin
  res:=pnlbtnsclips.ClickButton(imgpnlbtnsclips.canvas,x,y);
  pnlbtnsclips.Enable:=false;
       case res of
  0: begin
       EditClip(-1);
       SaveGridToFile(PathTemp + '\Clips.lst', Form1.GridClips);
     end;
  1: begin
       //+++++++++++++++++++++++++
       if CountGridMarkedRows(GridClips, 1, 1)<>0 then begin
         if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные клипы?',2) then exit;
         For i:=GridClips.RowCount-1 downto 1 do begin
           if (GridClips.Objects[0,i] as TGridRows).MyCells[1].Mark then begin
             nm := (GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
             if trim(nm)=trim(form1.lbActiveClipID.Caption) then begin
               Form1.Label2.Caption:='';
               Form1.lbActiveClipID.Caption:='';
               TLZone.ClearZone;
             end;
             nm := PathClips + '\' + nm + '.clip';
             if FileExists(nm) then DeleteFile(nm);
             MyGridDeleteRow(GridClips, i, RowGridClips);
           end;
         end;
       end else begin
         if MyTextMessage('Вопрос', 'Вы действительно хотите удалить выбранный клип?',2) then begin
           nm := (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID');
           if trim(nm)=trim(form1.lbActiveClipID.Caption) then begin
             Form1.Label2.Caption:='';
             Form1.lbActiveClipID.Caption:='';
             TLZone.ClearZone;
           end;
           nm := PathClips + '\' + nm + '.clip';
           if FileExists(nm) then DeleteFile(nm);
           MyGridDeleteRow(GridClips, GridClips.Row, RowGridClips);
         end;
       end;
       //+++++++++++++++++++++++++
       SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
       if trim(lbPLName.Caption)<>'' then begin
         CheckedActivePlayList;
         //SaveGridToFile(PathPlayLists + '\' + trim(lbPLName.Caption),GridActPlayList);
       end;
     end;
  2: PlayClipFromClipsList;
  3: begin
       SortMyListClear;
       SortMyList[0].Name:='Название клипов';
       SortMyList[0].Field:='Clip';
       SortMyList[0].TypeData:=tstext;
       SortMyList[1].Name:='Название песен';
       SortMyList[1].Field:='Song';
       SortMyList[1].TypeData:=tstext;
       SortMyList[2].Name:='Исполнители';
       SortMyList[2].Field:='Singer';
       SortMyList[2].TypeData:=tstext;
       SortMyList[3].Name:='Дата регистрации';
       SortMyList[3].Field:='ImportData';
       SortMyList[3].TypeData:=tsdate;
       SortMyList[4].Name:='Дата окончания';
       SortMyList[4].Field:='EndData';
       SortMyList[4].TypeData:=tsdate;
       GridSort(GridClips, 1, 3);
     end;
  4: begin
       LoadClipsToPlayList;
       SetMainGridPanel(actplaylist);
       if trim(lbPLName.Caption)<>'' then SaveGridToFile(PathPlayLists + '\' + lbPLName.Caption, GridActPlayList);
     end;
       end; //case
  pnlbtnsclips.Enable:=true;
  GridClips.Repaint;
end;

procedure TForm1.imgDeviceTLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnsdevicepr.MouseMove(imgDeviceTL.Canvas,X,Y);
end;

procedure TForm1.imgDeviceTLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res, ps : integer;
begin
  if Button<>mbLeft then exit;
  if trim(Label2.Caption)='' then exit;
  res := btnsdevicepr.ClickButton(imgDeviceTL.Canvas,X,Y);
  if res=-1 then exit;
  InsertEventToEditTimeline(res);
end;

procedure TForm1.imgTLNamesMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin

  ZoneNames.MoveMouse(imgTLNames.Canvas,Form1.GridTimeLines, X, Y);
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
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
      
    end else begin
      if ZoneNames.Scaler.plusHSelect then begin
        TLHeights.StepPlus;
        ZoneNames.Draw(imgTLnames.Canvas,Form1.GridTimeLines,false);
      end;
      if ZoneNames.Scaler.minusHSelect then begin
        TLHeights.StepMinus;
        ZoneNames.Draw(imgTLnames.Canvas,Form1.GridTimeLines,false);
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
end;

procedure TForm1.imgMediaTLMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnsmediatl.MouseMove(imgMediaTL.Canvas, X, Y);
end;

procedure TForm1.imgMediaTLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res : integer;
begin
  if trim(Label2.Caption)='' then exit;
  res := btnsmediatl.ClickButton(imgMediaTL.Canvas, X, Y);
       case res of
  0 : if trim(lbPlayerFile.Caption)<>'' then LoadFileToPlayer(lbPlayerFile.Caption);
  1 : begin end;
  2 : InsertEventToEditTimeline(-1);//TLEditor.AddEvent(TLParameters.Position, -1,-1);
  3 : begin end;
  4 : begin
        TLParameters.NTK:=TLParameters.Position - TLParameters.Preroll;
        TLParameters.UpdateParameters;
        TLParameters.Start:=TLParameters.ZeroPoint;
      end;
  5 : TLParameters.Finish:=TLParameters.Position;
       end;
  //TLZone.DrawBitmap(bmptimeline);
  TLZone.TLEditor.DrawEditor(bmptimeline.Canvas);
  TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
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
    btnsctlleft.Rows[0].Btns[5].LoadBMPFromRes(imdel);
  end else begin
    for i:=0 to 3 do btnsctlleft.Rows[0].Btns[i].Visible:=true;
    btnsctlleft.Rows[0].Btns[5].LoadBMPFromRes(imaddsong);
  end;
  btnsctlleft.Draw(Form1.imgCTLBottomL.Canvas);
end;

procedure TForm1.imgCTLBottomLMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var res :integer;
begin
  res := btnsctlleft.ClickButton(imgCTLBottomL.Canvas, X, Y);
     case res of
  0 : begin

        //AddPlayList;
        TLParameters.Position:=TLParameters.ZeroPoint;
        //TLZone.StopPosition:=TLZone.Position;
        MediaSetPosition(TLParameters.Position, false);
        TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
        //MediaPause;
        player.Pause;
      end;
  1 : begin
        res:=res;
      end;
  2 : begin
        res:=res;
      end;
  3 : begin
        res:=res;
      end;
  5 : begin
        if trim(Form1.lbPlayerFile.Caption)='' then exit;
        ControlPlayer;
        //if mode=paused then MediaPlay else MediaPause;
        //SetMediaButtons;
      end;
     end; //case
  // TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
end;

procedure TForm1.imgCtlBottomRMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var res :integer;
begin
  res := btnsctlright.ClickButton(imgCTLBottomR.Canvas, X, Y);
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
var i, lft, rgt, cl, cnt : integer;
begin
  i := GridColX(GridClips,X);
  if GridClips.Objects[0,GridClips.Row] is TGridRows then begin
    if i=3 then begin
//=========================================
      if (RowDownGridClips<>GridClips.Row) and (RowDownGridClips>0) and (GridClips.Row>0) then begin
        TempGridRow.Clear;
        TempGridRow.Assign((GridClips.Objects[0,RowDownGridClips] as TGridRows));
        if GridClips.Row < RowDownGridClips then begin
          for cnt:=RowDownGridClips downto GridClips.Row+1 do begin
            (GridClips.Objects[0,cnt] as TGridRows).Assign((GridClips.Objects[0,cnt-1] as TGridRows));
          end;
        end else begin
          for cnt:=RowDownGridClips to GridClips.Row-1 do begin
            (GridClips.Objects[0,cnt] as TGridRows).Assign((GridClips.Objects[0,cnt+1] as TGridRows));
          end;
        end;
        (GridClips.Objects[0,GridClips.Row] as TGridRows).Assign(TempGridRow);
        GridClips.Repaint;
      end;
      RowDownGridClips:=-1;
      GridClipsToPanel(GridClips.Row);
//=========================================
      if DblClickClips then begin
          if GridClips.Row > 0 then begin
            if (GridClips.Objects[0,GridClips.Row] is TGridRows) then begin
              if (GridClips.Objects[0,GridClips.Row] as TGridRows).ID=0
                then EditClip(-1)
                else EditClip(GridClips.Row);
              SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
           end;
         end;
       end;
      DblClickClips:=false;
      exit;
    end;
    if (GridClips.Objects[0,GridClips.Row] as TGridRows).ID<=0 then exit;
      case i of
  0,1: (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[i].Mark:=not (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[i].Mark;
    2: PlayClipFromClipsList;
      end; //case
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
  LoadPredClipToPlayer;
end;

procedure TForm1.sbNextClipClick(Sender: TObject);
begin
  LoadNextClipToPlayer;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var db1, db2 : double;
begin
  db1 := player.Time;
  db2 := player.Duration;
//Warning  pMediaPosition.get_CurrentPosition(db1);
//Warning  pMediaPosition.get_Duration(db2);
  if db1=db2 then begin
    MediaStop;
    SetMediaButtons;
    Timer1.Enabled:=false;
  end;
end;

procedure TForm1.imgLayer2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  TLZone.MoveMouseTimeline(imgLayer2.Canvas, Shift, X, Y);
end;

procedure TForm1.imgLayer2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  TLZone.DownZoneTimeLines(imgLayer2.Canvas, Button, Shift, X, Y);
end;

procedure TForm1.imgLayer2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
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
  if secondarygrid<>playlists then exit;
  ps:=findgridselection(GridLists,2);
  if ps<>-1 then begin
    (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark
      := Not (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark;
    SetPlaylistBlocking(ps);
    GridLists.Repaint;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //if mode=play then MediaStop;
  Player.Stop;

  if trim(lbActiveClipID.Caption)<>'' then SaveClipEditingToFile(trim(lbActiveClipID.Caption));
  SaveGridToFile(AppPath + DirProjects + '\' + 'ListProjects.prjt', GridProjects);
  saveoldproject;
  DeleteFilesMask(PathTemp, '*.*');
  Player.Release;
end;

procedure TForm1.GridActPlayListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, lft, rgt, cl, cnt : integer;
begin
  i := GridColX(GridClips,X);
  if GridActPlayList.Objects[0,GridActPlayList.Row] is TGridRows then begin
    if (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).ID<=0 then exit;
      case i of
    1: (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[i].Mark:=not (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[i].Mark;
    2: PlayClipFromActPlaylist;
    3: begin
         if (RowDownGridActPlayList<>GridActPlayList.Row) and (RowDownGridActPlayList>0) and (GridActPlayList.Row>0) then begin
           TempGridRow.Clear;
           TempGridRow.Assign((GridActPlayList.Objects[0,RowDownGridActPlayList] as TGridRows));
           if GridActPlayList.Row < RowDownGridActPlayList then begin
             for cnt:=RowDownGridActPlayList downto GridActPlayList.Row+1 do begin
               (GridActPlayList.Objects[0,cnt] as TGridRows).Assign((GridActPlayList.Objects[0,cnt-1] as TGridRows));
             end;
           end else begin
             for cnt:=RowDownGridActPlayList to GridActPlayList.Row-1 do begin
               (GridActPlayList.Objects[0,cnt] as TGridRows).Assign((GridActPlayList.Objects[0,cnt+1] as TGridRows));
             end;
           end;
           (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).Assign(TempGridRow);
           GridActPlayList.Repaint;
         end;
         RowDownGridActPlayList:=-1;
       end;
      end;
  end;
end; 

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if PanelPrepare.Visible then begin

    if ActiveControl=RichEdit1 then exit;
    If Key=32 then begin
      try
//Warning        pMediaPosition.get_Rate(Rate);
        ControlPlayer;
      except
        MyTextMessage('','В плейер не загружен клип для воспроизведения.',1);
      end;
      exit;
    end;
    If (ssCtrl In Shift) And (Key in [49..57]) then begin
      InsertEventToEditTimeline(Key - 39);
      exit;
    end;
    If (ssCtrl In Shift) And (Key=48) then begin
      InsertEventToEditTimeline(19);
      exit;
    end;
    If (ssShift In Shift) And (Key in [49..57]) then begin
      InsertEventToEditTimeline(Key - 29);
      exit;
    end;
    If (ssShift In Shift) And (Key=48) then begin
      InsertEventToEditTimeline(29);
      exit;
    end;
    If (ssAlt In Shift) And (Key=49) then begin
      InsertEventToEditTimeline(30);
      exit;
    end;
    If (ssAlt In Shift) And (Key=50) then begin
      InsertEventToEditTimeline(31);
      exit;
    end;
    If Key in [49..57] then begin
      InsertEventToEditTimeline(Key - 49);
      exit;
    end;
    If Key=48 then begin
      InsertEventToEditTimeline(9);
      exit;
    end;
  end;



//If ((ssCtrl In Shift) And (Key=Ord('t'))) Then //Ctrl+t
//If ((ssAlt In Shift) And (Key=Ord('t'))) Then //Alt+t
//If ((ssShift In Shift) And (Key=Ord('t'))) Then //Shift+t
//If ((ssShift In Shift) And (ssCtrl In Shift) And (Key=Ord('t'))) Then //Ctrl+Shift+t
end;

procedure TForm1.imgTextTLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res : integer;
begin
  if trim(Label2.Caption)='' then exit;
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
       TLZone.TLEditor.DrawEditor(bmptimeline.Canvas);
       form1.imgLayer0.repaint;
       //if mode<>play then TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
       TLZone.DrawBitmap(bmptimeline);
       //TLZone.TLEditor.DrawEditor(bmptimeline.Canvas);
       //bmptimeline.Canvas.Refresh;
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
  end else begin
    GridGRTemplate.Visible:=false;
    Panel16.Visible:=false;
    CheckBox2.Visible:=false;
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
var i, j, rw, ps : integer;
    bl : boolean;
    txt, flnm : string;
begin
  if (TLzone.TLEditor.TypeTL=tltext) or (TLzone.TLEditor.TypeTL=tlmedia) then exit;
  //rw := RowGridGrTemplateSelect;
  rw := GridClickRow(GridGRTemplate,Y);

  if rw=-1 then exit;
  if GridGRTemplate.Objects[0,rw] is TGridRows then begin
    with (GridGRTemplate.Objects[0,rw] as TGridRows) do begin
      for j := 0 to GridGRTemplate.RowCount-1
        do (GridGRTemplate.Objects[0,j] as TGridRows).MyCells[0].Mark:=false;
      MyCells[0].Mark:=true;
      MyCells[0].ColorTrue:=clRed;
      txt := MyCells[Count-1].ReadPhrase('Template');
      flnm := MyCells[Count-1].ReadPhrase('File');
    end;
    bl:=false;
    for i:=0 to TLzone.TLEditor.Count-1 do begin
      if TLzone.TLEditor.Events[i].Select then begin
        if not CheckBox2.Checked then TLzone.TLEditor.Events[i].SetPhraseText('Text',txt);
        TLzone.TLEditor.Events[i].SetPhraseCommand('Text',flnm);
        bl:=true;
      end;
    end;
    if not bl then begin
      for i:=0 to TLzone.TLEditor.Count-1 do begin
        if (TLzone.TLEditor.Events[i].Start<=TLParameters.Position) and (TLzone.TLEditor.Events[i].Finish>TLParameters.Position)
        then begin
          if not CheckBox2.Checked then TLzone.TLEditor.Events[i].SetPhraseText('Text',txt);
          TLzone.TLEditor.Events[i].SetPhraseCommand('Text',flnm);
          break;
        end;
      end;
    end;
  end;
  ps:=TLzone.FindTimeline(TLzone.TLEditor.IDTimeline);
  TLzone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
  TLzone.TLEditor.DrawEditor(bmptimeline.Canvas);
  TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps);
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

end.



