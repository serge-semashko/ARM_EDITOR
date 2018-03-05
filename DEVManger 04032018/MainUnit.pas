unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, Variants, MMSystem, Menus, UHRTimer,
  Vcl.Samples.Spin, UCommon;

CONST
   WM_TRANSFER = WM_USER + 1;  // Определяем сообщение
   //WM_TRANSFER = WM_USER + 1;
   WM_MYICONNOTIFY = WM_USER + 777;

type
  PCompartido =^TCompartido;
  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero    : Integer;
    Shift     : Double;
    Cadena    : String[20];
  end;

  TMyThread = class(TThread)
   private
     { Private declarations }
     //FicheroM   : THandle;
     //procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
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
  private
    { Private declarations }
    ShownOnce: Boolean;
    //Compartido : PCompartido;
    FicheroM   : THandle;
    procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
    //procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
    procedure ComportDialogOpen;
  public
    { Public declarations }
    Compartido : PCompartido;
    procedure WMICON(var msg: TMessage); message WM_MYICONNOTIFY;
    procedure WMSYSCOMMAND(var msg: TMessage); message WM_SYSCOMMAND;
    procedure RestoreMainForm;
    procedure HideMainForm;
    procedure CreateTrayIcon(n: Integer);
    procedure DeleteTrayIcon(n: Integer);
    procedure UpdateTrayIcon(icon : ticon; name : string);
    procedure ComportInit;
  end;

var
  fmMain: TfmMain;
  AppPath, AppName, AppExt : string;
  GridFile : string = '';
  CommandFile : string = '';
  CloseApplication : boolean = false;
  MyThread : TMyThread;
  OldList1Index : longint =-1;
  MyTimer : THRTimer;
  PredDt, CurrDt, pStart1 : Double;
  istrans : boolean = false;
  isduration : boolean = false;
  isendevent : boolean = false;
  isstartevent : boolean = false;

  procedure StartMyTimer;
  procedure StopMyTimer;
  Function ReadMyTimer : Double;

implementation

uses ComPortUnit, umychars, UMyWork, UMyInitFile, ShellApi, shlobj, registry,
    umain, UTimeline, UDrawTimelines, UGRTimelines, umyevents, uwebget, UPortOptions,
    umyinfo, umyprotocols;

{$R *.DFM}

Procedure DrawProtocolStatus;
begin
  UpdateInfoProtocol;
  UpdateInfo422;
  UpdateInfoIP;
  InfoProtocol.Draw(fmmain.ImgProtocol.Canvas,25);
  fmmain.ImgProtocol.Repaint;
  if port422select
    then info422.Draw(fmmain.ImgPort.Canvas,25)
    else infoIP.Draw(fmmain.ImgPort.Canvas,25);
  fmmain.ImgPort.Repaint;
end;

procedure StartMyTimer;
var dur : double;
begin
  try
  PredDt:=0;
  pStart1:=0;
  if TLParameters.Position - TLParameters.Preroll > dur
    then pStart1:=FramesToDouble(TLParameters.Position - TLParameters.Preroll);

  MyTimer.StartTimer;
  PredDt:=MyTimer.ReadTimer;

  except
  end;
end;

procedure StopMyTimer;
begin
  MyTimer.StopTimer;
end;

Function ReadMyTimer : Double;
begin
  result := MyTimer.ReadTimer;
end;

procedure TfmMain.Reciviendo(var Msg: TMessage);
begin
  try
  //label1.Caption:=compartido^.Cadena;
  MyShiftOld := MyShift;
  MyShift := compartido^.Shift;
  compartido^.Cadena:='';
  //WriteLog('MAIN', 'Message:Reciviendo');
  except
//    on E: Exception do WriteLog('MAIN', 'Message:Reciviendo | ' + E.Message);
  end;
end;

