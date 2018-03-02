unit UMain;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
    DirectShow9, ActiveX, UPlayer, UHRTimer, MMSystem, OpenGL, UCommon, SYSTEM.JSON;

const
    WM_DRAWTimeline = WM_APP + 9876;
    WM_TRANSFER = WM_USER + 1;

type
    PCompartido = ^TCompartido;

    TCompartido = record
        Manejador1: Cardinal;
        Manejador2: Cardinal;
        Numero: Integer;
        Shift: Double;
        Cadena: string[20];
    end;

    TMyThread = class(TThread)
    private
     { Private declarations }
    protected
        procedure DoWork;
        procedure Execute; override;
    end;

    TForm1 = class(TForm)
        ApplicationEvents1: TApplicationEvents;
        OpenDialog1: TOpenDialog;
        Timer1: TTimer;
        OpenDialog2: TOpenDialog;
        Timer2: TTimer;
        SaveDialog1: TSaveDialog;
        SpeedButton1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        Label1: TLabel;
        SpeedButton3: TSpeedButton;
        Label2: TLabel;
        Label3: TLabel;
        Memo1: TMemo;
        Label4: TLabel;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure SpeedButton2Click(Sender: TObject);
        procedure SpeedButton3Click(Sender: TObject);
    private
    { Private declarations }
    //Compartido : PCompartido;
        FicheroM: THandle;
        procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
    // Обработчик сообщения WM_HOTKEY
        procedure WMHotKey(var Mess: TWMHotKey); message WM_HOTKEY;
    //Procedure WMKeyDown(Var Msg:TWMKeyDown); Message WM_KeyDown;
        procedure WMDRAWTimeline(var msg: TMessage); message WM_DRAWTimeline;
    //procedure WMEraseBackGround(var msg:TMessage); Message WM_EraseBkgnd;
        procedure WM_GETMINMAXINFO(var msg: TWMGETMINMAXINFO); message wm_GetMinMaxInfo;
        procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    public
    { Public declarations }
        Compartido: PCompartido;
    end;

var
    Form1: TForm1;
    MyTimer: THRTimer;
    MyThread: TMyThread;
    PredDt, CurrDt, pStart1: Double;
    OldTCPosition: longint = -1;
    OldTCTime: double = -1;
    mmResult: Integer;
    OldList1Index: integer = -10;
  //strgrrect : TGridRect;

//  procedure SetMediaButtons;

procedure StartMyTimer;

procedure StopMyTimer;

function ReadMyTimer: Double;

implementation

uses
    UTimeline, UDrawTimelines, UGRTimelines, umyevents, UMyFiles, uAirDraw,
    uwebget;


{$R *.dfm}
//{$R bmpres2.res}

procedure Tform1.Reciviendo(var Msg: TMessage);
begin
    try
  //label1.Caption:=compartido^.Cadena;
        MyShiftOld := MyShift;
        MyShift := compartido^.Shift;
        compartido^.Cadena := '';
        WriteLog('MAIN', 'Message:Reciviendo');
    except
        on E: Exception do
            WriteLog('MAIN', 'Message:Reciviendo | ' + E.Message);
    end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
    form1.Memo1.Clear;
    MyTimer.StartTimer;
    CurrDt := now;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
    MyTimer.StopTimer;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
var
    str1, str2: ansistring;
    url: ansistring;
    slist1: tstringlist;
    JS1: TJSONOBJECT;
    d1, d2: double;
    i1, i2, maxcnt: integer;
