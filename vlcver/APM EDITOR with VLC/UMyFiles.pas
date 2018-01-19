unit UMyFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer,  MMSystem;

Procedure SaveGridToFile(FileName : string; Grid : tstringgrid);
function LoadGridFromFile(FileName : string; Grid : tstringgrid) : boolean;
Procedure LoadProjectFromDisk;
Procedure SaveProjectToDisk;
procedure DeleteFilesMask (Dir: AnsiString; Mask : string);
procedure WriteBufferStr(F : tStream; astr : widestring);
Procedure ReadBufferStr(F : tStream; out astr : String); overload;
Procedure ReadBufferStr(F : tStream; out astr : tfontname); overload;
Procedure ReadBufferStr(F : tStream; out astr : widestring); overload;
function LoadClipEditingFromFile(ClipName : string) : boolean;
Procedure SaveClipEditingToFile(ClipName : string);
function KillDir (Directory : String): boolean;
function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders,
  StopIfNotAllDeleted, RemoveRoot: boolean): Boolean;
function FullDirectoryCopy(SourceDir, TargetDir: string; StopIfNotAllCopied,
  OverWriteFiles: Boolean): Boolean;
procedure  SetTaskOnDelete(prj : string);
procedure ExecTaskOnDelete;

//var Stream : TFileStream;

implementation

uses umain, ucommon, ugrid, utimeline, UGRTimelines, udrawtimelines;

procedure ExecTaskOnDelete;
var lst : tstrings;
    i : integer;
    s : string;
begin
  if FileExists(AppPath+DirProjects + '\List.tsk') then begin
    lst := tstringlist.Create;
    lst.Clear;
    try
      lst.LoadFromFile(AppPath+DirProjects + '\List.tsk');
      for i:=lst.Count-1 downto 0 do begin
        s:=AppPath+DirProjects + '\' + trim(lst.Strings[i]);
        if DirectoryExists(s)
          then begin if KillDir(s) then lst.Delete(i); end
          else lst.Delete(i);
      end;
      if lst.Count<=0 then SysUtils.DeleteFile(AppPath+DirProjects + '\List.tsk')
      else lst.SaveToFile(AppPath+DirProjects + '\List.tsk');
    finally
      lst.Free;
    end;
  end;
end;

procedure  SetTaskOnDelete(prj : string);
var lst : tstrings;
begin
   lst := tstringlist.Create;
   lst.Clear;
   try
    if FileExists(AppPath+DirProjects + '\List.tsk') then lst.LoadFromFile(AppPath+DirProjects + '\List.tsk');
    if trim(prj)<>'' then lst.Add(Trim(prj));
    DeleteFile(AppPath+DirProjects + '\List.tsk');
    lst.SaveToFile(AppPath+DirProjects + '\List.tsk');
   finally
     lst.Free;
   end;
end;

function FullDirectoryCopy(SourceDir, TargetDir: string; StopIfNotAllCopied,
  OverWriteFiles: Boolean): Boolean;
var
  SR: TSearchRec;
  I: Integer;
begin
  Result := False;
  SourceDir := IncludeTrailingBackslash(SourceDir);
  TargetDir := IncludeTrailingBackslash(TargetDir);
  if not DirectoryExists(SourceDir) then
    Exit;
  if not ForceDirectories(TargetDir) then
    Exit;

  I := FindFirst(SourceDir + '*', faAnyFile, SR);
  try
    while I = 0 do
    begin
      if (SR.Name <> '') and (SR.Name <> '.') and (SR.Name <> '..') then
      begin
        if SR.Attr = faDirectory then
          Result := FullDirectoryCopy(SourceDir + SR.Name, TargetDir + SR.NAME,
            StopIfNotAllCopied, OverWriteFiles)
        else if not (not OverWriteFiles and FileExists(TargetDir + SR.Name))
          then
          Result := CopyFile(Pchar(SourceDir + SR.Name), Pchar(TargetDir +
            SR.Name), False)
        else
          Result := True;
        if not Result and StopIfNotAllCopied then
          exit;
      end;
      I := FindNext(SR);
    end;
  finally
    SysUtils.FindClose(SR);
  end;
end;

function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders,
  StopIfNotAllDeleted, RemoveRoot: boolean): Boolean;
var
  i: Integer;
  SRec: TSearchRec;
  FN: string;
