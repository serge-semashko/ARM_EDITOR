unit UCommon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid, uwaiting, JPEG,
  Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend,
  PasLibVlcUnit,
  vlcpl;

Type
  TGridPlayer = (grClips, grPlaylist, grDefault);
  TSinchronization = (chltc, chsystem, chnone1);
  TTypeTimeline = (tldevice, tltext, tlmedia, tlnone);

  TEventReplay = record
    Number: integer;
    SafeZone: boolean;
    Image: String;
  end;

  PCompartido = ^TCompartido;

  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero: integer;
    Shift: Double;
    State: boolean;
    Cadena: String[20];
  end;

Const
  DirProjects = 'Projects';
  DirFiles = 'Clips';
  DirLists = '\Lists';
  DirTemplates = '\Templates';
  DirClips = '\Clips';
  DirPlayLists = '\PlayLists';
  DirTemp = '\Temp';
  DirLog = '\Log';
  Alphabet =
    '0123456789абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz';

Var

  // Временно используемые параметрв для отладки программы
  // IDTL : longint = 0;     // Для формирования IDTimeline
  IDCLIPS: longint = 0; // Для формирования IDClips
  IDPROJ: longint = 0; // Для формирования IDProj
  IDPLst: longint = 0; // Для формирования IDLst
  IDTXTTmp: longint = 0; // Для формирования IDTXTTmp
  IDGRTmp: longint = 0; // Для формирования IDGRTmp
  IDEvents: longint = 0; // Для формирование IDEvents
  szFontEvents1, szFontEvents2: integer;
  dbld1, dbld2: Double; // Измерение времени выполнения модулей
  DrawTimeineInProgress: boolean = false; // Процесс рисования тайм линий
  LoadImageInProgress: boolean = false;

  FWait: TFWaiting;
  // Параметры синхронизации
  MyShift: Double = 0; // Смещение LTC относительно системного времени
  TCExists: boolean = false;
  MyShiftOld: Double = 0; // Старое смещение LTC относительно системного времени
  MyShiftDelta: Double = 0;
  MySinhro: TSinchronization = chsystem; // Тип синхронизации
  MyStartPlay: longint = -1;
  // Время старта клипа, при chnone не используется, -1 время не установлено.
  MyStartReady: boolean = false;
  // True - готовность к старту, false - старт осуществлен.
  MyRemainTime: longint = -1; // время оставшееся до запуска

  // Основные параметры программы
  MainWindowStayOnTop: boolean = false;
  MainWindowMove: boolean = true;
  MainWindowSize: boolean = true;
  MakeLogging: boolean = true;
  StepCoding: integer = 5;
  StepMouseWheel: integer = 10;
  SpeedMultiple: Double = 1;
  DepthUNDO: integer = 20;
  RowsEvents: integer = 7;
  AppPath, AppName: string;
  DefaultClipDuration: longint = 10500;
  SynchDelay: integer = 2;

  PredClipID: string = '';

  WorkDirGRTemplate: string = '';
  WorkDirTextTemplate: string = '';
  WorkDirClips: string = '';
  WorkDirSubtitors: string = '';

  PathFiles: string;
  PathProject: string;
  PathClips: string;
  PathLists: string;
  PathPlayLists: string;
  PathTemp: string;
  PathTemplates: string;
  PathLog: string;

  ProjectNumber: string;
  CurrentImageTemplate: string = '@#@';

  RowDownGridProject: integer = -1;
  RowDownGridLists: integer = -1;
  RowDownGridClips: integer = -1;
  RowDownGridImgTemplate: integer = -1;
  RowDownGridActPlayList: integer = -1;

  DeltaDateDelete: integer = 10;
  CurrentMode: boolean = false;
  MainGrid: TTypeGrid = projects;
  SecondaryGrid: TTypeGrid = empty;
  ProgrammColor: tcolor = $494747;
  ProgrammCommentColor: tcolor = clYellow;
  ProgrammFontColor: tcolor = clWhite;
  ProgrammFontName: tfontname = 'Times New Roman';
  ProgrammFontSize: integer = 10;
  ProgrammEditColor: tcolor = clWhite;
  ProgrammEditFontColor: tcolor = clBlack;
  ProgrammEditFontName: tfontname = 'Times New Roman';
  ProgrammEditFontSize: integer = 14;
  CurrentUser: string = 'Иванов И.И.';
  bmpTimeline: TBitmap;
  bmpEvents: TBitmap;
  bmpAirDevices: TBitmap;
  // Image24 : TFastDIB;

  GridPlayer: TGridPlayer = grPlaylist;
  GridPlayerRow: integer = -1;
  UpdateGridTemplate: boolean = true;

  TextRichSelect: boolean = false;

  // Основные параметры вспомогательных форм
  FormsColor: tcolor = clBackground;
  FormsFontColor: tcolor = clWhite;
  FormsFontSize: integer = 10;
  FormsSmallFont: integer = 8;
  FormsFontName: tfontname = 'Times New Roman';
  FormsEditColor: tcolor = clWindow;
  FormsEditFontColor: tcolor = clBlack;
  FormsEditFontSize: integer = 10;
  FormsEditFontName: tfontname = 'Times New Roman';

  // Основные параметры гридов
  GridBackGround: tcolor = clBlack;
  GridColorPen: tcolor = clWhite;
  GridMainFontColor: tcolor = clWhite;
  GridColorRow1: tcolor = $211F1F;
  GridColorRow2: tcolor = $201E1E;
  GridColorSelection: tcolor = $212020;
  PhraseErrorColor: tcolor = clRed;
  PhrasePlayColor: tcolor = clLime;

  GridTitleFontName: tfontname = 'Times New Roman';
  GridTitleFontColor: tcolor = clWhite;
  GridTitleFontSize: integer = 14;
  GridTitleFontBold: boolean = true;
  GridTitleFontItalic: boolean = false;
  GridTitleFontUnderline: boolean = false;
  GridFontName: tfontname = 'Times New Roman';
  GridFontColor: tcolor = clWhite;
  GridFontSize: integer = 11;
  GridFontBold: boolean = false;
  GridFontItalic: boolean = false;
  GridFontUnderline: boolean = false;
  GridSubFontName: tfontname = 'Times New Roman';
  GridSubFontColor: tcolor = clWhite;
  GridSubFontSize: integer = 9;
  GridSubFontBold: boolean = false;
  GridSubFontItalic: boolean = false;
  GridSubFontUnderline: boolean = false;
  ProjectHeightTitle: integer = 30;
  ProjectHeightRow: integer = 47;
  ProjectRowsTop: integer = 1;
  ProjectRowsHeight: integer = 21;
  ProjectRowsInterval: integer = 4;
  PLHeightTitle: integer = 0;
  PLHeightRow: integer = 47;
  PLRowsTop: integer = 1;
  PLRowsHeight: integer = 21;
  PLRowsInterval: integer = 4;
  ClipsHeightTitle: integer = 30;
  ClipsHeightRow: integer = 46;
  ClipsRowsTop: integer = 2;
  ClipsRowsHeight: integer = 20;
  ClipsRowsInterval: integer = 4;
  ListTxtHeightTitle: integer = 0;
  ListTxtHeightRow: integer = 35;
  ListTxtRowsTop: integer = 5;
  ListTxtRowsHeight: integer = 20;
  ListGRHeightTitle: integer = 0;
  ListGRHeightRow: integer = 80;
  ListGRRowsTop: integer = 8;
  ListGRRowsHeight: integer = 30;
  ListGRRowsInterval: integer = 8;
  MyCellColorTrue: tcolor = clLime;
  MyCellColorFalse: tcolor = clGray;
  MyCellColorSelect: tcolor = clRed;

  MouseInLayer2: boolean = false;
  DblClickClips: boolean;
  DblClickProject: boolean;
  DblClickLists: boolean;
  DblClickImgTemplate: boolean = false;
  DblClickGridGRTemplate: boolean = false;

  GridGrTemplateSelect: boolean = true;
  RowGridGrTemplateSelect: integer = -1;

  // Основные параметры Тайм-линий
  TLBackGround: tcolor = $211F1F;
  TLZoneNamesColor: tcolor = $505050;
  TLZoneNamesFontSize: integer = 14;
  TLZoneNamesFontColor: tcolor = clWhite;
  TLZoneNamesFontName: tfontname = 'Times New Roman';
  TLZoneNamesFontBold: boolean = false;
  TLZoneNamesFontItalic: boolean = false;
  TLZoneNamesFontUnderline: boolean = false;
  TLZoneEditFontBold: boolean = false;
  TLZoneEditFontItalic: boolean = false;
  TLZoneEditFontUnderline: boolean = false;
  TLMaxDevice: integer = 6;
  TLMaxText: integer = 5;
  TLMaxMedia: integer = 1;
  TLMaxCount: integer = 16;
  DefaultMediaColor: tcolor = $00D8A520;
  DefaultTextColor: tcolor = $00ACEAE1;
  Layer2FontColor: tcolor = $202020;
  Layer2FontSize: integer = 8;
  StatusColor: array [0 .. 4] of tcolor = (
    clRed,
    clGreen,
    clBlue,
    clYellow,
    clSilver
  );
  isZoneEditor: boolean = false;
  TLMaxFrameSize: integer = 10;
  TLPreroll: longint = 250;
  TLPostroll: longint = 3000;
  TLFlashDuration: integer = 5;
  // Основные параметры кнопок
  ProgBTNSFontName: tfontname = 'Times New Roman';
  ProgBTNSFontColor: tcolor = clWhite;
  ProgBTNSFontSize: integer = 10;
  HintBTNSFontName: tfontname = 'Times New Roman';
  HintBTNSFontColor: tcolor = clBlack;
  HintBTNSFontSize: integer = 9;
  // Основные параметры печати
  PrintSpaceLeft: Real = 5;
  PrintSpaceTop: Real = 5;
  PrintSpaceRight: Real = 5;
  PrintSpaceBottom: Real = 5;
  PrintHeadLineTop: Real = 5;
  PrintHeadLineBottom: Real = 5;

  // Procedure SetMainGridPanel(TypeGrid : TTypeGrid);
function UserExists(User, Pass: string): boolean;
function SetMainGridPanel(TypeGrid: TTypeGrid): boolean;
function TwoDigit(dig: integer): string;
// procedure SetSecondaryGrid(TypeGrid : TTypeGrid);
procedure LoadBMPFromRes(cv: tcanvas; rect: trect; width, height: integer;
  name: string);
function SmoothColor(color: tcolor; step: integer): tcolor;
Function DefineFontSizeW(cv: tcanvas; width: integer; txt: string): integer;
Function DefineFontSizeH(cv: tcanvas; height: integer): integer;
function MyDoubleToSTime(db: Double): string;
function MyDoubleToFrame(db: Double): longint;
function FramesToStr(frm: longint): string;
function FramesToShortStr(frm: longint): string;
function SecondToStr(frm: longint): string;
function SecondToShortStr(frm: longint): string;
function FramesToDouble(frm: longint): Double;
function FramesToTime(frm: longint): tdatetime;
function TimeToFrames(dt: tdatetime): longint;
function MyTimeToStr: string;
function TimeToTimeCodeStr(dt: tdatetime): string;
function StrTimeCodeToFrames(tc: string): longint;
function createunicumname: string;
procedure CreateDirectories(NewProject: string);
procedure UpdateProjectPathes(NewProject: string);
procedure initnewproject;
procedure saveoldproject;
procedure loadoldproject;
procedure LoadJpegFile(bmp: TBitmap; FileName: string);
Procedure PlayClipFromActPlaylist;
Procedure PlayClipFromClipsList;
procedure ControlPlayer;
procedure InsertEventToEditTimeline(nom: integer);
procedure MyTextRect(var cv: tcanvas; const rect: trect; Text: string);
procedure TemplateToScreen(crpos: TEventReplay);
function EraseClipInWinPrepare(ClipID: string): boolean;
procedure UpdateClipDataInWinPrepare(Grid: tstringgrid; Posi: integer;
  ClipID: string);
function SetInGridClipPosition(Grid: tstringgrid; ClipID: string): integer;
procedure ControlPlayerFastSlow(command: integer);
Procedure SetPanelTypeTL(TypeTL: TTypeTimeline; APos: integer);
procedure SetClipTimeParameters;
function MyDateTimeToStr(tm: tdatetime): string;
Procedure CheckedClipsInList(Grid: tstringgrid);
Procedure ReloadClipInList(Grid: tstringgrid; ARow: integer);
procedure SetStatusClipInPlayer(ClipID: string);
Procedure ControlPlayerTransmition(command: integer);
procedure ControlButtonsPrepare(command: integer);
procedure SwitcherVideoPanels(command: integer);
procedure ButtonsControlClipsPanel(command: integer);
procedure ButtonsControlPlayList(command: integer);
procedure ButtonsControlMedia(command: integer);
procedure ButtonsControlProjects(command: integer);
procedure ButtonControlLists(command: integer);
procedure ButtonPlaylLists(command: integer);
function TimeCodeDelta: Double;
procedure SetTypeTimeCode;
Function CTHTML(clr: tcolor): string;
procedure LoadImage(FileName: string; Image: TImage);
procedure LoadBitmap(FileName: string; bmp: TBitmap; width, height: integer;
  ClearColor: tcolor);

implementation

uses umain, uproject, uinitforms, umyfiles, utimeline, udrawtimelines,
  ugrtimelines,
  uplaylists, uactplaylist, uplayer, uimportfiles, ulock, umyundo, uimgbuttons,
  ushifttl, UShortNum, UEvSwapBuffer, UMyMessage, uairdraw, UMyMediaSwitcher,
  UGridSort, UImageTemplate, UTextTemplate, umyprint, umediacopy,
  UMyTextTemplate;
Function CTHTML(clr: tcolor): string;
var
  r, g, b: integer;
begin
  r := getrvalue(clr);
  g := getgvalue(clr);
  b := getbvalue(clr);
  result := Format('#%.2x%.2x%.2x', [r, g, b]);
end;

procedure LoadImage(FileName: string; Image: TImage);
var
  ext: string;
  Tmp, Tmp1: TFastDIB;
  tfClr: TFColor;
  Clr: longint;
