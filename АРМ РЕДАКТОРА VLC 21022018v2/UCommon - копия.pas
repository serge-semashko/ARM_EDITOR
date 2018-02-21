unit UCommon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, UGrid, uwaiting, JPEG;

Type
  TGridPlayer = (grClips, grPlaylist);

Const
  DirProjects  = 'Projects';
  DirPlaylists = 'Playlists';
  DirTemplates = 'Templates';
  DirImages    = 'Images';
  DirClips     = 'Clips';
  DirEvents    = 'Events';
  DirTemp      = 'Temp';

Var

//Временно используемые параметрв для отладки программы
  IDTL : longint = 0;     // Для формирования IDTimeline
  IDCLIPS : longint = 0;  // Для формирования IDClips
  IDPROJ : longint = 0;   // Для формирования IDProj
  IDPLst : longint = 0;   // Для формирования IDLst
  IDTXTTmp : longint = 0; // Для формирования IDTXTTmp
  IDGRTmp : longint = 0;  // Для формирования IDGRTmp
  IDEvents : longint = 0; // Для формирование IDEvents
  
  FWait : TFWaiting;
//Основные параметры программы
  RowsEvents : integer = 7;
  AppPath, AppName : string;
  PathProject : string;
  PathEvents : string;
  PathTemp : string;
  PathTemplates : string;

  TempPlayLists : string = '';
  TempGRTemplates : string = '';
  TempTextTemplates : string = '';
  TempTimelines : string = '';
  TempClipsLists : string = '';
  TempActPlayList : string = '';
  DeltaDateDelete : integer = 10;
  CurrentMode : boolean = false;
  MainGrid : TTypeGrid = projects;
  SecondaryGrid : TTypeGrid = empty;
  ProgrammColor : tcolor = $494747;
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

  GridPlayer : TGridPlayer = grPlayList;
  GridPlayerRow  : integer = -1;
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
  GridColorPen : tcolor = clWhite;//$aaaaaa;
  GridMainFontColor : tcolor = clWhite;
  GridColorRow1 : tcolor = $211F1F;//$ccffcc;
  GridColorRow2 : tcolor = $201E1E;//$bbeebb;
  GridColorSelection : tcolor = $212020;//$77aa77;
  DblClickClips : boolean;
  DblClickProject : boolean;
  DblClickLists : boolean;
//Основные параметры Тайм-линий
  TLBackGround : tcolor = $211F1F;
  TLZoneNamesColor : tcolor = $505050;
  TLZoneNamesFontSize : integer = 12;
  TLZoneNamesFontColor : tcolor = clWhite;
  TLZoneNamesFontName : tfontname = 'Times New Roman';
  TLMaxDevice : integer = 6;
  TLMaxText : integer =5;
  TLMaxMedia : integer = 1;
  TLMaxCount : integer = 16;
  DefaultMediaColor : tcolor = $00d8a520;
  DefaultTextColor : tcolor = $00aceae1;
  Layer2FontColor : tcolor = $202020;
  Layer2FontSize : integer = 8;
  StatusColor : array[0..4] of tcolor = (clRed,clGreen,clBlue,clYellow,clSilver);

Procedure SetMainGridPanel(TypeGrid : TTypeGrid);
procedure SetSecondaryGrid(TypeGrid : TTypeGrid);
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
function createunicumname : string;
procedure CreateDirectories;
procedure initnewproject;
procedure saveoldproject;
procedure loadoldproject;
procedure LoadJpegFile(bmp : tbitmap; FileName : string);
Procedure PlayClipFromActPlaylist;
Procedure PlayClipFromClipsList;
procedure ControlPlayer;
procedure InsertEventToEditTimeline(nom : integer);
procedure MyTextRect(var cv : tcanvas; const Rect : TRect; Text : string);
//procedure MyTextRect(cv : tcanvas; Rect : TRect; Text : string);

implementation
uses umain, uproject, uinitforms, umyfiles, utimeline, udrawtimelines, ugrtimelines,
     uplaylists, uactplaylist, uplayer;

Procedure SetPathProject(IDProject : string);
begin
  PathProject:=AppPath + DirProjects + '\' + IDProject;
  PathEvents:=PathProject + '\' + DirEvents;
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

