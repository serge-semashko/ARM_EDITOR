unit UActPlayList;
                          
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer;

procedure LoadClipsToPlayList;
Procedure LoadClipsToPlayer;
procedure LoadPredClipToPlayer;
procedure LoadNextClipToPlayer;
Procedure LoadFileToPlayer(FileName : string);
procedure ClearPanelActPlayList;
procedure CheckedActivePlayList;
procedure SetButtonsPredNext;
function ClipExists(Grid : tstringgrid; ClipID : string) : boolean;
function FindClipinGrid(Grid : tstringgrid; ClipID : string) : integer;
procedure GridActvePLToPanel(ARow : integer);
procedure LoadDefaultClipToPlayer;

implementation
uses umain, ucommon, ugrid, uimportfiles, ugrtimelines, utimeline, udrawtimelines,
     uairdraw, umyfiles, UIMGButtons, umymessage, umyundo, uplaylists;

procedure ClearPanelActPlayList;
begin
  //Form1.lbPlayList.Caption:='';;
  //Form1.lbPLComment.Caption:='';
  //form1.lbPLCreate.Caption:='';
  //form1.lbPLEnd.Caption:='';
  //Form1.lbPLName.Caption:='';
end;

procedure GridActvePLToPanel(ARow : integer);
var i : integer;
    dur : longint;
    txt : string;