begin
  Tmp := TFastDIB.Create;
  if FileExists(FileName) then
  begin
    ext := LowerCase(ExtractFileExt(FileName));
    if ext = '.bmp' then
      Tmp.LoadFromFile(FileName)
    else if (ext = '.jpg') or (ext = '.jpeg') then
      LoadJPGFile(Tmp, FileName, true);
  end
  else
  begin
    Tmp.SetSize(Image.width, Image.height, 32);
    Clr := ColorToRGB(SmoothColor(ProgrammColor, 24));
    // r := Color; g := Color shr 8; b := Color shr 16
    tfClr.r := Clr;
    tfClr.g := Clr shr 8;
    tfClr.b := Clr shr 16;
    Tmp.Clear(tfClr);
    Tmp.SetFont('Tahoma', 50);
  end;

  Tmp1 := TFastDIB.Create;
  Tmp1.SetSize(Image.width, Image.height, Tmp.Bpp);
  if Tmp1.Bpp = 8 then
  begin
    Tmp1.Colors^ := Tmp.Colors^;
    Tmp1.UpdateColors;
  end;

  Bilinear(Tmp, Tmp1);
  Tmp1.FreeHandle := false;
  Image.Picture.Bitmap.Handle := Tmp1.Handle;
  Tmp1.Free;

  Tmp.Free;
end;

procedure LoadBitmap(FileName: string; bmp: TBitmap; width, height: integer;
  ClearColor: tcolor);
var
  ext: string;
  Tmp, Tmp1: TFastDIB;
  tfClr: TFColor;
  Clr: longint;
begin
  Tmp := TFastDIB.Create;
  if FileExists(FileName) then
  begin
    ext := LowerCase(ExtractFileExt(FileName));
    if ext = '.bmp' then
      Tmp.LoadFromFile(FileName)
    else if (ext = '.jpg') or (ext = '.jpeg') then
      LoadJPGFile(Tmp, FileName, true);
  end
  else
  begin
    Tmp.SetSize(width, height, 32);
    Clr := ColorToRGB(ClearColor);
    // r := Color; g := Color shr 8; b := Color shr 16
    tfClr.r := Clr;
    tfClr.g := Clr shr 8;
    tfClr.b := Clr shr 16;
    Tmp.Clear(tfClr);
    // Tmp.SetFont('Tahoma',50);
  end;

  Tmp1 := TFastDIB.Create;
  Tmp1.SetSize(width, height, Tmp.Bpp);
  if Tmp1.Bpp = 8 then
  begin
    Tmp1.Colors^ := Tmp.Colors^;
    Tmp1.UpdateColors;
  end;

  Bilinear(Tmp, Tmp1);
  Tmp1.FreeHandle := false;
  bmp.Handle := Tmp1.Handle;
  Tmp1.Free;

  Tmp.Free;
end;

procedure SetTypeTimeCode;
var
  txt: string;
begin
  txt := '';
  if (MyStartPlay <> -1) then
    txt := 'Старт в (' + trim(FramesToStr(MyStartPlay)) + ')';
  if (MyRemainTime <> -1) and Form1.MySynhro.Checked { MyStartReady } then
    txt := 'До старта (' + trim(FramesToShortStr(MyRemainTime)) + ')';

  Form1.lbTypeTC.Caption := txt;
  // if txt<>'' then begin
  // Form1.lbTypeTC.Caption := txt;
  // end else begin
  // Form1.lbTypeTC.Caption := '';
  // end;

  // MyShift      : double = 0; //Смещение LTC относительно системного времени
  // MyShiftOld   : double = 0; //Старое смещение LTC относительно системного времени
  // MyShiftDelta : double = 0;
  // MySinhro     : TSinchronization = chnone; //Тип синхронизации
  // MyStartPlay  : longint = -1;    // Время старта клипа, при chnone не используется, -1 время не установлено.
  // MyStartReady : boolean = false; // True - готовность к старту, false - старт осуществлен.
end;

function TimeCodeDelta: Double;
begin
  result := 0;
  if MySinhro = chltc then
    result := MyShift;
end;

function UserExists(User, Pass: string): boolean;
begin
  result := false;
  if (User = 'Demo') and (Pass = 'Demo') then
    result := true;
end;

procedure SetStatusClipInPlayer(ClipID: string);
var
  i: integer;
  clpid, txt: string;
  Clr: tcolor;
begin
  try
    WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID);
    for i := 1 to Form1.GridClips.RowCount - 1 do
    begin
      if Form1.GridClips.Objects[0, i] is TGridRows then
      begin
        Clr := (Form1.GridClips.Objects[0, i] as TGridRows).MyCells[3]
          .ReadPhraseColor('Clip');
        if Clr = PhraseErrorColor then
          continue;
        clpid := trim((Form1.GridClips.Objects[0, i] as TGridRows).MyCells[3]
          .ReadPhrase('ClipID'));
        if clpid = trim(ClipID) then
          (Form1.GridClips.Objects[0, i] as TGridRows).MyCells[3].SetPhraseColor
            ('Clip', PhrasePlayColor)
        else
          (Form1.GridClips.Objects[0, i] as TGridRows).MyCells[3].SetPhraseColor
            ('Clip', GridFontColor);
      end;
    end;
    CheckedActivePlayList;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID + ' | '
        + E.Message);
  end;
end;

Procedure CheckedClipsInList(Grid: tstringgrid);
var
  i: integer;
  pth, txt: string;
begin
  try
    WriteLog('MAIN', 'UCommon.CheckedClipsInList Start Grid=' + Grid.name);
    for i := 1 to Grid.RowCount - 1 do
    begin
      if Grid.Objects[0, i] is TGridRows then
      begin
        txt := (Grid.Objects[0, i] as TGridRows).MyCells[3].ReadPhrase('File');

        if trim(txt) <> '' then
        begin
          if not FileExists(txt) then
          begin
            (Grid.Objects[0, i] as TGridRows).MyCells[3].SetPhraseColor('Clip',
              PhraseErrorColor);
            WriteLog('MAIN', 'UCommon.CheckedClipsInList-1 Grid=' + Grid.name +
              ' File=' + txt + 'Не существует');
          end
          else
            WriteLog('MAIN', 'UCommon.CheckedClipsInList Grid=' + Grid.name +
              ' File=' + txt + 'Найден');;
        end
        else
        begin
          (Grid.Objects[0, i] as TGridRows).MyCells[3].SetPhraseColor('Clip',
            PhraseErrorColor);
          WriteLog('MAIN', 'UCommon.CheckedClipsInList-2 Grid=' + Grid.name +
            ' File=' + txt + 'Не существует');
        end;
      end;
    end;
    WriteLog('MAIN', 'UCommon.CheckedClipsInList Finish Grid=' + Grid.name);
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.CheckedClipsInList Grid=' + Grid.name + ' | ' +
        E.Message);
  end;
end;

Procedure ReloadClipInList(Grid: tstringgrid; ARow: integer);
var
  txt: string;
  err: integer;
  dur: Double;
begin
  try
    WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.name + ' ARow' +
      inttostr(ARow));
    if Grid.Objects[0, ARow] is TGridRows then
    begin
      // txt := (Grid.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('File');
      // Form1.opendialog1.FileName:=txt;
      if Form1.OpenDialog1.Execute then
      begin
        if trim(Form1.OpenDialog1.FileName) <> '' then
        begin
          err := LoadVLCPlayer(Form1.OpenDialog1.FileName);
          if err <> 0 then
          begin
            ShowMessage
              ('Невозможно прочитать параметры выбранного медиафайла.');
            (Grid.Objects[0, ARow] as TGridRows).MyCells[3].SetPhraseColor
              ('Clip', clRed);
            (Grid.Objects[0, ARow] as TGridRows).MyCells[3].UpdatePhrase('File',
              'Медиа-данные отсутствуют');
            WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.name +
              ' ARow' + inttostr(ARow) + ' File=' +
              trim(Form1.OpenDialog1.FileName) + ' Медиа-данные отсутствуют');
            exit;
          end;
          (Grid.Objects[0, ARow] as TGridRows).MyCells[3].SetPhraseColor('Clip',
            GridFontColor);
          txt := CopyMediaFile(Form1.OpenDialog1.FileName, PathFiles);
          (Grid.Objects[0, ARow] as TGridRows).MyCells[3].UpdatePhrase('File',
            trim(txt));
          // pMediaPosition.get_Duration(dur);
          dur := vlcplayer.Duration;
          (Grid.Objects[0, ARow] as TGridRows).MyCells[3].UpdatePhrase
            ('Duration', MyDoubleToSTime(dur));
          WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.name +
            ' ARow' + inttostr(ARow) + ' File=' +
            trim(Form1.OpenDialog1.FileName) + ' Загружен');
        end;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.name + ' ARow' +
        inttostr(ARow) + ' | ' + E.Message);
  end;
end;

procedure SetClipTimeParameters;
begin
  try
    Form1.lbMediaKTK.Caption :=
      FramesToStr(TLParameters.Finish - TLParameters.ZeroPoint);
    Form1.lbMediaNTK.Caption :=
      FramesToStr(TLParameters.Start - TLParameters.ZeroPoint);
    Form1.lbMediaDuration.Caption :=
      FramesToStr(TLParameters.Finish - TLParameters.Start);
    Form1.lbMediaCurTK.Caption :=
      FramesToStr(TLParameters.Position - TLParameters.ZeroPoint);
    Form1.lbMediaTotalDur.Caption := FramesToStr(TLParameters.Duration);
    Form1.lbMediaKTK.Repaint;
    Form1.lbMediaNTK.Repaint;
    Form1.lbMediaDuration.Repaint;
    Form1.lbMediaCurTK.Repaint;
    Form1.lbMediaTotalDur.Repaint;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.ReloadClipInList SetClipTimeParameters | ' +
        E.Message);
  end;
end;

Procedure SetPanelTypeTL(TypeTL: TTypeTimeline; APos: integer);
begin
  try
    case TypeTL of
      tldevice:
        begin
          Form1.pnDevTL.Visible := true;
          Form1.PnTextTL.Visible := false;
          Form1.pnMediaTL.Visible := false;
          btnspanel1.Rows[0].Btns[3].Visible := true;
          btnspanel1.Rows[0].Btns[4].Visible := true;
          btnsdevicepr.BackGround := ProgrammColor;
          InitBTNSDEVICE(Form1.imgDeviceTL.Canvas,
            (Form1.GridTimeLines.Objects[0, APos] as TTimelineOptions),
            btnsdevicepr);
          WriteLog('MAIN', 'UCommon.SetPanelTypeTL TypeTL=tldevice Apos=' +
            inttostr(APos));
        end;
      tltext:
        begin
          Form1.pnDevTL.Visible := false;
          Form1.PnTextTL.Visible := true;
          Form1.pnMediaTL.Visible := false;
          btnspanel1.Rows[0].Btns[3].Visible := false;
          btnspanel1.Rows[0].Btns[4].Visible := true;
          Form1.imgTextTL.width := Form1.pnPrepareCTL.width;
          Form1.imgTextTL.Picture.Bitmap.width := Form1.imgTextTL.width;
          btnstexttl.Draw(Form1.imgTextTL.Canvas);
          WriteLog('MAIN', 'UCommon.SetPanelTypeTL TypeTL=tltext Apos=' +
            inttostr(APos));
        end;
      tlmedia:
        begin
          Form1.pnDevTL.Visible := false;
          Form1.PnTextTL.Visible := false;
          Form1.pnMediaTL.Visible := true;
          btnspanel1.Rows[0].Btns[3].Visible := false;
          btnspanel1.Rows[0].Btns[4].Visible := false;
          Form1.imgMediaTL.Picture.Bitmap.width := Form1.imgMediaTL.width;
          Form1.imgMediaTL.Picture.Bitmap.height := Form1.imgMediaTL.height;
          btnsmediatl.Top := Form1.imgMediaTL.height div 2 - 35;
          btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
          WriteLog('MAIN', 'UCommon.SetPanelTypeTL TypeTL=tlmedia Apos=' +
            inttostr(APos));
        end;
    end; // case
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.SetPanelTypeTL Apos=' + inttostr(APos) + ' | ' +
        E.Message);
  end;
end;

function SetInGridClipPosition(Grid: tstringgrid; ClipID: string): integer;
begin
  try
    WriteLog('MAIN', 'UCommon.SetInGridClipPosition Start Grid=' + Grid.name +
      ' ClipID=' + ClipID);
    result := FindClipInGrid(Grid, ClipID);
    if result = -1 then
      EraseClipInWinPrepare('')
    else
    begin
      GridPlayerRow := result;
      Grid.Row := result;
      UpdateClipDataInWinPrepare(Grid, result, ClipID);
    end;
    WriteLog('MAIN', 'UCommon.SetInGridClipPosition Finish Grid=' + Grid.name +
      ' ClipID=' + ClipID);
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.SetInGridClipPosition Grid=' + Grid.name +
        ' ClipID=' + ClipID + ' | ' + E.Message);
  end;
end;

procedure UpdateClipDataInWinPrepare(Grid: tstringgrid; Posi: integer;
  ClipID: string);
begin
  try
    WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Start Grid=' +
      Grid.name + ' ClipID=' + ClipID + ' Position=' + inttostr(Posi));
    if (trim(ClipID) = trim(Form1.lbActiveClipID.Caption)) then
    begin
      GridPlayerRow := Posi;
      WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Grid=' + Grid.name +
        ' ClipID=' + ClipID + ' GridPlayerRow=' + inttostr(Posi));
      Form1.lbNomClips.Caption := inttostr(GridPlayerRow);
      Form1.lbActiveClipID.Caption :=
        (Grid.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('ClipID');
      Form1.Label2.Caption := (Grid.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('Clip');
      Form1.lbClipName.Caption := (Grid.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('Clip');
      Form1.lbSongName.Caption := (Grid.Objects[0, GridPlayerRow] as TGridRows)
        .MyCells[3].ReadPhrase('Song');
      Form1.lbSongSinger.Caption :=
        (Grid.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('Singer');
      Form1.lbPlayerFile.Caption :=
        (Grid.Objects[0, GridPlayerRow] as TGridRows).MyCells[3]
        .ReadPhrase('File');
      SetButtonsPredNext;
    end;
    WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Finish Grid=' +
      Grid.name + ' ClipID=' + ClipID + ' Position=' + inttostr(Posi));
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Finish Grid=' +
        Grid.name + ' ClipID=' + ClipID + ' Position=' + inttostr(Posi) + ' | '
        + E.Message);
  end;
end;

function EraseClipInWinPrepare(ClipID: string): boolean;
var
  i, j: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare Start ClipID=' + ClipID);
    result := false;
    if (trim(ClipID) = trim(Form1.lbActiveClipID.Caption)) or (trim(ClipID) = '')
    then
    begin
      WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare Erase ClipID=' + ClipID);
      TLZone.ClearZone;
      Form1.lbActiveClipID.Caption := '';
      Form1.Label2.Caption := '';
      TLParameters.Start := TLParameters.Preroll;
      TLParameters.Duration := 0;
      TLParameters.Finish := TLParameters.Start + TLParameters.Duration;
      TLParameters.ZeroPoint := TLParameters.Start;
      TLParameters.Position := TLParameters.Start;
      TLParameters.EndPoint := TLParameters.Start + TLParameters.Duration;
      Form1.lbMediaNTK.Caption :=
        FramesToStr(TLParameters.Start - TLParameters.Preroll);
      Form1.lbMediaDuration.Caption :=
        FramesToStr(TLParameters.Finish - TLParameters.Start);
      Form1.lbMediaKTK.Caption :=
        FramesToStr(TLParameters.Finish - TLParameters.Preroll);
      Form1.lbMediaTotalDur.Caption := FramesToStr(TLParameters.Duration);
      Form1.lbMediaCurTK.Caption :=
        FramesToStr(TLParameters.Start - TLParameters.Preroll);
      Form1.lbNomClips.Caption := '';
      Form1.lbClipName.Caption := '';
      Form1.lbSongName.Caption := '';
      Form1.lbSongSinger.Caption := '';
      Form1.lbPlayerFile.Caption := '';
      MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '',
        'EraseClipInWinPrepare');
      Form1.Image3.Picture.Bitmap := nil;
      Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
      Form1.imgtimelines.Canvas.FillRect(Form1.imgtimelines.Canvas.ClipRect);
      bmpTimeline.Canvas.FillRect(bmpTimeline.Canvas.ClipRect);
      ClearVLCPlayer;
      TLZone.ClearZone;
      TLZone.DrawBitmap(bmpTimeline);
      TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
      Form1.imgtimelines.Repaint;
      if Form1.Image3.Visible then
        Form1.Image3.Repaint;
      ClearUNDO;
      SetStatusClipInPlayer('!!@@##$$%%^^&&**');
    end;
    WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare Finish ClipID=' + ClipID);
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare ClipID=' + ClipID + ' | '
        + E.Message);
  end;