begin
    MyTLEdit.Clear;
    JS1 := TJSONOBJECT.Create;

    while JS1.Count < 10 do
        JS1.AddPair(IntToStr(JS1.count), 'aaa' + IntToStr(JS1.count));
    maxcnt := 10;
    url := 'http://localhost:9090/';
    str2 := JS1.ToString;
    d1 := now;
    for i1 := 0 to maxcnt do begin
        JS1 := TJSONOBJECT.Create;
        while JS1.Count < 4 do
           JS1.AddPair(IntToStr(JS1.count + i1 * 10), 'aaa' + IntToStr(JS1.count));
        if i1=2  then str2 := JS1.ToString;

        url := 'http://localhost:9090/SET_TLE[1]' + IntToStr(i1) + '=' + js1.ToString;
        str1 := GetJsonStrFromWeb(url);
    end;
    showmessage('put = ' + str1 + ' speed =' + format('%.0n time=%n', [length(url) * maxcnt * 1.0 / ((now - d1) * 3600 * 24), ((now - d1) * 3600 * 24.0 * 1000) / maxcnt]));
    url := 'http://localhost:9090/';
    str1 := PutJsonStrToWeb(url, 'GET_TLE(21:aaa1)');
    showmessage('get = ' + str1);
    if str1 <> str2 then
        showmessage('!!!!!!!!!!!!!diff')
    else
        showmessage('!OK');

end;

procedure TForm1.WM_GETMINMAXINFO(var msg: TWMGETMINMAXINFO);
begin
    try
        if mainwindowsize then
            exit;

        with msg.minmaxinfo^ do begin
            ptmaxposition.x := BorderWidth;
            ptmaxposition.y := BorderWidth;

            ptmaxsize.x := Screen.Width;
            ptmaxsize.y := Screen.Height;

            ptMinTrackSize.x := Screen.Width;
            ptMinTrackSize.y := Screen.Height;
            ptMaxTrackSize.x := Screen.Width;
            ptMaxTrackSize.y := Screen.Height;
        end;
//  if imgTypeMovie<>nil then imgTypeMovie.Repaint;
        WriteLog('MAIN', 'Message:WM_GETMINMAXINFO');
    except
        on E: Exception do
            WriteLog('MAIN', 'Message:WM_GETMINMAXINFO | ' + E.Message);
    end;
end;

procedure TForm1.WMSysCommand(var Msg: TWMSysCommand);
begin
    try
        if ((Msg.CmdType and $FFF0) = SC_MOVE) then begin
            if not mainwindowmove then begin
                Msg.Result := 0;
                Exit;
            end;
        end;
        WriteLog('MAIN', 'Message:WMSysCommand');
        inherited;
    except
        on E: Exception do
            WriteLog('MAIN', 'Message:WMSysCommand | ' + E.Message);
    end;
end;

//==============================================================================
//====         Процедуры работы с точным таймером         ======================
//==============================================================================

procedure TForm1.WMDRAWTimeline(var msg: TMessage);
begin
    try
        WriteLog('MAIN', 'Message:WMDRAWTimeline');
  //if msg.WParamLo <> 0
  //  then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', CurrentImageTemplate, 'Message:WMDRAWTimeline-1')
  //  else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '', 'Message:WMDRAWTimeline-2');
    //Form1.GridGRTemplate.Refresh;
  //MyPanelAir.SetValues;
//  MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, msg.WParam);
  //application.ProcessMessages;
     //if bmptimeline.Canvas.LockCount =0 then TLZone.DrawBitmap(bmptimeline);
      //if Form1.imgtimelines.Canvas.LockCount<>0 then exit;
  //TLZone.DrawBitmap(bmptimeline);
//  TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
//  if Form1.PanelAir.Visible then MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
    except
        on E: Exception do
            WriteLog('MAIN', 'Message:WMDRAWTimeline | ' + E.Message);
    end;
end;

//procedure TForm1.WMEraseBackGround(var msg:TMessage);
//begin
//  try
//    //if vlcmode=play then  InvalidateRect(form1.imgTimelines.Canvas.Handle, NIL, FALSE);
//    WriteLog('MAIN', 'Message:WMEraseBackGround');
//  except
//    on E: Exception do WriteLog('MAIN', 'Message:WMEraseBackGround | ' + E.Message);
//  end;
//end;

