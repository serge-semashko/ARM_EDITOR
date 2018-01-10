unit USubtitrs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls;

Type
  TSubtitor = record
    Number : integer;
    NTK : longint;
    KTK : longint;
    Text : string;
  end;

procedure LoadSubtitrs;

implementation
uses umain, ucommon, ugrtimelines, umymessage, umyevents, utimeline;

function isInteger(zn : string) : boolean;
var res : longint;
begin
  result:=true;
  try
    res:=strtoint(zn);
  except
    result:=false;
  end;
end;

function StrToTimecode(stri : string) : longint;
var s, shh, smm, sss, sms : string;
    ps, i : integer;

begin
  s:=trim(stri);
  s:=StringReplace(s, '.', ':', [rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s, ',', ':', [rfReplaceAll, rfIgnoreCase]);
  ps := pos(':',s);
  shh:=copy(s,1,ps-1);
  if not isInteger(shh) then begin
    result :=-1;
    exit;
  end;

  s:=copy(s,ps+1,length(s));
  ps := pos(':',s);
  smm:=copy(s,1,ps-1);
  if not isInteger(smm) then begin
    result :=-1;
    exit;
  end;

  s:=copy(s,ps+1,length(s));
  ps := pos(':',s);
  sss:=copy(s,1,ps-1);
  sms:=copy(s,ps+1,length(s));
  if not isInteger(sss)  then begin
    result :=-1;
    exit;
  end;
  if not isInteger(sms) then begin
    result :=-1;
    exit;
  end;

  result := (strtoint(shh) * 3600 + strtoint(smm) * 60 + strtoint(sss)) * 25 + Round(strtoint(sms)/40);
end;

function SelectTimeCodes(stri : string; var sbt : tsubtitor) : boolean;
var s, s1, s2 : string;
    ps : integer;
begin
  result := true;
  try
  s:=trim(stri);
  ps:=pos(' ',s);
  s1:=trim(copy(s,1,ps));
  s:=trim(copy(s,ps,length(s)));
  ps:=pos(' ',s);
  s2:=trim(copy(s,ps,length(s)));
  sbt.NTK:=StrToTimecode(s1);
  sbt.KTK:=StrToTimecode(s2);
  if (sbt.NTK=-1) or (sbt.KTK=-1) then result:=false;
  except
    result:=false;
  end;
end;

procedure LoadSubtitrs;
var i : integer;
    lst, err : tstringlist;
    sbt : tsubtitor;
    nom : integer;
    s1, s2 : string;
    pstl : integer;
begin
  if not Form1.OpenDialog2.Execute then exit;
  err := tstringlist.Create;
  try
  err.Clear;
  lst := tstringlist.Create;
  try
    lst.Clear;
    //TLZone.TLEditor.Clear;
    pstl := TLZone.FindTimeline(TLZone.TLEditor.IDTimeline);
    TLZone.Timelines[pstl].Clear;
    lst.LoadFromFile(Form1.OpenDialog2.FileName);
//  ������ ������ ��������� ��������� �� ������ ������
    nom := 0;
    for i:=0 to lst.Count-1 do begin
       if trim(lst.Strings[i])='' then begin
         nom:=0;
         sbt.Number:=0;
         sbt.NTK:=0;
         sbt.KTK:=0;
         sbt.Text:='';
         continue;
       end;
       if trim(lst.Strings[i])<>'' then begin
           case nom of
        0: if not isInteger(lst.Strings[i]) then err.Add('������ ' + IntToStr(i) + ': ���������� ������������� ������ � ������� ��������');
        1: if not SelectTimeCodes(lst.Strings[i], sbt) then err.Add('������ ' + IntToStr(i) + ': ����������� ����� ������ ����-����');
        //else sbt.Text:=Trim(sbt.Text) + ' ' + trim(lst.Strings[i]);
           end; //case
        nom:=nom+1;
       end;
    end;
// ������ ������ ��������� ������ �������
    if err.Count<=0 then begin
      nom := 0;
      for i:=0 to lst.Count-1 do begin
        if trim(lst.Strings[i])='' then begin
          TLZone.Timelines[pstl].Count:=TLZone.Timelines[pstl].Count+1;
          setlength(TLZone.Timelines[pstl].Events,TLZone.Timelines[pstl].Count);
          TLZone.Timelines[pstl].Events[TLZone.Timelines[pstl].Count-1] := TMyEvent.Create;
          TLZone.Timelines[pstl].Events[TLZone.Timelines[pstl].Count-1].Assign((Form1.GridTimeLines.Objects[0,pstl+1] as TTimelineOptions).TextEvent);
          TLZone.Timelines[pstl].Events[TLZone.Timelines[pstl].Count-1].Start := sbt.NTK + TLParameters.Preroll;
          TLZone.Timelines[pstl].Events[TLZone.Timelines[pstl].Count-1].Finish := sbt.KTK + TLParameters.Preroll;
          TLZone.Timelines[pstl].Events[TLZone.Timelines[pstl].Count-1].SetPhraseText('Text',sbt.Text);
          //TLZone.Timelines[pstl].Events[TLZone.Timelines[pstl].Count-1].SetPhraseText('Color','White');
          TLZone.Timelines[pstl].Events[TLZone.Timelines[pstl].Count-1].SetPhraseTag('Text',sbt.Number);
          IDEvents := IDEvents + 1;
          TLZone.Timelines[pstl].Events[TLZone.Timelines[pstl].Count-1].IDEvent := IDEvents;

          nom:=0;
          sbt.Number:=0;
          sbt.NTK:=0;
          sbt.KTK:=0;
          sbt.Text:='';
          continue;
        end;
        if trim(lst.Strings[i])<>'' then begin
             case nom of
          0: sbt.Number:=strtoint(lst.Strings[i]);
          1: SelectTimeCodes(lst.Strings[i], sbt);
          else begin
                 sbt.Text:=Trim(sbt.Text) + ' ' + trim(lst.Strings[i]);
                 sbt.Text:=StringReplace(sbt.Text, '<i>', '', [rfReplaceAll, rfIgnoreCase]);
                 sbt.Text:=StringReplace(sbt.Text, '</i>', '', [rfReplaceAll, rfIgnoreCase]);
                 sbt.Text:=StringReplace(sbt.Text, '<b>', '', [rfReplaceAll, rfIgnoreCase]);
                 sbt.Text:=Trim(StringReplace(sbt.Text, '</b>', '', [rfReplaceAll, rfIgnoreCase]));
               end;
             end; //case
          nom:=nom+1;
        end;
      end;
      TLZone.TLEditor.Assign(TLZone.Timelines[pstl],pstl+1);
    end else begin
      s2:='';
      for i:=0 to err.Count-1 do s2:=s2+err.Strings[i] + #10#13;
      MyTextMessage('������ ������', s2, 1);
    end;
  finally
    lst.Free;
  end;
  finally
    err.Free;
  end;
end;

end.
