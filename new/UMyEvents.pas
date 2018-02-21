unit UMyEvents;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, ucommon,
  UMyLists;

Type

  TMyPhrase = Class(TObject)
    public
    Name     : string;
    Text     : string;
    Data     : longint;
    Command  : widestring;
    Tag      : integer;
    Rect     : TRect;
    Select   : boolean;
    WorkData : string;
    ListName : string;
    Maxlength: integer;
    Visible  : boolean;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    Constructor Create;
    Destructor  Destroy; override;
  end;

  TMyPhrases = Class(TObject)
    public
    Top : integer;
    Bottom : integer;
    //Procent : integer;
    Count : integer;
    Phrases : Array of TMyPhrase;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    procedure Clear;
    Constructor Create;
    Destructor  Destroy; override;
  end;

  TMyEvent = Class(TObject)
    public
    IDEvent : longint;
    Color : TColor;
    FontColor : TColor;
    FontSize : integer;
    FontSizeSub : integer;
    FontName : tfontname;
    SafeZone : integer;
    //Transition : integer;
    Editing : boolean;
    Select : boolean;
    //Discription : string;
    Start : longint;
    Finish: longint;
    Count : integer;
    Rows : array of TMyPhrases;
    function AddRow : integer;
    function AddPhrase(ARow : integer; Name, TypeDt : string; maxlen : integer) : integer;
    function FindPhrase(Name : string) : tpoint;
    function SelectionPhrase : string;
    procedure SetPhraseText(Name,Text : string);
    procedure SetPhraseType(Name,TypeData : string);
    procedure SetPhraseListName(Name,ListName : string);
    procedure SetPhraseData(Name : string; Data : longint);
    procedure SetPhraseCommand(Name : string; Command : widestring);
    procedure SetPhraseTag(Name : string; Tag : integer);
    procedure SetPhraseVisible(Name : string; visible : boolean);
    function ReadPhraseText(Name : string) : string;
    function ReadPhraseData(Name : string) : longint;
    function ReadPhraseCommand(Name : string) : widestring;
    function ReadPhraseTag(Name : string) : integer;
    function ReadPhraseType(Name : string) : string;
    function ReadPhraseListName(Name : string) : string;
    function PhraseIsVisible(Name : string) : boolean;
    procedure SetRectAreas(TypeTL : TTypeTimeline);
    procedure  SetDependentField(tdf : TDependentField);
    procedure Clear;
    procedure EventSelectFalse;
    procedure Assign(Event : TMyEvent);
    procedure SetEvents(Event : TMyEvent);
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    Constructor Create;
    Destructor  Destroy; override;
  end;
//===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
//========================  Helpers для классов. Сохранения в JSON и загрузка ==
//==============================================================================
  TMyEventJSON = Class helper for TMyEvent
    Function SaveToJSONStr:string;
    Function SaveToJSONObject:tjsonObject;
    Function LoadFromJSONObject(JSON:tjsonobject):boolean;
    Function LoadFromJSONstr(JSONstr:string):boolean;
  End;
  TMyPhraseJSON = Class helper for TMyPhrase
    Function SaveToJSONStr:string;
    Function SaveToJSONObject:tjsonObject;
    Function LoadFromJSONObject(JSON:tjsonobject):boolean;
    Function LoadFromJSONstr(JSONstr:string):boolean;
  End;
    TMyPhrasesJSON = Class helper for TMyPhrases
    Function SaveToJSONStr:string;
    Function SaveToJSONObject:tjsonObject;
    Function LoadFromJSONObject(JSON:tjsonobject):boolean;
    Function LoadFromJSONstr(JSONstr:string):boolean;
  End;

  TRectJSON = record helper for TRect
    Function SaveToJSONStr:string;
    Function SaveToJSONObject:tjsonObject;
    Function LoadFromJSONObject(JSON:tjsonobject):boolean;
    Function LoadFromJSONstr(JSONstr:string):boolean;
  End;
//===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
//========================  Helpers для классов. Сохранения в JSON и загрузка ==
//==============================================================================

var
  EventDevice, EventText, EventMedia : TMyEvent;
  ERow, EPhr : integer;

implementation
uses umain, udrawtimelines, UTimeline, umyfiles;

//===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
//========================  Helpers для классов. Сохранения в JSON и загрузка ==
//==============================================================================
{ TMyEventJSON }


function TMyEventJSON.LoadFromJSONObject(JSON: tjsonobject): boolean;
var
 i1 : integer;
 tmpjson : tJsonObject;
begin
  try
//    IDEvent : longint;
    IDEvent := GetVariableFromJson(json,'IDEvent',IDEvent);