procedure TimeCallBack(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); stdcall;
begin
    try
    //FWait.Position:=FWait.Position+1;
    //FWait.Draw;
        WriteLog('MAIN', 'Main.TimeCallBack');
    except
        on E: Exception do
            WriteLog('MAIN', 'Main.TimeCallBack | ' + E.Message);
    end;
end;

procedure TMyThread.Execute;
begin
    try //MyThread.Priority:=tpTimeCritical;
   {Если Вы хотите, чтобы процедура DoWork выполнялась лишь один раз - удалите цикл while}
        while not Terminated do
            Synchronize(DoWork);
        WriteLog('MAIN', 'TMyThread.Execute');
    except
        on E: Exception do
            WriteLog('MAIN', 'TMyThread.Execute | ' + E.Message);
    end;
end;

procedure TMyThread.DoWork;
var
    curpos, delttm, mycpos1, mycpos2, myrate: longint;
    dbpr, dbcr, dps: double;
    db0, db1, db2, db3: Int64; //double;
    crpos: TEventReplay;
    CurrTemplate, txt: string;
    dtt, dt, dts, dte, dtc: double;
    fcr, ftm, fst, fen: longint;
    msd: double;
    CTC: string;
    dttm: tdatetime;
    msg: TMessage;
    curr, next, cmdc, sdur, sset, cmdcmd, sstart, evdur: string;
begin
    try
//   if {Form1.MySynhro.Checked and} (not MyTimer.Enable) then begin
     //SynchroLoadClip(Form1.GridActPlayList);
//     application.ProcessMessages;
//     dtc := now-TimeCodeDelta;
//     ftm := TimeToFrames(dtc);
//     fen := MyStartPlay + (TLParameters.Finish-TLParameters.Start);

//     if ftm >= fen then form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor,72);

//     if (MyStartPlay<>-1) and (ftm < MyStartPlay-125) {and MyStartReady} then form1.lbTypeTC.Font.Color := ProgrammFontColor;
//     if (MyStartPlay<>-1) and (ftm > MyStartPlay-125) and (ftm < MyStartPlay) {and MyStartReady} then begin
//       form1.lbTypeTC.Font.Color := clLime;
//       MyRemainTime := MyStartPlay - ftm;
//       TLParameters.Position := TLParameters.Start;
//       TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
//       if Form1.PanelAir.Visible then begin
//         MyPanelAir.AirEvents.Draw(Form1.ImgEvents.Canvas);
//         MyPanelAir.AirDevices.Draw(Form1.ImgDevices.Canvas);
//         MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, TLParameters.Position - TLParameters.ZeroPoint);
//       end else begin
//         if not form1.PanelPrepare.Visible then CurrentMode:=false;
//         //form1.lbModeClick(nil);
//       end;
//       application.ProcessMessages;
       //MediaSetPosition(TLParameters.Position, false, 'TMyThread.DoWork-1'); //1
//     end;
//     if (MyStartPlay<=ftm) and (vlcmode<>play) and (MyStartPlay<>-1) {and MyStartReady} then begin
//       form1.lbTypeTC.Font.Color := ProgrammFontColor;
//       MyRemainTime := -1;
//       MyShiftOld := MyShift;
       //MediaStop;
//       application.ProcessMessages;
//       if ftm < fen then begin
//         TLParameters.Position := TLParameters.Start + ftm-MyStartPlay;
         //MediaSetPosition(TLParameters.Position, false, 'TMyThread.DoWork-2'); //2
//         if not fileexists({Form1.lbPlayerFile.Caption}) then begin
//           Rate:=1;
//           pStart := FramesToDouble(TLParameters.Position);
//         end;
//         //MediaPlay;
//       end;
       //SetMediaButtons;
//     end;
//   end else begin
//     form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor,72);
//   end;
//   if {Form1.MySynhro.Checked and} MyTimer.Enable then begin
//     MyShiftDelta := MyShift - MyShiftOld;
//     if MyShiftDelta<0 then msd := -1*MyShiftDelta else msd := MyShiftDelta;

//     MyShiftOld := MyShift;

