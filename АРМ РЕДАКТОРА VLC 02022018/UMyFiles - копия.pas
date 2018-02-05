unit UMyFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer,  MMSystem;

Procedure SaveGridToFile(FileName : string; Grid : tstringgrid);
function LoadGridFromFile(FileName : string; Grid : tstringgrid) : boolean;
Procedure LoadProjectFromDisk(ProjectName : string);
Procedure SaveProjectToDisk(ProjectName : string);
procedure DeleteFilesMask (Dir: AnsiString; Mask : string);

//var Stream : TFileStream;

implementation

uses umain, ucommon, ugrid, utimeline, UGRTimelines;

procedure DeleteFilesMask (Dir: AnsiString; Mask : string);
var
  Sr: SysUtils.TSearchRec;
begin
{$I-}
  if (Dir <> '') and (Dir[length(Dir)] = '\') then  Delete(Dir, length(dir), 1);
  if FindFirst(Dir + '\' + Mask, faDirectory + faHidden + faSysFile + faReadonly + faArchive, Sr) = 0 then
    repeat
      if (Sr.Name = '.') or (Sr.Name = '..') then continue;
      if (Sr.Attr and faDirectory <> faDirectory) then begin
        //if AnsiLowerCase(ExtractFileExt(sr.Name)) = '.tmp' then begin
          FileSetReadOnly(Dir + '\' + sr.Name, False);
          DeleteFile(Dir + '\' + sr.Name);
        //end
      end;
    until FindNext(sr) <> 0;
  FindClose(sr);
end;

function KillDir (Dir: AnsiString): boolean;
var
  Sr: SysUtils.TSearchRec;
begin
{$I-}
  if (Dir <> '') and (Dir[length(Dir)] = '\') then
    Delete(Dir, length(dir), 1);
  if FindFirst(Dir + '\*.*', faDirectory + faHidden + faSysFile +
    faReadonly + faArchive, Sr) = 0 then
    repeat
      if (Sr.Name = '.') or (Sr.Name = '..') then
        continue;
      if (Sr.Attr and faDirectory <> faDirectory) then
   begin
if AnsiLowerCase(ExtractFileExt(sr.Name)) = '.tmp' then
 begin
        FileSetReadOnly(Dir + '\' + sr.Name, False);
        DeleteFile(Dir + '\' + sr.Name);
 end
   end
      else
        KillDir(Dir + '\' + sr.Name);
    until FindNext(sr) <> 0;
  FindClose(sr);
//  RemoveDir(Dir); // Удалит пустой каталог
  KillDir := (FileGetAttr(Dir) = -1);
end;

procedure WriteBufferStr(F : tStream; astr : widestring);
var Len : longint;
begin
  len:=length(astr);
  F.WriteBuffer(Len, SizeOf(Len));
  if Len > 0 then F.WriteBuffer(astr[1],Length(astr)*SizeOf(astr[1]));
end;

Procedure ReadBufferStr(F : tStream; out astr : String); overload;
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

Procedure ReadBufferStr(F : tStream; out astr : tfontname); overload;
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

Procedure ReadBufferStr(F : tStream; out astr : widestring); overload;
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

Procedure SaveGridToFile(FileName : string; Grid : tstringgrid);
var Stream : TFileStream;
    i, j, rw, ph : integer;
    sz, ps : longint;
    renm : string;
begin

  if FileExists(FileName) then begin
    renm := ExtractFilePath(FileName) + 'Temp.prjl';
    RenameFile(FileName,renm);
    DeleteFile(renm);
  end;
  Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
  try

  Stream.WriteBuffer(Grid.RowCount, SizeOf(integer));

  for i:=0 to grid.RowCount-1 do begin
    with (grid.Objects[0,i] as TGridRows) do begin
      Stream.WriteBuffer(i, SizeOf(integer));
      Stream.WriteBuffer(ID, SizeOf(longint));
      Stream.WriteBuffer(HeightRow, SizeOf(integer));
      Stream.WriteBuffer(HeightTitle, SizeOf(integer));
      Stream.WriteBuffer(Count, SizeOf(integer));
      for j:=0 to count-1 do begin
        Stream.WriteBuffer(j, SizeOf(integer));
        ps := ord(MyCells[j].CellType);
        Stream.WriteBuffer(ps, SizeOf(ps));
        Stream.WriteBuffer(MyCells[j].Width, SizeOf(Integer));
        Stream.WriteBuffer(MyCells[j].Procents, SizeOf(integer));
        WriteBufferStr(Stream, MyCells[j].Title);
        ps := ord(MyCells[j].TitlePosition);
        Stream.WriteBuffer(ps, SizeOf(ps));
        Stream.WriteBuffer(MyCells[j].TitleColorFont, SizeOf(TColor));
        Stream.WriteBuffer(MyCells[j].TitleFontSize, SizeOf(integer));
        WriteBufferStr(Stream, MyCells[j].TitleFontName);
        Stream.WriteBuffer(MyCells[j].TitleBold, SizeOf(boolean));
        Stream.WriteBuffer(MyCells[j].TitleItalic, SizeOf(boolean));
        Stream.WriteBuffer(MyCells[j].TitleUnderline, SizeOf(boolean));
        Stream.WriteBuffer(MyCells[j].Used, SizeOf(boolean));
        Stream.WriteBuffer(MyCells[j].Mark, SizeOf(boolean));
        Stream.WriteBuffer(MyCells[j].Select, SizeOf(boolean));
        Stream.WriteBuffer(MyCells[j].Background, SizeOf(tcolor));
        WriteBufferStr(Stream, MyCells[j].Name);
        ps := ord(MyCells[j].TypeImage);
        Stream.WriteBuffer(ps, SizeOf(ps));
        Stream.WriteBuffer(MyCells[j].ImageWidth, SizeOf(integer));
        Stream.WriteBuffer(MyCells[j].ImageHeight, SizeOf(integer));
        Stream.WriteBuffer(MyCells[j].ImageRect, SizeOf(Trect));
        ps := ord(MyCells[j].ImagePosition);
        Stream.WriteBuffer(ps, SizeOf(ps));
        ps := ord(MyCells[j].ImageLayout);
        Stream.WriteBuffer(ps, SizeOf(ps));
        WriteBufferStr(Stream, MyCells[j].ImageTrue);
        WriteBufferStr(Stream, MyCells[j].ImageFalse);
        Stream.WriteBuffer(MyCells[j].Stretch, SizeOf(boolean));
        Stream.WriteBuffer(MyCells[j].Transperent, SizeOf(boolean));
        Stream.WriteBuffer(MyCells[j].ColorTrue, SizeOf(TColor));
        Stream.WriteBuffer(MyCells[j].ColorFalse, SizeOf(TColor));
        Stream.WriteBuffer(MyCells[j].ColorPen, SizeOf(TColor));
        Stream.WriteBuffer(MyCells[j].WidthPen, SizeOf(integer));
        Stream.WriteBuffer(MyCells[j].TopPhrase, SizeOf(integer));
        Stream.WriteBuffer(MyCells[j].Interval, SizeOf(integer));
        Stream.WriteBuffer(MyCells[j].Count, SizeOf(integer));
        for rw:=0 to MyCells[j].Count-1 do begin
          Stream.WriteBuffer(rw, SizeOf(integer));
          Stream.WriteBuffer(MyCells[j].Rows[rw].Height, SizeOf(integer));
          Stream.WriteBuffer(MyCells[j].Rows[rw].Top, SizeOf(integer));
          Stream.WriteBuffer(MyCells[j].Rows[rw].Count, SizeOf(integer));
          for ph:=0 to MyCells[j].Rows[rw].Count-1 do begin
            Stream.WriteBuffer(ph, SizeOf(integer));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Left, SizeOf(integer));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Right, SizeOf(integer));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Top, SizeOf(integer));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Bottom, SizeOf(integer));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Height, SizeOf(integer));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Width, SizeOf(integer));
            ps := ord(MyCells[j].Rows[rw].Phrases[ph].Alignment);
            Stream.WriteBuffer(ps, SizeOf(ps));
            ps := ord(MyCells[j].Rows[rw].Phrases[ph].Layout);
            Stream.WriteBuffer(ps, SizeOf(ps));
            WriteBufferStr(Stream, MyCells[j].Rows[rw].Phrases[ph].Text);
            WriteBufferStr(Stream, MyCells[j].Rows[rw].Phrases[ph].Name);
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].FontColor, SizeOf(TColor));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].FontSize, SizeOf(integer));
            WriteBufferStr(Stream, MyCells[j].Rows[rw].Phrases[ph].FontName);
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Bold, SizeOf(boolean));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Italic, SizeOf(boolean));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Underline, SizeOf(boolean));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].Visible, SizeOf(boolean));
            Stream.WriteBuffer(MyCells[j].Rows[rw].Phrases[ph].leftprocent, SizeOf(integer));
          end;
        end;
      end;
    end
  end;
  finally
    FreeAndNil(Stream);
  end