//    Color : TColor;
    Color := GetVariableFromJson(json,'Color',Color);
//    FontColor : TColor;
    FontColor := GetVariableFromJson(json,'FontColor',FontColor);
//    FontSize : integer;
    FontSize := GetVariableFromJson(json,'FontSize',FontSize);
//    FontSizeSub : integer;
    FontSizeSub := GetVariableFromJson(json,'FontSizeSub',FontSizeSub);
//    FontName : tfontname;
    FontName := GetVariableFromJson(json,'FontName',FontName);
//    SafeZone : integer;
    SafeZone := GetVariableFromJson(json,'SafeZone',SafeZone);
//    Editing : boolean;
    Editing := GetVariableFromJson(json,'Editing',Editing);
//    Select : boolean;
    Select := GetVariableFromJson(json,'Select',Select);
//    Start : longint;
    Start := GetVariableFromJson(json,'Start',Start);
//    Finish: longint;
    Finish := GetVariableFromJson(json,'Finish',Finish);
//    Count : integer;
    Count := GetVariableFromJson(json,'Count',Count);
   SetLength(rows,0);
   SetLength(rows,count);
   for i1 := 0 to count - 1  do begin
      tmpjson :=  tjsonObject(json.GetValue('Rows'+IntToStr(i1)));
      assert(tmpJson <> nil,'TMyEvents нет значения  '+'Rows'+IntToStr(i1));
      if tmpjson = nil then break;
      rows[i1] := TMyPhrases.Create;
      rows[i1].LoadFromJSONObject(tmpjson);
   end;
  except
    on E: Exception do
  end;

end;

function TMyEventJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
  json: tjsonobject;
begin
  json :=  TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONStr), 0) as TJSONObject;
  result := true;
  if json=nil  then begin
   result := false;
  end else LoadFromJsonObject(json);

end;

function TMyEventJSON.SaveToJSONObject: tJSONObject;
var
  str1 : string;
  js1, json: tjsonobject;
  i1, i2 : integer;
  (*
    ** сохранение всех переменных в строку JSONDATA в формате JSON
  *)
begin
  json := tjsonobject.Create;
  try
//    jsonstr : string;
//    IDEvent : longint;
    addVariableToJson(json,'IDEvent',IDEvent);
//    Color : TColor;
    addVariableToJson(json,'Color',Color);
//    FontColor : TColor;
    addVariableToJson(json,'FontColor',FontColor);
//    FontSize : integer;
    addVariableToJson(json,'FontSize',FontSize);
//    FontSizeSub : integer;
    addVariableToJson(json,'FontSizeSub',FontSizeSub);
//    FontName : tfontname;
    addVariableToJson(json,'FontName',FontName);
//    SafeZone : integer;
    addVariableToJson(json,'SafeZone',SafeZone);
//    Editing : boolean;
    addVariableToJson(json,'Editing',Editing);
//    Select : boolean;
    addVariableToJson(json,'Select',Select);
//    Start : longint;
    addVariableToJson(json,'Start',Start);
//    Finish: longint;
    addVariableToJson(json,'Finish',Finish);
//    Count : integer;
    addVariableToJson(json,'Count',Count);
//    Rows : array of TMyPhrases;
   for i1 := Low(Rows) to High(Rows) do begin
      json.AddPair('Rows'+IntToStr(i1),rows[i1].SaveToJSONObject)
   end;
  except
    on E: Exception do
  end;
  result := json;
  str1 := json.ToString;
end;

function TMyEventJSON.SaveToJSONstr: string;

var
 jsontmp : tjsonobject;
 jsonstr : string;
begin
  jsontmp := SaveToJsonObject;
  JsonStr := jsontmp.Tostring;
  result := jsonStr;
end;

{ TMyPhraseJSON }

function TMyPhraseJSON.LoadFromJSONObject(JSON: tjsonobject): boolean;
begin
  Name := GetVariableFromJson(json,'Name',Name);
//    Name     : string;
  Text := GetVariableFromJson(json,'Text',Text);
//    Text     : string;
  data := GetVariableFromJson(json,'Data',data);
//    Data     : longint;
  Data := GetVariableFromJson(json,'Data',Data);
//    Command  : widestring;
  command := GetVariableFromJson(json,'Command',command);
//    Tag      : integer;
  tag := GetVariableFromJson(json,'Tag',tag);
//    Rect     : TRect;
 rect.LoadFromJSONObject(TJsonObject(json.GetValue('Rect')));
//    Select   : boolean;
 Select := GetVariableFromJson(json,'Select',Select);
