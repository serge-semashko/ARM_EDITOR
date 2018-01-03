unit uwebserv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPServer, IdCustomHTTPServer, IdHTTPServer, ulkjson, blcksock, winsock, Synautil;

type
  THTTPSRVForm = class(TForm)
    Panel1 : TPanel;
    Timer1 : TTimer;
    Memo2 : TMemo;
    ObjNum : TComboBox;
    varname : TLabeledEdit;
    VarVal : TLabeledEdit;
    BitBtn2 : TBitBtn;
    Label1 : TLabel;
    procedure FormCreate (Sender : TObject);
    procedure BitBtn2Click (Sender : TObject);
    procedure BitBtn3Click (Sender : TObject);
    procedure Timer1Timer (Sender : TObject);
    private
    { Private declarations }
    public
  end;

// Function setVariable(ObjName,VarName:widestring;value:string);
  TTCPHttpDaemon = class(TThread)
    private
      Sock : TTCPBlockSocket;
    public
      Constructor Create;
      Destructor Destroy; override;
      procedure Execute; override;
  end;

  TTCPHttpThrd = class(TThread)
    private
      Sock : TTCPBlockSocket;
    public
      Headers : TStringList;
      InputData, OutputData : TMemoryStream;
      Constructor Create (hsock : tSocket);
      Destructor Destroy; override;
      procedure Execute; override;
      function ProcessHttpRequest (Request, URI : ansistring) : integer;
  end;

var
  PortNum : integer = 9091;

var
  HTTPsrv : TTCPHttpDaemon;
  HTTPSRVFORM : THTTPSRVForm;
  jsonobj0 : tlkjsonobject;
  jsonobj1 : tlkjsonobject;
  jsonobj2 : tlkjsonobject;
  jsonobj3 : tlkjsonobject;
  subobj : tlkjsonobject;
  tmpjSon : ansistring;
  Jevent, JDev, jAirsecond : TStringList;
  Jmain : ansistring;
  jsonresult : ansistring;
procedure BeginJson;
procedure SaveJson;
Function addVariable (ObjNum : integer; varname, VarValue : string) : integer; overload;
Function addVariable (ObjNum : integer; arrName, Elementid, varname, VarValue : string) : integer; overload;


implementation

{$R *.dfm}


Procedure BeginJson;
  var
    i : integer;
  begin
    tmpjSon := '{';
    for i := 0 to 255 do
      Jevent[i] := '';
    for i := 0 to 255 do
      Jdev[i] := '';
    for i := 0 to 255 do
      JairSecond[i] := '';
  end;


procedure SaveJson;
  var
    tmpres : ansistring;
    Procedure addjlist (arrName : ansistring; arrlist : TStringList);
      var
        i : integer;
      begin
        tmpJson :=tmpJson+arrname+':{';
        for i := 0 to arrlist.Count - 1 do
          begin
            if arrlist[i]<>'' then
               tmpJson :=tmpJson+ IntToStr(i)+':{'+arrlist[i]+'},';
          end;
        tmpJson :=tmpJson+'},';
      end;
begin
  addjlist ('Event', Jevent);
  addjlist ('Dev', JDev);
  addjlist ('airSecond', jAirsecond);
  jsonresult := tmpjSon + '}';
end;

Function addVariable (ObjNum : integer; varname, VarValue : string) : integer;
  var
    jsonobj : tlkjsonobject;
    resstr : ansistring;
    utf8val : string;
  begin
    utf8val := stringOf(tencoding.UTF8.GetBytes(varValue));
    tmpjSon := tmpjSon + varname + ':' + '"' + utf8Val + '",';
  end;

Function addVariable (ObjNum : integer; arrName, Elementid, varname, VarValue : string) : integer; overload;
  var
    teststr : ansistring;
    list : TStringList;
    numElement : integer;
    utf8val : string;
  begin
    utf8val := stringOf(tencoding.UTF8.GetBytes(varValue));
    if arrName = 'Event' then
      list := Jevent;
    if arrName = 'Dev' then
      list := JDev;
    if arrName = 'airSecond' then
      list := jAirsecond;
    numElement := strToInt (Elementid);
    list[numElement] :=    list[numElement]+ varname + ':' + '"' + utf8val + '",';
  end;


procedure THTTPSRVForm.FormCreate (Sender : TObject);
  var
    ff : tfilestream;
    str1 : ansistring;
    objFileName : ansistring;
    strlist : TStringList;
  begin
    HTTPsrv := TTCPHttpDaemon.Create;
    PortNum := 9090;
(*
  ObjFileName := application.ExeName+'.jdata';
  if fileexists(ObjFileName) then  begin
    strlist:=tstringlist.Create;
    strlist.LoadFromFile(ObjFileName);
    str1:=strlist.Text;
    jsonobj := TlkJSON.ParseText(str1) as TlkJSONobject;
  end else *)

  end;

procedure THTTPSRVForm.BitBtn2Click (Sender : TObject);
  var
    jsonobj : tlkjsonobject;
  begin
    if varname.Text = '' then
      begin
        showmessage ('Variable name must be defined');
        exit;
      end;

    addVariable (ObjNum.ItemIndex, varname.Text, VarVal.Text);
    Memo2.Lines.Clear;

(*
  memo2.Lines.Clear;
  memo2.Lines.add(tlkjson.GenerateText(jsonobj));
  subobj.Free;
*)
  end;

procedure THTTPSRVForm.BitBtn3Click (Sender : TObject);
  var
    jsonobj : tlkjsonobject;