end;

function SetTTypeCell(ps : longint) : TTypeCell;
begin
        case ps of
 ord(tsText) : Result := tsText;
 ord(tsState) : Result := tsState;
 ord(tsImage) : Result := tsImage;
       end;
end;

function SetTPhrasePosition(ps : longint) : TPhrasePosition;
begin
       case ps of
 ord(ppleft) : Result := ppleft;
 ord(ppcenter) : Result := ppcenter;
 ord(ppright) : Result := ppright;
 ord(ppafter) : Result := ppafter;
 ord(pptab) : Result := pptab;
       end;
end;

function SetTTypeGraphics(ps : longint) : TTypeGraphics;
begin
         case ps of
 ord(picture) : Result := picture;
 ord(ellipse) : Result := ellipse;
 ord(rectangle) : Result := rectangle;
 ord(roundrect) : Result := roundrect;
 ord(none) : Result := none;
       end;
end;

function SetTTextLayout(ps : longint) : TTextLayout;
begin
        case ps of
 ord(tlTop) : Result := tlTop;
 ord(tlCenter) : Result := tlCenter;
 ord(tlBottom) : Result := tlBottom;
       end;
end;

function LoadGridFromFile(FileName : string; Grid : tstringgrid) : boolean;
var Stream : TFileStream;
    i, j, rw, ph, pp, cnt, cnt1, cnt2 : integer;
    sz, ps : longint;
    renm : string;
    tc : TTypeCell;