begin

  if Not (Form1.GridActPlayList.Objects[0,ARow] is TGridRows) then exit;
  with (Form1.GridActPlayList.Objects[0,ARow] as TGridRows).MyCells[3] do begin
    if ARow>=1 then begin
      Form1.lbplclip.Caption:='Клип:   ' + trim(ReadPhrase('Clip'));
      Form1.lbplsong.Caption:='Песня:   ' + trim(ReadPhrase('Song'));
      Form1.lbplclpComment.Caption:=trim(ReadPhrase('Comment'));
      Form1.lbplSinger.Caption:='Исполнитель:  ' + trim(ReadPhrase('Singer'));
      Form1.lbplmdur.Caption:=trim(ReadPhrase('Duration'));
      Form1.lbplNTK.Caption:=trim(ReadPhrase('NTK'));
      Form1.lbplDUR.Caption:=trim(ReadPhrase('Dur'));
      Form1.lbplstrt.Caption:=trim(ReadPhrase('TypeMedia'));
      Form1.lbplfile.Caption:='Файл:   ' + trim(ReadPhrase('File'));
    end else begin
      Form1.lbplclip.Caption:='Клип:';
      Form1.lbplsong.Caption:='Песня:';
      Form1.lbplclpComment.Caption:=trim('00:00:00:00');
      Form1.lbplSinger.Caption:='Исполнитель:';
      Form1.lbplmdur.Caption:=trim('00:00:00:00');
      Form1.lbplNTK.Caption:=trim('00:00:00:00');
      Form1.lbplDUR.Caption:=trim('00:00:00:00');
      Form1.lbplstrt.Caption:='';
      Form1.lbplfile.Caption:='Файл:';
    end;
    dur := 0;
    for i:=1 to Form1.GridActPlayList.RowCount-1 do begin
      txt := trim((Form1.GridActPlayList.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('Dur'));
      if txt<>'' then dur := dur + StrTimeCodeToFrames(txt);
    end;
    Form1.lbplfulldur.Caption := FramesToStr(dur);
  end;
end;

procedure SetButtonsPredNext;
begin

  if GridPlayerRow=1
    then Form1.sbPredClip.Enabled:=false
    else Form1.sbPredClip.Enabled:=true;
  if GridPlayer=grPlayList then begin
    Form1.sbProject.Font.Style:=Form1.sbProject.Font.Style - [fsBold,fsUnderline];
    Form1.sbClips.Font.Style:=Form1.sbClips.Font.Style - [fsBold,fsUnderline];
    Form1.sbPlayList.Font.Style:=Form1.sbPlayList.Font.Style + [fsBold,fsUnderline];
    Form1.sbPlayList.Repaint;
    if GridPlayerRow=Form1.GridActPlayList.RowCount-1
      then Form1.sbNextClip.Enabled:=false
      else Form1.sbNextClip.Enabled:=true;
  end else begin
    Form1.sbProject.Font.Style:=Form1.sbProject.Font.Style - [fsBold,fsUnderline];
    Form1.sbClips.Font.Style:=Form1.sbClips.Font.Style + [fsBold,fsUnderline];
    Form1.sbPlayList.Font.Style:=Form1.sbPlayList.Font.Style - [fsBold,fsUnderline];
    Form1.sbClips.Repaint;
    if GridPlayerRow=Form1.GridClips.RowCount-1
      then Form1.sbNextClip.Enabled:=false
      else Form1.sbNextClip.Enabled:=true;
  end;
end;

procedure LoadPredClipToPlayer;
var txt : string;
begin
  if GridPlayerRow > 1 then GridPlayerRow:=GridPlayerRow - 1;
  SetButtonsPredNext;
  MediaStop;
  mode:=stop;
  LoadClipsToPlayer;
  SetMediaButtons;
end;

function FindNextStartTime(grid : tstringgrid) : integer;
var Tm, delt, tmclp : longint;
    i : integer;
    time, tmstr : string;
begin
  result := -1;
  delt := -1;
  if MySinhro = chnone  then exit;
  if MySinhro=chltc then Time := MyDateTimeToStr(now-TimeCodeDelta) else Time := MyDateTimeToStr(now);
  for i:=1 to grid.RowCount-1 do begin
    tmstr:=trim((grid.Objects[0,i] as tgridrows).MyCells[3].ReadPhrase('TypeMedia'));
    if tmstr<>'' then begin
      tmclp:=StrTimeCodeToFrames(tmstr);
      tm :=StrTimeCodeToFrames(time);
      if tm=tmclp then begin
        result := i;
        exit;
      end;
      if tm < tmclp then begin
        if delt=-1 then begin
          delt := tmclp -tm;
          result:=i;
        end else begin
          if (tmclp-tm)<delt then begin
            delt := tmclp -tm;
            result:=i;
          end;
        end;
      end;
    end;
  end;
end;

procedure LoadNextClipToPlayer;
var cnt, ps : integer;
    txt : string;
    Reg : boolean;
begin
  reg := true;
  if GridPlayer=grPlayList then begin
    if MySinhro=chnone then begin
      cnt:=Form1.GridActPlayList.RowCount;
      GridPlayerRow:=FindClipinGrid(Form1.GridActPlayList, Form1.lbActiveClipID.Caption);
    end else begin
      ps := FindNextStartTime(Form1.GridActPlayList);
      if ps<>-1 then begin
        GridPlayerRow:=ps;
        reg := false;
      end else begin
        cnt:=Form1.GridActPlayList.RowCount;
        GridPlayerRow:=FindClipinGrid(Form1.GridActPlayList, Form1.lbActiveClipID.Caption);
      end;
    end;
  end else begin
    if MySinhro=chnone then begin
      cnt:=Form1.GridClips.RowCount;
      GridPlayerRow:=FindClipinGrid(Form1.GridClips, Form1.lbActiveClipID.Caption);
    end else begin
      ps := FindNextStartTime(Form1.GridClips);
      if ps<>-1 then begin
        GridPlayerRow:=ps;
        reg := false;
      end else begin
        cnt:=Form1.GridClips.RowCount;
        GridPlayerRow:=FindClipinGrid(Form1.GridClips, Form1.lbActiveClipID.Caption);
      end;
    end;
  end;
  if reg then begin
    if GridPlayerRow < cnt - 1 then GridPlayerRow:=GridPlayerRow + 1;
    SetButtonsPredNext;
  end;
  MediaStop;
  mode:=stop;
  LoadClipsToPlayer;
  SetMediaButtons;
end;

Procedure LoadDefaultClipToPlayer;
var fn, stc, snch : string;
    i, err, APos, postl : integer;
    dur : double;
    clpid, nmfl : string;
    crpos : teventreplay;
    s1, s2, s3 : string;
    defdur : longint;
begin
try
//Проверяем загружен ли клип в панель подготовки, если да проверяем от куда загружен клип из плей-листа или списка клипов
//
  SetProcessWorkingSetSize(GetCurrentProcess,$FFFFFFFF,$FFFFFFFF);
  if trim(Form1.lbActiveClipID.Caption)<>'' then exit;
  Form1.lbusesclpidlst.Caption := '';
  for i:=0 to TLZone.Count-1
    do if TLZone.Timelines[i].Count > 0 then exit;
  GridPlayer:=grDefault;

  //Form1.Label2Click(nil);

  ClearUndo;

  MyStartPlay  := -1;    // Время старта клипа, при chnone не используется, -1 время не установлено.
  MyStartReady := false; // True - готовность к старту, false - старт осуществлен.
  MyRemainTime := -1;  //время оставшееся до запуска

  Form1.lbNomClips.Caption:='...';
  Form1.Label2.Caption:='';//(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
  Form1.lbClipName.Caption:='';//(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
  Form1.lbSongName.Caption:='';//(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
  Form1.lbSongSinger.Caption:='';//(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
  Form1.lbPlayerFile.Caption:='';//(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
  form1.lbTypeTC.Caption :='';// Trim((Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('TypeMedia'));
  defdur := DefaultClipDuration;

  if MySinhro<>chnone then begin
    if form1.lbTypeTC.Caption<>'' then begin
        MyStartPlay:=StrTimeCodeToFrames(form1.lbTypeTC.Caption);
        MyStartReady := true;
    end;
  end;

  SwitcherVideoPanels(1);
  dur:=FramesToDouble(defdur);

  mode:=paused;

  if not LoadClipEditingFromFile('defaultclip') then begin
    TLZone.ClearZone;
    //EraseClipInWinPrepare('')
    TLParameters.ZeroPoint:=TLParameters.Preroll;
    TLParameters.Position:=TLParameters.ZeroPoint;
    TLParameters.StopPosition:=TLParameters.Position;
    TLParameters.Start:=TLParameters.Preroll;
    TLParameters.Duration:=MyDoubleToFrame(dur);
    TLParameters.Finish:=TLParameters.Preroll + TLParameters.Duration;
  end;

//  s1:=inttostr((Form1.GridTimeLines.Objects[0,1] as TTimelineOptions).IDTimeline);
//  s2:=inttostr(ZoneNames.Edit.IDTimeline);
//  s3:=inttostr(TLZone.TLEditor.IDTimeline);

  TLParameters.Duration:=MyDoubleToFrame(dur);
  TLParameters.UpdateParameters;

  TLParameters.Position:=TLParameters.Start;
  MediaSetPosition(TLParameters.Position, false);
  mediapause;
  //mediaplay;
  //mediapause;
  //TLParameters.Position := TLParameters.Start;
  //MediaSetPosition(TLParameters.Position, false);
  //mediapause;

  SetClipTimeParameters;
  if TLParameters.Finish = 0 then TLParameters.Finish:=TLParameters.Preroll + TLParameters.Duration;
  if TLParameters.Finish > (TLParameters.Preroll + TLParameters.Duration + TLParameters.Postroll)
    then TLParameters.Finish:=TLParameters.Preroll + TLParameters.Duration;
//  Form1.lbMediaDuration.Caption:=framestostr(TLParameters.Finish - TLParameters.Start);
//  TLParameters.Position:=TLParameters.Start;
//  MediaSetPosition(TLParameters.Position, false);
           case TLZone.TLEditor.TypeTL of
      tldevice : begin
                   Form1.pnDevTL.Visible:=true;
                   Form1.PnTextTL.Visible:=false;
                   Form1.pnMediaTL.Visible:=false;
                   APos := EditTL.GridPosition(form1.GridTimeLines, TLZone.TLEditor.IDTimeline);
                   btnsdevicepr.BackGround:=ProgrammColor;
                   if APos <> -1 then InitBTNSDEVICE(Form1.imgDeviceTL.Canvas, (form1.GridTimeLines.Objects[0,APos] as TTimelineOptions), btnsdevicepr);
                 end;
      tltext   : begin
                   Form1.pnDevTL.Visible:=false;
                   Form1.PnTextTL.Visible:=true;
                   Form1.pnMediaTL.Visible:=false;
                   Form1.imgTextTL.Width:=Form1.pnPrepareCTL.Width;
                   Form1.imgTextTL.Picture.Bitmap.Width:=Form1.imgTextTL.Width;
                   btnstexttl.Draw(Form1.imgTextTL.Canvas);
                 end;
      tlmedia  : begin
                   Form1.pnDevTL.Visible:=false;
                   Form1.PnTextTL.Visible:=false;
                   Form1.pnMediaTL.Visible:=true;
                   Form1.imgMediaTL.Picture.Bitmap.Width := Form1.imgMediaTL.Width;
                   Form1.imgMediaTL.Picture.Bitmap.Height := Form1.imgMediaTL.Height;
                   btnsmediatl.Top:=Form1.imgMediaTL.Height div 2 - 35;
                   btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
                 end;
           end; //case

  form1.imgTLNames.Height:=TLHeights.Height;
  form1.imgTimelines.Height:=TLHeights.Height;
  form1.imgTLNames.Picture.Bitmap.Height:=form1.imgTLNames.Height;
  form1.imgTimelines.Picture.Bitmap.Height:=form1.imgTimelines.Height;
  form1.Panel4.Height:=TLHeights.Height + Form1.Panel7.Height;

  postl := ZoneNames.Edit.GridPosition(form1.GridTimeLines,ZoneNames.Edit.IDTimeline);
  TLZone.TLEditor.Index := postl;
  if postl=-1 then begin
    ZoneNames.Edit.IDTimeline := (Form1.GridTimeLines.Objects[0,1] as TTimelineOptions).IDTimeline;
    postl := TLZone.FindTimeline(ZoneNames.Edit.IDTimeline);
    if postl<>-1 then TLZone.TLEditor.Assign(TLZone.Timelines[0],1);
    TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
  end;
  ZoneNames.Draw(form1.imgTLNames.Canvas, form1.GridTimeLines, true);

  TLZone.DrawBitmap(bmptimeline);
  TLZone.DrawTimelines(form1.imgtimelines.Canvas,bmptimeline);


  crpos := TLZone.TLEditor.CurrentEvents;
  if crpos.Number <> -1
    then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image)
    else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '');
  TemplateToScreen(crpos);


  form1.imgTLNames.Repaint;
  form1.imgTimelines.Repaint;
  //if TLZone.TLEditor.Index=0 then TLZone.TLEditor.Index:=1;

  //postl := ZoneNames.Edit.GridPosition(form1.GridTimeLines,ZoneNames.Edit.IDTimeline);

  MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas,TLZone.TLEditor.Index);
  MyPanelAir.SetValues;
  if Form1.PanelAir.Visible then MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
  //MyTimer.Enable := false;