//     if (MyShiftDelta<>0) and MakeLogging then begin
//       if MySinhro=chltc then begin
//       end else begin
//       end;
//     end;
//     if (TimeToFrames(msd)>=SynchDelay) and (vlcmode=play) then begin
//        dtc := now-TimeCodeDelta;
//        ftm := TimeToFrames(dtc);
//        fen := MyStartPlay + (TLParameters.Finish-TLParameters.Start);
//        if ftm >= fen then form1.lbTypeTC.Font.Color := SmoothColor(ProgrammFontColor,72);
//        MyStartPlay := -1;
        //MediaStop;

//        if ftm < fen then begin
//          if ftm < MyStartPlay then begin
//            TLParameters.Position := TLParameters.Start;
//          end else begin
//            TLParameters.Position := TLParameters.Start + ftm-MyStartPlay;
//          end;

          //MediaSetPosition(TLParameters.Position, false, 'TMyThread.DoWork-3'); //3
//          TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
          //MediaPlay;
//        end;
//     end;
//   end;
// Включаем или выключаем отображение времени запуска
//   SetTypeTimeCode;

// Если запуск воспроизведения выполнен то отображаем движение тайм-линий.
        if MyTimer.Enable then begin
     //form1.Reciviendo(msg);
            Form1.label1.Caption := '';
     //Form1.label1.Repaint;
     //application.ProcessMessages;
            dbld1 := MyTimer.ReadTimer; //========
     //CurrDt:=MyTimer.ReadTimer - PredDt;
     //dttm:=now;
     //Form1.label1.Caption:=TimeToTimeCodeStr(dttm);//CurrDt);
     //Form1.label1.Repaint;
     //application.ProcessMessages;
            dttm := now;
            Form1.label1.Caption := MyDateTimeToStr(now - CurrDt - TimeCodeDelta); //TimeToTimeCodeStr(dttm);//CurrDt);

            if Form1.label1.Caption <> '' then
                TLParameters.Position := TLParameters.Preroll + StrTimeCodeToFrames(Form1.label1.Caption);
            Form1.label2.Caption := inttostr(TLParameters.Position - TLParameters.Preroll);
            crpos := MyTLEdit.CurrentEvents;
            if crpos.Number = -1 then
                exit;

            Form1.label3.Caption := inttostr(crpos.Number);
            curr := MyTLEdit.Events[crpos.Number].ReadPhraseText('Device');

            if crpos.Number >= MyTLEdit.Count - 1 then begin
                next := 'Стоп';
                cmdc := '';
                cmdcmd := '';
                sdur := '';
                sset := '';
                sstart := '';
            end
            else begin
                next := MyTLEdit.Events[crpos.Number + 1].ReadPhraseText('Device');
                cmdcmd := MyTLEdit.Events[crpos.Number + 1].ReadPhraseCommand('Command');
                cmdc := MyTLEdit.Events[crpos.Number + 1].ReadPhraseText('Command');
                sdur := inttostr(MyTLEdit.Events[crpos.Number + 1].ReadPhraseData('Duration'));
                sset := inttostr(MyTLEdit.Events[crpos.Number + 1].ReadPhraseData('Set'));
                sstart := FramesToStr(MyTLEdit.Events[crpos.Number + 1].Start - (TLParameters.Position));
            end;

            evdur := FramesToStr(MyTLEdit.Events[crpos.Number].Finish - MyTLEdit.Events[crpos.Number].Start);
            Form1.Label4.Caption := sstart;
            if OldList1Index <> crpos.Number then begin
                form1.memo1.Lines.Insert(0, inttostr(crpos.Number) + ')  Текущее - ' + curr + '  Следующее - ' + next + '  Переход - ' + cmdc + '  Dur=' + sdur + '  Set=' + sset + '  ' + cmdcmd + '  ' + evdur);

            end;
            OldList1Index := crpos.Number;