end;

Procedure SetPathProject(IDProject: string);
begin
  PathProject := AppPath + DirProjects + '\' + IDProject;
  // PathEvents:=PathProject + '\' + DirEvents;
  PathTemp := PathProject + '\' + DirTemp;
  PathTemplates := PathProject + '\' + DirTemplates;
  WriteLog('MAIN', 'UCommon.SetPathProject IDProject=' + IDProject);
end;

function CalcTextExtent(DCHandle: integer; Text: string): TSize;
var
  CharFSize: TABCFloat;
begin
  try
    result.cx := 0;
    result.cy := 0;
    if Text = '' then
      exit;
    GetTextExtentPoint32(DCHandle, PChar(Text), Length(Text), result);
    GetCharABCWidthsFloat(DCHandle, Ord(Text[Length(Text)]),
      Ord(Text[Length(Text)]), CharFSize);
    if CharFSize.abcfC < 0 then
      result.cx := result.cx + Trunc(Abs(CharFSize.abcfC));
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.CalcTextExtent Text=' + Text + ' | ' +
        E.Message);
  end;
end;

function CalcTextWidth(DCHandle: integer; Text: string): integer;
begin
  try
    result := CalcTextExtent(DCHandle, Text).cx;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.CalcTextWidth Text=' + Text + ' | ' +
        E.Message);
  end;
end;

procedure TemplateToScreen(crpos: TEventReplay);
begin
  try
    // WriteLog('MAIN', 'UCommon.TemplateToScreen CurrentEvents : Number=' + inttostr(crpos.Number) + ' Image=' +crpos.Image);
    if crpos.Number <> -1 then
    begin
      // MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'TemplateToScreen');
      if Form1.pnImageScreen.Visible then
      begin
        if trim(CurrentImageTemplate) <> trim(crpos.Image) then
        begin
          if trim(crpos.Image) = '' then
          begin
            // Form1.Image3.Picture.Bitmap.FreeImage;
            // Form1.Image3.Canvas.Brush.Color := SmoothColor(ProgrammColor,24);
            // Form1.Image3.Canvas.Brush.Style := bsSolid;
            // Form1.Image3.Width:=Form1.pnImageScreen.Width;
            // Form1.Image3.Height:=Form1.pnImageScreen.Height;
            // Form1.Image3.Picture.Bitmap.Width:=Form1.pnImageScreen.Width;
            // Form1.Image3.Picture.Bitmap.Height:=Form1.pnImageScreen.Height;
            // Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
            // Form1.Image3.repaint;
            LoadImage(PathTemplates + '\', Form1.Image3);
            WriteLog('MAIN', 'UCommon.TemplateToScreen-1 Clear');
            // application.ProcessMessages;
          end
          else
          begin
            if FileExists(PathTemplates + '\' + trim(crpos.Image)) then
            begin
              // if Form1.Image3.Picture.Graphic is TJPEGImage then begin
              // TJPEGImage(Form1.Image3.Picture.Graphic).DIBNeeded;
              // end;
              if LoadImageInProgress then
                exit;
              try
                LoadImageInProgress := true;
                LoadImage(PathTemplates + '\' + trim(crpos.Image),
                  Form1.Image3);
                // Form1.Image3.Picture.LoadFromFile(PathTemplates + '\' + trim(crpos.Image));
                CurrentImageTemplate := crpos.Image;
              finally
              end;
              LoadImageInProgress := false;
              WriteLog('MAIN', 'UCommon.TemplateToScreen-3 : Number=' +
                inttostr(crpos.Number) + ' Image=' + crpos.Image);
              exit;
            end;
          end;
          CurrentImageTemplate := crpos.Image;
        end;
      end;
    end
    else
    begin
      if Form1.pnImageScreen.Visible then
      begin
        // Form1.Image3.Picture.Bitmap.FreeImage;
        // Form1.Image3.Canvas.Brush.Color := SmoothColor(ProgrammColor,24);
        // Form1.Image3.Canvas.Brush.Style := bsSolid;
        // Form1.Image3.Width:=Form1.pnImageScreen.Width;
        // Form1.Image3.Height:=Form1.pnImageScreen.Height;
        // Form1.Image3.Picture.Bitmap.Width:=Form1.pnImageScreen.Width;
        // Form1.Image3.Picture.Bitmap.Height:=Form1.pnImageScreen.Height;
        // Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
        // Form1.Image3.repaint;
        WriteLog('MAIN', 'UCommon.TemplateToScreen-2 Clear');
        CurrentImageTemplate := '#@@#';
        // application.ProcessMessages;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.TemplateToScreen CurrentEvents : Number=' +
        inttostr(crpos.Number) + ' Image=' + crpos.Image + ' | ' + E.Message);
  end;
end;

procedure MyTextRect(var cv: tcanvas; const rect: trect; Text: string);
var
  LR: TLogFont;
  FHOld, FHNew: HFONT;
  wdth, fntsz, sz, sz1, szc, sz2, szm: integer;
  size: TSize;
  pr: integer;
  s, s1, s2: string;
  bmp: TBitmap;
begin
  if Length(Text) <= 0 then
    exit;
  bmp := TBitmap.Create;
  try
    try
      bmp.width := rect.Right - rect.Left;
      bmp.height := rect.Bottom - rect.Top;
      bmp.Canvas.Brush.Style := bsSolid;
      bmp.Canvas.CopyRect(bmp.Canvas.ClipRect, cv, rect);
      bmp.Canvas.Font.Assign(cv.Font);
      wdth := rect.Right - rect.Left;
      GetObject(bmp.Canvas.Font.Handle, SizeOf(LR), Addr(LR));
      LR.lfHeight := rect.Bottom - rect.Top;

      szm := (wdth - Length(Text)) div Length(Text);
      LR.lfWidth := szm;
      FHNew := CreateFontIndirect(LR);
      FHOld := SelectObject(bmp.Canvas.Handle, FHNew);
      szc := bmp.Canvas.TextWidth(Text);
      FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
      DeleteObject(FHNew);

      if szc <= wdth then
      begin
        for sz := szm to 50 do
        begin
          LR.lfWidth := sz;
          FHNew := CreateFontIndirect(LR);
          FHOld := SelectObject(bmp.Canvas.Handle, FHNew);
          szc := bmp.Canvas.TextWidth(Text);
          FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
          DeleteObject(FHNew);
          if szc > wdth then
          begin
            LR.lfWidth := sz - 1;
            FHNew := CreateFontIndirect(LR);
            FHOld := SelectObject(bmp.Canvas.Handle, FHNew);
            szc := bmp.Canvas.TextWidth(Text);
            break;
          end;
        end;
      end
      else
      begin
        for sz := szm downto 1 do
        begin
          LR.lfWidth := sz;
          FHNew := CreateFontIndirect(LR);
          FHOld := SelectObject(bmp.Canvas.Handle, FHNew);
          szc := bmp.Canvas.TextWidth(Text);
          if szc <= wdth then
            break
          else
          begin
            FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
            DeleteObject(FHNew);
          end;
        end;
      end;

      sz2 := wdth - szc;
      s1 := copy(Text, 1, Length(Text) - sz2);
      s2 := copy(Text, Length(Text) - sz2 + 1, sz2);
      bmp.Canvas.Brush.Style := bsClear;
      bmp.Canvas.TextOut(0, 0, s1);
      szc := bmp.Canvas.TextWidth(s1);
      SetTextCharacterExtra(bmp.Canvas.Handle, 1);
      bmp.Canvas.TextOut(szc, 0, s2);
      bitblt(cv.Handle, rect.Left, rect.Top, rect.Right - rect.Left,
        rect.Bottom - rect.Top, bmp.Canvas.Handle, 0, 0, SRCCOPY);
      SetTextCharacterExtra(bmp.Canvas.Handle, 0);
      FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
      DeleteObject(FHNew);
    finally
      bmp.Free;
      bmp := nil;
    end;
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyTextRect : Text=' + Text + ' | ' + E.Message);
      FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
      DeleteObject(FHNew);
      bmp.Free;
      bmp := nil;
    end
    else
    begin
      FHNew := SelectObject(bmp.Canvas.Handle, FHOld);
      DeleteObject(FHNew);
      bmp.Free;
      bmp := nil;
    end;
  end;
end;

procedure InsertEventToEditTimeline(nom: integer);
var
  ps: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.InsertEventToEditTimeline Number=' +
      inttostr(nom));
    frLock.Hide;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    if TLZone.Timelines[ps].Block then
      exit;
    case TLZone.TLEditor.TypeTL of
      tldevice:
        begin
          if nom > (Form1.GridTimeLines.Objects[0, ps + 1] as TTimelineOptions)
            .CountDev - 1 then
            exit;
          if ps <> -1 then
          begin
            TLZone.TLEditor.AddEvent(TLParameters.Position, ps + 1, nom);
            TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
            // if mode=play then exit;
            // TLZone.DrawBitmap(bmptimeline);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            WriteLog('MAIN',
              'UCommon.InsertEventToEditTimeline TypeTL=tlDevice Number=' +
              inttostr(nom));
            if vlcmode = play then
              exit;
            // TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
          end;
        end;
      tltext:
        begin
          if ps <> -1 then
          begin
            if TLParameters.Position < TLParameters.Preroll then
              exit;
            if TLParameters.Position >= TLParameters.EndPoint then
              exit;
            TLZone.TLEditor.AddEvent(TLParameters.Position, ps + 1, nom);
            TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
            // if mode=play then exit;
            // TLZone.DrawBitmap(bmptimeline);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            WriteLog('MAIN',
              'UCommon.InsertEventToEditTimeline TypeTL=tlText Number=' +
              inttostr(nom));
            if vlcmode = play then
              exit;
          end;

        end;
      tlmedia:
        begin
          if ps <> -1 then
          begin
            if TLParameters.Position <= TLParameters.Preroll then
              exit;
            if TLParameters.Position >= TLParameters.EndPoint then
              exit;
            TLZone.TLEditor.AddEvent(TLParameters.Position, ps + 1, nom);
            TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
            // if mode=play then exit;
            // TLZone.DrawBitmap(bmptimeline);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps,
              TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
            WriteLog('MAIN',
              'UCommon.InsertEventToEditTimeline TypeTL=tlMedia Number=' +
              inttostr(nom));
            if vlcmode = play then
              exit;
          end;
        end;
    end;
    TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.InsertEventToEditTimeline Number=' +
        inttostr(nom) + ' | ' + E.Message);
  end;
end;

Procedure PlayClipFromActPlaylist;
begin
  try
    Form1.sbPlayList.Font.Style := Form1.sbPlayList.Font.Style + [fsUnderline];
    MyTimer.Waiting := true;
    GridPlayer := grPlaylist;
    GridPlayerRow := Form1.GridActPlayList.Row;
    Form1.lbActiveClipID.Caption :=
      (Form1.GridActPlayList.Objects[0, GridPlayerRow] as TGridRows)
      .MyCells[3].ReadPhrase('ClipID');
    WriteLog('MAIN', 'UCommon.PlayClipFromActPlaylist ClipID=' +
      Form1.lbActiveClipID.Caption);
    LoadClipsToPlayer;
    MyTimer.Waiting := false;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.PlayClipFromActPlaylist | ' + E.Message);
  end;
end;

Procedure PlayClipFromClipsList;
begin
  try
    Form1.sbClips.Font.Style := Form1.sbClips.Font.Style + [fsUnderline];
    // MyTimer.Waiting:=true;
    GridPlayer := grClips;
    GridPlayerRow := Form1.GridClips.Row;
    PredClipID := (Form1.GridClips.Objects[0, Form1.GridClips.Row] as TGridRows)
      .MyCells[3].ReadPhrase('ClipID');
    WriteLog('MAIN', 'UCommon.PlayClipFromClipsList PredClipID=' + PredClipID);
    LoadClipsToPlayer;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.PlayClipFromClipsList | ' + E.Message);
  end;
  // MyTimer.Waiting:=false;
end;

procedure ControlPlayer;
begin
  // pMediaPosition.get_Rate(Rate);
  // mode := play;
  // StartMyTimer;
  try
    WriteLog('MAIN', 'UCommon.ControlPlayer Start');
    if vlcmode = paused then
    begin
      Rate := 1;
      WriteLog('MAIN', 'UCommon.ControlPlayer mode=paused');
      if FileExists(Form1.lbPlayerFile.Caption) then
        Rate := 1; // pMediaPosition.put_Rate(Rate);
      MediaPlay;
    end
    else
    begin
      WriteLog('MAIN', 'UCommon.ControlPlayer mode<>paused');
      Form1.MySynhro.Checked := false;
      if FileExists(Form1.lbPlayerFile.Caption) then
        Rate := 1; // pMediaPosition.get_Rate(Rate);
      if Rate <> 1 then
      begin
        Rate := 1;
        if not FileExists(Form1.lbPlayerFile.Caption) then
        begin
          pStart := FramesToDouble(TLParameters.Position);
          application.ProcessMessages;
        end;
        if FileExists(Form1.lbPlayerFile.Caption) then
          Rate := 1; // pMediaPosition.put_Rate(Rate);
      end
      else
      begin
        MediaPause;
        application.ProcessMessages;
        DrawTimeineInProgress := false;
      end;
    end;
    Form1.imgLayer0.Canvas.FillRect(Form1.imgLayer1.Canvas.ClipRect);
    Form1.imgLayer0.Repaint;
    SetMediaButtons;
    WriteLog('MAIN', 'UCommon.ControlPlayer Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.ControlPlayer | ' + E.Message);
  end;