begin
  Result := False;
  if not DirectoryExists(Dir) then
    exit;
  Result := True;
  // Удаляем слеш и задаем маску все файлы в директории
  Dir := IncludeTrailingBackslash(Dir);
  i := FindFirst(Dir + '*', faAnyFile, SRec);
  try
    while i = 0 do
    begin
      // Получаем полный путь к файлу или директории
      FN := Dir + SRec.Name;
      // если это директория
      if SRec.Attr = faDirectory then
      begin
        // рекурсивный вызов этой же функции с ключом удаления корня
        if (SRec.Name <> '') and (SRec.Name <> '.') and (SRec.Name <> '..') then  begin
          if DeleteAllFilesAndFolders then
            FileSetAttr(FN, faArchive);
          Result := FullRemoveDir(FN, DeleteAllFilesAndFolders,
            StopIfNotAllDeleted, True);
          if not Result and StopIfNotAllDeleted then
            exit;
        end;
      end else begin
        if DeleteAllFilesAndFolders then
          FileSetAttr(FN, faArchive);
        Result := SysUtils.DeleteFile(FN);
        if not Result and StopIfNotAllDeleted then
          exit;
      end;
      // берем следующий файл или директорию
      i := FindNext(SRec);
    end;
  finally
    SysUtils.FindClose(SRec);
  end;
  if not Result then
    exit;
  if RemoveRoot then // если необходимо удалить корень удаляем
    if not RemoveDir(Dir) then
      Result := false;
end;

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

function KillDir (Directory : String): boolean;
var
  Sr: SysUtils.TSearchRec;
  Dir : AnsiString;