//     mycpos1:=TLParameters.Position;
//     if (not fileexists('iii'{Form1.lbPlayerFile.Caption)})) {or (vlcplayer.p_mi=nil)} then begin
//       TLParameters.Position:= MyDoubleToFrame(pStart +  MyTimer.ReadTimer * Rate);
//       PredDt:=CurrDt;
//       if vlcmode=paused then exit;
//     end else begin
////       db2:=vlcplayer.Duration;
////       if libvlc_media_player_get_state(vlcplayer.p_mi)<>libvlc_Ended
////         then db1:=vlcplayer.Time
////         else db1:=vlcplayer.Duration+1;
//       db3:=(TLParameters.Finish - TLParameters.Preroll)*40;
//       if MyDoubleToFrame(pStart1)*40 > db2 then begin
////         Rate := libvlc_media_player_get_rate(vlcplayer.p_mi);
//         db0:=MyDoubleToFrame(pStart1 + currDT * Rate) *40;
//       end else begin
//         if db1 < db2 then begin
//           db0:=db1;
//           PredDT:=MyTimer.ReadTimer;
//         end else begin
////           Rate:=libvlc_media_player_get_rate(vlcplayer.p_mi);
//           db0 :=db2 + MyDoubleToFrame((MyTimer.ReadTimer - PredDt) * Rate)*40;//SpeedMultiple;
//         end;
//       end;
//       if db0>db3 then db0:=db3;
////       Rate:=libvlc_media_player_get_rate(vlcplayer.p_mi);
//       mycpos2 := TLParameters.Preroll + (db0 div 40);
//       if vlcmode=play then begin
//         if mycpos2<mycpos1 then mycpos2:=mycpos1;
//         myrate := Round(Rate);
//         if myrate=0 then myrate:=1;
//
//         if mycpos2>mycpos1+myrate then mycpos2:=mycpos1+myrate;
//       end;
//       TLParameters.Position:=mycpos2;//TLParameters.Preroll + (db0 div 40);
//     end;

            crpos := TLZone.TLEditor.CurrentEvents;

//       curpos:=TLParameters.Position - TLParameters.ZeroPoint;
//       if (not Form1.compartido^.State) and (MySinhro=chltc)
//         then Form1.lbCTLTimeCode.Caption:='*' + MyDateTimeToStr(now-TimeCodeDelta)
//         else Form1.lbCTLTimeCode.Caption:='' + MyDateTimeToStr(now-TimeCodeDelta);

       //SetClipTimeParameters;

//       MyPanelAir.SetValues;
//       if not Form1.PanelAir.Visible then begin
//         if Trim(CurrentImageTemplate)<>trim(crpos.Image) then begin
//           TemplateToScreen(crpos);
//           CurrentImageTemplate:=trim(crpos.Image);
//           if crpos.Number <> -1
//             then PostMessage(Form1.Handle,WM_DRAWTimeline,1,1)
//             else PostMessage(Form1.Handle,WM_DRAWTimeline,0,0);
//         end;
//       end;

//       if crpos.SafeZone then begin
//         if vlcmode=play then TLZone.DrawFlash(crpos.Number);
//       end else begin
//         Form1.ImgLayer0.Canvas.FillRect(Form1.ImgLayer0.Canvas.ClipRect);
//       end;
//       if OldParamPosition <> TLParameters.Position
//         then TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
//       OldParamPosition := TLParameters.Position;
//       if Form1.PanelAir.Visible then begin
//         if MyDoubleToFrame(db0) mod 1 = 0 then begin
//           MyPanelAir.AirEvents.Draw(Form1.ImgEvents.Canvas);
//           MyPanelAir.AirDevices.Draw(Form1.ImgDevices.Canvas);
//         end;
//         MyPanelAir.AirEvents.DrawTimeCode(Form1.ImgEvents.Canvas, TLParameters.Position - TLParameters.ZeroPoint);
        end;

        application.ProcessMessages;