end;

procedure LoadJpegFile(bmp: TBitmap; FileName: string);
var
  JpegIm: TJpegImage;
  wdth, hght, bwdth, bhght: integer;
  dlt: Real;
begin
  try
    WriteLog('MAIN', 'UCommon.LoadJpegFile FileName=' + FileName);
    JpegIm := TJpegImage.Create;
    try
      JpegIm.LoadFromFile(FileName);
      bmp.Assign(JpegIm);
    finally
      JpegIm.Free;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.LoadJpegFile FileName=' + FileName + ' | ' +
        E.Message);
  end;
end;

procedure loadoldproject;
var
  ps, pp: integer;
  nm: string;
begin
  try
    WriteLog('MAIN', 'UCommon.loadoldproject Start');
    initnewproject;
    SecondaryGrid := playlists;
    ps := findgridselection(Form1.gridprojects, 2);

    if ps > 0 then
    begin
      Form1.gridprojects.Row := ps;
      ProjectToPanel(ps);
      ProjectNumber := (Form1.gridprojects.Objects[0, ps] as TGridRows)
        .MyCells[3].ReadPhrase('Note');
      UpdateProjectPathes(ProjectNumber);
      LoadProjectFromDisk;
      SecondaryGrid := playlists;
      LoadGridFromFile(PathTemp + '\PlayLists.lst', Form1.GridLists);
      LoadGridFromFile(PathTemp + '\ImageTemplates.lst', Form1.GridGRTemplate);
      application.ProcessMessages;
      GridImageReload(Form1.GridGRTemplate);
      UpdateGridTemplate := true;
      LoadGridFromFile(PathTemp + '\Clips.lst', Form1.GridClips);
      CheckedClipsInList(Form1.GridClips);
      pp := findgridselection(Form1.GridLists, 2);
      if pp > 0 then
      begin
        nm := (Form1.GridLists.Objects[0, pp] as TGridRows).MyCells[3]
          .ReadPhrase('Note');
        PlaylistToPanel(pp);
        LoadGridFromFile(PathPlayLists + '\' + nm, Form1.GridActPlayList);
        CheckedClipsInList(Form1.GridActPlayList);
        Form1.lbClipActPL.Caption :=
          (Form1.GridLists.Objects[0, pp] as TGridRows).MyCells[3]
          .ReadPhrase('Name');
      end;
    end;
    Form1.GridLists.Repaint;
    Form1.GridTimeLines.Repaint;
    Form1.gridprojects.Repaint;
    Form1.GridClips.Repaint;
    Form1.GridActPlayList.Repaint;
    WriteLog('MAIN', 'UCommon.loadoldproject Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.loadoldproject | ' + E.Message);
  end;
end;

procedure saveoldproject;
var
  ps: integer;
  nm, txt: string;
begin
  try
    WriteLog('MAIN', 'UCommon.saveoldproject Start');
    ps := findgridselection(Form1.gridprojects, 2);
    if ps > 0 then
      nm := (Form1.gridprojects.Objects[0, ps] as TGridRows).MyCells[3]
        .ReadPhrase('Note');
    // SaveProjectToDisk;
    if Form1.ListBox1.ItemIndex <> -1 then
    begin
      txt := (Form1.ListBox1.Items.Objects[Form1.ListBox1.ItemIndex]
        as TMyListBoxObject).ClipID;
      SaveGridToFile(PathPlayLists + '\' + txt, Form1.GridActPlayList);
    end;
    SaveProjectToDisk;
    if Form1.GridClips.Objects[0, 1] is TGridRows then
    begin
      txt := (Form1.GridClips.Objects[0, 1] as TGridRows).MyCells[3]
        .ReadPhrase('ClipId');
      if (Form1.GridClips.RowCount = 2) and (trim(txt) = '') then
        exit;
      SaveGridToFile(PathLists + '\Clips.lst', Form1.GridClips);
    end;
    WriteLog('MAIN', 'UCommon.saveoldproject Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.saveoldproject | ' + E.Message);
  end;
end;

procedure initnewproject;
var
  i: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.initnewproject Start');
    with Form1 do
    begin
      if trim(Label2.Caption) <> '' then
      begin
        SaveClipEditingToFile(trim(Label2.Caption));
        Label2.Caption := '';
        TLZone.TLEditor.Clear;
        for i := 0 to TLZone.Count - 1 do
          TLZone.Timelines[i].Clear;
        ClearVLCPlayer;
      end;
      ProjectNumber := '';
      lbProjectName.Caption := '';
      lbpComment.Caption := '';
      lbDateStart.Caption := '';
      lbDateEnd.Caption := '';
      if FileExists(PathLists + '\Timelines.lst') then
        LoadGridTimelinesFromFile(PathLists + '\Timelines.lst',
          Form1.GridTimeLines)
      else
        InitGridTimelines;
      // ZoneNames.Update;
      InitPanelPrepare;
      GridClear(GridClips, RowGridClips);
      GridClear(GridActPlayList, RowGridClips);
      ClearPanelActPlayList;
      ClearClipsPanel;
      GridClear(GridLists, RowGridListPL);

      GridLists.Repaint;
      GridClips.Repaint;
      GridActPlayList.Repaint;
      WriteLog('MAIN', 'UCommon.initnewproject Finish');
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.initnewproject | ' + E.Message);
  end;
end;

procedure UpdateProjectPathes(NewProject: string);
begin
  try
    WriteLog('MAIN', 'UCommon.UpdateProjectPathes NewProject=' + NewProject);
    PathProject := AppPath + DirProjects + '\' + NewProject;
    PathLists := PathProject + DirLists;
    PathClips := PathProject + DirClips;
    PathTemplates := PathProject + DirTemplates;
    PathPlayLists := PathProject + DirPlayLists;
    PathTemp := PathProject + DirTemp;
    PathLog := PathProject + DirLog;
  except
    on E: Exception do
      WriteLog('MAIN', 'UCommon.UpdateProjectPathes NewProject=' + NewProject +
        ' | ' + E.Message);
  end;
end;

procedure CreateDirectories(NewProject: string);
var
  i: integer;
  ext: string;
begin
  try
    WriteLog('MAIN', 'UCommon.CreateDirectories NewProject=' + NewProject);
    AppPath := extractfilepath(application.ExeName);
    AppName := extractfilename(application.ExeName);
    ext := ExtractFileExt(application.ExeName);
    AppName := copy(AppName, 1, Length(AppName) - Length(ext));
    PathFiles := AppPath + DirFiles;
    if not DirectoryExists(PathFiles) then
      ForceDirectories(PathFiles);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathFiles=' + PathFiles);
    PathProject := AppPath + DirProjects;
    if not DirectoryExists(PathProject) then
      ForceDirectories(PathProject);
    WriteLog('MAIN', 'UCommon.CreateDirectories DirProject=' + PathProject);
    If trim(NewProject) = '' then
    begin
      WriteLog('MAIN', 'UCommon.CreateDirectories Проект не задан');
      exit;
    end;
    PathProject := AppPath + DirProjects + '\' + NewProject;
    WriteLog('MAIN', 'UCommon.CreateDirectories PathProject=' + PathProject);
    PathLists := PathProject + DirLists;
    if not DirectoryExists(PathLists) then
      ForceDirectories(PathLists);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathLists=' + PathLists);
    PathClips := PathProject + DirClips;
    if not DirectoryExists(PathClips) then
      ForceDirectories(PathClips);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathClips=' + PathClips);
    PathTemplates := PathProject + DirTemplates;
    if not DirectoryExists(PathTemplates) then
      ForceDirectories(PathTemplates);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathTemplates=' +
      PathTemplates);
    PathPlayLists := PathProject + DirPlayLists;
    if not DirectoryExists(PathPlayLists) then
      ForceDirectories(PathPlayLists);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathPlayLists=' +
      PathPlayLists);
    PathTemp := PathProject + DirTemp;
    if not DirectoryExists(PathTemp) then
      ForceDirectories(PathTemp);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathTemp=' + PathTemp);
    if MakeLogging then
    begin
      PathLog := AppPath + DirLog;
      if not DirectoryExists(PathLog) then
        ForceDirectories(PathLog);
      WriteLog('MAIN', 'UCommon.CreateDirectories PathLog=' + PathLog);
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.CreateDirectories NewProject=' + NewProject +
        ' | ' + E.Message);
  end;
end;

function createunicumname: string;
var
  YY, MN, DD: Word;
  HH, MM, SS, MS: Word;
begin
  try
    DecodeDate(Now, YY, MN, DD);
    DecodeTime(Now, HH, MM, SS, MS);
    result := inttostr(YY) + inttostr(MN) + inttostr(DD) + inttostr(HH) +
      inttostr(MM) + inttostr(SS) + inttostr(MS);
    WriteLog('MAIN', 'UCommon.createunicumname Result=' + result);
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.createunicumname | ' + E.Message);
  end;
end;

procedure LoadBMPFromRes(cv: tcanvas; rect: trect; width, height: integer;
  name: string);
var
  bmp: TBitmap;
  wdth, hght, deltx, delty: integer;
  rt: trect;
begin
  try
    if trim(name) = '' then
      exit;
    bmp := TBitmap.Create;
    bmp.LoadFromResourceName(HInstance, name);
    bmp.Transparent := true;
    rt.Left := rect.Left;
    rt.Right := rect.Right;
    rt.Top := rect.Top;
    rt.Bottom := rect.Bottom;
    wdth := rect.Right - rect.Left;
    hght := rect.Bottom - rect.Top;
    if wdth > width then
    begin
      deltx := (wdth - width) div 2;
      rt.Left := rect.Left + deltx;
      rt.Right := rect.Right - deltx;
    end;
    if hght > height then
    begin
      delty := (hght - height) div 2;
      rt.Top := rect.Top + delty;
      rt.Bottom := rect.Bottom - delty;
    end;
    cv.StretchDraw(rt, bmp);
    bmp.Free;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.LoadBMPFromRes Name=' + Name + ' | ' +
        E.Message);
  end;
end;

function TwoDigit(dig: integer): string;
begin
  try
    if (dig >= 0) and (dig <= 9) then
      result := '0' + inttostr(dig)
    else
      result := inttostr(dig);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.TwoDigit | ' + E.Message);
      result := '00';
    end
    else
      result := '00';
  end;
end;

function FramesToDouble(frm: longint): Double;
var
  HH, MM, SS, FF, dlt: longint;
begin
  try
    dlt := frm div 25;
    FF := frm mod 25;
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := (HH * 3600 + MM * 60 + SS) + (FF * 40 / 1000);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.FramesToDouble | ' + E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function FramesToTime(frm: longint): tdatetime;
var
  HH, MM, SS, FF, dlt: longint;
begin
  try
    dlt := frm div 25;
    FF := frm mod 25;
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := encodetime(HH, MM, SS, FF * 40);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.FramesToTime | ' + E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function TimeToFrames(dt: tdatetime): longint;
var
  HH, MM, SS, MS: Word;
begin
  try
    DecodeTime(dt, HH, MM, SS, MS);
    result := (HH * 3600 + MM * 60 + SS) * 25 + Trunc(MS / 40);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.TimeToFrames | ' + E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function TimeToTimeCodeStr(dt: tdatetime): string;
var
  HH, MM, SS, MS: Word;
begin
  try
    DecodeTime(dt, HH, MM, SS, MS);
    result := TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) + ':' +
      TwoDigit(Trunc(MS / 40));
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.TimeToTimeCodeStr | ' + E.Message);
      result := '00:00:00:00';
    end
    else
      result := '00:00:00:00';
  end;
end;

function MyTimeToStr: string;
var
  HH, MM, SS, MS: Word;
  dbl: Double;
begin
  try
    // DecodeTime(dt,hh,mm,ss,ms);
    // dbl := RoundTo(dt * 1000,-3);
    dbld2 := MyTimer.ReadTimer;
    result := FloatToStr(RoundTo((dbld2 - dbld1) * 1000, -3)) + 'ms';
    // result := FloatToStr(dt);
    // TwoDigit(hh) + ':' + TwoDigit(mm) + ':' + TwoDigit(ss) + ':' + inttostr(ms);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyTimeToStr | ' + E.Message);
      result := '00:00:00:000';
    end
    else
      result := '00:00:00:000';
  end;
end;

function StrTimeCodeToFrames(tc: string): longint;
var
  HH, MM, SS, MS: Word;
begin
  try
    HH := strtoint(tc[1] + tc[2]);
    MM := strtoint(tc[4] + tc[5]);
    SS := strtoint(tc[7] + tc[8]);
    MS := strtoint(tc[10] + tc[11]);
    result := (HH * 3600 + MM * 60 + SS) * 25 + MS;
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.StrTimeCodeToFrames TC=' + tc + ' | ' +
        E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function FramesToStr(frm: longint): string;
var
  ZN, HH, MM, SS, FF, dlt: longint;
  znak: char;
begin
  try
    ZN := frm;
    znak := #32;
    if frm < 0 then
    begin
      znak := '-';
      ZN := -1 * ZN;
    end;
    dlt := ZN div 25;
    FF := ZN mod 25;
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := znak + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) +
      ':' + TwoDigit(FF);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.FramesToStr | ' + E.Message);
      result := '00:00:00:00';
    end
    else
      result := '00:00:00:00';
  end;
end;

function FramesToShortStr(frm: longint): string;
var
  HH, MM, SS, FF, dlt, fr: longint;
  st: string;
begin
  try
    if frm < 0 then
    begin
      st := '-';
      fr := -1 * frm;
    end
    else
    begin
      st := '';
      fr := frm;
    end;
    dlt := fr div 25;
    FF := fr mod 25;
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    if HH <> 0 then
    begin
      result := st + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) +
        ':' + TwoDigit(FF);
      exit;
    end;
    if MM <> 0 then
    begin
      result := st + TwoDigit(MM) + ':' + TwoDigit(SS) + ':' + TwoDigit(FF);
      exit;
    end;
    result := st + TwoDigit(SS) + ':' + TwoDigit(FF);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.FramesToShortStr | ' + E.Message);
      result := '00:00';
    end
    else
      result := '00:00';
  end;