// subobj:tlkjsonbase;
    stype : TlkJSONtypes;
  begin
    assert (varname.Text <> '', 'Variable name must be defined');
    addVariable (ObjNum.ItemIndex, varname.Text, VarVal.Text);
  end;

procedure THTTPSRVForm.Timer1Timer (Sender : TObject);
  begin
    Memo2.Lines.Clear;
    Memo2.Lines.Add (tlkjson.GenerateText(jsonobj0));
    Memo2.Lines.Add (tlkjson.GenerateText(jsonobj1));
    Memo2.Lines.Add (tlkjson.GenerateText(jsonobj2));
    Memo2.Lines.Add (tlkjson.GenerateText(jsonobj3));
  // THTTPSRVForm
  end;

Constructor TTCPHttpDaemon.Create;
  begin
    inherited Create (false);
    Sock := TTCPBlockSocket.Create;
    FreeOnTerminate := true;
    Priority := tpNormal;
  end;

Destructor TTCPHttpDaemon.Destroy;
  begin
    Sock.free;
    inherited Destroy;
  end;

procedure TTCPHttpDaemon.Execute;
  var
    ClientSock : tSocket;
  begin
    with Sock do
      begin
        CreateSocket;
        setLinger (true, 10);
        bind ('0.0.0.0', IntToStr(PortNum));
        listen;
        repeat
          if terminated then
            break;
          if canread (1000) then
            begin
              ClientSock := accept;
              if lastError = 0 then
                TTCPHttpThrd.Create (ClientSock);
            end;
        until false;
      end;
  end;

{ TTCPHttpThrd }

Constructor TTCPHttpThrd.Create (hsock : tSocket);
  begin
    inherited Create (false);
    Sock := TTCPBlockSocket.Create;
    Headers := TStringList.Create;
    InputData := TMemoryStream.Create;
    OutputData := TMemoryStream.Create;
    Sock.socket := hsock;
    FreeOnTerminate := true;
    Priority := tpNormal;
  end;

Destructor TTCPHttpThrd.Destroy;
  begin
    Sock.free;
    Headers.free;
    InputData.free;
    OutputData.free;
    inherited Destroy;
  end;

procedure TTCPHttpThrd.Execute;
  var
    b : byte;
    timeout : integer;
    s : string;
    method, URI, protocol : ansistring;
    size : integer;
    x, n : integer;
    resultcode : integer;
  begin
    timeout := 120000;
  // read request line
    s := Sock.RecvString (timeout);
    if Sock.lastError <> 0 then
      exit;
    if s = '' then
      exit;
    method := fetch (s, ' ');
    if (s = '') or (method = '') then
      exit;
    URI := fetch (s, ' ');
    if URI = '' then
      exit;
    protocol := fetch (s, ' ');
    Headers.Clear;
    size := -1;
  // read request headers
    if protocol <> '' then
      begin
        if pos ('HTTP/', protocol) <> 1 then
          exit;
        repeat
          s := Sock.RecvString (timeout);
          if Sock.lastError <> 0 then
            exit;
          if s <> '' then
            Headers.Add (s);
          if pos ('CONTENT-LENGTH:', Uppercase(s)) = 1 then
            size := StrToIntDef (SeparateRight(s, ' '), -1);
        until s = '';
      end;
  // recv document...
    InputData.Clear;
    if size >= 0 then
      begin
        InputData.SetSize (size);
        x := Sock.RecvBufferEx (InputData.Memory, size, timeout);
        InputData.SetSize (x);
        if Sock.lastError <> 0 then
          exit;
      end;
    OutputData.Clear;
    resultcode := ProcessHttpRequest (method, URI);
    Sock.SendString ('HTTP/1.0 ' + IntToStr(resultcode) + CRLF);
    if protocol <> '' then
      begin
        Headers.Add ('Content-length: ' + IntToStr(OutputData.size));
        Headers.Add ('Connection: close');
        Headers.Add ('Date: ' + Rfc822DateTime(now));
        Headers.Add ('Server: Synapse HTTP server demo');
        Headers.Add ('');
        for n := 0 to Headers.Count - 1 do
          Sock.SendString (Headers[n] + CRLF);
      end;
    if Sock.lastError <> 0 then
      exit;
    Sock.SendBuffer (OutputData.Memory, OutputData.size);
  end;

function TTCPHttpThrd.ProcessHttpRequest (Request, URI : ansistring) : integer;
  var
    l : TStringList;
    resp : ansistring;
    stmp, jreq : ansistring;
    amppos : integer;
  begin
// sample of precessing HTTP request:
// InputData is uploaded document, headers is stringlist with request headers.
// Request is type of request and URI is URI of request
// OutputData is document with reply, headers is stringlist with reply headers.
// Result is result code
    result := 504;
    if Request = 'GET' then
      begin
        Headers.Clear;
        Headers.Add ('Content-type: Text/Html');
        l := TStringList.Create;
        try
          if (pos('callback=', URI) <> 0) then
            begin
              stmp := copy (URI, pos('callback=', URI) + 9, length(URI));
              amppos := pos ('get_member', stmp);
              if amppos > 0 then
                jreq := copy (stmp, 1, amppos - 2);
            end;
          resp := jsonresult;
          resp := jreq + '(' + resp + ');';
          l.Add (resp);
          l.SaveToStream (OutputData);
        finally
          l.free;
        end;
        result := 200;
      end;
  end;

var
  i : integer;

initialization

Jevent := TStringList.Create;
for i := 0 to 255 do
  Jevent.Add ('');
JDev := TStringList.Create;
for i := 0 to 255 do
  JDev.Add ('');
jAirsecond := TStringList.Create;
for i := 0 to 255 do
  jAirsecond.Add ('');

end.
