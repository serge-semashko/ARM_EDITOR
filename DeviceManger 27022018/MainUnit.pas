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
    StatusBar1: TStatusBar;
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
    Panel3: TPanel;
    Panel4: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure RestoreItemClick(Sender: TObject);
    procedure FileExitItem1Click(Sender: TObject);
    procedure HideItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
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

  procedure StartMyTimer;
  procedure StopMyTimer;
  Function ReadMyTimer : Double;

implementation

uses ComPortUnit, umychars, UMyWork, UMyInitFile, ShellApi, shlobj, registry,
    umain, UTimeline, UDrawTimelines, UGRTimelines, umyevents, uwebget, UPortOptions,
    umyinfo;

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
    while not Terminated do Synchronize(DoWork);
    //WriteLog('MAIN', 'TMyThread.Execute');
  except
    //on E: Exception do WriteLog('MAIN', 'TMyThread.Execute | ' + E.Message);
  end;
end;

procedure TMyThread.DoWork;
var curpos, delttm, mycpos1, mycpos2, myrate : longint;
    dbpr, dbcr, dps : double;
    db0, db1, db2, db3 : Int64;//double;
    crpos : TEventReplay;
    CurrTemplate, txt : string;
    dtt, dt, dts, dte, dtc : double;
    fcr, ftm, fst, fen, framestostart : longint;
    msd : double;
    CTC : string;
    dttm : tdatetime;
    msg : TMessage;
    curr, crtr, crdr, crst, crcmd, Stri : string;
    next, cmdc, sdur, sset, cmdcmd, sstart, evdur : string;
    i : integer;
begin
  try


// Если запуск воспроизведения выполнен то отображаем движение тайм-линий.
   If MyTimer.Enable then begin
     //form1.Reciviendo(msg);
     //FmMain.label6.Caption:='';

     //dbld1 := MyTimer.ReadTimer;//========

     dttm:=now;
     //FmMain.label6.Caption:=MyDateTimeToStr(now-CurrDt-TimeCodeDelta);//TimeToTimeCodeStr(dttm);//CurrDt);

     InfoWEB.SetData(0,MyDateTimeToStr(now)); //'Тайм код системы:
     InfoWEB.SetData(1,MyDateTimeToStr(now-CurrDt-TimeCodeDelta)); //'Тайм код воспроизв.:'
     InfoWEB.SetData(2,inttostr(TLParameters.Position-TLParameters.Preroll)); // 'Текущий кадр:'
     if InfoWEB.Options[0].Text<>'' then TLParameters.Position :=TLParameters.Preroll + StrTimeCodeToFrames(InfoWEB.Options[1].Text);

     //if FmMain.label6.Caption<>'' then TLParameters.Position :=TLParameters.Preroll + StrTimeCodeToFrames(FmMain.label6.Caption);
     //FmMain.label12.Caption:=inttostr(TLParameters.Position-TLParameters.Preroll);

     crpos := MyTLEdit.CurrentEvents;
     if crpos.Number<>-1 then begin

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
       end;
       sstart := FramesToStr(framestostart);
      // evdur:= FramesToStr(MyTLEdit.Events[crpos.Number].Finish - MyTLEdit.Events[crpos.Number].Start);

       //InfoWEB.Add('Тайм код системы:','00:00:00:00');
       //InfoWEB.Add('Тайм код воспроизв.:','00:00:00:00');
       //InfoWEB.Add('Текущий кадр:','');
       InfoWEB.SetData(3,inttostr(MyTLEdit.Count));  // 'Кол-во событий:'
       InfoWEB.SetData(4,inttostr(crpos.Number)); // 'Текущее событие:'
       InfoWEB.SetData(5,FramesToStr(MyTLEdit.Events[crpos.Number].Finish - MyTLEdit.Events[crpos.Number].Start)); // 'Хроном. события:'
       InfoWEB.SetData(8,curr);// 'Текущее устройство:'
       InfoWEB.SetData(9,crtr + '  Dur=' + crdr + '  Set=' + crst);// 'Тип перехода:'
       InfoWEB.SetData(10,crcmd); // 'Текущ. команда:'
       InfoWEB.SetData(7,sstart);// 'До след. события'
       if trim(cmdc)='' then cmdc:='Cut';

       InfoWEB.SetData(6,curr + '  |  ' + cmdc + '  |  ' + next);// 'Переход'
       InfoWEB.SetData(11,next); // 'След. устройство:'
       InfoWEB.SetData(12,cmdc + '  Dur=' + sdur + '  Set=' + sset); // 'Тип перехода'
       InfoWEB.SetData(13,cmdcmd); // 'След. команда:'



       if (framestostart=1) and (not istrans) then begin
         inbuff[0]:=chr(55);
         inbuff[1]:=chr(66);
         inbuff[2]:=chr(67);
         inbuff[3]:=chr(68);
         inbuff[4]:=chr(69);
         WriteBuffToPort(5);
         //Stri := '';
         //for i := 0 to 4 do Stri:=Stri+inbuff[i];
         //infoport.SetData(1,Stri);
         //infoport.SetData(2,MyDateTimeToStr(now));
         //FmMain.edWriteStr.Lines.Insert(0,cmdc);

         istrans := true;
         //application.ProcessMessages;
       end;

       //FmMain.Label8.Caption:=sstart;
       if OldList1Index<>crpos.Number then begin

         inbuff[0]:=chr(45);
         inbuff[1]:=chr(46);
         inbuff[2]:=chr(47);
         inbuff[3]:=chr(48);
         inbuff[4]:=chr(49);
         WriteBuffToPort(5);
         //Stri := '';
         //for i := 0 to 4 do Stri:=Stri+inbuff[i];
         //infoport.SetData(1,Stri);
         //infoport.SetData(2,MyDateTimeToStr(now));
         //FmMain.edWriteStr.Lines.Insert(0,curr +'--->'+ Next);
         istrans := false;
         //FmMain.memo2.Lines.Insert(0, inttostr(crpos.Number) + ')  Текущее - ' + curr + '  Следующее - ' + next +
         //                         '  Переход - ' + cmdc + '  Dur=' + sdur + '  Set=' + sset + '  ' + cmdcmd + '  ' + evdur);

       end;
       OldList1Index:=crpos.Number;


      //   crpos := TLZone.TLEditor.CurrentEvents;



     end;
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
    exit;
  end;
 
  if CommThreadExists then StopService;
  if GridFile<>'' then GridToFile(GridFile);
  if CommandFile<>'' then WorkGridToFile(CommandFile);
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
begin

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
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  UnmapViewOfFile(Compartido);
  CloseHandle(FicheroM);
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

procedure TfmMain.SpeedButton2Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TfmMain.SpeedButton4Click(Sender: TObject);
begin
  FrMyWork.Show;
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