//    WorkData : string;
 WorkData := GetVariableFromJson(json,'WorkData',WorkData);
//    ListName : string;
 ListName := GetVariableFromJson(json,'ListName',ListName);
//    Maxlength: integer;
 Maxlength := GetVariableFromJson(json,'Maxlength',Maxlength);
//    Visible  : boolean;
 Visible := GetVariableFromJson(json,'Visible',Visible);
end;

function TMyPhraseJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
  json: tjsonobject;
begin
  json :=  TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONStr), 0) as TJSONObject;
  result := true;
  if json=nil  then begin
   result := false;
  end else LoadFromJsonObject(json);
end;

function TMyPhraseJSON.SaveToJSONObject: tjsonObject;
var
 json : tjsonobject;
begin
 json := tjsonobject.create;
 addVariableToJson(json,'Name',Name);
//    Name     : string;
 addVariableToJson(json,'Text',Text);
//    Text     : string;
 addVariableToJson(json,'Data',data);
//    Data     : longint;
 addVariableToJson(json,'Data',Data);
//    Command  : widestring;
 addVariableToJson(json,'Command',command);
//    Tag      : integer;
 addVariableToJson(json,'Tag',tag);
//    Rect     : TRect;
 json.AddPair('Rect',Rect.saveToJsonObject);
//    Select   : boolean;
 addVariableToJson(json,'Select',Select);
//    WorkData : string;
 addVariableToJson(json,'WorkData',WorkData);
//    ListName : string;
 addVariableToJson(json,'ListName',ListName);
//    Maxlength: integer;
 addVariableToJson(json,'Maxlength',Maxlength);
//    Visible  : boolean;
 addVariableToJson(json,'Visible',Visible);
 result := json;
end;

function TMyPhraseJSON.SaveToJSONStr: string;
begin
  result := SaveToJSONObject.ToString;
end;

{ TMyPhrasesJSON }

function TMyPhrasesJSON.LoadFromJSONObject(JSON: tjsonobject): boolean;
var
 tmpjson : tjsonobject;
 i1 : integer;
begin
  Top := GetVariableFromJson(json,'Top',Top);
//    Top : integer;
  Bottom := GetVariableFromJson(json,'Bottom',Bottom);
//    Bottom : integer;
  Count := GetVariableFromJson(json,'Count',Count);
//    Count : integer;
   SetLength(Phrases,0);
   SetLength(Phrases,count);
   for i1 := 0 to count - 1  do begin

      tmpjson :=  tjsonObject(json.GetValue('Phrases'+IntToStr(i1)));
      assert(tmpJson <> nil,'TMyPhrasesJSON нет фразы для '+'Phrases'+IntToStr(i1));
      if tmpjson = nil then break;
      Phrases[i1] := TMyPhrase.Create;
      Phrases[i1].LoadFromJSONObject(tmpjson);
   end;

end;

function TMyPhrasesJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
  json: tjsonobject;
begin
  json :=  TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONStr), 0) as TJSONObject;
  result := true;
  if json=nil  then begin
   result := false;
  end else LoadFromJsonObject(json);
end;

function TMyPhrasesJSON.SaveToJSONObject: tjsonObject;
var
 json : tjsonobject;
 i1 : integer;
begin
 json := tjsonobject.Create;
 addVariableToJson(json,'Top',Top);
//    Top : integer;
 addVariableToJson(json,'Bottom',Bottom);
//    Bottom : integer;
 addVariableToJson(json,'Count',Count);
//    Count : integer;
   for i1 := Low(Phrases) to High(Phrases) do begin
      json.AddPair('Phrases'+IntToStr(i1),Phrases[i1].SaveToJSONObject)
   end;
 result := json;

end;

function TMyPhrasesJSON.SaveToJSONStr: string;
begin
  result := SaveToJSONObject.ToString;
end;

{ TMyWventJSON }


{ TRectJSON }

function TRectJSON.LoadFromJSONObject(JSON: tjsonobject): boolean;
begin
 Top := GetVariableFromJson(json,'Top',Top);
 Bottom := GetVariableFromJson(json,'Bottom',Bottom);
 left := GetVariableFromJson(json,'Left',left);
 Right := GetVariableFromJson(json,'Right',Right);

end;

function TRectJSON.LoadFromJSONstr(JSONstr: string): boolean;
var
  json: tjsonobject;
begin
  json :=  TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSONStr), 0) as TJSONObject;
  result := true;
  if json=nil  then begin
   result := false;
  end else LoadFromJsonObject(json);
end;

function TRectJSON.SaveToJSONObject: tjsonObject;
var
 json : tjsonobject;
