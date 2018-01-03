unit UCommon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid, uwaiting, JPEG;

Type
  TGridPlayer = (grClips, grPlaylist, grDefault);
  TSinchronization = (chltc, chsystem, chnone);
  TTypeTimeline = (tldevice, tltext, tlmedia, tlnone);

  TEventReplay = record
    Number : integer;
    SafeZone : boolean;
    Image : String;
  end;

  PCompartido =^TCompartido;
  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero    : Integer;
    Shift     : Double;
    State     : boolean;
    Cadena    : String[20];
  end;

Const
  DirProjects  = 'Projects';
  DirFiles = 'Clips';
  DirLists = '\Lists';
  DirTemplates = '\Templates';
  DirClips     = '\Clips';
  DirPlayLists      = '\PlayLists';
  DirTemp      = '\Temp';
  Alphabet = '0123456789абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz';

Var

//Временно используемые параметрв для отладки программы
  //IDTL : longint = 0;     // Для формирования IDTimeline
  IDCLIPS : longint = 0;  // Для формирования IDClips
  IDPROJ : longint = 0;   // Для формирования IDProj
  IDPLst : longint = 0;   // Для формирования IDLst
  IDTXTTmp : longint = 0; // Для формирования IDTXTTmp
  IDGRTmp : longint = 0;  // Для формирования IDGRTmp
  IDEvents : longint = 0; // Для формирование IDEvents
  szFontEvents1, szFontEvents2 : integer;

  FWait : TFWaiting;
//Параметры синхронизации
  MyShift      : double = 0; //Смещение LTC относительно системного времени
  TCExists     : boolean = false;
  MyShiftOld   : double = 0; //Старое смещение LTC относительно системного времени
  MyShiftDelta : double = 0;
  MySinhro     : TSinchronization = chnone; //Тип синхронизации
  MyStartPlay  : longint = -1;    // Время старта клипа, при chnone не используется, -1 время не установлено.
  MyStartReady : boolean = false; // True - готовность к старту, false - старт осуществлен.
  MyRemainTime : longint = -1;  //время оставшееся до запуска

//Основные параметры программы
  MainWindowStayOnTop : boolean = false;
  StepCoding : integer =5;
  StepMouseWheel : integer = 10;
  SpeedMultiple : double = 1;
  DepthUNDO : integer = 20;
  RowsEvents : integer = 7;
  AppPath, AppName : string;
  DefaultClipDuration : longint = 10500;

  PredClipID : string = '';

  WorkDirGRTemplate : string ='';
  WorkDirTextTemplate  : string ='';
  WorkDirClips  : string ='';
  WorkDirSubtitors  : string ='';

  PathFiles : string;
  PathProject : string;
  PathClips : string;
  PathLists : string;
  PathPlayLists : string;
  PathTemp : string;
  PathTemplates : string;

  ProjectNumber : string;
  CurrentImageTemplate : string = '@#@';

  RowDownGridProject : integer = -1;
  RowDownGridLists   : integer = -1;
  RowDownGridClips   : integer = -1;
  RowDownGridImgTemplate   : integer = -1;
  RowDownGridActPlayList : integer = -1;

  DeltaDateDelete : integer = 10;
  CurrentMode : boolean = false;
  MainGrid : TTypeGrid = projects;
  SecondaryGrid : TTypeGrid = empty;
  ProgrammColor : tcolor = $494747;
  ProgrammCommentColor : tcolor = clYellow;
  ProgrammFontColor : tcolor = clWhite;
  ProgrammFontName : tfontname = 'Times New Roman';
  ProgrammFontSize : integer = 10;
  ProgrammEditColor : tcolor = clWhite;
  ProgrammEditFontColor : tcolor = clBlack;
  ProgrammEditFontName : tfontname = 'Times New Roman';
  ProgrammEditFontSize : integer = 14;
  CurrentUser : string = 'Иванов И.И.';
  bmpTimeline : TBitmap;
  bmpEvents : TBitmap;
  bmpAirDevices : TBitmap;

  GridPlayer : TGridPlayer = grPlayList;
  GridPlayerRow  : integer = -1;
  UpdateGridTemplate : boolean = true;

  TextRichSelect : boolean = false;

//Основные параметры вспомогательных форм
  FormsColor : tcolor = clBackground;
  FormsFontColor : tcolor = clWhite;
  FormsFontSize : integer = 10;
  FormsSmallFont : integer = 8;
  FormsFontName : tfontname = 'Times New Roman';
  FormsEditColor : tcolor = clWindow;
  FormsEditFontColor : tcolor = clBlack;
  FormsEditFontSize : integer = 10;
  FormsEditFontName : tfontname = 'Times New Roman';

//Основные параметры гридов
  GridBackGround : tcolor = clBlack;
  GridColorPen : tcolor = clWhite;
  GridMainFontColor : tcolor = clWhite;
  GridColorRow1 : tcolor = $211F1F;
  GridColorRow2 : tcolor = $201E1E;
  GridColorSelection : tcolor = $212020;
  PhraseErrorColor : tcolor = clRed;
  PhrasePlayColor : tcolor = clLime;

  GridTitleFontName : tfontname = 'Times New Roman';
  GridTitleFontColor : tcolor = clWhite;
  GridTitleFontSize : Integer = 14;
  GridTitleFontBold : boolean = true;
  GridTitleFontItalic : boolean = false;
  GridTitleFontUnderline : boolean = false;
  GridFontName : tfontname = 'Times New Roman';
  GridFontColor : tcolor = clWhite;
  GridFontSize : Integer = 11;
  GridFontBold : boolean = false;
  GridFontItalic : boolean = false;
  GridFontUnderline : boolean = false;
  GridSubFontName : tfontname = 'Times New Roman';
  GridSubFontColor : tcolor = clWhite;
  GridSubFontSize : Integer = 9;
  GridSubFontBold : boolean = false;
  GridSubFontItalic : boolean = false;
  GridSubFontUnderline : boolean = false;
  ProjectHeightTitle : integer = 30;
  ProjectHeightRow : integer = 47;
  ProjectRowsTop : integer = 1;
  ProjectRowsHeight : integer = 21;
  ProjectRowsInterval : integer = 4;
  PLHeightTitle : integer = 0;
  PLHeightRow : integer = 47;
  PLRowsTop : integer = 1;
  PLRowsHeight : integer = 21;
  PLRowsInterval : integer = 4;
  ClipsHeightTitle : integer = 30;
  ClipsHeightRow : integer = 46;
  ClipsRowsTop : integer = 2;
  ClipsRowsHeight : integer = 20;
  ClipsRowsInterval : integer = 4;
  ListTxtHeightTitle : integer = 0;
  ListTxtHeightRow : integer = 35;
  ListTxtRowsTop : integer = 5;
  ListTxtRowsHeight : integer = 20;
  ListGRHeightTitle : integer = 0;
  ListGRHeightRow : integer = 80;
  ListGRRowsTop : integer = 8;
  ListGRRowsHeight : integer = 30;
  ListGRRowsInterval : integer = 8;
  MyCellColorTrue : tcolor = clLime;
  MyCellColorFalse : tcolor = clGray;
  MyCellColorSelect : tcolor = clRed;

  MouseInLayer2 : boolean = false;
  DblClickClips : boolean;
  DblClickProject : boolean;
  DblClickLists : boolean;
  DblClickImgTemplate  : boolean = false;
  DblClickGridGRTemplate : boolean = false;

  GridGrTemplateSelect : boolean = true;
  RowGridGrTemplateSelect : integer = -1;

//Основные параметры Тайм-линий
  TLBackGround : tcolor = $211F1F;
  TLZoneNamesColor : tcolor = $505050;
  TLZoneNamesFontSize : integer = 14;
  TLZoneNamesFontColor : tcolor = clWhite;
  TLZoneNamesFontName : tfontname = 'Times New Roman';
  TLZoneNamesFontBold : boolean = false;
  TLZoneNamesFontItalic : boolean = false;
  TLZoneNamesFontUnderline : boolean = false;
  TLZoneEditFontBold : boolean = false;
  TLZoneEditFontItalic : boolean = false;
  TLZoneEditFontUnderline : boolean = false;
  TLMaxDevice : integer = 6;
  TLMaxText : integer =5;
  TLMaxMedia : integer = 1;
  TLMaxCount : integer = 16;
  DefaultMediaColor : tcolor = $00d8a520;
  DefaultTextColor : tcolor = $00aceae1;
  Layer2FontColor : tcolor = $202020;
  Layer2FontSize : integer = 8;
  StatusColor : array[0..4] of tcolor = (clRed,clGreen,clBlue,clYellow,clSilver);
  isZoneEditor : boolean = false;
  TLMaxFrameSize : integer = 10;
  TLPreroll  : longint = 250;
  TLPostroll : longint = 3000;
  TLFlashDuration : integer = 5;
  //Основные параметры кнопок
  ProgBTNSFontName : tfontname = 'Times New Roman';
  ProgBTNSFontColor : tcolor = clWhite;
  ProgBTNSFontSize : Integer = 10;
  HintBTNSFontName : tfontname = 'Times New Roman';
  HintBTNSFontColor : tcolor = clBlack;
  HintBTNSFontSize : Integer = 9;
  //Основные параметры печати
  PrintSpaceLeft       : Real = 5;
  PrintSpaceTop        : Real = 5;
  PrintSpaceRight      : Real = 5;
  PrintSpaceBottom     : Real = 5;
  PrintHeadLineTop     : Real = 5;
  PrintHeadLineBottom  : Real = 5;