begin
  result:=false;
  if not FileExists(FileName) then exit;
  Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  try
  Stream.ReadBuffer(cnt, SizeOf(integer));
  for i:=0 to grid.RowCount-1 do grid.Objects[0,i]:=nil;
  grid.RowCount:=cnt;
  for i:=0 to grid.RowCount-1 do begin
    if not (grid.Objects[0,i] is TGridRows) then grid.Objects[0,i] := TGridRows.Create;
    with (grid.Objects[0,i] as TGridRows) do begin
      Stream.ReadBuffer(pp, SizeOf(integer));
      Stream.ReadBuffer(ID, SizeOf(longint));
      Stream.ReadBuffer(HeightRow, SizeOf(integer));
      Stream.ReadBuffer(HeightTitle, SizeOf(integer));
      Stream.ReadBuffer(Count, SizeOf(integer));
      cnt:=0;
      for j:=0 to Count-1 do begin
        cnt:=cnt + 1;
        Setlength(MyCells,cnt);
        MyCells[j]:=TMyCell.Create;
        Stream.ReadBuffer(pp, SizeOf(integer));
        Stream.ReadBuffer(ps, SizeOf(ps));
        MyCells[j].CellType:= SetTTypeCell(ps);
        Stream.ReadBuffer(MyCells[j].Width, SizeOf(Integer));
        Stream.ReadBuffer(MyCells[j].Procents, SizeOf(integer));
        ReadBufferStr(Stream,MyCells[j].Title);
        Stream.ReadBuffer(ps, SizeOf(ps));
        MyCells[j].TitlePosition:= SetTPhrasePosition(ps);
        Stream.ReadBuffer(MyCells[j].TitleColorFont, SizeOf(TColor));
        Stream.ReadBuffer(MyCells[j].TitleFontSize, SizeOf(integer));
        ReadBufferStr(Stream, MyCells[j].TitleFontName);
        Stream.ReadBuffer(MyCells[j].TitleBold, SizeOf(boolean));
        Stream.ReadBuffer(MyCells[j].TitleItalic, SizeOf(boolean));
        Stream.ReadBuffer(MyCells[j].TitleUnderline, SizeOf(boolean));
        Stream.ReadBuffer(MyCells[j].Used, SizeOf(boolean));
        Stream.ReadBuffer(MyCells[j].Mark, SizeOf(boolean));
        Stream.ReadBuffer(MyCells[j].Select, SizeOf(boolean));
        Stream.ReadBuffer(MyCells[j].Background, SizeOf(tcolor));
        ReadBufferStr(Stream,MyCells[j].Name);
        Stream.ReadBuffer(ps, SizeOf(ps));
        MyCells[j].TypeImage:= SetTTypeGraphics(ps);
        Stream.ReadBuffer(MyCells[j].ImageWidth, SizeOf(integer));
        Stream.ReadBuffer(MyCells[j].ImageHeight, SizeOf(integer));
        Stream.ReadBuffer(MyCells[j].ImageRect, SizeOf(Trect));
        Stream.ReadBuffer(ps, SizeOf(ps));
        MyCells[j].ImagePosition:= SetTPhrasePosition(ps);
        Stream.ReadBuffer(ps, SizeOf(ps));
        MyCells[j].ImageLayout:= SetTTextLayout(ps);
        ReadBufferStr(Stream,MyCells[j].ImageTrue);
        ReadBufferStr(Stream,MyCells[j].ImageFalse);
        Stream.ReadBuffer(MyCells[j].Stretch, SizeOf(boolean));
        Stream.ReadBuffer(MyCells[j].Transperent, SizeOf(boolean));
        Stream.ReadBuffer(MyCells[j].ColorTrue, SizeOf(TColor));
        Stream.ReadBuffer(MyCells[j].ColorFalse, SizeOf(TColor));
        Stream.ReadBuffer(MyCells[j].ColorPen, SizeOf(TColor));
        Stream.ReadBuffer(MyCells[j].WidthPen, SizeOf(integer));
        Stream.ReadBuffer(MyCells[j].TopPhrase, SizeOf(integer));
        Stream.ReadBuffer(MyCells[j].Interval, SizeOf(integer));
        Stream.ReadBuffer(MyCells[j].Count, SizeOf(integer));
        cnt1:=0;
        for rw:=0 to MyCells[j].Count-1 do begin
          cnt1:=cnt1 + 1;
          Setlength(MyCells[j].Rows,cnt1);
          MyCells[j].Rows[rw] := TPhrasesRow.Create;
          Stream.ReadBuffer(pp, SizeOf(integer));
          Stream.ReadBuffer(MyCells[j].Rows[rw].Height, SizeOf(integer));
          Stream.ReadBuffer(MyCells[j].Rows[rw].Top, SizeOf(integer));
          Stream.ReadBuffer(MyCells[j].Rows[rw].Count, SizeOf(integer));
          cnt2:=0;
          for ph:=0 to MyCells[j].Rows[rw].Count-1 do begin
            cnt2:=cnt2+1;
            Setlength(MyCells[j].Rows[rw].Phrases,cnt2);
            MyCells[j].Rows[rw].Phrases[ph] := TCellPhrase.Create;
            Stream.ReadBuffer(pp, SizeOf(integer));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Left, SizeOf(integer));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Right, SizeOf(integer));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Top, SizeOf(integer));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Bottom, SizeOf(integer));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Height, SizeOf(integer));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Width, SizeOf(integer));
            Stream.ReadBuffer(ps, SizeOf(ps));
            MyCells[j].Rows[rw].Phrases[ph].Alignment:= SetTPhrasePosition(ps);
            Stream.ReadBuffer(ps, SizeOf(ps));
            MyCells[j].Rows[rw].Phrases[ph].Layout:= SetTPhrasePosition(ps);
            ReadBufferStr(Stream,MyCells[j].Rows[rw].Phrases[ph].Text);
            ReadBufferStr(Stream,MyCells[j].Rows[rw].Phrases[ph].Name);
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].FontColor, SizeOf(TColor));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].FontSize, SizeOf(integer));
            ReadBufferStr(Stream,MyCells[j].Rows[rw].Phrases[ph].FontName);
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Bold, SizeOf(boolean));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Italic, SizeOf(boolean));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Underline, SizeOf(boolean));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].Visible, SizeOf(boolean));
            Stream.ReadBuffer(MyCells[j].Rows[rw].Phrases[ph].leftprocent, SizeOf(integer));
          end;
        end;
      end;
    end;
  end;
  finally
    FreeAndNil(Stream);
  end;
  result:=true;
