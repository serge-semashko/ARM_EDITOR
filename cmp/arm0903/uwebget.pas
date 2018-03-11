unit uwebget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, strutils, httpsend, system.win.crtl, ucommon;

function GetJsonStrFromServer(varName: ansistring): ansistring;
function PutJsonStrToServer(varName: ansistring; varValue: ansistring)
  : ansistring;

implementation

var
  PortNum: integer = 9090;
  chbuf: array [0 .. 100000] of char;
  tmpjSon: ansistring;
  Jevent, JDev, jAirsecond: TStringList;
  Jmain: ansistring;
  jsonresult: ansistring;
  url: string;

function GetJsonStrFromServer(varName: ansistring): ansistring;
var
  http: thttpsend;
  jsonstr: ansistring;
  strlist: TStringList;
  httpstr: ansistring;
  i, i1: integer;
  putcommand: ansistring;
  mstr: tmemorystream;
  ff: tfilestream;
begin
  result := '';
  if LoadProject_active then  exit;
  strlist := TStringList.create;
  putcommand := url + 'GET_' + varName;
  if not httpgettext(putcommand, strlist) then
    exit;
  result := strlist.text;
  if length(strlist.text) < 6 then
    exit;
  i1 := pos('{', strlist.text);
  if i1 < 1 then
    exit;
  result := system.copy(strlist.text, i1, length(strlist.text) - 2);
  while (result[length(result)] <> '}') and (length(result) > 0) do
    system.delete(result, length(result), 1);
end;

function PutJsonStrToServer(varName: ansistring; varValue: ansistring)
  : ansistring;
var
  http: thttpsend;
  strlist,plist : TStringList;
  httpstr: ansistring;
  i, i1: integer;
  str1: ansistring;
  mstr: tmemorystream;
  ff: tfilestream;
  putcommand: ansistring;
begin
  result := '';
    if LoadProject_active then exit;
  strlist := TStringList.create;
  putcommand := url + 'SET_' + varName + '=' + varValue;
  if not httpgettext(putcommand, strlist) then
  begin
       plist := tstringlist.Create;
       plist.add(putcommand);
       plist.SaveToFile('g:\home\errset_'+varName+'.txt');
     SHOWMESSAGE('ERR SET_' + varName);

    exit;

  end;
  result := strlist.text;
  if length(strlist.text) < 6 then
    exit;
  i1 := pos('{', strlist.text);
  if i1 < 1 then
    exit;
  result := system.copy(strlist.text, i1, length(strlist.text) - 2);
  while (result[length(result)] <> '}') and (length(result) > 0) do
    system.delete(result, length(result), 1);
end;

initialization

url := 'http://localhost:9090/';

end.