{procedure MyTextRect(cv : tcanvas; Rect : TRect; Text : string);
var LR : TLogFont;
    FHOld, FHNew : HFONT;
    wdth, fntsz, sz, sz1, szc, sz2 : integer;
    size : TSize;
    pr : integer;
    s, s1, s2: string;
    bmp : tbitmap;
begin
  bmp := t.Create;
  bmp.Width:=rect.Right-rect.Left;
  bmp.Height:=rect.Bottom-rect.Top;
  bmp.Canvas.CopyRect(bmp.Canvas.ClipRect,cv,Rect);
  try
    if length(Text)<=0 then exit;
    fntsz:=cv.Font.Size;
    wdth := Rect.Right-Rect.Left;
    GetObject(cv.Font.Handle, SizeOf(LR), Addr(LR));
    LR.lfHeight:=Rect.Bottom-Rect.Top;
    For sz:=40 downto 1 do begin
      LR.lfWidth:=sz;
      FHNew:=CreateFontIndirect(LR);
      FHOld:=SelectObject(cv.Handle,FHNew);
      szc := cv.TextWidth(Text);
      //szc:=CalcTextWidth(cv.Handle, Text);
      if szc <= wdth then break;
    end;
    sz2 := wdth - szc;
    s1:=copy(Text,1,Length(Text)-sz2);
    s2:=copy(Text,length(Text)-sz2+1,sz2);
    cv.TextOut(Rect.Left,Rect.Top,s1);
    szc:=cv.TextWidth(s1);
    //szc:=CalcTextWidth(cv.Handle, s1);
    SetTextCharacterExtra(cv.Handle, 1);
    cv.TextOut(Rect.Left+szc,Rect.Top,s2);
    SetTextCharacterExtra(cv.Handle, 0);
    FHNew:=SelectObject(cv.Handle,FHOld);
    DeleteObject(FHNew);
    cv.Font.Size:=fntsz;
  finally
    bmp.Free;
    bmp:=nil;
  end;
end;}

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
    bmp.Canvas.Brush.Color:=cv.Brush.Color;
    bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
    bmp.Canvas.CopyRect(bmp.Canvas.ClipRect,cv,Rect);
    bmp.Canvas.Brush.Style:=bsSolid;
    bmp.Canvas.Font.Assign(cv.Font);
    //if length(Text)<=0 then exit;
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
       for sz:=szm to 30 do begin
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

//    For sz:=30 downto 1 do begin
//      LR.lfWidth:=sz;
//      FHNew:=CreateFontIndirect(LR);
//      FHOld:=SelectObject(bmp.Canvas.Handle,FHNew);
//      szc := bmp.Canvas.TextWidth(Text);
//      if szc <= wdth then break
//      else begin
//       FHNew:=SelectObject(bmp.Canvas.Handle,FHOld);
//       DeleteObject(FHNew);
//      end;
//    end;

    sz2 := wdth - szc;
    s1:=copy(Text,1,Length(Text)-sz2);
    s2:=copy(Text,length(Text)-sz2+1,sz2);
    bmp.Canvas.TextOut(0,0,s1);
    szc:=bmp.Canvas.TextWidth(s1);
    SetTextCharacterExtra(bmp.Canvas.Handle, 1);
    bmp.Canvas.TextOut(szc,0,s2);
    //cv.CopyRect(Rect,bmp.Canvas,bmp.Canvas.ClipRect);
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
  ps := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
      case TLZone.TLEditor.TypeTL of
  tlDevice : begin
               if nom > (Form1.GridTimeLines.Objects[0,ps+1] as TTimelineOptions).CountDev-1 then exit;
               if ps<>-1 then begin
                 TLZone.TLEditor.AddEvent(TLParameters.Position,ps+1,nom);
                 TLZone.TLEditor.ReturnEvents(TLZone.Timelines[ps]);
                 //if mode=play then exit;
              //TLZone.DrawBitmap(bmptimeline);
                 TLZone.TLEditor.DrawEditor(bmptimeline.Canvas);
                 TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps);
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
                 TLZone.TLEditor.DrawEditor(bmptimeline.Canvas);
                 TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps);
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
                 TLZone.TLEditor.DrawEditor(bmptimeline.Canvas);
                 TLZone.Timelines[ps].DrawTimeline(bmptimeline.Canvas,ps);
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
  LoadClipsToPlayer;
  MyTimer.Waiting:=false;
end;

