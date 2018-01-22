unit UMyEvents;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, UTimeline;

Type

  TMyPhrase = Class(TObject)
    public
    name     : string;
    Text     : string;
    Data     : longint;
    Command  : widestring;
    Tag      : integer;
    Rect     : TRect;
    Select   : boolean;
    workdata : string;
    maxlength: integer;
    visible  : boolean;
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
    Transition : integer;
    Editing : boolean;
    Select : boolean;
    Discription : string;
    Start : longint;
    Finish: longint;
    Count : integer;
    Rows : array of TMyPhrases;
    function AddRow : integer;
    function AddPhrase(ARow : integer; Name, TypeDt : string; maxlen : integer) : integer;
    function FindPhrase(Name : string) : tpoint;
    procedure SetPhraseText(Name,Text : string);
    procedure SetPhraseData(Name : string; Data : longint);
    procedure SetPhraseCommand(Name : string; Command : widestring);
    procedure SetPhraseTag(Name : string; Tag : integer);
    function ReadPhraseText(Name : string) : string;
    function ReadPhraseData(Name : string) : longint;
    function ReadPhraseCommand(Name : string) : widestring;
    function ReadPhraseTag(Name : string) : integer;
    procedure SetRectAreas;
    procedure Clear;
    procedure Assign(Event : TMyEvent);
    Constructor Create;
    Destructor  Destroy; override;
  end;

var
  EventDevice, EventText, EventMedia : TMyEvent;
  ERow, EPhr : integer;

implementation
uses umain, ucommon, udrawtimelines;

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
  Freemem(@maxlength);
  Freemem(@visible);
  inherited;
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
  FontSizeSub := TLZoneNamesFontSize-2;
  FontName := TLZoneNamesFontName;
  SafeZone := 10;
  Transition := 0;
  Editing := false;
  Select := false;
  Discription := '';
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
  Freemem(@Transition);
  Freemem(@Editing);
  Freemem(@Select);
  Freemem(@Discription);
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
  result := Rows[ARow].Count-1;
  setrectareas;
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

procedure TMyEvent.SetPhraseText(Name,Text : string);
var ps : tpoint;
begin
  ps := FindPhrase(Name);
  if (ps.x=-1) and (ps.y=-1) then exit;
  Rows[ps.X].Phrases[ps.Y].Text:=Text;
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
  Transition := Event.Transition;
  Editing := Event.Editing;
  Select := Event.Select;
  Discription := Event.Discription;
  Start := Event.Start;
  Finish:= Event.Finish;
  Clear;
  For i:=0 to Event.Count-1 do begin
    rw:=AddRow;
    for j:=0 to Event.Rows[i].Count-1 do begin
      AddPhrase(rw,Event.Rows[i].Phrases[j].Name,Event.Rows[i].Phrases[j].workdata,Event.Rows[i].Phrases[j].maxlength);
      Rows[i].Phrases[j].Select:=Event.Rows[i].Phrases[j].Select;
      //Rows[i].Phrases[j].workdata:=Event.Rows[i].Phrases[j].workdata;
      //Rows[i].Phrases[j].maxlength:=Event.Rows[i].Phrases[j].maxlength;
      Rows[i].Phrases[j].visible:=Event.Rows[i].Phrases[j].visible;
      SetPhraseText(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Text);
      SetPhraseData(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Data);
      SetPhraseCommand(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Command);
      SetPhraseTag(Event.Rows[i].Phrases[j].Name, Event.Rows[i].Phrases[j].Tag);
    end;
  end;
end;

procedure TMyEvent.setrectareas;
var i, j : integer;
    bmp : tbitmap;
    dzn, zn : integer;
    hdlt, lft, tp, bt : integer;

function mystr(ch : char; len: integer) : string;
var i : integer;
begin
  result := '';
  for i:=0 to len-1 do result:=result + ch;
end;