//     if not fileexists('iii'{Form1.lbPlayerFile.Caption}) then begin
//       if TLParameters.Position >= TLparameters.Finish then begin
//         TLParameters.Position := TLparameters.Finish;
//         //MediaPause;
//         //SetMediaButtons;
////         form1.lbTypeTC.Caption:='';
//         MyStartPlay := -1;
////         TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
//         exit;
//       end;
//     end else begin
//       if (db0 >= db3) or (db0 < 0) then begin
//         //MediaPause;
//         //SetMediaButtons;
////         form1.lbTypeTC.Caption:='';
//         MyStartPlay := -1;
////         TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
//       end;
//     end;
//   end;
    except
        on E: Exception do
            WriteLog('MAIN', 'TMyThread.DoWork | ' + E.Message);
    end;
end;

procedure StartMyTimer;
var
    dur: double;
begin
    try
        PredDt := 0;
//  if fileexists(Form1.lbPlayerFile.Caption) then begin
//    pStart:=vlcplayer.Time;
//    dur := vlcplayer.Duration div 40;
//  end else begin
//    pStart := FramesToDouble(TLParameters.Position);
//    dur := TLParameters.Duration;
//  end;
        pStart1 := 0;
  //if FramesToDouble(TLParameters.Position - TLParameters.Preroll) > dur
        if TLParameters.Position - TLParameters.Preroll > dur then
            pStart1 := FramesToDouble(TLParameters.Position - TLParameters.Preroll);
  //OlDTCPosition:=-1;

        MyTimer.StartTimer;
        PredDt := MyTimer.ReadTimer;
        if Makelogging then
            WriteLog('MAIN', 'UMain.StartMyTimer Duration=' + TimeToTimeCodeStr(dur) + ' Start=' + TimeToTimeCodeStr(pStart) + ' Start1=' + TimeToTimeCodeStr(pStart1));
    except
        on E: Exception do
            WriteLog('MAIN', 'UMain.StartMyTimer | ' + E.Message);
    end;
end;

procedure StopMyTimer;
begin
    MyTimer.StopTimer;
    if Makelogging then
        WriteLog('MAIN', 'UMain.StopMyTimer');
end;

function ReadMyTimer: Double;
begin
    result := MyTimer.ReadTimer;
end;

procedure TForm1.WMHotKey(var Mess: TWMHotKey);
var
    hk, uns, res: integer;
    s: string;
begin
    try
        WriteLog('MAIN', 'Message.WMHotKey');
        hk := Mess.HotKey;
        uns := Mess.Unused;
        res := Mess.Result;
        s := inttostr(res);
        inherited;
 //ShowMessage('Нажата горячая клавиша CTRL+F12');
    except
        on E: Exception do
            WriteLog('MAIN', 'Message.WMHotKey | ' + E.Message);
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    Step, i, ps: integer;
    ext, nm: string;
begin

    try
        WriteLog('MAIN', 'Form1.Create Start');
        WriteLog('MAIN', '');
        WriteLog('MAIN', '*****************************************************************************************');
        WriteLog('MAIN', '*************************               ЗАПУСК ПРОГРАММЫ             *************************');
        WriteLog('MAIN', '*************************            Время старта: ' + TimeToTimeCodeStr(now) + '             *************************');
        WriteLog('MAIN', '*****************************************************************************************');

//  CreateDirectories1;

//  bmpEvents := TBitmap.Create;
//  bmpAirDevices := TBitmap.Create;
//++++++++++++++++++++++++++++++++++++++++++
  { Посмотрим, существует ли файл }
        FicheroM := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, 'MiFichero');
  { Если нет, то ошибка }
        if FicheroM = 0 then
            FicheroM := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(TCompartido), 'MiFichero');
  // если создается файл, заполним его нулями
        if FicheroM = 0 then
            raise Exception.Create('Не удалось создать файл' + '/Ошибка при создании файла');
        Compartido := MapViewOfFile(FicheroM, FILE_MAP_WRITE, 0, 0, 0);
        compartido^.Manejador2 := Handle;
        compartido^.Cadena := 'request';

        MySinhro := chltc;

  //MyTLEdit.Create;