Procedure PlayClipFromClipsList;
begin
  Form1.sbClips.Font.Style:=Form1.sbClips.Font.Style + [fsUnderline];
  MyTimer.Waiting:=true;
  GridPlayer:=grClips;
  GridPlayerRow:=Form1.GridClips.Row;
  LoadClipsToPlayer;
  MyTimer.Waiting:=false;
end;

procedure ControlPlayer;
begin
  //pMediaPosition.get_Rate(Rate);
    //mode := play;
    //StartMyTimer;
  if mode=paused then MediaPlay else MediaPause;
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
  ps := findgridselection(form1.gridprojects, 2);

  if ps > 0 then begin
    ProjectToPanel(ps);
    nm := (form1.gridprojects.Objects[0,ps] as tgridrows).MyCells[3].ReadPhrase('Note');
    if trim(nm)<>'' then LoadProjectFromDisk(nm);
    SetSecondaryGrid(playlists);
    LoadGridFromFile(AppPath + DirProjects + '\' + TempPlayLists, form1.GridLists);
    LoadGridFromFile(AppPath + DirProjects + '\' + TempClipsLists, form1.GridClips);
    pp := findgridselection(form1.gridlists, 2);
    if pp > 0 then begin
      nm := (form1.gridlists.Objects[0,pp] as tgridrows).MyCells[3].ReadPhrase('Note');
      PlaylistToPanel(pp);
      LoadGridFromFile(AppPath + DirPlayLists + '\' + nm, form1.GridActPlayList);
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
    nm : string;
begin
  ps := findgridselection(Form1.gridprojects, 2);
  if ps > 0 then nm:=(form1.gridprojects.Objects[0,ps] as tgridrows).MyCells[3].ReadPhrase('Note');
  if trim(nm)<>'' then SaveProjectToDisk(nm);
  if trim(Form1.lbPLName.Caption)<>''
     then SaveGridToFile(AppPath + DirPlayLists + '\' + Form1.lbPLName.Caption, Form1.GridActPlayList);
end;

procedure initnewproject;
begin
  with Form1 do begin
    TempPlayLists := '';
    TempGRTemplates := '';
    TempTextTemplates := '';
    TempTimelines := '';
    lbProjectName.Caption:='';
    lbpComment.Caption:='';
    lbDateStart.Caption:='';
    lbDateEnd.Caption:='';
    InitGridTimelines;
    ZoneNames.Update;
    InitPanelPrepare;
    GridClear(GridClips,RowGridClips);
    GridClear(GridActPlayList,RowGridClips);
         case SecondaryGrid of
    playlists   : GridClear(GridLists, RowGridListPL);
    grtemplate  : GridClear(GridLists, RowGridListGR);
    txttemplate : GridClear(GridLists, RowGridListTxt);
         end;
  end;
end;

procedure CreateDirectories;
var i : integer;
    ext : string;
begin
  AppPath := extractfilepath(Application.ExeName);
  AppName := extractfilename(Application.ExeName);
  ext := extractfileext(Application.ExeName);
  AppName := copy(AppName,1,length(AppName)-length(ext));
  if not DirectoryExists(AppPath+DirProjects)  then ForceDirectories(AppPath+DirProjects);
  if not DirectoryExists(AppPath+DirPlaylists) then ForceDirectories(AppPath+DirPlaylists);
  if not DirectoryExists(AppPath+DirTemplates) then ForceDirectories(AppPath+DirTemplates);
  if not DirectoryExists(AppPath+DirImages)    then ForceDirectories(AppPath+DirImages);
  if not DirectoryExists(AppPath+DirClips)     then ForceDirectories(AppPath+DirClips);
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

function FramesToStr(frm : longint) : string;
var HH,MM,SS,FF,DLT : longint;
begin
  DLT:=frm div 25;
  FF:= frm mod 25;
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := TwoDigit(HH)+':'+TwoDigit(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
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
  result := st +inttostr(MM)+':'+TwoDigit(SS)+':'+TwoDigit(FF);
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
  DLT:=Trunc(db);
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
  DLT:=Trunc(db);
  FF:=Trunc((db-DLT)*1000/40);
  HH:=DLT div 3600;
  MM:=DLT mod 3600;
  SS:=MM mod 60;
  MM:=MM div 60;
  result := (HH*3600 + mm*60 + SS)*25 + FF;
end;

Function DefineFontSizeW(cv : TCanvas; width : integer; txt : string): integer;
var fntsz, sz : integer;
begin
  result:=0;
  if cv.Font.Size=0 then cv.Font.Size:=40;
  fntsz:=cv.Font.Size;
  For sz:=fntsz downto 5 do begin
    cv.Font.Size:=sz;
    if cv.TextWidth(txt) < width - 4 then break;
  end;
  result := sz;
  cv.Font.Size:=fntsz;
end;

Function DefineFontSizeH(cv : TCanvas; height : integer): integer;
var fntsz, sz : integer;
begin
  result:=0;
  fntsz:=cv.Font.Size;
  //cv.Font.Size:=40;
  For sz:=40 downto 5 do begin
    cv.Font.Size:=sz;
    if cv.TextHeight('0') < height-2 then break;
  end;
  result := sz;
  cv.Font.Size:=fntsz;
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

procedure SetSecondaryGrid(TypeGrid : TTypeGrid);
begin
 // SecondaryGrid:=TypeGrid;
  With Form1 do begin
      Case TypeGrid of
  playlists   : begin
                  sbListPlayLists.Font.Style:=sbListPlayLists.Font.Style + [fsBold,fsUnderline];
                  sbListGraphTemplates.Font.Style:=sbListGraphTemplates.Font.Style - [fsBold,fsUnderline];
                  sbListTextTemplates.Font.Style:=sbListTextTemplates.Font.Style - [fsBold,fsUnderline];
                  if SecondaryGrid<>TypeGrid then begin
                    initgrid(Form1.GridLists, RowGridListPL, PanelProject.Width - panel2.Width);
                    if TempPlayLists<>'' then LoadGridFromFile(AppPath + DirProjects + '\' + TempPlayLists, GridLists);
                  end;
                end;
  grtemplate  : begin
                  sbListPlayLists.Font.Style:=sbListPlayLists.Font.Style - [fsBold,fsUnderline];
                  sbListGraphTemplates.Font.Style:=sbListGraphTemplates.Font.Style + [fsBold,fsUnderline];
                  sbListTextTemplates.Font.Style:=sbListTextTemplates.Font.Style - [fsBold,fsUnderline];
                  if SecondaryGrid<>TypeGrid then begin
                    initgrid(Form1.GridLists, RowGridListGR, PanelProject.Width - panel2.Width);
                    if TempGrTemplates<>'' then begin
                      LoadGridFromFile(AppPath + DirProjects + '\' + TempGrTemplates, GridLists);
                      GridLists.Repaint;
                      application.ProcessMessages;
                      GridImageReload(GridLists);
                    end;
                  end;
                end;
  txttemplate : begin
                  sbListPlayLists.Font.Style:=sbListPlayLists.Font.Style - [fsBold,fsUnderline];
                  sbListGraphTemplates.Font.Style:=sbListGraphTemplates.Font.Style - [fsBold,fsUnderline];
                  sbListTextTemplates.Font.Style:=sbListTextTemplates.Font.Style + [fsBold,fsUnderline];
                  if SecondaryGrid<>TypeGrid then begin
                    initgrid(Form1.GridLists, RowGridListTxt, PanelProject.Width - panel2.Width);
                    if TempTextTemplates<>'' then LoadGridFromFile(AppPath + DirProjects + '\' + TempTextTemplates, GridLists);
                  end;
                end;
      end;
  end;
  SecondaryGrid:=TypeGrid;
  Form1.GridLists.Repaint;
end;

Procedure SetMainGridPanel(TypeGrid : TTypeGrid);
begin
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
                  SetSecondaryGrid(SecondaryGrid);
                end;
  clips       : begin
                  PanelProject.Visible:=false;
                  PanelClips.Visible:=true;
                  PanelPlayList.Visible:=false;
                  sbProject.Font.Style:=sbProject.Font.Style - [fsBold,fsUnderline];
                  sbClips.Font.Style:=sbClips.Font.Style + [fsBold,fsUnderline];
                  sbPlayList.Font.Style:=sbPlayList.Font.Style - [fsBold,fsUnderline];
                end;
  actplaylist : begin
                  PanelProject.Visible:=false;
                  PanelClips.Visible:=false;
                  PanelPlayList.Visible:=true;
                  sbProject.Font.Style:=sbProject.Font.Style - [fsBold,fsUnderline];
                  sbClips.Font.Style:=sbClips.Font.Style - [fsBold,fsUnderline];
                  sbPlayList.Font.Style:=sbPlayList.Font.Style + [fsBold,fsUnderline];
                end;
        end;
  end;
end;


end.
