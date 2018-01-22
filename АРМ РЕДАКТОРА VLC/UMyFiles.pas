unit UMyFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, AppEvnts,
  DirectShow9, ActiveX, UPlayer, UHRTimer, MMSystem;

Procedure SaveGridToFile(FileName: string; Grid: tstringgrid);
function LoadGridFromFile(FileName: string; Grid: tstringgrid): boolean;
Procedure LoadProjectFromDisk;
Procedure SaveProjectToDisk;
procedure DeleteFilesMask(Dir: AnsiString; Mask: string);
procedure WriteBufferStr(F: tStream; astr: widestring);
Procedure ReadBufferStr(F: tStream; out astr: String); overload;
Procedure ReadBufferStr(F: tStream; out astr: tfontname); overload;
Procedure ReadBufferStr(F: tStream; out astr: widestring); overload;
function LoadClipEditingFromFile(ClipName: string): boolean;
Procedure SaveClipEditingToFile(ClipName: string);
function KillDir(Directory: String): boolean;
function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders,
  StopIfNotAllDeleted, RemoveRoot: boolean): boolean;
function FullDirectoryCopy(SourceDir, TargetDir: string;
  StopIfNotAllCopied, OverWriteFiles: boolean): boolean;
procedure SetTaskOnDelete(prj: string);
procedure ExecTaskOnDelete;
Procedure LoadGridTimelinesFromFile(FileName: string; Grid: tstringgrid);
procedure WriteLog(FileName: string; log: widestring);

// var Stream : TFileStream;

implementation

uses umain, ucommon, ugrid, utimeline, UGRTimelines, udrawtimelines;

procedure ExecTaskOnDelete;
var
  lst: tstrings;
  i: integer;
  s: string;
begin
  try
    WriteLog('MAIN', 'UMyFiles.ExecTaskOnDelete');
    if FileExists(AppPath + DirProjects + '\List.tsk') then
    begin
      lst := tstringlist.Create;
      lst.Clear;
      try
        lst.LoadFromFile(AppPath + DirProjects + '\List.tsk');
        for i := lst.Count - 1 downto 0 do
        begin
          s := AppPath + DirProjects + '\' + trim(lst.Strings[i]);
          if DirectoryExists(s) then
          begin
            if KillDir(s) then
            begin
              lst.Delete(i);
              WriteLog('MAIN', 'UMyFiles.ExecTaskOnDelete KillDir ' + s);
            end;
          end
          else
          begin
            lst.Delete(i);
          end;
        end;
        if lst.Count <= 0 then
        begin
          SysUtils.DeleteFile(AppPath + DirProjects + '\List.tsk');
          WriteLog('MAIN', 'UMyFiles.ExecTaskOnDelete - Все задачи выполнены');
        end
        else
        begin
          lst.SaveToFile(AppPath + DirProjects + '\List.tsk');
          WriteLog('MAIN',
            'UMyFiles.ExecTaskOnDelete - Не все задачи выполнены');
        end;
      finally
        lst.Free;
      end;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.ExecTaskOnDelete | ' + E.Message);
  end;
end;

procedure SetTaskOnDelete(prj: string);
var
  lst: tstrings;
begin
  try
    WriteLog('MAIN', 'UMyFiles.SetTaskOnDelete Task=' + prj);
    lst := tstringlist.Create;
    lst.Clear;
    try
      if FileExists(AppPath + DirProjects + '\List.tsk') then
        lst.LoadFromFile(AppPath + DirProjects + '\List.tsk');
      if trim(prj) <> '' then
        lst.Add(trim(prj));
      DeleteFile(AppPath + DirProjects + '\List.tsk');
      lst.SaveToFile(AppPath + DirProjects + '\List.tsk');
    finally
      lst.Free;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.SetTaskOnDelete Task=' + prj + ' | ' +
        E.Message);
  end;
end;

function FullDirectoryCopy(SourceDir, TargetDir: string;
  StopIfNotAllCopied, OverWriteFiles: boolean): boolean;
var
  SR: TSearchRec;
  i: integer;