procedure TMyThread.Execute;
begin
  try //MyThread.Priority:=tpTimeCritical;
   {Если Вы хотите, чтобы процедура DoWork выполнялась лишь один раз - удалите цикл while}
    while not Terminated do begin
     sleep(1);
     Synchronize(DoWork);
    end;
    //WriteLog('MAIN', 'TMyThread.Execute');
  except
    //on E: Exception do WriteLog('MAIN', 'TMyThread.Execute | ' + E.Message);
  end;
end;

procedure TMyThread.DoWork;
var crpos : TEventReplay;
    txt, strchron : string;
    framestostart, data : longint;
    curr, crtr, crdr, crst, crcmd, Stri : string;
    next, cmdc, sdur, sset, cmdcmd, sstart, evdur : string;
    i, icmd : integer;
    StartFrame, DurFrame, EndFrame, nStartFrame, nEndFrame, nDurFrame : longint;
begin
  try


   If MyTimer.Enable then begin
     //FmMain.label6.Caption:=MyDateTimeToStr(now-CurrDt-TimeCodeDelta);//TimeToTimeCodeStr(dttm);//CurrDt);
     application.ProcessMessages;
     InfoWEB.SetData(0,MyDateTimeToStr(now)); //'Тайм код системы:

      // 'Текущий кадр:'
     if InfoWEB.Options[0].Text<>'' then TLParameters.Position :=TLParameters.Preroll + StrTimeCodeToFrames(InfoWEB.Options[1].Text);
     InfoWEB.SetData(2,inttostr(TLParameters.Position));
     //if FmMain.label6.Caption<>'' then TLParameters.Position :=TLParameters.Preroll + StrTimeCodeToFrames(FmMain.label6.Caption);
     //FmMain.label12.Caption:=inttostr(TLParameters.Position-TLParameters.Preroll);
     crpos := MyTLEdit.CurrentEvents;
     if crpos.Number<>-1 then begin
       strchron := FramesToStr(MyTLEdit.Events[MyTLEdit.Count-1].Finish - MyTLEdit.Events[0].Finish);
       InfoWEB.SetData(1,MyDateTimeToStr(now-CurrDt-TimeCodeDelta)+'  ('+strchron+')'); //'Тайм код воспроизв.:'
       //FmMain.label10.Caption:=inttostr(crpos.Number);
       curr:=MyTLEdit.Events[crpos.Number].ReadPhraseText('Device');

       if crpos.Number>=MyTLEdit.Count-1 then begin
         next := 'Стоп';
         cmdc := '';
         cmdcmd := '';
         sdur := '';
         sset := '';
         sstart:='';
         curr:=MyTLEdit.Events[MyTLEdit.Count-1].ReadPhraseText('Device');
         crtr:=MyTLEdit.Events[MyTLEdit.Count-1].ReadPhraseText('Command');
         crdr:=inttostr(MyTLEdit.Events[MyTLEdit.Count-1].ReadPhraseData('Duration'));
         crst:=inttostr(MyTLEdit.Events[MyTLEdit.Count-1].ReadPhraseData('Set'));
         crcmd:=MyTLEdit.Events[MyTLEdit.Count-1].ReadPhraseCommand('Command');
         TLParameters.Finish:=MyTLEdit.Events[MyTLEdit.Count-1].Finish;  //++++++++++++++++++++++++
         framestostart := TLParameters.Finish - TLParameters.Position;
       end else begin
         curr:=MyTLEdit.Events[crpos.Number].ReadPhraseText('Device');
         data:=MyTLEdit.Events[crpos.Number].ReadPhraseData('Device');
         crtr:=MyTLEdit.Events[crpos.Number].ReadPhraseText('Command');
         crdr:=inttostr(MyTLEdit.Events[crpos.Number].ReadPhraseData('Duration'));
         crst:=inttostr(MyTLEdit.Events[crpos.Number].ReadPhraseData('Set'));
         crcmd:=MyTLEdit.Events[crpos.Number].ReadPhraseCommand('Command');

         next := MyTLEdit.Events[crpos.Number+1].ReadPhraseText('Device');
         cmdcmd := MyTLEdit.Events[crpos.Number+1].ReadPhraseCommand('Command');
         cmdc := MyTLEdit.Events[crpos.Number+1].ReadPhraseText('Command');
         sdur := inttostr(MyTLEdit.Events[crpos.Number+1].ReadPhraseData('Duration'));
         sset := inttostr(MyTLEdit.Events[crpos.Number+1].ReadPhraseData('Set'));

         framestostart := MyTLEdit.Events[crpos.Number+1].Start - (TLParameters.Position);
         StartFrame := MyTLEdit.Events[crpos.Number].Start;
         EndFrame := MyTLEdit.Events[crpos.Number].Finish;
         DurFrame := MyTLEdit.Events[crpos.Number].Start + MyTLEdit.Events[crpos.Number].ReadPhraseData('Duration');
         if DurFrame>MyTLEdit.Events[crpos.Number].Finish then DurFrame:=MyTLEdit.Events[crpos.Number].Finish-1;

         nStartFrame := MyTLEdit.Events[crpos.Number+1].Start;
         nEndFrame := MyTLEdit.Events[crpos.Number+1].Finish;
         nDurFrame := MyTLEdit.Events[crpos.Number+1].Start + MyTLEdit.Events[crpos.Number+1].ReadPhraseData('Duration');
         if nDurFrame>MyTLEdit.Events[crpos.Number+1].Finish then DurFrame:=MyTLEdit.Events[crpos.Number+1].Finish-1;
       end;
       sstart := FramesToStr(framestostart-1);

       InfoWEB.SetData(3,inttostr(MyTLEdit.Count) + '  (' + inttostr(crpos.Number+1) + ')');  // 'Кол-во событий (текущее):'
       InfoWEB.SetData(4, ''); // 'Режим воспроизведения:'
       InfoWEB.SetData(5,FramesToStr(MyTLEdit.Events[crpos.Number].Finish - MyTLEdit.Events[crpos.Number].Start)); // 'Хроном. события:'
       InfoWEB.SetData(8,curr + '  S=' + inttostr(StartFrame) + '  T=' + inttostr(DurFrame) + '  F=' + inttostr(EndFrame));// 'Текущее устройство:'
       if trim(crtr)='' then crtr:='Cut';
       if ansilowercase(trim(crtr))<>'cut' then crtr:=crtr + '  Dur=' + crdr + '  Set=' + crst;
       InfoWEB.SetData(9,crtr);// 'Тип перехода:'
       InfoWEB.SetData(10,crcmd); // 'Текущ. команда:'
       InfoWEB.SetData(7,sstart);// 'До след. события'
       if trim(cmdc)='' then cmdc:='Cut';

       if ansilowercase(trim(next))<>'стоп' then txt:=curr+'  |  '+cmdc+'  |  '+next else txt:=next;
       InfoWEB.SetData(6,txt);// 'Переход'
       InfoWEB.SetData(11,next + '  S=' + inttostr(nStartFrame) + '  T=' + inttostr(nDurFrame) + '  F=' + inttostr(nEndFrame)); // 'След. устройство:'
       if ansilowercase(trim(cmdc))<>'cut' then cmdc:=cmdc + '  Dur=' + sdur + '  Set=' + sset;
       InfoWEB.SetData(12,cmdc); // 'Тип перехода'
       InfoWEB.SetData(13,cmdcmd); // 'След. команда:'


       if (TLParameters.Position = DurFrame) and (not isduration) then begin
         ListCommands.Clear;
         if myprotocol<>nil then MyProtocol.CMDTemplates.GetCMDTransition(MyTLEdit.Events[crpos.Number+1], ListCommands);
         for icmd:=0 to ListCommands.Count-1 do begin
           if trim(MyProtocol.CMDTemplates.TypeData)='0'
             then WriteBuffToPort(DataToBuffIn(trim(ListCommands.Strings[icmd])))
             else WriteStrToPort(trim(ListCommands.Strings[icmd]));
         end;
         //WriteBuffToPort(DataToBuffIn('31313131'));
         isduration := true;
       end;
       if TLParameters.Position = EndFrame then begin
         //WriteBuffToPort(DataToBuffIn('51515151'));
         isendevent := true;
       end;
       if TLParameters.Position-1 = StartFrame then begin
         //WriteBuffToPort(DataToBuffIn('3967676739'));
         isstartevent := true;
       end;

       if (framestostart-1=0) and (not istrans) then begin
         ListCommands.Clear;
         if myprotocol<>nil then MyProtocol.CMDTemplates.GetCMDFinish(MyTLEdit.Events[crpos.Number+1], ListCommands);
         for icmd:=0 to ListCommands.Count-1 do begin
           if trim(MyProtocol.CMDTemplates.TypeData)='0'
             then WriteBuffToPort(DataToBuffIn(trim(ListCommands.Strings[icmd])))
             else WriteStrToPort(trim(ListCommands.Strings[icmd]));
         end;
         //WriteBuffToPort(DataToBuffIn('32323232'));
         istrans := true;
       end;

       //FmMain.Label8.Caption:=sstart;
       if OldList1Index<>crpos.Number then begin
         ListCommands.Clear;
         //WriteBuffToPort(DataToBuffIn('30303030'));
         if myprotocol<>nil then MyProtocol.CMDTemplates.GetCMDStart(MyTLEdit.Events[crpos.Number], ListCommands);
         for icmd:=0 to ListCommands.Count-1 do begin
           if trim(MyProtocol.CMDTemplates.TypeData)='0'
             then WriteBuffToPort(DataToBuffIn(trim(ListCommands.Strings[icmd])))
             else WriteStrToPort(trim(ListCommands.Strings[icmd]));
         end;

         istrans := false;
         isduration := false;
         isendevent := false;
         isstartevent := false;
       end;
       OldList1Index:=crpos.Number;
       //application.ProcessMessages;

      //   crpos := TLZone.TLEditor.CurrentEvents;
      //MyProtocol.CMDTemplates.GetCMDStart(MyTLEdit.Events[crpos.Number], ListCommads);
      //MyProtocol.CMDTemplates.GetCMDTransition(MyTLEdit.Events[crpos.Number+1], ListCommadss);
      //MyProtocol.CMDTemplates.GetCMDFinish(MyTLEdit.Events[crpos.Number+1], ListCommads);


     end;
     //application.ProcessMessages;
     InfoWEB.Draw(FmMain.imgWeb.Canvas,25);
     FmMain.imgWeb.Repaint;
     InfoPort.Draw(FmMain.ImgTrans.Canvas,25);
     FmMain.imgTrans.Repaint;
   end;
    application.ProcessMessages;


  except
   // on E: Exception do WriteLog('MAIN', 'TMyThread.DoWork | ' + E.Message);
  end;