//++++++++++++++++++++++++++++++++++++++++++

  //ReadMyIniFile;
  //ReadEditedProjects;

//  if MainWindowStayOnTop then begin
//    Form1.FormStyle := fsStayOnTop;
//    Form1.WindowState := wsNormal;
//  end else begin
//    Form1.FormStyle := fsNormal;
//    Form1.WindowState := wsMaximized;
//  end;

 // if MenuListFiles=nil then MenuListFiles:=TMyMenu.create;
 // CreateMainMenu;
//  pnMainMenu.Visible:=false;
//  pnMainMenu.Left:=Form1.BorderWidth;
//  pnMainMenu.Top:=PanelControlBtns.Top + PanelControlBtns.Height;

 // TempMenu :=TMyMenu.Create;

 // DrawMenuBitmap(sbMainMenu);
 // ExecTaskOnDelete;
 // InputInSystem;
//  RegisterHotKey(Handle, Ord('1'),0, Ord('1'));
//  RegisterHotKey(Handle, 2001 ,MOD_ALT,vk_F12);
 // FWait := TFWaiting.Create(nil);

 // CreateInputPopUpMenu;

//  InitInputInSystem;
//  InitMyStartWindow;
//  InitMainForm;
//  InitPanelControl;
//  InitPanelClips(true);
//  InitPanelPlayList(true);
//  InitPanelProject(true);
//  InitPanelPrepare(true);
//  InitPanelAir;

////  self.imgTimelines.Parent.DoubleBuffered:=true;
//  self.imgLayer0.Parent.DoubleBuffered:=true;
////  self.imgLayer1.Parent.DoubleBuffered:=true;
//  self.imgLayer2.Parent.DoubleBuffered:=true;
//  self.imgTLNames.Parent.DoubleBuffered:=true;
//  form1.Repaint;
//  bmpTimeline := TBitmap.Create;
//  bmpTimeline.PixelFormat := pf32bit;

        MyTimer := THRTimer.Create;
        MyThread := TMyThread.Create(False);
        MyThread.Priority := tpTimeCritical; //tpHighest;

  //  then Label15.Caption:= 'Список плей-листов проекта (' + (GridProjects.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('Project') + ')'
  //  else Label15.Caption:= 'Список плей-листов проекта';
//  SecondaryGrid:=playlists;
//  InputPopUpMenu.Draw(Form1.Image4.Canvas);
//  btnstartpnl.Draw(ImgStartWinBtn.Canvas);
//  MenuListFiles.Draw(Form1.ImgListFiles.Canvas);
//  if inputwithoutusers then InputPanel.Visible:=false else InputPanel.Visible:=true;
//  if not InputPanel.Visible then MyStartWindow;

  //loadoldproject;
  //MyStartPlay:= -1;
  //MyStartReady := false;
//  Form1.MySynhro.Checked := false;
//  UpdatePanelAir;
        SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
        WriteLog('MAIN', 'Form1.Create Finish');
//  VLCPlayer:=TVlcPl.Create;
//  if vlcplayer.Init(pnMovie.Handle)<>'' then begin
//    MessageDlg(VLCPlayer.error, mtError, [mbOK], 0);
    //exit;
//  end;
  //VLCPlayer.Init(Form1.pnMovie.Handle);


    except
        on E: Exception do
            WriteLog('MAIN', 'Form1.Create | ' + E.Message);
    end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//  UnregisterHotKey(Handle, Ord('1'));
//  UnregisterHotKey(Handle, 2001);
//  CoUninitialize;// деинициализировать OLE
//  MyTLEdit.FreeInstance;
//  MyTLEdit := nil;

    bmpTimeline.Free;
    bmpEvents.Free;
    bmpAirDevices.Free;
//  GridTimelines.FreeOnRelease;

    UnmapViewOfFile(Compartido);
    CloseHandle(FicheroM);

end;

end.

