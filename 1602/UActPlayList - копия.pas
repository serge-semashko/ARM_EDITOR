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

implementation
uses umain, ucommon, ugrid, uimportfiles, ugrtimelines, utimeline, udrawtimelines, uairdraw;

procedure SetButtonsPredNext;
begin
  if GridPlayerRow=1
    then Form1.sbPredClip.Enabled:=false
    else Form1.sbPredClip.Enabled:=true;
  if GridPlayer=grPlayList then begin
    if GridPlayerRow=Form1.GridActPlayList.RowCount-1
      then Form1.sbNextClip.Enabled:=false
      else Form1.sbNextClip.Enabled:=true;
  end else begin
    if GridPlayerRow=Form1.GridClips.RowCount-1
      then Form1.sbNextClip.Enabled:=false
      else Form1.sbNextClip.Enabled:=true;
  end;
end;

procedure LoadPredClipToPlayer;
begin
  if GridPlayerRow > 1 then GridPlayerRow:=GridPlayerRow - 1;
  SetButtonsPredNext;
  MediaStop;
  mode:=stop;
  LoadClipsToPlayer;
  SetMediaButtons;
end;

procedure LoadNextClipToPlayer;
var cnt : integer;
begin
  if GridPlayer=grPlayList then begin
    cnt:=Form1.GridActPlayList.RowCount;
  end else begin
    cnt:=Form1.GridClips.RowCount
  end;
  if GridPlayerRow < cnt - 1 then GridPlayerRow:=GridPlayerRow + 1;
  SetButtonsPredNext;
  MediaStop;
  mode:=stop;
  LoadClipsToPlayer;
  SetMediaButtons;
end;

Procedure LoadClipsToPlayer;
var fn : string;
    err : integer;
    dur : double;
begin
  Form1.Label2Click(nil);
  SetButtonsPredNext;

  if GridPlayerRow<=0 then exit;
  if GridPlayer=grPlayList then begin
    if Not (Form1.GridActPlayList.Objects[0,GridPlayerRow] is TGridRows) then exit;
    fn := (Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
    Form1.lbNomClips.Caption:=inttostr(GridPlayerRow);
    Form1.Label2.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbClipName.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbSongName.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
    Form1.lbSongSinger.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
    Form1.lbPlayerFile.Caption:=(Form1.GridActPlayList.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
  end else begin
    if Not (Form1.GridClips.Objects[0,GridPlayerRow] is TGridRows) then exit;
    fn := (Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
    Form1.lbNomClips.Caption:=inttostr(GridPlayerRow);
    Form1.Label2.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbClipName.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Clip');
    Form1.lbSongName.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Song');
    Form1.lbSongSinger.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('Singer');
    Form1.lbPlayerFile.Caption:=(Form1.GridClips.Objects[0,GridPlayerRow] as TGridRows).MyCells[3].ReadPhrase('File');
  end;

  if not FileExists(fn) then begin
    Showmessage('Не найден медиа файл : ' + fn);
    exit;
  end;

  Err := CreateGraph(fn);
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
  //ZoneNames.Edit.AssignTL(form1.imgtimelines.Canvas, Form1.GridTimeLines, NamesTL.Names[1]);
  TLZone.DrawBitmap(bmptimeline);
  TLZone.DrawTimelines(form1.imgtimelines.Canvas,bmptimeline);
  if TLZone.TLEditor.Index=0 then TLZone.TLEditor.Index:=1;
  MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas,TLZone.TLEditor.Index);
  MyPanelAir.AirDevices.Draw(Form1.ImgDevices.Canvas);
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
var i, cnt, rw : integer;
begin
  With Form1 do begin
    cnt:=0;
    For i:=1 to GridClips.RowCount-1 do begin
      if GridClips.Objects[0,i] is TGridRows then begin
        if (GridClips.Objects[0,i] as TGridRows).ID<>0 then begin
          if (GridClips.Objects[0,i] as TGridRows).MyCells[1].Mark then begin
            cnt:=cnt+1;
            rw := GridAddRow(GridActPlayList,RowGridClips);
            (GridActPlayList.Objects[0,rw] as TGridRows).Assign((GridClips.Objects[0,i] as TGridRows));
            (GridClips.Objects[0,i] as TGridRows).MyCells[1].Mark:=False;
          end; //if3
        end; //if2
      end; // if1
    end; //for
    if cnt=0 then ShowMessage('Не выделенно ни одного клипа.');
  end; //width
end;

end.