end;

procedure TfmMain.WMICON(var msg: TMessage);
var
  P: TPoint;
begin
  case msg.LParam of
    WM_LBUTTONUP:
      begin
        GetCursorPos(p);
        SetForegroundWindow(Application.MainForm.Handle);
        PopupMenu1.Popup(P.X, P.Y);
      end;
    WM_LBUTTONDBLCLK: RestoreItemClick(Self);
  end;
end;

procedure TfmMain.WMSYSCOMMAND(var msg: TMessage);
begin
  inherited;
  if (Msg.wParam = SC_MINIMIZE) then
    HideItemClick(Self);
end;

procedure TfmMain.HideItemClick(Sender: TObject);
begin
  HideMainForm;
  CreateTrayIcon(1);
  HideItem.Enabled := False;
  RestoreItem.Enabled := True;
end;

procedure TfmMain.HideMainForm;
begin
  Application.ShowMainForm := False;
  ShowWindow(Application.Handle, SW_HIDE);
  ShowWindow(Application.MainForm.Handle, SW_HIDE);
end;

procedure TfmMain.N1Click(Sender: TObject);
begin
  setoptions;
end;

procedure TfmMain.RestoreItemClick(Sender: TObject);
begin
  RestoreMainForm;
  RestoreItem.Enabled := False;
  HideItem.Enabled := True;