begin
 json := tjsonobject.Create;
 addVariableToJson(json,'Top',Top);
 addVariableToJson(json,'Bottom',Bottom);
 addVariableToJson(json,'Left',left);
 addVariableToJson(json,'Right',Right);
 result := json;
end;

function TRectJSON.SaveToJSONStr: string;
begin
  result := SaveToJSONObject.ToString;
end;
//===========SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs=============================
//========================  END Helpers для классов. Сохранения в JSON и загрузка ==
//==============================================================================

//==============================================================================
//========================  Класс TMyPhrase   ==================================
//==============================================================================
Constructor TMyPhrase.Create;
begin
  inherited;
  name        := '';
  Text        := '';
  data        := 0;
  Command     := '';
  Tag         := 0;
  Rect.Left   := 0;
  Rect.Right  := 0;
  Rect.Top    := 0;
  Rect.Bottom := 0;
  Select      := false;
  workdata    := 'Text';
  ListName    := '';
  maxlength   := 10;
  visible     := true;
end;

Destructor TMyPhrase.Destroy;
begin
  Freemem(@name);
  Freemem(@Text);
  Freemem(@data);
  Freemem(@Command);
  Freemem(@Tag);
  Freemem(@Rect);
  Freemem(@Select);
  Freemem(@workdata);
  Freemem(@Listname);
  Freemem(@maxlength);
  Freemem(@visible);
  inherited;
end;

Procedure TMyPhrase.WriteToStream(F : TStream);
begin
   WriteBufferStr(F, Name);
   WriteBufferStr(F, Text);
   F.WriteBuffer(Data, SizeOf(Data));
   WriteBufferStr(F, Command);
   F.WriteBuffer(Tag, SizeOf(Tag));
   F.WriteBuffer(Rect.Top, SizeOf(Rect.Top));
   F.WriteBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
   F.WriteBuffer(Rect.Left, SizeOf(Rect.Left));
   F.WriteBuffer(Rect.Right, SizeOf(Rect.Right));
   F.WriteBuffer(Select, SizeOf(Select));
   WriteBufferStr(F, WorkData);
   WriteBufferStr(F, ListName);
   F.WriteBuffer(Maxlength, SizeOf(Maxlength));
   F.WriteBuffer(Visible, SizeOf(Visible));
end;

Procedure TMyPhrase.ReadFromStream(F : TStream);
begin
   ReadBufferStr(F, Name);
   ReadBufferStr(F, Text);
   F.ReadBuffer(Data, SizeOf(Data));
   ReadBufferStr(F, Command);
   F.ReadBuffer(Tag, SizeOf(Tag));
   F.ReadBuffer(Rect.Top, SizeOf(Rect.Top));
   F.ReadBuffer(Rect.Bottom, SizeOf(Rect.Bottom));
   F.ReadBuffer(Rect.Left, SizeOf(Rect.Left));
   F.ReadBuffer(Rect.Right, SizeOf(Rect.Right));
   F.ReadBuffer(Select, SizeOf(Select));
   ReadBufferStr(F, WorkData);
   ReadBufferStr(F, ListName);
   F.ReadBuffer(Maxlength, SizeOf(Maxlength));
   F.ReadBuffer(Visible, SizeOf(Visible));
end;

//==============================================================================
//========================  Класс TMyPhrases   ==================================
//==============================================================================
Constructor TMyPhrases.Create;
begin
  inherited;
  Top := 0;
  Bottom := 0;
  Count := 0;
end;

Destructor TMyPhrases.Destroy;
begin
  Freemem(@Top);
  Freemem(@Bottom);
  Freemem(@Count);
  Freemem(@Phrases);
  inherited;
end;

procedure TMyPhrases.Clear;
var i : integer;
begin
  for i:=Count-1 downto 0 do begin
    Phrases[i].FreeInstance;
  end;
  Count:=0;
  Setlength(Phrases,Count);
end;

Procedure TMyPhrases.WriteToStream(F : tStream);
var i : integer;
begin
  F.WriteBuffer(Top, SizeOf(Top));
  F.WriteBuffer(Bottom, SizeOf(Bottom));
  F.WriteBuffer(Count, SizeOf(Count));
  for i:=0 to Count-1 do Phrases[i].WriteToStream(F);
end;

Procedure TMyPhrases.ReadFromStream(F : tStream);
var i : integer;
begin
  F.ReadBuffer(Top, SizeOf(Top));
  F.ReadBuffer(Bottom, SizeOf(Bottom));
  clear;
  F.ReadBuffer(Count, SizeOf(Count));
  for i:=0 to Count-1 do begin
    Setlength(Phrases,i+1);
    Phrases[i] := TMyPhrase.Create;
    Phrases[i].ReadFromStream(F);
  end;