begin
{$I-}
  Dir := PAnsiChar(Directory);
  if (Dir <> '') and (Dir[length(Dir)] = '\') then
    Delete(Dir, length(dir), 1);
    if FindFirst(Dir + '\*.*', faDirectory + faHidden + faSysFile + faReadonly + faArchive, Sr) = 0
    then repeat
      if (Sr.Name = '.') or (Sr.Name = '..') then continue;
      if (Sr.Attr and faDirectory <> faDirectory) then begin
        FileSetReadOnly(Dir + '\' + sr.Name, False);
        DeleteFile(Dir + '\' + sr.Name);
      end else KillDir(Dir + '\' + sr.Name);
    until FindNext(sr) <> 0;
  FindClose(sr);
  RemoveDir(Dir); // Удалит пустой каталог
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

Procedure SaveClipEditingToFile(ClipName : string);
var Stream : TFileStream;
    renm, FileName : string;
    i : integer;
begin
  FileName:=PathClips + '\' + ClipName + '.Clip';
  if FileExists(FileName) then begin
    renm := ExtractFilePath(FileName) + 'Temp.Clip';
    RenameFile(FileName,renm);
    DeleteFile(renm);
  end;
  Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
  try
  TLParameters.WriteToStream(Stream);
  TLHeights.WriteToStream(Stream);
  //Stream.WriteBuffer(Form1.GridTimeLines.RowCount, SizeOf(integer));
  //for i:=1 to Form1.GridTimeLines.RowCount-1
  //  do (Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).WriteToStream(Stream);
  ZoneNames.WriteToStream(Stream);
  TLZone.WriteToStream(Stream);
  finally
    FreeAndNil(Stream);
  end
end;

function LoadClipEditingFromFile(ClipName : string) : boolean;
var Stream : TFileStream;
    renm, FileName : string;
    i, cnt: integer;
begin
  result := false;
  FileName:=PathClips + '\' + ClipName + '.Clip';
  if not FileExists(FileName) then exit;
  Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  try
  TLParameters.ReadFromStream(Stream);
  TLHeights.ReadFromStream(Stream);
 // Stream.ReadBuffer(cnt, SizeOf(integer));
 // if cnt < Form1.GridTimeLines.RowCount then begin
 //   For i:= Form1.GridTimeLines.RowCount - 1 to cnt-1
 //      do Form1.GridTimeLines.Objects[0,i]:=nil;
 // end;
 // Form1.GridTimeLines.RowCount:=cnt;
 // For i:=1 to Form1.GridTimeLines.RowCount-1 do begin
 //   if not (Form1.GridTimeLines.Objects[0,i] is TTimelineOptions)
 //     then Form1.GridTimeLines.Objects[0,i] := TTimelineOptions.Create;
 //   (Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).ReadFromStream(Stream);
 // end;

  ZoneNames.ReadFromStream(Stream);
  TLZone.ReadFromStream(Stream);
  result:=true;
  finally
    FreeAndNil(Stream);
  end
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
    for i:=0 to grid.RowCount-1 do (grid.Objects[0,i] as TGridRows).WriteToStream(Stream);
  finally
    FreeAndNil(Stream);
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
    (grid.Objects[0,i] as TGridRows).ReadFromStream(Stream);
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
  try
  if FileExists(FileName) then begin
    renm := ExtractFilePath(FileName) + 'Temp.gtls';
    RenameFile(FileName,renm);
    DeleteFile(renm);
  end;
  Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
  try
    Stream.WriteBuffer(Grid.RowCount, SizeOf(integer));
    for i:=1 to grid.RowCount-1 do (grid.Objects[0,i] as TTimelineOptions).WriteToStream(Stream);
  finally
    FreeAndNil(Stream);
  end;
  except
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
    grid.Objects[0,i] := TTimelineOptions.Create;
    (grid.Objects[0,i] as TTimelineOptions).ReadFromStream(Stream);
  end;
  finally
    FreeAndNil(Stream);
  end;
end;

Procedure SaveProjectToDisk;
var Streamp : TFileStream;
    FileName : string;
    i, j, rw, ph : integer;
    sz, ps : longint;
    renm : string;
    name : string;
begin
  if not directoryexists(PathLists) then exit;

  Filename:= PathLists + '\Timelines.lst';
  if FileExists(FileName) then begin
    renm := PathLists + '\Temp.tlls';
    RenameFile(FileName,renm);
    DeleteFile(renm);
  end;
  SaveGridTimelinesToFile(Filename, Form1.GridTimeLines);

  if FileExists(PathTemp + '\PlayLists.lst') then begin
     if FileExists(PathLists + '\PlayLists.lst') then begin
      renm := PathLists + '\Temp.plls';
      RenameFile(PathLists + '\PlayLists.lst',renm);
      DeleteFile(renm);
     end;
     if FileExists(PathTemp + '\PlayLists.lst')
       then CopyFile(PAnsiChar(PathTemp + '\PlayLists.lst'), PAnsiChar(PathLists + '\PlayLists.lst'), true);
  end;

  if FileExists(PathTemp + '\ImageTemplates.lst') then begin
     if FileExists(PathLists + '\ImageTemplates.lst') then begin
      renm := PathLists + '\Temp.tmgr';
      RenameFile(PathLists + '\ImageTemplates.lst',renm);
      DeleteFile(renm);
     end;
     if FileExists(PathTemp + '\ImageTemplates.lst')
       then CopyFile(PAnsiChar(PathTemp + '\ImageTemplates.lst'), PAnsiChar(PathLists + '\ImageTemplates.lst'), true);
  end;

  if FileExists(PathTemp + '\TextTemplates.lst') then begin
     if FileExists(PathLists + '\TextTemplates.lst') then begin
      renm := PathLists + '\Temp.tmtx';
      RenameFile(PathLists + '\TextTemplates.lst',renm);
      DeleteFile(renm);
     end;
     if FileExists(PathTemp + '\TextTemplates.lst')
       then CopyFile(PAnsiChar(PathTemp + '\TextTemplates.lst'), PAnsiChar(PathLists + '\TextTemplates.lst'), true);
  end;

  if FileExists(PathTemp + '\Clips.lst') then begin
     if FileExists(PathLists + '\Clips.lst') then begin
      renm := PathLists + '\Temp.clps';
      RenameFile(PathLists + '\Clips.lst',renm);
      DeleteFile(renm);
     end;
     if FileExists(PathTemp + '\Clips.lst')
       then CopyFile(PAnsiChar(PathTemp + '\Clips.lst'), PAnsiChar(PathLists + '\Clips.lst'), true);
  end;
end;

Procedure LoadProjectFromDisk;
var Streamp : TFileStream;
    FileName : string;
    i, j, rw, ph : integer;
    sz, ps : longint;
    renm : string;
    name : string;
begin
    if Trim(ProjectNumber)='' then exit;
    CreateDirectories(ProjectNumber);

    DeleteFilesMask(pathproject, '*.*');

    if FileExists(pathlists + '\Timelines.lst') then LoadGridTimelinesFromFile(pathlists + '\Timelines.lst', Form1.GridTimeLines);

    if FileExists(pathlists + '\PlayLists.lst')
       then CopyFile(PAnsiChar(pathlists + '\PlayLists.lst'), PAnsiChar(pathtemp + '\PlayLists.lst'), true);

    if FileExists(pathlists + '\ImageTemplates.lst')
       then CopyFile(PAnsiChar(pathlists + '\ImageTemplates.lst'), PAnsiChar(pathtemp + '\ImageTemplates.lst'), true);

    if FileExists(pathlists + '\TextTemplates.lst')
       then CopyFile(PAnsiChar(pathlists + '\TextTemplates.lst'), PAnsiChar(pathtemp + '\TextTemplates.lst'), true);

    if FileExists(pathlists + '\Clips.lst')
       then CopyFile(PAnsiChar(pathlists + '\Clips.lst'), PAnsiChar(pathtemp + '\Clips.lst'), true);
end;

end.