end;

function SecondToStr(frm: longint): string;
var
  HH, MM, SS, FF, dlt, fr: longint;
  st: string;
begin
  try
    if frm < 0 then
    begin
      st := '-';
      fr := -1 * frm;
    end
    else
    begin
      st := '';
      fr := frm;
    end;
    HH := fr div 3600;
    MM := fr mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    if HH <> 0 then
    begin
      result := st + inttostr(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS);
      exit;
    end;
    result := st + inttostr(MM) + ':' + TwoDigit(SS);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.SecondToStr | ' + E.Message);
      result := '00:00';
    end
    else
      result := '00:00';
  end;
end;

function SecondToShortStr(frm: longint): string;
var
  HH, MM, SS, FF, dlt, fr: longint;
  st: string;
begin
  try
    if frm < 0 then
    begin
      st := '-';
      fr := -1 * frm;
    end
    else
    begin
      st := '';
      fr := frm;
    end;
    HH := fr div 3600;
    MM := fr mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    if HH <> 0 then
    begin
      result := st + inttostr(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS);
      exit;
    end;
    if MM <> 0 then
    begin
      result := st + inttostr(MM) + ':' + TwoDigit(SS);
      exit;
    end;
    result := st + ':' + TwoDigit(SS);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.SecondToShortStr | ' + E.Message);
      result := '00:00';
    end
    else
      result := '00:00';
  end;
end;

function MyDoubleToSTime(db: Double): string;
var
  HH, MM, SS, FF, dlt: longint;
begin
  try
    dlt := Trunc(db);
    FF := Trunc((db - dlt) * 1000 / 40);
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) + ':' +
      TwoDigit(FF);
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyDoubleToSTime | ' + E.Message);
      result := '00:00:00:00';
    end
    else
      result := '00:00:00:00';
  end;
end;

function MyDoubleToFrame(db: Double): longint;
var
  HH, MM, SS, FF, dlt: longint;
begin
  try
    dlt := Trunc(db);
    FF := Trunc((db - dlt) * 1000 / 40);
    HH := dlt div 3600;
    MM := dlt mod 3600;
    SS := MM mod 60;
    MM := MM div 60;
    result := (HH * 3600 + MM * 60 + SS) * 25 + FF;
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyDoubleToFrame | ' + E.Message);
      result := 0;
    end
    else
      result := 0;
  end;
end;

function MyDateTimeToStr(tm: tdatetime): string;
var
  Hour, Min, Sec, MSec: Word;
begin
  try
    DecodeTime(tm, Hour, Min, Sec, MSec);
    result := TwoDigit(Hour) + ':' + TwoDigit(Min) + ':' + TwoDigit(Sec) + ':' +
      TwoDigit(Trunc(MSec / 40));
  except
    On E: Exception do
    begin
      WriteLog('MAIN', 'UCommon.MyDateTimeToStr | ' + E.Message);
      result := '00:00:00:00';
    end
    else
      result := '00:00:00:00';
  end;
end;

Function DefineFontSizeW(cv: tcanvas; width: integer; txt: string): integer;
var
  fntsz, sz: integer;
  bmp: TBitmap;
begin
  try
    bmp := TBitmap.Create;
    try
      result := 0;
      if bmp.Canvas.Font.size = 0 then
        bmp.Canvas.Font.size := 40;
      fntsz := cv.Font.size;
      For sz := fntsz downto 5 do
      begin
        bmp.Canvas.Font.size := sz;
        if bmp.Canvas.TextWidth(txt) < width - 4 then
          break;
      end;
      result := sz;
      // cv.Font.Size:=fntsz;
    finally
      bmp.Free;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.DefineFontSizeW | ' + E.Message);
  end;
end;

Function DefineFontSizeH(cv: tcanvas; height: integer): integer;
var
  fntsz, sz: integer;
  bmp: TBitmap;
begin
  try
    bmp := TBitmap.Create;
    try
      result := 0;
      // fntsz:=cv.Font.Size;
      // cv.Font.Size:=40;
      For sz := 40 downto 5 do
      begin
        bmp.Canvas.Font.size := sz;
        if bmp.Canvas.TextHeight('0') < height - 2 then
          break;
      end;
      result := sz;
      // cv.Font.Size:=fntsz;
    finally
      bmp.Free;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.DefineFontSizeH | ' + E.Message);
  end;
end;

function SmoothColor(color: tcolor; step: integer): tcolor;
var
  cColor: longint;
  r, g, b: Byte;
  ZN: integer;
  rm, gm, bm: Byte;
begin
  try
    cColor := ColorToRGB(color);
    r := cColor;
    g := cColor shr 8;
    b := cColor shr 16;

    if (r >= g) and (r >= b) then
    begin
      if (r + step) <= 255 then
      begin
        r := r + step;
        g := g + step;
        b := b + step;
      end
      else
      begin
        if r - step > 0 then
          r := r - step
        else
          r := 0;
        if g - step > 0 then
          g := g - step
        else
          g := 0;
        if b - step > 0 then
          b := b - step
        else
          b := 0;
      end;
      result := RGB(r, g, b);
      exit;
    end;

    if (g >= r) and (g >= b) then
    begin
      if (g + step) <= 255 then
      begin
        r := r + step;
        g := g + step;
        b := b + step;
      end
      else
      begin
        if r - step > 0 then
          r := r - step
        else
          r := 0;
        if g - step > 0 then
          g := g - step
        else
          g := 0;
        if b - step > 0 then
          b := b - step
        else
          b := 0;
      end;
      result := RGB(r, g, b);
      exit;
    end;

    if (b >= r) and (b >= g) then
    begin
      if (b + step) <= 255 then
      begin
        r := r + step;
        g := g + step;
        b := b + step;
      end
      else
      begin
        if r - step > 0 then
          r := r - step
        else
          r := 0;
        if g - step > 0 then
          g := g - step
        else
          g := 0;
        if b - step > 0 then
          b := b - step
        else
          b := 0;
      end;
      result := RGB(r, g, b);
      exit;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.SmoothColor | ' + E.Message);
  end;
end;

function SetMainGridPanel(TypeGrid: TTypeGrid): boolean;
var
  i, APos, oldcount: integer;
  clpid: string;
begin
  try
    WriteLog('MAIN', 'UCommon.SetMainGridPanel Start');
    result := true;
    if (vlcmode = play) and (GridPlayer <> grPlaylist) and
      (TypeGrid = actplaylist) then
    begin
      result := false;
      exit;
    end;
    if (trim(Form1.lbActiveClipID.Caption) = '') and Form1.PanelPrepare.Visible
    then
    begin
      for i := 0 to TLZone.Count - 1 do
      begin
        if TLZone.Timelines[i].Count > 0 then
        begin
          if MyTextMessage('Вопрос',
            'Сохранить редактируемые данные в списке клипов?', 2) then
          begin
            FImportFiles.edTotalDur.Text :=
              trim(FramesToStr(DefaultClipDuration));
            FImportFiles.edNTK.Text :=
              trim(FramesToStr(TLParameters.Start - TLParameters.Preroll));
            FImportFiles.EdDur.Text :=
              trim(FramesToStr(TLParameters.Finish - TLParameters.Start));
            FImportFiles.ExternalValue := true;
            oldcount := Form1.GridClips.RowCount;
            EditClip(-100);
            WriteLog('MAIN',
              'UCommon.SetMainGridPanel - Сохранение пустого клипа');
            if oldcount < Form1.GridClips.RowCount then
            begin
              clpid := (Form1.GridClips.Objects[0, Form1.GridClips.RowCount - 1]
                as TGridRows).MyCells[3].ReadPhrase('ClipID');
              SaveClipEditingToFile(trim(clpid));
              Form1.GridClips.Row := Form1.GridClips.RowCount - 1;
              GridPlayer := grClips;
              GridPlayerRow := Form1.GridClips.RowCount - 1;
              LoadClipsToPlayer;
            end;
          end;
          break;
        end;
      end;
    end;
    MainGrid := TypeGrid;
    With Form1 do
    begin
      PanelPrepare.Visible := false;
      PanelAir.Visible := false;
      case MainGrid of
        projects:
          begin
            PanelProject.Visible := true;
            PanelClips.Visible := false;
            PanelPlayList.Visible := false;
            sbProject.Font.Style := sbProject.Font.Style +
              [fsBold, fsUnderline];
            sbClips.Font.Style := sbClips.Font.Style - [fsBold, fsUnderline];
            sbPlayList.Font.Style := sbPlayList.Font.Style -
              [fsBold, fsUnderline];
            // SetSecondaryGrid(SecondaryGrid);
            // CheckedClipsInList(GridClips);
            // GridTimeLines.Top:= Bevel8.Top + 15;
            // GridTimeLines.Height:=imgButtonsControlProj.Top - Bevel8.Top - 25;
            ActiveControl := gridprojects;
            WriteLog('MAIN', 'UCommon.SetMainGridPanel MainGrid=projects');
          end;
        clips:
          begin
            if trim(ProjectNumber) = '' then
            begin
              MyTextMessage('Предупреждение',
                'Для начала работы необходимо выбрать/создать проект.', 1);
              exit;
            end;
            PanelProject.Visible := false;
            PanelClips.Visible := true;
            PanelPlayList.Visible := false;
            lbusesclpidlst.Caption := 'Список клипов';
            sbProject.Font.Style := sbProject.Font.Style -
              [fsBold, fsUnderline];
            sbClips.Font.Style := sbClips.Font.Style + [fsBold, fsUnderline];
            sbPlayList.Font.Style := sbPlayList.Font.Style -
              [fsBold, fsUnderline];
            ActiveControl := GridClips;
            if trim(Form1.lbActiveClipID.Caption) <> '' then
            begin
              GridPlayer := grClips;
              SetInGridClipPosition(GridClips, Form1.lbActiveClipID.Caption);
              if APos <> -1 then
                GridClipsToPanel(GridClips.Row);
            end
            else
            begin
              if GridClips.Row > 0 then
              begin
                if trim(PredClipID) <> '' then
                begin
                  GridPlayer := grClips;
                  SetInGridClipPosition(GridClips, PredClipID);
                  if APos <> -1 then
                  begin
                    GridClipsToPanel(GridClips.Row);
                    Form1.lbActiveClipID.Caption := PredClipID;
                    PlayClipFromClipsList;
                  end;
                end;
                if GridClips.Objects[0, GridClips.Row] is TGridRows then
                begin
                  GridClipsToPanel(GridClips.Row);
                end;
              end;
            end;
            // CheckedClipsInList(GridClips);
            WriteLog('MAIN', 'UCommon.SetMainGridPanel MainGrid=clips');
          end;
        actplaylist:
          begin
            if trim(ProjectNumber) = '' then
            begin
              MyTextMessage('Предупреждение',
                'Для начала работы необходимо выбрать/создать проект.', 1);
              exit;
            end;
            PanelProject.Visible := false;
            PanelClips.Visible := false;
            PanelPlayList.Visible := true;
            sbProject.Font.Style := sbProject.Font.Style -
              [fsBold, fsUnderline];
            sbClips.Font.Style := sbClips.Font.Style - [fsBold, fsUnderline];
            sbPlayList.Font.Style := sbPlayList.Font.Style +
              [fsBold, fsUnderline];
            if ListBox1.ItemIndex = -1 then
              lbusesclpidlst.Caption := 'Плей-лист: '
            else
              lbusesclpidlst.Caption := 'Плей-лист: ' +
                trim(ListBox1.Items.Strings[ListBox1.ItemIndex]);
            if trim(Form1.lbActiveClipID.Caption) <> '' then
            begin
              GridPlayer := grPlaylist;
              SetInGridClipPosition(GridActPlayList,
                Form1.lbActiveClipID.Caption);
            end;
            ActiveControl := GridActPlayList;
            WriteLog('MAIN', 'UCommon.SetMainGridPanel MainGrid=actplaylist');
          end;
      end;
      CheckedClipsInList(GridClips);
      CheckedActivePlayList;
      WriteLog('MAIN', 'UCommon.SetMainGridPanel Finish');
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.SetMainGridPanel | ' + E.Message);
  end;
end;

procedure ButtonControlLists(command: integer);
var
  s: string;
  i, res, ps, cnt: integer;
  nm: string;
  id: longint;
  cntmrk, cntdel: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonControlLists Command=' + inttostr(command));
    with Form1 do
    begin
      case command of
        0:
          begin
            ps := findgridselection(gridprojects, 2);
            if ps <= 0 then
            begin
              MyTextMessage('Сообщение', 'Добавления тайм-линии невозможно,' +
                #10#13 + 'необходимо инициализировать проект.', 1);
              exit;
            end;
            EditTimeline(-1);
            GridTimeLines.Repaint;
          end;
        1:
          begin
            ps := findgridselection(gridprojects, 2);
            if ps <= 0 then
            begin
              MyTextMessage('Сообщение', 'Добавления тайм-линии невозможно,' +
                #10#13 + 'необходимо инициализировать проект.', 1);
              exit;
            end;
            id := (GridTimeLines.Objects[0, GridTimeLines.Selection.Top]
              as TTimelineOptions).IDTimeline;
            DeleteTimeline(GridTimeLines.Selection.Top);
            if id = ZoneNames.Edit.IDTimeline then
            begin
              ZoneNames.Edit.IDTimeline :=
                (Form1.GridTimeLines.Objects[0, 1] as TTimelineOptions)
                .IDTimeline;
              ps := TLZone.FindTimeline(ZoneNames.Edit.IDTimeline);
              if ps <> -1 then
                TLZone.TLEditor.Assign(TLZone.Timelines[ps], ps);
              TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
              ZoneNames.Draw(Form1.imgTLNames.Canvas,
                Form1.GridTimeLines, true);
              MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas, 1);
              MyPanelAir.SetValues;
            end;
            GridTimeLines.Repaint;
          end;
        2:
          begin
            if (GridTimeLines.Selection.Top < 1) or
              (GridTimeLines.Selection.Top >= GridTimeLines.RowCount) then
              exit;
            EditTimeline(GridTimeLines.Selection.Top);
            GridTimeLines.Repaint;
          end;
      end; // case
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonControlLists Command=' + inttostr(command)
        + ' | ' + E.Message);
  end;
end;