end;

procedure TfmMain.RestoreMainForm;
var
  i, j: Integer;
begin
  Application.ShowMainForm := True;
  ShowWindow(Application.Handle, SW_RESTORE);
  ShowWindow(Application.MainForm.Handle, SW_RESTORE);
  if not ShownOnce then
  begin
    for I := 0 to Application.MainForm.ComponentCount - 1 do
      if Application.MainForm.Components[I] is TWinControl then
        with Application.MainForm.Components[I] as TWinControl do
          if Visible then
          begin
            ShowWindow(Handle, SW_SHOWDEFAULT);
            for J := 0 to ComponentCount - 1 do
              if Components[J] is TWinControl then
                ShowWindow((Components[J] as TWinControl).Handle,
                  SW_SHOWDEFAULT);
          end;
    ShownOnce := True;
  end;

end;

procedure TfmMain.CreateTrayIcon(n: Integer);
var
  nidata: TNotifyIconData;
begin
  with nidata do begin
    //cbSize := SizeOf(TNotifyIconData);
    Wnd := Self.Handle;
    uID := 1;
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uCallBackMessage := WM_MYICONNOTIFY;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, Application.Title);
  end;
  Shell_NotifyIcon(NIM_ADD, @nidata);
end;

procedure TfmMain.UpdateTrayIcon(icon : ticon; name : string);
var
  nidata: TNotifyIconData;