end;

Procedure SaveGridTimelinesToFile(FileName : string; grid : tstringgrid);
var Stream : TFileStream;
    i, j, rw, ph : integer;
    sz, ps : longint;
    renm : string;
begin

  if FileExists(FileName) then begin
    renm := ExtractFilePath(FileName) + 'Temp.gtls';
    RenameFile(FileName,renm);
    DeleteFile(renm);
  end;
  Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
  try
    Stream.WriteBuffer(Grid.RowCount, SizeOf(integer));
    for i:=1 to grid.RowCount-1 do begin //1
      with (grid.Objects[0,i] as TTimelineOptions) do begin
        ps := ord(TypeTL);
        Stream.WriteBuffer(ps, SizeOf(ps));
        Stream.WriteBuffer(NumberBmp, SizeOf(integer));
        WriteBufferStr(Stream,Name);
        WriteBufferStr(Stream,Name);
        Stream.WriteBuffer(IDTimeline, SizeOf(IDTimeline));
        Stream.WriteBuffer(Block, SizeOf(boolean));
        Stream.WriteBuffer(Status, SizeOf(integer));
        Stream.WriteBuffer(EventDuration, SizeOf(integer));
        Stream.WriteBuffer(CharDuration, SizeOf(integer));
        Stream.WriteBuffer(TextColor, SizeOf(tcolor));
        Stream.WriteBuffer(MediaColor, SizeOf(tcolor));
        Stream.WriteBuffer(CountDev, SizeOf(integer));
        for j:=0 to 31 do begin  //2
          Stream.WriteBuffer(DevColors[j], SizeOf(tcolor));
          WriteBufferStr(Stream,DevNames[j]);
        end; //for 2
      end; //with
    end; //for 1
  finally
    FreeAndNil(Stream);
  end;