//Procedure SetMainGridPanel(TypeGrid : TTypeGrid);
function UserExists(User,Pass : string) : boolean;
function SetMainGridPanel(TypeGrid : TTypeGrid) : boolean;
//procedure SetSecondaryGrid(TypeGrid : TTypeGrid);
procedure LoadBMPFromRes(cv : tcanvas; rect : trect; width, height : integer; name : string);
function SmoothColor(color : tcolor; step : integer) : tcolor;
Function DefineFontSizeW(cv : TCanvas; width : integer; txt : string): integer;
Function DefineFontSizeH(cv : TCanvas; height : integer): integer;
function MyDoubleToSTime(db : Double) : string;
function MyDoubleToFrame(db : Double) : longint;
function FramesToStr(frm : longint) : string;
function FramesToShortStr(frm : longint) : string;
function SecondToStr(frm : longint) : string;
function SecondToShortStr(frm : longint) : string;
function FramesToDouble(frm : longint) : Double;
function FramesToTime(frm : longint) : tdatetime;
function TimeToFrames(dt : tdatetime) : longint;
function TimeToTimeCodeStr(dt : tdatetime) : string;
function StrTimeCodeToFrames(tc : string) : longint;
function createunicumname : string;
procedure CreateDirectories(NewProject : string);
procedure UpdateProjectPathes(NewProject : string);
procedure initnewproject;
procedure saveoldproject;
procedure loadoldproject;
procedure LoadJpegFile(bmp : tbitmap; FileName : string);
Procedure PlayClipFromActPlaylist;
Procedure PlayClipFromClipsList;
procedure ControlPlayer;
procedure InsertEventToEditTimeline(nom : integer);
procedure MyTextRect(var cv : tcanvas; const Rect : TRect; Text : string);
procedure TemplateToScreen(crpos : TEventReplay);
function EraseClipInWinPrepare(ClipID : string) : boolean;
procedure UpdateClipDataInWinPrepare(Grid : tstringgrid; Posi : integer; ClipID : string);
function SetInGridClipPosition(Grid : tstringgrid; ClipID : string) : integer;
procedure ControlPlayerFastSlow(command : integer);
Procedure SetPanelTypeTL(TypeTL : TTypeTimeline; APos : integer);
procedure SetClipTimeParameters;
function MyDateTimeToStr(tm : tdatetime) : string;
Procedure CheckedClipsInList(Grid : tstringgrid);
Procedure ReloadClipInList(Grid : tstringgrid; ARow : integer);
procedure SetStatusClipInPlayer(ClipID : string);
Procedure ControlPlayerTransmition(command : integer);
procedure ControlButtonsPrepare(command : integer);
procedure SwitcherVideoPanels(command : integer);
procedure ButtonsControlClipsPanel(Command : integer);
procedure ButtonsControlPlayList(Command : integer);
procedure ButtonsControlMedia(command : integer);
procedure ButtonsControlProjects(command : integer);
procedure ButtonControlLists(command : integer);
procedure ButtonPlaylLists(command : integer);
function TimeCodeDelta : double;
procedure SetTypeTimeCode;

implementation
uses umain, uproject, uinitforms, umyfiles, utimeline, udrawtimelines, ugrtimelines,
     uplaylists, uactplaylist, uplayer, uimportfiles, ulock, umyundo, uimgbuttons,
     ushifttl, UShortNum, UEvSwapBuffer, UMyMessage, uairdraw, UMyMediaSwitcher,
     UGridSort, UImageTemplate, UTextTemplate, umyprint, umediacopy, UMyTextTemplate;

procedure SetTypeTimeCode;
var txt : string;
begin
  txt := '';
  if (MyStartPlay<>-1) and MyStartReady then txt:='Старт в (' + trim(FramesToStr(MyStartPlay)) + ')';
  if (MyRemainTime <> -1) and MyStartReady then txt:='До старта (' + trim(FramesToShortStr(MyRemainTime)) + ')';
       case MySinhro of
 chnone   : begin
              Form1.lbTypeTC.Visible:=false;
            end;
 chsystem,
 chltc    : begin
              Form1.lbTypeTC.Visible:=true;
              if txt<>'' then begin
                Form1.lbTypeTC.Caption := txt;
              end else begin
                Form1.lbTypeTC.Caption := '';
              end;
            end;
       end;

//  MyShift      : double = 0; //Смещение LTC относительно системного времени
//  MyShiftOld   : double = 0; //Старое смещение LTC относительно системного времени
//  MyShiftDelta : double = 0;
//  MySinhro     : TSinchronization = chnone; //Тип синхронизации
//  MyStartPlay  : longint = -1;    // Время старта клипа, при chnone не используется, -1 время не установлено.
//  MyStartReady : boolean = false; // True - готовность к старту, false - старт осуществлен.
end;

function TimeCodeDelta : double;
begin
  result := 0;
  if MySinhro = chltc then result := MyShift;
end;

function UserExists(User,Pass : string) : boolean;
begin
  result:=false;
  if (User='Demo') and (Pass='Demo') then result := true;
end;

procedure SetStatusClipInPlayer(ClipID : string);
var i : integer;
    clpid, txt : string;
    clr : tcolor;
