unit uwebget;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, strutils, httpsend, system.win.crtl;

var
    PortNum: integer = 9091;
    chbuf: array[0..100000] of char;
    tmpjSon: ansistring;
    Jevent, JDev, jAirsecond: TStringList;
    Jmain: ansistring;
    jsonresult: ansistring;

function BeginJson(): boolean;

function SaveJson(): boolean;

function GetJsonStrFromWeb(url: ansistring): ansistring;
function PutJsonStrToWeb(url: ansistring; jsonstr : ansistring): ansistring;

function addVariable(ObjNum: integer; varname, VarValue: string): integer; overload;

function addVariable(ObjNum: integer; arrName, Elementid, varname, VarValue: string): integer; overload;

implementation

function BeginJson(): boolean;
begin

end;

function SaveJson(): boolean;
begin

end;

function addVariable(ObjNum: integer; varname, VarValue: string): integer; overload;
begin
end;

function addVariable(ObjNum: integer; arrName, Elementid, varname, VarValue: string): integer; overload;
begin

end;

function GetJsonStrFromWeb(url: ansistring): ansistring;
var
    http: thttpsend;
    jsonstr: ansistring;
    strlist: tstringlist;
    httpstr: ansistring;
    i, i1 : integer;
    str1: ansistring;
    mstr: tmemorystream;
    ff: tfilestream;
begin
    result := '';
    strlist := tstringlist.create;
    if not httpgettext(url, strlist) then
        exit;
    if length(strlist.text) < 6 then
        exit;
    i1 := pos('{',strlist.text);
    result := 'ERR='+strlist.text;
    if i1 <1   then exit;
    //    strlist.savetofile('g:\home\gettext.js');
    result := system.copy(strlist.text, i1, length(strlist.text) - 2);
    while (result[length(result)] <> '}') and (length(result) > 1) do
        system.delete(result, length(result), 1);

end;
function PutJsonStrToWeb(url: ansistring; jsonstr : ansistring): ansistring;
var
    http: thttpsend;
    strlist: tstringlist;
    httpstr: ansistring;
    i, i1 : integer;
    str1: ansistring;
    mstr: tmemorystream;
    ff: tfilestream;
    putcommand : ansistring;
begin
    result := '';

    strlist := tstringlist.create;
    putcommand := url+jsonstr;
    showmessage('verb put = '+putcommand);
    if not httpgettext(putcommand, strlist) then
        exit;
    result := strlist.text;
//    showmessage(' answ = '+result);
    if length(strlist.text) < 6 then exit;
    i1 := pos('{',strlist.text);
    if i1<1  then exit;

    //    strlist.savetofile('g:\home\gettext.js');
    result := system.copy(strlist.text, i1, length(strlist.text) - 2);
    while (result[length(result)] <> '}') and (length(result) > 0) do
        system.delete(result, length(result), 1);
//    showmessage(result);
end;

end.