end;

function SetTTypeTimeline(ps : longint) : TTypeTimeline;
begin
        case ps of
 ord(tldevice) : Result := tldevice;
 ord(tltext) : Result := tltext;
 ord(tlmedia) : Result := tlmedia;
       end;
end;

Procedure LoadGridTimelinesFromFile(FileName : string; grid : tstringgrid);
var Stream : TFileStream;
    i, j, rw, ph, cnt, cnt1 : integer;
    sz, ps : longint;
    renm : string;
begin

  if not FileExists(FileName) then exit;
  Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  try
  Stream.ReadBuffer(cnt, SizeOf(integer));
  for i:=1 to grid.RowCount-1 do grid.Objects[0,i]:=nil;
  grid.RowCount:=cnt;
  for i:=1 to grid.RowCount-1 do begin
  if not (grid.Objects[0,i] is TTimelineOptions) then grid.Objects[0,i] := TTimelineOptions.Create; //if 1
    with (grid.Objects[0,i] as TTimelineOptions) do begin
      Stream.ReadBuffer(ps, SizeOf(ps));
      TypeTL := SetTTypeTimeline(ps);
      Stream.ReadBuffer(NumberBmp, SizeOf(integer));
      ReadBufferStr(Stream,Name);
      ReadBufferStr(Stream,Name);
      Stream.ReadBuffer(IDTimeline, SizeOf(IDTimeline));
      Stream.ReadBuffer(Block, SizeOf(boolean));
      Stream.ReadBuffer(Status, SizeOf(integer));
      Stream.ReadBuffer(EventDuration, SizeOf(integer));
      Stream.ReadBuffer(CharDuration, SizeOf(integer));
      Stream.ReadBuffer(TextColor, SizeOf(tcolor));
      Stream.ReadBuffer(MediaColor, SizeOf(tcolor));
      Stream.ReadBuffer(CountDev, SizeOf(integer));
      for j:=0 to 31 do begin  //2
        Stream.ReadBuffer(DevColors[j], SizeOf(tcolor));
        ReadBufferStr(Stream,DevNames[j]);
      end; //for 2
    end; //with
  end; //if 1
  finally
    FreeAndNil(Stream);
  end;
end;

procedure SaveClipEventsToDisk(FileName : string);
var Stream : TFileStream;
    //FileName : string;
    i, j, rw, ph : integer;
    sz, ps : longint;
    renm : string;
    name : string;