begin
  for i := 1 to Form1.GridClips.RowCount-1 do begin
    if Form1.GridClips.Objects[0,i] is TGridRows then begin
       clr := (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhraseColor('Clip');
       if clr = PhraseErrorColor then continue;
       clpid := trim((Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
       if clpid=trim(ClipID)
         then (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].SetPhraseColor('Clip', PhrasePlayColor)
         else (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].SetPhraseColor('Clip', GridFontColor);
    end;
  end;
  CheckedActivePlayList;
end;

Procedure CheckedClipsInList(Grid : tstringgrid);
var i : integer;
    pth, txt : string;
begin
  for i := 1 to Grid.RowCount-1 do begin
    if Grid.Objects[0,i] is TGridRows then begin
       txt := (Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('File');

       if Trim(txt)<>'' then begin
         if not FileExists(txt) then (Grid.Objects[0,i] as TGridRows).MyCells[3].SetPhraseColor('Clip', PhraseErrorColor);
       end else (Grid.Objects[0,i] as TGridRows).MyCells[3].SetPhraseColor('Clip', PhraseErrorColor);
    end;
  end;
end;

Procedure ReloadClipInList(Grid : tstringgrid; ARow : integer);
var txt : string;
    err : integer;
    dur : double;
begin
  if Grid.Objects[0,ARow] is TGridRows then begin
    //txt := (Grid.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('File');
    //Form1.opendialog1.FileName:=txt;
    if Form1.OpenDialog1.Execute then begin
      if trim(Form1.opendialog1.FileName)<>'' then begin
        err := CreateGraph(Form1.OpenDialog1.FileName);
        if Err<>0 then begin
          ShowMessage('Невозможно прочитать параметры выбранного медиафайла.');
          (Grid.Objects[0,ARow] as TGridRows).MyCells[3].SetPhraseColor('Clip', clRed);
          (Grid.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('File', 'Медиа-данные отсутствуют');
          exit;
        end;
        (Grid.Objects[0,ARow] as TGridRows).MyCells[3].SetPhraseColor('Clip', GridFontColor);
        txt := CopyMediaFile(Form1.Opendialog1.FileName, PathFiles);
        (Grid.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('File', trim(txt));
         pMediaPosition.get_Duration(dur);
        (Grid.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('Duration',MyDoubleToSTime(Dur));
      end;
    end;
  end;
end;

procedure SetClipTimeParameters;
begin
  Form1.lbMediaKTK.Caption:=framestostr(TLParameters.Finish - TLParameters.ZeroPoint);
  Form1.lbMediaNTK.Caption:=framestostr(TLParameters.Start - TLParameters.ZeroPoint);
  Form1.lbMediaDuration.Caption:=framestostr(TLParameters.Finish-TLParameters.Start);
  Form1.lbMediaCurTK.Caption:=framestostr(TLParameters.Position - TLParameters.ZeroPoint);
  Form1.lbMediaTotalDur.Caption:=framestostr(TLParameters.Duration);
  Form1.lbMediaKTK.Repaint;
  Form1.lbMediaNTK.Repaint;
  Form1.lbMediaDuration.Repaint;
  Form1.lbMediaCurTK.Repaint;
  Form1.lbMediaTotalDur.Repaint;
end;

Procedure SetPanelTypeTL(TypeTL : TTypeTimeline; APos : integer);
begin
         case TypeTL of
  tldevice : begin
               Form1.pnDevTL.Visible:=true;
               Form1.PnTextTL.Visible:=false;
               Form1.pnMediaTL.Visible:=false;
               btnspanel1.Rows[0].Btns[3].Visible:=true;
               btnspanel1.Rows[0].Btns[4].Visible:=true;
               btnsdevicepr.BackGround:=ProgrammColor;
               InitBTNSDEVICE(Form1.imgDeviceTL.Canvas, (Form1.GridTimeLines.Objects[0,APos] as TTimelineOptions), btnsdevicepr);
             end;
  tltext   : begin
               Form1.pnDevTL.Visible:=false;
               Form1.PnTextTL.Visible:=true;
               Form1.pnMediaTL.Visible:=false;
               btnspanel1.Rows[0].Btns[3].Visible:=false;
               btnspanel1.Rows[0].Btns[4].Visible:=true;
               Form1.imgTextTL.Width:=Form1.pnPrepareCTL.Width;
               Form1.imgTextTL.Picture.Bitmap.Width:=Form1.imgTextTL.Width;
               btnstexttl.Draw(Form1.imgTextTL.Canvas);
             end;
  tlmedia  : begin
               Form1.pnDevTL.Visible:=false;
               Form1.PnTextTL.Visible:=false;
               Form1.pnMediaTL.Visible:=true;
               btnspanel1.Rows[0].Btns[3].Visible:=false;
               btnspanel1.Rows[0].Btns[4].Visible:=false;
               Form1.imgMediaTL.Picture.Bitmap.Width := Form1.imgMediaTL.Width;
               Form1.imgMediaTL.Picture.Bitmap.Height := Form1.imgMediaTL.Height;
               btnsmediatl.Top:=Form1.imgMediaTL.Height div 2 - 35;
               btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
             end;
        end; //case
end;


function SetInGridClipPosition(Grid : tstringgrid; ClipID : string) : integer;
begin

  result := FindClipInGrid(Grid,ClipID);
  if result = -1 then EraseClipInWinPrepare('')
  else begin
    GridPlayerRow:=Result;
    Grid.Row:=result;
    UpdateClipDataInWinPrepare(Grid, result, ClipID);
  end;
end;

procedure UpdateClipDataInWinPrepare(Grid : tstringgrid; Posi : integer; ClipID : string);
begin
  if (trim(ClipID)=Trim(Form1.lbActiveClipID.Caption)) then begin
    GridPlayerRow:=Posi;
    Form1.lbNomClips.Caption:=inttostr(GridPlayerRow);
    Form1.lbActiveClipID.Caption := (Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    Form1.Label2.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbClipName.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbSongName.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
    Form1.lbSongSinger.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
    Form1.lbPlayerFile.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
    SetButtonsPredNext;
  end;
end;

function EraseClipInWinPrepare(ClipID : string) : boolean;
var i, j : integer;
begin
  result := false;
  if (trim(ClipID)=Trim(Form1.lbActiveClipID.Caption)) or (trim(ClipID)='') then begin
     TLZone.ClearZone;
     Form1.lbActiveClipID.Caption := '';
     Form1.Label2.Caption := '';
     TLParameters.Start :=TLParameters.Preroll;
     TLParameters.Duration := 0;
     TLParameters.Finish := TLParameters.Start + TLParameters.Duration;
     TLParameters.ZeroPoint:=TLParameters.Start;
     TLParameters.Position := TLParameters.Start;
     TLparameters.EndPoint := TLParameters.Start + TLParameters.Duration;
     Form1.lbMediaNTK.Caption:=FramesToStr(TLParameters.Start - TLParameters.Preroll);
     Form1.lbMediaDuration.Caption:=FramesToStr(TLParameters.Finish - TLParameters.Start);
     Form1.lbMediaKTK.Caption:=FramesToStr(TLParameters.Finish - TLParameters.Preroll);
     Form1.lbMediaTotalDur.Caption:=FramesToStr(TLParameters.Duration);
     Form1.lbMediaCurTK.Caption:=FramesToStr(TLParameters.Start - TLParameters.Preroll);
     Form1.lbNomClips.Caption:='';
     Form1.lbClipName.Caption:='';
     Form1.lbSongName.Caption:='';
     Form1.lbSongSinger.Caption:='';
     Form1.lbPlayerFile.Caption:='';
     MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '');
     Form1.Image3.Picture.Bitmap:=nil;
     Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
     Form1.imgtimelines.Canvas.FillRect(Form1.imgtimelines.Canvas.ClipRect);
     bmptimeline.Canvas.FillRect(bmptimeline.Canvas.ClipRect);
     ClearGraph;
     TLZone.ClearZone;
     TLZone.DrawBitmap(bmptimeline);
     TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
     Form1.imgtimelines.Repaint;
     if Form1.Image3.Visible then Form1.Image3.Repaint;
     ClearUNDO;
     SetStatusClipInPlayer('!!@@##$$%%^^&&**');
  end;
end;

Procedure SetPathProject(IDProject : string);
begin
  PathProject:=AppPath + DirProjects + '\' + IDProject;
  //PathEvents:=PathProject + '\' + DirEvents;
  PathTemp:=PathProject + '\' + DirTemp;
  PathTemplates:=PathProject + '\' + DirTemplates;
end;

function CalcTextExtent(DCHandle:integer;Text:string):TSize;
var
 CharFSize:TABCFloat;
begin
 Result.cx:=0;
 Result.cy:=0;
 if Text='' then
   exit;
 GetTextExtentPoint32(DCHandle,PChar(Text),Length(Text),Result);
 GetCharABCWidthsFloat(DCHandle,Ord(Text[Length(Text)]),Ord(Text[Length(Text)]),CharFSize);
 if CharFSize.abcfC<0 then
   Result.cx:=Result.cx+Trunc(Abs(CharFSize.abcfC));
end;

function CalcTextWidth(DCHandle:integer;Text:string):integer;
begin
 Result:= CalcTextExtent(DCHandle,Text).cx;
end;

procedure TemplateToScreen(crpos : TEventReplay);
begin
  if crpos.Number <> -1 then begin
    MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image);
    if Form1.pnImageScreen.Visible then begin
      if Trim(CurrentImageTemplate)<>trim(crpos.Image) then begin
        if trim(crpos.Image)='' then begin
          Form1.Image3.Picture.Bitmap.FreeImage;
          Form1.Image3.Canvas.Brush.Color := SmoothColor(ProgrammColor,24);
          Form1.Image3.Canvas.Brush.Style := bsSolid;
          Form1.Image3.Width:=Form1.pnImageScreen.Width;
          Form1.Image3.Height:=Form1.pnImageScreen.Height;
          Form1.Image3.Picture.Bitmap.Width:=Form1.pnImageScreen.Width;
          Form1.Image3.Picture.Bitmap.Height:=Form1.pnImageScreen.Height;
          Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
          Form1.Image3.repaint;
          application.ProcessMessages;
        end else if FileExists(PathTemplates + '\' + trim(crpos.Image))
                   then Form1.Image3.Picture.LoadFromFile(PathTemplates + '\' + trim(crpos.Image));
        CurrentImageTemplate:=crpos.Image;
      end;
    end;
  end else begin
    if Form1.pnImageScreen.Visible then begin
      Form1.Image3.Picture.Bitmap.FreeImage;
      Form1.Image3.Canvas.Brush.Color := SmoothColor(ProgrammColor,24);
      Form1.Image3.Canvas.Brush.Style := bsSolid;
      Form1.Image3.Width:=Form1.pnImageScreen.Width;
      Form1.Image3.Height:=Form1.pnImageScreen.Height;
      Form1.Image3.Picture.Bitmap.Width:=Form1.pnImageScreen.Width;
      Form1.Image3.Picture.Bitmap.Height:=Form1.pnImageScreen.Height;
      Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
      Form1.Image3.repaint;
      CurrentImageTemplate := '#@@#';
      application.ProcessMessages;
    end;
  end;
end;

procedure MyTextRect(var cv : tcanvas; const Rect : TRect; Text : string);
var LR : TLogFont;
    FHOld, FHNew : HFONT;
    wdth, fntsz, sz, sz1, szc, sz2, szm : integer;
    size : TSize;
    pr : integer;
    s, s1, s2: string;
    bmp : tbitmap;
begin
  if length(Text)<=0 then exit;
  bmp := tbitmap.Create;
  try
  try
    bmp.Width:=rect.Right-rect.Left;
    bmp.Height:=rect.Bottom-rect.Top;
    bmp.Canvas.Brush.Style:=bsSolid;
    bmp.Canvas.CopyRect(bmp.Canvas.ClipRect,cv,Rect);
    bmp.Canvas.Font.Assign(cv.Font);
    wdth := Rect.Right-Rect.Left;
    GetObject(bmp.Canvas.Font.Handle, SizeOf(LR), Addr(LR));
    LR.lfHeight:=Rect.Bottom-Rect.Top;

    szm := (wdth - length(Text)) div length(Text);
    LR.lfWidth:=szm;
    FHNew:=CreateFontIndirect(LR);
    FHOld:=SelectObject(bmp.Canvas.Handle,FHNew);
    szc := bmp.Canvas.TextWidth(Text);
    FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
    DeleteObject(FHNew);

    if szc <= wdth then begin
       for sz:=szm to 50 do begin
         LR.lfWidth:=sz;
         FHNew:=CreateFontIndirect(LR);
         FHOld:=SelectObject(bmp.Canvas.Handle,FHNew);
         szc := bmp.Canvas.TextWidth(Text);
         FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
         DeleteObject(FHNew);
         if szc > wdth then begin
           LR.lfWidth:=sz-1;
           FHNew:=CreateFontIndirect(LR);
           FHOld:=SelectObject(bmp.Canvas.Handle,FHNew);
           szc := bmp.Canvas.TextWidth(Text);
           break;
         end;
       end;
    end else begin
       for sz:=szm downto 1 do begin
         LR.lfWidth:=sz;
         FHNew:=CreateFontIndirect(LR);
         FHOld:=SelectObject(bmp.Canvas.Handle,FHNew);
         szc := bmp.Canvas.TextWidth(Text);
         if szc <= wdth then break
         else begin
           FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
           DeleteObject(FHNew);
         end;
       end;
    end;

    sz2 := wdth - szc;
    s1:=copy(Text,1,Length(Text)-sz2);
    s2:=copy(Text,length(Text)-sz2+1,sz2);
    bmp.Canvas.Brush.Style:=bsClear;
    bmp.Canvas.TextOut(0,0,s1);
    szc:=bmp.Canvas.TextWidth(s1);
    SetTextCharacterExtra(bmp.Canvas.Handle, 1);
    bmp.Canvas.TextOut(szc,0,s2);
    bitblt(cv.Handle, rect.left, rect.top, rect.Right-rect.Left, rect.Bottom-rect.Top ,bmp.Canvas.Handle, 0, 0 , SRCCOPY);
    SetTextCharacterExtra(bmp.Canvas.Handle, 0);
    FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
    DeleteObject(FHNew);
  finally
    bmp.Free;
    bmp:=nil;
  end;
  except
    FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
    DeleteObject(FHNew);
    bmp.Free;
    bmp:=nil;
  end;
end;

procedure InsertEventToEditTimeline(nom : integer);
var ps : integer;
begin
  frLock.Hide;
  ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
  if TLZone.Timelines[ps].Block then exit;
      case TLZone.TLEditor.TypeTL of
  tlDevice : begin
               if nom > (Form1.GridTimeLines.Objects[0,ps+1] as TTimelineOptions).CountDev-1 then exit;
               if ps<>-1 then begin
                 TLZone.TLEditor.AddEvent(TLParameters.Position,ps+1,nom);
                 TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
                 //if mode=play then exit;
              //TLZone.DrawBitmap(bmptimeline);
                 TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
                 TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
                 if mode=play then exit;
               //TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
               end;
             end;
  tlText :   begin
               if ps<>-1 then begin
                 if TLParameters.Position < TLParameters.Preroll then exit;
                 if TLParameters.Position >= TLParameters.EndPoint then exit;
                 TLZone.TLEditor.AddEvent(TLParameters.Position,ps+1,nom);
                 TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
                 //if mode=play then exit;
            //TLZone.DrawBitmap(bmptimeline);
                 TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
                 TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
                 if mode=play then exit;
               end;
             end;
  tlMedia :  begin
               if ps<>-1 then begin
                 if TLParameters.Position <= TLParameters.Preroll then exit;
                 if TLParameters.Position >= TLParameters.EndPoint then exit;
                 TLZone.TLEditor.AddEvent(TLParameters.Position,ps+1,nom);
                 TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
                 //if mode=play then exit;
           //TLZone.DrawBitmap(bmptimeline);
                 TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
                 TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame));
                 if mode=play then exit;
               end;
             end;
      end;
  TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
end;

Procedure PlayClipFromActPlaylist;
begin
  Form1.sbPlayList.Font.Style:=Form1.sbPlayList.Font.Style + [fsUnderline];
  MyTimer.Waiting:=true;
  GridPlayer:=grPlayList;
  GridPlayerRow:=Form1.GridActPlayList.Row;
  form1.lbActiveClipID.Caption := (Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('ClipID');
  LoadClipsToPlayer;
  MyTimer.Waiting:=false;
end;

Procedure PlayClipFromClipsList;
begin
  Form1.sbClips.Font.Style:=Form1.sbClips.Font.Style + [fsUnderline];
  //MyTimer.Waiting:=true;
  GridPlayer:=grClips;
  GridPlayerRow:=Form1.GridClips.Row;
  PredClipID := (Form1.GridClips.Objects[0,Form1.GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID');
  LoadClipsToPlayer;
  //MyTimer.Waiting:=false;
end;

procedure ControlPlayer;
begin
  //pMediaPosition.get_Rate(Rate);
    //mode := play;
    //StartMyTimer;

  if mode=paused then begin
    Rate:=1;

    if fileexists(Form1.lbPlayerFile.Caption) then pMediaPosition.put_Rate(Rate);
    MediaPlay
  end else begin
    if fileexists(Form1.lbPlayerFile.Caption) then pMediaPosition.get_Rate(Rate);
    if Rate<>1 then begin
      Rate:=1;
      if not fileexists(Form1.lbPlayerFile.Caption) then begin
        pStart := FramesToDouble(TLParameters.Position);
        application.ProcessMessages;
      end;
      if fileexists(Form1.lbPlayerFile.Caption) then pMediaPosition.put_Rate(Rate);
    end else MediaPause;
  end;
  Form1.imgLayer0.Canvas.FillRect(Form1.imgLayer1.Canvas.ClipRect);
  Form1.imgLayer0.Repaint;
  SetMediaButtons;
end;

procedure LoadJpegFile(bmp : tbitmap; FileName : string);
var
  JpegIm: TJpegImage;
  wdth,hght,bwdth,bhght : integer;
  dlt : real;
begin
  JpegIm := TJpegImage.Create;
  try
  JpegIm.LoadFromFile(FileName);
  bmp.Assign(JpegIm);
  finally
    JpegIm.Free;
  end;
end;

procedure loadoldproject;
var ps, pp : integer;
    nm : string;
begin
  initnewproject;
  SecondaryGrid:=playlists;
  ps := findgridselection(form1.gridprojects, 2);

  if ps > 0 then begin
    form1.gridprojects.Row:=ps;
    ProjectToPanel(ps);
    ProjectNumber := (form1.gridprojects.Objects[0,ps] as tgridrows).MyCells[3].ReadPhrase('Note');
    UpdateProjectPathes(ProjectNumber);
    LoadProjectFromDisk;
    SecondaryGrid:=playlists;
    LoadGridFromFile(PathTemp + '\PlayLists.lst', form1.GridLists);
    LoadGridFromFile(PathTemp + '\ImageTemplates.lst', form1.GridGRTemplate);
    application.ProcessMessages;
    GridImageReload(form1.GridGRTemplate);
    UpdateGridTemplate:=true;
    LoadGridFromFile(PathTemp + '\Clips.lst', form1.GridClips);
    CheckedClipsInList(form1.GridClips);
    pp := findgridselection(form1.gridlists, 2);
    if pp > 0 then begin
      nm := (form1.gridlists.Objects[0,pp] as tgridrows).MyCells[3].ReadPhrase('Note');
      PlaylistToPanel(pp);
      LoadGridFromFile(PathPlayLists+ '\' + nm, form1.GridActPlayList);
      CheckedClipsInList(form1.GridActPlayList);
      Form1.lbClipActPL.Caption := (form1.gridlists.Objects[0,pp] as tgridrows).MyCells[3].ReadPhrase('Name');
    end;
  end;
  form1.GridLists.Repaint;
  Form1.GridTimeLines.Repaint;
  Form1.GridProjects.Repaint;
  Form1.GridClips.Repaint;
  Form1.GridActPlayList.Repaint;
end;

procedure saveoldproject;
var ps : integer;
    nm, txt : string;
begin
  ps := findgridselection(Form1.gridprojects, 2);
  if ps > 0 then nm:=(form1.gridprojects.Objects[0,ps] as tgridrows).MyCells[3].ReadPhrase('Note');
  //SaveProjectToDisk;
  if Form1.cbPlayLists.ItemIndex<>-1 then begin
    txt := (Form1.cbPlayLists.Items.Objects[Form1.cbPlayLists.ItemIndex] as TMyListBoxObject).ClipId;
    SaveGridToFile(PathPlayLists + '\' + txt, Form1.GridActPlayList);
  end;
  SaveProjectToDisk;
  SaveGridToFile(PathLists + '\Clips.lst', Form1.GridClips);
end;

procedure initnewproject;
var i : integer;
begin
  with Form1 do begin
    if trim(Label2.Caption)<>'' then begin
      SaveClipEditingToFile(trim(Label2.Caption));
      Label2.Caption:='';
      TLZone.TLEditor.Clear;
      for i := 0 to TLZone.Count - 1 do TLZone.Timelines[i].Clear;
      ClearGraph;
    end;
    ProjectNumber := '';
    lbProjectName.Caption:='';
    lbpComment.Caption:='';
    lbDateStart.Caption:='';
    lbDateEnd.Caption:='';
    if FileExists(pathlists + '\Timelines.lst')
      then LoadGridTimelinesFromFile(pathlists + '\Timelines.lst', Form1.GridTimeLines)
      else InitGridTimelines;
    //ZoneNames.Update;
    InitPanelPrepare;
    GridClear(GridClips,RowGridClips);
    GridClear(GridActPlayList,RowGridClips);
    ClearPanelActPlayList;
    ClearClipsPanel;
    GridClear(GridLists, RowGridListPL);

    GridLists.Repaint;
    GridClips.Repaint;
    GridActPlayList.Repaint;
  end;
end;

procedure UpdateProjectPathes(NewProject : string);
begin
  PathProject:=AppPath + DirProjects + '\' + NewProject;
  PathLists := PathProject + DirLists;
  PathClips := PathProject + DirClips;
  PathTemplates := PathProject + DirTemplates;
  PathPlayLists := PathProject + DirPlayLists;
  PathTemp := PathProject + DirTemp;
end;

procedure CreateDirectories(NewProject : string);
var i : integer;
    ext : string;
begin
  AppPath := extractfilepath(Application.ExeName);
  AppName := extractfilename(Application.ExeName);
  ext := extractfileext(Application.ExeName);
  AppName := copy(AppName,1,length(AppName)-length(ext));
  PathFiles:=AppPath+DirFiles;
  if not DirectoryExists(PathFiles) then ForceDirectories(PathFiles);
  PathProject:=AppPath+DirProjects;
  if not DirectoryExists(PathProject) then ForceDirectories(PathProject);
  If Trim(NewProject)='' then exit;
  PathProject:=AppPath + DirProjects + '\' + NewProject;
  PathLists := PathProject + DirLists;
  if not DirectoryExists(PathLists) then ForceDirectories(PathLists);
  PathClips := PathProject + DirClips;
  if not DirectoryExists(PathClips) then ForceDirectories(PathClips);
  PathTemplates := PathProject + DirTemplates;
  if not DirectoryExists(PathTemplates)  then ForceDirectories(PathTemplates);
  PathPlayLists := PathProject + DirPlayLists;
  if not DirectoryExists(PathPlayLists)  then ForceDirectories(PathPlayLists);
  PathTemp := PathProject + DirTemp;
  if not DirectoryExists(PathTemp) then ForceDirectories(PathTemp);
end;

function createunicumname : string;
var YY,MN,DD : Word;
    HH,MM,SS,MS : Word;
begin
  DecodeDate(Now,YY,MN,dd);
  DecodeTime(Now,HH,MM,SS,MS);
  result := inttostr(YY) + inttostr(MN) + inttostr(DD) +
            inttostr(HH) + inttostr(MM) + inttostr(SS) + inttostr(MS);
end;

procedure LoadBMPFromRes(cv : tcanvas; rect : trect; width, height : integer; name : string);
var bmp : tbitmap;
    wdth, hght, deltx, delty : integer;
    rt : trect;
begin
  if trim(name)='' then exit;
  bmp:=tbitmap.Create;
  bmp.LoadFromResourceName(HInstance, name);
  bmp.Transparent:=true;
  rt.Left:=rect.Left;
  rt.Right:=rect.Right;
  rt.Top:=rect.Top;
  rt.Bottom:=rect.Bottom;
  wdth:=rect.Right-rect.Left;
  hght:=rect.Bottom-rect.Top;
  if wdth > width then begin
    deltx:=(wdth-width) div 2;
    rt.Left:=rect.Left+deltx;
    rt.Right:=rect.Right-deltx;
  end;
  if hght > height then begin
    delty:=(hght-height) div 2;
    rt.Top:=rect.Top+delty;
    rt.Bottom:=rect.Bottom-delty;
  end;
  cv.StretchDraw(rt,bmp);
  bmp.Free;
end;

function TwoDigit(dig : integer) : string;
begin
  if (dig>=0) and (dig<=9) then Result:='0'+IntToStr(dig)
  else Result:=IntToStr(dig);
end;

function FramesToDouble(frm : longint) : Double;
var HH,MM,SS,FF,DLT : longint;
begin
  DLT:=frm div 25;
  FF:= frm mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := (HH*3600 + mm*60 + SS) + (FF*40/1000);
end;

function FramesToTime(frm : longint) : tdatetime;
var HH,MM,SS,FF,DLT : longint;
begin
  DLT:=frm div 25;
  FF:= frm mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := encodetime(HH,mm,SS,FF*40);
end;

function TimeToFrames(dt : tdatetime) : longint;
var HH,MM,SS,ms : word;
begin
  DecodeTime(dt,hh,mm,ss,ms);
  result := (hh*3600 + mm*60 + ss) * 25 + trunc(ms / 40);
end;

function TimeToTimeCodeStr(dt : tdatetime) : string;
var HH,MM,SS,ms : word;
begin
  DecodeTime(dt,hh,mm,ss,ms);
  result := TwoDigit(hh) + ':' + TwoDigit(mm) + ':' + TwoDigit(ss) + ':' + TwoDigit(trunc(ms / 40));
end;

function StrTimeCodeToFrames(tc : string) : longint;
var HH,MM,SS,ms : word;
begin
  hh:=strtoint(tc[1]+tc[2]);
  mm:=strtoint(tc[4]+tc[5]);
  ss:=strtoint(tc[7]+tc[8]);
  ms:=strtoint(tc[10]+tc[11]);
  result := (hh*3600 + mm*60 + ss) * 25 + ms;
end;

function FramesToStr(frm : longint) : string;
var ZN, HH,MM,SS,FF,DLT : longint;
    znak : char;
begin
  ZN := frm;
  znak := #32;
  if frm<0 then begin
    znak := '-';
    ZN :=-1 * ZN;
  end;
  DLT:=ZN div 25;
  FF:= ZN mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := znak + TwoDigit(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
end;

function FramesToShortStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  if frm < 0 then begin
    st:='-';
    fr := -1 * frm;
  end else begin
    st:='';
    fr:=frm;
  end;
  DLT:=fr div 25;
  FF:= fr mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  if HH<>0 then begin
    result := st + TwoDigit(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
    exit;
  end;
  if MM<>0 then begin
    result := st + TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
    exit;
  end;
  result := st +TwoDigit(SS)+':'+TwoDigit(FF);
end;

function SecondToStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  if frm < 0 then begin
    st:='-';
    fr := -1 * frm;
  end else begin
    st:='';
    fr:=frm;
  end;
  HH:=fr div 3600;
  MM:=fr mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  if HH<>0 then begin
    result := st + inttostr(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS);
    exit;
  end;
  result := st +inttostr(MM)+':'+TwoDigit(SS);
end;

function SecondToShortStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  if frm < 0 then begin
    st:='-';
    fr := -1 * frm;
  end else begin
    st:='';
    fr:=frm;
  end;
  HH:=fr div 3600;
  MM:=fr mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  if HH<>0 then begin
    result := st + inttostr(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS);
    exit;
  end;
  if MM<>0 then begin
    result := st +inttostr(MM)+':'+TwoDigit(SS);
    exit;
  end;
  result := st + ':'+TwoDigit(SS);
end;

function MyDoubleToSTime(db : Double) : string;
var HH,MM,SS,FF,DLT : longint;
begin
  DLT:=trunc(db);
  FF:=Trunc((db-DLT)*1000/40);
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := TwoDigit(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
end;

function MyDoubleToFrame(db : Double) : longint;
var HH,MM,SS,FF,DLT : longint;
begin
  DLT:=trunc(db);
  FF:=trunc((db-DLT)*1000/40);
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := (HH*3600 + mm*60 + SS)*25 + FF;
end;

function MyDateTimeToStr(tm : tdatetime) : string;
var Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(tm, Hour, Min, Sec, MSec);
  Result := twodigit(Hour) + ':' + twodigit(Min) + ':' + twodigit(Sec) + ':' + twodigit(trunc(MSec/40));
end;

Function DefineFontSizeW(cv : TCanvas; width : integer; txt : string): integer;
var fntsz, sz : integer;
    bmp : tbitmap;
begin
  bmp := tbitmap.Create;
  try
    result:=0;
    if bmp.Canvas.Font.Size=0 then bmp.Canvas.Font.Size:=40;
    fntsz:=cv.Font.Size;
    For sz:=fntsz downto 5 do begin
      bmp.Canvas.Font.Size:=sz;
      if bmp.Canvas.TextWidth(txt) < width - 4 then break;
    end;
    result := sz;
    //cv.Font.Size:=fntsz;
  finally
    bmp.Free;
  end;
end;

Function DefineFontSizeH(cv : TCanvas; height : integer): integer;
var fntsz, sz : integer;
    bmp : tbitmap;
begin
  bmp := tbitmap.Create;
  try
  result:=0;
  //fntsz:=cv.Font.Size;
  //cv.Font.Size:=40;
  For sz:=40 downto 5 do begin
    bmp.Canvas.Font.Size:=sz;
    if bmp.Canvas.TextHeight('0') < height-2 then break;
  end;
  result := sz;
  //cv.Font.Size:=fntsz;
  finally
    bmp.Free;
  end;
end;

//function SmoothColor(color : tcolor; step : integer) : tcolor;
//var cColor: Longint;
//    r, g, b: Byte;
//begin
//  cColor := ColorToRGB(Color);
//  r := cColor;
//  g := cColor shr 8;
//  b := cColor shr 16;
//  if (r + step) < 255 then r := r+step else r:=r-step;
//  if (g + step) < 255 then g := g+step else g:=g-step;
//  if (b + step) < 255 then b := b+step else b:=b-step;
//  result:=RGB(r,g,b);
//end;

function SmoothColor(color : tcolor; step : integer) : tcolor;
var cColor: Longint;
    r, g, b: Byte;
    zn : integer;
    rm, gm, bm : Byte;
begin
  cColor := ColorToRGB(Color);
  r := cColor;
  g := cColor shr 8;
  b := cColor shr 16;

    if (r >= g) and (r >= b) then begin
    if (r + step) <= 255 then begin
       r := r + step;
       g := g + step;
       b := b + step;
    end else begin
       if r-step > 0 then r:=r-step else r:=0;
       if g-step > 0 then g:=g-step else g:=0;
       if b-step > 0 then b:=b-step else b:=0;
    end;
    result:=RGB(r,g,b);
    exit;
  end;

  if (g >= r) and (g >= b) then begin
    if (g + step) <= 255 then begin
       r := r + step;
       g := g + step;
       b := b + step;
    end else begin
       if r-step > 0 then r:=r-step else r:=0;
       if g-step > 0 then g:=g-step else g:=0;
       if b-step > 0 then b:=b-step else b:=0;
    end;
    result:=RGB(r,g,b);
    exit;
  end;

  if (b >= r) and (b >= g) then begin
    if (b + step) <= 255 then begin
       r := r + step;
       g := g + step;
       b := b + step;
    end else begin
       if r-step > 0 then r:=r-step else r:=0;
       if g-step > 0 then g:=g-step else g:=0;
       if b-step > 0 then b:=b-step else b:=0;
    end;
    result:=RGB(r,g,b);
    exit;
  end;

end;

function SetMainGridPanel(TypeGrid : TTypeGrid) : boolean;
var i, APos, oldcount : integer;
    clpid : string;
begin
  result := true;
  if (mode=play) and (GridPlayer<>grPlayList) and (TypeGrid=actplaylist) then begin
    result:= false;
    exit;
  end;
  if (trim(Form1.lbActiveClipID.Caption)='') and Form1.PanelPrepare.Visible then begin
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
            Form1.GridClips.Row := Form1.GridClips.RowCount-1;
            GridPlayer:=grClips;
            GridPlayerRow:=Form1.GridClips.RowCount-1;
            LoadClipsToPlayer;
          end;
        end;
        break;
      end;
    end;
  end;
  MainGrid:=TypeGrid;
  With Form1 do begin
    PanelPrepare.Visible:=false;
    PanelAir.Visible:=false;
        case MainGrid of
  projects    : begin
                  PanelProject.Visible:=true;
                  PanelClips.Visible:=false;
                  PanelPlayList.Visible:=false;
                  sbProject.Font.Style:=sbProject.Font.Style + [fsBold,fsUnderline];
                  sbClips.Font.Style:=sbClips.Font.Style - [fsBold,fsUnderline];
                  sbPlayList.Font.Style:=sbPlayList.Font.Style - [fsBold,fsUnderline];
                  //SetSecondaryGrid(SecondaryGrid);
                  //CheckedClipsInList(GridClips);
                  //GridTimeLines.Top:= Bevel8.Top + 15;
                  //GridTimeLines.Height:=imgButtonsControlProj.Top - Bevel8.Top - 25;
                  ActiveControl := GridProjects;
                end;
  clips       : begin
                  PanelProject.Visible:=false;
                  PanelClips.Visible:=true;
                  PanelPlayList.Visible:=false;
                  lbusesclpidlst.Caption := 'Список клипов';
                  sbProject.Font.Style:=sbProject.Font.Style - [fsBold,fsUnderline];
                  sbClips.Font.Style:=sbClips.Font.Style + [fsBold,fsUnderline];
                  sbPlayList.Font.Style:=sbPlayList.Font.Style - [fsBold,fsUnderline];
                  ActiveControl := GridClips;
                  if trim(Form1.lbActiveClipID.Caption)<>''   then begin
                    GridPlayer:=grClips;
                    SetInGridClipPosition(GridClips, Form1.lbActiveClipID.Caption);
                    if APos <> -1 then GridClipsToPanel(GridClips.Row);
                  end else begin
                    if GridClips.Row > 0 then begin
                      if trim(PredClipID) <> '' then begin
                        GridPlayer:=grClips;
                        SetInGridClipPosition(GridClips, PredClipID);
                        if APos <> -1 then begin
                          GridClipsToPanel(GridClips.Row);
                          Form1.lbActiveClipID.Caption := PredClipID;
                          PlayClipFromClipsList;
                        end;
                      end;
                      if GridClips.Objects[0,GridClips.Row] is TGridRows then begin
                        GridClipsToPanel(GridClips.Row);
                      end;
                    end;
                  end;
                  //CheckedClipsInList(GridClips);
                end;
  actplaylist : begin

                  PanelProject.Visible:=false;
                  PanelClips.Visible:=false;
                  PanelPlayList.Visible:=true;
                  sbProject.Font.Style:=sbProject.Font.Style - [fsBold,fsUnderline];
                  sbClips.Font.Style:=sbClips.Font.Style - [fsBold,fsUnderline];
                  sbPlayList.Font.Style:=sbPlayList.Font.Style + [fsBold,fsUnderline];
                  lbusesclpidlst.Caption := 'Плай-лист: ' + trim(cbPlayLists.Text);
                  if trim(Form1.lbActiveClipID.Caption)<>''   then begin
                    GridPlayer:=grPlayList;
                    SetInGridClipPosition(GridActPlayList, Form1.lbActiveClipID.Caption);
                  end;
                  ActiveControl := GridActPlayList;
                end;
        end;
    CheckedClipsInList(GridClips);
    CheckedActivePlayList;
  end;
end;

procedure ButtonControlLists(command : integer);
var s:string;
    i, res, ps, cnt : integer;
    nm : string;
    id : longint;
    cntmrk, cntdel : integer;
begin
  with Form1 do begin
      case command of
    0 : begin
          ps := findgridselection(gridprojects, 2);
          if ps <= 0 then begin
            MyTextMessage('Сообщение','Добавления тайм-линии невозможно,' + #10#13 + 'необходимо инициализировать проект.',1);
            exit;
          end;
          EditTimeline(-1);
          GridTimelines.Repaint;
        end;
    1 : begin
          ps := findgridselection(gridprojects, 2);
          if ps <= 0 then begin
            MyTextMessage('Сообщение','Добавления тайм-линии невозможно,' + #10#13 + 'необходимо инициализировать проект.',1);
            exit;
          end;
          id := (GridTimelines.Objects[0, GridTimelines.Selection.Top] as ttimelineoptions).IDTimeline;
          DeleteTimeline(GridTimelines.Selection.Top);
          if id = ZoneNames.Edit.IDTimeline then begin
            ZoneNames.Edit.IDTimeline := (Form1.GridTimeLines.Objects[0,1] as TTimelineOptions).IDTimeline;
            ps := TLZone.FindTimeline(ZoneNames.Edit.IDTimeline);
            if ps<>-1 then TLZone.TLEditor.Assign(TLZone.Timelines[ps],ps);
            TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
            ZoneNames.Draw(form1.imgTLNames.Canvas, form1.GridTimeLines, true);
            MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas,1);
            MyPanelAir.SetValues;
          end;
          GridTimelines.Repaint;
        end;
      2: begin
           if (GridTimeLines.Selection.Top < 1) or (GridTimeLines.Selection.Top >= GridTimeLines.RowCount) then exit;
           EditTimeline(GridTimeLines.Selection.Top);
           GridTimeLines.Repaint;
         end;
       end; //case
  end;
end;

procedure ButtonPlaylLists(command : integer);
var s:string;
    i, res, ps, cnt : integer;
    nm : string;
    id : longint;
    cntmrk, cntdel : integer;
begin
  with Form1 do begin
      case command of
    0 : begin
          ps := findgridselection(form1.gridprojects, 2);
          if ps=-1 then exit;
          EditPlaylist(-1);
          SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
          GridLists.Repaint;
          CheckedActivePlayList;
        end;
    1 : begin
          ps := findgridselection(gridlists, 2);
          cntmrk := CountGridMarkedRows(GridLists, 1, 1);
          if cntmrk<>0 then begin
            if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные плей-листы?',2) then exit;
            if ps>0 then begin
              if (GridLists.Objects[0,ps] as TGridRows).MyCells[1].Mark and (not (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark) then begin
                if MyTextMessage('Вопрос', 'Вы действительно хотите удалить активный плей-лист?',2) then begin
                  (GridLists.Objects[0,ps] as TGridRows).MyCells[2].Mark:=false;
                  //lbPlaylist.Caption:='';
                  lbPLComment.Caption:='';
                  //lbPLCreate.Caption:='';
                  //lbPLEnd.Caption:='';
                  GridClear(GridActPlayList,RowGridClips);
                end;
              end;
            end;
            cntdel := 0;
            for i:=GridLists.RowCount-1 downto 1 do begin
              if (GridLists.Objects[0,i] as TGridRows).MyCells[1].Mark and (Not (GridLists.Objects[0,i] as TGridRows).MyCells[0].Mark) then begin
                  nm := (GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
                  cntdel:=cntdel + 1;
                  nm := PathPlaylists + '\PL' + trim(nm) + '.plst';
                  if fileexists(nm) then DeleteFile(nm);
                  MyGridDeleteRow(GridLists, i, RowGridListPL);
                  //SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
              end;
            end;
            MyTextMessage('Сообщение','Выделено плей-листов ' + inttostr(cntmrk) + ', удалено ' + inttostr(cntdel) + '.' ,1);
            SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
          end else begin
            //ps := findgridselection(gridlists, 2);
            if ps=GridLists.Row then begin
              if (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[0].Mark then begin
                MyTextMessage('Сообщение','Плей-лист защищен от удаления',1);
                exit;
              end;
              if MyTextMessage('Вопрос', 'Вы действительно хотите удалить активный плей-лист?',2) then begin
                nm := (GridLists.Objects[0,GridLists.Row ] as TGridRows).MyCells[3].ReadPhrase('Note');
                nm := PathPlaylists + '\PL' + trim(nm) + '.plst';
                if fileexists(nm) then DeleteFile(nm);
                MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                //lbPlaylist.Caption:='';
                lbPLComment.Caption:='';
                //lbPLCreate.Caption:='';
                //lbPLEnd.Caption:='';
                GridClear(GridActPlayList,RowGridClips);
              end;
            end else begin
              if MyTextMessage('Вопрос', 'Вы действительно хотите удалить плей-лист?',2) then begin
                nm := (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[3].ReadPhrase('Note');
                nm := PathPlaylists + '\PL' + trim(nm) + '.plst';
                if fileexists(nm) then DeleteFile(nm);
                MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
              end;
            end;
            if (GridLists.RowCount=2) and (GridLists.Row=1) and ((GridLists.Objects[0,GridLists.Row] as TGridRows).ID<=0) then begin
              GridClear(GridActPlayList,RowGridClips);
            end;
          end;//if1
          GridLists.Repaint;
        end;
    2 : begin
                case SecondaryGrid of
          playlists   : begin
                          SortMyListClear;
                          SortMyList[0].Name:='Плей-листы';
                          SortMyList[0].Field:='Name';
                          SortMyList[0].TypeData:=tstext;
                          GridSort(GridLists, 1, 3);
                        end;

                end;
          GridLists.Repaint;

        end;
       end; //case
       //DrawPanelButtons(imgButtonsControlProj.Canvas, IMGPanelProjectControl,-1);
       //GridTimelines.Repaint;
  end;
end;

procedure ButtonsControlProjects(command : integer);
var i, ps, setpos : integer;
    cntmrk, cntdel : integer;
    s, fp, msg, cmnt, edt : string;
    SDir, TDir : string;
begin
  with Form1 do begin
           case command of
    0: begin
         CreateProject(-1);
         ps := findgridselection(GridProjects, 2);
         if ps<>-1
           then Label15.Caption:= 'Список плей-листов проекта (' + (GridProjects.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('Project') + ')'
           else Label15.Caption:= 'Список плей-листов проекта';
       end;
    1: begin
         ps := findgridselection(gridprojects, 2);
         cntmrk := CountGridMarkedRows(GridProjects, 1, 1);
         if cntmrk <> 0 then begin
           if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные проекты?',2) then exit;
           if ps > 0 then begin
             if (GridProjects.Objects[0,ps] as TGridRows).MyCells[1].Mark and (not (GridProjects.Objects[0,ps] as TGridRows).MyCells[0].Mark)
               then if not MyTextMessage('Вопрос','Вы действительно хотите удалить текущий проект?',2)
                     then (GridProjects.Objects[0,ps] as TGridRows).MyCells[1].Mark := false;
           end;
           cntdel:=0;
           For i:=GridProjects.RowCount-1 downto 1 do begin
             if (GridProjects.Objects[0,i] as TGridRows).MyCells[1].Mark and (not (GridProjects.Objects[0,i] as TGridRows).MyCells[0].Mark)
             then begin
               s := (GridProjects.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
               MyGridDeleteRow(GridProjects, i, RowGridProject);
               cntdel := cntdel +1;
               if Trim(s)<>'' then begin
                 ProjectNumber:='';
                 if not KillDir(AppPath + DirProjects + '\' + s) then SetTaskOnDelete(s);
               end;
             end;
           end;
           if cntdel<>cntmrk then MyTextMessage('Сообщение','Выделено проектов ' + inttostr(cntmrk) + ', удалено ' + inttostr(cntdel) + '.',1);
         end else begin
           if (ps=gridprojects.Row) then begin
             if not MyTextMessage('Вопрос','Вы действительно хотите удалить текущий проект?',2) then exit;
           end else if not MyTextMessage('Вопрос','Вы действительно хотите удалить проект?',2) then exit;
           if (GridProjects.Objects[0,gridprojects.Row] as TGridRows).MyCells[0].Mark then begin
             MyTextMessage('Сообщение','Выбранный проект защищен от удаления.',1);
             exit;
           end;
           s := (GridProjects.Objects[0,gridprojects.Row] as TGridRows).MyCells[3].ReadPhrase('Note');
           MyGridDeleteRow(GridProjects, GridProjects.Row, RowGridProject);
           if Trim(s)<>'' then begin
             ProjectNumber:='';
             if not KillDir(AppPath + DirProjects + '\' + s) then SetTaskOnDelete(s);
           end;
         end;
         initnewproject;
         ps := findgridselection(gridprojects, 2);
         if ps<>-1
           then Label15.Caption:= 'Список плей-листов проекта (' + (GridProjects.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('Project') + ')'
           else Label15.Caption:= 'Список плей-листов проекта';
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
         ps := findgridselection(GridProjects, 2);
         if ps<>-1
           then Label15.Caption:= 'Список плей-листов проекта (' + (GridProjects.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('Project') + ')'
           else Label15.Caption:= 'Список плей-листов проекта';
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
    4: begin
         MyTextTemplateOptions;
       end;
    5: begin
         EditImageTamplate;
       end;
    6 : begin
          SaveGridToFile(AppPath + DirProjects + '\' + 'ListProjects.prjt', GridProjects);
          saveoldproject;
        end;
         end;
    GridProjects.Repaint;
  end;
end;

procedure ButtonsControlMedia(command : integer);
var i, oldcount, ps, res : integer;
    crpos : teventreplay;
    clpid : string;
begin
  With Form1 do begin
    //if trim(Label2.Caption)='' then exit;
    ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    if TLZone.Timelines[ps].Block then begin
      frLock.ShowModal;
      exit;
    end;
    SaveToUNDO;

         case command of
    0 : if (trim(Form1.lbActiveClipID.Caption)='') and Form1.PanelPrepare.Visible then begin
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
                  Form1.GridClips.Row := Form1.GridClips.RowCount-1;
                  GridPlayer:=grClips;
                  GridPlayerRow:=Form1.GridClips.RowCount-1;
                  CheckedActivePlayList;
                  LoadClipsToPlayer;
                end;
              end;
              break;
            end;
          end;
        end else begin
           ps := FindClipInGrid(Form1.GridClips, Form1.lbActiveClipID.Caption);
           ReloadClipInList(Form1.GridClips, ps);
           CheckedActivePlayList;
           LoadClipsToPlayer;
        end;
    1 : begin
          TLParameters.ZeroPoint:=TLParameters.Position;
          TLParameters.Start:=TLParameters.ZeroPoint;
          TLZone.TLScaler.DrawScaler(bmptimeline.Canvas);
          ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
          TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,0);
        end;
    2 : TLParameters.Start:=TLParameters.Position;
    3 : TLParameters.Finish:=TLParameters.Position;
    4 : InsertEventToEditTimeline(-1);
    5 : begin
          crpos := TLZone.TLEditor.CurrentEvents;
          if crpos.Number <> -1 then begin
            TLZone.TLEditor.DeleteEvent(crpos.Number);
            ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
            //TLZone.TLEditor.FindEventPos(TLParameters.ScreenStartFrame)
            TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
            TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,0);
          end;
        end;
         end;
    TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
    TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
  end;
end;

procedure ButtonsControlPlayList(Command : integer);
var i, j, res : integer;
    ps, cntmrk, cntdel : integer;
begin
  with Form1 do begin
            case command of
    0: begin
         //SetMainGridPanel(clips);
          ps := findgridselection(form1.gridprojects, 2);
          if ps=-1 then exit;
          EditPlaylist(-1);
          SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
          GridLists.Repaint;
          cbPlayLists.Clear;
          for i:=1 to GridLists.RowCount-1 do begin
            cbPlayLists.Items.Add((GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Name'));
            j := cbPlayLists.Items.Count-1;
            if not (cbPlayLists.Items.Objects[j] is TMyListBoxObject) then cbPlayLists.Items.Objects[j] := TMyListBoxObject.Create;
            (cbPlayLists.Items.Objects[j] as TMyListBoxObject).ClipId := (GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
          end;
          ps:=findgridselection(GridLists,2);
          if ps<>-1 then cbPlayLists.ItemIndex:=ps-1;
          cbPlayListsChange(nil);
       end;
    1:  begin
         //SetMainGridPanel(clips);
          ps := findgridselection(form1.gridprojects, 2);
          if ps=-1 then exit;
          if cbplaylists.ItemIndex=-1 then exit;
          EditPlaylist(cbplaylists.ItemIndex + 1);
          SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
          GridLists.Repaint;
          ps := cbplaylists.ItemIndex;
          cbplaylists.Items.Strings[cbplaylists.ItemIndex]
            := (GridLists.Objects[0,cbplaylists.ItemIndex + 1] as TGridRows).MyCells[3].ReadPhrase('Name');
          cbplaylists.ItemIndex := ps;
          cbPlayListsChange(nil);
       end;
    2: begin
         //+++++++++++++++++++++++++
         cntmrk := CountGridMarkedRows(GridActPlayList, 1, 1);
         if cntmrk<>0 then begin
           if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные клипы?',2) then exit;
           cntdel := 0;
           For i:=GridActPlayList.RowCount-1 downto 1 do begin
             if (GridActPlayList.Objects[0,i] as TGridRows).MyCells[1].Mark and (not (GridActPlayList.Objects[0,i] as TGridRows).MyCells[0].Mark)then begin
               cntdel := cntdel + 1;
               EraseClipInWinPrepare((GridActPlayList.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
               MyGridDeleteRow(GridActPlayList, i, RowGridClips);
             end;
           end;
           GridActPlayList.Repaint;
           MyTextMessage('Сообщение','Выделено клипов ' + inttostr(cntmrk) + ', удалено ' + inttostr(cntdel) + '.',1);
         end else begin
           if (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[0].Mark then begin
             MyTextMessage('Сообщение','Клип защищен от удаления.',1);
             exit;
           end;
           if MyTextMessage('Вопрос', 'Вы действительно хотите удалить выбранный клип?',2) then begin
             EraseClipInWinPrepare((GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
             MyGridDeleteRow(GridActPlayList, GridActPlayList.Row, RowGridClips);
           end;
         end;
         //+++++++++++++++++++++++++
         SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
         if cbplaylists.ItemIndex<>-1 then begin
           CheckedActivePlayList;
         end;
       end;
    3: PlayClipFromActPlaylist;
            end;//case
    GridActPlayList.Repaint;
  end;
end;

procedure ButtonsControlClipsPanel(Command : integer);
var i, res : integer;
    nm, txt : string;
    ps, cntmrk, cntdel : integer;
begin
  with Form1 do begin
    if (GridProjects.RowCount=2) and (GridProjects.Row=1) and ((GridProjects.Objects[0,1] as TGridRows).ID<=0) then exit;
    ps := findgridselection(gridprojects, 2);
    if ps <= 0 then begin
      MyTextMessage('Сообщение','Не выбрано ни одого проекта.',1);
      exit;
    end;
    //res:=pnlbtnsclips.ClickButton(imgpnlbtnsclips.canvas,x,y);
    pnlbtnsclips.Enable:=false;
         case command of
    0: begin
         EditClip(-1);
         SaveGridToFile(PathTemp + '\Clips.lst', Form1.GridClips);
         CheckedActivePlayList;
       end;
    1: begin
         EditClip(-100);
         SaveGridToFile(PathTemp + '\Clips.lst', Form1.GridClips);
         CheckedActivePlayList;
       end;
    5: begin
         //+++++++++++++++++++++++++
         cntmrk := CountGridMarkedRows(GridClips, 1, 1);
         if cntmrk<>0 then begin
           if Not MyTextMessage('Вопрос', 'Вы действительно хотите удалить все выделенные клипы?',2) then exit;
           cntdel := 0;
           For i:=GridClips.RowCount-1 downto 1 do begin
             if (GridClips.Objects[0,i] as TGridRows).MyCells[1].Mark and (not (GridClips.Objects[0,i] as TGridRows).MyCells[0].Mark)then begin
               cntdel := cntdel + 1;
               nm := PathClips + '\' + nm + '.clip';
               if FileExists(nm) then DeleteFile(nm);
               EraseClipInWinPrepare((GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
               MyGridDeleteRow(GridClips, i, RowGridClips);
             end;
           end;
           if (GridClips.RowCount=2) and (GridClips.Row=1) and ((GridClips.Objects[0,GridClips.Row] as TGridRows).ID<=0)
               then ClearClipsPanel;
           GridClips.Repaint;
           MyTextMessage('Сообщение','Выделено клипов ' + inttostr(cntmrk) + ', удалено ' + inttostr(cntdel) + '.',1);
         end else begin
           if (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[0].Mark then begin
             MyTextMessage('Сообщение','Клип защищен от удаления.',1);
             exit;
           end;
           if MyTextMessage('Вопрос', 'Вы действительно хотите удалить выбранный клип?',2) then begin
             nm := PathClips + '\' + nm + '.clip';
             if FileExists(nm) then DeleteFile(nm);
             EraseClipInWinPrepare((GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
             MyGridDeleteRow(GridClips, GridClips.Row, RowGridClips);
             if (GridClips.RowCount=2) and (GridClips.Row=1) and ((GridClips.Objects[0,GridClips.Row] as TGridRows).ID<=0)
               then ClearClipsPanel;
           end;
         end;
         //+++++++++++++++++++++++++
         SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
         if cbPlayLists.ItemIndex<>-1 then begin
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
         //ps := findgridselection(gridlist, 2);
         if cbPlayLists.itemIndex=-1 then begin
           MyTextMessage('Сообщение','Не выбран активный плей-лист.',1);
           exit;
         end;
         LoadClipsToPlayList;
         SetMainGridPanel(actplaylist);
         if cbPlayLists.ItemIndex<>-1 then begin
           txt := (cbPlayLists.Items.Objects[cbPlayLists.ItemIndex] as TMyListBoxObject).ClipId;
           SaveGridToFile(PathPlayLists + '\' + txt, GridActPlayList);
         end;
       end;
         end; //case
    pnlbtnsclips.Enable:=true;
    GridClips.Repaint;
  end;
end;

procedure SwitcherVideoPanels(command : integer);
var crpos : teventreplay;
begin
  with Form1 do begin
       case command of
  0: begin
       pnImageScreen.Visible := false;
       MyMediaSwitcher.Select:=0;
     end;
  1: begin
       pnImageScreen.Left := pnMovie.Left;
       pnImageScreen.Top := pnMovie.Top;
       pnImageScreen.Width := pnMovie.Width;
       pnImageScreen.Height := pnMovie.Height;
       pnImageScreen.Visible := true;
       crpos := TLZone.TLEditor.CurrentEvents;
       if crpos.Number <> -1
         then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image)
         else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '');
       TemplateToScreen(crpos);
       MyMediaSwitcher.Select:=1;
     end;
       end;
    MyMediaSwitcher.Draw(imgTypeMovie.Canvas);
    imgTypeMovie.Repaint;
  end;
end;

procedure ControlButtonsPrepare(command : integer);
var i, j, res, ps : integer;
    crpos : teventreplay;
    tmpos : longint;
    bl : boolean;
begin
  with Form1 do begin
       case command of
  0    : begin
           tmpos:=TLParameters.Position;
           crpos := TLZone.TLEditor.CurrentEvents;
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;
                case  TLZone.TLEditor.TypeTL of
           tldevice : begin
                        if crpos.Number=-1 then exit;
                        if crpos.Number=0 then begin
                          TLZone.TLEditor.Events[crpos.Number].Start:=tmpos;
                          TLZone.Timelines[ps].Events[crpos.Number].Start:=tmpos;
                        end else begin
                          TLZone.TLEditor.Events[crpos.Number].Start:=tmpos;
                          TLZone.Timelines[ps].Events[crpos.Number].Start:=tmpos;
                          TLZone.TLEditor.Events[crpos.Number-1].Finish:=tmpos;
                          TLZone.Timelines[ps].Events[crpos.Number-1].Finish:=tmpos;
                        end;
                      end;
           tltext   : begin
                        if crpos.Number<>-1 then begin
                          if (TLZone.TLEditor.Events[crpos.Number].Start=tmpos) and (crpos.Number > 0) then begin
                            TLZone.TLEditor.Events[crpos.Number-1].Finish:=tmpos;
                            TLZone.Timelines[ps].Events[crpos.Number-1].Finish:=tmpos;
                          end else begin
                            TLZone.TLEditor.Events[crpos.Number].Start:=tmpos;
                            TLZone.Timelines[ps].Events[crpos.Number].Start:=tmpos;
                          end;
                        end else begin
                          if TLParameters.Position > TLZone.TLEditor.Events[TLZone.TLEditor.Count-1].Finish then begin
                            TLZone.TLEditor.Events[TLZone.TLEditor.Count-1].finish:=tmpos;
                            TLZone.Timelines[ps].Events[TLZone.TLEditor.Count-1].finish:=tmpos;
                          end else begin
                            for i :=0 to TLZone.TLEditor.Count-2 do begin
                              if (TLZone.TLEditor.Events[i].Finish<=TLParameters.Position)
                                 and (TLZone.TLEditor.Events[i+1].Start > TLParameters.Position)
                                then begin
                                  TLZone.TLEditor.Events[i].Finish:=tmpos;
                                  TLZone.Timelines[ps].Events[i].Finish:=tmpos;
                                end;
                            end;
                          end;
                        end;;
                      end;
           tlmedia  : exit;
                end;
           //TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,0);
           TLZone.TLEditor.UpdateScreen(bmpTimeline.Canvas);
           TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,0);
           TLZone.DrawTimelines(imgTimelines.Canvas,bmpTimeline);
         end;
  1    : begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;

           crpos := TLZone.TLEditor.CurrentEvents;
           if (TLParameters.Position < TLZone.TLEditor.Events[0].Start) then crpos.Number:=0;

                case  TLZone.TLEditor.TypeTL of
           tldevice : if crpos.Number = 0 then begin
                        if TLParameters.Position < TLZone.TLEditor.Events[0].Start then begin
                          TLZone.TLEditor.Events[0].Start := TLParameters.Position;
                          TLZone.Timelines[ps].Events[0].Start:=TLParameters.Position;
                        end;
                      end else begin
                        if crpos.Number < TLZone.TLEditor.Count-1 then begin
                          if TLZone.TLEditor.Events[crpos.Number].Start=TLParameters.Position then exit;
                          if crpos.Number=0 then begin
                            TLZone.TLEditor.Events[crpos.Number].Start:=TLParameters.Position;
                            TLZone.Timelines[ps].Events[crpos.Number].Start:=TLParameters.Position;
                          end else begin
                            TLZone.TLEditor.Events[crpos.Number+1].Start:=TLParameters.Position;
                            TLZone.Timelines[ps].Events[crpos.Number+1].Start:=TLParameters.Position;
                            TLZone.TLEditor.Events[crpos.Number].Finish:=TLParameters.Position;
                            TLZone.Timelines[ps].Events[crpos.Number].Finish:=TLParameters.Position;
                          end;
                        end;
                      end;
           tltext,
           tlmedia :  if crpos.Number=0 then begin
                        if (TLParameters.Position < TLZone.TLEditor.Events[0].Start) then begin
                          TLZone.TLEditor.Events[0].Start:=TLParameters.Position;
                          TLZone.Timelines[ps].Events[0].Start:=TLParameters.Position;
                        end else begin
                          TLZone.TLEditor.Events[0].Finish:=TLParameters.Position;
                          TLZone.Timelines[ps].Events[0].Finish:=TLParameters.Position;
                        end;
                      end else begin
                       if crpos.Number=TLZone.TLEditor.Count - 1 then begin
                         TLZone.TLEditor.Events[TLZone.TLEditor.Count - 1].Finish:=TLParameters.Position;
                         TLZone.Timelines[ps].Events[TLZone.TLEditor.Count - 1].Finish:=TLParameters.Position;
                       end else begin
                       for i:=0 to TLZone.TLEditor.Count-2 do begin
                         if (TLZone.TLEditor.Events[i].Finish<=TLParameters.Position)
                           and (TLZone.TLEditor.Events[i+1].Start > TLParameters.Position)
                         then begin
                           TLZone.TLEditor.Events[i+1].Start:=TLParameters.Position;
                           TLZone.Timelines[ps].Events[i+1].Start:=TLParameters.Position;
                           break;
                         end else begin
                           if (TLZone.TLEditor.Events[i].Finish>TLParameters.Position)
                             and (TLZone.TLEditor.Events[i].Start < TLParameters.Position)
                           then begin
                             TLZone.TLEditor.Events[i].Finish:=TLParameters.Position;
                             TLZone.Timelines[ps].Events[i].Finish:=TLParameters.Position;
                             break;
                           end;
                         end;;
                       end;
                       end;
                     end;
                end;

           TLZone.TLEditor.UpdateScreen(bmpTimeline.Canvas);
           for i:=0 to TLZone.Count-1 do TLZone.Timelines[i].DrawTimeline(bmptimeline.Canvas,i,0);
           TLZone.DrawTimelines(imgTimelines.Canvas,bmpTimeline);
         end;
  2    : begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;
           ShiftTimelines;
           TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,0);
           for i:=0 to TLZone.Count-1 do TLZone.Timelines[i].DrawTimeline(bmptimeline.Canvas,i,0);
           TLZone.DrawTimelines(imgTimelines.Canvas,bmpTimeline);
         end;
  3    : begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;
           SetShortNumber;
           //ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,0);
           TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,0);
           TLZone.DrawTimelines(imgTimelines.Canvas,bmpTimeline);
         end;
  4    : begin PrintTimelines; end;
  5    : begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;
           evswapbuffer.Cut;
         end;
  6    :  begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;
           evswapbuffer.Copy;
          end;
  7    :  begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;
           evswapbuffer.Paste;
         end;
  8    : begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           bl:=false;
           for i:=0 to TLZone.TLEditor.Count-1
             do if TLZone.TLEditor.Events[i].Select then bl := true;
           if bl then begin
             If not MyTextMessage('Вопрос','Удалить выделенные значения, без возможности востановления?',2) then exit;
             for i:=TLZone.TLEditor.Count-1 downto 0
               do if TLZone.TLEditor.Events[i].Select then TLZone.TLEditor.DeleteEvent(i);
           end else begin
             crpos := TLZone.TLEditor.CurrentEvents;
             if crpos.Number=-1 then exit;
             If not MyTextMessage('Вопрос','Удалить текущее значение, без возможности востановления?',2) then exit;
             TLZone.TLEditor.DeleteEvent(crpos.Number);
           end;
           TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
           TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,0);
           TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,0);
           TLZone.DrawTimelines(imgTimelines.Canvas,bmpTimeline);
           if TLZone.TLEditor.TypeTL = tldevice then begin
             crpos := TLZone.TLEditor.CurrentEvents;
             if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image);
             TemplateToScreen(crpos);
             if pnImageScreen.Visible then Image3.Repaint;
           end;
         end;
  9    : begin
           LoadFromUNDO;
           ps:=ZoneNames.Edit.GridPosition(Form1.GridTimeLines, ZoneNames.Edit.IDTimeline);
           SetPanelTypeTL((Form1.GridTimeLines.Objects[0,ps] as TTimelineOptions).TypeTL, ps);
           ZoneNames.Draw(imgTLNames.Canvas, Form1.GridTimeLines, true);
           TLZone.DrawBitmap(bmptimeline);
           TLZone.DrawTimelines(ImgTimelines.Canvas,bmptimeline);
           if (mode<>play) then begin
             MediaSetPosition(TLParameters.Position, false);
             mediapause;
             crpos := TLZone.TLEditor.CurrentEvents;
             if crpos.Number <> -1
               then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image)
               else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '');
               TemplateToScreen(crpos);
           end;
         end;
       end;
  end;
end;

Procedure ControlPlayerTransmition(command : integer);
var i, res :integer;
    crpos : teventreplay;
    posi : longint;
begin
  with Form1 do begin
     case command of
  0 : begin
        SaveToUNDO;
        TLParameters.Position:=TLParameters.Start; //TLParameters.ZeroPoint;
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
      end;
  1 : begin
        SaveToUNDO;
        posi:=-1;
        if TLZone.TLEditor.Count <= 0 then exit;
        if TLParameters.Position < TLZone.TLEditor.Events[0].Start then exit;
        if TLParameters.Position > TLZone.TLEditor.Events[TLZone.TLEditor.Count-1].Start then begin
          TLParameters.Position:=TLZone.TLEditor.Events[TLZone.TLEditor.Count-1].Start;
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
        crpos := TLZone.TLEditor.CurrentEvents;
        if crpos.Number = -1 then begin
           for i:=0 to TLZone.TLEditor.Count-2 do begin
              if (TLParameters.Position >=TLZone.TLEditor.Events[i].Finish)
                   and (TLParameters.Position <=TLZone.TLEditor.Events[i+1].Start)
              then begin
                posi := i;
                break;
              end;
           end;
        end else if crpos.Number = 0 then posi := 0 else posi := crpos.Number - 1;
        TLParameters.Position:=TLZone.TLEditor.Events[posi].Start;
        crpos := TLZone.TLEditor.CurrentEvents;
        MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image);
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
      end;
  2 : begin
        SaveToUNDO;
        posi:=-1;
        if TLZone.TLEditor.Count <= 0 then exit;
        if TLParameters.Position >= TLZone.TLEditor.Events[TLZone.TLEditor.Count-1].Start then exit;
        if TLParameters.Position < TLZone.TLEditor.Events[0].Start then begin
          TLParameters.Position:=TLZone.TLEditor.Events[0].Start;
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
        crpos := TLZone.TLEditor.CurrentEvents;
        if crpos.Number = -1 then begin
           for i:=0 to TLZone.TLEditor.Count-2 do begin
              if (TLParameters.Position >=TLZone.TLEditor.Events[i].Finish)
                   and (TLParameters.Position <=TLZone.TLEditor.Events[i+1].Start)
              then begin
                posi := i+1;
                break;
              end;
           end;
        end else posi := crpos.Number + 1;
        TLParameters.Position:=TLZone.TLEditor.Events[posi].Start;
        crpos := TLZone.TLEditor.CurrentEvents;
        MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image);
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
      end;
  3 : begin
        SaveToUNDO;
        TLParameters.Position:=TLParameters.Finish; //TLParameters.ZeroPoint;
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
      end;
     end; //case
  end;//with
end;


procedure ControlPlayerFastSlow(command : integer);
var crpos : teventreplay;
    rightlimit : longint;
begin
        case command of
  0 : begin
        if mode=play then begin
          SpeedMultiple:=SpeedMultiple / 4;
          MediaSlow(4);
        end else begin
          if TLParameters.Position<=TLParameters.Preroll then begin
            TLParameters.Position:=TLParameters.Preroll;
            TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
            Form1.imgtimelines.Repaint;
            exit;
          end;
          TLParameters.Position:=TLParameters.Position-StepMouseWheel;
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
        end;
      end;
  1 : begin
        if mode=play then begin
          SpeedMultiple:=SpeedMultiple / 2;
          MediaSlow(2);
        end else begin
          if TLParameters.Position<=TLParameters.Preroll then begin
            TLParameters.Position:=TLParameters.Preroll;
            TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
            Form1.imgtimelines.Repaint;
            exit;
          end;
          TLParameters.Position:=TLParameters.Position-1;
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
        end;
      end;
  2 : begin
        if mode=play then begin
          SpeedMultiple:=SpeedMultiple * 2;
          MediaFast(2);
        end else begin
          rightlimit := TLParameters.Preroll + TLParameters.Duration + TLParameters.Postroll
                                             - (TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame)
                                             + TLParameters.MyCursor div TLParameters.FrameSize;
          if TLParameters.Position > rightlimit then begin
            TLParameters.Position:=rightlimit;
            TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
            Form1.imgtimelines.Repaint;
            exit;
          end;
          TLParameters.Position:=TLParameters.Position+1;
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
        end;
      end;
  3 : begin
        if mode=play then begin
          SpeedMultiple:=SpeedMultiple * 4;
          MediaFast(4);
        end else begin
          rightlimit := TLParameters.Preroll + TLParameters.Duration + TLParameters.Postroll
                                             - (TLParameters.ScreenEndFrame - TLParameters.ScreenStartFrame)
                                             + TLParameters.MyCursor div TLParameters.FrameSize;
          if TLParameters.Position > rightlimit then begin
            TLParameters.Position:=rightlimit;
            TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
            Form1.imgtimelines.Repaint;
            exit;
          end;
          TLParameters.Position:=TLParameters.Position+StepMouseWheel;
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
        end;
      end;
        end;//case
end;


end.