except
  Form1.FormStyle := fsNormal;
end;
end;

Procedure LoadClipsToPlayer;
var fn, stc, snch : string;
    err, APos, postl : integer;
    dur : double;
    clpid, nmfl : string;
    crpos : teventreplay;
    s1, s2, s3 : string;
    defdur : longint;
begin
try
//Проверяем загружен ли клип в панель подготовки, если да проверяем от куда загружен клип из плей-листа или списка клипов
//
  SetProcessWorkingSetSize(GetCurrentProcess,$FFFFFFFF,$FFFFFFFF);
  if trim(Form1.lbActiveClipID.Caption)<>'' then begin
    if GridPlayer=grPlayList then begin
      if Not (Form1.GridActPlayList.Objects[0,GridPlayerRow] is TGridRows) then exit;
      clpid := (Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    end else begin
      if Not (Form1.GridClips.Objects[0,GridPlayerRow] is TGridRows) then exit;
      clpid := (Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    end;
    if trim(Form1.lbActiveClipID.Caption)<>trim(clpid) then SaveClipEditingToFile(trim(Form1.lbActiveClipID.Caption)); //******Warning
  end;

  //Form1.label7.Caption:=clpid; //******Warning

  Form1.Label2Click(nil);
  SetButtonsPredNext;

  if GridPlayerRow<=0 then exit;

  ClearUndo;

  MyStartPlay  := -1;    // Время старта клипа, при chnone не используется, -1 время не установлено.
  MyStartReady := false; // True - готовность к старту, false - старт осуществлен.
  MyRemainTime := -1;  //время оставшееся до запуска

  if GridPlayer=grPlayList then begin
    if Not (Form1.GridActPlayList.Objects[0,GridPlayerRow] is TGridRows) then exit;
    Form1.lbusesclpidlst.Caption:='Плей-лист: ' + Form1.cbPlayLists.Text;
    fn := (Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
    Form1.lbNomClips.Caption:=inttostr(GridPlayerRow);
    Form1.lbActiveClipID.Caption := (Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    Form1.Label2.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbClipName.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbSongName.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
    Form1.lbSongSinger.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
    Form1.lbPlayerFile.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
    form1.lbTypeTC.Caption := Trim((Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('TypeMedia'));
    defdur := StrTimeCodeToFrames((Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Duration'));
  end else begin
    if Not (Form1.GridClips.Objects[0,GridPlayerRow] is TGridRows) then exit;
    Form1.lbusesclpidlst.Caption:='Список клипов';
    fn := (Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
    Form1.lbNomClips.Caption:=inttostr(GridPlayerRow);
    Form1.lbActiveClipID.Caption := (Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('ClipID');
    Form1.Label2.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbClipName.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbSongName.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
    Form1.lbSongSinger.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
    Form1.lbPlayerFile.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
    form1.lbTypeTC.Caption := Trim((Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('TypeMedia'));
    defdur := StrTimeCodeToFrames((Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Duration'));
  end;

  if MySinhro<>chnone then begin
    if form1.lbTypeTC.Caption<>'' then begin
        MyStartPlay:=StrTimeCodeToFrames(form1.lbTypeTC.Caption);
        MyStartReady := true;
    end;
  end;
  //Form1.label7.Caption:=Form1.lbActiveClipID.Caption;

  SetStatusClipInPlayer(Form1.lbActiveClipID.Caption);

  if FileExists(fn) then begin
    SwitcherVideoPanels(0);
    Err := CreateGraph(fn);
    If Err<>0 then begin
       Showmessage(GraphErrorToStr(err));
       exit;
    end;
    pMediaPosition.get_Duration(dur);
    PlayerWindow(Form1.pnMovie);
    pMediaControl.Pause;
    pMediaPosition.get_Rate(Rate);
  end else begin
    SwitcherVideoPanels(1);
    dur:=FramesToDouble(defdur);
  end;

  mode:=paused;

  if not LoadClipEditingFromFile(Trim(Form1.lbActiveClipID.Caption)) then begin
    TLZone.ClearZone;
    //EraseClipInWinPrepare('')
    TLParameters.ZeroPoint:=TLParameters.Preroll;
    TLParameters.Position:=TLParameters.ZeroPoint;
    TLParameters.StopPosition:=TLParameters.Position;
    TLParameters.Start:=TLParameters.Preroll;
    TLParameters.Duration:=MyDoubleToFrame(dur);
    TLParameters.Finish:=TLParameters.Preroll + TLParameters.Duration;
  end;

//  s1:=inttostr((Form1.GridTimeLines.Objects[0,1] as TTimelineOptions).IDTimeline);
//  s2:=inttostr(ZoneNames.Edit.IDTimeline);
//  s3:=inttostr(TLZone.TLEditor.IDTimeline);

  TLParameters.Duration:=MyDoubleToFrame(dur);
  TLParameters.UpdateParameters;

  TLParameters.Position:=TLParameters.Start;
  MediaSetPosition(TLParameters.Position, false);
  mediapause;
  //mediaplay;
  //mediapause;
  //TLParameters.Position := TLParameters.Start;
  //MediaSetPosition(TLParameters.Position, false);
  //mediapause;

  SetClipTimeParameters;
  if TLParameters.Finish = 0 then TLParameters.Finish:=TLParameters.Preroll + TLParameters.Duration;
  if TLParameters.Finish > (TLParameters.Preroll + TLParameters.Duration + TLParameters.Postroll)
    then TLParameters.Finish:=TLParameters.Preroll + TLParameters.Duration;
//  Form1.lbMediaDuration.Caption:=framestostr(TLParameters.Finish - TLParameters.Start);
//  TLParameters.Position:=TLParameters.Start;
//  MediaSetPosition(TLParameters.Position, false);
           case TLZone.TLEditor.TypeTL of
      tldevice : begin
                   Form1.pnDevTL.Visible:=true;
                   Form1.PnTextTL.Visible:=false;
                   Form1.pnMediaTL.Visible:=false;
                   APos := EditTL.GridPosition(form1.GridTimeLines, TLZone.TLEditor.IDTimeline);
                   btnsdevicepr.BackGround:=ProgrammColor;
                   if APos <> -1 then InitBTNSDEVICE(Form1.imgDeviceTL.Canvas, (form1.GridTimeLines.Objects[0,APos] as TTimelineOptions), btnsdevicepr);
                 end;
      tltext   : begin
                   Form1.pnDevTL.Visible:=false;
                   Form1.PnTextTL.Visible:=true;
                   Form1.pnMediaTL.Visible:=false;
                   Form1.imgTextTL.Width:=Form1.pnPrepareCTL.Width;
                   Form1.imgTextTL.Picture.Bitmap.Width:=Form1.imgTextTL.Width;
                   btnstexttl.Draw(Form1.imgTextTL.Canvas);
                 end;
      tlmedia  : begin
                   Form1.pnDevTL.Visible:=false;
                   Form1.PnTextTL.Visible:=false;
                   Form1.pnMediaTL.Visible:=true;
                   Form1.imgMediaTL.Picture.Bitmap.Width := Form1.imgMediaTL.Width;
                   Form1.imgMediaTL.Picture.Bitmap.Height := Form1.imgMediaTL.Height;
                   btnsmediatl.Top:=Form1.imgMediaTL.Height div 2 - 35;
                   btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
                 end;
           end; //case

  form1.imgTLNames.Height:=TLHeights.Height;
  form1.imgTimelines.Height:=TLHeights.Height;
  form1.imgTLNames.Picture.Bitmap.Height:=form1.imgTLNames.Height;
  form1.imgTimelines.Picture.Bitmap.Height:=form1.imgTimelines.Height;
  form1.Panel4.Height:=TLHeights.Height + Form1.Panel7.Height;

  postl := ZoneNames.Edit.GridPosition(form1.GridTimeLines,ZoneNames.Edit.IDTimeline);
  TLZone.TLEditor.Index := postl;
  if postl=-1 then begin
    ZoneNames.Edit.IDTimeline := (Form1.GridTimeLines.Objects[0,1] as TTimelineOptions).IDTimeline;
    postl := TLZone.FindTimeline(ZoneNames.Edit.IDTimeline);
    if postl<>-1 then TLZone.TLEditor.Assign(TLZone.Timelines[0],1);
    TLZone.TLEditor.DrawEditor(bmptimeline.Canvas,0);
  end;
  ZoneNames.Draw(form1.imgTLNames.Canvas, form1.GridTimeLines, true);

  TLZone.DrawBitmap(bmptimeline);
  TLZone.DrawTimelines(form1.imgtimelines.Canvas,bmptimeline);

//  MyStartPlay  := -1;    // Время старта клипа, при chnone не используется, -1 время не установлено.
//  MyStartReady := false; // True - готовность к старту, false - старт осуществлен.
//  MyRemainTime := -1;  //время оставшееся до запуска


  crpos := TLZone.TLEditor.CurrentEvents;
  if crpos.Number <> -1
    then MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', crpos.Image)
    else MarkRowPhraseInGrid(Form1.GridGRTemplate, 0, 2, 'File', '');
  TemplateToScreen(crpos);


  form1.imgTLNames.Repaint;
  form1.imgTimelines.Repaint;
  //if TLZone.TLEditor.Index=0 then TLZone.TLEditor.Index:=1;

  //postl := ZoneNames.Edit.GridPosition(form1.GridTimeLines,ZoneNames.Edit.IDTimeline);

  MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas,TLZone.TLEditor.Index);
  MyPanelAir.SetValues;
  if Form1.PanelAir.Visible then MyPanelAir.Draw(Form1.ImgDevices.Canvas,Form1.ImgEvents.Canvas,TLZone.TLEditor.Index);
  //MyTimer.Enable := false;
except
  Form1.FormStyle := fsNormal;
end;
end;

Procedure LoadFileToPlayer(FileName : string);
var fn : string;
    err : integer;
    dur : double;
begin
  SetButtonsPredNext;

  if not FileExists(FileName) then begin
    Showmessage('Не найден медиа файл : ' + fn);
    exit;
  end;

  Err := CreateGraph(FileName);
  If Err<>0 then begin
     Showmessage(GraphErrorToStr(err));
     exit;
  end;
  pMediaPosition.get_Duration(dur);
  PlayerWindow(Form1.pnMovie);
  pMediaControl.Pause;
  pMediaPosition.get_Rate(Rate);
        //pMediaPosition.put_CurrentPosition(0);
  mode:=paused;

  TLParameters.Duration:=MyDoubleToFrame(dur);
  //TLParameters.NTK:=0; //###### Warming
  TLParameters.InitParameters;
  TLParameters.Position:=TLParameters.ZeroPoint;
  TLParameters.StopPosition:=TLParameters.Position;

  TLZone.DrawBitmap(bmptimeline);
  TLZone.DrawTimelines(form1.imgtimelines.Canvas,bmptimeline);
end;

procedure LoadClipsToPlayList;
var i, cnt, rw, ttl : integer;
begin
  With Form1 do begin
    cnt := 0;
    ttl := 0;
    For i:=1 to GridClips.RowCount-1 do begin
      if GridClips.Objects[0,i] is TGridRows then begin
        if (GridClips.Objects[0,i] as TGridRows).ID<>0 then begin
          if (GridClips.Objects[0,i] as TGridRows).MyCells[1].Mark then begin
            ttl := ttl + 1;
            if not ClipExists(GridActPlayList,(GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID')) then begin
              cnt:=cnt+1;
              rw := GridAddRow(GridActPlayList,RowGridClips);
              (GridActPlayList.Objects[0,rw] as TGridRows).Assign((GridClips.Objects[0,i] as TGridRows));
              (GridActPlayList.Objects[0,rw] as TGridRows).MyCells[0].Used:=false;
              (GridActPlayList.Objects[0,rw] as TGridRows).MyCells[1].Mark:=false;
              (GridClips.Objects[0,i] as TGridRows).MyCells[1].Mark:=False;
            end;
          end; //if3
        end; //if2
      end; // if1
    end; //for
    if cnt=0
      then MyTextMessage('Сообщение','В плей-лист не загружен ни один клип.',1)
      else MyTextMessage('Сообщение','Выделено клипов ' + inttostr(ttl) + ' загруженно в плей-лист ' + inttostr(cnt) + '.',1);
  end; //width
end;

function ClipExists(Grid : tstringgrid; ClipID : string) : boolean;
var i : integer;
   txt : string;
begin
  result := false;
  with form1 do begin
    for i:=1 to Grid.RowCount-1 do begin
      txt := (Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
      if trim(ClipID)=trim(txt) then begin
        result:=true;
        exit;
      end;
    end;
  end;
end;

function FindClipinGrid(Grid : tstringgrid; ClipID : string) : integer;
var i : integer;
   txt : string;
begin
  result := -1;
  with form1 do begin
    for i:=1 to Grid.RowCount-1 do begin
      txt := (Grid.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
      if trim(ClipID)=trim(txt) then begin
        result:=i;
        exit;
      end;
    end;
  end;
end;

procedure UpdateClipData(APos : integer; ClipID : string);
var i : integer;
   txt : string;
begin
  with form1 do begin
    for i:=1 to GridClips.RowCount-1 do begin
      txt := (GridClips.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
      if trim(ClipID)=trim(txt) then begin
        (GridActPlayList.Objects[0,APos] as TGridRows).Assign((GridClips.Objects[0,i] as TGridRows));
        exit;
      end;
    end;
  end;
end;

procedure CheckedActivePlayList;
var i : integer;
    txt : string;
begin
  with form1 do begin
    for i:=GridActPlayList.RowCount-1 downto 1 do begin
      if GridActPlayList.Objects[0,i] is TGridRows then begin
        txt :=  (GridActPlayList.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
        if not ClipExists(GridClips, txt) then begin
          if trim(txt)=trim(lbActiveClipID.Caption) then TLZone.ClearZone;
          MyGridDeleteRow(GridActPlayList, i, RowGridClips);
        end;
      end;
    end;
    for i:=1 to GridActPlayList.RowCount-1 do begin
      if GridActPlayList.Objects[0,i] is TGridRows then begin
        txt := (GridActPlayList.Objects[0,i] as TGridRows).MyCells[3].ReadPhrase('ClipID');
        UpdateClipData(i, txt);
        (GridActPlayList.Objects[0,i] as TGridRows).MyCells[0].Used:=false;
      end;
    end;
    if cbPlayLists.ItemIndex<>-1 then begin
      txt := (cbPlayLists.Items.Objects[cbPlayLists.ItemIndex] as TMyListBoxObject).ClipId;
      SaveGridToFile(PathPlayLists + '\' + trim(txt),GridActPlayList);
    end;
  end;
end;

end.