begin
  name := PathEvents + '\' + FileName + '.evns';
  if FileExists(name) then begin
    renm := PathEvents + '\' + 'Temp.evns';
    RenameFile(name,renm);
    DeleteFile(renm);
  end;
  Stream := TFileStream.Create(name, fmCreate or fmShareDenyNone);
  try
    Stream.WriteBuffer(TLZone.Count, SizeOf(integer));
    For i := 0 to TLZone.Count-1 do begin //For 1
      Stream.WriteBuffer(TLZone.Timelines[i].IDTimeline, SizeOf(TLZone.Timelines[i].IDTimeline));
      sz:=ord(TLZone.Timelines[i].TypeTL);
      Stream.WriteBuffer(sz, SizeOf(integer));
      Stream.WriteBuffer(TLZone.Timelines[i].Count, SizeOf(integer));
      with TLZone.Timelines[i] do begin //With 1
        For j := 0 to Count-1 do begin //For 2
          Stream.WriteBuffer(Events[j].IDEvent, SizeOf(Events[j].IDEvent));
          Stream.WriteBuffer(Events[j].Color, SizeOf(TColor));
          Stream.WriteBuffer(Events[j].FontColor, SizeOf(TColor));
          Stream.WriteBuffer(Events[j].FontSize, SizeOf(integer));
          Stream.WriteBuffer(Events[j].FontSizeSub, SizeOf(integer));
          WriteBufferStr(Stream, Events[j].FontName);
          Stream.WriteBuffer(Events[j].SafeZone, SizeOf(integer));
          Stream.WriteBuffer(Events[j].Transition, SizeOf(integer));
          Stream.WriteBuffer(Events[j].Editing, SizeOf(boolean));
          Stream.WriteBuffer(Events[j].Select, SizeOf(boolean));
          WriteBufferStr(Stream, Events[j].Discription);
          Stream.WriteBuffer(Events[j].Start, SizeOf(Events[j].Start));
          Stream.WriteBuffer(Events[j].Finish, SizeOf(Events[j].Finish));
          Stream.WriteBuffer(Events[j].Count, SizeOf(integer));
          with Events[j] do begin //With 2
            For rw:=0 to Events[j].Count-1 do begin //For 3
              Stream.WriteBuffer(Rows[rw].Top, SizeOf(integer));
              Stream.WriteBuffer(Rows[rw].Bottom, SizeOf(integer));
             //Rows[rw].Procent : integer;
              Stream.WriteBuffer(Rows[rw].Count, SizeOf(integer));
              with Rows[rw] do begin //With 3
                for ph:=0 to Rows[rw].Count-1 do begin //For 4
                  WriteBufferStr(Stream, Phrases[ph].name);
                  WriteBufferStr(Stream, Phrases[ph].Text);
                  Stream.WriteBuffer(Phrases[ph].data, SizeOf(Phrases[ph].data));
                  WriteBufferStr(Stream, Phrases[ph].Command);
                  Stream.WriteBuffer(Phrases[ph].Tag, SizeOf(integer));
                  Stream.WriteBuffer(Phrases[ph].Rect.Left, SizeOf(integer));
                  Stream.WriteBuffer(Phrases[ph].Rect.Top, SizeOf(integer));
                  Stream.WriteBuffer(Phrases[ph].Rect.Right, SizeOf(integer));
                  Stream.WriteBuffer(Phrases[ph].Rect.Bottom, SizeOf(integer));
                  Stream.WriteBuffer(Phrases[ph].Select, SizeOf(Phrases[ph].Select));
                  WriteBufferStr(Stream, Phrases[ph].workdata);
                  Stream.WriteBuffer(Phrases[ph].maxlength, SizeOf(integer));
                  Stream.WriteBuffer(Phrases[ph].visible, SizeOf(Phrases[ph].visible));
                end; //For 4
              end; //With 3
            end; //For 3
          end; //With 2
        end; //For 2
      end; //With 1
    end; //For 1
  finally
    FreeAndNil(Stream);
  end;
end;

procedure LoadClipEventsFromDisk(FileName : string);
var Stream : TFileStream;
    i, j, rw, ph, cnt, cnt1, rtl : integer;
    sz, ps, idtl : longint;
    tptl : ttypetimeline;
    renm : string;