begin
  with nidata do begin
    //cbSize := SizeOf(TNotifyIconData);
    Wnd := Self.Handle;
    uID := 1;
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uCallBackMessage := WM_MYICONNOTIFY;
    hIcon := Icon.Handle;
    StrPCopy(szTip, name);
  end;
  Shell_NotifyIcon(NIM_MODIFY , @nidata);
end;

procedure TfmMain.DeleteTrayIcon(n: Integer);
var
  nidata: TNotifyIconData;
begin
  with nidata do begin
    //cbSize := SizeOf(TNotifyIconData);
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
begin
  if not CloseApplication then begin
    Action := caNone;
    HideItemClick(nil);
    if frOptions.Showing then frOptions.Close;
    if Form3.Showing then Form3.Close;
    exit;
  end;
  if MyThread<>nil then MyThread.Terminate;

  if CommThreadExists then StopService;
  WriteIniFile(AppPath+AppName+SerialNumber+'.ini');
end;

procedure TfmMain.ComportInit;
Var lstrs : string;
begin
  lstrs := trim(GetSerialPortNames(ListComports));
  if lstrs<>'' then begin
    if port422number<=ListComports.Count-1 then begin
      port422name := ListComports.Strings[port422number];
      Port422Init:=StartService;
    end;
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var i: integer;
  myLabel: TLabel;
begin
  Panel5.Height:=25*10;
  GroupBox3.Height:=25*16;
  fmMain.Height := Panel5.Height + GroupBox3.Height + 60;
  fmMain.Color:=ProgrammColor;
  fmMain.Font.Name:=ProgrammFontName;
  fmMain.Font.Size:=ProgrammFontSize;
  fmMain.Font.Color:=ProgrammFontColor;

  panel1.Color := ProgrammColor;
  panel1.Font.Name := ProgrammFontName;
  panel1.Font.Size := ProgrammFontSize;
  panel1.Font.Color := ProgrammFontColor;

  panel2.Color := ProgrammColor;
  panel2.Font.Name := ProgrammFontName;
  panel2.Font.Size := ProgrammFontSize;
  panel2.Font.Color := ProgrammFontColor;

  panel5.Color := ProgrammColor;
  panel5.Font.Name := ProgrammFontName;
  panel5.Font.Size := ProgrammFontSize;
  panel5.Font.Color := ProgrammFontColor;

  panel6.Color := ProgrammColor;
  panel6.Font.Name := ProgrammFontName;
  panel6.Font.Size := ProgrammFontSize;
  panel6.Font.Color := ProgrammFontColor;

