unit UTimeline;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Grids, ImgList, UIMGButtons, Spin, ucommon,
  umyevents;

type
  //TTypeTimeline = (tldevice, tltext, tlmedia);

  TTimelineOptions = Class(TObject)
    public
    TypeTL : TTypeTimeline;
    NumberBmp : integer;
    Name : string;
    UserLock : string;
    IDTimeline : longint;
    Block : boolean;
    Status : integer;
    CountDev   : Integer;
    DevEvents : array[0..31] of tmyevent;
    MediaEvent : tmyevent;
    TextEvent : tmyevent;
    MediaColor : tcolor;
    TextColor : tcolor;
    CharDuration : integer;
    EventDuration : integer;
    procedure Assign(obj : TTimelineOptions);
    procedure Clear;
    Procedure WriteToStream(F : tStream);
    Procedure ReadFromStream(F : tStream);
    constructor Create;
    destructor  Destroy; override;
  end;

  TFEditTimeline = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    pnDevice: TPanel;
    pnMedia: TPanel;
    pnText: TPanel;
    Edit1: TEdit;
    Label2: TLabel;
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    pnDelete: TPanel;
    Label4: TLabel;
    Bevel1: TBevel;
    Image2: TImage;
    Edit2: TEdit;
    SpeedButton3: TSpeedButton;
    Label7: TLabel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Label8: TLabel;
    Label9: TLabel;
    SpinEdit2: TSpinEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Edit3: TEdit;
    SpinEdit3: TSpinEdit;
    Label13: TLabel;
    Bevel2: TBevel;
    Image3: TImage;
    ColorDialog1: TColorDialog;
    SpeedButton6: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    Bevel3: TBevel;
    Image4: TImage;
    sbTextEvent: TSpeedButton;
    SpeedButton7: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure sbTextEventClick(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    { Private declarations }
    Procedure DrawIcons(ttl : TTypeTimeline; Selection : integer);
    function SelectIcons(X,Y : integer) : integer;
  public
    { Public declarations }
  end;

var
  FEditTimeline: TFEditTimeline;
  //BTNSDEVICE : TBTNSPanel;//TIMGPanelButtons;
  OPTTimeline : TTimelineOptions;
  IconsLocation : array[1..10] of Trect;
  DefaultColors : array[0..31] of tcolor = ($0000cf5b,$00d8a520,$00d877d0,$002a7169,$00aa2669,$00aa26d5,$002fadd5,$0023c987,
                                            $004288a8,$001d7487,$00fa00ff,$00ffff00,$0084c75c,$00288613,$0089819f,$00a8b19f,
                                            $00bae2bf,$00aceae1,$009b9913,$00b89cd6,$0028d1e9,$009dc4d9,$009dc4f7,$001862bc,
                                            $0020788f,$000aacff,$007e9fcd,$007e8398,$00d1adb8,$00e3d4d2,$006eebbb,$005d801f);
procedure EditTimeline(ARow : integer);
procedure GridDrawCellTimeline(Grid : tstringgrid; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
Procedure DeleteTimeline(ARow : integer);
procedure InitBTNSDEVICE(cv : tcanvas; obj : tobject; BTNSDEVICE : TBTNSPanel);
Procedure InitGridTimelines;
function SetTypeTimeline(ps : integer) : TTypeTimeline;

implementation

uses UMain, UButtonOptions, uinitforms, umymessage, ugrtimelines, umyfiles;

{$R *.dfm}

Procedure TFEditTimeline.DrawIcons(ttl : TTypeTimeline; Selection : integer);
var i, clx, nx, deltx, delty, wx, hy : integer;
    nm : string;
    rt : trect;
begin
  Image2.Canvas.FillRect(Image2.Canvas.ClipRect);
      Case ttl of
  tldevice: nm:='Tools';
  tltext  : nm:='Text';
  tlmedia : nm:='Media';
      end;
  clx:=Image2.Width div 10;
  if clx < 24 then begin
    deltx:=2;
    wx:=clx - 4;
  end else begin
    wx:=20;
    deltx:=(clx-20) div 2;
  end;
  delty:=(Image2.Height - wx) div 2;
  nx:=0;
  for i:=1 to 10 do begin
    IconsLocation[i].Left:=nx + deltx;
    IconsLocation[i].Right:=IconsLocation[i].Left + wx;
    nx:=IconsLocation[i].Right + deltx;
    IconsLocation[i].Top:=delty;
    IconsLocation[i].Bottom:=IconsLocation[i].Top + wx;
  end;

  for i:=1 to 10 do begin
  //nm + inttostr(i);
    if i=selection then begin
      rt.Left:=IconsLocation[i].Left-deltx;
      rt.Right:=IconsLocation[i].Right+deltx;
      rt.Top:=IconsLocation[i].Top-delty;
      rt.Bottom:=IconsLocation[i].Bottom+delty;
      Image2.Canvas.Rectangle(rt);
    end;
    LoadBMPFromRes(Image2.Canvas, IconsLocation[i], wx, wx, nm + inttostr(i));
  end;
end;

function TFEditTimeline.SelectIcons(X,Y : integer) : integer;
var i:integer;
begin
  result:=-1;
  for i:=1 to 10 do begin
    if (X >= IconsLocation[i].Left) and (X <= IconsLocation[i].Right)
       and (Y >= IconsLocation[i].Top) and (Y <= IconsLocation[i].Bottom) then begin
      result:=i;
      DrawIcons((OPTTimeline as TTimelineOptions).TypeTL,i);
      (OPTTimeline as TTimelineOptions).NumberBmp:=i;
      exit;
    end;
  end;
end;

function SetOffset(LenCV, CntElem, LenElem, ZnDel : integer) : integer;
begin
  result := (LenCV - CntElem*LenElem - (CntElem-1)*ZnDel) div 2;
end;

procedure InitBTNSDEVICE(cv : tcanvas; obj : tobject; BTNSDEVICE : TBTNSPanel{TIMGPanelButtons});
var i, j, cntbtns, cntx, cnty, cntend, szbtns, hghtbtn, arow, abtn : integer;
begin
  BTNSDEVICE.Clear;
  cv.Brush.Color:=BTNSDEVICE.BackGround;//FormsColor;
  cv.FillRect(cv.ClipRect);
  //cv.Pen.Color := FormsFontColor;
  //cv.Font.Color := FormsFontColor;
  //cv.Font.Size :=  FormsFontSize + 2;
  BTNSDEVICE.Top:=10;
  BTNSDEVICE.Bottom:=10;
  BTNSDEVICE.Left:=5;
  BTNSDEVICE.Right:=5;
  //BTNSDEVICE.BackGround:=FormsColor;
  //BTNSDEVICE.DeltY:=5;
  if FormsFontName <> '' then cv.Font.Name := FormsFontName;
  if obj=nil then exit;
  if not (obj is TTimelineOptions) then exit;

  cntbtns := (obj as TTimelineOptions).CountDev;

  szbtns:=0;
  for i:=0 to cntbtns-1
    do if cv.TextWidth((obj as TTimelineOptions).DevEvents[i].ReadPhraseText('Device')) > szbtns
         then szbtns:=cv.TextWidth((obj as TTimelineOptions).DevEvents[i].ReadPhraseText('Device'));
  szbtns:=szbtns + 20;
  if szbtns<50 then szbtns:=50;
  cntx:=(cv.ClipRect.Right-cv.ClipRect.Left - 15) div (szbtns + 5);
  cnty:=cntbtns div cntx;

  for i:=0 to cnty-1 do begin
    arow:=BTNSDEVICE.AddRow;
    for j:=0 to cntx-1 do begin
      ABtn := ARow * cntx + j;
      BTNSDEVICE.Rows[ARow].AddButton((obj as TTimelineOptions).DevEvents[ABtn].ReadPhraseText('Device'),imnone);
    end;
    //Rows[i].Count:=cntx;
  end;

  cntend:=cntbtns mod cntx;
  if cntend <> 0 then begin
  //  BTNSDEVICE.Count:=cnty;

  //end else begin
    ARow:=BTNSDEVICE.AddRow;//:=cnty + 1;
    for i:=0 to cntend-1 do begin
      ABtn := ARow * cntx + i;
      BTNSDEVICE.Rows[ARow].AddButton((obj as TTimelineOptions).DevEvents[ABtn].ReadPhraseText('Device'),imnone);
    end;
  end;

  if BTNSDEVICE.Count <> 0 then begin
    hghtbtn:=(cv.ClipRect.Bottom - cv.ClipRect.Top - BTNSDEVICE.Top -
               BTNSDEVICE.Bottom - BTNSDEVICE.Interval * (BTNSDEVICE.Count-1)) div BTNSDEVICE.Count;
    if hghtbtn > 30 then hghtbtn:=30;
  end else hghtbtn:=30;



  BTNSDEVICE.HeightRow:=hghtbtn;
  BTNSDEVICE.Top:=SetOffset(cv.ClipRect.Bottom-cv.ClipRect.Top,BTNSDEVICE.Count,hghtbtn,BTNSDEVICE.Interval);
  for i:=0 to BTNSDEVICE.Count -1 do begin
    //BTNSDEVICE.Rows[i].Interval:=5;
    BTNSDEVICE.Rows[i].AutoSize:=false;
    for j:=0 to BTNSDEVICE.Rows[i].Count-1 do begin
      //BTNSDEVICE.Rows[i].Name[j]:=(obj as TTimelineOptions).DevNames[i*cntx + j];
      BTNSDEVICE.Rows[i].Btns[j].Color:=(obj as TTimelineOptions).DevEvents[i*cntx + j].Color;
      BTNSDEVICE.Rows[i].Btns[j].Font.Size:=FormsFontSize + 2;
      BTNSDEVICE.Rows[i].Btns[j].Font.Color:=FormsFontColor;
      BTNSDEVICE.Rows[i].Btns[j].Width:=szbtns;
      //BTNSDEVICE.Rows[i].Btns[j].Image:=imnone;
      BTNSDEVICE.Rows[i].Btns[j].Visible:=true;
      BTNSDEVICE.Rows[i].Btns[j].Enable:=true;
      //BTNSDEVICE.Rows[i].Btns[j].Height:=hghtbtn; //cv.TextHeight('0')+10;
      //BTNSDEVICE.Rows[i].Btns[j].Radius:=hghtbtn+5; //cv.TextHeight('0') + 15;
    end;
  end;
  
  BTNSDEVICE.Draw(cv);
end;

{ Events[ARow].SetPhraseText('Text', '');
               Events[ARow].SetPhraseCommand('Text', '');
               Events[ARow].SetPhraseText('Command', 'Cut');
               Events[ARow].SetPhraseVisible('Duration',false);
               Events[ARow].SetPhraseVisible('Set',false);
               Events[ARow].SetPhraseText('ShortNum', inttostr(ARow + 1));
               Events[ARow].SetPhraseText('Comment', ''); }

constructor  TTimelineOptions.Create;
var i:integer;
begin
  inherited;
  TypeTL:=tldevice;
  CountDev:=16;
  IDTimeline := 0;
  NumberBmp:=1;
  Name:='Устройства';
  Block:=false;
  Status:=4;
  MediaColor := DefaultMediaColor;
  TextColor := TLParameters.ForeGround;
  CharDuration := 100;
  EventDuration := 25;
  for i:=0 to 31 do begin
    DevEvents[i] := tmyevent.Create;
    DevEvents[i].Assign(EventDevice);
    DevEvents[i].Color := DefaultColors[i];
    DevEvents[i].SetPhraseText('Device',inttostr(i+1));
    DevEvents[i].SetPhraseData('Device',i+1);
    //DevNames[i]:=IntToStr(i+1);
    //DevColors[i]:=DefaultColors[i];
  end;
  MediaEvent := tmyevent.Create;
  MediaEvent.Assign(EventMedia);
  MediaEvent.Color:=DefaultMediaColor;
  TextEvent := tmyevent.Create;
  TextEvent.Assign(EventText);
  TextEvent.Color:=TLParameters.ForeGround;
end;

destructor TTimelineOptions.Destroy;
var i : integer;
begin
  FreeMem(@TypeTL);
  FreeMem(@CountDev);
  FreeMem(@IDTimeline);
  FreeMem(@NumberBmp);
  FreeMem(@Name);
  FreeMem(@UserLock);
  //FreeMem(@DevNames);
  //FreeMem(@DevColors);
  FreeMem(@Block);
  FreeMem(@Status);
  FreeMem(@MediaColor);
  FreeMem(@TextColor);
  FreeMem(@CharDuration);
  FreeMem(@EventDuration);
  MediaEvent.Free;
  TextEvent.Free;
  for i:=31 to 0 do DevEvents[i].Free;
  FreeMem(@DevEvents);
  inherited Destroy;
end;

Procedure TTimelineOptions.Clear;
var i : integer;
begin
  TypeTL:=tldevice;
  CountDev:=16;
  NumberBmp:=1;
  Name:='';
  Block:=false;
  Status:=4;
  UserLock:='';
  MediaColor := DefaultMediaColor;
  TextColor := DefaultTextColor;
  CharDuration := 100;
  EventDuration := 25;
  for i:=0 to 31 do begin
    DevEvents[i].Assign(EventDevice);
    DevEvents[i].Color := DefaultColors[i];
    DevEvents[i].SetPhraseText('Device',inttostr(i+1));
    DevEvents[i].SetPhraseData('Device',i+1);
    //DevNames[i]:=IntToStr(i+1);
    //DevColors[i]:=DefaultColors[i];
  end;
  MediaEvent.Assign(EventMedia);
  MediaEvent.Color:=DefaultMediaColor;
  TextEvent.Assign(EventText);
  TextEvent.Color:=TLParameters.ForeGround;
end;

procedure TTimelineOptions.Assign(obj : TTimelineOptions);
var i : integer;
begin
  TypeTL:=obj.TypeTL;
  CountDev:=obj.CountDev;
  NumberBmp:=obj.NumberBmp;
  Name:=obj.Name;
  IDTimeline:=obj.IDTimeline;
  Block:=obj.Block;
  Status:=obj.Status;
  MediaColor := obj.MediaColor;
  TextColor := obj.TextColor;
  CharDuration := obj.CharDuration;
  EventDuration := obj.EventDuration;
  for i:=0 to 31 do begin
    DevEvents[i].Assign(obj.DevEvents[i]);
    //DevNames[i]:=obj.DevNames[i];
    //DevColors[i]:=obj.DevColors[i];
  end;
  MediaEvent.Assign(obj.MediaEvent);
  TextEvent.Assign(obj.TextEvent);
end;

Procedure TTimelineOptions.WriteToStream(F : tStream);
var i : Longint;
begin
  if TypeTL=tldevice then i:=0;
  if TypeTL=tltext   then i:=1;
  if TypeTL=tlmedia  then i:=2;
  //i := ord(TypeTL);
  F.WriteBuffer(i, SizeOf(i));
  F.WriteBuffer(NumberBmp, SizeOf(NumberBmp));
  WriteBufferStr(F, Name);
  WriteBufferStr(F, UserLock);
  F.WriteBuffer(IDTimeline, SizeOf(IDTimeline));
  F.WriteBuffer(Block, SizeOf(Block));
  F.WriteBuffer(Status, SizeOf(Status));
  F.WriteBuffer(CountDev, SizeOf(CountDev));
  F.WriteBuffer(MediaColor, SizeOf(MediaColor));
  F.WriteBuffer(TextColor, SizeOf(TextColor));
  F.WriteBuffer(CharDuration, SizeOf(CharDuration));
  F.WriteBuffer(EventDuration, SizeOf(EventDuration));
  F.WriteBuffer(CountDev, SizeOf(CountDev));
  MediaEvent.WriteToStream(F);
  TextEvent.WriteToStream(F);
  For i:=0 to 31 do DevEvents[i].WriteToStream(F);
end;

function SetTypeTimeline(ps : integer) : TTypeTimeline;
begin
         case ps of
  ord(tldevice) : result := tldevice;
  ord(tltext)   : result := tltext;
  ord(tlmedia)  : result := tlmedia;
         end;
end;

Procedure TTimelineOptions.ReadFromStream(F : tStream);
var i : integer;
begin
  F.ReadBuffer(i, SizeOf(i));
  TypeTL:=SetTypeTimeline(i);
  F.ReadBuffer(NumberBmp, SizeOf(NumberBmp));
  ReadBufferStr(F, Name);
  ReadBufferStr(F, UserLock);
  F.ReadBuffer(IDTimeline, SizeOf(IDTimeline));
  F.ReadBuffer(Block, SizeOf(Block));
  F.ReadBuffer(Status, SizeOf(Status));
  F.ReadBuffer(CountDev, SizeOf(CountDev));
  F.ReadBuffer(MediaColor, SizeOf(MediaColor));
  F.ReadBuffer(TextColor, SizeOf(TextColor));
  F.ReadBuffer(CharDuration, SizeOf(CharDuration));
  F.ReadBuffer(EventDuration, SizeOf(EventDuration));
  F.ReadBuffer(CountDev, SizeOf(CountDev));
  //MediaEvent := TMyEvent.Create;
  MediaEvent.ReadFromStream(F);
  //TextEvent := TMyEvent.Create;
  TextEvent.ReadFromStream(F);
  For i:=0 to 31 do begin
    //DevEvents[i] := TMyEvent.Create;
    DevEvents[i].ReadFromStream(F);
  end;
end;

function CanDelete(ARow : integer) : boolean;
var typetl : TTypeTimeline;
    i, cnt : integer;
begin
  result := false;
  with Form1.GridTimeLines do begin
    typetl:=(Objects[0,ARow] as ttimelineoptions).TypeTL;
    cnt:=0;
    for i:=1 to RowCount-1
      do if (Objects[0,i] as ttimelineoptions).TypeTL = typetl then cnt:=cnt+1;
    if cnt > 1 then result:=true;
  end; //with
end;

Procedure DeleteTimeline(ARow : integer);
var i : integer;
    msg : string;
begin
  if ARow < 1 then exit;
  if ARow > Form1.GridTimeLines.RowCount-1 then exit;

  if  not CanDelete(ARow) then begin
             case (Form1.GridTimeLines.Objects[0,ARow] as ttimelineoptions).TypeTL of
    tldevice : msg:='Невозможно выполнить данное удаление, '
                     + #10#13 +'так как проект должен содержать хотя бы одну'
                     + #10#13 +'тайм-линию устройств.';
    tltext   : msg:='Невозможно выполнить данное удаление, '
                     + #10#13 +'так как проект должен содержать хотя бы одну'
                     + #10#13 +'текстовую тайм-линию.';
    tlmedia  : msg:='Невозможно  выполнить данное удаление, '
                     + #10#13 +'так как проект должен содержать хотя бы одну'
                     + #10#13 +'тайм-линию медиа данных.';
             end; //case
    MyTextMessage('', msg, 1);
    exit;
  end;
  if not MyTextMessage('Вопрос', 'Вы действительно хотите удалить тайм-линию?', 2) then exit;
  with Form1.GridTimeLines do begin
    for i:=ARow to RowCount-2 do begin
      (Objects[0,i] as ttimelineoptions).Assign(Objects[0,i+1] as ttimelineoptions);
    end;//for
    Objects[0,RowCount-1]:=nil;
    RowCount:=RowCount-1;
  end;
  Form1.GridTimeLines.Repaint;
end;

function IDTimelineExists(ID : integer) : boolean;
var i : integer;
begin
  result := false;
  with Form1 do begin
    for i:=1 to Form1.GridTimeLines.RowCount-1 do begin
      if  GridTimelines.Objects[0,i] is TTimelineOptions then begin
        if (GridTimelines.Objects[0,i] as TTimelineOptions).IDTimeline=ID then begin
          result:=true;
          exit;
        end;
      end;
    end;
  end;
end;

function SetIDTimeline : integer;
begin
  IDTL:=IDTL+1;
  while IDTimelineExists(IDTL) do IDTL:=IDTL+1;
  result:=IDTL;
end;

function HowMuchTimelines(ttl : TTypeTimeline) : integer;
var i : integer;
begin
  with Form1.GridTimeLines do begin
    result:=0;
    for i:=1 to RowCount-1
     do if objects[0,i] is TTimelineOptions
        then if (objects[0,i] as TTimelineOptions).TypeTL=ttl
             then result:=result+1;
  end;
end;

function FindPositionTimeline : integer;
var ps : integer;
begin
  result:=-1;
           case OPTTimeline.TypeTL of
  tldevice : result:=HowMuchTimelines(tldevice) + 1;
  tltext   : result:=HowMuchTimelines(tldevice) + HowMuchTimelines(tltext) + 1;
  tlmedia  : result:=HowMuchTimelines(tldevice) + HowMuchTimelines(tltext) + HowMuchTimelines(tlmedia) + 1;
           end;
end;

procedure SetValuesTimeline;
begin
           case (OPTTimeline as TTimelineOptions).TypeTL of
  tldevice : begin
               OPTTimeline.Name:=FEditTimeline.Edit1.Text;
               OPTTimeline.CountDev:=FEditTimeline.SpinEdit1.Value;
             end;
  tltext   : begin
               OPTTimeline.Name:=FEditTimeline.Edit3.Text;
               OPTTimeline.EventDuration:=FEditTimeline.SpinEdit2.Value;
               OPTTimeline.CharDuration:=FEditTimeline.SpinEdit3.Value;
               OPTTimeline.TextColor:=FEditTimeline.Image3.Canvas.Brush.Color;
             end;
  tlmedia  : begin
               OPTTimeline.Name:=FEditTimeline.Edit4.Text;
               OPTTimeline.MediaColor:=FEditTimeline.Image4.Canvas.Brush.Color;
             end;
           end;
end;

function CheckedQuantityTimelines : boolean;
begin
  result:=true;
           case OPTTimeline.TypeTL of
  tldevice : if HowMuchTimelines(tldevice) + 1 > TLMaxDevice then begin
               MyTextMessage('','Максимальное количество тайм-линий устройств '
                                + ' в данной версии программы не должно быть больше '
                                + inttostr(TLMaxDevice) + '.',1);
               result:=false;
             end;
  tltext   : if HowMuchTimelines(tltext) + 1 > TLMaxText then begin
               MyTextMessage('','Максимальное количество текстовых тайм-линий '
                               + ' в данной версии программы не должно быть больше '
                               + inttostr(TLMaxText) + '.',1);
               result:=false;
             end;
  tlmedia  : if HowMuchTimelines(tlmedia) + 1 > TLMaxMedia then begin
               MyTextMessage('','Максимальное количество медиа тайм-линий '
                                + ' в данной версии программы не должно быть больше '
                                + inttostr(TLMaxMedia) + '.',1);
               result:=false;
             end;
           end;
end;

procedure EditTimeline(ARow : integer);
var i, cellpos : integer;
begin
  FEditTimeline.Panel1.Visible:=true;;
  FEditTimeline.Label1.Visible:=true;
  FEditTimeline.Label1.Caption:='Тип тайм-линии:';
  FEditTimeline.SpeedButton1.Caption:='Сохранить';
  FEditTimeline.Image2.Visible:=true;
  FEditTimeline.Label7.Visible:=true;
  if ARow <> -1 then begin
    OPTTimeline.Assign(Form1.GridTimelines.Objects[0,ARow] as TTimelineOptions);
    FEditTimeline.Caption:='Редактирование тайм-линии.';
    FEditTimeline.ComboBox1.Visible:=False;
  end else begin
    OPTTimeline.Clear;
    FEditTimeline.Caption:='Новая тайм-линия.';
    FEditTimeline.ComboBox1.Visible:=true;
    FEditTimeline.Edit1.Text:='';
    FEditTimeline.Edit3.Text:='';
    FEditTimeline.Edit4.Text:='';
  end;



  FEditTimeline.SpinEdit1.Value:=OPTTimeline.CountDev;
  FEditTimeline.DrawIcons((OPTTimeline as TTimelineOptions).TypeTL, (OPTTimeline as TTimelineOptions).NumberBmp);
      case (OPTTimeline as TTimelineOptions).TypeTL of
  tldevice : begin
               FEditTimeline.pnDevice.Visible:=true;
               FEditTimeline.pnText.Visible:=false;
               FEditTimeline.pnMedia.Visible:=false;
               FEditTimeline.pnDelete.Visible:=false;
               FEditTimeline.ComboBox1.ItemIndex:=0;
               FEditTimeline.Edit1.Text:=OPTTimeline.Name;
               If ARow<>-1 then FEditTimeline.Label1.Caption:='Тип тайм-линии: Устройства';

             end;
  tltext   : begin
               FEditTimeline.pnDevice.Visible:=false;
               FEditTimeline.pnText.Visible:=true;
               FEditTimeline.pnMedia.Visible:=false;
               FEditTimeline.pnDelete.Visible:=false;
               FEditTimeline.ComboBox1.ItemIndex:=1;
               FEditTimeline.Edit3.Text:=OPTTimeline.Name;
               //FEditTimeline.SpinEdit2.Value:=OPTTimeline.EventDuration;
               //FEditTimeline.SpinEdit3.Value:=OPTTimeline.CharDuration;
               //FEditTimeline.Image3.Canvas.Brush.Color:=OPTTimeline.TextColor;
               If ARow<>-1 then FEditTimeline.Label1.Caption:='Тип тайм-линии: Текст';
             end;
  tlmedia  : begin
               FEditTimeline.pnDevice.Visible:=false;
               FEditTimeline.pnText.Visible:=false;
               FEditTimeline.pnMedia.Visible:=true;
               FEditTimeline.pnDelete.Visible:=false;
               FEditTimeline.ComboBox1.ItemIndex:=2;
               FEditTimeline.Edit4.Text:=OPTTimeline.Name;
               //FEditTimeline.Image4.Canvas.Brush.Color:=OPTTimeline.MediaColor;
               If ARow<>-1 then FEditTimeline.Label1.Caption:='Тип тайм-линии: Media';
             end;
  else      exit;
      end;
  FEditTimeline.SpinEdit2.Value:=OPTTimeline.EventDuration;
  FEditTimeline.SpinEdit3.Value:=OPTTimeline.CharDuration;
  FEditTimeline.Image3.Canvas.Brush.Color:=OPTTimeline.TextColor;
  FEditTimeline.Image4.Canvas.Brush.Color:=OPTTimeline.MediaColor;
  FEditTimeline.Image3.Canvas.FillRect(FEditTimeline.Image3.Canvas.ClipRect);
  FEditTimeline.Image4.Canvas.FillRect(FEditTimeline.Image4.Canvas.ClipRect);

  FEditTimeline.ShowModal;
  If FEditTimeline.ModalResult=mrOk then begin
    SetValuesTimeline;
    if ARow=-1 then begin
      if not CheckedQuantityTimelines then exit;
      cellpos:=FindPositionTimeline;
      Form1.GridTimeLines.RowCount:=Form1.GridTimeLines.RowCount + 1;
      if not (Form1.GridTimeLines.Objects[0,Form1.GridTimeLines.RowCount-1] is TTimelineOptions)
        then Form1.GridTimeLines.Objects[0,Form1.GridTimeLines.RowCount-1]:=TTimelineOptions.Create;
      for i:=Form1.GridTimeLines.RowCount-1 downto cellpos do begin
        (Form1.GridTimeLines.Objects[0,i] as TTimelineOptions).Assign((Form1.GridTimeLines.Objects[0,i-1] as TTimelineOptions));
      end;

      (Form1.GridTimeLines.Objects[0,cellpos] as TTimelineOptions).Assign(OPTTimeline);
      Form1.GridTimeLines.Row:=cellpos;
      IDTL:=SetIDTimeline;

      (Form1.GridTimeLines.Objects[0,cellpos] as TTimelineOptions).IDTimeline:=IDTL;
    end else begin
      //SetValuesTimeline;
      (Form1.GridTimeLines.Objects[0,ARow] as TTimelineOptions).Assign(OPTTimeline);
    end;
  end;
end;

procedure TFEditTimeline.SpeedButton2Click(Sender: TObject);
begin
  FEditTimeline.ModalResult:=mrCancel;
  //if colordialog1.Execute then;
end;

procedure GridDrawCellTimeline(Grid : tstringgrid; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
Var RT : TRect;
    strs, nm : string;
    deltx, delty, TypeTL : integer;
    oldfontsize : integer;
    oldfontcolor : tcolor;
begin
  if ARow=0 then begin
    grid.Canvas.Font.Style:=grid.Canvas.Font.Style + [fsBold];
          case ACol of
    1 : begin
          deltx:= (grid.ColWidths[ACol] - grid.Canvas.TextWidth('Тайм-линии')) div 2;
          deltY:= (grid.RowHeights[ARow] - grid.Canvas.TextHeight('Тайм-линии')) div 2;
          grid.Canvas.TextOut(Rect.Left + 10{deltx},Rect.Top + delty,'Тайм-линии');
        end;
    2 : begin
          deltx:= (grid.ColWidths[ACol] - grid.Canvas.TextWidth('Кол-во')) div 2;
          deltY:= (grid.RowHeights[ARow] - grid.Canvas.TextHeight('Кол-во')) div 2;
          grid.Canvas.TextOut(Rect.Left + deltx,Rect.Top + delty,'Кол-во');
        end;
          end;//case
    exit;
  end;
  if ARow=Grid.Selection.Top then begin
    grid.Canvas.Brush.Color:=ProgrammColor;
    grid.Canvas.Pen.Color:=$aaaaaa;
    grid.Canvas.Pen.Width:=1;
    grid.Canvas.Pen.Style:=psClear;
    grid.Canvas.FillRect(Rect);
  end;
  grid.Canvas.Brush.Color:=ProgrammColor;
  grid.Canvas.Pen.Color:=$aaaaaa;
  grid.Canvas.Pen.Width:=1;
  deltx:=(grid.ColWidths[ACol] - 20) div 2;
      delty:=(grid.RowHeights[ARow] - 20) div 2;
      RT.Left:=Rect.Left+deltx;
      RT.Top:=Rect.Top+delty;
      RT.Right:=Rect.Right-deltx;
      RT.Bottom:=Rect.Bottom-delty;
       Case ACol of
  0: Begin
          Case (Grid.Objects[0,ARow] as TTimelineOptions).TypeTL of
       tldevice: nm:='Tools';
       tltext  : nm:='Text';
       tlmedia : nm:='Media';
          end;//case
       nm:=nm + inttostr((Grid.Objects[0,ARow] as TTimelineOptions).NumberBmp);
       LoadBMPFromRes(grid.Canvas, rect, 20, 20, nm);
     End;
  1: Begin
       if (Grid.Objects[0,ARow] is TTimelineOptions) then begin
         //deltx:= (grid.ColWidths[ACol] - grid.Canvas.TextWidth((Grid.Objects[0,ARow] as TTimelineOptions).Name)) div 2;
         deltY:= (grid.RowHeights[ARow] - grid.Canvas.TextHeight((Grid.Objects[0,ARow] as TTimelineOptions).Name)) div 2;
         grid.Canvas.TextOut(Rect.Left + 10,Rect.Top + delty,(Grid.Objects[0,ARow] as TTimelineOptions).Name);
       end;
     End;
  2: Begin
       if (Grid.Objects[0,ARow] is TTimelineOptions) then begin
         strs:='';
         if (Grid.Objects[0,ARow] as TTimelineOptions).TypeTL = tldevice
          then strs:=inttostr((Grid.Objects[0,ARow] as TTimelineOptions).CountDev);
         deltx:= (grid.ColWidths[ACol] - grid.Canvas.TextWidth(strs)) div 2;
         deltY:= (grid.RowHeights[ARow] - grid.Canvas.TextHeight(strs)) div 2;
         grid.Canvas.TextOut(Rect.Left + deltx,Rect.Top + delty,strs);
       end;
     End;
       end;
  //end;
end;

procedure TFEditTimeline.FormCreate(Sender: TObject);
var RT : TRect;
begin
  InitEditTimeline;
end;

procedure TFEditTimeline.SpinEdit1Change(Sender: TObject);
begin
  if OPTTimeline=nil then exit;
  if not (OPTTimeline is TTimelineOptions) then exit;
  if SpinEdit1.Text='' then exit;
  if SpinEdit1.Text='-' then exit;
  if SpinEdit1.Text='+' then exit;
  if SpinEdit1.Value < 1 then SpinEdit1.Value:=1;
  if SpinEdit1.Value > 32 then SpinEdit1.Value:=32;
  (OPTTimeline as TTimelineOptions).CountDev:=SpinEdit1.Value;
  BTNSDEVICE.BackGround:=FormsColor;
  InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
end;

procedure TFEditTimeline.SpeedButton1Click(Sender: TObject);
begin
           case OPTTimeline.TypeTL of
  tldevice : if trim(Edit1.Text)<> '' then ModalResult:=mrOk else ActiveControl:=Edit1;
  tltext   : if trim(Edit3.Text)<> '' then ModalResult:=mrOk else ActiveControl:=Edit3;
  tlmedia  : if trim(Edit4.Text)<> '' then ModalResult:=mrOk else ActiveControl:=Edit4;
           end;
end;

procedure TFEditTimeline.Image1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var zn : integer;
begin
  if Button<>mbLeft then exit;
  zn:=BTNSDEVICE.ClickButton(Image1.Canvas,X,Y);
   case zn of
0..31: begin
         EditButtonsOptions(zn,OPTTimeline);
         InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
       end;
   end;
end;

procedure TFEditTimeline.ComboBox1Change(Sender: TObject);
begin
     Case ComboBox1.ItemIndex of
0: begin
     FEditTimeline.pnDevice.Visible:=true;
     FEditTimeline.pnText.Visible:=false;
     FEditTimeline.pnMedia.Visible:=false;
     FEditTimeline.pnDelete.Visible:=false;
     (OPTTimeline as TTimelineOptions).TypeTL:=tldevice;
     DrawIcons(tldevice, 1);
   end;
1: begin
     FEditTimeline.pnDevice.Visible:=false;
     FEditTimeline.pnText.Visible:=true;
     FEditTimeline.pnMedia.Visible:=false;
     FEditTimeline.pnDelete.Visible:=false;
     (OPTTimeline as TTimelineOptions).TypeTL:=tltext;
     DrawIcons(tltext, 1);
   end;
2: begin
     FEditTimeline.pnDevice.Visible:=false;
     FEditTimeline.pnText.Visible:=false;
     FEditTimeline.pnMedia.Visible:=true;
     FEditTimeline.pnDelete.Visible:=false;
     (OPTTimeline as TTimelineOptions).TypeTL:=tlmedia;
     DrawIcons(tlmedia, 1);
   end;
     End;
end;

procedure TFEditTimeline.SpeedButton3Click(Sender: TObject);
var i : integer;
begin
  for i:=0 to 31 do OPTTimeline.DevEvents[i].SetPhraseText('Device', Trim(Edit2.Text) + OPTTimeline.DevEvents[i].ReadPhraseText('Device'));
  InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
end;

procedure TFEditTimeline.SpeedButton5Click(Sender: TObject);
var i : integer;
begin
  for i:=0 to 31 do OPTTimeline.DevEvents[i].SetPhraseText('Device',IntToStr(i+1));
  InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
end;

procedure TFEditTimeline.SpeedButton4Click(Sender: TObject);
var i : integer;
    s : string;
begin
   for i:=0 to 31 do begin
     s:=OPTTimeline.DevEvents[i].ReadPhraseText('Device');
     OPTTimeline.DevEvents[i].SetPhraseText('Device',StringReplace(s,Edit2.Text,'', [ rfReplaceAll, rfIgnoreCase ]));
   end;
  InitBTNSDEVICE(FEditTimeline.Image1.Canvas, OPTTimeline, BTNSDEVICE);
end;

procedure TFEditTimeline.Image2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button<>mbLeft then exit;
  SelectIcons(X,Y);
end;

procedure TFEditTimeline.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var pos:integer;
begin
  btnsdevice.MouseMove(Image1.Canvas,X,Y);
end;

Procedure InitGridTimelines;
begin
  with Form1 do begin
    GridTimeLines.RowCount:=4;
    GridTimeLines.Height:=GridTimelines.DefaultRowHeight * (TLMaxDevice + TLMaxText + TLMaxMedia+1) + 20;
    GridTimeLines.Top:=Panel2.ClientRect.Bottom - imgButtonsControlProj.Height - GridTimeLines.Height;

    if not (GridTimeLines.Objects[0,1] is TTimelineOptions) then GridTimeLines.Objects[0,1]:=TTimelineOptions.Create;
    (GridTimeLines.Objects[0,1] as TTimelineOptions).TypeTL:=tldevice;
    (GridTimeLines.Objects[0,1] as TTimelineOptions).Name:='Камеры';
    (GridTimeLines.Objects[0,1] as TTimelineOptions).CountDev:=32;
    IDTL:=IDTL + 1;
    (GridTimeLines.Objects[0,1] as TTimelineOptions).IDTimeline:=IDTL;

    if not (GridTimeLines.Objects[0,2] is TTimelineOptions) then GridTimeLines.Objects[0,2]:=TTimelineOptions.Create;
    (GridTimeLines.Objects[0,2] as TTimelineOptions).TypeTL:=tltext;
    (GridTimeLines.Objects[0,2] as TTimelineOptions).Name:='Текст песни';
    IDTL:=IDTL + 1;
    (GridTimeLines.Objects[0,2] as TTimelineOptions).IDTimeline:=IDTL;

    if not (GridTimeLines.Objects[0,3] is TTimelineOptions) then GridTimeLines.Objects[0,3]:=TTimelineOptions.Create;
    (GridTimeLines.Objects[0,3] as TTimelineOptions).TypeTL:=tlmedia;
    (GridTimeLines.Objects[0,3] as TTimelineOptions).Name:='Media';
    IDTL:=IDTL + 1;
    (GridTimeLines.Objects[0,3] as TTimelineOptions).IDTimeline:=IDTL;

    GridTimeLines.ColWidths[1]:=180;
    GridTimeLines.ColWidths[2]:=GridTimeLines.Width-GridTimeLines.ColWidths[0] - GridTimeLines.ColWidths[1];
  end;
end;

procedure TFEditTimeline.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then SpeedButton1Click(nil);
  if key=27 then ModalResult:=mrOk;
end;

procedure TFEditTimeline.SpeedButton6Click(Sender: TObject);
begin
  MyTextMessage('','В текущей версии данный модуль не поддерживается.',1);
end;

procedure TFEditTimeline.Image4Click(Sender: TObject);
begin
  if ColorDialog1.Execute then begin
    Image4.Canvas.Brush.Color:=ColorDialog1.Color;
    Image4.Canvas.FillRect(Image4.Canvas.ClipRect);
  end;
end;

procedure TFEditTimeline.sbTextEventClick(Sender: TObject);
begin
  if EditButtonsOptions(-1,OPTTimeline) then begin
    Image3.Canvas.Brush.Color:=OPTTimeline.TextEvent.Color;
    Image3.Canvas.FillRect(Image3.Canvas.ClipRect);
  end;
end;

procedure TFEditTimeline.SpeedButton7Click(Sender: TObject);
begin
  if EditButtonsOptions(-1,OPTTimeline) then begin
    Image4.Canvas.Brush.Color:=OPTTimeline.MediaEvent.Color;
    Image4.Canvas.FillRect(Image3.Canvas.ClipRect);
  end;
end;

end.