end;

//==============================================================================
//=========================  Класс TMyEvent   ==================================
//==============================================================================
Constructor TMyEvent.Create;
begin
  inherited;
  IDEvent := -1;
  Color := clSilver;
  FontColor := TLZoneNamesFontColor;
  FontSize := TLZoneNamesFontSize;
  FontSizeSub := TLZoneNamesFontSize-4;
  FontName := TLZoneNamesFontName;
  SafeZone := 10;
  //Transition := 0;
  Editing := false;
  Select := false;
  //Discription := '';
  Start := 0;
  Finish:= 0;
  Count := 0;
end;

Destructor TMyEvent.Destroy;
begin
  Freemem(@Color);
  Freemem(@IDEvent);
  Freemem(@FontColor);
  Freemem(@FontSize);
  Freemem(@FontSizeSub);
  Freemem(@FontName);
  Freemem(@SafeZone);
  //Freemem(@Transition);
  Freemem(@Editing);
  Freemem(@Select);
  //Freemem(@Discription);
  Freemem(@Start);
  Freemem(@Finish);
  Freemem(@Count);
  Freemem(@Rows);
  inherited;
end;

function TMyEvent.AddRow : integer;
begin
  count:=count+1;
  Setlength(Rows,count);
  Rows[count-1]:= TMyPhrases.Create;
  result := count-1;
end;

function TMyEvent.AddPhrase(ARow : integer; Name, TypeDt : string; maxlen : integer) : integer;
begin
  Rows[ARow].Count:=Rows[ARow].Count+1;
  Setlength(Rows[ARow].Phrases,Rows[ARow].Count);
  Rows[ARow].Phrases[Rows[ARow].Count-1] := TMyPhrase.Create;
  Rows[ARow].Phrases[Rows[ARow].Count-1].name := Name;
  Rows[ARow].Phrases[Rows[ARow].Count-1].maxlength := maxlen;
  Rows[ARow].Phrases[Rows[ARow].Count-1].WorkData := TypeDt;
  result := Rows[ARow].Count-1;
  //setrectareas;
end;

function TMyEvent.FindPhrase(Name : string) : tpoint;
var i, j : integer;
begin
  Result.X:=-1;
  Result.Y:=-1;
  for i:=0 to count-1 do begin
    for j:=0 to Rows[i].Count-1 do begin
      if trim(lowercase(Rows[i].Phrases[j].Name))=trim(lowercase(Name)) then begin
        Result.X:=i;
        Result.Y:=j;
        exit;
      end;
    end;
  end;
end;

procedure TMyEvent.EventSelectFalse;
var i, j : integer;
begin
  for i:=0 to count-1 do
    for j:=0 to Rows[i].Count-1 do Rows[i].Phrases[j].Select:=false;
end;

function TMyEvent.SelectionPhrase : string;
var i, j : integer;
begin
  Result:='';
  for i:=0 to count-1 do begin
    for j:=0 to Rows[i].Count-1 do begin
      if Rows[i].Phrases[j].Select then begin
        Result := Rows[i].Phrases[j].Name;
        exit;
      end;
    end;
  end;
end;

procedure TMyEvent.SetPhraseText(Name,Text : string);
var ps : tpoint;
begin
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Rows[ps.X].Phrases[ps.Y].Text:=Text;
  //setrectareas;
end;

procedure TMyEvent.SetPhraseType(Name,TypeData : string);
var ps : tpoint;
begin
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Rows[ps.X].Phrases[ps.Y].WorkData:=TypeData;
end;

procedure TMyEvent.SetPhraseListName(Name,ListName : string);
var ps : tpoint;
begin
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Rows[ps.X].Phrases[ps.Y].ListName:=ListName;
  //setrectareas;
end;

procedure TMyEvent.SetPhraseData(Name : string; Data : longint);
var ps : tpoint;
begin
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Rows[ps.X].Phrases[ps.Y].data:=Data;
  //setrectareas;
end;

procedure TMyEvent.SetPhraseCommand(Name : string; Command : widestring);
var ps : tpoint;
begin
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Rows[ps.X].Phrases[ps.Y].Command:=Command;
  //setrectareas;
end;

procedure TMyEvent.SetPhraseVisible(Name : string; visible : boolean);
var ps : tpoint;
begin
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Rows[ps.X].Phrases[ps.Y].Visible:=Visible;
  //setrectareas;
end;