begin
  if not FileExists(FileName) then exit;
  Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  try
    TLZone.ClearTimeline;
    TLZone.Count:=Form1.GridTimeLines.RowCount-1;
    For i:=0 to TLZone.Count-1 do begin
      Setlength(TLZone.Timelines,i+1);
      TLZone.Timelines[i] := TTLTimeline.Create;
      if Form1.GridTimeLines.Objects[0,i+1] is TTimelineOptions then begin
        TLZone.Timelines[i].IDTimeline := (Form1.GridTimeLines.Objects[0,i+1] as TTimelineOptions).IDTimeline;
        TLZone.Timelines[i].TypeTL := (Form1.GridTimeLines.Objects[0,i+1] as TTimelineOptions).TypeTL;
      end;
    end;

    Stream.ReadBuffer(cnt, SizeOf(integer));
    For i := 0 to cnt-1 do begin //For 1

      Stream.ReadBuffer(idtl, SizeOf(idtl));
      Stream.ReadBuffer(sz, SizeOf(sz));
      tptl := SetTTypeTimeline(sz);

      rtl := -1;
      for j:=0 to cnt do begin
        if (TLZone.Timelines[j].IDTimeline=idtl) and (TLZone.Timelines[j].TypeTL=tptl) then begin
          rtl:=j;
          break;
        end;
      end;
      if rtl=-1 then continue;

      TLZone.Timelines[rtl].IDTimeline:=idtl;
      TLZone.Timelines[rtl].TypeTL := tptl;

      Stream.ReadBuffer(TLZone.Timelines[rtl].Count, SizeOf(integer));
      with TLZone.Timelines[rtl] do begin //With 1
        For j := 0 to Count-1 do begin //For 2
          Stream.ReadBuffer(Events[j].IDEvent, SizeOf(Events[j].IDEvent));
          Stream.ReadBuffer(Events[j].Color, SizeOf(TColor));
          Stream.ReadBuffer(Events[j].FontColor, SizeOf(TColor));
          Stream.ReadBuffer(Events[j].FontSize, SizeOf(integer));
          Stream.ReadBuffer(Events[j].FontSizeSub, SizeOf(integer));
          ReadBufferStr(Stream, Events[j].FontName);
          Stream.ReadBuffer(Events[j].SafeZone, SizeOf(integer));
          Stream.ReadBuffer(Events[j].Transition, SizeOf(integer));
          Stream.ReadBuffer(Events[j].Editing, SizeOf(boolean));
          Stream.ReadBuffer(Events[j].Select, SizeOf(boolean));
          ReadBufferStr(Stream, Events[j].Discription);
          Stream.ReadBuffer(Events[j].Start, SizeOf(Events[j].Start));
          Stream.ReadBuffer(Events[j].Finish, SizeOf(Events[j].Finish));
          Stream.ReadBuffer(Events[j].Count, SizeOf(integer));
          with Events[j] do begin //With 2
            For rw:=0 to Events[j].Count-1 do begin //For 3
              Stream.ReadBuffer(Rows[rw].Top, SizeOf(integer));
              Stream.ReadBuffer(Rows[rw].Bottom, SizeOf(integer));
             //Rows[rw].Procent : integer;
              Stream.ReadBuffer(Rows[rw].Count, SizeOf(integer));
              with Rows[rw] do begin //With 3
                for ph:=0 to Rows[rw].Count-1 do begin //For 4
                  ReadBufferStr(Stream, Phrases[ph].name);
                  ReadBufferStr(Stream, Phrases[ph].Text);
                  Stream.ReadBuffer(Phrases[ph].data, SizeOf(Phrases[ph].data));
                  ReadBufferStr(Stream, Phrases[ph].Command);
                  Stream.ReadBuffer(Phrases[ph].Tag, SizeOf(integer));
                  Stream.ReadBuffer(Phrases[ph].Rect.Left, SizeOf(integer));
                  Stream.ReadBuffer(Phrases[ph].Rect.Top, SizeOf(integer));
                  Stream.ReadBuffer(Phrases[ph].Rect.Right, SizeOf(integer));
                  Stream.ReadBuffer(Phrases[ph].Rect.Bottom, SizeOf(integer));
                  Stream.ReadBuffer(Phrases[ph].Select, SizeOf(Phrases[ph].Select));
                  ReadBufferStr(Stream, Phrases[ph].workdata);
                  Stream.ReadBuffer(Phrases[ph].maxlength, SizeOf(integer));
                  Stream.ReadBuffer(Phrases[ph].visible, SizeOf(Phrases[ph].visible));
                end; //For 4
              end; //With 3
            end; //For 3
          end; //With 2
        end; //For 2
      end; //With 1
    end; //For 1
  finally
    FreeAndNil(Stream);
  end;
end;

Procedure SaveProjectToDisk(ProjectName : string);
var Streamp : TFileStream;
    FileName : string;
    i, j, rw, ph : integer;
    sz, ps : longint;
    renm : string;
    name : string;