function mylength(phr : TMyPhrase; var bmp : tbitmap) : integer;
begin
  result := -1;
  if lowercase(trim(phr.workdata))='text' then begin
    if trim(phr.Text)<>'' then begin
       result:=bmp.Canvas.TextWidth(phr.Text);
    end;
    exit;
  end else if lowercase(trim(phr.workdata))='data' then begin
    result:=bmp.Canvas.TextWidth(inttostr(phr.data));
    exit;
  end else if lowercase(trim(phr.workdata))='command' then begin
    if trim(phr.Command)<>'' then result:=bmp.Canvas.TextWidth(phr.Command);
    exit;
  end else if lowercase(trim(phr.workdata))='tag' then begin
    result:=bmp.Canvas.TextWidth(inttostr(phr.Tag));
  end;
end;

begin
  if TLHeights.Edit <=10 then hdlt := 0
  else hdlt := (TLHeights.Edit - 4 *(Count + 1)) div count;
  tp := 4;
  for i:=0 to Count-1 do begin
    Rows[i].Top:=tp;
    Rows[i].Bottom:=Rows[i].Top + hdlt;
    tp := Rows[i].Bottom + 4;
  end;

  bmp :=tbitmap.Create;
  try
    bmp.Width:=100;
    bmp.Height:=100;
    bmp.Canvas.Font.Name := FontName;
    bmp.Canvas.Font.Size := FontSize;
    For i:=0 to count-1 do begin
      lft := safezone + 2;
      For j:=0 to Rows[i].Count-1 do begin
        zn := mylength(Rows[i].Phrases[j], bmp);
        if zn=-1 then zn := bmp.Canvas.TextWidth(mystr('0', Rows[i].Phrases[j].maxlength));
        Rows[i].Phrases[j].Rect.Left:=lft;
        Rows[i].Phrases[j].Rect.Top:=Rows[i].Top;
        Rows[i].Phrases[j].Rect.Right:=lft + zn;
        Rows[i].Phrases[j].Rect.Bottom:=Rows[i].Bottom;
        lft:=lft + zn + 2;
      end; //for j
      bmp.Canvas.Font.Size := FontSizeSub;
    end; //for i
  finally
    bmp.Free;
  end;
end;

initialization
//Событие тайм-линии устройств
EventDevice := TMyEvent.Create;
ERow:=EventDevice.AddRow;
EPhr:=EventDevice.AddPhrase(ERow,'Device','Text',8);
EPhr:=EventDevice.AddPhrase(ERow,'Text','Text',255);

ERow:=EventDevice.AddRow;
EPhr:=EventDevice.AddPhrase(ERow,'Command','Text',10);
EPhr:=EventDevice.AddPhrase(ERow,'Duration','Data',5);
EPhr:=EventDevice.AddPhrase(ERow,'Set','Data',5);

ERow:=EventDevice.AddRow;
EPhr:=EventDevice.AddPhrase(ERow,'ShortNum','Text',10);

ERow:=EventDevice.AddRow;
EPhr:=EventDevice.AddPhrase(ERow,'Comment','Text',1000);

//Событие тайм-линии устройств
EventText := TMyEvent.Create;
ERow:=EventText.AddRow;
EPhr:=EventText.AddPhrase(ERow,'Text','Text',255);

ERow:=EventText.AddRow;
EPhr:=EventText.AddPhrase(ERow,'Command','Text',10);
EPhr:=EventText.AddPhrase(ERow,'Duration','Data',5);
EPhr:=EventText.AddPhrase(ERow,'Set','Data',5);

ERow:=EventText.AddRow;
EPhr:=EventText.AddPhrase(ERow,'Comment','Text',100);

//Событие тайм-линии медиа
EventMedia := TMyEvent.Create;
ERow:=EventMedia.AddRow;
EPhr:=EventMedia.AddPhrase(ERow,'Marker','Text',10);
ERow:=EventMedia.AddRow;
EPhr:=EventMedia.AddPhrase(ERow,'Text','Text',25);

end.
