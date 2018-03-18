unit MainUnit;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, Buttons, ComCtrls, Variants, MMSystem, Menus, UHRTimer,
    Vcl.Samples.Spin, UCommon, UTimeline, UGRTimelines;

CONST
    WM_TRANSFER = WM_USER + 1; // ���������� ���������
    // WM_TRANSFER = WM_USER + 1;
    WM_MYICONNOTIFY = WM_USER + 777;

type
    PCompartido = ^TCompartido;

    TCompartido = record
        Manejador1: Cardinal;
        Manejador2: Cardinal;
        Numero: Integer;
        Shift: Double;
        Cadena: String[20];
    end;

    TMyThread = class(TThread)
    private
        { Private declarations }
        // FicheroM   : THandle;
        // procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
    protected
        procedure DoWork;
        procedure Execute; override;
    end;

    TfmMain = class(TForm)
        Panel1: TPanel;
        Panel2: TPanel;
        SpeedButton2: TSpeedButton;
        SpeedButton4: TSpeedButton;
        PopupMenu1: TPopupMenu;
        RestoreItem: TMenuItem;
        N1: TMenuItem;
        FileExitItem1: TMenuItem;
        N2: TMenuItem;
        HideItem: TMenuItem;
        Image1: TImage;
        SpeedButton8: TSpeedButton;
        GroupBox1: TGroupBox;
        ImgProtocol: TImage;
        GroupBox3: TGroupBox;
        GroupBox4: TGroupBox;
        imgWeb: TImage;
        ImgTrans: TImage;
        Timer1: TTimer;
        GroupBox2: TGroupBox;
        imgPort: TImage;
        Panel5: TPanel;
        Panel6: TPanel;
        SpeedButton1: TSpeedButton;
        procedure FormCreate(Sender: TObject);
        procedure SpeedButton2Click(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormHide(Sender: TObject);
        procedure RestoreItemClick(Sender: TObject);
        procedure FileExitItem1Click(Sender: TObject);
        procedure HideItemClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure SpeedButton8Click(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure N1Click(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    private
        { Private declarations }
        ShownOnce: Boolean;
        // Compartido : PCompartido;
        FicheroM: THandle;
        procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
        // procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
        procedure ComportDialogOpen;
    public
        { Public declarations }
        Compartido: PCompartido;
        procedure WMICON(var Msg: TMessage); message WM_MYICONNOTIFY;
        procedure WMSYSCOMMAND(var Msg: TMessage); message WM_SYSCOMMAND;
        procedure RestoreMainForm;
        procedure HideMainForm;
        procedure CreateTrayIcon(n: Integer);
        procedure DeleteTrayIcon(n: Integer);
        procedure UpdateTrayIcon(icon: ticon; name: string);
        procedure ComportInit;
    end;

var
    TLO_server: array [0 .. 16] of TTimelineOptions;
    TLO_server_changed: array [0 .. 16] of Boolean;
    TLO_server_old: array [0 .. 16] of string;

    TLT_server: array [0 .. 16] of TTlTimeline;
    TLT_server_changed: array [0 .. 16] of Boolean;
    TLT_server_old: array [0 .. 16] of string;
    fmMain: TfmMain;
    AppPath, AppName, AppExt: string;
    GridFile: string = '';
    CommandFile: string = '';
    CloseApplication: Boolean = false;
    MyThread: TMyThread;
    OldList1Index: longint = -1;
    MyTimer: THRTimer;
    PredDt, CurrDt, pStart1: Double;
    istrans: Boolean = false;
    isduration: Boolean = false;
    isendevent: Boolean = false;
    isstartevent: Boolean = false;
    tlp_str: string;
    old_tlp_str: string = '';
    old_tle_str: string = '';
    tlp_changed: Boolean = false;
    webrequest_time: Double = -1;
    tlp_webrequest_time: Double = -1;
    tl_to_request_time: Double = -1;
    tle_request_time: Double = -1;



procedure StartMyTimer;
procedure StopMyTimer;
Function ReadMyTimer: Double;
Procedure Update_TLEditor;

implementation

uses ComPortUnit, umychars, UMyWork, UMyInitFile, ShellApi, shlobj, registry,
    umain, UDrawTimelines, umyevents, uwebget,
    UPortOptions,
    umyinfo, umyprotocols;

{$R *.DFM}

Procedure DrawProtocolStatus;
begin
    UpdateInfoProtocol;
    UpdateInfo422;
    UpdateInfoIP;
    InfoProtocol.Draw(fmMain.ImgProtocol.Canvas, 25);
    fmMain.ImgProtocol.Repaint;
    if port422select then
        info422.Draw(fmMain.imgPort.Canvas, 25)
    else
        infoIP.Draw(fmMain.imgPort.Canvas, 25);
    fmMain.imgPort.Repaint;
end;

procedure StartMyTimer;
var
    dur: Double;
begin
    try
        PredDt := 0;
        pStart1 := 0;
        if TLParameters.Position - TLParameters.Preroll > dur then
            pStart1 := FramesToDouble(TLParameters.Position -
              TLParameters.Preroll);

        MyTimer.StartTimer;
        PredDt := MyTimer.ReadTimer;

    except
    end;
end;

procedure StopMyTimer;
begin
    MyTimer.StopTimer;
end;

Function ReadMyTimer: Double;
begin
    result := MyTimer.ReadTimer;
end;

procedure TfmMain.Reciviendo(var Msg: TMessage);
begin
    try
        // label1.Caption:=compartido^.Cadena;
        MyShiftOld := MyShift;
        MyShift := Compartido^.Shift;
        Compartido^.Cadena := '';
        // WriteLog('MAIN', 'Message:Reciviendo');
    except
        // on E: Exception do WriteLog('MAIN', 'Message:Reciviendo | ' + E.Message);
    end;
end;

procedure TMyThread.Execute;
begin
    try // MyThread.Priority:=tpTimeCritical;
        { ���� �� ������, ����� ��������� DoWork ����������� ���� ���� ��� - ������� ���� while }
        while not Terminated do
        begin
            sleep(1);
            Synchronize(DoWork);
        end;
        // WriteLog('MAIN', 'TMyThread.Execute');
    except
        // on E: Exception do WriteLog('MAIN', 'TMyThread.Execute | ' + E.Message);
    end;
end;

procedure TMyThread.DoWork;
var
    crpos: TEventReplay;
    txt, strchron: string;
    framestostart, data: longint;
    curr, crtr, crdr, crst, crcmd, Stri: string;
    next, cmdc, sdur, sset, cmdcmd, sstart, evdur: string;
    i, icmd: Integer;
    StartFrame, DurFrame, EndFrame, nStartFrame, nEndFrame, nDurFrame: longint;
    DT_tlpupdate: int64;
begin
    // WriteLog('vlcmode', 'TRY update TLP dt = '+IntToStr(DT_tlpupdate));
    try
        If MyTimer.Enable then
        begin
            // FmMain.label6.Caption:=MyDateTimeToStr(now-CurrDt-TimeCodeDelta);//TimeToTimeCodeStr(dttm);//CurrDt);
            application.ProcessMessages;
            InfoWEB.SetData(0, MyDateTimeToStr(now)); // '���� ��� �������:

            // '������� ����:'
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            // if InfoWEB.Options[0].Text<>'' then TLParameters.Position :=TLParameters.Preroll + StrTimeCodeToFrames(InfoWEB.Options[1].Text);
            Update_TLEditor;
            DT_tlpupdate := trunc((now - tlp_webrequest_time) * 24 *
              3600 * 1000);

            // WriteLog('vlcmode', 'check update TLP dt = '+IntToStr(DT_tlpupdate));
            if DT_tlpupdate > 20 then
            begin
                // WriteLog('vlcmode', 'begin update TLP dt = '+IntToStr(DT_tlpupdate));
                tlp_str := GetJsonStrFromServer('TLP');
                // WriteLog('vlcmode', ' answer= '+tlp_str);

                if Length(tlp_str) > 10 then
                begin
                    InfoProtocol.SetData('������:', '��������');
                    if tlp_str <> old_tlp_str then
                    begin
                        // WriteLog('vlcmode', 'update TLP dt = '+IntToStr(DT_tlpupdate));
                        TLP_server.LoadFromJSONstr(tlp_str);
                        local_vlcMode := TLP_server.vlcmode;
                        if TLP_server.vlcmode = play then
                            // showmessage('Play')
                              ;

                        old_tlp_str := tlp_str;
                        tlp_changed := true;
                    end
                    else
                    begin
                        // WriteLog('vlcmode', 'ERR update TLP not chenged');
                        tlp_changed := false;
                    end;

                    // caption := IntToStr(TLP_server.Position)+formatdatetime(' HH:NN:SS ZZZ',now);;
                    if InfoWEB.Options[0].Text <> '' then
                        TLParameters.Position := TLP_server.Position;
                    // InfoWEB.SetData(0, TLP_server.TLTimeCode);
                end
                else
                begin
                    InfoProtocol.SetData('������:', '�� ��������');
                    WriteLog('vlcmode', 'ERR update TLP answer :' + tlp_str);
                end;;
                tlp_webrequest_time := now;
                // WriteLog('vlcmode', IntToStr(local_vlcMode)+' position = '+IntToStr(TLParameters.Position));

            end
            else
            begin
                // WriteLog('vlcmode', 'NOT TLP update: dt low');
            end;;
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            InfoWEB.SetData(2, inttostr(TLParameters.Position));
            // if FmMain.label6.Caption<>'' then TLParameters.Position :=TLParameters.Preroll + StrTimeCodeToFrames(FmMain.label6.Caption);
            // FmMain.label12.Caption:=inttostr(TLParameters.Position-TLParameters.Preroll);
            crpos := MyTLEdit.CurrentEvents;
            if crpos.Number <> -1 then
            begin
                strchron := FramesToStr(MyTLEdit.Events[MyTLEdit.Count - 1]
                  .Finish - MyTLEdit.Events[0].Finish);
                // InfoWEB.SetData(1, MyDateTimeToStr(now - CurrDt - TimeCodeDelta)
                // + '  (' + strchron + ')'); // '���� ��� ���������.:'
                InfoWEB.SetData(1,
                  FramesToStr(TLP_server.Position - TLP_server.Start) + '  (' +
                  strchron + ')');
                // FmMain.label10.Caption:=inttostr(crpos.Number);
                curr := MyTLEdit.Events[crpos.Number].ReadPhraseText('Device');

                if crpos.Number >= MyTLEdit.Count - 1 then
                begin
                    next := '����';
                    cmdc := '';
                    cmdcmd := '';
                    sdur := '';
                    sset := '';
                    sstart := '';
                    curr := MyTLEdit.Events[MyTLEdit.Count - 1].ReadPhraseText
                      ('Device');
                    crtr := MyTLEdit.Events[MyTLEdit.Count - 1].ReadPhraseText
                      ('Command');
                    crdr := inttostr(MyTLEdit.Events[MyTLEdit.Count - 1]
                      .ReadPhraseData('Duration'));
                    crst := inttostr(MyTLEdit.Events[MyTLEdit.Count - 1]
                      .ReadPhraseData('Set'));
                    crcmd := MyTLEdit.Events[MyTLEdit.Count - 1]
                      .ReadPhraseCommand('Command');
                    TLParameters.Finish := MyTLEdit.Events[MyTLEdit.Count - 1]
                      .Finish; // ++++++++++++++++++++++++
                    framestostart := TLParameters.Finish -
                      TLParameters.Position;
                end
                else
                begin
                    curr := MyTLEdit.Events[crpos.Number].ReadPhraseText
                      ('Device');
                    data := MyTLEdit.Events[crpos.Number].ReadPhraseData
                      ('Device');
                    crtr := MyTLEdit.Events[crpos.Number].ReadPhraseText
                      ('Command');
                    crdr := inttostr(MyTLEdit.Events[crpos.Number]
                      .ReadPhraseData('Duration'));
                    crst := inttostr(MyTLEdit.Events[crpos.Number]
                      .ReadPhraseData('Set'));
                    crcmd := MyTLEdit.Events[crpos.Number].ReadPhraseCommand
                      ('Command');

                    framestostart := MyTLEdit.Events[crpos.Number + 1].Start -
                      (TLParameters.Position);
                    StartFrame := MyTLEdit.Events[crpos.Number].Start;
                    EndFrame := MyTLEdit.Events[crpos.Number].Finish;
                    DurFrame := MyTLEdit.Events[crpos.Number].Start +
                      MyTLEdit.Events[crpos.Number].ReadPhraseData('Duration');
                    if DurFrame > MyTLEdit.Events[crpos.Number].Finish then
                        DurFrame := MyTLEdit.Events[crpos.Number].Finish - 1;

                    if crpos.Number<MyTLEdit.Count then begin
                      next := MyTLEdit.Events[crpos.Number + 1].ReadPhraseText
                        ('Device');
                      cmdcmd := MyTLEdit.Events[crpos.Number + 1]
                        .ReadPhraseCommand('Command');
                      cmdc := MyTLEdit.Events[crpos.Number + 1].ReadPhraseText
                        ('Command');
                      sdur := inttostr(MyTLEdit.Events[crpos.Number + 1]
                        .ReadPhraseData('Duration'));
                      sset := inttostr(MyTLEdit.Events[crpos.Number + 1]
                        .ReadPhraseData('Set'));



                      nStartFrame := MyTLEdit.Events[crpos.Number + 1].Start;
                      nEndFrame := MyTLEdit.Events[crpos.Number + 1].Finish;
                      nDurFrame := MyTLEdit.Events[crpos.Number + 1].Start +
                        MyTLEdit.Events[crpos.Number + 1].ReadPhraseData
                        ('Duration');
                      if nDurFrame > MyTLEdit.Events[crpos.Number + 1].Finish then
                          DurFrame := MyTLEdit.Events[crpos.Number + 1]
                            .Finish - 1;
                    end else begin
                      next:='����';
                      cmdc:='';
                      sdur:='0';
                      sset:='0';
                      cmdcmd :='';
                      nStartFrame:=EndFrame;
                      nEndFrame:=EndFrame;
                      nDurFrame := 0;
                    end;
                   // if DurFrame=0 then DurFrame:=1;

                end;
                sstart := FramesToStr(framestostart - 1);

                InfoWEB.SetData(3, inttostr(MyTLEdit.Count) + '  (' +

                  inttostr(crpos.Number + 1) + ')');

                // '���-�� ������� (�������):'
                // WriteLog('vlcmode', IntToStr(local_vlcMode));


                // InfoWEB.SetData(4, ''); // '����� ���������������:'
                InfoWEB.SetData(5,
                  FramesToStr(MyTLEdit.Events[crpos.Number].Finish -
                  MyTLEdit.Events[crpos.Number].Start)); // '������. �������:'
                InfoWEB.SetData(8, curr + '  S=' + inttostr(StartFrame) + '  T='
                  + inttostr(DurFrame) + '  F=' + inttostr(EndFrame));
                // '������� ����������:'
                if trim(crtr) = '' then
                    crtr := 'Cut';
                if ansilowercase(trim(crtr)) <> 'cut' then
                    crtr := crtr + '  Dur=' + crdr + '  Set=' + crst;
                InfoWEB.SetData(9, crtr); // '��� ��������:'
                InfoWEB.SetData(10, crcmd); // '�����. �������:'
                InfoWEB.SetData(7, sstart); // '�� ����. �������'
                if trim(cmdc) = '' then
                    cmdc := 'Cut';

                if ansilowercase(trim(next)) <> '����' then
                    txt := curr + '  |  ' + cmdc + '  |  ' + next
                else
                    txt := next;
                //if local_vlcMode=1 then WriteLog('CMD', '***********   ' + txt + '    ******************** DurFrame=' + inttostr(DurFrame));
                InfoWEB.SetData(6, txt); // '�������'
                InfoWEB.SetData(11, next + '  S=' + inttostr(nStartFrame) +
                  '  T=' + inttostr(nDurFrame) + '  F=' + inttostr(nEndFrame));
                // '����. ����������:'
                if ansilowercase(trim(cmdc)) <> 'cut' then
                    cmdc := cmdc + '  Dur=' + sdur + '  Set=' + sset;
                InfoWEB.SetData(12, cmdc); // '��� ��������'
                InfoWEB.SetData(13, cmdcmd); // '����. �������:'

                   case local_vlcMode of
                0,2: begin
                       if local_vlcMode=0 then InfoWEB.SetData(4, 'Stop');
                       if local_vlcMode=2 then InfoWEB.SetData(4, 'Paused');
//++++++++++++++++++++++++++++++   PAUSED   ++++++++++++++++++++++++++++++++++++
                       if OldList1Index <> crpos.Number then
                       begin
                           ListCommands.Clear;
                           // WriteBuffToPort(DataToBuffIn('30303030'));
                           if myprotocol <> nil then
                             if crpos.Number<MyTLEdit.Count then
                               myprotocol.CMDTemplates.GetCMDPaused
                                 (crpos.Number, ListCommands);
                           if ListCommands.Count>0 then WriteLog('CMD', 'Paused ***********   ' + txt + '    *********** DurFrame=' + inttostr(DurFrame));
                           for icmd := 0 to ListCommands.Count - 1 do begin
                               if trim(myprotocol.CMDTemplates.TypeData) = '0' then begin
                                 //infoport.SetData(9, infoport.Options[8].Text);
                                 //infoport.SetData(8, infoport.Options[7].Text);
                                 infoport.SetData(7, '');
                                 WriteBuffToPort
                                     (DataToBuffIn(trim(ListCommands.Strings[icmd])));
                                 CountWaitReplay:=0;
                                 while (trim(infoport.Options[7].Text)='')
                                      and (CountWaitReplay<MaxCountReplay) do
                                 begin
                                   CountWaitReplay:=CountWaitReplay+1;
                                   application.ProcessMessages;
                                 end;
                                 WriteLog('CMD', 'CMDPaused(byte): ' + ListCommands.Strings[icmd]);
                               end else begin
                                 WriteStrToPort(trim(ListCommands.Strings[icmd]));
                                 CountWaitReplay:=0;
                                 while (trim(infoport.Options[7].Text)='')
                                      and (CountWaitReplay<MaxCountReplay) do
                                 begin
                                   CountWaitReplay:=CountWaitReplay+1;
                                   application.ProcessMessages;
                                 end;
                                 WriteLog('CMD', 'CMDSPaused(string): ' + ListCommands.Strings[icmd]);
                               end;
                           end;

                           istrans := false;
                           isduration := false;
                           isendevent := false;
                           isstartevent := false;
                       end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                     end;
                1:   begin
                       InfoWEB.SetData(4, 'Play');
//++++++++++++++++++++++++++++++   PLAY   ++++++++++++++++++++++++++++++++++++++
                       if (TLParameters.Position > DurFrame) and (not isduration) then
                       begin
                           ListCommands.Clear;
                           if myprotocol <> nil then
                              if crpos.Number<MyTLEdit.Count then
                                myprotocol.CMDTemplates.GetCMDTransition
                                  (crpos.Number, ListCommands);
                           if ListCommands.Count>0 then WriteLog('CMD', 'Transition ***********   ' + txt + '    *********** DurFrame=' + inttostr(DurFrame));
                           for icmd := 0 to ListCommands.Count - 1 do
                           begin
                               if trim(myprotocol.CMDTemplates.TypeData) = '0' then begin
                                 //infoport.SetData(9, infoport.Options[8].Text);
                                 //infoport.SetData(8, infoport.Options[7].Text);
                                 infoport.SetData(7, '');
                                 WriteBuffToPort
                                     (DataToBuffIn(trim(ListCommands.Strings[icmd])));
                                 CountWaitReplay:=0;
                                 while (trim(infoport.Options[7].Text)='')
                                      and (CountWaitReplay<MaxCountReplay) do
                                 begin
                                   CountWaitReplay:=CountWaitReplay+1;
                                   application.ProcessMessages;
                                 end;
                                 WriteLog('CMD', 'CMDTransition(byte): ' + ListCommands.Strings[icmd]);
                               end else begin
                                 WriteStrToPort(trim(ListCommands.Strings[icmd]));
                                 CountWaitReplay:=0;
                                 while (trim(infoport.Options[7].Text)='')
                                      and (CountWaitReplay<MaxCountReplay) do
                                 begin
                                   CountWaitReplay:=CountWaitReplay+1;
                                   application.ProcessMessages;
                                 end;
                                 WriteLog('CMD', 'CMDTransition(string): ' + ListCommands.Strings[icmd]);
                               end;
                           end;
                           // WriteBuffToPort(DataToBuffIn('31313131'));
                           isduration := true;
                       end;
                       if TLParameters.Position = EndFrame then
                       begin
                           // WriteBuffToPort(DataToBuffIn('51515151'));
                           isendevent := true;
                       end;
                       if TLParameters.Position - 1 = StartFrame then
                       begin
                           // WriteBuffToPort(DataToBuffIn('3967676739'));
                           isstartevent := true;
                       end;

                       if (framestostart - 1 = 0) and (not istrans) then
                       begin
                           ListCommands.Clear;
                           if myprotocol <> nil then
                             if crpos.Number<MyTLEdit.Count then
                               myprotocol.CMDTemplates.GetCMDFinish
                                 (crpos.Number, ListCommands);
                           if ListCommands.Count>0 then WriteLog('CMD', 'Finish ***********   ' + txt + '    *********** DurFrame=' + inttostr(DurFrame));
                           for icmd := 0 to ListCommands.Count - 1 do
                           begin
                               if trim(myprotocol.CMDTemplates.TypeData) = '0' then begin
                                 WriteBuffToPort
                                     (DataToBuffIn(trim(ListCommands.Strings[icmd])));
                                 CountWaitReplay:=0;
                                 while (trim(infoport.Options[7].Text)='')
                                      and (CountWaitReplay<MaxCountReplay) do
                                 begin
                                   CountWaitReplay:=CountWaitReplay+1;
                                   application.ProcessMessages;
                                 end;
                                 WriteLog('CMD', 'CMDFinish(byte): ' + ListCommands.Strings[icmd]);
                               end else begin
                                 WriteStrToPort(trim(ListCommands.Strings[icmd]));
                                 CountWaitReplay:=0;
                                 while (trim(infoport.Options[7].Text)='')
                                      and (CountWaitReplay<MaxCountReplay) do
                                 begin
                                   CountWaitReplay:=CountWaitReplay+1;
                                   application.ProcessMessages;
                                 end;
                                 WriteLog('CMD', 'CMDFinish(string): ' + ListCommands.Strings[icmd]);
                               end;
                           end;
                           // WriteBuffToPort(DataToBuffIn('32323232'));
                           istrans := true;
                       end;

                       // FmMain.Label8.Caption:=sstart;
                       if OldList1Index <> crpos.Number then
                       begin
                           ListCommands.Clear;
                           // WriteBuffToPort(DataToBuffIn('30303030'));
                           if myprotocol <> nil then
                             if crpos.Number<MyTLEdit.Count then
                               myprotocol.CMDTemplates.GetCMDStart
                                 (crpos.Number, ListCommands);
                           if ListCommands.Count>0 then WriteLog('CMD', 'Start ***********   ' + txt + '    *********** DurFrame=' + inttostr(DurFrame));
                           for icmd := 0 to ListCommands.Count - 1 do begin
                               if trim(myprotocol.CMDTemplates.TypeData) = '0' then begin
                                 //infoport.SetData(9, infoport.Options[8].Text);
                                 //infoport.SetData(8, infoport.Options[7].Text);
                                 infoport.SetData(7, '');
                                 WriteBuffToPort
                                     (DataToBuffIn(trim(ListCommands.Strings[icmd])));
                                 while (trim(infoport.Options[7].Text)='')
                                      and (CountWaitReplay<MaxCountReplay) do
                                 begin
                                   CountWaitReplay:=CountWaitReplay+1;
                                   application.ProcessMessages;
                                 end;
                                 WriteLog('CMD', 'CMDStart(byte): ' + ListCommands.Strings[icmd]);
                               end else begin
                                 WriteStrToPort(trim(ListCommands.Strings[icmd]));
                                 while (trim(infoport.Options[7].Text)='')
                                      and (CountWaitReplay<MaxCountReplay) do
                                 begin
                                   CountWaitReplay:=CountWaitReplay+1;
                                   application.ProcessMessages;
                                 end;
                                 WriteLog('CMD', 'CMDStart(string): ' + ListCommands.Strings[icmd]);
                               end;
                           end;

                           istrans := false;
                           isduration := false;
                           isendevent := false;
                           isstartevent := false;
                       end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                     end;
                   end;




                OldList1Index := crpos.Number;
                // application.ProcessMessages;

                // crpos := TLZone.TLEditor.CurrentEvents;
                // MyProtocol.CMDTemplates.GetCMDStart(MyTLEdit.Events[crpos.Number], ListCommads);
                // MyProtocol.CMDTemplates.GetCMDTransition(MyTLEdit.Events[crpos.Number+1], ListCommadss);
                // MyProtocol.CMDTemplates.GetCMDFinish(MyTLEdit.Events[crpos.Number+1], ListCommads);

            end;
            // application.ProcessMessages;
            InfoWEB.Draw(fmMain.imgWeb.Canvas, 25);
            fmMain.imgWeb.Repaint;
            InfoPort.Draw(fmMain.ImgTrans.Canvas, 25);
            fmMain.ImgTrans.Repaint;
        end
        else
        begin
            // WriteLog('vlcmode', 'TRY update TLP mytimer diabled');

        end;;
        application.ProcessMessages;

    except
        // on E: Exception do WriteLog('MAIN', 'TMyThread.DoWork | ' + E.Message);
    end;
end;

procedure TfmMain.WMICON(var Msg: TMessage);
var
    P: TPoint;
begin
    case Msg.LParam of
        WM_LBUTTONUP:
            begin
                GetCursorPos(P);
                SetForegroundWindow(application.MainForm.Handle);
                PopupMenu1.Popup(P.X, P.Y);
            end;
        WM_LBUTTONDBLCLK:
            RestoreItemClick(Self);
    end;
end;

procedure TfmMain.WMSYSCOMMAND(var Msg: TMessage);
begin
    inherited;
    if (Msg.wParam = SC_MINIMIZE) then
        HideItemClick(Self);
end;

procedure TfmMain.HideItemClick(Sender: TObject);
begin
    //HideMainForm;
    CreateTrayIcon(1);
    HideMainForm;
    HideItem.Enabled := false;
    RestoreItem.Enabled := true;
end;

procedure TfmMain.HideMainForm;
begin
    application.ShowMainForm := false;
    ShowWindow(application.Handle, SW_HIDE);
    ShowWindow(application.MainForm.Handle, SW_HIDE);
end;

procedure TfmMain.N1Click(Sender: TObject);
begin
    setoptions;
end;

procedure TfmMain.RestoreItemClick(Sender: TObject);
begin
    RestoreMainForm;
    RestoreItem.Enabled := false;
    HideItem.Enabled := true;
end;

procedure TfmMain.RestoreMainForm;
var
    i, j: Integer;
begin
    application.ShowMainForm := true;
    ShowWindow(application.Handle, SW_RESTORE);
    ShowWindow(application.MainForm.Handle, SW_RESTORE);
    if not ShownOnce then
    begin
        for i := 0 to application.MainForm.ComponentCount - 1 do
            if application.MainForm.Components[i] is TWinControl then
                with application.MainForm.Components[i] as TWinControl do
                    if Visible then
                    begin
                        ShowWindow(Handle, SW_SHOWDEFAULT);
                        for j := 0 to ComponentCount - 1 do
                            if Components[j] is TWinControl then
                                ShowWindow((Components[j] as TWinControl)
                                  .Handle, SW_SHOWDEFAULT);
                    end;
        ShownOnce := true;
    end;

end;

procedure TfmMain.CreateTrayIcon(n: Integer);
var
    nidata: TNotifyIconData;
begin
    with nidata do
    begin
        // cbSize := SizeOf(TNotifyIconData);
        Wnd := Self.Handle;
        uID := 1;
        uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
        uCallBackMessage := WM_MYICONNOTIFY;
        hIcon := application.icon.Handle;
        StrPCopy(szTip, application.Title);
    end;
    Shell_NotifyIcon(NIM_ADD, @nidata);
end;

procedure TfmMain.UpdateTrayIcon(icon: ticon; name: string);
var
    nidata: TNotifyIconData;
begin
    with nidata do
    begin
        // cbSize := SizeOf(TNotifyIconData);
        Wnd := Self.Handle;
        uID := 1;
        uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
        uCallBackMessage := WM_MYICONNOTIFY;
        hIcon := icon.Handle;
        StrPCopy(szTip, name);
    end;
    Shell_NotifyIcon(NIM_MODIFY, @nidata);
end;

procedure TfmMain.DeleteTrayIcon(n: Integer);
var
    nidata: TNotifyIconData;
begin
    with nidata do
    begin
        // cbSize := SizeOf(TNotifyIconData);
        Wnd := Self.Handle;
        uID := 1;
    end;
    Shell_NotifyIcon(NIM_DELETE, @nidata);
end;

procedure TfmMain.FileExitItem1Click(Sender: TObject);
begin
    CloseApplication := true;
    Close;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nidata: TNotifyIconData;
begin
    if not CloseApplication then
    begin
        Action := caNone;
        HideItemClick(nil);
        if frOptions.Showing then
            frOptions.Close;
        if Form3.Showing then
            Form3.Close;
        exit;
    end;
    if MyThread <> nil then
        MyThread.Terminate;

    if CommThreadExists then
        StopService;
    WriteIniFile(AppPath + AppName + SerialNumber + '.ini');
    try
       with nidata do begin
          Wnd := fmMain.Handle;
          uID := 1;
       end;
       Shell_NotifyIcon(NIM_DELETE, Addr(nidata));
    finally
       Application.Terminate;
    end;
end;

procedure TfmMain.ComportInit;
Var
    lstrs: string;
begin
    lstrs := trim(GetSerialPortNames(ListComports));
    if lstrs <> '' then
    begin
        if port422number <= ListComports.Count - 1 then
        begin
            port422name := ListComports.Strings[port422number];
            Port422Init := StartService;
        end;
    end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
    i: Integer;
    myLabel: TLabel;
begin
    Panel5.Height := 25 * 10;
    GroupBox3.Height := 25 * 16;
    fmMain.Height := Panel5.Height + GroupBox3.Height + 60;
    fmMain.Color := ProgrammColor;
    fmMain.Font.name := ProgrammFontName;
    fmMain.Font.Size := ProgrammFontSize;
    fmMain.Font.Color := ProgrammFontColor;

    Panel1.Color := ProgrammColor;
    Panel1.Font.name := ProgrammFontName;
    Panel1.Font.Size := ProgrammFontSize;
    Panel1.Font.Color := ProgrammFontColor;

    Panel2.Color := ProgrammColor;
    Panel2.Font.name := ProgrammFontName;
    Panel2.Font.Size := ProgrammFontSize;
    Panel2.Font.Color := ProgrammFontColor;

    Panel5.Color := ProgrammColor;
    Panel5.Font.name := ProgrammFontName;
    Panel5.Font.Size := ProgrammFontSize;
    Panel5.Font.Color := ProgrammFontColor;

    Panel6.Color := ProgrammColor;
    Panel6.Font.name := ProgrammFontName;
    Panel6.Font.Size := ProgrammFontSize;
    Panel6.Font.Color := ProgrammFontColor;

    // for i := 0 to fmmain.ComponentCount - 1 do
    // if (fmmain.Components[i] is TGroupBox) and
    // (fmmain.Components[i].Tag <> 1) then
    // begin
    // myLabel := TLabel.Create(fmmain.Components[i]);
    // myLabel.Parent := fmmain.Components[i] as TGroupBox;
    // myLabel.Font := (fmmain.Components[i] as TGroupBox).Font;
    // myLabel.Caption := (fmmain.Components[i] as TGroupBox).Caption;
    // myLabel.Transparent := False;
    // myLabel.Left := 8;
    // myLabel.Top := 0;
    // fmmain.Components[i].Tag := 1;
    // end;

    GroupBox1.Color := ProgrammColor;
    GroupBox1.Font.name := ProgrammFontName;
    GroupBox1.Font.Size := ProgrammFontSize;
    GroupBox1.Font.Color := ProgrammFontColor;
    // GroupBox1.Repaint;

    GroupBox2.Color := ProgrammColor;
    GroupBox2.Font.name := ProgrammFontName;
    GroupBox2.Font.Size := ProgrammFontSize;
    GroupBox2.Font.Color := ProgrammFontColor;

    GroupBox3.Color := ProgrammColor;
    GroupBox3.Font.name := ProgrammFontName;
    GroupBox3.Font.Size := ProgrammFontSize;
    GroupBox3.Font.Color := ProgrammFontColor;

    GroupBox4.Color := ProgrammColor;
    GroupBox4.Font.name := ProgrammFontName;
    GroupBox4.Font.Size := ProgrammFontSize;
    GroupBox4.Font.Color := ProgrammFontColor;

    FicheroM := OpenFileMapping(FILE_MAP_ALL_ACCESS, false, 'MiFichero');
    { ���� ���, �� ������ }
    if FicheroM = 0 then
        FicheroM := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
          SizeOf(TCompartido), 'MiFichero');
    // ���� ��������� ����, �������� ��� ������
    if FicheroM = 0 then
        raise Exception.Create('�� ������� ������� ����' +
          '/������ ��� �������� �����');
    Compartido := MapViewOfFile(FicheroM, FILE_MAP_WRITE, 0, 0, 0);
    Compartido^.Manejador2 := Handle;
    Compartido^.Cadena := 'request';

    MySinhro := chltc;

    // trim(GetSerialPortNames(cbComPort.Items));
    AppPath := extractfilepath(application.ExeName);
    AppName := extractfilename(application.ExeName);
    AppExt := extractfileext(application.ExeName);
    AppName := Copy(AppName, 1, Length(AppName) - Length(AppExt));
    ReadIniFile(AppPath + AppName + SerialNumber + '.ini');
    Caption := '������ ���������� ������������: ' + '  S/N: ' + SerialNumber +
      '   ID=' + inttostr(ManagerNumber);
    // ������������� ������ ���������
    SetIconApplication(Image1, ManagerNumber);
    // �������������� ���������������� ����
    ComportInit;

    // fmMain.StatusBar1.Panels[0].Text:='���� �� ���������������';

    // if cbComPort.Items.Count>0 then cbComPort.ItemIndex:=cbComPort.Items.IndexOf(port422name);

    MyTimer := THRTimer.Create;
    MyThread := TMyThread.Create(false);
    MyThread.Priority := tpTimeCritical; // tpHighest;

    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);

    DrawProtocolStatus;
    InfoWEB.Draw(fmMain.imgWeb.Canvas, 25);
    fmMain.imgWeb.Repaint;

    ShownOnce := false;
    CreateTrayIcon(1);
    // if CheckBox3.checked then begin
    fmMain.WindowState := wsMinimized;
    application.ShowMainForm := false;
    ShowWindow(application.Handle, SW_HIDE);
    HideItem.Enabled := false;

    // ������� +++++++++++++++++++++++++++++++++++

    LoadAProtocolFromFile(AppPath + 'AProtocol.txt');
    LoadProtocol('AListProtocols.txt', 'TLDevices', INFOTypeDevice, INFOVendor,
      INFODevice, INFOProt);
    // ������� +++++++++++++++++++++++++++++++++++
    if ProgOptions = nil then ProgOptions := TProgOptions.create;
    ProgOptions.LoadData;
    Timer1.Enabled := true;
    // FmMain.Memo2.Clear;
    MyTimer.StartTimer;
    CurrDt := now;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
    UnmapViewOfFile(Compartido);
    CloseHandle(FicheroM);
    MyThread.Free;
    MyThread := nil;
end;

procedure TfmMain.FormHide(Sender: TObject);
begin
    WriteIniFile(AppPath + AppName + '.ini');
end;

procedure TfmMain.ComportDialogOpen;
var
    lpcc: _COMMCONFIG;
    sz: dword;
    notstart: Boolean;
    tempport: Integer;
begin
    try
        if CommThreadExists then
        begin
            GetCommConfig(hport, &lpcc, sz);
            CommConfigDialog(PChar(port422name), fmMain.Handle, &lpcc);
            SetCommConfig(hport, &lpcc, SizeOf(lpcc));
        end
        else
        begin
            tempport := CreateFile(PChar(port422name), GENERIC_READ or
              GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
              OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
            if tempport <= 0 then
            begin
                MessageDlg('�� ������� ������������ ���� ' + port422name + '.' +
                  #10#13 + '�������� �� ����� � ������ ���������.',
                  mtInformation, [mbOk], 0, mbOk);
            end
            else
            begin;
                GetCommConfig(tempport, &lpcc, sz);
                CommConfigDialog(PChar(port422name), fmMain.Handle, &lpcc);
                SetCommConfig(tempport, &lpcc, SizeOf(lpcc));
            end;
            CloseHandle(tempport);
        end;
    except
        MessageDlg('������ ��������� � ����� ' + port422name + '.',
          mtInformation, [mbOk], 0, mbOk);
    end;
end;

procedure TfmMain.SpeedButton1Click(Sender: TObject);
begin
    Close;
end;

procedure TfmMain.SpeedButton2Click(Sender: TObject);
begin
    Form3.Show;
end;

procedure TfmMain.SpeedButton3Click(Sender: TObject);
begin
  ComportDialogOpen;
end;

procedure TfmMain.SpeedButton4Click(Sender: TObject);
begin
    setoptions;
end;

Procedure GetTimeLinesFromServer;
var
    i: Integer;
    wt_i: Integer;
    str1: ansistring;
    str2: ansistring;
    sl: tstringlist;
    tle: ansistring;
begin
     if ProgOptions <> nil  then begin
         str2 := 'DEVMAN['+ProgOptions.Options[1].text+']';
          str1 :=ProgOptions.SaveToJSONStr;
               PutJsonStrToServer(str2,str1);
     end;

    for i := low(TLO_server) to high(TLO_server) do
    begin
        str2 := GetJsonStrFromServer('TLO[' + inttostr(i + 1) + ']');
        for wt_i := 0 to 10 do
        begin
            application.ProcessMessages;
        end;
        if TLO_server_old[i] <> str2 then
        begin
            TLO_server_changed[i] := true;
            TLO_server_old[i] := str2;
            if Length(str2) < 30 then
            begin
                TLO_server[i] := nil;
                continue;
            end;
            if TLO_server[i] = nil then
                TLO_server[i] := TTimelineOptions.Create;
            if not TLO_server[i].LoadFromJSONstr(str2) then
                TLO_server[i] := nil;
        end;

    end;
    for i := 0 to 16 do
    begin
        str2 := GetJsonStrFromServer('TLT[' + inttostr(i) + ']');
        if TLT_server_old[i] <> str2 then
        begin
            TLT_server_changed[i] := true;;
            if TLT_server[i] = nil then
                TLT_server[i] := TTlTimeline.Create;
            if not TLT_server[i].LoadFromJSONstr(str2) then
                TLT_server[i] := nil;
        end;
        TLT_server_old[i] := str2;
        for wt_i := 0 to 10 do
        begin
            application.ProcessMessages;
        end;

        if Length(str2) < 30 then
        begin
            TLT_server[i] := nil;
        end;
    end;

end;

Procedure Update_TLEditor;
var
    str1, str2, str3: ansistring;
    url: ansistring;
    slist1: tstringlist;
    i, wt_i: Integer;
begin
    // FmMain.Memo2.Clear;
    if abs(now - tle_request_time) * 24 * 3600 * 1000 < 3000 then
        exit;
    tle_request_time := now;
    // InfoWEB.SetData(1,'00:00:00:00');
    CurrDt := now;
    url := URLServer;
    LoadProject_active := false;

    GetTimeLinesFromServer;

    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    for i := 0 to 15 do
    begin
        // if trim(TLO_server[i].Manager)=trim(ProgOptions.Options[1].Text) then begin  //
        if TLO_server[i] <> nil then
        begin
            if trim(TLO_server[i].Manager) = inttostr(ManagerNumber) then
            begin
                NumberManeger := i;
                break;
            end;
        end;
    end;
    if TLO_server[NumberManeger] <> nil then
    begin
        if TLO_server_changed[NumberManeger] then
        begin
          if trim(TLO_server[NumberManeger].Protocol) <> '' then
            SetAProtocolData(TLO_server[NumberManeger].Protocol);
            SaveAProtocolToFile('AProtocol.txt', TLO_server[NumberManeger].Protocol);
            LoadProtocol('AListProtocols.txt', 'TLDevices', INFOTypeDevice, INFOVendor,
                         INFODevice, INFOProt);
          TLO_server_changed[NumberManeger] := false;
          if ProgOptions = nil  then begin
            ProgOptions := TProgOptions.Create;
            ProgOptions.Clear;
          end;
          str2 := 'DEVMAN['+ProgOptions.Options[1].text+']';
          str3 :=ProgOptions.SaveToJSONStr;
          PutJsonStrToServer(str2,str3);
        end;
    end;

    if TLT_server[NumberManeger] <> nil then
    begin
       // if TLT_server_changed[NumberManeger] then
       // begin
            MyTLEdit.Assign(TLT_server[NumberManeger], NumberManeger + 1);
            TLT_server_changed[NumberManeger] := false;
       // end;
    end;
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    // WriteLog('vlcmode','GETTLEDITOR '+ url);

    str1 := GetJsonStrFromServer(url);
    if trim(str1) <> '' then
    begin
        if str1 <> old_tle_str then
        begin
            // MyTLEdit.Clear;
            // if MyTLEdit.LoadFromJSONstr(str1) then
            // begin
            // WriteLog('vlcmode', 'Load TLEDIT:');
            // WriteLog('vlcmode', '            '+str1);
            old_tle_str := str1;
            tle_request_time := now;
            // end
            // else begin
            // WriteLog('vlcmode', 'ERR load TLEDIT:');
            // WriteLog('vlcmode',str1);
            // end;
        end;
    end
    else
        InfoProtocol.SetData('������:', '�� ��������');
end;

procedure TfmMain.SpeedButton8Click(Sender: TObject);
var
    str1: ansistring;
    url: ansistring;
    slist1: tstringlist;
begin
    // FmMain.Memo2.Clear;
    if abs(now - tle_request_time) * 24 * 3600 < 10 then
        exit;

    InfoWEB.SetData(1, '00:00:00:00');
    CurrDt := now;
    MyTLEdit.Clear;
    url := URLServer;
    LoadProject_active := false;
    str1 := GetJsonStrFromServer(url);

    if trim(str1) <> '' then
    begin
        if str1 <> old_tle_str then
            if MyTLEdit.LoadFromJSONstr(str1) then
            begin
                InfoProtocol.SetData('������:', '��������');
                old_tle_str := str1;
                tle_request_time := now;
            end
            else
                InfoProtocol.SetData('������:', '�� ��������');
    end
    else
        InfoProtocol.SetData('������:', '�� ��������');
end;

procedure TfmMain.Timer1Timer(Sender: TObject);
var
    lstrs: string;
    tlp_str: string;
begin
    // tlp_str := GetJsonStrFromServer('TLP');
    // if Length(tlp_str)>10 then begin
    // TLP_server.LoadFromJSONstr(tlp_str);
    // caption := IntToStr(TLP_server.Position)+formatdatetime(' HH:NN:SS ZZZ',now);;
    // end;

    if port422select then
    begin
        if Port422Init then
        begin
            lstrs := trim(GetSerialPortNames(ListComports));
            if port422number > ListComports.Count - 1 then
            begin
                Port422Init := false;
                StopService;
                info422.SetData(7, '�� ���������������');
                // exit;
            end
            else
            begin
                info422.SetData(7, '�������');
                MyGetCommState;
                // label13.Caption:='��������������� ���� ' + port422name + ' ';
                // exit;
            end;
        end
        else
        begin
            info422.SetData(7, '�� ���������������');
            ComportInit;
        end;
        DrawProtocolStatus;
        exit;
    end
    else
    begin
        DrawProtocolStatus;
    end;
end;

var
    i: Integer;

initialization

for i := low(TLO_server) to high(TLO_server) do
begin
    TLO_server[i] := nil;
    TLO_server_changed[i] := true;
    TLO_server_old[i] := '';

    TLT_server[i] := nil;
    TLT_server_changed[i] := true;
    TLT_server_old[i] := '';
end;

end.