procedure TMyEvent.SetPhraseTag(Name : string; Tag : integer);
var ps : tpoint;
begin
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Rows[ps.X].Phrases[ps.Y].Tag:=Tag;
  //setrectareas;
end;

function TMyEvent.ReadPhraseText(Name : string) : string;
var ps : tpoint;
begin
  Result:='';
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Result := Rows[ps.X].Phrases[ps.Y].Text;
end;

function TMyEvent.ReadPhraseData(Name : string) : longint;
var ps : tpoint;
begin
  Result:=0;
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Result := Rows[ps.X].Phrases[ps.Y].Data;
end;

function TMyEvent.ReadPhraseCommand(Name : string) : widestring;
var ps : tpoint;
begin
  Result:='';
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Result := Rows[ps.X].Phrases[ps.Y].Command;
end;

function TMyEvent.ReadPhraseTag(Name : string) : integer;
var ps : tpoint;
begin
  Result:=0;
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Result := Rows[ps.X].Phrases[ps.Y].Tag;
end;

function TMyEvent.ReadPhraseType(Name : string) : string;
var ps : tpoint;
begin
  Result:='';
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Result := Rows[ps.X].Phrases[ps.Y].WorkData;
end;

function TMyEvent.ReadPhraseListName(Name : string) : string;
var ps : tpoint;
begin
  Result:='';
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Result := Rows[ps.X].Phrases[ps.Y].ListName;
end;

function TMyEvent.PhraseIsVisible(Name : string) : boolean;
var ps : tpoint;
begin
  Result:=false;
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Result := Rows[ps.X].Phrases[ps.Y].Visible;
end;

procedure TMyEvent.Clear;
var i : integer;
begin
  for i:=count-1 downto 0 do begin
    Rows[i].Clear;
    Rows[i].FreeInstance;
  end;
  Count:=0;
  Setlength(Rows,Count);
end;

procedure TMyEvent.Assign(Event : TMyEvent);
var i, j, rw, pr : integer;
begin
  IDEvent := Event.IDEvent;
  Color := Event.Color;
  FontColor := Event.FontColor;
  FontSize := Event.FontSize;
  FontSizeSub := Event.FontSizeSub;
  FontName := Event.FontName;
  SafeZone := Event.SafeZone;
  //Transition := Event.Transition;
  Editing := Event.Editing;
  Select := Event.Select;
  //Discription := Event.Discription;
  Start := Event.Start;
  Finish:= Event.Finish;
  Clear;
  For i:=0 to Event.Count-1 do begin
    rw:=AddRow;
    for j:=0 to Event.Rows[i].Count-1 do begin
      AddPhrase(rw,Event.Rows[i].Phrases[j].Name,Event.Rows[i].Phrases[j].workdata,Event.Rows[i].Phrases[j].maxlength);
      Rows[i].Phrases[j].Select:=Event.Rows[i].Phrases[j].Select;
      //Rows[i].Phrases[j].workdata:=Event.Rows[i].Phrases[j].workdata;
      Rows[i].Phrases[j].maxlength:=Event.Rows[i].Phrases[j].maxlength;
      Rows[i].Phrases[j].visible:=Event.Rows[i].Phrases[j].visible;
      SetPhraseText(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Text);
      SetPhraseData(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Data);
      SetPhraseCommand(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Command);
      SetPhraseTag(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Tag);
      SetPhraseType(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].WorkData);
      SetPhraseListName(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].ListName);
    end;
  end;
end;

procedure TMyEvent.SetEvents(Event : TMyEvent);
var i, j, rw, pr : integer;
begin
  //IDEvent := Event.IDEvent;
  Color := Event.Color;
  FontColor := Event.FontColor;
  FontSize := Event.FontSize;
  FontSizeSub := Event.FontSizeSub;
  FontName := Event.FontName;
  SafeZone := Event.SafeZone;
  //Transition := Event.Transition;
  Editing := false;
  Select := false;
  //Discription := Event.Discription;
  //Start := Event.Start;
  //Finish:= Event.Finish;
  Clear;
  For i:=0 to Event.Count-1 do begin
    rw:=AddRow;
    for j:=0 to Event.Rows[i].Count-1 do begin
      AddPhrase(rw,Event.Rows[i].Phrases[j].Name,Event.Rows[i].Phrases[j].workdata,Event.Rows[i].Phrases[j].maxlength);
      Rows[i].Phrases[j].Select:=Event.Rows[i].Phrases[j].Select;
      //Rows[i].Phrases[j].workdata:=Event.Rows[i].Phrases[j].workdata;
      Rows[i].Phrases[j].maxlength:=Event.Rows[i].Phrases[j].maxlength;
      Rows[i].Phrases[j].visible:=Event.Rows[i].Phrases[j].visible;
      SetPhraseText(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Text);
      SetPhraseData(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Data);
      SetPhraseCommand(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Command);
      SetPhraseTag(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Tag);
      SetPhraseType(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].WorkData);
      SetPhraseListName(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].ListName);
    end;
  end;