procedure ButtonPlaylLists(command: integer);
var
  s: string;
  i, res, ps, cnt: integer;
  nm: string;
  id: longint;
  cntmrk, cntdel: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonPlaylLists Command=' + inttostr(command));
    with Form1 do
    begin
      case command of
        0:
          begin
            ps := findgridselection(Form1.gridprojects, 2);
            if ps = -1 then
              exit;
            EditPlaylist(-1);
            SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
            GridLists.Repaint;
            CheckedActivePlayList;
          end;
        1:
          begin
            ps := findgridselection(GridLists, 2);
            cntmrk := CountGridMarkedRows(GridLists, 1, 1);
            if cntmrk <> 0 then
            begin
              if Not MyTextMessage('Вопрос',
                'Вы действительно хотите удалить все выделенные плей-листы?', 2)
              then
                exit;
              if ps > 0 then
              begin
                if (GridLists.Objects[0, ps] as TGridRows).MyCells[1].Mark and
                  (not(GridLists.Objects[0, ps] as TGridRows).MyCells[0].Mark)
                then
                begin
                  if MyTextMessage('Вопрос',
                    'Вы действительно хотите удалить активный плей-лист?', 2)
                  then
                  begin
                    (GridLists.Objects[0, ps] as TGridRows).MyCells[2]
                      .Mark := false;
                    // lbPlaylist.Caption:='';
                    lbPLComment.Caption := '';
                    // lbPLCreate.Caption:='';
                    // lbPLEnd.Caption:='';
                    GridClear(GridActPlayList, RowGridClips);
                  end;
                end;
              end;
              cntdel := 0;
              for i := GridLists.RowCount - 1 downto 1 do
              begin
                if (GridLists.Objects[0, i] as TGridRows).MyCells[1].Mark and
                  (Not(GridLists.Objects[0, i] as TGridRows).MyCells[0].Mark)
                then
                begin
                  nm := (GridLists.Objects[0, i] as TGridRows).MyCells[3]
                    .ReadPhrase('Note');
                  cntdel := cntdel + 1;
                  nm := PathPlayLists + '\PL' + trim(nm) + '.plst';
                  if FileExists(nm) then
                    DeleteFile(nm);
                  MyGridDeleteRow(GridLists, i, RowGridListPL);
                  // SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                end;
              end;
              MyTextMessage('Сообщение', 'Выделено плей-листов ' +
                inttostr(cntmrk) + ', удалено ' + inttostr(cntdel) + '.', 1);
              SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
            end
            else
            begin
              // ps := findgridselection(gridlists, 2);
              if ps = GridLists.Row then
              begin
                if (GridLists.Objects[0, GridLists.Row] as TGridRows)
                  .MyCells[0].Mark then
                begin
                  MyTextMessage('Сообщение',
                    'Плей-лист защищен от удаления', 1);
                  exit;
                end;
                if MyTextMessage('Вопрос',
                  'Вы действительно хотите удалить активный плей-лист?', 2) then
                begin
                  nm := (GridLists.Objects[0, GridLists.Row] as TGridRows)
                    .MyCells[3].ReadPhrase('Note');
                  nm := PathPlayLists + '\PL' + trim(nm) + '.plst';
                  if FileExists(nm) then
                    DeleteFile(nm);
                  MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                  SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                  // lbPlaylist.Caption:='';
                  lbPLComment.Caption := '';
                  // lbPLCreate.Caption:='';
                  // lbPLEnd.Caption:='';
                  GridClear(GridActPlayList, RowGridClips);
                end;
              end
              else
              begin
                if MyTextMessage('Вопрос',
                  'Вы действительно хотите удалить плей-лист?', 2) then
                begin
                  nm := (GridLists.Objects[0, GridLists.Row] as TGridRows)
                    .MyCells[3].ReadPhrase('Note');
                  nm := PathPlayLists + '\PL' + trim(nm) + '.plst';
                  if FileExists(nm) then
                    DeleteFile(nm);
                  MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                  SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                end;
              end;
              if (GridLists.RowCount = 2) and (GridLists.Row = 1) and
                ((GridLists.Objects[0, GridLists.Row] as TGridRows).id <= 0)
              then
              begin
                GridClear(GridActPlayList, RowGridClips);
              end;
            end; // if1
            GridLists.Repaint;
          end;
        2:
          begin
            case SecondaryGrid of
              playlists:
                begin
                  SortMyListClear;
                  SortMyList[0].name := 'Плей-листы';
                  SortMyList[0].Field := 'Name';
                  SortMyList[0].TypeData := tstext;
                  GridSort(GridLists, 1, 3);
                end;

            end;
            GridLists.Repaint;

          end;
      end; // case
      // DrawPanelButtons(imgButtonsControlProj.Canvas, IMGPanelProjectControl,-1);
      // GridTimelines.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonPlaylLists Command=' + inttostr(command) +
        ' | ' + E.Message);
  end;
end;

