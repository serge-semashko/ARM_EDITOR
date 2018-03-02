unit UCommon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid, uwaiting, JPEG,
  Math, FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend, PasLibVlcUnit,
  vlcpl, ustartwindow, ufrhotkeys, System.JSON, StrUtils;

Type
  TGridPlayer = (grClips, grPlaylist, grDefault);
  TSinchronization = (chltc, chsystem, chnone1);
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

  TListParam = record
    Name : String;
    Text : String;
    VarText : String;
  end;

Const
  DirProjects  = 'Projects';
  DirFiles = 'Clips';
  DirTemplates = '\Templates';
  DirClips     = '\Clips';
  DirPlayLists      = '\PlayLists';
  DirTemp      = '\Temp';
  DirLog  = '\Log';
  DirKeylayouts = '\Keylayouts';
  Alphabet = '0123456789��������������������������������abcdefghijklmnopqrstuvwxyz';

Var

//�������� ������������ ��������� ��� ������� ���������
  //IDTL : longint = 0;     // ��� ������������ IDTimeline
  IDCLIPS : longint = 0;  // ��� ������������ IDClips
  IDPROJ : longint = 0;   // ��� ������������ IDProj
  IDPLst : longint = 0;   // ��� ������������ IDLst
  IDTXTTmp : longint = 0; // ��� ������������ IDTXTTmp
  IDGRTmp : longint = 0;  // ��� ������������ IDGRTmp
  IDEvents : longint = 0; // ��� ������������ IDEvents
  szFontEvents1, szFontEvents2 : integer;
  dbld1, dbld2 : double;  // ��������� ������� ���������� �������
  DrawTimeineInProgress : boolean = false; //������� ��������� ���� �����
  LoadImageInProgress : boolean = false;

  FWait : TFWaiting;
  FStart : TFrStartWindow;
//��������� �������������
  MyShift      : double = 0; //�������� LTC ������������ ���������� �������
  TCExists     : boolean = false;
  MyShiftOld   : double = 0; //������ �������� LTC ������������ ���������� �������
  MyShiftDelta : double = 0;
  MySinhro     : TSinchronization = chsystem; //��� �������������
  MyStartPlay  : longint = -1;    // ����� ������ �����, ��� chnone �� ������������, -1 ����� �� �����������.
  MyStartReady : boolean = false; // True - ���������� � ������, false - ����� �����������.
  MyRemainTime : longint = -1;  //����� ���������� �� �������

//�������� ��������� ���������
  MainWindowStayOnTop : boolean = false;
  MainWindowMove : boolean = true;
  MainWindowSize : boolean = true;
  IsProjectChanges : boolean = false;
  MakeLogging : boolean = true;
  StepCoding : integer =5;
  StepMouseWheel : integer = 10;
  SpeedMultiple : double = 1;
  DepthUNDO : integer = 20;
  AppPath, AppName : string;
  DefaultClipDuration : longint = 10500;
  SynchDelay : integer = 2;
  InputWithoutUsers : boolean = true;
  FileNameProject : string ='';
  ListEditedProjects : tstrings;
  ListVisibleWindows : tstrings;
  PredClipID : string = '';

  WorkDirGRTemplate : string ='';
  WorkDirTextTemplate  : string ='';
  WorkDirClips  : string ='';
  WorkDirSubtitors  : string ='';
  WorkDirKeyLayouts : string = '';

  PathFiles : string;
  PathProject : string;
  PathClips : string;
  PathPlayLists : string;
  PathTemp : string;
  PathTemplates : string;
  PathLog : string;
  PathKeyLayouts : string;

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
  OldProgrammFontColor : tcolor = clWhite;
  ProgrammFontName : tfontname = 'Arial';
  ProgrammFontSize : integer = 10;
  ProgrammEditColor : tcolor = clWhite;
  ProgrammEditFontColor : tcolor = clBlack;
  ProgrammEditFontName : tfontname = 'Arial';
  ProgrammEditFontSize : integer = 14;
  ProgrammBtnFontSize : Integer = 10;
  ProgrammHintBtnFontName : tfontname = 'Arial';
  ProgrammHintBTNSFontColor : tcolor = clBlack;
  ProgrammHintBTNSFontSize : Integer = 9;

  CurrentUser : string = '';
  bmpTimeline : TBitmap;
  bmpEvents : TBitmap;
  bmpAirDevices : TBitmap;
  //Image24 : TFastDIB;

  GridPlayer : TGridPlayer = grPlayList;
  GridPlayerRow  : integer = -1;
  UpdateGridTemplate : boolean = true;

  TextRichSelect : boolean = false;

//�������� ��������� ��������������� ����
  FormsColor : tcolor = clBackground;
  FormsFontColor : tcolor = clWhite;
  FormsFontSize : integer = 10;
  FormsSmallFont : integer = 8;
  FormsFontName : tfontname = 'Arial';
  FormsEditColor : tcolor = clWindow;
  FormsEditFontColor : tcolor = clBlack;
  FormsEditFontSize : integer = 10;
  FormsEditFontName : tfontname = 'Arial';

//�������� ��������� ������
  GridBackGround : tcolor = clBlack;
  GridColorPen : tcolor = clWhite;
  //GridMainFontColor : tcolor = clWhite;
  GridColorRow1 : tcolor = $211F1F;
  GridColorRow2 : tcolor = $211F1F;//$201E1E;
  GridColorSelection : tcolor = $212020;
  PhraseErrorColor : tcolor = clRed;
  PhrasePlayColor : tcolor = clLime;

  GridTitleFontName : tfontname = 'Arial';
  GridTitleFontColor : tcolor = clWhite;
  GridTitleFontSize : Integer = 14;
  GridTitleFontBold : boolean = true;
  GridTitleFontItalic : boolean = false;
  GridTitleFontUnderline : boolean = false;
  GridFontName : tfontname = 'Arial';
  GridFontColor : tcolor = clWhite;
  GridFontSize : Integer = 11;
  GridFontBold : boolean = false;
  GridFontItalic : boolean = false;
  GridFontUnderline : boolean = false;
  GridSubFontName : tfontname = 'Arial';
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

//�������� ��������� ����-�����
  TLBackGround : tcolor = $211F1F;
  TLZoneNamesColor : tcolor = $505050;
  TLZoneFontColorSelect  : tcolor = $057522;
  TLZoneNamesFontSize : integer = 14;
  TLZoneNamesFontColor : tcolor = clWhite;
  TLZoneNamesFontName : tfontname = 'Arial';
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
  //Layer2FontColor : tcolor = $202020;
  Layer2FontSize : integer = 8;
  StatusColor : array[0..4] of tcolor = (clRed,clGreen,clBlue,clYellow,clSilver);
  isZoneEditor : boolean = false;
  TLMaxFrameSize : integer = 10;
  TLPreroll  : longint = 250;
  TLPostroll : longint = 3000;
  TLFlashDuration : integer = 5;
  //TLFontColor : tcolor = clWhite;

  //�������� ��������� ������
  ProgBTNSFontName : tfontname = 'Arial';
  ProgBTNSFontColor : tcolor = clWhite;
  ProgBTNSFontSize : Integer = 10;
  HintBTNSFontName : tfontname = 'Arial';
  HintBTNSFontColor : tcolor = clBlack;
  HintBTNSFontSize : Integer = 9;
  //��������� ���� �����
  RowsEvents : integer = 7;
  AirBackGround     : tcolor = $211F1F;
  AirForeGround     : tcolor = $211F1F;
  AirColorTimeLine  : tcolor = $211F1F;
  DevBackGround     : tcolor = $211F1F;
  TimeForeGround    : tcolor = $211F1F;
  TimeSecondColor   : tcolor = $211F1F;
  AirFontComment    : tcolor = clYellow;
  StartColorCursor  : tcolor = clGreen;
  EndColorCursor   : tcolor = clBlue;


  //AirZoneNamesColor : tcolor = $505050;

  //�������� ��������� ������
  PrintSpaceLeft       : Real = 5;
  PrintSpaceTop        : Real = 5;
  PrintSpaceRight      : Real = 5;
  PrintSpaceBottom     : Real = 5;
  PrintHeadLineTop     : Real = 5;
  PrintHeadLineBottom  : Real = 5;
  PrintCol1            : string = '����';
  PrintCol2            : string = '������';
  PrintCol3            : string = '�����������';
  PrintCol4            : string = '������';
  PrintCol5            : string = '�����';
  PrintCol61           : string = '�����������';
  PrintCol62           : string = '����� �����';
  PrintDeviceName      : string = '������';

  PrintEventShift      : integer = 30;


  //�������� ��������� ������ ������� ������
  KEYFontName    : tfontname;
  KEYColorNew    : tcolor = clLime;
  WorkHotKeys    : TMyListHotKeys;
  NAMEKeyLayout  : string;

  //������� ������� ��� ������ �������
  MTFontSize : integer = 15;
  MTFontSizeS : integer = 16;
  MTFontSizeB : integer = 18;


//Procedure SetMainGridPanel(TypeGrid : TTypeGrid);
function UserExists(User,Pass : string) : boolean;
function SetMainGridPanel(TypeGrid : TTypeGrid) : boolean;
function TwoDigit(dig : integer) : string;
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
function MyTimeToStr : string;
function TimeToTimeCodeStr(dt : tdatetime) : string;
function StrTimeCodeToFrames(tc : string) : longint;
function createunicumname : string;
procedure CreateDirectories1;
procedure UpdateProjectPathes(NewProject : string);
procedure initnewproject;
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
Procedure CheckedClipsInList;
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
procedure LoadImage(FileName:string; Image : TImage);
procedure LoadBitmap(FileName:string; bmp : TBitmap; Width, Height : integer; ClearColor : tcolor);
procedure ReadEditedProjects;
procedure WriteEditedProjects(CProj : string);
procedure EnableProgram;
procedure SaveClipFromPanelPrepare;
procedure updateImageTemplateGrids;
procedure ClearClipsStatusPlay;
procedure Delay(const AMilliseconds: Cardinal);
Function GetHotKeysCommand(Key: Word; Shift: TShiftState) : word;
function FindNextClipTime(Grid : tstringgrid; dtime : tdatetime) : integer;
function FindNextClipTime1(Grid : tstringgrid; dtime : tdatetime) : integer;
function FindPredClipTime(Grid : tstringgrid; dtime : tdatetime) : integer;
function SynchroLoadClip(Grid : tstringgrid) : boolean;
procedure SortGridStartTime(Grid : tstringgrid; Direction : boolean);
function TColorToTfcolor(Color : TColor) : TFColor;
procedure readlistvisiblewindows(handle : hwnd);
function WindowInVisibleList(Name : string) : boolean;
//procedure GetProtocolsList(SrcStr, Name : widestring; var List : tstrings); overload;
procedure GetProtocolsList(SrcStr, Name : string; List : tstrings); //overload;
function GetProtocolsStr(SrcStr, Name : string) : string;
function GetProtocolsParam(SrcStr, Name : string) : string;
function GetProtocolsParamEx(SrcStr : string; Number : integer) : TListParam;
procedure GetListParam(SrcStr : string; lst : tstrings);

//===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
//========================  Helpers ��� �������. ���������� � JSON � �������� ==
//==============================================================================

Procedure addVariableToJson(var json:tjsonobject; varName: string; varvalue: variant);
Function getVariableFromJson(var json:tjsonobject; varName: string;varvalue: variant):variant;
//===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
//========================  Helpers ��� �������. ���������� � JSON � �������� ==
//==============================================================================

implementation
uses umain, uproject, uinitforms, umyfiles, utimeline, udrawtimelines, ugrtimelines,
     uplaylists, uactplaylist, uplayer, uimportfiles, ulock, umyundo, uimgbuttons,
     ushifttl, UShortNum, UEvSwapBuffer, UMyMessage, uairdraw, UMyMediaSwitcher,
     UGridSort, UImageTemplate, UTextTemplate, umyprint, umediacopy, UMyTextTemplate,
     umymenu, ufrlisterrors, umytexttable;

//===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
//========================  Helpers ��� �������. ���������� � JSON � �������� ==
//==============================================================================
  Function getVariableFromJson(var json:tjsonobject; varName: string;varvalue: variant):variant;
  var
    tmpjson: tjsonvalue;
    tmpstr : string;
    res : variant;
  begin
    tmpjson := json.GetValue(varName);
    if (tmpjson <> nil) then
    begin
     tmpStr:= tmpjson.Value;
//     varValue := tmpStr;
     result :=tmpstr;
    end;
  end;

  Procedure addVariableToJson(var json:tjsonobject; varName: string; varvalue: variant);
  var
    teststr: ansistring;
    list: TStringList;
    numElement: integer;
    utf8val: string;
    tmpjson: tjsonvalue;
    retval: string;
    strValue : string;
    vType : tvarType;
    tmpInt : integer;
  begin
    FormatSettings.DecimalSeparator := '.';
    vtype:=varType(varValue);
    strValue := varValue;
    utf8val := stringOf(tencoding.UTF8.GetBytes(strValue));
    json.AddPair(varName, strvalue);
  end;
//===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
//========================  END Helpers ��� �������. ���������� � JSON � �������� ==
//==============================================================================



