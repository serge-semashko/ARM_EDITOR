unit uwebget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, strutils, httpsend, system.win.crtl, ucommon, system.json;
Procedure addVariableToJson(var JSON: tjsonobject; varName: string;
  varvalue: variant);
Function getVariableFromJson(var JSON: tjsonobject; varName: string;
  varvalue: variant): variant;

function GetJsonStrFromServer(varName: ansistring): ansistring;
function PutJsonStrToServer(varName: ansistring; varValue: ansistring)
  : ansistring;
var
  jsonware_url: string;
  LoadProject_active : boolean = true;
  webredis_errlasttime : double = -1;
implementation

var
  PortNum: integer = 9090;
  chbuf: array [0 .. 100000] of char;
  tmpjSon: ansistring;
  Jevent, JDev, jAirsecond: TStringList;
  Jmain: ansistring;
  jsonresult: ansistring;
Function getVariableFromJson(var JSON: tjsonobject; varName: string;
  varvalue: variant): variant;
var
  tmpjson: tjsonvalue;
  tmpstr: string;
  res: variant;
begin
  tmpjson := JSON.GetValue(varName);
  if (tmpjson <> nil) then
  begin
    tmpstr := tmpjson.Value;
    // varValue := tmpStr;
    result := tmpstr;
  end;
end;

Procedure addVariableToJson(var JSON: tjsonobject; varName: string;
  varvalue: variant);
var
  teststr: ansistring;
  List: TStringList;
  numElement: integer;
  utf8val: string;
  tmpjson: tjsonvalue;
  retval: string;
  strValue, s1 : string;
  vType: tvarType;
  tmpInt: integer;
begin
  FormatSettings.DecimalSeparator := '.';
  vType := varType(varvalue);
  strValue := varvalue;
//  if varName = 'Name'  then begin
    s1 := AnsiReplaceStr(strValue,' ','_');
    strValue := AnsiReplaceStr(strValue,' ','_');
//  end;
  utf8val := stringOf(tencoding.UTF8.GetBytes(strValue));
  JSON.AddPair(varName, strValue);
end;

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
  if (now-webredis_errlasttime)*24*3600<10 then exit;

  strlist := TStringList.create;
  if pos('HTTP://',AnsiUpperCase(varName)) < 1 then
     putcommand := jsonware_url + 'GET_' + varName
     else putcommand :=varName;
  if not httpgettext(putcommand, strlist) then
  begin
    webredis_errlasttime := now;
    exit;
  end;
  result := strlist.text;
  if length(strlist.text) < 6 then
  begin
    webredis_errlasttime := now;
    exit;
  end;
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
    if LoadProject_active then exit;
  if (now-webredis_errlasttime)*24*3600<10 then exit;
  result := '';
  strlist := TStringList.create;
  putcommand := jsonware_url + 'SET_' + varName + '=' + varValue;
  if not httpgettext(putcommand, strlist) then
  begin
    webredis_errlasttime := now;
    exit;
  end;
  result := strlist.text;
  if length(strlist.text) < 6 then
  begin
    webredis_errlasttime := now;
    exit;
  end;
  i1 := pos('{', strlist.text);
  if i1 < 1 then
    exit;
  result := system.copy(strlist.text, i1, length(strlist.text) - 2);
  while (result[length(result)] <> '}') and (length(result) > 0) do
    system.delete(result, length(result), 1);
  if length(result)<1 then  result:=' ';
end;

initialization

jsonware_url := 'http://localhost:9090/';

end.
