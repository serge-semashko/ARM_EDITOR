unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer,  MMSystem;

Const

WM_DRAWTimeline = WM_APP + 9876;

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


  private
    { Private declarations }
    // Обработчик сообщения WM_HOTKEY
    procedure WMHotKey(var Mess:TWMHotKey);message WM_HOTKEY;
    Procedure WMKeyDown(Var Msg:TWMKeyDown); Message WM_KeyDown;
    procedure WMDRAWTimeline(var msg:TMessage); Message WM_DRAWTimeline;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  MyTimer : THRTimer;
  MyThread : TMyThread;
  PredDt, CurrDt : Double;

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
     USubtitrs;

{$R *.dfm}
{$R bmpres1.res}

//==============================================================================
//====         Процедуры работы с точным таймером         ======================
//==============================================================================

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
        if TLParameters.Position<TLParameters.Preroll then pMediaControl.Pause else pMediaControl.Run;
        pMediaPosition.get_CurrentPosition(dps);
        if pStart >= dps then exit;
      end;

      curpos:=TLParameters.Position - TLParameters.ZeroPoint;
      Form1.lbCTLTimeCode.Caption:=FramesToStr(curpos);
      MyPanelAir.SetValues;
      MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, curpos);
      //SendMessage(Form1.Handle,WM_DRAWTimeline,curpos,0);
      application.ProcessMessages;
      //if bmptimeline.Canvas.LockCount =0 then TLZone.DrawBitmap(bmptimeline);
      //if Form1.imgtimelines.Canvas.LockCount<>0 then exit;
      TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
      if Form1.PanelAir.Visible then MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);

      pMediaPosition.get_CurrentPosition(db1);
      pMediaPosition.get_Duration(db2);
      db3:=FramesToDouble(TLParameters.Finish - TLParameters.Preroll);
      if db1<db2 then db0:=db1 else db0:=FramesToDouble(TLParameters.Position - TLParameters.Preroll);
      if db0>=db3 then begin
        MediaStop;
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
  pMediaPosition.get_CurrentPosition(pStart);
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
  CreateDirectories;

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
  CoInitialize(nil);// инициализировать OLE
  bmpTimeline := TBitmap.Create;
  bmpEvents := TBitmap.Create;
  MyTimer:=THRTimer.Create;
  MyThread:=TMyThread.Create(False);
  MyThread.Priority:=tpTimeCritical;//tpHighest;
  LoadGridFromFile(AppPath + DirProjects + '\' + 'ListProjects.ptjl', GridProjects);
  loadoldproject;
//  ps := findgridselection(gridprojects, 2);
//  ProjectToPanel(ps);
//  if ps > 0 then nm:=(gridprojects.Objects[0,ps] as tgridrows).MyCells[3].ReadPhrase('Note');
//  if trim(nm)<>'' then LoadProjectFromDisk(nm);
//  SetSecondaryGrid(playlists);
//  LoadGridFromFile(AppPath + DirProjects + '\' + TempPlayLists, GridLists);
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
var i, lft, rgt, cl, ps : integer;
begin
  i := GridColX(GridProjects,X);
  if GridProjects.Objects[0,GridProjects.Row] is TGridRows then begin
    if i=3 then begin
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
  GridDrawMyCell(GridLists, ACol, ARow, Rect)
end;

procedure TForm1.GridListsDblClick(Sender: TObject);
begin
  DblClickLists:=true;
end;

procedure TForm1.GridListsMouseUpPlaylists(X, Y: Integer);
var i, lft, rgt, cl : integer;
begin
  i := GridColX(GridLists,X);
  if GridLists.Objects[0,GridLists.Row] is TGridRows then begin
    if i=3 then begin
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
         LoadGridFromFile(AppPath + DirPlayLists + '\' + Form1.lbPLName.Caption, form1.GridActPlayList);
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
var i, lft, rgt, cl : integer;
begin
  i := GridColX(GridLists,X);
  if GridLists.Objects[0,GridLists.Row] is TGridRows then begin
    if i=1 then begin
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
var i, lft, rgt, cl : integer;
begin
  i := GridColX(GridLists,X);
  if GridLists.Objects[0,GridLists.Row] is TGridRows then begin
    if i=2 then begin
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
                  SaveGridToFile(AppPath + DirProjects + '\' + TempPlayLists, GridLists);
                end;
  grtemplate  : begin
                 GridListsMouseUpGrTemplates(X, Y);
                 SaveGridToFile(AppPath + DirProjects + '\' + TempGRTemplates, GridLists);
                end;
  txttemplate : begin
                 GridListsMouseUpTextTemplates(X, Y);
                 SaveGridToFile(AppPath + DirProjects + '\' + TempTextTemplates, GridLists);
                end;
       end; //case
end;

procedure TForm1.imgButtonsProjectMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, ps : integer;
    s : string;
begin

  if Button<>mbLeft then exit;
  i:=pnlprojects.ClickButton(imgButtonsProject.Canvas,x,y);
       case i of
  0: CreateProject(-1);
  1: begin
       ps := findgridselection(Form1.gridprojects, 2);
       if ps=Form1.gridprojects.Row then begin
         if MyTextMessage('Вопрос','Вы действительно хотите удалить текущий проект?',2) then begin
           MyGridDeleteRow(GridProjects, GridProjects.Row, RowGridProject);
           initnewproject;
         end;
       end else begin
         if MyTextMessage('Вопрос','Вы действительно хотите удалить проект?',2) then begin
           MyGridDeleteRow(GridProjects, GridProjects.Row, RowGridProject);
         end;
       end;
     end;
  2: begin
       if GridProjects.ColCount=2 then exit;
       s:=s;
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
    res, ps : integer;
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
                       SaveGridToFile(AppPath + DirProjects + '\' + TempPlayLists, GridLists);
                     end;
       grtemplate  : begin
                       EditImageTamplate(-1);
                       SaveGridToFile(AppPath + DirProjects + '\' + TempGrTemplates, GridLists);
                       GridImageReload(GridLists);
                     end;
       txttemplate : begin
                       TextTemplate(-1,false,'');
                       SaveGridToFile(AppPath + DirProjects + '\' + TempTextTemplates, GridLists);
                     end;
             end;
       GridLists.Repaint;
     end;
 3 : begin
             case SecondaryGrid of
       playlists   : begin
                       ps := findgridselection(gridlists, 2);
                       if ps=GridLists.Row then begin
                         if MyTextMessage('Вопрос', 'Вы действительно хотите удалить активный плей-лист?',2) then begin
                           MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                           SaveGridToFile(AppPath + DirProjects + '\' + TempPlayLists, GridLists);
                           lbPlaylist.Caption:='';
                           lbPLComment.Caption:='';
                           lbPLCreate.Caption:='';
                           lbPLEnd.Caption:='';
                         end;
                       end else begin
                         if MyTextMessage('Вопрос', 'Вы действительно хотите удалить плей-лист?',2) then begin
                           MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                           SaveGridToFile(AppPath + DirProjects + '\' + TempPlayLists, GridLists);
                         end;
                       end;
                     end;
       grtemplate  : begin
                       if MyTextMessage('Вопрос', 'Вы действительно хотите удалить графический шаблон?',2) then begin
                         MyGridDeleteRow(GridLists, GridLists.Row, RowGridListGR);
                         SaveGridToFile(AppPath + DirProjects + '\' + TempGRTemplates, GridLists);
                       end;
                     end;
       txttemplate : begin
                       if MyTextMessage('Вопрос', 'Вы действительно хотите удалить текстовый шаблон?',2) then begin
                         MyGridDeleteRow(GridLists, GridLists.Row, RowGridListTxt);
                         SaveGridToFile(AppPath + DirProjects + '\' + TempTextTemplates, GridLists);
                       end;
                     end;
             end;
       GridLists.Repaint;
     end;
 4 : begin
       SaveGridToFile(AppPath + DirProjects + '\' + 'ListProjects.ptjl', GridProjects);
       saveoldproject;
       //ps := findgridselection(gridprojects, 2);
       //if ps > 0 then nm:=(gridprojects.Objects[0,ps] as tgridrows).MyCells[3].ReadPhrase('Note');
       //if trim(nm)<>'' then SaveProjectToDisk(nm);
     end;
 5 : begin
       s:=s;
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
var res : integer;
begin
  res := pnlbtnspl.ClickButton(imgpnlbtnspl.Canvas,x,y);
      case res of
  0: begin
       res:=res;
     end;
  1: begin
       MyGridDeleteRow(GridActPlayList, GridActPlayList.Row, RowGridClips);
       if trim(lbPLName.Caption)<>'' then SaveGridToFile(AppPath + DirPlayLists + '\' + lbPLName.Caption, GridActPlayList);
     end;
  2: begin
       res:=res;
     end;
  3: begin
       res:=res;
     end;
  4: begin
       PlayClipFromActPlaylist;
       //GridPlayer:=grPlayList;
       //GridPlayerRow:=GridActPlayList.Row;
       //LoadClipsToPlayer;
     end;
      end;
  GridActPlayList.Repaint;
end;

procedure TForm1.imgpnlbtnsclipsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlbtnsclips.MouseMove(imgpnlbtnsclips.canvas,x,y);
end;

procedure TForm1.imgpnlbtnsclipsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var res : integer;
begin
  res:=pnlbtnsclips.ClickButton(imgpnlbtnsclips.canvas,x,y);
  pnlbtnsclips.Enable:=false;
       case res of
  0: begin
       EditClip(-1);
       SaveGridToFile(AppPath + DirProjects + '\' + TempClipsLists, Form1.GridClips);
     end;
  1: begin
       MyGridDeleteRow(GridClips, GridClips.Row, RowGridClips);
       SaveGridToFile(AppPath + DirProjects + '\' + TempClipsLists, Form1.GridClips);
     end;
  2: PlayClipFromClipsList;   
  4: begin
       LoadClipsToPlayList;
       SetMainGridPanel(actplaylist);
       if trim(lbPLName.Caption)<>'' then SaveGridToFile(AppPath + DirPlayLists + '\' + lbPLName.Caption, GridActPlayList);
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
        MediaPause;
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
var i, lft, rgt, cl : integer;
begin
  i := GridColX(GridClips,X);
  if GridClips.Objects[0,GridClips.Row] is TGridRows then begin
    if i=3 then begin
      if DblClickClips then begin
          if GridClips.Row > 0 then begin
            if (GridClips.Objects[0,GridClips.Row] is TGridRows) then begin
              if (GridClips.Objects[0,GridClips.Row] as TGridRows).ID=0
                then EditClip(-1)
                else EditClip(GridClips.Row);
              SaveGridToFile(AppPath + DirProjects + '\' + TempClipsLists, GridClips);
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
  pMediaPosition.get_CurrentPosition(db1);
  pMediaPosition.get_Duration(db2);
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
  if mode=play then MediaStop;
  SaveGridToFile(AppPath + DirProjects + '\' + 'ListProjects.ptjl', GridProjects);
  saveoldproject;
  DeleteFilesMask(AppPath + DirProjects, 'TMP*.*');
end;

procedure TForm1.GridActPlayListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, lft, rgt, cl : integer;
begin
  i := GridColX(GridClips,X);
  if GridActPlayList.Objects[0,GridActPlayList.Row] is TGridRows then begin
//    if i=3 then begin
//      if DblClickClips then begin
//          if GridClips.Row > 0 then begin
//            if (GridClips.Objects[0,GridClips.Row] is TGridRows) then begin
//              if (GridClips.Objects[0,GridClips.Row] as TGridRows).ID=0
//                then EditClip(-1)
//                else EditClip(GridClips.Row);
//              SaveGridToFile(AppPath + DirProjects + '\' + TempClipsLists, GridClips);
//           end;
//         end;
//       end;
//      DblClickClips:=false;
//      exit;
//    end;
    if (GridClips.Objects[0,GridClips.Row] as TGridRows).ID<=0 then exit;
      case i of
  0,1: (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[i].Mark:=not (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[i].Mark;
    2: PlayClipFromActPlaylist;
    3: begin end;
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
        pMediaPosition.get_Rate(Rate);
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
       TLZone.DrawBitmap(bmptimeline);
       TLZone.DrawTimelines(imgtimelines.Canvas,bmptimeline);
       imgtimelines.Repaint;
     end;
       end;
end;

procedure TForm1.imgTextTLMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  btnstexttl.MouseMove(imgTextTL.Canvas,X,Y);
end;

end.