//procedure GetProtocolsList(SrcStr, Name : widestring; var List : tstrings); overload;
//var slst,ssrc, sstr, estr, stmp : string;
//    pss, pse : integer;
//begin
//  List.Clear;
//  ssrc := lowercase(srcstr);
//  sstr := '<' + lowercase(trim(Name))+'=';
//  estr := '>';
//  pss := pos(sstr,ssrc);
//  stmp := copy(ssrc,pss,length(ssrc));
//  pse := pos(estr,stmp);
//  while (pss<>0) or (pse<>0) do begin
//    slst:=Copy(stmp,1,pse);
//    slst := StringReplace(slst,sstr,'',[rfReplaceAll, rfIgnoreCase]);
//    slst := StringReplace(slst,estr,'',[rfReplaceAll, rfIgnoreCase]);
//    if trim(slst)<>'' then List.Add(slst);
//    pss := pos(sstr,ssrc);
//    stmp := copy(ssrc,pss,length(ssrc));
//    pse := pos(estr,stmp);
//  end;
//end;

procedure GetListParam(SrcStr : string; lst : tstrings);
var ssrc, sstr, stmp, ssc, ss1, ss2 : string;
    i, pss, pse, ps1, ps2 : integer;
begin
  lst.Clear;
  pss:=1;
  pse:=posex('|',SrcStr,pss);
  while pse<>0 do begin
    stmp := copy(SrcStr,pss,pse-pss);
    stmp := StringReplace(stmp,'|','',[rfReplaceAll, rfIgnoreCase]);
    if trim(stmp)<>'' then begin
      ps1 := posex('[',stmp,1);
      ps2 := posex(']',stmp,ps1);
      if (ps1<>0) and (ps2<>0) then begin
        ssc := Copy(stmp,1,ps1-1);
        ss1 := Copy(stmp,ps1+1,ps2-ps1-1);
        ps1 := posex('..',ss1,1);
        if ps1<>0 then begin
          ss2:=copy(ss1,ps1+2,length(ss1));
          ss1:=copy(ss1,1,ps1-1);
          for i:=strtoint(ss1) to strtoint(ss2) do lst.Add(ssc + inttostr(i));
        end else lst.Add(stmp);
      end else lst.Add(stmp);
    end;
    pss:=pse+1;
    pse:=posex('|',SrcStr,pss);
  end;
  stmp := copy(SrcStr,pss,length(SrcStr));
  stmp := StringReplace(stmp,'|','',[rfReplaceAll, rfIgnoreCase]);
  if trim(stmp)<>'' then begin
    ps1 := posex('[',stmp,1);
    ps2 := posex(']',stmp,ps1);
    if (ps1<>0) and (ps2<>0) then begin
      ssc := Copy(stmp,1,ps1-1);
      ss1 := Copy(stmp,ps1+1,ps2-ps1-1);
      ps1 := posex('..',ss1,1);
      if ps1<>0 then begin
        ss2:=copy(ss1,ps1+2,length(ss1));
        ss1:=copy(ss1,1,ps1-1);
        for i:=strtoint(ss1) to strtoint(ss2) do lst.Add(ssc + inttostr(i));
      end else lst.Add(stmp);
    end else lst.Add(stmp);
  end;
end;

function GetProtocolsParam(SrcStr, Name : string) : string;
var ssrc, sstr, stmp : string;
    pss, pse : integer;
begin
  result := '';
  ssrc := ansilowercase(srcstr);
  sstr := '<' + ansilowercase(trim(Name))+'=';
  pss:=posex(sstr,ssrc,1);
  pse:=posex('>',ssrc,pss);
  if (pss=0) or (pse=0) then exit;
  stmp := copy(SrcStr,pss,pse-pss);
  stmp := StringReplace(stmp,sstr,'',[rfReplaceAll, rfIgnoreCase]);
  result := StringReplace(stmp,'>','',[rfReplaceAll, rfIgnoreCase]);
end;

function GetProtocolsParamEx(SrcStr : string; Number : integer) : TListParam;
var ssrc, sstr, stmp, snam, stxt, svtxt : string;
    pss, pse : integer;
begin
  result.Name := '';
  result.Text := '';
  result.VarText := '';

  ssrc := ansilowercase(srcstr);
  sstr := '<' + inttostr(Number)+':';
  pss:=posex(sstr,ssrc,1)+length(sstr);
  pse:=posex('>',ssrc,pss);
  if (pss=0) or (pse=0) then exit;
  stmp := copy(SrcStr,pss,pse-pss);
  pse := posex('=',stmp,1);
  result.Name:= Copy(stmp,1,pse-1);
  stmp := Copy(stmp,pse+1,length(stmp));

  pse := posex('|',stmp,1);
  result.Text := Copy(stmp,1,pse-1);
  result.VarText := Copy(stmp,pse+1,length(stmp));
  //stmp := StringReplace(stmp,sstr,'',[rfReplaceAll, rfIgnoreCase]);
  //result := StringReplace(stmp,'>','',[rfReplaceAll, rfIgnoreCase]);
end;

procedure GetProtocolsList(SrcStr, Name : string; List : tstrings); //overload;
var slst,ssrc, sstr, estr, stmp : string;
    pss, pse : integer;
begin
  List.Clear;
  ssrc := ansilowercase(srcstr);
  sstr := '<' + ansilowercase(trim(Name));
  estr := '>';
  pss := posex(sstr,ssrc,1);
  //stmp := copy(ssrc,pss,length(ssrc));
  pse := posex(estr,ssrc,pss);
  while (pss<>0) and (pse<>0) do begin
    slst:=Copy(SrcStr,pss,pse-pss);
    slst := StringReplace(slst,sstr,'',[rfReplaceAll, rfIgnoreCase]);
    slst := StringReplace(slst,estr,'',[rfReplaceAll, rfIgnoreCase]);
    if trim(slst)<>'' then List.Add(slst);
    pss := posex(sstr,ssrc,pse);
    pse := pos(estr,ssrc,pss);
    //stmp := copy(ssrc,pss,pse);
  end;
end;

function GetProtocolsStr(SrcStr, Name : string) : string;
var ssrc, sstr, estr, stmp : string;
    pss, pse : integer;
begin
  result := '';
  ssrc := ansilowercase(srcstr);
  sstr := '<' + ansilowercase(trim(Name));
  estr := '</' + ansilowercase(trim(Name));
  pss:=posex(sstr,ssrc,1);
  pse:=posex(estr,ssrc,pss);
  pse:=posex('>',ssrc,pse);
  if (pss=0) or (pse=0) then exit;
  result := copy(SrcStr,pss,pse-pss+1);
  //pse:=PosEx(estr,stmp,pss);
  //if pse=0 then result:=stmp else result:=copy(stmp,1,pse-1);
end;

procedure readlistvisiblewindows(handle : hwnd);
var
  wnd: hwnd;
  buff: array [0 .. 127] of char;
begin
  ListVisibleWindows.clear;
  wnd := GetWindow(handle, gw_hwndfirst);
  while wnd <> 0 do
  begin // �� ����������:
    if (wnd <> Application.handle) // ����������� ����
      and IsWindowVisible(wnd) // ��������� ����
      and (GetWindow(wnd, gw_owner) <> 0) // ���������� ������ �������� ����
      and (GetWindowText(wnd, buff, SizeOf(buff)) <> 0) then
    begin
      GetWindowText(wnd, buff, SizeOf(buff));
      //if StrPas(buff) = '������' then
      // SetForegroundWindow(wnd);
      ListVisibleWindows.Add(StrPas(buff));
    end;
    wnd := GetWindow(wnd, gw_hwndnext);
  end;
  //ListBox1.ItemIndex := 0;
end;

function WindowInVisibleList(Name : string) : boolean;
var i : integer;
begin
  result := false;
  for i:=0 to ListVisibleWindows.Count-1 do begin
    if lowercase(trim(ListVisibleWindows.Strings[i]))=lowercase(trim(Name)) then begin
      result:=true;
      exit;
    end;
  end;
end;


function TColorToTfcolor(Color : TColor) : TFColor;
//�������������� TColor � RGB
var Clr : longint;
begin
  Clr:=ColorToRGB(Color);
  Result.r:=Clr;
  Result.g:=Clr shr 8;
  Result.b:=Clr shr 16;
end;

function cutstring(Text : string; len : integer) : string;
begin
  result:=Text;
  if length(Text)>len then result:=copy(Text,1,len-3) + '...';
end;

procedure ProbingStartTime(Grid : tstringgrid);
var i, j : integer;
    stime, scmp, clp, sdur, scdr, clp1 : string;
    stm, ctm, dur, cdr : longint;
