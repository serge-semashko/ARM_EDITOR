unit uwebget;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, strutils, httpsend, system.win.crtl, system.json;

function GetJsonStrFromServer(varName: ansistring): ansistring;
function PutJsonStrToServer(varName: ansistring; varValue: ansistring) : ansistring;
type
  TlabelJSON = Class helper for TLabel
  public
    Function SaveToJSONStr: string;
    Function SaveToJSONObject: tjsonObject;
    Function LoadFromJSONObject(json: tjsonObject): boolean;
    Function LoadFromJSONstr(JSONstr: string): boolean;
  End;

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
  strlist: TStringList;
  httpstr: ansistring;
  i, i1: integer;
  str1: ansistring;
  mstr: tmemorystream;
  ff: tfilestream;
  putcommand: ansistring;
begin
  result := '';
  strlist := TStringList.create;
  putcommand := url + 'SET_' + varName + '=' + varValue;
  if not httpgettext(putcommand, strlist) then
  begin
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
{ TlabelJSON }

function TlabelJSON.LoadFromJSONObject(json: tjsonObject): boolean;
var
  i1: integer;
  tmpjson: tjsonObject;
begin
  try
    caption := GetVariableFromJson(JSON, 'Caption', Caption);
  except
    on E: Exception do
  end;

end;

function TlabelJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
  JSON: tjsonObject;
begin
  JSON := tjsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONstr), 0)
    as tjsonObject;
  result := true;
  if JSON = nil then
  begin
    result := false;
  end
  else
    LoadFromJSONObject(JSON);
end;

function TlabelJSON.SaveToJSONObject: tjsonObject;
var
  str1: string;
  js1, JSON: tjsonObject;
  i1, i2: integer;
  (*
    ** сохранение всех переменных в строку JSONDATA в формате JSON
  *)
begin
  JSON := tjsonObject.Create;
  try
    // jsonstr : string;
    // IDEvent : longint;
    addVariableToJson(JSON, 'Caption', caption);
  except
    on E: Exception do
  end;
  result := JSON;
end;

function TlabelJSON.SaveToJSONStr: string;
var
  jsontmp: tjsonObject;
  JSONstr: string;
begin
  jsontmp := SaveToJSONObject;
  JSONstr := jsontmp.ToString;
  result := JSONstr;
end;

initialization

url := 'http://localhost:9090/';

end.