end;

function mystr(ch : char; len: integer) : string;
var i : integer;
begin
  result := '';
  for i:=0 to len-1 do result:=result + ch;
end;

procedure TMyEvent.setrectareas(TypeTL : TTypeTimeline);
var i, j : integer;
    bmp : tbitmap;
    dzn, zn, mzn : integer;
    hgh, hdlt, lft, tp, bt : integer;
begin
  //if TLHeights.Edit <=20 then hdlt := 0 else hdlt := 2;
  //tp := hdlt;
  //hgh := Trunc((TLHeights.Edit - (hdlt * 5)) / 4);
       case TypeTL of
  tldevice : begin
               hgh := Trunc((TLHeights.Edit / 9));
               Rows[0].Top:=5;
               Rows[0].Bottom:=Rows[0].Top + 3 * hgh - 6;
               tp := Rows[0].Bottom + 2;
               for i:=1 to Count-1 do begin
                 Rows[i].Top:=tp;
                 Rows[i].Bottom:=Rows[i].Top + 2 * hgh-1;
                 tp := Rows[i].Bottom + 1;
               end;
             end;
  tlmedia  : begin
               hgh := Trunc((TLHeights.Edit / 4));
               Rows[0].Top:=4;
               Rows[0].Bottom:=Rows[0].Top + hgh - 4;
               tp := Rows[0].Bottom;
               for i:=1 to Count-1 do begin
                 Rows[i].Top:=tp;
                 Rows[i].Bottom:=Rows[i].Top + hgh - 4;
                 tp := Rows[i].Bottom;
               end;
             end;
  tltext   : begin
               hgh := Trunc((TLHeights.Edit / 4));
               Rows[0].Top:=3;
               Rows[0].Bottom := Rows[0].Top + 2 * hgh - 6;
               tp := Rows[0].Bottom + 3;
               for i:=1 to Count-1 do begin
                 Rows[i].Top:=tp;
                 Rows[i].Bottom:=Rows[i].Top + hgh - 3;
                 tp := Rows[i].Bottom;
               end;
             end;
       end;


  bmp :=tbitmap.Create;
  try
    bmp.Width:=100;
    bmp.Height:=100;
    bmp.Canvas.Font.Name := FontName;
    bmp.Canvas.Font.Size := FontSize;
    For i:=0 to count-1 do begin
      lft := safezone + 5;
      if (i=0) and (TypeTL=tltext) then lft:= safezone;
      For j:=0 to Rows[i].Count-1 do begin
        //Rows[i].Phrases[j].Text
        //zn := mylength(Rows[i].Phrases[j], bmp);
        if trim(Rows[i].Phrases[j].Text)<>''
          then zn:=bmp.Canvas.TextWidth(Rows[i].Phrases[j].Text)
          else zn := bmp.Canvas.TextWidth(mystr('0', Rows[i].Phrases[j].maxlength));

        //if zn=-1 then zzn := bmp.Canvas.TextWidth(mystr('0', Rows[i].Phrases[j].maxlength));
        Rows[i].Phrases[j].Rect.Left:=lft;
        Rows[i].Phrases[j].Rect.Top:=Rows[i].Top;
        Rows[i].Phrases[j].Rect.Right:=lft + zn;
        Rows[i].Phrases[j].Rect.Bottom:=Rows[i].Bottom;
        lft:=lft + zn + 12;
      end; //for j
      bmp.Canvas.Font.Size := FontSizeSub;
    end; //for i
  finally
    bmp.Free;
  end;
end;

procedure  TMyEvent.SetDependentField(tdf : TDependentField);
var name, tpobj, tpfld : string;
begin
  name := trim(lowercase(tdf.Name));
  tpobj := trim(lowercase(tdf.TypeObject));
  tpfld := trim(lowercase(tdf.TypeField));
  if tpobj='event' then begin
    if Name='color' then Color := tdf.Data
    else if Name='fontcolor' then FontColor := tdf.Data
    else if Name='fontsize' then FontSize := tdf.Data
    else if Name='fontsizeSub' then FontSizeSub := tdf.Data
    else if Name='fontname' then FontName := tdf.Text
    else if Name='safezone' then SafeZone := tdf.Data
    else if Name='editing' then Editing := tdf.Bool
    else if Name='select' then Select := tdf.Bool
    else if Name='start' then Start := tdf.Data
    else if Name='finish' then Finish := tdf.Data;
    exit;
  end;
  if tpobj='phrase' then begin
    SetPhraseVisible(tdf.Name,tdf.Visible);
    SetPhraseData(tdf.Name,tdf.Data);

  end;