begin
  ListErrors.Clear;
  for i:=1 to Grid.RowCount-1 do begin
    stime := trim((Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('StartTime'));
    clp := cutstring(trim((Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Clip')),50);
    if stime='' then begin
      ListErrors.Add('������������ ����� ������:   [' + inttostr(i) + '] ' + Clp);
    end else begin
      sdur := trim((Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Dur'));
      stm:=StrTimeCodeToFrames(stime);
      dur:=StrTimeCodeToFrames(sdur);
      for j:=i+1 to Grid.RowCount-1 do begin
        scmp := trim((Grid.Objects[0,j] as TGridRows).MyCells[3].ReadPhrase('StartTime'));
        if scmp<>'' then begin
          scdr := trim((Grid.Objects[0,j] as TGridRows).MyCells[3].ReadPhrase('Dur'));
          clp1 := cutstring(trim((Grid.Objects[0,j] as TGridRows).MyCells[3].ReadPhrase('Clip')),50);
          ctm:=StrTimeCodeToFrames(scmp);
          cdr:=StrTimeCodeToFrames(scdr);
          if ((ctm>=stm) and (ctm<=stm+dur)) or ((ctm+cdr>=stm) and (ctm+cdr<=stm+dur))
             or ((stm>=ctm) and (stm<=ctm+cdr)) or ((stm+dur>=ctm) and (stm+dur<=ctm+dur))
          then begin
            ListErrors.Add('����������� ������:           [' + inttostr(i) + '] '
                       + Clp + '    -    [' + inttostr(j) + '] ' + Clp1);
          end;
        end;
      end;
    end;
  end;
  if ListErrors.Count=0 then begin
    MyTextMessage('���������','���� ������ ���������� ����� ������.', 1);
  end else begin
    ShowListErrors;
  end;
end;

function findmintime(Grid : tstringgrid; ARow : integer) : integer;
var i : integer;
    dlt, tm : longint;
    stime : string;
begin
  result := -1;
  dlt := -1;
  for i:=ARow to Grid.RowCount-1 do begin
    stime := (Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('StartTime');
    if trim(stime)=''
      then tm := StrTimeCodeToFrames('24:00:00:00')
      else tm := StrTimeCodeToFrames(stime);
    if dlt=-1 then begin
      dlt:=tm;
      result := i;
    end else begin
      if tm<dlt then begin
        dlt:=tm;
        result := i;
      end;
    end;
  end;
end;

function findmaxtime(Grid : tstringgrid; ARow : integer) : integer;
var i : integer;
    dlt, tm : longint;
    stime : string;
begin
  result := -1;
  dlt := -1;
  for i:=ARow to Grid.RowCount-1 do begin
    stime := (Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('StartTime');
    if trim(stime)=''
      then tm := StrTimeCodeToFrames('24:00:00:00')
      else tm := StrTimeCodeToFrames(stime);
    if dlt=-1 then begin
      dlt:=tm;
      result := i;
    end else begin
      if tm>dlt then begin
        dlt:=tm;
        result := i;
      end;
    end;
  end;
end;

procedure SortGridStartTime(Grid : tstringgrid; Direction : boolean);
var i, j, k : integer;
    f1, f2, rw : longint;
    stime : string;
    temp : tgridrows;
begin
  temp := tgridrows.Create;
  try
    if Direction then begin
      for i:=1 to grid.RowCount-1 do begin
        rw := findmintime(Grid, i);
        if rw=-1 then exit;
        temp.Assign(Grid.Objects[0,rw] as tgridrows);
        (Grid.Objects[0,rw] as tgridrows).Assign(Grid.Objects[0,i] as tgridrows);
        (Grid.Objects[0,i] as tgridrows).Assign(temp);
      end;
    end else begin
      for i:=1 to grid.RowCount-1 do begin
        rw := findmaxtime(Grid, i);
        if rw=-1 then exit;
        temp.Assign(Grid.Objects[0,rw] as tgridrows);
        (Grid.Objects[0,rw] as tgridrows).Assign(Grid.Objects[0,i] as tgridrows);
        (Grid.Objects[0,i] as tgridrows).Assign(temp);
      end;
    end;
  Grid.Repaint;
  finally
    temp.FreeInstance;
  end;
end;

function FindPredClipTime(Grid : tstringgrid; dtime : tdatetime) : integer;
var i, ps : integer;
      //dlt : longint;
    clid, stime, send, stm : string;
    dtnow, dtt, dlt, dtend  : tdatetime;
    //btp : boolean;
begin
  dtnow := dtime-TimeCodeDelta;

  result := -1;
  //btp := false;
  dlt:=-1;
  ps:=-1;
  for i:=1 to Grid.RowCount-1 do begin
    stime:=(Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('StartTime');
    if trim(stime)='' then continue;
    send:=(Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Duration');
    dtt := trunc(dtnow) + FramesToTime(StrTimeCodeToFrames(stime));
    dtend := FramesToTime(StrTimeCodeToFrames(send));
    if (dtt<=dtnow) and (dtt+dtend>=dtnow) then begin
      if dlt=-1 then begin
        dlt:=dtnow-dtt;
        ps:=i;
      end else begin
        if dlt>dtnow-dtt then begin
          dlt:=dtnow-dtt;
          ps:=i;
        end;
      end;
      //btp:=true
    end;
  end;
  if ps>0 then begin
    stime:=(Grid.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('StartTime');
    if trim(stime)<>'' then dtnow :=trunc(dtnow)+FramesToTime(StrTimeCodeToFrames(stime));
  end;
  dlt := -1;
  for i:=1 to Grid.RowCount-1 do begin
    if i=ps then continue;

    stime:=(Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('StartTime');
    if trim(stime)='' then continue;
    dtt := trunc(dtnow)+FramesToTime(StrTimeCodeToFrames(stime));
    //send := (Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Dur');
    //dtend := FramesToTime(StrTimeCodeToFrames(send));
    //dtend := dtt + dtend;
    if dtt<dtnow then begin
      if dlt=-1 then begin
        dlt:=dtnow-dtt;
        result:=i;
      end else begin
        if dlt>dtnow-dtt then begin
          dlt:=dtnow-dtt;
          result:=i;
        end;
      end;
    end;
  end;
end;

function FindNextClipTime1(Grid : tstringgrid; dtime : tdatetime) : integer;
var i, ps : integer;
      //dlt : longint;
    clid, stime, send, stm : string;
    dtnow, dtt, dlt, dtend  : ttime;
    //btp : boolean;
begin

  dtnow := (dtime-trunc(dtime))-TimeCodeDelta;
  result := -1;
  //btp := false;
  dlt:=-1;
  ps:=-1;
  for i:=1 to Grid.RowCount-1 do begin
    stime:=(Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('StartTime');
    if trim(stime)='' then continue;
    send:=(Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Duration');
    dtt := FramesToTime(StrTimeCodeToFrames(stime));
    dtend := FramesToTime(StrTimeCodeToFrames(send));
    if (dtt<=dtnow) and (dtt+dtend>=dtnow) then begin
      if dlt=-1 then begin
        dlt:=dtnow-dtt;
        ps:=i;
      end else begin
        if dlt>dtnow-dtt then begin
          dlt:=dtnow-dtt;
          ps:=i;
        end;
      end;
      //btp:=true
    end;
  end;
  if ps>0 then begin
    stime:=(Grid.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('StartTime');
    if trim(stime)<>'' then begin
      dtt := FramesToTime(StrTimeCodeToFrames(stime));
      send := (Grid.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('Dur');
      dtend := FramesToTime(StrTimeCodeToFrames(send));
      dtnow:=dtt + dtend;
    end;
  end;
  dlt := -1;
  for i:=0 to Grid.RowCount-1 do begin
    stime:=(Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('StartTime');
    if trim(stime)='' then continue;
    dtt := FramesToTime(StrTimeCodeToFrames(stime));
    send := (Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Dur');
    dtend := FramesToTime(StrTimeCodeToFrames(send));
    dtend:=dtt+dtend;
    if dtend>dtnow then begin
      if dlt=-1 then begin
        dlt:=dtend-dtnow;
        result:=i;
      end else begin
        if dlt<dtnow-dtend then begin
          dlt:=dtend-dtnow;
          result:=i;
        end;
      end;
    end;
  end;
end;

function FindNextClipTime(Grid : tstringgrid; dtime : tdatetime) : integer;
var i, ps : integer;
      //dlt : longint;
    stime, send : string;
    dtnow, dtt, dlt, dtend  : tdatetime;
begin
  dtnow := dtime-TimeCodeDelta;
  result :=-1;
  dlt :=-1;
  for i:=0 to Grid.RowCount-1 do begin
    if Grid.Objects[0,i] is TGridRows then begin
      stime:=(Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('StartTime');
      if trim(stime)='' then continue;

      send:=(Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Dur');
      if trim(send)='' then dtend:=0 else dtend:=FramesToTime(StrTimeCodeToFrames(send));

      if trim(stime)<>'' then begin
        dtt:=trunc(dtnow) + FramesToTime(StrTimeCodeToFrames(stime));
        dtend:=dtt + dtend;
        if dtend<dtnow then continue;
        if (dtt<=dtnow) and (dtnow<dtend) then begin
           result:=i;
           exit;
        end;
        if dtt>dtnow then begin
          if dlt=-1 then begin
            dlt:=dtt-dtnow;
            result:=i;
          end else begin
            if (dtt-dtnow)<dlt then begin
              dlt:=dtt-dtnow;
              result:=i;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function sourceclipsstr : string;
begin
  if GridPlayer=grClips then begin
     result:='������ ������';
  end else begin;
    if form1.listbox1.ItemIndex=-1
      then form1.lbusesclpidlst.Caption := '����-����: '
      else form1.lbusesclpidlst.Caption := '����-����: ' + trim(form1.ListBox1.Items.Strings[form1.ListBox1.ItemIndex]);
  end;
end;

function SynchroLoadClip(Grid : tstringgrid) : boolean;
var rw : integer;
    clipid, stime, send : string;
    dtnext, dtend, dtnow : tdatetime;
    nowfrm, strfrm, endfrm : longint;
begin
  if GridPlayer=grDefault then begin
    //MyTextMessage('���������','�� ������ �������� ������.' + #13#10
    //              + '����� ����� ���������� �� ������ ������.' ,1);
    GridPlayer:=grPlaylist;
    //appllc
  end;
  if vlcmode=play then exit;
  dtnow := now;
//  if lowercase(trim(Form1.lbActiveClipID.Caption))<>'' then begin
//    nowfrm := TimeToFrames(dtnow);
//    strfrm := StrTimeCodeToFrames(Form1.lbTypeTC.Caption);
//    endfrm := strfrm + TLParameters.Finish-TLParameters.Preroll;
//    if (nowfrm>=strfrm) and (nowfrm<=endfrm)
//      then TLParameters.Position:=TLParameters.Preroll + endfrm - nowfrm;
//    MediaPlay;
//  end;
  rw := FindNextClipTime(Grid, dtnow);
  if rw=-1 then exit;
  clipid:=(Grid.Objects[0,rw] as tgridrows).MyCells[3].ReadPhrase('ClipID');

  if lowercase(trim(clipid))<>lowercase(trim(Form1.lbActiveClipID.Caption)) then begin
    if Form1.MySynhro.Checked then begin
      GridPlayerRow:=rw;
      GridPlayer:=grPlaylist;
      LoadClipsToPlayer;
    end;
  end;

  //=======================
  stime:=(Grid.Objects[0,rw] as TGridRows).MyCells[3].ReadPhrase('StartTime');
  send:=(Grid.Objects[0,rw] as TGridRows).MyCells[3].ReadPhrase('Duration');
  if trim(send)='' then dtend:=0 else dtend:=FramesToTime(StrTimeCodeToFrames(send));
  dtnext:=trunc(dtnow) + FramesToTime(StrTimeCodeToFrames(stime)) + dtend;
  //=========================

  rw := FindNextClipTime1(Grid, dtnext);
  form1.lbusesclpidlst.Caption := sourceclipsstr;
  if rw=-1 then exit
  else begin
    form1.lbusesclpidlst.Caption := form1.lbusesclpidlst.Caption + ' ('
         + trim((Grid.Objects[0,rw] as TGridRows).MyCells[3].ReadPhrase('Clip')) + ')';
  end;
end;

Function GetHotKeysCommand(Key: Word; Shift: TShiftState) : word;
var s, serr1, serr2 : string;
    res : word;
    key1 : byte;
begin
//if not (frHotKeys.ActiveControl=stringgrid1) then begin
  result:=$FFFF;
  res:=0;
  if ssCtrl in Shift then res:=res or $0100;
  if ssShift in Shift then res:=res or $0200;
  if ssAlt in Shift then res:=res or $0400;
  key1:=Key;
  if not ((key1=16) or (key1=17) or (key1=18)) then result:=res + key1;
end;

procedure Delay(const AMilliseconds: Cardinal);
var
  SaveTickCount: Cardinal;
begin
  SaveTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
  until GetTickCount - SaveTickCount > AMilliseconds;
end;

procedure updateImageTemplateGrids;
var i : integer;
begin
  with Form1,FGRTemplate do begin
    GridClear(GridGRTemplate, RowGridListGR);
    GridGRTemplate.RowCount:=0;
    for i:=0 to GridImgTemplate.RowCount-1 do begin
      GridAddRow(GridGRTemplate, RowGridListGR);
     (GridGRTemplate.Objects[0,GridGRTemplate.RowCount-1]
        as TGridRows).Assign((GridImgTemplate.Objects[0,i] as TGridRows));
    end;
  end;
end;

procedure SaveClipFromPanelPrepare;
var i, oldcount : integer;
    clpid : string;
begin
  with Form1 do begin
    if trim(lbActiveClipID.Caption)<>'' then SaveClipEditingToFile(trim(lbActiveClipID.Caption))
    else begin
      if PanelPrepare.Visible then begin
        for i:=0 to TLZone.Count-1 do begin
          if TLZone.Timelines[i].Count > 0 then begin
            if MyTextMessage('������','��������� ������������� ������ � ������ ������?',2) then begin
              FImportFiles.edTotalDur.Text:=trim(FramesToStr(DefaultClipDuration));
              FImportFiles.edNTK.Text:=trim(FramesToStr(TLParameters.Start-TLParameters.Preroll));
              FImportFiles.EdDur.Text:=trim(FramesToStr(TLParameters.Finish-TLParameters.Start));
              FImportFiles.ExternalValue := true;
              oldcount := Form1.GridClips.RowCount;
              EditClip(-100);
              if oldcount<Form1.GridClips.RowCount then begin
                clpid := (form1.GridClips.Objects[0,Form1.GridClips.RowCount-1] as TGridRows).MyCells[3].ReadPhrase('ClipID');
                lbActiveClipID.Caption:=clpid;
                SaveClipEditingToFile(trim(clpid));
              end;
            end;
            break;
          end;
        end;
      end;
    end;
  end;
end;

procedure EnableProgram;
begin
  Form1.sbMainMenu.Enabled:=true;
  Form1.sbProject.Enabled:=true;
  Form1.sbClips.Enabled:=true;
  Form1.sbPlayList.Enabled:=true;
  Form1.sbPredClip.Enabled:=true;
  Form1.sbNextClip.Enabled:=true;
  Form1.Label2.Enabled:=true;
  Form1.lbMode.Enabled:=true;
  Form1.GridLists.Enabled:=true;
  Form1.GridTimeLines.Enabled:=true;
  form1.imgButtonsProject.Enabled:=true;
  form1.imgButtonsControlProj.Enabled:=true;
  form1.imgBlockProjects.Enabled:=true;
  form1.ImgButtonsPL.Enabled:=true;
end;

procedure ReadEditedProjects;
var fl : string;
    i : integer;
begin
  fl:=AppPath + 'EditedProjects.eprj';
  if fileexists(fl) then begin
    ListEditedProjects.Clear;
    ListEditedProjects.LoadFromFile(fl);
    for i:=ListEditedProjects.Count-1 downto 0
      do if not FileExists(ListEditedProjects.Strings[i]) then ListEditedProjects.Delete(i);
    if MenuListFiles=nil then MenuListFiles:=TMyMenu.create else MenuListFiles.Clear;
    for i:=0 to ListEditedProjects.Count-1
      do MenuListFiles.Add(extractfilename(ListEditedProjects.Strings[i]),i);
    //Form1.ListBox2.ItemIndex:=-1;
    MenuListFiles.offset := 0;
    MenuListFiles.rowheight := 20;
    Form1.ImgListFiles.Height:=MenuListFiles.count*MenuListFiles.rowheight;
    Form1.ImgListFiles.Width:=265;
    Form1.ImgListFiles.Picture.Bitmap.Height:=Form1.ImgListFiles.Height;
    Form1.ImgListFiles.Picture.Bitmap.Width:=Form1.ImgListFiles.Width;
    Form1.ImgListFiles.Repaint;
    MenuListFiles.Draw(Form1.ImgListFiles.Canvas);
  end;
end;


procedure WriteEditedProjects(CProj : string);
var fl, renm : string;
    i : integer;
begin
  fl:=AppPath + 'EditedProjects.eprj';
  for i:= ListEditedProjects.Count-1 downto 0
    do if lowercase(trim(ListEditedProjects.Strings[i]))=lowercase(trim(CProj))
         then ListEditedProjects.Delete(i);
  ListEditedProjects.Insert(0,CProj);
  if ListEditedProjects.Count>10
    then for i:=ListEditedProjects.Count-1 downto 10
           do ListEditedProjects.Delete(i);
  if FileExists(fl) then begin
    renm := AppPath + '\Temp.eprj';
    RenameFile(fl,renm);
    DeleteFile(renm);
  end;
  ListEditedProjects.SaveToFile(fl);
end;

procedure LoadImage(FileName:string; Image : TImage);
var
  ext: string;
  Tmp, Tmp1: TFastDIB;
  tfClr : TFColor;
  Clr : longint;
begin
  Tmp:=TFastDIB.Create;
  if FileExists(FileName)then
  begin
    ext:=LowerCase(ExtractFileExt(FileName));
    if ext='.bmp' then Tmp.LoadFromFile(FileName) else
    if (ext='.jpg') or (ext='.jpeg') then LoadJPGFile(Tmp,FileName,True);
  end else
  begin
    Tmp.SetSize(Image.Width,Image.Height,32);
    Clr:=ColorToRGB(SmoothColor(ProgrammColor,24));
    //r := Color; g := Color shr 8; b := Color shr 16
    tfClr.r:=Clr;
    tfClr.g:=Clr shr 8;
    tfClr.b:=Clr shr 16;
    Tmp.Clear(tfClr);
    Tmp.SetFont('Tahoma',50);
  end;

  Tmp1:=TFastDIB.Create;
  Tmp1.SetSize(Image.Width,Image.Height,Tmp.Bpp);
  if Tmp1.Bpp=8 then
  begin
    Tmp1.Colors^:=Tmp.Colors^;
    Tmp1.UpdateColors;
  end;

  Bilinear(Tmp,Tmp1);
  Tmp1.FreeHandle:=False;
  Image.Picture.Bitmap.Handle:=Tmp1.Handle;
  Tmp1.Free;

  Tmp.Free;
end;

procedure LoadBitmap(FileName:string; bmp : TBitmap; Width, Height : integer; ClearColor : tcolor);
var
  ext: string;
  Tmp, Tmp1: TFastDIB;
  tfClr : TFColor;
  Clr : longint;
begin
  Tmp:=TFastDIB.Create;
  if FileExists(FileName)then
  begin
    ext:=LowerCase(ExtractFileExt(FileName));
    if ext='.bmp' then Tmp.LoadFromFile(FileName) else
    if (ext='.jpg') or (ext='.jpeg') then LoadJPGFile(Tmp,FileName,True);
  end else
  begin
    Tmp.SetSize(Width,Height,32);
    Clr:=ColorToRGB(ClearColor);
    //r := Color; g := Color shr 8; b := Color shr 16
    tfClr.r:=Clr;
    tfClr.g:=Clr shr 8;
    tfClr.b:=Clr shr 16;
    Tmp.Clear(tfClr);
    //Tmp.SetFont('Tahoma',50);
  end;

  Tmp1:=TFastDIB.Create;
  Tmp1.SetSize(Width,Height,Tmp.Bpp);
  if Tmp1.Bpp=8 then
  begin
    Tmp1.Colors^:=Tmp.Colors^;
    Tmp1.UpdateColors;
  end;

  Bilinear(Tmp,Tmp1);
  Tmp1.FreeHandle:=False;
  bmp.Handle:=Tmp1.Handle;
  Tmp1.Free;

  Tmp.Free;
end;


procedure SetTypeTimeCode;
var txt : string;
begin
  txt := '';
  if (MyStartPlay<>-1) then txt:='����� � (' + trim(FramesToStr(MyStartPlay)) + ')';
  if (MyRemainTime <> -1) and Form1.MySynhro.Checked {MyStartReady} then txt:='�� ������ (' + trim(FramesToShortStr(MyRemainTime)) + ')';

  Form1.lbTypeTC.Caption := txt;
//  if txt<>'' then begin
//    Form1.lbTypeTC.Caption := txt;
//  end else begin
//    Form1.lbTypeTC.Caption := '';
//  end;

//  MyShift      : double = 0; //�������� LTC ������������ ���������� �������
//  MyShiftOld   : double = 0; //������ �������� LTC ������������ ���������� �������
//  MyShiftDelta : double = 0;
//  MySinhro     : TSinchronization = chnone; //��� �������������
//  MyStartPlay  : longint = -1;    // ����� ������ �����, ��� chnone �� ������������, -1 ����� �� �����������.
//  MyStartReady : boolean = false; // True - ���������� � ������, false - ����� �����������.
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

//procedure SetStatusClipInPlayer(ClipID : string);
//var i, ps : integer;
//    clpid, txt : string;
//    clr : tcolor;
//begin
//  try
//  WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID);
//  ps := Uplaylists.findclipposition(Form1.GridClips, ClipID);
//  clr := (Form1.GridClips.Objects[0,ps] as TGridRows).MyCells[3].ReadPhraseColor('Clip');
//  if clr <> PhraseErrorColor then begin
//    clpid := trim((Form1.GridClips.Objects[0,ps] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
//    if clpid=trim(ClipID)
//      then (Form1.GridClips.Objects[0,ps] as TGridRows).MyCells[3].SetPhraseColor('Clip', PhrasePlayColor)
//      else (Form1.GridClips.Objects[0,ps] as TGridRows).MyCells[3].SetPhraseColor('Clip', GridFontColor);
//  end;
//  CheckedActivePlayList;
//  except
//    on E: Exception do WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID + ' | ' + E.Message);
//  end;
//end;

procedure ClearClipsStatusPlay;
var i : integer;
    clpid, txt : string;
    clr : tcolor;
begin
  try
  WriteLog('MAIN', 'UCommon.ClearClipsStatusPlay');
  for i := 1 to Form1.GridClips.RowCount-1
    do if Form1.GridClips.Objects[0,i] is TGridRows
         then (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[2].Mark:=true;
  CheckedActivePlayList;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.ClearClipsStatusPlay | ' + E.Message);
  end;
end;

procedure SetStatusClipInPlayer(ClipID : string);
var i : integer;
    clpid, txt : string;
    clr : tcolor;
    frerr : boolean;
begin
  try
  WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID);
  for i := 1 to Form1.GridClips.RowCount-1 do begin
    if Form1.GridClips.Objects[0,i] is TGridRows then begin
       clr := (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhraseColor('Clip');
       frerr:=false;
       if clr = PhraseErrorColor then frerr := true;
       clpid := trim((Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
       if clpid=trim(ClipID) then begin
         if not frerr then (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].SetPhraseColor('Clip', PhrasePlayColor);
         (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[2].Mark:=false;
       end else begin
         if not frerr then (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[3].SetPhraseColor('Clip', GridFontColor);
         (Form1.GridClips.Objects[0,i] as TGridRows).MyCells[2].Mark:=true;
       end;
    end;
  end;
  CheckedActivePlayList;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.SetStatusClipInPlayer ClipID=' + ClipID + ' | ' + E.Message);
  end;
end;

Procedure CheckedClipsInList;
var i : integer;
    pth, txt : string;
begin
  try
    with Form1 do begin
      WriteLog('MAIN', 'UCommon.CheckedClipsInList Start GridClips');
      for i := 1 to GridClips.RowCount-1 do begin
        if GridClips.Objects[0,i] is TGridRows then begin
         txt := (GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('File');

           if Trim(txt)<>'' then begin
             if not FileExists(txt) then begin
               (GridClips.Objects[0,i] as TGridRows).MyCells[3].SetPhraseColor('Clip', PhraseErrorColor);
               WriteLog('MAIN', 'UCommon.CheckedClipsInList-1 GridClips File=' + txt + '�� ����������');
             end else WriteLog('MAIN', 'UCommon.CheckedClipsInList GridClips File=' + txt + '������');
           end else begin
             (GridClips.Objects[0,i] as TGridRows).MyCells[3].SetPhraseColor('Clip', PhraseErrorColor);
             WriteLog('MAIN', 'UCommon.CheckedClipsInList-2 GridClips File=' + txt + '�� ����������');
           end;
        end;
      end;
      WriteLog('MAIN', 'UCommon.CheckedClipsInList Finish GridClips');
    end;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.CheckedClipsInList GridLists  | ' + E.Message);
  end;
end;

Procedure ReloadClipInList(Grid : tstringgrid; ARow : integer);
var txt : string;
    err : integer;
    dur : int64;
    mediadata : string;
begin
  try
  WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.Name + ' ARow' + inttostr(ARow));
  if Grid.Objects[0,ARow] is TGridRows then begin
    //txt := (Grid.Objects[0,ARow] as TGridRows).MyCells[3].ReadPhrase('File');
    //Form1.opendialog1.FileName:=txt;
    if Form1.OpenDialog1.Execute then begin
      if trim(Form1.opendialog1.FileName)<>'' then begin
        err := LoadVLCPlayer(Form1.OpenDialog1.FileName, mediadata);
        if Err<>0 then begin
          ShowMessage('���������� ��������� ��������� ���������� ����������.');
          (Grid.Objects[0,ARow] as TGridRows).MyCells[3].SetPhraseColor('Clip', clRed);
          (Grid.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('File', '�����-������ �����������');
          WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.Name + ' ARow' + inttostr(ARow) + ' File=' + trim(Form1.opendialog1.FileName) + ' �����-������ �����������');
          exit;
        end;
        (Grid.Objects[0,ARow] as TGridRows).MyCells[3].SetPhraseColor('Clip', GridFontColor);
        txt := CopyMediaFile(Form1.Opendialog1.FileName, PathFiles);
        (Grid.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('File', trim(txt));
         //pMediaPosition.get_Duration(dur);
         dur:=vlcplayer.Duration div 40;
        (Grid.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('Duration',FramesToStr(Dur));
        (Grid.Objects[0,ARow] as TGridRows).MyCells[3].UpdatePhrase('MediaType',mediadata);
        WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.Name + ' ARow' + inttostr(ARow) + ' File=' + trim(Form1.opendialog1.FileName) + ' ��������');
      end;
    end;
  end;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.ReloadClipInList Grid=' + Grid.Name + ' ARow' + inttostr(ARow) + ' | ' + E.Message);
  end;
end;

procedure SetClipTimeParameters;
begin
  try
  Form1.lbMediaKTK.Caption:=framestostr(TLParameters.Finish - TLParameters.ZeroPoint);
  Form1.lbMediaNTK.Caption:=framestostr(TLParameters.Start - TLParameters.ZeroPoint);
  Form1.lbMediaDuration.Caption:=framestostr(TLParameters.Duration);
  Form1.lbMediaCurTK.Caption:=framestostr(TLParameters.Position - TLParameters.ZeroPoint);
  Form1.lbMediaTotalDur.Caption:=framestostr(TLParameters.Finish-TLParameters.Start);
  Form1.lbMediaKTK.Repaint;
  Form1.lbMediaNTK.Repaint;
  Form1.lbMediaDuration.Repaint;
  Form1.lbMediaCurTK.Repaint;
  Form1.lbMediaTotalDur.Repaint;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.ReloadClipInList SetClipTimeParameters | ' + E.Message);
  end;
end;

Procedure SetPanelTypeTL(TypeTL : TTypeTimeline; APos : integer);
begin
  try
         case TypeTL of
  tldevice : begin
               Form1.pnDevTL.Visible:=true;
               Form1.PnTextTL.Visible:=false;
               Form1.pnMediaTL.Visible:=false;
               btnspanel1.Rows[0].Btns[3].Visible:=true;
               btnspanel1.Rows[0].Btns[4].Visible:=true;
               btnsdevicepr.BackGround:=ProgrammColor;
               InitBTNSDEVICE(Form1.imgDeviceTL.Canvas, (Form1.GridTimeLines.Objects[0,APos] as TTimelineOptions), btnsdevicepr);
               WriteLog('MAIN', 'UCommon.SetPanelTypeTL TypeTL=tldevice Apos=' + inttostr(APos));
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
               WriteLog('MAIN', 'UCommon.SetPanelTypeTL TypeTL=tltext Apos=' + inttostr(APos));
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
               WriteLog('MAIN', 'UCommon.SetPanelTypeTL TypeTL=tlmedia Apos=' + inttostr(APos));
             end;
        end; //case
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.SetPanelTypeTL Apos=' + inttostr(APos) + ' | ' + E.Message);
  end;
end;


function SetInGridClipPosition(Grid : tstringgrid; ClipID : string) : integer;
begin
  try
  WriteLog('MAIN', 'UCommon.SetInGridClipPosition Start Grid=' + Grid.Name + ' ClipID=' + ClipID);
  result := FindClipInGrid(Grid,ClipID);
//  if result = -1 then EraseClipInWinPrepare('')
//  else begin
    if result>=0 then begin
      GridPlayerRow:=Result;
      Grid.Row:=result;
      UpdateClipDataInWinPrepare(Grid, result, ClipID);
    end;
//  end;
  WriteLog('MAIN', 'UCommon.SetInGridClipPosition Finish Grid=' + Grid.Name + ' ClipID=' + ClipID);
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.SetInGridClipPosition Grid=' + Grid.Name + ' ClipID=' + ClipID + ' | ' + E.Message);
  end;
end;

procedure UpdateClipDataInWinPrepare(Grid : tstringgrid; Posi : integer; ClipID : string);
begin
  try
  WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Start Grid=' + Grid.Name + ' ClipID=' + ClipID + ' Position=' + inttostr(posi));
  if (trim(ClipID)=Trim(Form1.lbActiveClipID.Caption)) then begin
    GridPlayerRow:=Posi;
    WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Grid=' + Grid.Name + ' ClipID=' + ClipID + ' GridPlayerRow=' + inttostr(posi));
    //Form1.lbNomClips.Caption:=inttostr(GridPlayerRow);
    pntlprep.SetText('Nom',inttostr(GridPlayerRow));
    Form1.lbActiveClipID.Caption := (Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    Form1.Label2.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    //Form1.lbClipName.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    pntlprep.SetText('ClipName',(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip'));
    //Form1.lbSongName.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
    pntlprep.SetText('SongName',(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song'));
    //Form1.lbSongSinger.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
    pntlprep.SetText('SingerName',(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer'));
    Form1.lbPlayerFile.Caption:=(Grid.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
    pntlprep.Draw(form1.imgdataprep.Canvas);
    form1.imgdataprep.Repaint;
    SetButtonsPredNext;
  end;
  WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Finish Grid=' + Grid.Name + ' ClipID=' + ClipID + ' Position=' + inttostr(posi));
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.UpdateClipDataInWinPrepare Finish Grid=' + Grid.Name + ' ClipID=' + ClipID + ' Position=' + inttostr(posi) + ' | ' + E.Message);
  end;
end;

function EraseClipInWinPrepare(ClipID : string) : boolean;
var i, j : integer;
begin
  try
  WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare Start ClipID=' + ClipID);
  result := false;
  if (trim(ClipID)=Trim(Form1.lbActiveClipID.Caption)) or (trim(ClipID)='') then begin
     WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare Erase ClipID=' + ClipID);
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
     pntlprep.SetText('Nom','');
     pntlprep.SetText('ClipName','');
     pntlprep.SetText('SongName','');
     pntlprep.SetText('SingerName','');

     //Form1.lbNomClips.Caption:='';
     //Form1.lbClipName.Caption:='';
     //Form1.lbSongName.Caption:='';
     //Form1.lbSongSinger.Caption:='';
     Form1.lbPlayerFile.Caption:='';
     MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '', 'EraseClipInWinPrepare');
     Form1.Image3.Picture.Bitmap:=nil;
     Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
     Form1.imgtimelines.Canvas.FillRect(Form1.imgtimelines.Canvas.ClipRect);
     bmptimeline.Canvas.FillRect(bmptimeline.Canvas.ClipRect);
     ClearVLCPlayer;
     TLZone.ClearZone;
     TLZone.DrawBitmap(bmptimeline);
     TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
     Form1.imgtimelines.Repaint;
     if Form1.Image3.Visible then Form1.Image3.Repaint;
     ClearUNDO;
     SetStatusClipInPlayer('!!@@##$$%%^^&&**');
     pntlprep.Draw(form1.imgdataprep.Canvas);
     form1.imgdataprep.Repaint;
  end;
  WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare Finish ClipID=' + ClipID);
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.EraseClipInWinPrepare ClipID=' + ClipID + ' | ' + E.Message);
  end;
end;

Procedure SetPathProject(IDProject : string);
begin
  PathProject:=AppPath + DirProjects + '\' + IDProject;
  //PathEvents:=PathProject + '\' + DirEvents;
  PathTemp:=PathProject + '\' + DirTemp;
  PathTemplates:=PathProject + '\' + DirTemplates;
  WriteLog('MAIN', 'UCommon.SetPathProject IDProject=' + IDProject);
end;

function CalcTextExtent(DCHandle:integer;Text:string):TSize;
var
 CharFSize:TABCFloat;
begin
 try
 Result.cx:=0;
 Result.cy:=0;
 if Text='' then
   exit;
 GetTextExtentPoint32(DCHandle,PChar(Text),Length(Text),Result);
 GetCharABCWidthsFloat(DCHandle,Ord(Text[Length(Text)]),Ord(Text[Length(Text)]),CharFSize);
 if CharFSize.abcfC<0 then
   Result.cx:=Result.cx+Trunc(Abs(CharFSize.abcfC));
 except
   on E: Exception do WriteLog('MAIN', 'UCommon.CalcTextExtent Text=' + Text + ' | ' + E.Message);
 end;
end;

function CalcTextWidth(DCHandle:integer;Text:string):integer;
begin
 try
 Result:= CalcTextExtent(DCHandle,Text).cx;
 except
   on E: Exception do WriteLog('MAIN', 'UCommon.CalcTextWidth Text=' + Text + ' | ' + E.Message);
 end;
end;

procedure TemplateToScreen(crpos : TEventReplay);
begin
  try
  //WriteLog('MAIN', 'UCommon.TemplateToScreen CurrentEvents : Number=' + inttostr(crpos.Number) + ' Image=' +crpos.Image);
  if crpos.Number <> -1 then begin
    //MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'TemplateToScreen');
    if Form1.pnImageScreen.Visible then begin
      if Trim(CurrentImageTemplate)<>trim(crpos.Image) then begin
        if trim(crpos.Image)='' then begin
          //Form1.Image3.Picture.Bitmap.FreeImage;
          //Form1.Image3.Canvas.Brush.Color := SmoothColor(ProgrammColor,24);
          //Form1.Image3.Canvas.Brush.Style := bsSolid;
          //Form1.Image3.Width:=Form1.pnImageScreen.Width;
          //Form1.Image3.Height:=Form1.pnImageScreen.Height;
          //Form1.Image3.Picture.Bitmap.Width:=Form1.pnImageScreen.Width;
          //Form1.Image3.Picture.Bitmap.Height:=Form1.pnImageScreen.Height;
          //Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
          //Form1.Image3.repaint;
          LoadImage(PathTemplates + '\',Form1.Image3);
          WriteLog('MAIN', 'UCommon.TemplateToScreen-1 Clear');
          //application.ProcessMessages;
        end else begin
          if FileExists(PathTemplates + '\' + trim(crpos.Image)) then begin
            //if Form1.Image3.Picture.Graphic is TJPEGImage then begin
            //  TJPEGImage(Form1.Image3.Picture.Graphic).DIBNeeded;
            //end;
            if LoadImageInProgress then exit;
            try
              LoadImageInProgress:= true;
              LoadImage(PathTemplates + '\' + trim(crpos.Image),Form1.Image3);
              //Form1.Image3.Picture.LoadFromFile(PathTemplates + '\' + trim(crpos.Image));
              CurrentImageTemplate:=crpos.Image;
            finally
            end;
            LoadImageInProgress:=false;
            WriteLog('MAIN', 'UCommon.TemplateToScreen-3 : Number=' + inttostr(crpos.Number) + ' Image=' +crpos.Image);
            exit;
          end;
        end;
        CurrentImageTemplate:=crpos.Image;
      end;
    end;
  end else begin
    if Form1.pnImageScreen.Visible then begin
      //Form1.Image3.Picture.Bitmap.FreeImage;
      //Form1.Image3.Canvas.Brush.Color := SmoothColor(ProgrammColor,24);
      //Form1.Image3.Canvas.Brush.Style := bsSolid;
      //Form1.Image3.Width:=Form1.pnImageScreen.Width;
      //Form1.Image3.Height:=Form1.pnImageScreen.Height;
      //Form1.Image3.Picture.Bitmap.Width:=Form1.pnImageScreen.Width;
      //Form1.Image3.Picture.Bitmap.Height:=Form1.pnImageScreen.Height;
      //Form1.Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
     // Form1.Image3.repaint;
      WriteLog('MAIN', 'UCommon.TemplateToScreen-2 Clear');
      CurrentImageTemplate := '#@@#';
      //application.ProcessMessages;
    end;
  end;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.TemplateToScreen CurrentEvents : Number=' + inttostr(crpos.Number) + ' Image=' +crpos.Image + ' | ' + E.Message);
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
    on E: Exception do begin
      WriteLog('MAIN', 'UCommon.MyTextRect : Text=' + Text + ' | ' + E.Message);
      FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
      DeleteObject(FHNew);
      bmp.Free;
      bmp:=nil;
    end else begin
      FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
      DeleteObject(FHNew);
      bmp.Free;
      bmp:=nil;
    end;
  end;
end;

procedure InsertEventToEditTimeline(nom : integer);
var ps : integer;
begin
  try
  WriteLog('MAIN', 'UCommon.InsertEventToEditTimeline Number=' + inttostr(nom));
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
                 WriteLog('MAIN', 'UCommon.InsertEventToEditTimeline TypeTL=tlDevice Number=' + inttostr(nom));
                 if vlcmode=play then exit;
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
                 WriteLog('MAIN', 'UCommon.InsertEventToEditTimeline TypeTL=tlText Number=' + inttostr(nom));
                 if vlcmode=play then exit;
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
                 WriteLog('MAIN', 'UCommon.InsertEventToEditTimeline TypeTL=tlMedia Number=' + inttostr(nom));
                 if vlcmode=play then exit;
               end;
             end;
      end;
  TLZone.DrawTimelines(Form1.imgtimelines.Canvas,bmptimeline);
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.InsertEventToEditTimeline Number=' + inttostr(nom) + ' | ' + E.Message);
  end;
end;

Procedure PlayClipFromActPlaylist;
begin
  try
  Form1.sbPlayList.Font.Style:=Form1.sbPlayList.Font.Style + [fsUnderline];
  //MyTimer.Waiting:=true;
  GridPlayer:=grPlayList;
  GridPlayerRow:=Form1.GridActPlayList.Row;
  PredClipID := (Form1.GridActPlayList.Objects[0,Form1.GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID');
  //form1.lbActiveClipID.Caption := (Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('ClipID');
  WriteLog('MAIN', 'UCommon.PlayClipFromActPlaylist ClipID=' + form1.lbActiveClipID.Caption);
  LoadClipsToPlayer;
  //MyTimer.Waiting:=false;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.PlayClipFromActPlaylist | ' + E.Message);
  end;
end;

Procedure PlayClipFromClipsList;
begin
  try
  Form1.sbClips.Font.Style:=Form1.sbClips.Font.Style + [fsUnderline];
  //MyTimer.Waiting:=true;
  GridPlayer:=grClips;
  GridPlayerRow:=Form1.GridClips.Row;
  PredClipID := (Form1.GridClips.Objects[0,Form1.GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID');
  WriteLog('MAIN', 'UCommon.PlayClipFromClipsList PredClipID=' + PredClipID);
  LoadClipsToPlayer;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.PlayClipFromClipsList | ' + E.Message);
  end;
  //MyTimer.Waiting:=false;
end;

procedure ControlPlayer;
begin
  //pMediaPosition.get_Rate(Rate);
    //mode := play;
    //StartMyTimer;
  try
  WriteLog('MAIN', 'UCommon.ControlPlayer Start');
  if vlcmode=paused then begin
    Rate:=1;
    WriteLog('MAIN', 'UCommon.ControlPlayer mode=paused');
    if fileexists(Form1.lbPlayerFile.Caption) then Rate:=1;//pMediaPosition.put_Rate(Rate);
     pStart :=  FramesToDouble(TLParameters.Position);
     MediaPlay;
  end else begin
    WriteLog('MAIN', 'UCommon.ControlPlayer mode<>paused');
    Form1.MySynhro.Checked := false;
     if fileexists(Form1.lbPlayerFile.Caption) then Rate:=1;//pMediaPosition.get_Rate(Rate);
    if Rate<>1 then begin
      Rate:=1;
      if not fileexists(Form1.lbPlayerFile.Caption) then begin
        pStart := FramesToDouble(TLParameters.Position);
        application.ProcessMessages;
      end;
      if fileexists(Form1.lbPlayerFile.Caption) then Rate:=1;//pMediaPosition.put_Rate(Rate);
    end else begin
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
    on E: Exception do WriteLog('MAIN', 'UCommon.ControlPlayer | ' + E.Message);
  end;
end;

procedure LoadJpegFile(bmp : tbitmap; FileName : string);
var
  JpegIm: TJpegImage;
  wdth,hght,bwdth,bhght : integer;
  dlt : real;
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
    on E: Exception do WriteLog('MAIN', 'UCommon.LoadJpegFile FileName=' + FileName + ' | ' + E.Message);
  end;
end;

procedure loadoldproject;
var ps, pp : integer;
    nm : string;
begin
  try
  WriteLog('MAIN', 'UCommon.loadoldproject Start');
  initnewproject;
  SecondaryGrid:=playlists;
  SecondaryGrid:=playlists;
 //   LoadGridFromFile(PathTemp + '\ImageTemplates.lst', form1.GridGRTemplate);

  application.ProcessMessages;
  GridImageReload(form1.GridGRTemplate);
  UpdateGridTemplate:=true;
 //   LoadGridFromFile(PathTemp + '\Clips.lst', form1.GridClips);
  CheckedClipsInList;
 //   pp := findgridselection(form1.gridlists, 2);
 //   if pp > 0 then begin
 //     nm := (form1.gridlists.Objects[0,pp] as tgridrows).MyCells[3].ReadPhrase('Note');
 //     PlaylistToPanel(pp);
 //     LoadGridFromFile(PathPlayLists+ '\' + nm, form1.GridActPlayList);
 //     CheckedClipsInList(form1.GridActPlayList);
 //     Form1.lbClipActPL.Caption := (form1.gridlists.Objects[0,pp] as tgridrows).MyCells[3].ReadPhrase('Name');
 //   end;
 // end;
  form1.GridLists.Repaint;
  Form1.GridTimeLines.Repaint;
  Form1.GridClips.Repaint;
  Form1.GridActPlayList.Repaint;
  WriteLog('MAIN', 'UCommon.loadoldproject Finish');
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.loadoldproject | ' + E.Message);
  end;
end;

procedure initnewproject;
var i : integer;
begin
  try
  WriteLog('MAIN', 'UCommon.initnewproject Start');
  with Form1 do begin
    if trim(Label2.Caption)<>'' then begin
      SaveClipEditingToFile(trim(Label2.Caption));
      Label2.Caption:='';
      TLZone.TLEditor.Clear;
      for i := 0 to TLZone.Count - 1 do TLZone.Timelines[i].Clear;
      ClearVLCPlayer;
    end;
    pntlproj.SetText('ProjectName','');
    ProjectNumber := '';
    pntlproj.SetText('CommentText','');
    pntlproj.SetText('FileName','');
    pntlproj.SetText('DateStart','');
    pntlproj.SetText('DateEnd','');
    //if FileExists(pathlists + '\Timelines.lst')
    //  then LoadGridTimelinesFromFile(pathlists + '\Timelines.lst', Form1.GridTimeLines)
    //  else
    InitGridTimelines;
    //ZoneNames.Update;
    InitPanelPrepare(true);
    GridClear(GridClips,RowGridClips);
    GridClear(GridActPlayList,RowGridClips);
    //ClearPanelActPlayList;
    ClearClipsPanel;
    GridClear(GridLists, RowGridListPL);

    GridLists.Repaint;
    GridClips.Repaint;
    GridActPlayList.Repaint;
    GridTimeLines.Repaint;
    WriteLog('MAIN', 'UCommon.initnewproject Finish');
  end;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.initnewproject | ' + E.Message);
  end;
end;

procedure UpdateProjectPathes(NewProject : string);
begin
  try
  WriteLog('MAIN', 'UCommon.UpdateProjectPathes NewProject=' + NewProject);
  PathProject:=AppPath + DirProjects;
  //PathLists := PathProject + DirLists;
  PathClips := PathProject + DirClips;
  PathTemplates := PathProject + DirTemplates;
  PathPlayLists := PathProject + DirPlayLists;
  PathTemp := PathProject + DirTemp;
  PathLog := PathProject + DirLog;
  PathKeylayouts := PathProject + DirKeylayouts;
  except
    on E: Exception do WriteLog('MAIN', 'UCommon.UpdateProjectPathes NewProject=' + NewProject + ' | ' + E.Message);
  end;
end;

procedure CreateDirectories1;
var i : integer;
    ext : string;
begin
  try
  WriteLog('MAIN', 'UCommon.CreateDirectories');
  AppPath := extractfilepath(Application.ExeName);
  AppName := extractfilename(Application.ExeName);
  ext := extractfileext(Application.ExeName);
  AppName := copy(AppName,1,length(AppName)-length(ext));

  PathFiles:=AppPath+DirFiles;
  if not DirectoryExists(PathFiles) then ForceDirectories(PathFiles);
  WriteLog('MAIN', 'UCommon.CreateDirectories PathFiles=' + PathFiles);
  PathProject:=AppPath+DirProjects;
  if not DirectoryExists(PathProject) then ForceDirectories(PathProject);
  WriteLog('MAIN', 'UCommon.CreateDirectories DirProject=' + PathProject);
  //PathLists := PathProject + DirLists;
  //if not DirectoryExists(PathLists) then ForceDirectories(PathLists);
  //WriteLog('MAIN', 'UCommon.CreateDirectories PathLists=' + PathLists);
  PathClips := PathProject + DirClips;
  if not DirectoryExists(PathClips) then ForceDirectories(PathClips);
  WriteLog('MAIN', 'UCommon.CreateDirectories PathClips=' + PathClips);
  PathTemplates := PathProject + DirTemplates;
  if not DirectoryExists(PathTemplates)  then ForceDirectories(PathTemplates);
  WriteLog('MAIN', 'UCommon.CreateDirectories PathTemplates=' + PathTemplates);
  PathPlayLists := PathProject + DirPlayLists;
  if not DirectoryExists(PathPlayLists)  then ForceDirectories(PathPlayLists);
  WriteLog('MAIN', 'UCommon.CreateDirectories PathPlayLists=' + PathPlayLists);
  PathTemp := PathProject + DirTemp;
  if not DirectoryExists(PathTemp) then ForceDirectories(PathTemp);
  WriteLog('MAIN', 'UCommon.CreateDirectories PathTemp=' + PathTemp);
  //'Keylayouts'
  PathKeylayouts := PathProject + DirKeylayouts;
  if not DirectoryExists(PathKeylayouts) then ForceDirectories(PathKeylayouts);
  WriteLog('MAIN', 'UCommon.CreateDirectories PathTemp=' + PathKeylayouts);

  if MakeLogging then begin
    PathLog := AppPath + DirLog;
    if not DirectoryExists(PathLog) then ForceDirectories(PathLog);
    WriteLog('MAIN', 'UCommon.CreateDirectories PathLog=' + PathLog);
  end;
  except
    On E : Exception do  WriteLog('MAIN', 'UCommon.CreateDirectories | ' + E.Message);
  end;
end;

function createunicumname : string;
var YY,MN,DD : Word;
    HH,MM,SS,MS : Word;
begin
  try
  DecodeDate(Now,YY,MN,dd);
  DecodeTime(Now,HH,MM,SS,MS);
  result := inttostr(YY) + inttostr(MN) + inttostr(DD) +
            inttostr(HH) + inttostr(MM) + inttostr(SS) + inttostr(MS);
  WriteLog('MAIN', 'UCommon.createunicumname Result=' + result);
  except
    On E : Exception do  WriteLog('MAIN', 'UCommon.createunicumname | ' + E.Message);
  end;
end;

procedure LoadBMPFromRes(cv : tcanvas; rect : trect; width, height : integer; name : string);
var bmp : tbitmap;
    wdth, hght, deltx, delty : integer;
    rt : trect;
begin
  try
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
  except
    On E : Exception do  WriteLog('MAIN', 'UCommon.LoadBMPFromRes Name=' + Name + ' | ' + E.Message);
  end;
end;

function TwoDigit(dig : integer) : string;
begin
  try
  if (dig>=0) and (dig<=9) then Result:='0'+IntToStr(dig)
  else Result:=IntToStr(dig);
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.TwoDigit | ' + E.Message);
       Result:='00';
    end else Result:='00';
  end;
end;

function FramesToDouble(frm : longint) : Double;
var HH,MM,SS,FF,DLT : longint;
begin
  try
  DLT:=frm div 25;
  FF:= frm mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := (HH*3600 + mm*60 + SS) + (FF*40/1000);
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.FramesToDouble | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function FramesToTime(frm : longint) : tdatetime;
var HH,MM,SS,FF,DLT : longint;
begin
  try
  DLT:=frm div 25;
  FF:= frm mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := encodetime(HH,mm,SS,FF*40);
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.FramesToTime | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function TimeToFrames(dt : tdatetime) : longint;
var HH,MM,SS,ms : word;
begin
  try
  DecodeTime(dt,hh,mm,ss,ms);
  result := (hh*3600 + mm*60 + ss) * 25 + trunc(ms / 40);
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.TimeToFrames | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function TimeToTimeCodeStr(dt : tdatetime) : string;
var HH,MM,SS,ms : word;
begin
  try
  DecodeTime(dt,hh,mm,ss,ms);
  result := TwoDigit(hh) + ':' + TwoDigit(mm) + ':' + TwoDigit(ss) + ':' + TwoDigit(trunc(ms / 40));
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.TimeToTimeCodeStr | ' + E.Message);
       Result:='00:00:00:00';
    end else Result:='00:00:00:00';
  end;
end;

function MyTimeToStr : string;
var HH,MM,SS,ms : word;
   dbl : double;
begin
  try
  //DecodeTime(dt,hh,mm,ss,ms);
  //dbl := RoundTo(dt * 1000,-3);
  dbld2 := MyTimer.ReadTimer;
  result := FloatToStr(RoundTo((dbld2 - dbld1) * 1000, -3)) + 'ms';
  //dbld1:=dbld2;
  //result := FloatToStr(dt);
  //TwoDigit(hh) + ':' + TwoDigit(mm) + ':' + TwoDigit(ss) + ':' + inttostr(ms);
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.MyTimeToStr | ' + E.Message);
       Result:='00:00:00:000';
    end else Result:='00:00:00:000';
  end;
end;

function StrTimeCodeToFrames(tc : string) : longint;
var HH,MM,SS,ms : word;
    s : string;
begin
  try
  s:=trim(tc);
  s:=StringReplace(s,'����� � (','',[rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,')','',[rfReplaceAll, rfIgnoreCase]);
  hh:=strtoint(s[1]+s[2]);
  mm:=strtoint(s[4]+s[5]);
  ss:=strtoint(s[7]+s[8]);
  ms:=strtoint(s[10]+s[11]);
  result := (hh*3600 + mm*60 + ss) * 25 + ms;
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.StrTimeCodeToFrames TC=' + tc + ' | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function FramesToStr(frm : longint) : string;
var ZN, HH,MM,SS,FF,DLT : longint;
    znak : char;
begin
  try
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
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.FramesToStr | ' + E.Message);
       Result:='00:00:00:00';
    end else Result:='00:00:00:00';
  end;
end;

function FramesToShortStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  try
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
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.FramesToShortStr | ' + E.Message);
       Result:='00:00';
    end else Result:='00:00';
  end;
end;

function SecondToStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  try
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
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.SecondToStr | ' + E.Message);
       Result:='00:00';
    end else Result:='00:00';
  end;
end;

function SecondToShortStr(frm : longint) : string;
var HH,MM,SS,FF,DLT, fr : longint;
    st : string;
begin
  try
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
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.SecondToShortStr | ' + E.Message);
       Result:='00:00';
    end else Result:='00:00';
  end;
end;

function MyDoubleToSTime(db : Double) : string;
var HH,MM,SS,FF,DLT : longint;
begin
  try
  DLT:=trunc(db);
  FF:=Trunc((db-DLT)*1000/40);
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := TwoDigit(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.MyDoubleToSTime | ' + E.Message);
       Result:='00:00:00:00';
    end else Result:='00:00:00:00';
  end;
end;

function MyDoubleToFrame(db : Double) : longint;
var HH,MM,SS,FF,DLT : longint;
begin
  try
  DLT:=trunc(db);
  FF:=trunc((db-DLT)*1000/40);
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := (HH*3600 + mm*60 + SS)*25 + FF;
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.MyDoubleToFrame | ' + E.Message);
       Result:=0;
    end else Result:=0;
  end;
end;

function MyDateTimeToStr(tm : tdatetime) : string;
var Hour, Min, Sec, MSec: Word;
begin
  try
  DecodeTime(tm, Hour, Min, Sec, MSec);
  Result := twodigit(Hour) + ':' + twodigit(Min) + ':' + twodigit(Sec) + ':' + twodigit(trunc(MSec/40));
  except
    On E : Exception do begin
       WriteLog('MAIN', 'UCommon.MyDateTimeToStr | ' + E.Message);
       Result:='00:00:00:00';
    end else Result:='00:00:00:00';
  end;
end;

Function DefineFontSizeW(cv : TCanvas; width : integer; txt : string): integer;
var fntsz, sz : integer;
    bmp : tbitmap;
begin
  try
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
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.DefineFontSizeW | ' + E.Message);
  end;
end;

Function DefineFontSizeH(cv : TCanvas; height : integer): integer;
var fntsz, sz : integer;
    bmp : tbitmap;
begin
  try
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
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.DefineFontSizeH | ' + E.Message);
  end;
end;

function SmoothColor(color : tcolor; step : integer) : tcolor;
var cColor: Longint;
    r, g, b: Byte;
    zn : integer;
    rm, gm, bm : Byte;
begin
  try
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
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.SmoothColor | ' + E.Message);
  end;
end;

function SetMainGridPanel(TypeGrid : TTypeGrid) : boolean;
var i, APos, oldcount : integer;
    clpid : string;
begin
  try
  WriteLog('MAIN', 'UCommon.SetMainGridPanel Start');
  result := true;
  //if (vlcmode=play) and (GridPlayer<>grPlayList) and (TypeGrid=actplaylist) then begin
  //  result:= false;
  //  exit;
  //end;
  if (trim(Form1.lbActiveClipID.Caption)='') and Form1.PanelPrepare.Visible then begin
    for i:=0 to TLZone.Count-1 do begin
      if TLZone.Timelines[i].Count > 0 then begin
        if MyTextMessage('������','��������� ������������� ������ � ������ ������?',2) then begin
          FImportFiles.edTotalDur.Text:=trim(FramesToStr(DefaultClipDuration));
          FImportFiles.edNTK.Text:=trim(FramesToStr(TLParameters.Start-TLParameters.Preroll));
          FImportFiles.EdDur.Text:=trim(FramesToStr(TLParameters.Finish-TLParameters.Start));
          FImportFiles.ExternalValue := true;
          oldcount := Form1.GridClips.RowCount;
          EditClip(-100);
          WriteLog('MAIN', 'UCommon.SetMainGridPanel - ���������� ������� �����');
          if (oldcount<Form1.GridClips.RowCount) or (Form1.GridClips.RowCount=2) then begin
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
//                  ActiveControl := GridProjects;
                  WriteLog('MAIN', 'UCommon.SetMainGridPanel MainGrid=projects');
                end;
  clips       : begin
                  if trim(ProjectNumber)='' then begin
                    MyTextMessage('��������������','��� ������ ������ ���������� �������/������� ������.',1);
                    exit;
                  end;
                  GridPlayer:=grClips;
                  PanelProject.Visible:=false;
                  PanelClips.Visible:=true;
                  PanelPlayList.Visible:=false;
                  lbusesclpidlst.Caption := '������ ������';
                  sbProject.Font.Style:=sbProject.Font.Style - [fsBold,fsUnderline];
                  sbClips.Font.Style:=sbClips.Font.Style + [fsBold,fsUnderline];
                  sbPlayList.Font.Style:=sbPlayList.Font.Style - [fsBold,fsUnderline];
                  ActiveControl := GridClips;
                  if trim(Form1.lbActiveClipID.Caption)<>''   then begin
                    GridPlayer:=grClips;
                    APos:=SetInGridClipPosition(GridClips, Form1.lbActiveClipID.Caption);
                    GridPlayerRow:=APos;
                    if APos <> -1 then GridClipsToPanel(GridClips.Row);
                  end else begin
                    GridPlayerRow:=-1;
                  //  if GridClips.Row > 0 then begin
                  //    if trim(PredClipID) <> '' then begin
                  //      GridPlayer:=grClips;
                  //      SetInGridClipPosition(GridClips, PredClipID);
                  //      if APos <> -1 then begin
                  //        GridClipsToPanel(GridClips.Row);
                  //        Form1.lbActiveClipID.Caption := PredClipID;
                  //        PlayClipFromClipsList;
                  //      end;
                  //    end;
                  //    if GridClips.Objects[0,GridClips.Row] is TGridRows then begin
                  //      GridClipsToPanel(GridClips.Row);
                  //    end;
                  //  end;
                  end;
                  CheckedClipsInList;
                  WriteLog('MAIN', 'UCommon.SetMainGridPanel MainGrid=clips');
                end;
  actplaylist : begin
                  if trim(ProjectNumber)='' then begin
                    MyTextMessage('��������������','��� ������ ������ ���������� �������/������� ������.',1);
                    exit;
                  end;
                  GridPlayer:=grPlayList;
                  PanelProject.Visible:=false;
                  PanelClips.Visible:=false;
                  PanelPlayList.Visible:=true;
                  sbProject.Font.Style:=sbProject.Font.Style - [fsBold,fsUnderline];
                  sbClips.Font.Style:=sbClips.Font.Style - [fsBold,fsUnderline];
                  sbPlayList.Font.Style:=sbPlayList.Font.Style + [fsBold,fsUnderline];
                  if listbox1.ItemIndex=-1
                    then lbusesclpidlst.Caption := '����-����: '
                    else lbusesclpidlst.Caption := '����-����: ' + trim(ListBox1.Items.Strings[ListBox1.ItemIndex]);
                  if trim(Form1.lbActiveClipID.Caption)<>''   then begin
                    GridPlayer:=grPlayList;
                    GridPlayerRow:=SetInGridClipPosition(GridActPlayList, Form1.lbActiveClipID.Caption);
                  end else GridPlayerRow:=-1;
                  ActiveControl := GridActPlayList;
                  WriteLog('MAIN', 'UCommon.SetMainGridPanel MainGrid=actplaylist');
                end;
        end;
    CheckedClipsInList;
    CheckedActivePlayList;
    WriteLog('MAIN', 'UCommon.SetMainGridPanel Finish');
  end;
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.SetMainGridPanel | ' + E.Message);
  end;
end;

procedure ButtonControlLists(command : integer);
var s:string;
    i, res, ps, cnt : integer;
    nm : string;
    id : longint;
    cntmrk, cntdel, hghtgr : integer;
begin
  try
  WriteLog('MAIN', 'UCommon.ButtonControlLists Command=' + inttostr(command));

  with Form1 do begin
      case command of
    0 : begin
          EditTimeline(-1);
        end;
    1 : begin
          if panelprepare.Visible then begin
            for i := 1 to GridTimelines.RowCount-1 do begin
              if (GridTimelines.Objects[0, i] as ttimelineoptions).IDTimeline = ZoneNames.Edit.IDTimeline then begin
                GridTimelines.Row:=i;
                break;
              end;
            end;
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
        end;
    2:  begin
           if (GridTimeLines.Selection.Top < 1) or (GridTimeLines.Selection.Top >= GridTimeLines.RowCount) then exit;
           EditTimeline(GridTimeLines.Selection.Top);
         end;
       end; //case
    hghtgr:=0;
    for i:=0 to GridTimeLines.RowCount-1 do hghtgr:=hghtgr+GridTimeLines.RowHeights[i];
    GridTimeLines.Height:=hghtgr;
    GridTimeLines.Repaint;
    if panelprepare.Visible then UpdatePanelPrepare;
  end;
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.ButtonControlLists Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonPlaylLists(command : integer);
var s:string;
    i, res, ps, cnt : integer;
    nm : string;
    id : longint;
    cntmrk, cntdel : integer;
begin
  try
  WriteLog('MAIN', 'UCommon.ButtonPlaylLists Command=' + inttostr(command));
  with Form1 do begin
      case command of
    0 : begin
//          ps := findgridselection(form1.gridprojects, 2);
//          if ps=-1 then exit;
          EditPlaylist(-1);
          //SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
          GridLists.Repaint;
          CheckedActivePlayList;

        end;
    1 : begin
          ps := findgridselection(gridlists, 2);
          cntmrk := CountGridMarkedRows(GridLists, 1, 1);
          if cntmrk<>0 then begin
            if Not MyTextMessage('������', '�� ������������� ������ ������� ��� ���������� ����-�����?',2) then exit;
            if ps>0 then begin
              if (GridLists.Objects[0,ps] as TGridRows).MyCells[1].Mark and (not (GridLists.Objects[0,ps] as TGridRows).MyCells[0].Mark) then begin
                if MyTextMessage('������', '�� ������������� ������ ������� �������� ����-����?',2) then begin
                  (GridLists.Objects[0,ps] as TGridRows).MyCells[2].Mark:=false;
                  //lbPlaylist.Caption:='';
                  pntlapls.SetText('CommentText',''); //    lbPLComment.Caption:='';
                  pntlapls.Draw(imgpldata.Canvas);
                  imgpldata.Repaint;
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
            MyTextMessage('���������','�������� ����-������ ' + inttostr(cntmrk) + ', ������� ' + inttostr(cntdel) + '.' ,1);
            //SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
          end else begin
            //ps := findgridselection(gridlists, 2);
            if ps=GridLists.Row then begin
              if (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[0].Mark then begin
                MyTextMessage('���������','����-���� ������� �� ��������',1);
                exit;
              end;
              if MyTextMessage('������', '�� ������������� ������ ������� �������� ����-����?',2) then begin
                nm := (GridLists.Objects[0,GridLists.Row ] as TGridRows).MyCells[3].ReadPhrase('Note');
                nm := PathPlaylists + '\PL' + trim(nm) + '.plst';
                if fileexists(nm) then DeleteFile(nm);
                MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                //SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
                //lbPlaylist.Caption:='';
                //lbPLComment.Caption:='';
                pntlapls.SetText('CommentText','');
                pntlapls.Draw(imgpldata.Canvas);
                imgpldata.Repaint;
                //lbPLCreate.Caption:='';
                //lbPLEnd.Caption:='';
                GridClear(GridActPlayList,RowGridClips);
              end;
            end else begin
              if MyTextMessage('������', '�� ������������� ������ ������� ����-����?',2) then begin
                nm := (GridLists.Objects[0,GridLists.Row] as TGridRows).MyCells[3].ReadPhrase('Note');
                nm := PathPlaylists + '\PL' + trim(nm) + '.plst';
                if fileexists(nm) then DeleteFile(nm);
                MyGridDeleteRow(GridLists, GridLists.Row, RowGridListPL);
                //SaveGridToFile(PathTemp + '\PlayLists.lst', GridLists);
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
                          //SortMyListClear;
                          //SortMyList[0].Name:='����-�����';
                          //SortMyList[0].Field:='Name';
                          //SortMyList[0].TypeData:=tstext;
                          mysortlist.clear;
                          mysortlist.Add('����-�����','Name',tstext,0);
                          GridSort(GridLists, 1, 3);
                        end;

                end;
          GridLists.Repaint;

        end;
       end; //case
       //DrawPanelButtons(imgButtonsControlProj.Canvas, IMGPanelProjectControl,-1);
       //GridTimelines.Repaint;
  end;
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.ButtonPlaylLists Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlProjects(command : integer);
var i, ps, setpos : integer;
    cntmrk, cntdel : integer;
    s, fp, msg, cmnt, edt : string;
    SDir, TDir : string;
begin
  try
  WriteLog('MAIN', 'UCommon.ButtonsControlProjects Command=' + inttostr(command));
  with Form1 do begin
           case command of
    2: CreateProject(-1);
    3: OpenProject;
    4: SaveProject;
    5: SaveProjectAs;
    0: begin
         if trim(ProjectNumber)='' then exit;
         MyTextTemplateOptions;
       end;
    1: begin
         if trim(ProjectNumber)='' then exit;
         EditImageTamplate;
       end;
    6 : CreateProject(1);
    7 : Form1.Close;
         end;
//    GridProjects.Repaint;
  end;
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.ButtonsControlProjects Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlMedia(command : integer);
var i, oldcount, ps, res : integer;
    crpos : teventreplay;
    clpid : string;
begin
  try
  WriteLog('MAIN', 'UCommon.ButtonsControlMedia Command=' + inttostr(command));
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
              if MyTextMessage('������','��������� ������������� ������ � ������ ������?',2) then begin
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
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.ButtonsControlMedia Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlPlayList(Command : integer);
var i, j, res : integer;
    ps, cntmrk, cntdel : integer;
begin
  try
  WriteLog('MAIN', 'UCommon.ButtonsControlPlayList Command=' + inttostr(command));
  with Form1 do begin
            case command of
    0: begin
          EditPlaylist(-1);
          GridLists.Repaint;
          ListBox1.Clear;
          for i:=1 to GridLists.RowCount-1 do begin
            ListBox1.Items.Add((GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Name'));
            j := ListBox1.Items.Count-1;
            if not (ListBox1.Items.Objects[j] is TMyListBoxObject) then ListBox1.Items.Objects[j] := TMyListBoxObject.Create;
            (ListBox1.Items.Objects[j] as TMyListBoxObject).ClipId := (GridLists.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Note');
          end;
          ps:=findgridselection(GridLists,2);
          if ps<>-1 then ListBox1.ItemIndex:=ps-1;
          ListBox1Click(nil);
       end;
    1:  begin
          if ListBox1.ItemIndex=-1 then exit;
          EditPlaylist(ListBox1.ItemIndex + 1);
          GridLists.Repaint;
          ps := ListBox1.ItemIndex;
          ListBox1.Items.Strings[ListBox1.ItemIndex]
            := (GridLists.Objects[0,ListBox1.ItemIndex + 1] as TGridRows).MyCells[3].ReadPhrase('Name');
          ListBox1.ItemIndex := ps;
          ListBox1Click(nil);
       end;
    5: begin
         //+++++++++++++++++++++++++
         cntmrk := CountGridMarkedRows(GridActPlayList, 1, 1);
         if cntmrk<>0 then begin
           if Not MyTextMessage('������', '�� ������������� ������ ������� ��� ���������� �����?',2) then exit;
           cntdel := 0;
           For i:=GridActPlayList.RowCount-1 downto 1 do begin
             if (GridActPlayList.Objects[0,i] as TGridRows).MyCells[1].Mark and (not (GridActPlayList.Objects[0,i] as TGridRows).MyCells[0].Mark)then begin
               cntdel := cntdel + 1;
               EraseClipInWinPrepare((GridActPlayList.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
               MyGridDeleteRow(GridActPlayList, i, RowGridClips);
             end;
           end;
           GridActPlayList.Repaint;
           MyTextMessage('���������','�������� ������ ' + inttostr(cntmrk) + ', ������� ' + inttostr(cntdel) + '.',1);
         end else begin
           if (GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[0].Mark then begin
             MyTextMessage('���������','���� ������� �� ��������.',1);
             exit;
           end;
           if MyTextMessage('������', '�� ������������� ������ ������� ��������� ����?',2) then begin
             EraseClipInWinPrepare((GridActPlayList.Objects[0,GridActPlayList.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
             MyGridDeleteRow(GridActPlayList, GridActPlayList.Row, RowGridClips);
           end;
         end;
         //+++++++++++++++++++++++++
         //SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
         if ListBox1.ItemIndex<>-1 then begin
           CheckedActivePlayList;
         end;
       end;
    2: begin
         if MySynhro.Checked then begin
           if MyTextMessage('��������������','���������� ����� ������������� �� �������.' + #13#10 +
                            '� ������ ����������� ����� ������������� ����� �������.' + #13#10 +
                            #13#10 + '����������?',2)
           then begin
             MySynhro.Checked := false;
             if (GridClips.Objects[0,GridClips.Row] is TGridRows) then PlayClipFromActPlaylist;
           end;
         end else if (GridClips.Objects[0,GridClips.Row] is TGridRows) then PlayClipFromActPlaylist;
         //PlayClipFromActPlaylist;
       end;
    3: begin
         MySortList.clear;
         MySortList.Add('�������� ������','Clip',tstext,0);
         MySortList.Add('�������� �����','Song',tstext,0);
         MySortList.Add('�����������','Singer',tstext,0);
         MySortList.Add('����� ������','StartTime',tsdate,1);
         MySortList.Add('��-� �����','Duration',tstime,0);
         MySortList.Add('��-� �����.','Dur',tstime,0);
         MySortList.Draw(frSortGrid.Image3.Canvas);
         GridSort(GridActPlayList, 1, 3);
       end;
    4: begin
         ProbingStartTime(GridActPlayList);
       end;
            end;//case
    GridActPlayList.Repaint;
  end;
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.ButtonsControlPlayList Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ButtonsControlClipsPanel(Command : integer);
var i, res : integer;
    nm, txt : string;
    ps, cntmrk, cntdel : integer;
begin
  try
  WriteLog('MAIN', 'UCommon.ButtonsControlClipsPanel Command=' + inttostr(command));
  with Form1 do begin
    pnlbtnsclips.Enable:=false;
         case command of
    0: begin
         EditClip(-1);
         CheckedActivePlayList;
       end;
    1: begin
         EditClip(-100);
         CheckedActivePlayList;
       end;
    5: begin
         //+++++++++++++++++++++++++
         cntmrk := CountGridMarkedRows(GridClips, 1, 1);
         if cntmrk<>0 then begin
           if Not MyTextMessage('������', '�� ������������� ������ ������� ��� ���������� �����?',2) then exit;
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
           MyTextMessage('���������','�������� ������ ' + inttostr(cntmrk) + ', ������� ' + inttostr(cntdel) + '.',1);
         end else begin
           if (GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[0].Mark then begin
             MyTextMessage('���������','���� ������� �� ��������.',1);
             exit;
           end;
           if MyTextMessage('������', '�� ������������� ������ ������� ��������� ����?',2) then begin
             nm := PathClips + '\' + nm + '.clip';
             if FileExists(nm) then DeleteFile(nm);
             EraseClipInWinPrepare((GridClips.Objects[0,GridClips.Row] as TGridRows).MyCells[3].ReadPhrase('ClipID'));
             MyGridDeleteRow(GridClips, GridClips.Row, RowGridClips);
             if (GridClips.RowCount=2) and (GridClips.Row=1) and ((GridClips.Objects[0,GridClips.Row] as TGridRows).ID<=0)
               then ClearClipsPanel;
           end;
         end;
         //+++++++++++++++++++++++++
         //SaveGridToFile(PathTemp + '\Clips.lst', GridClips);
         if ListBox1.ItemIndex<>-1 then begin
           CheckedActivePlayList;
           //SaveGridToFile(PathPlayLists + '\' + trim(lbPLName.Caption),GridActPlayList);
         end;
       end;
    2: begin
         if MySynhro.Checked then begin
           if MyTextMessage('��������������','���������� ����� ������������� �� �������.' + #13#10 +
                            '� ������ ����������� ����� ������������� ����� �������.' + #13#10 +
                            #13#10 + '����������?',2)
           then begin
             MySynhro.Checked := false;
             if (GridClips.Objects[0,GridClips.Row] is TGridRows) then PlayClipFromClipsList;
           end;
         end else if (GridClips.Objects[0,GridClips.Row] is TGridRows) then PlayClipFromClipsList;  //PlayClipFromClipsList;
       end;
    3: begin
         MySortList.clear;
         MySortList.Add('�������� ������','Clip',tstext,0);
         MySortList.Add('�������� �����','Song',tstext,0);
         MySortList.Add('�����������','Singer',tstext,0);
         MySortList.Add('����� ������','StartTime',tsdate,1);
         MySortList.Add('��-� �����','Duration',tstime,0);
         MySortList.Add('��-� �����.','Dur',tstime,0);
         MySortList.Draw(frSortGrid.Image3.Canvas);
         GridSort(GridClips, 1, 3);
       end;
    4: begin
         //ps:=FindNextClipTime(Form1.GridClips);
         //ps := findgridselection(gridlist, 2);
         if ListBox1.itemIndex=-1 then begin
           MyTextMessage('���������','�� ������ �������� ����-����.',1);
           exit;
         end;
         LoadClipsToPlayList;
         SetMainGridPanel(actplaylist);
         if ListBox1.ItemIndex<>-1 then begin
           txt := (ListBox1.Items.Objects[ListBox1.ItemIndex] as TMyListBoxObject).ClipId;
           //SaveGridToFile(PathPlayLists + '\' + txt, GridActPlayList);
         end;
       end;
         end; //case
    pnlbtnsclips.Enable:=true;
    GridClips.Repaint;
  end;
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.ButtonsControlClipsPanel Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure SwitcherVideoPanels(command : integer);
var crpos : teventreplay;
begin
  try
  WriteLog('MAIN', 'UCommon.SwitcherVideoPanels Command=' + inttostr(command));
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
         then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'SwitcherVideoPanels-1')
         else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '', 'SwitcherVideoPanels-2');
       CurrentImageTemplate:='SS@@##';
       TemplateToScreen(crpos);
       MyMediaSwitcher.Select:=1;
     end;
       end;
    MyMediaSwitcher.Draw(imgTypeMovie.Canvas);
    imgTypeMovie.Repaint;
  end;
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.SwitcherVideoPanels Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;

procedure ControlButtonsPrepare(command : integer);
var i, j, res, ps : integer;
    crpos : teventreplay;
    tmpos : longint;
    bl : boolean;
    olddir, oldfilter, sext : string;
begin
  try
  WriteLog('MAIN', 'UCommon.ControlButtonsPrepare Command=' + inttostr(command));
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
           olddir := SaveDialog1.InitialDir;
           oldfilter := SaveDialog1.Filter;
           SaveDialog1.InitialDir := PathTemp + '\';
           SaveDialog1.Filter := '���� ������� ���� ����� (*.evtl)|*.EVTL';
           SaveDialog1.FileName := PathTemp + '\tledit.evtl';
           SaveDialog1.FilterIndex:=0;
           if SaveDialog1.Execute then begin
             sext := extractfileext(SaveDialog1.FileName);
             if trim(sext)='' then SaveDialog1.FileName:=SaveDialog1.FileName + '*.evtl';
             TLZone.TLEditor.SaveToFile(SaveDialog1.FileName);
           end;
           SaveDialog1.Filter := olddir;
           SaveDialog1.InitialDir := oldfilter;
         end;
  6    : begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;
           evswapbuffer.Cut;
         end;
  7    :  begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;
           evswapbuffer.Copy;
          end;
  8    :  begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           SaveToUNDO;
           evswapbuffer.Paste;
         end;
  9    : begin
           ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
           if TLZone.Timelines[ps].Block then begin
             frLock.ShowModal;
             exit;
           end;
           bl:=false;
           for i:=0 to TLZone.TLEditor.Count-1
             do if TLZone.TLEditor.Events[i].Select then bl := true;
           if bl then begin
             If not MyTextMessage('������','������� ���������� ��������, ��� ����������� �������������?',2) then exit;
             for i:=TLZone.TLEditor.Count-1 downto 0
               do if TLZone.TLEditor.Events[i].Select then TLZone.TLEditor.DeleteEvent(i);
           end else begin
             crpos := TLZone.TLEditor.CurrentEvents;
             if crpos.Number=-1 then exit;
             If not MyTextMessage('������','������� ������� ��������, ��� ����������� �������������?',2) then exit;
             TLZone.TLEditor.DeleteEvent(crpos.Number);
           end;
           TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
           TLZone.TLEditor.DrawEditor(bmpTimeline.Canvas,0);
           TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps,0);
           TLZone.DrawTimelines(imgTimelines.Canvas,bmpTimeline);
           if TLZone.TLEditor.TypeTL = tldevice then begin
             crpos := TLZone.TLEditor.CurrentEvents;
             if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image,'ControlButtonsPrepare-8');
             TemplateToScreen(crpos);
             if pnImageScreen.Visible then Image3.Repaint;
           end;
         end;
  10   : begin
           LoadFromUNDO;
           ps:=ZoneNames.Edit.GridPosition(Form1.GridTimeLines, ZoneNames.Edit.IDTimeline);
           SetPanelTypeTL((Form1.GridTimeLines.Objects[0,ps] as TTimelineOptions).TypeTL, ps);
           ZoneNames.Draw(imgTLNames.Canvas, Form1.GridTimeLines, true);
           TLZone.DrawBitmap(bmptimeline);
           TLZone.DrawTimelines(ImgTimelines.Canvas,bmptimeline);
           if (vlcmode<>play) then begin
             MediaSetPosition(TLParameters.Position, false, 'UCommon.ControlButtonsPrepare');
             mediapause;
             crpos := TLZone.TLEditor.CurrentEvents;
             if crpos.Number <> -1
               then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlButtonsPrepare 9-1')
               else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '', 'ControlButtonsPrepare 9-2');
               TemplateToScreen(crpos);
           end;
         end;
  11   : begin
           olddir := OpenDialog1.InitialDir;
           oldfilter := OpenDialog1.Filter;
           OpenDialog1.InitialDir := PathTemp;
           OpenDialog1.Filter := '���� ������� ���� ����� (*.evtl)|*.EVTL';
           OpenDialog1.FilterIndex:=0;
           if OpenDialog1.Execute then begin
             TLZone.TLEditor.LoadFromFile(TLZone.TLEditor.TypeTL, OpenDialog1.FileName);
             TLZone.DrawBitmap(bmptimeline);
             TLZone.DrawTimelines(form1.imgtimelines.Canvas,bmptimeline);
             form1.imgtimelines.Repaint;
             ps := FindClipInGrid(GridClips,trim(lbActiveClipID.Caption));
             (GridClips.Objects[0,ps] as tgridrows).MyCells[3].UpdatePhrase('Dur',FramesToStr(TLParameters.Finish-TLParameters.Preroll));
             CheckedActivePlayList;
             SaveClipEditingToFile(trim(lbActiveClipID.Caption));
           end;
           OpenDialog1.Filter := olddir;
           OpenDialog1.InitialDir := oldfilter;
         end;
       end;
  end;
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.ControlButtonsPrepare Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;

Procedure ControlPlayerTransmition(command : integer);
var i, res :integer;
    crpos : teventreplay;
    posi : longint;
begin
  try
  WriteLog('MAIN', 'UCommon.ControlPlayerTransmition Command=' + inttostr(command));
  with Form1 do begin
     case command of
  0 : begin
        SaveToUNDO;
        TLParameters.Position:=TLParameters.Start; //TLParameters.ZeroPoint;
        crpos := TLZone.TLEditor.CurrentEvents;
        if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerTransmition-1');
        TemplateToScreen(crpos);
        if pnImageScreen.Visible then Image3.Repaint;
        MediaSetPosition(TLParameters.Position, false, 'UCommon.ControlPlayerTransmition-0');
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
          if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerTransmition-1');
          TemplateToScreen(crpos);
          if pnImageScreen.Visible then Image3.Repaint;
          MediaSetPosition(TLParameters.Position, false, 'UCommon.ControlPlayerTransmition-1.1');//1
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
        MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerTransmition 1-1');
        TemplateToScreen(crpos);
        if pnImageScreen.Visible then Image3.Repaint;
        MediaSetPosition(TLParameters.Position, false, 'UCommon.ControlPlayerTransmition-1.2');//2
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
          if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerTransmition-2');
          TemplateToScreen(crpos);
          if pnImageScreen.Visible then Image3.Repaint;
          MediaSetPosition(TLParameters.Position, false, 'UCommon.ControlPlayerTransmition-2.1');//1
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
        MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerTransmition 2-2');
        TemplateToScreen(crpos);
        if pnImageScreen.Visible then Image3.Repaint;
        MediaSetPosition(TLParameters.Position, false, 'UCommon.ControlPlayerTransmition-2.2');//2
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
        if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerTransmition-3');
        TemplateToScreen(crpos);
        if pnImageScreen.Visible then Image3.Repaint;
        MediaSetPosition(TLParameters.Position, false, 'UCommon.ControlPlayerTransmition-3');
        //TLZone.TLEditor.UpdateScreen(imgtimelines.Canvas);
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
     TLZone.DrawTimelines(Form1.imgTimelines.Canvas, bmptimeline);
     form1.imgLayer1.Repaint;
  end;//with
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.ControlPlayerTransmition Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;


procedure ControlPlayerFastSlow(command : integer);
var crpos : teventreplay;
    rightlimit : longint;
begin
  try
  WriteLog('MAIN', 'UCommon.ControlPlayerFastSlow Command=' + inttostr(command));
        case command of
  0 : begin
        if vlcmode=play then begin
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
          if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerFastSlow-0');
          TemplateToScreen(crpos);
          if Form1.pnImageScreen.Visible then Form1.Image3.Repaint;
          MediaSetPosition(TLParameters.Position, false, 'ControlPlayerFastSlow-0');
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
        if vlcmode=play then begin
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
          if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerFastSlow-1');
          TemplateToScreen(crpos);
          if Form1.pnImageScreen.Visible then Form1.Image3.Repaint;
          MediaSetPosition(TLParameters.Position, false, 'ControlPlayerFastSlow-1');
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
        if vlcmode=play then begin
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
          if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerFastSlow-2');
          TemplateToScreen(crpos);
          if Form1.pnImageScreen.Visible then Form1.Image3.Repaint;
          MediaSetPosition(TLParameters.Position, false, 'ControlPlayerFastSlow-2');
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
        if vlcmode=play then begin
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
          if crpos.Number <> -1 then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image, 'ControlPlayerFastSlow-3');
          TemplateToScreen(crpos);
          if Form1.pnImageScreen.Visible then Form1.Image3.Repaint;
          MediaSetPosition(TLParameters.Position, false, 'ControlPlayerFastSlow-3');
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
  except
    On E : Exception do WriteLog('MAIN', 'UCommon.ControlPlayerFastSlow Command=' + inttostr(command) + ' | ' + E.Message);
  end;
end;

initialization
  ListEditedProjects := tstringlist.Create;
  ListEditedProjects.Clear;

  ListVisibleWindows := tstringlist.Create;
  ListVisibleWindows.Clear;

  WorkHotKeys := TMyListHotKeys.Create('Default');
  WorkHotKeys.SetDefault;
finalization
  ListEditedProjects.Free;
  ListVisibleWindows.Free;
  WorkHotKeys.Free;

end.