begin
  try
    WriteLog('MAIN', 'UMyFiles.FullDirectoryCopy SDir=' + SourceDir + ' TDir=' +
      TargetDir);
    Result := False;
    SourceDir := IncludeTrailingBackslash(SourceDir);
    TargetDir := IncludeTrailingBackslash(TargetDir);
    if not DirectoryExists(SourceDir) then
      Exit;
    if not ForceDirectories(TargetDir) then
      Exit;

    i := FindFirst(SourceDir + '*', faAnyFile, SR);
    try
      while i = 0 do
      begin
        if (SR.Name <> '') and (SR.Name <> '.') and (SR.Name <> '..') then
        begin
          if SR.Attr = faDirectory then
          begin
            Result := FullDirectoryCopy(SourceDir + SR.Name,
              TargetDir + SR.Name, StopIfNotAllCopied, OverWriteFiles)
          end
          else
          begin
            if not(not OverWriteFiles and FileExists(TargetDir + SR.Name)) then
            begin
              Result := CopyFile(Pchar(SourceDir + SR.Name),
                Pchar(TargetDir + SR.Name), False);
              if Result then
                WriteLog('MAIN', 'UMyFiles.FullDirectoryCopy File SFile=' +
                  SourceDir + SR.Name + ' TFile=' + TargetDir + SR.Name);
            end
            else
            begin
              Result := True;
            end;
          end;
          if not Result and StopIfNotAllCopied then
            Exit;
        end;
        i := FindNext(SR);
      end;
    finally
      SysUtils.FindClose(SR);
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.FullDirectoryCopy SDir=' + SourceDir + ' TDir='
        + TargetDir + ' | ' + E.Message);
  end;
end;

function FullRemoveDir(Dir: string; DeleteAllFilesAndFolders,
  StopIfNotAllDeleted, RemoveRoot: boolean): boolean;
var
  i: integer;
  SRec: TSearchRec;
  FN: string;
begin
  try
    WriteLog('MAIN', 'UMyFiles.FullRemoveDir Dir=' + Dir);
    Result := False;
    if not DirectoryExists(Dir) then
      Exit;
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
          if (SRec.Name <> '') and (SRec.Name <> '.') and (SRec.Name <> '..')
          then
          begin
            if DeleteAllFilesAndFolders then
              FileSetAttr(FN, faArchive);
            Result := FullRemoveDir(FN, DeleteAllFilesAndFolders,
              StopIfNotAllDeleted, True);
            if not Result and StopIfNotAllDeleted then
              Exit;
          end;
        end
        else
        begin
          if DeleteAllFilesAndFolders then
            FileSetAttr(FN, faArchive);
          Result := SysUtils.DeleteFile(FN);
          if Result then
            WriteLog('MAIN', 'UMyFiles.FullRemoveDir Delete File: ' + FN);
          if not Result and StopIfNotAllDeleted then
            Exit;
        end;
        // берем следующий файл или директорию
        i := FindNext(SRec);
      end;
    finally
      SysUtils.FindClose(SRec);
    end;
    if not Result then
      Exit;
    if RemoveRoot then
    begin // если необходимо удалить корень удаляем
      if not RemoveDir(Dir) then
        Result := False
      else
        WriteLog('MAIN', 'UMyFiles.FullRemoveDir Delete Dir: ' + Dir);;
    end;
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.FullRemoveDir Dir=' + Dir + ' | ' + E.Message);
  end;
end;

procedure DeleteFilesMask(Dir: AnsiString; Mask: string);
var
  SR: SysUtils.TSearchRec;
