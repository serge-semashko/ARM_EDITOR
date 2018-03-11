unit UMyInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Math ,FastDIB, FastFX, FastSize, FastFiles, FConvert, FastBlend, Utils, StrUtils,
  Vcl.Buttons;

type
  TOneRec = class
    Name : string;
    RTN : trect;
    Text : string;
    RTT : trect;
    constructor  create(SName, SText : string);
    destructor  destroy;
  end;

  TMyInfo = class
    Count : integer;
    Options : array of TOneRec;
    function Add(Name, Text : string) : integer;
    procedure SetData(Name, Text : string); overload;
    procedure SetData(index : integer; Text : string); overload;
    procedure Draw(cv : tcanvas; HeightRow : integer);
    procedure clear;
    constructor create;
    destructor destroy;
  end;

var
  InfoProtocol : TMyInfo;
  Info422  : TMyInfo;
  InfoIP   : TMyInfo;
  InfoWEB  : TMyInfo;
  InfoPort : TMyInfo;

procedure UpdateInfoProtocol;
procedure UpdateInfo422;
procedure UpdateInfoIP;

implementation
uses ucommon;


constructor TMyInfo.create;
begin
  Count:=0;
end;

procedure TMyInfo.clear;
var i : integer;
begin
  for i:=Count-1 downto 0 do begin
    Options[Count-1].FreeInstance;
    Count := Count-1;
    setlength(Options,Count);
  end;
  Count:=0;
end;

destructor TMyInfo.destroy;
begin
  clear;
  freemem(@Count);
  freemem(@Options);
end;

function TMyInfo.Add(Name, Text : string) : integer;
begin
  Count := Count+1;
  setlength(Options, Count);
  Options[Count-1] := TOneRec.create(Name, Text);
  result := Count-1;
end;

procedure TMyInfo.SetData(Name, Text : string);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if ansilowercase(trim(Options[i].Name))=ansilowercase(trim(Name)) then begin
      Options[i].Text:=Text;
      exit;
    end;
  end;
end;

procedure TMyInfo.SetData(index : integer; Text : string);
begin
  Options[index].Text:=Text;
end;

procedure TMyInfo.Draw(cv : tcanvas; HeightRow : integer);
var tmp : tfastdib;
    i, wdth, hght, rowhght, top, ps : integer;
begin
   //init(cv);
   tmp := tfastdib.Create;
   try
     wdth := cv.ClipRect.Right-cv.ClipRect.Left;
     hght := cv.ClipRect.Bottom-cv.ClipRect.Top;
     tmp.SetSize(wdth, hght, 32);
     tmp.Clear(TColorToTfcolor(ProgrammColor));
     tmp.SetBrush(bs_solid,0,colortorgb(ProgrammColor));
     tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
     tmp.SetTransparent(true);
     tmp.SetPen(ps_Solid,1,ColorToRGB(ProgrammFontColor));
     tmp.SetTextColor(ColorToRGB(ProgrammFontColor));
     tmp.SetFont(ProgrammFontName, MTFontSize);
     top := 10;
     ps := (wdth - 10) div 2;
     for i:=0 to Count-1 do begin
       Options[i].RTN.Left:=5;
       Options[i].RTN.Right:=Options[i].RTN.Left+ps-5;
       Options[i].RTN.Top:=top;
       top := top + HeightRow;
       Options[i].RTN.Bottom:=top;
       Options[i].RTT.Left:=Options[i].RTN.Right+5;
       Options[i].RTT.Right:=wdth-5;
       Options[i].RTT.Top:=Options[i].RTN.Top;
       Options[i].RTT.Bottom:=Options[i].RTN.Bottom;
       tmp.DrawText(Options[i].Name,Options[i].RTN,DT_VCENTER or DT_SINGLELINE);
       tmp.DrawText(Options[i].Text,Options[i].RTT,DT_VCENTER or DT_SINGLELINE);
     end;
     tmp.SetTransparent(false);
     tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
     cv.Refresh;
   finally
     tmp.Free;
     tmp:=nil;
   end;
end;

constructor  TOneRec.create(SName, SText : string);
begin
  Name := SName;
  initrect(RTN);
  Text := SText;
  initrect(RTT);
end;

destructor  TOneRec.destroy;
begin
  freemem(@Name);
  freemem(@RTN);
  freemem(@Text);
  freemem(@RTT);
end;