begin
  name :=  StringReplace(ProjectName, 'PROJECT', '', [rfReplaceAll, rfIgnoreCase]);
  name :=  StringReplace(name, '.prjt', '', [rfReplaceAll, rfIgnoreCase]);

  if FileExists(AppPath + DirProjects + '\' + ProjectName) then begin
    renm := AppPath + DirProjects + '\'  + 'Temp.prjt';
    RenameFile(ProjectName,renm);
    DeleteFile(renm);
  end;
  Streamp := TFileStream.Create(AppPath + DirProjects + '\' + ProjectName, fmCreate or fmShareDenyNone);
  try
    if Trim(TempTimelines)='' then begin
      Filename:= 'TL' + name + '.gtls';
      TempTimelines := Filename;
    end else Filename :=TempTimelines;
    SaveGridTimelinesToFile(AppPath + DirProjects + '\' + Filename, Form1.GridTimeLines);
    WriteBufferStr(Streamp,Filename);

    FileName :=  'PL' + name + '.gpls';
    if FileExists(AppPath + DirProjects + '\' + Filename)
       then DeleteFile(AppPath + DirProjects + '\' + Filename);
    if FileExists(AppPath + DirProjects + '\' + TempPlayLists)
       then CopyFile(PAnsiChar(AppPath + DirProjects + '\' + TempPlayLists), PAnsiChar(AppPath + DirProjects + '\' + Filename), true);
    WriteBufferStr(Streamp,Filename);

    FileName :=  'TXT' + name + '.ttmp';
    if FileExists(AppPath + DirProjects + '\' + Filename)
       then DeleteFile(AppPath + DirProjects + '\' + Filename);
    if FileExists(AppPath + DirProjects + '\' + TempTextTemplates)
       then CopyFile(PAnsiChar(AppPath + DirProjects + '\' + TempTextTemplates), PAnsiChar(AppPath + DirProjects + '\' + Filename), true);
    WriteBufferStr(Streamp,Filename);

    FileName :=  'GR' + name + '.gtmp';
    if FileExists(AppPath + DirProjects + '\' + Filename)
       then DeleteFile(AppPath + DirProjects + '\' + Filename);
    if FileExists(AppPath + DirProjects + '\' + TempGrTemplates)
       then CopyFile(PAnsiChar(AppPath + DirProjects + '\' + TempGRTemplates), PAnsiChar(AppPath + DirProjects + '\' + Filename), true);
    WriteBufferStr(Streamp,Filename);

    FileName :=  'CLIP' + name + '.clps';
    if FileExists(AppPath + DirProjects + '\' + Filename)
       then DeleteFile(AppPath + DirProjects + '\' + Filename);
    if FileExists(AppPath + DirProjects + '\' + TempClipsLists)
       then CopyFile(PAnsiChar(AppPath + DirProjects + '\' + TempClipsLists), PAnsiChar(AppPath + DirProjects + '\' + Filename), true);
    WriteBufferStr(Streamp,Filename);

  finally
    FreeAndNil(Streamp);
  end;
end;

Procedure LoadProjectFromDisk(ProjectName : string);
var Streamp : TFileStream;
    FileName : string;
    i, j, rw, ph : integer;
    sz, ps : longint;
    renm : string;
    name : string;
begin

  if not FileExists(AppPath + DirProjects + '\' + ProjectName) then exit;
  Streamp := TFileStream.Create(AppPath + DirProjects + '\' + ProjectName, fmOpenReadWrite or fmShareDenyNone);
  try
    ReadBufferStr(Streamp,Filename);
    TempTimelines := Filename;
    if trim(Filename) <> '' then LoadGridTimelinesFromFile(AppPath + DirProjects + '\' + Filename, Form1.GridTimeLines);

    ReadBufferStr(Streamp,Filename);
    name :=  StringReplace(Filename, 'PL', '', [rfReplaceAll]);
    name := 'TMP' + name;
    if FileExists(AppPath + DirProjects + '\' + name)
       then DeleteFile(AppPath + DirProjects + '\' + name);
    if FileExists(AppPath + DirProjects + '\' + Filename)
       then CopyFile(PAnsiChar(AppPath + DirProjects + '\' + Filename), PAnsiChar(AppPath + DirProjects + '\' + name), true);
    TempPlayLists := name;

    ReadBufferStr(Streamp,Filename);
    name :=  StringReplace(Filename, 'TXT', '', [rfReplaceAll, rfIgnoreCase]);
    name := 'TMP' + name;
    if FileExists(AppPath + DirProjects + '\' + name)
       then DeleteFile(AppPath + DirProjects + '\' + name);
    if FileExists(AppPath + DirProjects + '\' + Filename)
       then CopyFile(PAnsiChar(AppPath + DirProjects + '\' + Filename), PAnsiChar(AppPath + DirProjects + '\' + name), true);
    TempTextTemplates := name;

    ReadBufferStr(Streamp,Filename);
    name :=  StringReplace(Filename, 'GR', '', [rfReplaceAll, rfIgnoreCase]);
    name := 'TMP' + name;
    if FileExists(AppPath + DirProjects + '\' + name)
       then DeleteFile(AppPath + DirProjects + '\' + name);
    if FileExists(AppPath + DirProjects + '\' + Filename)
       then CopyFile(PAnsiChar(AppPath + DirProjects + '\' + Filename), PAnsiChar(AppPath + DirProjects + '\' + name), true);
    TempGRTemplates := name;

    ReadBufferStr(Streamp,Filename);
    name :=  StringReplace(Filename, 'CLIP', '', [rfReplaceAll, rfIgnoreCase]);
    name := 'TMP' + name;
    if FileExists(AppPath + DirProjects + '\' + name)
       then DeleteFile(AppPath + DirProjects + '\' + name);
    if FileExists(AppPath + DirProjects + '\' + Filename)
       then CopyFile(PAnsiChar(AppPath + DirProjects + '\' + Filename), PAnsiChar(AppPath + DirProjects + '\' + name), true);
    TempClipsLists := name;

  finally
    FreeAndNil(Streamp);
  end;
end;

end.