end;

procedure  TMyEvent.WriteToStream(F : TStream);
var i : integer;
begin
  F.WriteBuffer(IDEvent, SizeOf(IDEvent));
  F.WriteBuffer(Color, SizeOf(Color));
  F.WriteBuffer(FontColor, SizeOf(FontColor));
  F.WriteBuffer(FontSize, SizeOf(FontSize));
  F.WriteBuffer(FontSizeSub, SizeOf(FontSizeSub));
  WriteBufferStr(F, FontName);
  F.WriteBuffer(SafeZone, SizeOf(SafeZone));
  F.WriteBuffer(Editing, SizeOf(Editing));
  F.WriteBuffer(Select, SizeOf(Select));
  F.WriteBuffer(Start, SizeOf(Start));
  F.WriteBuffer(Finish, SizeOf(Finish));
  F.WriteBuffer(Count, SizeOf(Count));
  for i := 0 to Count-1 do Rows[i].WriteToStream(F);
end;

procedure  TMyEvent.ReadFromStream(F : TStream);
var i : integer;
begin
  F.ReadBuffer(IDEvent, SizeOf(IDEvent));
  F.ReadBuffer(Color, SizeOf(Color));
  F.ReadBuffer(FontColor, SizeOf(FontColor));
  F.ReadBuffer(FontSize, SizeOf(FontSize));
  F.ReadBuffer(FontSizeSub, SizeOf(FontSizeSub));
  ReadBufferStr(F, FontName);
  F.ReadBuffer(SafeZone, SizeOf(SafeZone));
  F.ReadBuffer(Editing, SizeOf(Editing));
  F.ReadBuffer(Select, SizeOf(Select));
  F.ReadBuffer(Start, SizeOf(Start));
  F.ReadBuffer(Finish, SizeOf(Finish));
  clear;
  F.ReadBuffer(Count, SizeOf(integer));
  for i := 0 to Count-1 do begin
    Setlength(Rows, i+1);
    Rows[i] := TMyPhrases.Create;
    Rows[i].ReadFromStream(F);
  end;
end;

initialization
//Событие тайм-линии устройств
EventDevice := TMyEvent.Create;
ERow:=EventDevice.AddRow;
EPhr:=EventDevice.AddPhrase(ERow,'Device','Device',8);
EPhr:=EventDevice.AddPhrase(ERow,'Text','Template',255);

ERow:=EventDevice.AddRow;
EPhr:=EventDevice.AddPhrase(ERow,'Command','Text',10);
      EventDevice.Rows[ERow].Phrases[EPhr].ListName:='GVG100Command';
EPhr:=EventDevice.AddPhrase(ERow,'Duration','ShortTimeCode',5);
EPhr:=EventDevice.AddPhrase(ERow,'Set','Data',5);

ERow:=EventDevice.AddRow;
EPhr:=EventDevice.AddPhrase(ERow,'ShortNum','Text',10);

ERow:=EventDevice.AddRow;
EPhr:=EventDevice.AddPhrase(ERow,'Comment','Template',1000);

//Событие тайм-линии текст
EventText := TMyEvent.Create;
ERow:=EventText.AddRow;
EPhr:=EventText.AddPhrase(ERow,'Text','Text',255);

ERow:=EventText.AddRow;
EPhr:=EventText.AddPhrase(ERow,'Color','Text',20);
      EventText.Rows[ERow].Phrases[EPhr].ListName:='MainColors';
//EPhr:=EventText.AddPhrase(ERow,'Duration','Data',5);
//EPhr:=EventText.AddPhrase(ERow,'Set','Data',5);

ERow:=EventText.AddRow;
EPhr:=EventText.AddPhrase(ERow,'Comment','Text',255);

//Событие тайм-линии медиа
EventMedia := TMyEvent.Create;
//ERow:=EventMedia.AddRow;
//EPhr:=EventMedia.AddPhrase(ERow,'ShortNom','Text',10);
ERow:=EventMedia.AddRow;
EPhr:=EventMedia.AddPhrase(ERow,'Marker1','Text',10);
ERow:=EventMedia.AddRow;
EPhr:=EventMedia.AddPhrase(ERow,'Marker2','Text',10);

end.