procedure UpdateInfoProtocol;
begin
  InfoProtocol.SetData(0,URLServer);
  InfoProtocol.SetData(2,INFOTypeDevice);
  InfoProtocol.SetData(3,INFOVendor);
  InfoProtocol.SetData(4,INFODevice);
  InfoProtocol.SetData(5,INFOProt);
  InfoProtocol.Options[6].Name:=INFOName1;
  InfoProtocol.SetData(6,INFOText1);
  InfoProtocol.Options[7].Name:=INFOName2;
  InfoProtocol.SetData(7,INFOText2);
  InfoProtocol.Options[8].Name:=INFOName3;
  InfoProtocol.SetData(8,INFOText3);
end;

procedure UpdateInfo422;
begin
  Info422.SetData(1,Port422Name);
  Info422.SetData(2,Port422Speed);
  Info422.SetData(3,Port422Bits);
  Info422.SetData(4,Port422Parity);
  Info422.SetData(5,Port422Stop);
  Info422.SetData(6,Port422Flow);
end;

procedure UpdateInfoIP;
begin
  InfoIP.SetData(1, IPAdress);
  InfoIP.SetData(2, IPPort);
  InfoIP.SetData(3,IPLogin);
  InfoIP.SetData(4,IPPassword);
end;

initialization
  InfoProtocol := TMyInfo.create;
  InfoProtocol.Add('URL WEB �������:',URLServer);
  InfoProtocol.Add('������:','�� ��������');
  InfoProtocol.Add('��� ������������:',INFOTypeDevice);
  InfoProtocol.Add('�������������:',INFOVendor);
  InfoProtocol.Add('����������:',INFODevice);
  InfoProtocol.Add('��������:',INFOProt);
  InfoProtocol.Add(INFOName1,INFOText1);
  InfoProtocol.Add(INFOName2,INFOText2);
  InfoProtocol.Add(INFOName3,INFOText3);

  Info422 := TMyInfo.create;
  Info422.Add('��� ��������','RS232/422');
  Info422.Add('��� �����:',Port422Name);
  Info422.Add('��������:',Port422Speed);
  Info422.Add('���-�� ���:',Port422Bits);
  Info422.Add('��������',Port422Parity);
  Info422.Add('���� ���',Port422Stop);
  Info422.Add('�����. �������:',Port422Flow);
  Info422.Add('Status','�� ��������');

  InfoIP  := TMyInfo.create;
  InfoIP.Add('��� ��������:','IP �����');
  InfoIP.Add('IP �����:', IPAdress);
  InfoIP.Add('IP ����:', IPPort);
  InfoIP.Add('�������:',IPLogin);
  InfoIP.Add('������:',IPPassword);
  InfoIP.Add('������:','�� ��������');

  InfoWEB  := TMyInfo.create;
  InfoWEB.Add('���� ��� �������:','00:00:00:00');
  InfoWEB.Add('���� ��� �����. (�����������):','00:00:00:00  (00:00:00:00)');
  InfoWEB.Add('������� ����:','');
  InfoWEB.Add('���������� ������� (�������):','');
  InfoWEB.Add('����� ���������������:','');
  InfoWEB.Add('������������� �������:','');
  InfoWEB.Add('��������� ������������:','');
  InfoWEB.Add('�� ������������ ��������','00:00:00:00');
  InfoWEB.Add('������� ����������:','');
  InfoWEB.Add('�������:','');
  InfoWEB.Add('�������:','');
  InfoWEB.Add('��������� ����������:','');
  InfoWEB.Add('�������:','');
  InfoWEB.Add('�������:','');

  InfoPort := TMyInfo.create;
  InfoPort.Add('','');
  InfoPort.Add('����� ��������:','');
  InfoPort.Add('���������� ������:','');
  InfoPort.Add('','');
  InfoPort.Add('','');
  InfoPort.Add('','');

  InfoPort.Add('����� ���������:','');
  InfoPort.Add('���������� ������:','');
  InfoPort.Add('','');
  InfoPort.Add('','');
  InfoPort.Add('','');
  InfoPort.Add('���������� ����:','');
  InfoPort.Add('��������� ����','');

finalization
  infoprotocol.FreeInstance;
  infoprotocol := nil;

  info422.FreeInstance;
  info422 := nil;

  infoIP.FreeInstance;
  infoIP := nil;

  infoWEB.FreeInstance;
  infoWEB := nil;

  infoPort.FreeInstance;
  infoPort := nil;
end.