begin
{$I-}
  try
    WriteLog('MAIN', 'UMyFiles.DeleteFilesMask Dir=' + Dir + ' Mask=' + Mask);
    if (Dir <> '') and (Dir[length(Dir)] = '\') then
      Delete(Dir, length(Dir), 1);
    if FindFirst(Dir + '\' + Mask, faDirectory + faHidden + faSysFile +
      faReadonly + faArchive, SR) = 0 then
      repeat
        if (SR.Name = '.') or (SR.Name = '..') then
          continue;
        if (SR.Attr and faDirectory <> faDirectory) then
        begin
          // if AnsiLowerCase(ExtractFileExt(sr.Name)) = '.tmp' then begin
          FileSetReadOnly(Dir + '\' + SR.Name, False);
          DeleteFile(Dir + '\' + SR.Name);
          WriteLog('MAIN', 'UMyFiles.DeleteFilesMask Dir=' + Dir + ' Mask=' +
            Mask + ' | Delete File:' + SR.Name);
          // end
        end;
      until FindNext(SR) <> 0;
    FindClose(SR);
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.DeleteFilesMask Dir=' + Dir + ' Mask=' + Mask +
        ' | ' + E.Message);
  end;
end;

function KillDir(Directory: String): boolean;
var
  SR: SysUtils.TSearchRec;
  Dir: AnsiString;
begin
{$I-}
  try
    WriteLog('MAIN', 'UMyFiles.KillDir Dir=' + Dir);
    Dir := PAnsiChar(Directory);
    if (Dir <> '') and (Dir[length(Dir)] = '\') then
      Delete(Dir, length(Dir), 1);

    if FindFirst(Dir + '\*.*', faDirectory + faHidden + faSysFile + faReadonly +
      faArchive, SR) = 0 then
      repeat
        if (SR.Name = '.') or (SR.Name = '..') then
          continue;
        if (SR.Attr and faDirectory <> faDirectory) then
        begin
          FileSetReadOnly(Dir + '\' + SR.Name, False);
          DeleteFile(Dir + '\' + SR.Name);
          WriteLog('MAIN', 'UMyFiles.KillDir Dir=' + Dir + ' | Delete File:'
            + SR.Name);
        end
        else
        begin
          KillDir(Dir + '\' + SR.Name);
        end;
      until FindNext(SR) <> 0;

    FindClose(SR);
    RemoveDir(Dir); // Удалит пустой каталог
    WriteLog('MAIN', 'UMyFiles.KillDir Delete Dir=' + Dir);
    KillDir := (FileGetAttr(Dir) = -1);
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.KillDir Dir=' + Dir + ' | ' + E.Message);
  end;
end;

procedure WriteBufferStr(F: tStream; astr: widestring);
var
  Len: longint;
begin
  Len := length(astr);
  F.WriteBuffer(Len, SizeOf(Len));
  if Len > 0 then
    F.WriteBuffer(astr[1], length(astr) * SizeOf(astr[1]));
end;

Procedure ReadBufferStr(F: tStream; out astr: String); overload;
var
  Len: longint;
  ws: widestring;
begin
  F.ReadBuffer(Len, SizeOf(Len));
  Setlength(ws, Len);
  if Len > 0 then
    F.ReadBuffer(ws[1], length(ws) * SizeOf(ws[1]));
  astr := ws;
end;

Procedure ReadBufferStr(F: tStream; out astr: tfontname); overload;
var
  Len: longint;
  ws: widestring;
begin
  F.ReadBuffer(Len, SizeOf(Len));
  Setlength(ws, Len);
  if Len > 0 then
    F.ReadBuffer(ws[1], length(ws) * SizeOf(ws[1]));
  astr := ws;
end;

Procedure ReadBufferStr(F: tStream; out astr: widestring); overload;
var
  Len: longint;
  ws: widestring;
begin
  F.ReadBuffer(Len, SizeOf(Len));
  Setlength(ws, Len);
  if Len > 0 then
    F.ReadBuffer(ws[1], length(ws) * SizeOf(ws[1]));
  astr := ws;
end;

procedure WriteLog(FileName: string; log: widestring);
var
  F: TextFile;
  txt, FN: string;
  Day, Month, Year: Word;
Begin
  if not MakeLogging then
    Exit;
  try
    DecodeDate(now, Year, Month, Day);
    PathLog := extractfilepath(application.ExeName) + 'Log';
    if not DirectoryExists(PathLog) then
      ForceDirectories(PathLog);
    FN := PathLog + '\' + trim(FileName) + TwoDigit(Day) + TwoDigit(Month) +
      inttostr(Year) + '.log';
    AssignFile(F, FN);
    try
      if FileExists(FN) then
        Append(F)
      else
        Rewrite(F);
      DateTimeToString(txt, 'dd.mm.yyyy hh:mm:ss:ms', now);
      Writeln(F, txt + ' |' + ProjectNumber + '| ' + log);
    except
    end;
  finally
    CloseFile(F);
  end
End;

Procedure SaveClipEditingToFile(ClipName: string);
var
  Stream: TFileStream;
  renm, FileName: string;
  i: integer;
begin
  try
    WriteLog('MAIN', 'UMyFiles.SaveClipEditingToFile Start ClipName=' +
      ClipName);
    FileName := PathClips + '\' + ClipName + '.Clip';
    if FileExists(FileName) then
    begin
      renm := extractfilepath(FileName) + 'Temp.Clip';
      RenameFile(FileName, renm);
      DeleteFile(renm);
    end;
    Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
    try
      TLParameters.WriteToStream(Stream);
      // TLHeights.WriteToStream(Stream);
      // Stream.WriteBuffer(Form1.GridTimeLines.RowCount, SizeOf(integer));
      // for i:=1 to Form1.GridTimeLines.RowCount-1
      // do (Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).WriteToStream(Stream);
      ZoneNames.WriteToStream(Stream);
      TLZone.WriteToStream(Stream);
    finally
      FreeAndNil(Stream);
      WriteLog('MAIN', 'UMyFiles.SaveClipEditingToFile Finish ClipName=' +
        ClipName);
    end
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UMyFiles.SaveClipEditingToFile ClipName=' + ClipName +
        ' | ' + E.Message);
      FreeAndNil(Stream);
    end
    else
      FreeAndNil(Stream);
  end;
end;

function LoadClipEditingFromFile(ClipName: string): boolean;
var
  Stream: TFileStream;
  renm, FileName: string;
  i, cnt: integer;
begin
  try
    WriteLog('MAIN', 'UMyFiles.LoadClipEditingFromFile Start ClipName=' +
      ClipName);
    Result := False;
    FileName := PathClips + '\' + ClipName + '.Clip';
    if not FileExists(FileName) then
      Exit;
    Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
    try
      TLParameters.ReadFromStream(Stream);
      // TLHeights.ReadFromStream(Stream);
      // Stream.ReadBuffer(cnt, SizeOf(integer));
      // if cnt < Form1.GridTimeLines.RowCount then begin
      // For i:= Form1.GridTimeLines.RowCount - 1 to cnt-1
      // do Form1.GridTimeLines.Objects[0,i]:=nil;
      // end;
      // Form1.GridTimeLines.RowCount:=cnt;
      // For i:=1 to Form1.GridTimeLines.RowCount-1 do begin
      // if not (Form1.GridTimeLines.Objects[0,i] is TTimelineOptions)
      // then Form1.GridTimeLines.Objects[0,i] := TTimelineOptions.Create;
      // (Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).ReadFromStream(Stream);
      // end;

      ZoneNames.ReadFromStream(Stream);
      TLZone.ReadFromStream(Stream);
      Result := True;
    finally
      FreeAndNil(Stream);
      WriteLog('MAIN', 'UMyFiles.LoadClipEditingFromFile Finish ClipName=' +
        ClipName);
    end
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UMyFiles.LoadClipEditingFromFile ClipName=' + ClipName +
        ' | ' + E.Message);
      FreeAndNil(Stream);
    end
    else
      FreeAndNil(Stream);
  end;
end;

Procedure SaveGridToFile(FileName: string; Grid: tstringgrid);
var
  Stream: TFileStream;
  i, j, rw, ph: integer;
  sz, ps: longint;
  renm: string;
begin
  try
    WriteLog('MAIN', 'UMyFiles.SaveGridToFile Start FileName=' + FileName +
      ' Grid=' + Grid.Name);
    if trim(ExtractFileName(FileName)) = '' then
      Exit;
    if FileExists(FileName) then
    begin
      renm := extractfilepath(FileName) + 'Temp.prjl';
      RenameFile(FileName, renm);
      DeleteFile(renm);
    end;
    Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
    try
      Stream.WriteBuffer(Grid.RowCount, SizeOf(integer));
      for i := 0 to Grid.RowCount - 1 do
        (Grid.Objects[0, i] as TGridRows).WriteToStream(Stream);
    finally
      FreeAndNil(Stream);
      WriteLog('MAIN', 'UMyFiles.SaveGridToFile Finish FileName=' + FileName +
        ' Grid=' + Grid.Name);
    end;
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UMyFiles.SaveGridToFile FileName=' + FileName + ' Grid='
        + Grid.Name + ' | ' + E.Message);
      FreeAndNil(Stream);
    end
    else
      FreeAndNil(Stream);
  end;
end;

function LoadGridFromFile(FileName: string; Grid: tstringgrid): boolean;
var
  Stream: TFileStream;
  i, j, rw, ph, pp, cnt, cnt1, cnt2: integer;
  sz, ps: longint;
  renm: string;
  tc: TTypeCell;
begin
  try
    WriteLog('MAIN', 'UMyFiles.LoadGridFromFile Start FileName=' + FileName +
      ' Grid=' + Grid.Name);
    Result := False;
    if not FileExists(FileName) then
      Exit;
    Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
    try
      Stream.ReadBuffer(cnt, SizeOf(integer));
      for i := 0 to Grid.RowCount - 1 do
        Grid.Objects[0, i] := nil;
      Grid.RowCount := cnt;
      for i := 0 to Grid.RowCount - 1 do
      begin
        if not(Grid.Objects[0, i] is TGridRows) then
          Grid.Objects[0, i] := TGridRows.Create;
        (Grid.Objects[0, i] as TGridRows).ReadFromStream(Stream);
        (Grid.Objects[0, i] as TGridRows).SetDefaultFonts;
      end;
    finally
      FreeAndNil(Stream);
      WriteLog('MAIN', 'UMyFiles.LoadGridFromFile Finish FileName=' + FileName +
        ' Grid=' + Grid.Name);
    end;
    Result := True;
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UMyFiles.LoadGridFromFile FileName=' + FileName +
        ' Grid=' + Grid.Name + ' | ' + E.Message);
      FreeAndNil(Stream);
    end
    else
      FreeAndNil(Stream);
  end;
end;

Procedure SaveGridTimelinesToFile(FileName: string; Grid: tstringgrid);
var
  Stream: TFileStream;
  i, j, rw, ph: integer;
  sz, ps: longint;
  renm: string;
begin
  try
    WriteLog('MAIN', 'UMyFiles.SaveGridTimelinesToFile Start FileName=' +
      FileName + ' Grid=' + Grid.Name);
    if FileExists(FileName) then
    begin
      renm := extractfilepath(FileName) + 'Temp.gtls';
      RenameFile(FileName, renm);
      DeleteFile(renm);
    end;
    Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
    try
      Stream.WriteBuffer(Grid.RowCount, SizeOf(integer));
      for i := 1 to Grid.RowCount - 1 do
        (Grid.Objects[0, i] as TTimelineOptions).WriteToStream(Stream);
    finally
      FreeAndNil(Stream);
      WriteLog('MAIN', 'UMyFiles.SaveGridTimelinesToFile Finish FileName=' +
        FileName + ' Grid=' + Grid.Name);
    end;
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UMyFiles.SaveGridTimelinesToFile FileName=' + FileName +
        ' Grid=' + Grid.Name + ' | ' + E.Message);
      FreeAndNil(Stream);
    end
    else
      FreeAndNil(Stream);
  end;
end;

Procedure LoadGridTimelinesFromFile(FileName: string; Grid: tstringgrid);
var
  Stream: TFileStream;
  i, j, rw, ph, cnt, cnt1: integer;
  sz, ps: longint;
  renm: string;
begin
  try
    WriteLog('MAIN', 'UMyFiles.LoadGridTimelinesFromFile Start FileName=' +
      FileName + ' Grid=' + Grid.Name);
    if not FileExists(FileName) then
      Exit;
    Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
    try
      Stream.ReadBuffer(cnt, SizeOf(integer));
      for i := 1 to Grid.RowCount - 1 do
        Grid.Objects[0, i] := nil;
      Grid.RowCount := cnt;
      for i := 1 to Grid.RowCount - 1 do
      begin
        Grid.Objects[0, i] := TTimelineOptions.Create;
        (Grid.Objects[0, i] as TTimelineOptions).ReadFromStream(Stream);
      end;
    finally
      FreeAndNil(Stream);
      WriteLog('MAIN', 'UMyFiles.LoadGridTimelinesFromFile Finish FileName=' +
        FileName + ' Grid=' + Grid.Name);
    end;
  except
    on E: Exception do
    begin
      WriteLog('MAIN', 'UMyFiles.LoadGridTimelinesFromFile FileName=' + FileName
        + ' Grid=' + Grid.Name + ' | ' + E.Message);
      FreeAndNil(Stream);
    end
    else
      FreeAndNil(Stream);
  end;
end;

Procedure SaveProjectToDisk;
var
  Streamp: TFileStream;
  FileName: string;
  i, j, rw, ph: integer;
  sz, ps: longint;
  renm: string;
  Name: string;
begin
  try
    WriteLog('MAIN', 'UMyFiles.SaveProjectToDisk Start');
    if not DirectoryExists(PathLists) then
      Exit;

    FileName := PathLists + '\Timelines.lst';
    if FileExists(FileName) then
    begin
      renm := PathLists + '\Temp.tlls';
      RenameFile(FileName, renm);
      DeleteFile(renm);
    end;
    SaveGridTimelinesToFile(FileName, Form1.GridTimeLines);

    if FileExists(PathTemp + '\PlayLists.lst') then
    begin
      if FileExists(PathLists + '\PlayLists.lst') then
      begin
        renm := PathLists + '\Temp.plls';
        RenameFile(PathLists + '\PlayLists.lst', renm);
        DeleteFile(renm);
      end;
      if FileExists(PathTemp + '\PlayLists.lst') then
        CopyFile(PWideChar(PathTemp + '\PlayLists.lst'),
          PWideChar(PathLists + '\PlayLists.lst'), True);
    end;

    if FileExists(PathTemp + '\ImageTemplates.lst') then
    begin
      if FileExists(PathLists + '\ImageTemplates.lst') then
      begin
        renm := PathLists + '\Temp.tmgr';
        RenameFile(PathLists + '\ImageTemplates.lst', renm);
        DeleteFile(renm);
      end;
      if FileExists(PathTemp + '\ImageTemplates.lst') then
        CopyFile(PWideChar(PathTemp + '\ImageTemplates.lst'),
          PWideChar(PathLists + '\ImageTemplates.lst'), True);
    end;

    if FileExists(PathTemp + '\TextTemplates.lst') then
    begin
      if FileExists(PathLists + '\TextTemplates.lst') then
      begin
        renm := PathLists + '\Temp.tmtx';
        RenameFile(PathLists + '\TextTemplates.lst', renm);
        DeleteFile(renm);
      end;
      if FileExists(PathTemp + '\TextTemplates.lst') then
        CopyFile(PWideChar(PathTemp + '\TextTemplates.lst'),
          PWideChar(PathLists + '\TextTemplates.lst'), True);
    end;

    if FileExists(PathTemp + '\Clips.lst') then
    begin
      if FileExists(PathLists + '\Clips.lst') then
      begin
        renm := PathLists + '\Temp.clps';
        RenameFile(PathLists + '\Clips.lst', renm);
        DeleteFile(renm);
      end;
      if FileExists(PathTemp + '\Clips.lst') then
        CopyFile(PWideChar(PathTemp + '\Clips.lst'),
          PWideChar(PathLists + '\Clips.lst'), True);
    end;
    WriteLog('MAIN', 'UMyFiles.SaveProjectToDisk Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.SaveProjectToDisk | ' + E.Message);
  end;
end;

Procedure LoadProjectFromDisk;
var
  Streamp: TFileStream;
  FileName: string;
  i, j, rw, ph: integer;
  sz, ps: longint;
  renm: string;
  Name: string;
begin
  try
    WriteLog('MAIN', 'UMyFiles.LoadProjectFromDisk Start');
    if trim(ProjectNumber) = '' then
      Exit;
    CreateDirectories(ProjectNumber);

    DeleteFilesMask(pathproject, '*.*');

    if FileExists(PathLists + '\Timelines.lst') then
      LoadGridTimelinesFromFile(PathLists + '\Timelines.lst',
        Form1.GridTimeLines);

    if FileExists(PathLists + '\PlayLists.lst') then
      CopyFile(PWideChar(PathLists + '\PlayLists.lst'),
        PWideChar(PathTemp + '\PlayLists.lst'), True);

    if FileExists(PathLists + '\ImageTemplates.lst') then
      CopyFile(PWideChar(PathLists + '\ImageTemplates.lst'),
        PWideChar(PathTemp + '\ImageTemplates.lst'), True);

    if FileExists(PathLists + '\TextTemplates.lst') then
      CopyFile(PWideChar(PathLists + '\TextTemplates.lst'),
        PWideChar(PathTemp + '\TextTemplates.lst'), True);

    if FileExists(PathLists + '\Clips.lst') then
      CopyFile(PWideChar(PathLists + '\Clips.lst'),
        PWideChar(PathTemp + '\Clips.lst'), True);
    WriteLog('MAIN', 'UMyFiles.LoadProjectFromDisk Finish');
  except
    on E: Exception do
      WriteLog('MAIN', 'UMyFiles.LoadProjectFromDisk | ' + E.Message);
  end;
end;

end.