//  for i := 0 to fmmain.ComponentCount - 1 do
//    if (fmmain.Components[i] is TGroupBox) and
//      (fmmain.Components[i].Tag <> 1) then
//    begin
//      myLabel := TLabel.Create(fmmain.Components[i]);
//      myLabel.Parent := fmmain.Components[i] as TGroupBox;
//      myLabel.Font := (fmmain.Components[i] as TGroupBox).Font;
//      myLabel.Caption := (fmmain.Components[i] as TGroupBox).Caption;
//      myLabel.Transparent := False;
//      myLabel.Left := 8;
//      myLabel.Top := 0;
//      fmmain.Components[i].Tag := 1;
//    end;

  GroupBox1.Color := ProgrammColor;
  GroupBox1.Font.Name := ProgrammFontName;
  GroupBox1.Font.Size := ProgrammFontSize;
  GroupBox1.Font.Color := ProgrammFontColor;
  //GroupBox1.Repaint;

  GroupBox2.Color := ProgrammColor;
  GroupBox2.Font.Name := ProgrammFontName;
  GroupBox2.Font.Size := ProgrammFontSize;
  GroupBox2.Font.Color := ProgrammFontColor;

  GroupBox3.Color := ProgrammColor;
  GroupBox3.Font.Name := ProgrammFontName;
  GroupBox3.Font.Size := ProgrammFontSize;
  GroupBox3.Font.Color := ProgrammFontColor;

  GroupBox4.Color := ProgrammColor;
  GroupBox4.Font.Name := ProgrammFontName;
  GroupBox4.Font.Size := ProgrammFontSize;
  GroupBox4.Font.Color := ProgrammFontColor;

  FicheroM:=OpenFileMapping(FILE_MAP_ALL_ACCESS, False,'MiFichero');
  { Если нет, то ошибка }
  if FicheroM = 0 then  FicheroM:=CreateFileMapping( $FFFFFFFF,nil,PAGE_READWRITE,0,SizeOf(TCompartido),'MiFichero');
  // если создается файл, заполним его нулями
  if FicheroM=0 then raise Exception.Create( 'Не удалось создать файл'+'/Ошибка при создании файла');
  Compartido:=MapViewOfFile(FicheroM,FILE_MAP_WRITE,0,0,0);
  compartido^.Manejador2:=Handle;
  compartido^.Cadena:='request';

  MySinhro := chltc;

  //trim(GetSerialPortNames(cbComPort.Items));
  AppPath:=extractfilepath(Application.ExeName);
  AppName:=extractfilename(Application.ExeName);
  AppExt:=extractfileext(Application.ExeName);
  AppName:=Copy(AppName,1,length(AppName)-length(AppExt));
  ReadIniFile(AppPath+AppName+SerialNumber + '.ini');
  Caption := 'Модуль управления устройствами: ' + '  S/N: ' + SerialNumber + '   ID=' + inttostr(ManagerNumber);
//Устанавливаем иконку программы
  SetIconApplication(image1, ManagerNumber);