procedure ButtonsControlProjects(command: integer);
var
  i, ps, setpos: integer;
  cntmrk, cntdel: integer;
  s, fp, msg, cmnt, edt: string;
  SDir, TDir: string;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonsControlProjects Command=' +
      inttostr(command));
    with Form1 do
    begin
      case command of
        0:
          begin
            CreateProject(-1);
            ps := findgridselection(gridprojects, 2);
            if ps <> -1 then
              Label15.Caption := 'Список плей-листов проекта (' +
                (gridprojects.Objects[0, ps] as TGridRows).MyCells[3]
                .ReadPhrase('Project') + ')'
            else
              Label15.Caption := 'Список плей-листов проекта';
          end;
        1:
          begin
            if trim(ProjectNumber) = '' then
              exit;
            ps := findgridselection(gridprojects, 2);
            cntmrk := CountGridMarkedRows(gridprojects, 1, 1);
            if cntmrk <> 0 then
            begin
              if Not MyTextMessage('Вопрос',
                'Вы действительно хотите удалить все выделенные проекты?', 2)
              then
                exit;
              if ps > 0 then
              begin
                if (gridprojects.Objects[0, ps] as TGridRows).MyCells[1]
                  .Mark and (not(gridprojects.Objects[0, ps] as TGridRows)
                  .MyCells[0].Mark) then
                  if not MyTextMessage('Вопрос',
                    'Вы действительно хотите удалить текущий проект?', 2) then
                    (gridprojects.Objects[0, ps] as TGridRows).MyCells[1]
                      .Mark := false;
              end;
              cntdel := 0;
              For i := gridprojects.RowCount - 1 downto 1 do
              begin
                if (gridprojects.Objects[0, i] as TGridRows).MyCells[1].Mark and
                  (not(gridprojects.Objects[0, i] as TGridRows).MyCells[0].Mark)
                then
                begin
                  s := (gridprojects.Objects[0, i] as TGridRows).MyCells[3]
                    .ReadPhrase('Note');
                  MyGridDeleteRow(gridprojects, i, RowGridProject);
                  cntdel := cntdel + 1;
                  if trim(s) <> '' then
                  begin
                    ProjectNumber := '';
                    if not KillDir(AppPath + DirProjects + '\' + s) then
                      SetTaskOnDelete(s);
                  end;
                end;
              end;
              if cntdel <> cntmrk then
                MyTextMessage('Сообщение', 'Выделено проектов ' +
                  inttostr(cntmrk) + ', удалено ' + inttostr(cntdel) + '.', 1);
            end
            else
            begin
              if (ps = gridprojects.Row) then
              begin
                if not MyTextMessage('Вопрос',
                  'Вы действительно хотите удалить текущий проект?', 2) then
                  exit;
              end
              else if not MyTextMessage('Вопрос',
                'Вы действительно хотите удалить проект?', 2) then
                exit;
              if (gridprojects.Objects[0, gridprojects.Row] as TGridRows)
                .MyCells[0].Mark then
              begin
                MyTextMessage('Сообщение',
                  'Выбранный проект защищен от удаления.', 1);
                exit;
              end;
              s := (gridprojects.Objects[0, gridprojects.Row] as TGridRows)
                .MyCells[3].ReadPhrase('Note');
              MyGridDeleteRow(gridprojects, gridprojects.Row, RowGridProject);
              if trim(s) <> '' then
              begin
                ProjectNumber := '';
                if not KillDir(AppPath + DirProjects + '\' + s) then
                  SetTaskOnDelete(s);
              end;
            end;
            initnewproject;
            ps := findgridselection(gridprojects, 2);
            if ps <> -1 then
              Label15.Caption := 'Список плей-листов проекта (' +
                (gridprojects.Objects[0, ps] as TGridRows).MyCells[3]
                .ReadPhrase('Project') + ')'
            else
              Label15.Caption := 'Список плей-листов проекта';
            if ps > 0 then
              loadoldproject;
          end;
        2:
          begin
            if trim(ProjectNumber) = '' then
              exit;
            ps := findgridselection(gridprojects, 2);
            if (gridprojects.Row > 0) and
              (gridprojects.Row < gridprojects.RowCount) then
            begin
              s := (gridprojects.Objects[0, gridprojects.Row] as TGridRows)
                .MyCells[3].ReadPhrase('Note');
              if trim(s) = '' then
                exit;
              msg := (gridprojects.Objects[0, gridprojects.Row] as TGridRows)
                .MyCells[3].ReadPhrase('Project');
              cmnt := (gridprojects.Objects[0, gridprojects.Row] as TGridRows)
                .MyCells[3].ReadPhrase('Comment');
              edt := (gridprojects.Objects[0, gridprojects.Row] as TGridRows)
                .MyCells[3].ReadPhrase('EndDate');
              if MyTextMessage('Вопрос', 'Создать копию проекта ''' + msg +
                '''?', 2) then
              begin
                if ps = gridprojects.Row then
                  if MyTextMessage('Вопрос',
                    'Копируется текущий проект. Сохранить сделанные изменения?',
                    2) then
                    saveoldproject;

                msg := GridCreateCopyName(gridprojects, 3, 'Project', msg);
                setpos := AddNewProject(msg, cmnt, edt);
                CreateDirectories(ProjectNumber);

                SDir := AppPath + DirProjects + '\' + s + '\' + DirLists;
                FullDirectoryCopy(SDir, PathLists, false, true);

                SDir := AppPath + DirProjects + '\' + s + '\' + DirTemplates;
                FullDirectoryCopy(SDir, PathTemplates, false, true);

                SDir := AppPath + DirProjects + '\' + s + '\' + DirClips;
                FullDirectoryCopy(SDir, PathClips, false, true);

                SDir := AppPath + DirProjects + '\' + s + '\' + DirPlayLists;
                FullDirectoryCopy(SDir, PathPlayLists, false, true);

                SDir := AppPath + DirProjects + '\' + s + '\' + DirTemp;
                FullDirectoryCopy(SDir, PathTemp, false, true);

                for i := 1 to gridprojects.RowCount - 1 do
                  (gridprojects.Objects[0, i] as TGridRows).MyCells[2]
                    .Mark := false;
                (gridprojects.Objects[0, gridprojects.Row] as TGridRows)
                  .MyCells[2].Mark := true;
                loadoldproject;
                ProjectToPanel(gridprojects.Row);

                Form1.ActiveControl := Form1.gridprojects;
              end;
            end;
            ps := findgridselection(gridprojects, 2);
            if ps <> -1 then
              Label15.Caption := 'Список плей-листов проекта (' +
                (gridprojects.Objects[0, ps] as TGridRows).MyCells[3]
                .ReadPhrase('Project') + ')'
            else
              Label15.Caption := 'Список плей-листов проекта';
          end;
        3:
          begin
            if trim(ProjectNumber) = '' then
              exit;
            SortMyListClear;
            SortMyList[0].name := 'Проекты';
            SortMyList[0].Field := 'Project';
            SortMyList[0].TypeData := tstext;
            SortMyList[1].name := 'Дата регистрации';
            SortMyList[1].Field := 'ImportDate';
            SortMyList[1].TypeData := tsdate;
            SortMyList[2].name := 'Дата окончания';
            SortMyList[2].Field := 'EndDate';
            SortMyList[2].TypeData := tsdate;
            GridSort(gridprojects, 1, 3);
            // SortGridAlphabet(GridProjects, 1, 3, 'Project' , false);
          end;
        4:
          begin
            if trim(ProjectNumber) = '' then
              exit;
            MyTextTemplateOptions;
          end;
        5:
          begin
            if trim(ProjectNumber) = '' then
              exit;
            EditImageTamplate;
          end;
        6:
          begin
            if trim(ProjectNumber) = '' then
              exit;
            SaveGridToFile(AppPath + DirProjects + '\' + 'ListProjects.prjt',
              gridprojects);
            saveoldproject;
          end;
      end;
      gridprojects.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonsControlProjects Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlMedia(command: integer);
var
  i, oldcount, ps, res: integer;
  crpos: TEventReplay;
  clpid: string;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonsControlMedia Command=' +
      inttostr(command));
    With Form1 do
    begin
      // if trim(Label2.Caption)='' then exit;
      ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
      if TLZone.Timelines[ps].Block then
      begin
        frLock.ShowModal;
        exit;
      end;
      SaveToUNDO;

      case command of
        0:
          if (trim(Form1.lbActiveClipID.Caption) = '') and Form1.PanelPrepare.Visible
          then
          begin
            for i := 0 to TLZone.Count - 1 do
            begin
              if TLZone.Timelines[i].Count > 0 then
              begin
                if MyTextMessage('Вопрос',
                  'Сохранить редактируемые данные в списке клипов?', 2) then
                begin
                  FImportFiles.edTotalDur.Text :=
                    trim(FramesToStr(DefaultClipDuration));
                  FImportFiles.edNTK.Text :=
                    trim(FramesToStr(TLParameters.Start -
                    TLParameters.Preroll));
                  FImportFiles.EdDur.Text :=
                    trim(FramesToStr(TLParameters.Finish - TLParameters.Start));
                  FImportFiles.ExternalValue := true;
                  oldcount := Form1.GridClips.RowCount;
                  EditClip(-100);
                  if oldcount < Form1.GridClips.RowCount then
                  begin
                    clpid := (Form1.GridClips.Objects[0,
                      Form1.GridClips.RowCount - 1] as TGridRows).MyCells[3]
                      .ReadPhrase('ClipID');
                    SaveClipEditingToFile(trim(clpid));
                    Form1.GridClips.Row := Form1.GridClips.RowCount - 1;
                    GridPlayer := grClips;
                    GridPlayerRow := Form1.GridClips.RowCount - 1;
                    CheckedActivePlayList;
                    LoadClipsToPlayer;
                  end;
                end;
                break;
              end;
            end;
          end
          else
          begin
            ps := FindClipInGrid(Form1.GridClips, Form1.lbActiveClipID.Caption);
            ReloadClipInList(Form1.GridClips, ps);
            CheckedActivePlayList;
            LoadClipsToPlayer;
          end;
        1:
          begin
            TLParameters.ZeroPoint := TLParameters.Position;
            TLParameters.Start := TLParameters.ZeroPoint;
            TLZone.TLScaler.DrawScaler(bmpTimeline.Canvas);
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
          end;
        2:
          TLParameters.Start := TLParameters.Position;
        3:
          TLParameters.Finish := TLParameters.Position;
        4:
          InsertEventToEditTimeline(-1);
        5:
          begin
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
            begin
              TLZone.TLEditor.DeleteEvent(crpos.Number);
              ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
              // TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame)
              TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
              TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
            end;
          end;
      end;
      TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
      TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonsControlMedia Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlPlayList(command: integer);
var
  i, j, res: integer;
  ps, cntmrk, cntdel: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonsControlPlayList Command=' +
      inttostr(command));
    with Form1 do
    begin
      case command of
        0:
          begin
            // SetMainGridPanel(clips);
            ps := findgridselection(Form1.gridprojects, 2);
            if ps = -1 then
              exit;

            EditPlaylist(-1);
            SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
            GridLists.Repaint;
            ListBox1.Clear;
            for i := 1 to GridLists.RowCount - 1 do
            begin
              ListBox1.Items.Add((GridLists.Objects[0, i] as TGridRows)
                .MyCells[3].ReadPhrase('Name'));
              j := ListBox1.Items.Count - 1;
              if not(ListBox1.Items.Objects[j] is TMyListBoxObject) then
                ListBox1.Items.Objects[j] := TMyListBoxObject.Create;
              (ListBox1.Items.Objects[j] as TMyListBoxObject).ClipID :=
                (GridLists.Objects[0, i] as TGridRows).MyCells[3]
                .ReadPhrase('Note');
            end;
            ps := findgridselection(GridLists, 2);
            if ps <> -1 then
              ListBox1.ItemIndex := ps - 1;
            // cbPlayListsChange(nil);
            ListBox1Click(nil);
          end;
        1:
          begin
            // SetMainGridPanel(clips);
            ps := findgridselection(Form1.gridprojects, 2);
            if ps = -1 then
              exit;
            if ListBox1.ItemIndex = -1 then
              exit;
            EditPlaylist(ListBox1.ItemIndex + 1);
            SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
            GridLists.Repaint;
            ps := ListBox1.ItemIndex;
            ListBox1.Items.Strings[ListBox1.ItemIndex] :=
              (GridLists.Objects[0, ListBox1.ItemIndex + 1] as TGridRows)
              .MyCells[3].ReadPhrase('Name');
            ListBox1.ItemIndex := ps;
            // cbPlayListsChange(nil);
            ListBox1Click(nil);
          end;
        2:
          begin
            // +++++++++++++++++++++++++
            cntmrk := CountGridMarkedRows(GridActPlayList, 1, 1);
            if cntmrk <> 0 then
            begin
              if Not MyTextMessage('Вопрос',
                'Вы действительно хотите удалить все выделенные клипы?', 2) then
                exit;
              cntdel := 0;
              For i := GridActPlayList.RowCount - 1 downto 1 do
              begin
                if (GridActPlayList.Objects[0, i] as TGridRows).MyCells[1]
                  .Mark and (not(GridActPlayList.Objects[0, i] as TGridRows)
                  .MyCells[0].Mark) then
                begin
                  cntdel := cntdel + 1;
                  EraseClipInWinPrepare
                    ((GridActPlayList.Objects[0, i] as TGridRows).MyCells[3]
                    .ReadPhrase('ClipID'));
                  MyGridDeleteRow(GridActPlayList, i, RowGridClips);
                end;
              end;
              GridActPlayList.Repaint;
              MyTextMessage('Сообщение', 'Выделено клипов ' + inttostr(cntmrk) +
                ', удалено ' + inttostr(cntdel) + '.', 1);
            end
            else
            begin
              if (GridActPlayList.Objects[0, GridActPlayList.Row] as TGridRows)
                .MyCells[0].Mark then
              begin
                MyTextMessage('Сообщение', 'Клип защищен от удаления.', 1);
                exit;
              end;
              if MyTextMessage('Вопрос',
                'Вы действительно хотите удалить выбранный клип?', 2) then
              begin
                EraseClipInWinPrepare
                  ((GridActPlayList.Objects[0, GridActPlayList.Row]
                  as TGridRows).MyCells[3].ReadPhrase('ClipID'));
                MyGridDeleteRow(GridActPlayList, GridActPlayList.Row,
                  RowGridClips);
              end;
            end;
            // +++++++++++++++++++++++++
            SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
            if ListBox1.ItemIndex <> -1 then
            begin
              CheckedActivePlayList;
            end;
          end;
        3:
          PlayClipFromActPlaylist;
      end; // case
      GridActPlayList.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonsControlPlayList Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlClipsPanel(command: integer);
var
  i, res: integer;
  nm, txt: string;
  ps, cntmrk, cntdel: integer;
begin
  try
    WriteLog('MAIN', 'UCommon.ButtonsControlClipsPanel Command=' +
      inttostr(command));
    with Form1 do
    begin
      if (gridprojects.RowCount = 2) and (gridprojects.Row = 1) and
        ((gridprojects.Objects[0, 1] as TGridRows).id <= 0) then
        exit;
      ps := findgridselection(gridprojects, 2);
      if ps <= 0 then
      begin
        MyTextMessage('Сообщение', 'Не выбрано ни одого проекта.', 1);
        exit;
      end;
      // res:=pnlbtnsclips.ClickButton(imgpnlbtnsclips.canvas,x,y);
      pnlbtnsclips.Enable := false;
      case command of
        0:
          begin
            EditClip(-1);
            SaveGridToFile(PathTemp + '\Clips.lst', Form1.GridClips);
            CheckedActivePlayList;
          end;
        1:
          begin
            EditClip(-100);
            SaveGridToFile(PathTemp + '\Clips.lst', Form1.GridClips);
            CheckedActivePlayList;
          end;
        5:
          begin
            // +++++++++++++++++++++++++
            cntmrk := CountGridMarkedRows(GridClips, 1, 1);
            if cntmrk <> 0 then
            begin
              if Not MyTextMessage('Вопрос',
                'Вы действительно хотите удалить все выделенные клипы?', 2) then
                exit;
              cntdel := 0;
              For i := GridClips.RowCount - 1 downto 1 do
              begin
                if (GridClips.Objects[0, i] as TGridRows).MyCells[1].Mark and
                  (not(GridClips.Objects[0, i] as TGridRows).MyCells[0].Mark)
                then
                begin
                  cntdel := cntdel + 1;
                  nm := PathClips + '\' + nm + '.clip';
                  if FileExists(nm) then
                    DeleteFile(nm);
                  EraseClipInWinPrepare((GridClips.Objects[0, i] as TGridRows)
                    .MyCells[3].ReadPhrase('ClipID'));
                  MyGridDeleteRow(GridClips, i, RowGridClips);
                end;
              end;
              if (GridClips.RowCount = 2) and (GridClips.Row = 1) and
                ((GridClips.Objects[0, GridClips.Row] as TGridRows).id <= 0)
              then
                ClearClipsPanel;
              GridClips.Repaint;
              MyTextMessage('Сообщение', 'Выделено клипов ' + inttostr(cntmrk) +
                ', удалено ' + inttostr(cntdel) + '.', 1);
            end
            else
            begin
              if (GridClips.Objects[0, GridClips.Row] as TGridRows).MyCells[0].Mark
              then
              begin
                MyTextMessage('Сообщение', 'Клип защищен от удаления.', 1);
                exit;
              end;
              if MyTextMessage('Вопрос',
                'Вы действительно хотите удалить выбранный клип?', 2) then
              begin
                nm := PathClips + '\' + nm + '.clip';
                if FileExists(nm) then
                  DeleteFile(nm);
                EraseClipInWinPrepare
                  ((GridClips.Objects[0, GridClips.Row] as TGridRows)
                  .MyCells[3].ReadPhrase('ClipID'));
                MyGridDeleteRow(GridClips, GridClips.Row, RowGridClips);
                if (GridClips.RowCount = 2) and (GridClips.Row = 1) and
                  ((GridClips.Objects[0, GridClips.Row] as TGridRows).id <= 0)
                then
                  ClearClipsPanel;
              end;
            end;
            // +++++++++++++++++++++++++
            SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
            if ListBox1.ItemIndex <> -1 then
            begin
              CheckedActivePlayList;
              // SaveGridToFile(PathPlayLists + '\' + trim(lbPLName.Caption),GridActPlayList);
            end;
          end;
        2:
          PlayClipFromClipsList;
        3:
          begin
            SortMyListClear;
            SortMyList[0].name := 'Название клипов';
            SortMyList[0].Field := 'Clip';
            SortMyList[0].TypeData := tstext;
            SortMyList[1].name := 'Название песен';
            SortMyList[1].Field := 'Song';
            SortMyList[1].TypeData := tstext;
            SortMyList[2].name := 'Исполнители';
            SortMyList[2].Field := 'Singer';
            SortMyList[2].TypeData := tstext;
            SortMyList[3].name := 'Дата регистрации';
            SortMyList[3].Field := 'ImportData';
            SortMyList[3].TypeData := tsdate;
            SortMyList[4].name := 'Дата окончания';
            SortMyList[4].Field := 'EndData';
            SortMyList[4].TypeData := tsdate;
            GridSort(GridClips, 1, 3);
          end;
        4:
          begin
            // ps := findgridselection(gridlist, 2);
            if ListBox1.ItemIndex = -1 then
            begin
              MyTextMessage('Сообщение', 'Не выбран активный плей-лист.', 1);
              exit;
            end;
            LoadClipsToPlayList;
            SetMainGridPanel(actplaylist);
            if ListBox1.ItemIndex <> -1 then
            begin
              txt := (ListBox1.Items.Objects[ListBox1.ItemIndex]
                as TMyListBoxObject).ClipID;
              SaveGridToFile(PathPlayLists + '\' + txt, GridActPlayList);
            end;
          end;
      end; // case
      pnlbtnsclips.Enable := true;
      GridClips.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ButtonsControlClipsPanel Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure SwitcherVideoPanels(command: integer);
var
  crpos: TEventReplay;
begin
  try
    WriteLog('MAIN', 'UCommon.SwitcherVideoPanels Command=' +
      inttostr(command));
    with Form1 do
    begin
      case command of
        0:
          begin
            pnImageScreen.Visible := false;
            MyMediaSwitcher.Select := 0;
          end;
        1:
          begin
            pnImageScreen.Left := pnMovie.Left;
            pnImageScreen.Top := pnMovie.Top;
            pnImageScreen.width := pnMovie.width;
            pnImageScreen.height := pnMovie.height;
            pnImageScreen.Visible := true;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'SwitcherVideoPanels-1')
            else
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '',
                'SwitcherVideoPanels-2');
            CurrentImageTemplate := 'SS@@##';
            TemplateToScreen(crpos);
            MyMediaSwitcher.Select := 1;
          end;
      end;
      MyMediaSwitcher.Draw(imgTypeMovie.Canvas);
      imgTypeMovie.Repaint;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.SwitcherVideoPanels Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ControlButtonsPrepare(command: integer);
var
  i, j, res, ps: integer;
  crpos: TEventReplay;
  tmpos: longint;
  bl: boolean;
begin
  try
    WriteLog('MAIN', 'UCommon.ControlButtonsPrepare Command=' +
      inttostr(command));
    with Form1 do
    begin
      case command of
        0:
          begin
            tmpos := TLParameters.Position;
            crpos := TLZone.TLEditor.CurrentEvents;
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            case TLZone.TLEditor.TypeTL of
              tldevice:
                begin
                  if crpos.Number = -1 then
                    exit;
                  if crpos.Number = 0 then
                  begin
                    TLZone.TLEditor.Events[crpos.Number].Start := tmpos;
                    TLZone.Timelines[ps].Events[crpos.Number].Start := tmpos;
                  end
                  else
                  begin
                    TLZone.TLEditor.Events[crpos.Number].Start := tmpos;
                    TLZone.Timelines[ps].Events[crpos.Number].Start := tmpos;
                    TLZone.TLEditor.Events[crpos.Number - 1].Finish := tmpos;
                    TLZone.Timelines[ps].Events[crpos.Number - 1]
                      .Finish := tmpos;
                  end;
                end;
              tltext:
                begin
                  if crpos.Number <> -1 then
                  begin
                    if (TLZone.TLEditor.Events[crpos.Number].Start = tmpos) and
                      (crpos.Number > 0) then
                    begin
                      TLZone.TLEditor.Events[crpos.Number - 1].Finish := tmpos;
                      TLZone.Timelines[ps].Events[crpos.Number - 1]
                        .Finish := tmpos;
                    end
                    else
                    begin
                      TLZone.TLEditor.Events[crpos.Number].Start := tmpos;
                      TLZone.Timelines[ps].Events[crpos.Number].Start := tmpos;
                    end;
                  end
                  else
                  begin
                    if TLParameters.Position > TLZone.TLEditor.Events
                      [TLZone.TLEditor.Count - 1].Finish then
                    begin
                      TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1]
                        .Finish := tmpos;
                      TLZone.Timelines[ps].Events[TLZone.TLEditor.Count - 1]
                        .Finish := tmpos;
                    end
                    else
                    begin
                      for i := 0 to TLZone.TLEditor.Count - 2 do
                      begin
                        if (TLZone.TLEditor.Events[i].Finish <=
                          TLParameters.Position) and
                          (TLZone.TLEditor.Events[i + 1].Start >
                          TLParameters.Position) then
                        begin
                          TLZone.TLEditor.Events[i].Finish := tmpos;
                          TLZone.Timelines[ps].Events[i].Finish := tmpos;
                        end;
                      end;
                    end;
                  end;;
                end;
              tlmedia:
                exit;
            end;
            // TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,0);
            TLZone.TLEditor.UpdateScreen(bmpTimeline.Canvas);
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
          end;
        1:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;

            crpos := TLZone.TLEditor.CurrentEvents;
            if (TLParameters.Position < TLZone.TLEditor.Events[0].Start) then
              crpos.Number := 0;

            case TLZone.TLEditor.TypeTL of
              tldevice:
                if crpos.Number = 0 then
                begin
                  if TLParameters.Position < TLZone.TLEditor.Events[0].Start
                  then
                  begin
                    TLZone.TLEditor.Events[0].Start := TLParameters.Position;
                    TLZone.Timelines[ps].Events[0].Start :=
                      TLParameters.Position;
                  end;
                end
                else
                begin
                  if crpos.Number < TLZone.TLEditor.Count - 1 then
                  begin
                    if TLZone.TLEditor.Events[crpos.Number]
                      .Start = TLParameters.Position then
                      exit;
                    if crpos.Number = 0 then
                    begin
                      TLZone.TLEditor.Events[crpos.Number].Start :=
                        TLParameters.Position;
                      TLZone.Timelines[ps].Events[crpos.Number].Start :=
                        TLParameters.Position;
                    end
                    else
                    begin
                      TLZone.TLEditor.Events[crpos.Number + 1].Start :=
                        TLParameters.Position;
                      TLZone.Timelines[ps].Events[crpos.Number + 1].Start :=
                        TLParameters.Position;
                      TLZone.TLEditor.Events[crpos.Number].Finish :=
                        TLParameters.Position;
                      TLZone.Timelines[ps].Events[crpos.Number].Finish :=
                        TLParameters.Position;
                    end;
                  end;
                end;
              tltext, tlmedia:
                if crpos.Number = 0 then
                begin
                  if (TLParameters.Position < TLZone.TLEditor.Events[0].Start)
                  then
                  begin
                    TLZone.TLEditor.Events[0].Start := TLParameters.Position;
                    TLZone.Timelines[ps].Events[0].Start :=
                      TLParameters.Position;
                  end
                  else
                  begin
                    TLZone.TLEditor.Events[0].Finish := TLParameters.Position;
                    TLZone.Timelines[ps].Events[0].Finish :=
                      TLParameters.Position;
                  end;
                end
                else
                begin
                  if crpos.Number = TLZone.TLEditor.Count - 1 then
                  begin
                    TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].Finish :=
                      TLParameters.Position;
                    TLZone.Timelines[ps].Events[TLZone.TLEditor.Count - 1]
                      .Finish := TLParameters.Position;
                  end
                  else
                  begin
                    for i := 0 to TLZone.TLEditor.Count - 2 do
                    begin
                      if (TLZone.TLEditor.Events[i].Finish <=
                        TLParameters.Position) and
                        (TLZone.TLEditor.Events[i + 1].Start >
                        TLParameters.Position) then
                      begin
                        TLZone.TLEditor.Events[i + 1].Start :=
                          TLParameters.Position;
                        TLZone.Timelines[ps].Events[i + 1].Start :=
                          TLParameters.Position;
                        break;
                      end
                      else
                      begin
                        if (TLZone.TLEditor.Events[i].Finish >
                          TLParameters.Position) and
                          (TLZone.TLEditor.Events[i].Start <
                          TLParameters.Position) then
                        begin
                          TLZone.TLEditor.Events[i].Finish :=
                            TLParameters.Position;
                          TLZone.Timelines[ps].Events[i].Finish :=
                            TLParameters.Position;
                          break;
                        end;
                      end;;
                    end;
                  end;
                end;
            end;

            TLZone.TLEditor.UpdateScreen(bmpTimeline.Canvas);
            for i := 0 to TLZone.Count - 1 do
              TLZone.Timelines[i].DrawTimeline(bmpTimeline.Canvas, i, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
          end;
        2:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            ShiftTimelines;
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
            for i := 0 to TLZone.Count - 1 do
              TLZone.Timelines[i].DrawTimeline(bmpTimeline.Canvas, i, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
          end;
        3:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            SetShortNumber;
            // ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
          end;
        4:
          begin
            PrintTimelines;
          end;
        5:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            evswapbuffer.Cut;
          end;
        6:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            evswapbuffer.copy;
          end;
        7:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            SaveToUNDO;
            evswapbuffer.Paste;
          end;
        8:
          begin
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            if TLZone.Timelines[ps].Block then
            begin
              frLock.ShowModal;
              exit;
            end;
            bl := false;
            for i := 0 to TLZone.TLEditor.Count - 1 do
              if TLZone.TLEditor.Events[i].Select then
                bl := true;
            if bl then
            begin
              If not MyTextMessage('Вопрос',
                'Удалить выделенные значения, без возможности востановления?', 2)
              then
                exit;
              for i := TLZone.TLEditor.Count - 1 downto 0 do
                if TLZone.TLEditor.Events[i].Select then
                  TLZone.TLEditor.DeleteEvent(i);
            end
            else
            begin
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number = -1 then
                exit;
              If not MyTextMessage('Вопрос',
                'Удалить текущее значение, без возможности востановления?', 2)
              then
                exit;
              TLZone.TLEditor.DeleteEvent(crpos.Number);
            end;
            TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
            TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas, 0);
            TLZone.Timelines[ps].DrawTimeline(bmpTimeline.Canvas, ps, 0);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            if TLZone.TLEditor.TypeTL = tldevice then
            begin
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number <> -1 then
                MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                  crpos.Image, 'ControlButtonsPrepare-8');
              TemplateToScreen(crpos);
              if pnImageScreen.Visible then
                Image3.Repaint;
            end;
          end;
        9:
          begin
            LoadFromUNDO;
            ps := ZoneNames.Edit.GridPosition(Form1.GridTimeLines,
              ZoneNames.Edit.IDTimeline);
            SetPanelTypeTL((Form1.GridTimeLines.Objects[0,
              ps] as TTimelineOptions).TypeTL, ps);
            ZoneNames.Draw(imgTLNames.Canvas, Form1.GridTimeLines, true);
            TLZone.DrawBitmap(bmpTimeline);
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            if (vlcmode <> play) then
            begin
              MediaSetPosition(TLParameters.Position, false,
                'UCommon.ControlButtonsPrepare');
              MediaPause;
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number <> -1 then
                MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                  crpos.Image, 'ControlButtonsPrepare 9-1')
              else
                MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '',
                  'ControlButtonsPrepare 9-2');
              TemplateToScreen(crpos);
            end;
          end;
      end;
    end;
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ControlButtonsPrepare Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

Procedure ControlPlayerTransmition(command: integer);
var
  i, res: integer;
  crpos: TEventReplay;
  Posi: longint;
begin
  try
    WriteLog('MAIN', 'UCommon.ControlPlayerTransmition Command=' +
      inttostr(command));
    with Form1 do
    begin
      case command of
        0:
          begin
            SaveToUNDO;
            TLParameters.Position := TLParameters.Start;
            // TLParameters.ZeroPoint;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerTransmition-1');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'UCommon.ControlPlayerTransmition-0');
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.ImgEvents.Repaint;
            end;
          end;
        1:
          begin
            SaveToUNDO;
            Posi := -1;
            if TLZone.TLEditor.Count <= 0 then
              exit;
            if TLParameters.Position < TLZone.TLEditor.Events[0].Start then
              exit;
            if TLParameters.Position > TLZone.TLEditor.Events
              [TLZone.TLEditor.Count - 1].Start then
            begin
              TLParameters.Position := TLZone.TLEditor.Events
                [TLZone.TLEditor.Count - 1].Start;
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number <> -1 then
                MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                  crpos.Image, 'ControlPlayerTransmition-1');
              TemplateToScreen(crpos);
              if pnImageScreen.Visible then
                Image3.Repaint;
              MediaSetPosition(TLParameters.Position, false,
                'UCommon.ControlPlayerTransmition-1.1'); // 1
              TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
              MediaPause;
              SetClipTimeParameters;
              MyPanelAir.SetValues;
              if Form1.PanelAir.Visible then
              begin
                MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                  TLZone.TLEditor.Index);
                Form1.ImgDevices.Repaint;
                Form1.ImgEvents.Repaint;
              end;
              exit;
            end;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number = -1 then
            begin
              for i := 0 to TLZone.TLEditor.Count - 2 do
              begin
                if (TLParameters.Position >= TLZone.TLEditor.Events[i].Finish)
                  and (TLParameters.Position <= TLZone.TLEditor.Events[i + 1]
                  .Start) then
                begin
                  Posi := i;
                  break;
                end;
              end;
            end
            else if crpos.Number = 0 then
              Posi := 0
            else
              Posi := crpos.Number - 1;
            TLParameters.Position := TLZone.TLEditor.Events[Posi].Start;
            crpos := TLZone.TLEditor.CurrentEvents;
            MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
              'ControlPlayerTransmition 1-1');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'UCommon.ControlPlayerTransmition-1.2'); // 2
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.ImgEvents.Repaint;
            end;
          end;
        2:
          begin
            SaveToUNDO;
            Posi := -1;
            if TLZone.TLEditor.Count <= 0 then
              exit;
            if TLParameters.Position >= TLZone.TLEditor.Events
              [TLZone.TLEditor.Count - 1].Start then
              exit;
            if TLParameters.Position < TLZone.TLEditor.Events[0].Start then
            begin
              TLParameters.Position := TLZone.TLEditor.Events[0].Start;
              crpos := TLZone.TLEditor.CurrentEvents;
              if crpos.Number <> -1 then
                MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                  crpos.Image, 'ControlPlayerTransmition-2');
              TemplateToScreen(crpos);
              if pnImageScreen.Visible then
                Image3.Repaint;
              MediaSetPosition(TLParameters.Position, false,
                'UCommon.ControlPlayerTransmition-2.1'); // 1
              TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
              MediaPause;
              SetClipTimeParameters;
              MyPanelAir.SetValues;
              if Form1.PanelAir.Visible then
              begin
                MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                  TLZone.TLEditor.Index);
                Form1.ImgDevices.Repaint;
                Form1.ImgEvents.Repaint;
              end;
              exit;
            end;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number = -1 then
            begin
              for i := 0 to TLZone.TLEditor.Count - 2 do
              begin
                if (TLParameters.Position >= TLZone.TLEditor.Events[i].Finish)
                  and (TLParameters.Position <= TLZone.TLEditor.Events[i + 1]
                  .Start) then
                begin
                  Posi := i + 1;
                  break;
                end;
              end;
            end
            else
              Posi := crpos.Number + 1;
            TLParameters.Position := TLZone.TLEditor.Events[Posi].Start;
            crpos := TLZone.TLEditor.CurrentEvents;
            MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,
              'ControlPlayerTransmition 2-2');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'UCommon.ControlPlayerTransmition-2.2'); // 2
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.ImgEvents.Repaint;
            end;
          end;
        3:
          begin
            SaveToUNDO;
            TLParameters.Position := TLParameters.Finish;
            // TLParameters.ZeroPoint;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerTransmition-3');
            TemplateToScreen(crpos);
            if pnImageScreen.Visible then
              Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'UCommon.ControlPlayerTransmition-3');
            TLZone.DrawTimelines(imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.ImgEvents.Repaint;
            end;
          end;
      end; // case
    end; // with
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ControlPlayerTransmition Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ControlPlayerFastSlow(command: integer);
var
  crpos: TEventReplay;
  rightlimit: longint;
begin
  try
    WriteLog('MAIN', 'UCommon.ControlPlayerFastSlow Command=' +
      inttostr(command));
    case command of
      0:
        begin
          if vlcmode = play then
          begin
            SpeedMultiple := SpeedMultiple / 4;
            MediaSlow(4);
          end
          else
          begin
            if TLParameters.Position <= TLParameters.Preroll then
            begin
              TLParameters.Position := TLParameters.Preroll;
              TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
              Form1.imgtimelines.Repaint;
              exit;
            end;
            TLParameters.Position := TLParameters.Position - StepMouseWheel;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerFastSlow-0');
            TemplateToScreen(crpos);
            if Form1.pnImageScreen.Visible then
              Form1.Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'ControlPlayerFastSlow-0');
            TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.ImgEvents.Repaint;
            end;
          end;
        end;
      1:
        begin
          if vlcmode = play then
          begin
            SpeedMultiple := SpeedMultiple / 2;
            MediaSlow(2);
          end
          else
          begin
            if TLParameters.Position <= TLParameters.Preroll then
            begin
              TLParameters.Position := TLParameters.Preroll;
              TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
              Form1.imgtimelines.Repaint;
              exit;
            end;
            TLParameters.Position := TLParameters.Position - 1;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerFastSlow-1');
            TemplateToScreen(crpos);
            if Form1.pnImageScreen.Visible then
              Form1.Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'ControlPlayerFastSlow-1');
            TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.ImgEvents.Repaint;
            end;
          end;
        end;
      2:
        begin
          if vlcmode = play then
          begin
            SpeedMultiple := SpeedMultiple * 2;
            MediaFast(2);
          end
          else
          begin
            rightlimit := TLParameters.Preroll + TLParameters.Duration +
              TLParameters.Postroll -
              (TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame) +
              TLParameters.MyCursor div TLParameters.FrameSize;
            if TLParameters.Position > rightlimit then
            begin
              TLParameters.Position := rightlimit;
              TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
              Form1.imgtimelines.Repaint;
              exit;
            end;
            TLParameters.Position := TLParameters.Position + 1;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerFastSlow-2');
            TemplateToScreen(crpos);
            if Form1.pnImageScreen.Visible then
              Form1.Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'ControlPlayerFastSlow-2');
            TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.ImgEvents.Repaint;
            end;
          end;
        end;
      3:
        begin
          if vlcmode = play then
          begin
            SpeedMultiple := SpeedMultiple * 4;
            MediaFast(4);
          end
          else
          begin
            rightlimit := TLParameters.Preroll + TLParameters.Duration +
              TLParameters.Postroll -
              (TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame) +
              TLParameters.MyCursor div TLParameters.FrameSize;
            if TLParameters.Position > rightlimit then
            begin
              TLParameters.Position := rightlimit;
              TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
              Form1.imgtimelines.Repaint;
              exit;
            end;
            TLParameters.Position := TLParameters.Position + StepMouseWheel;
            crpos := TLZone.TLEditor.CurrentEvents;
            if crpos.Number <> -1 then
              MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File',
                crpos.Image, 'ControlPlayerFastSlow-3');
            TemplateToScreen(crpos);
            if Form1.pnImageScreen.Visible then
              Form1.Image3.Repaint;
            MediaSetPosition(TLParameters.Position, false,
              'ControlPlayerFastSlow-3');
            TLZone.DrawTimelines(Form1.imgtimelines.Canvas, bmpTimeline);
            MediaPause;
            SetClipTimeParameters;
            MyPanelAir.SetValues;
            if Form1.PanelAir.Visible then
            begin
              MyPanelAir.Draw(Form1.ImgDevices.Canvas, Form1.ImgEvents.Canvas,
                TLZone.TLEditor.Index);
              Form1.ImgDevices.Repaint;
              Form1.ImgEvents.Repaint;
            end;
          end;
        end;
    end; // case
  except
    On E: Exception do
      WriteLog('MAIN', 'UCommon.ControlPlayerFastSlow Command=' +
        inttostr(command) + ' | ' + E.Message);
  end;
end;

end.