//Инициализируем последовательный порт
  ComportInit;

  //fmMain.StatusBar1.Panels[0].Text:='Порт не инициализирован';

 // if cbComPort.Items.Count>0 then cbComPort.ItemIndex:=cbComPort.Items.IndexOf(port422name);



  MyTimer:=THRTimer.Create;
  MyThread:=TMyThread.Create(False);
  MyThread.Priority:=tpTimeCritical;//tpHighest;


  SetProcessWorkingSetSize(GetCurrentProcess,$FFFFFFFF,$FFFFFFFF);

  DrawProtocolStatus;
  InfoWEB.Draw(FmMain.imgWeb.Canvas,25);
  FmMain.imgWeb.Repaint;

  ShownOnce := False;
  CreateTrayIcon(1);
  //if CheckBox3.checked then begin
    fmMain.WindowState:=wsMinimized;
    Application.ShowMainForm := False;
    ShowWindow(Application.Handle, SW_HIDE);
    HideItem.Enabled := False;
    //Button1Click(nil);
  //end;
  Timer1.Enabled:=true;
  //FmMain.Memo2.Clear;
  MyTimer.StartTimer;
  CurrDt:=now;
//отладка +++++++++++++++++++++++++++++++++++
  LoadAProtocolFromFile(AppPath+'AProtocol1.txt');
  LoadProtocol('AListProtocols.txt','TLDevices',INFOTypeDevice, INFOVendor, INFODevice, INFOProt);
//отладка +++++++++++++++++++++++++++++++++++
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  UnmapViewOfFile(Compartido);
  CloseHandle(FicheroM);
  MyThread.Free;
  MyThread:=nil;
end;

procedure TfmMain.FormHide(Sender: TObject);
begin
  WriteIniFile(AppPath+AppName+'.ini');
end;

procedure TfmMain.ComportDialogOpen;
var lpcc : _COMMCONFIG;
    sz : dword;
    notstart : boolean;
    tempport : integer;
begin
  try
  if CommThreadExists then begin
    GetCommConfig(hport,&lpcc,sz);
    CommConfigDialog(PChar(port422Name),fmMain.Handle, &lpcc);
    SetCommConfig(hport,&lpcc,SizeOf(lpcc));
  end else begin
    tempPort := CreateFile(Pchar(port422Name),
                        GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE,
                        nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if tempport<=0 then begin
       MessageDlg('Не удалось активировать порт ' + port422Name + '.'
             + #10#13 + 'Возможно он отрыт в другой программе.', mtInformation,[mbOk], 0, mbOk);
    end else begin;
      GetCommConfig(tempport,&lpcc,sz);
      CommConfigDialog(PChar(port422Name),fmMain.Handle, &lpcc);
      SetCommConfig(tempport,&lpcc,SizeOf(lpcc));
    end;
    CloseHandle(tempPort);
  end;
  except
    MessageDlg('Ошибка обращения к порту ' + port422Name + '.',
                mtInformation,[mbOk], 0, mbOk);
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

procedure TfmMain.SpeedButton4Click(Sender: TObject);
begin
  setoptions;
end;

procedure TfmMain.SpeedButton8Click(Sender: TObject);
var
 str1 : ansistring;
 url : ansistring;
 slist1 : tstringlist;
begin
  //FmMain.Memo2.Clear;
  InfoWEB.SetData(1,'00:00:00:00');
  CurrDt:=now;
  MyTLEdit.Clear;
  url := URLServer;
  str1 := GetJsonStrFromWeb(url);
  if trim(str1)<>''
    then InfoProtocol.SetData('Статус:','Доступен')
    else InfoProtocol.SetData('Статус:','Не доступен');
  MyTLEdit.LoadFromJSONstr(str1);
end;

procedure TfmMain.Timer1Timer(Sender: TObject);
var lstrs : string;
begin
   if port422select then begin
    if port422init then begin
      lstrs := trim(GetSerialPortNames(ListComports));
      if port422number>ListComports.Count-1 then begin
        port422init:=false;
        StopService;
        Info422.SetData(7,'Не инициализирован');
        //exit;
      end else begin
        Info422.SetData(7,'Активен');
        //label13.Caption:='Инициализирован порт ' + port422name + ' ';
        //exit;
      end;
    end else begin
      Info422.SetData(7,'Не инициализирован');
      ComportInit;
    end;
    DrawProtocolStatus;

    exit;
  end else begin
    DrawProtocolStatus;
  end;
end;

end.
