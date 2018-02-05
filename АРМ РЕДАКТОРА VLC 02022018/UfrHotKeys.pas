unit UfrHotKeys;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TMyHotKey = class
    Mode    : byte;
    Action  : string;
    Command : Word;
    mainkey : word;
    addkey1 : word;
    addkey2 : word;
    procedure Clear;
    procedure Assign(MHK : TMyHotKey);
    procedure WriteToStream(F : Tstream);
    procedure ReadFromStream(F : Tstream);
    Constructor Create;
    Destructor Destroy;
  end;

  TMyListHotKeys = class
    DefaultKeys : byte;
    Name        : string;
    Number      : integer;
    Count       : integer;
    List        : array of TMyHotKey;
    procedure Clear;
    procedure Assign(LHK : TMyListHotKeys);
    procedure AddString(s : string);
    procedure UpdateCommand(s : string; cmd1,cmd2 : word); overload;
    procedure UpdateCommand(cmd, mkey, akey1, akey2 : word); overload;
    procedure SetDefault;
    function GetAction(section, cmd : word) : string;
    function GetSection(cmd : word) : integer;
    function GetCommand(section, cmd : word) : integer;
    function CommandExists(cmd : word) : boolean; overload;
    function CommandExists(mode : byte; cmd : word) : boolean; overload;
    procedure WriteToStream(F : tstream);
    procedure ReadFromStream(F : tstream);
    procedure SaveToFile(FileName : string);
    procedure LoadFromFile(FileName : string);
    //function SelectCommand(InKeys : word) : integer;
    Constructor Create(Name : string);
    Destructor Destroy;
  end;

  TfrHotKeys = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Panel4: TPanel;
    Image1: TImage;
    Panel5: TPanel;
    Label7: TLabel;
    Panel6: TPanel;
    Label1: TLabel;
    Panel7: TPanel;
    Panel8: TPanel;
    Image2: TImage;
    LbOsnCurr: TLabel;
    Label3: TLabel;
    lbOsnNew: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    LbDopCurr: TLabel;
    LbDopNew: TLabel;
    Label5: TLabel;
    LbAction: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Label8: TLabel;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Bevel3: TBevel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure StringGrid1TopLeftChanged(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    IsChanges : boolean;
  public
    { Public declarations }
    procedure LoadHotKeysGrid;
    procedure ReadKeyLayouts(SourceDir : string);
  end;

var
  frHotKeys: TfrHotKeys;
  ListHotKeys, TempHotKeys : TMyListHotKeys;

function addplus(s : string) : string;
function KeyToName(Key : byte) : string;
function NameToKey(Name : string) : byte;
function StringKeysToWord(skeys : string) : word;
function WordToStringKeys(Keys : word) : string;

procedure EditListHotKeys;

implementation
uses umain, ucommon, uhotkeys, uinitforms;

{$R *.dfm}

procedure EditListHotKeys;
begin
  frHotKeys.IsChanges:=False;
  frHotKeys.ReadKeyLayouts(PathKeylayouts);
  ListHotKeys.Assign(WorkHotKeys);
  frHotKeys.ShowModal;
  //if ListHotKeys=nil then ListHotKeys := TMyListHotKeys.Create('');
  if frHotKeys.ModalResult=mrOk then begin
    WorkHotKeys.Assign(ListHotKeys);
    //ListHotKeys.Free;
  end;
end;


procedure TfrHotKeys.ReadKeyLayouts(SourceDir : string);
var
  SR: TSearchRec;
  I: Integer;
  name, ext : string;
begin
  try
  combobox1.Clear;
  SourceDir := IncludeTrailingBackslash(SourceDir);
  if not DirectoryExists(SourceDir) then Exit;

  I := System.SysUtils.FindFirst(SourceDir + '*.klns', faAnyFile, SR);
  try
    while I = 0 do begin
      if (SR.Name <> '') and (SR.Name <> '.') and (SR.Name <> '..') then begin
        if SR.Attr <> faDirectory then begin
          name:=extractfilename(SR.Name);
          ext:=extractfileext(name);
          name:=copy(name,1,length(name)-length(ext));
          ComboBox1.Items.Add(name);
        end;
      end;
      I := System.SysUtils.FindNext(SR);
    end;
  finally
    System.SysUtils.FindClose(SR);
  end;
  except
  end;
end;

function addplus(s : string) : string;
begin
  result := '';
  if trim(s)<>'' then result:=trim(s)+ '+';
end;

function KeyToName(Key : byte) : string;
begin
   case key of
 0 : result := 'NUll';
 8 : result := 'BACKSPACE';
 9 : result := 'TAB';
13 : result := 'ENTER';
16 : result := 'SHIFT';
17 : result := 'CTRL';
18 : result := 'ALT';
19 : result := 'PAUSE';
20 : result := 'CAPSLOCK';
27 : result := 'ESC';
32 : result := 'SPACE';
33 : result := 'PAGEUP';
34 : result := 'PAGEDOWN';
35 : result := 'END';
36 : result := 'HOME';
37 : result := 'LEFT';
38 : result := 'UP';
39 : result := 'RIGHT';
40 : result := 'DOWN';
45 : result := 'INSERT';
46 : result := 'DELETE';
91 : result := 'WINLEFT';
93 : result := 'WINRIGHT';
96 : result := 'NUMPAD0';
97 : result := 'NUMPAD1';
98 : result := 'NUMPAD2';
99 : result := 'NUMPAD3';
100 : result := 'NUMPAD4';
101 : result := 'NUMPAD5';
102 : result := 'NUMPAD6';
103 : result := 'NUMPAD7';
104 : result := 'NUMPAD8';
105 : result := 'NUMPAD9';
106 : result := 'NUMPADMULT';
107 : result := 'NUMPADPLUS';
109 : result := 'NUMPADMINUS';
110 : result := 'NUMPADPOINT';
111 : result := 'NUMPADDIV';
112 : result := 'F1';
113 : result := 'F2';
114 : result := 'F3';
115 : result := 'F4';
116 : result := 'F5';
117 : result := 'F6';
118 : result := 'F7';
119 : result := 'F8';
120 : result := 'F9';
121 : result := 'F10';
122 : result := 'F11';
123 : result := 'F12';
144 : result := 'NUM';
186 : result := ';';
187 : result := 'PLUS';
188 : result := '<';
189 : result := 'MINUS';
190 : result := '>';
191 : result := '?';
192 : result := '~';
219 : result := '[';
220 : result := '|';
221 : result := ']';
222 : result := '''';
 else result:=chr(Key);
   end;
end;

function NameToKey(Name : string) : byte;
var s : string;
begin
  s:=trim(Name);
  if s='NUll' then result:=0
  else if s='BACKSPACE' then result:=8
  else if s='TAB' then result:=9
  else if s='ENTER' then result:=13
  else if s='SHIFT' then result:=16
  else if s='CTRL' then result:=17
  else if s='ALT' then result:=18
  else if s='PAUSE' then result:=19
  else if s='CAPSLOCK' then result:=20
  else if s='ESC' then result:=27
  else if s='SPACE' then result:=32
  else if s='PAGEUP' then result:=33
  else if s='PAGEDOWN' then result:=34
  else if s='END' then result:=35
  else if s='HOME' then result:=36
  else if s='LEFT' then result:=37
  else if s='UP' then result:=38
  else if s='RIGHT' then result:=39
  else if s='DOWN' then result:=40
  else if s='INSERT' then result:=45
  else if s='DELETE' then result:=46
  else if s='WINLEFT' then result:=91
  else if s='WINRIGHT' then result:=93
  else if s='NUMPAD0' then result:=96
  else if s='NUMPAD1' then result:=97
  else if s='NUMPAD2' then result:=98
  else if s='NUMPAD3' then result:=99
  else if s='NUMPAD4' then result:=100
  else if s='NUMPAD5' then result:=101
  else if s='NUMPAD6' then result:=102
  else if s='NUMPAD7' then result:=103
  else if s='NUMPAD8' then result:=104
  else if s='NUMPAD9' then result:=105
  else if s='NUMPADMULT' then result:=106
  else if s='NUMPADPLUS' then result:=107
  else if s='NUMPADMINUS' then result:=109
  else if s='NUMPADPOINT' then result:=110
  else if s='NUMPADDIV' then result:=111
  else if s='F1' then result:=112
  else if s='F2' then result:=113
  else if s='F3' then result:=114
  else if s='F4' then result:=115
  else if s='F5' then result:=116
  else if s='F6' then result:=117
  else if s='F7' then result:=118
  else if s='F8' then result:=119
  else if s='F9' then result:=120
  else if s='F10' then result:=121
  else if s='F11' then result:=122
  else if s='F12' then result:=123
  else if s='NUM' then result:=144
  else if s=';' then result:=186
  else if s='PLUS' then result:=187
  else if s='<' then result:=188
  else if s='MINUS' then result:=189
  else if s='>' then result:=190
  else if s='?' then result:=191
  else if s='~' then result:=192
  else if s='[' then result:=219
  else if s='|' then result:=220
  else if s=']' then result:=221
  else if s='''' then result:=222
  else if length(s)=1 then result:=ord(Name[1])
  else result:=255;
end;

function StringKeysToWord(skeys : string) : word;
var s, s1, s2, s3, s4 : string;
    i, ps : integer;
    mkeys : array[0..3] of byte;
begin
  if trim(skeys)='' then begin
    result := $ffff;
    exit;
  end;
  s1:='';
  s2:='';
  s3:='';
  s4:='';
  s:=trim(skeys);
  ps:=Pos('+',s);
  s1:=trim(copy(s,1,ps-1));
  s:=trim(copy(s,ps+1,length(s)));
  if trim(s)<>'' then begin
    ps:=Pos('+',s);
    s2:=trim(copy(s,1,ps-1));
    s:=trim(copy(s,ps+1,length(s)));
    if trim(s)<>'' then begin
      ps:=Pos('+',s);
      s3:=trim(copy(s,1,ps-1));
      s4:=trim(copy(s,ps+1,length(s)));
    end;
  end;
  mkeys[0] := NameToKey(s1);
  mkeys[1] := NameToKey(s2);
  mkeys[2] := NameToKey(s3);
  mkeys[3] := NameToKey(s4);
  result:=0;
  for i:=0 to 3 do begin
     case mkeys[i] of
  16 : result:=result or $0200;
  17 : result:=result or $0100;
  18 : result:=result or $0400;
  else if mkeys[i]<>255 then result:=result + mkeys[i]
     end;
  end;
end;

function WordToStringKeys(Keys : word) : string;
var key : word;
    bt : byte;
    s : string;
begin
  if Keys=$ffff then begin
    result:='';
  end;
  if (keys and $0100)<>0 then s:='CTRL';
  if (keys and $0200)<>0 then s:=addplus(s) + 'SHIFT';
  if (keys and $0400)<>0 then s:=addplus(s) + 'ALT';
  bt:=keys and $00FF;
  s:=addplus(s) + KeyToName(bt);
  result:=s;
end;

procedure TfrHotKeys.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i, res : byte;
    cmd, cmd1 : word;
begin
  res := mainkeyboard.ClickMouse(Image1.Canvas, X,Y);
  LbOsnNew.Font.Color:=frHotKeys.Font.Color;
  cmd := mainkeyboard.GetControlValue;
  cmd1 := numkeyboard.GetControlValue;
  cmd1 := cmd1  and ($FFFF-512);
  if res=255 then begin
    if cmd=cmd1 then begin
      if (not numkeyboard.GetKeySelection('NUM')) or numkeyboard.GetKeySelection(16) then begin
        for i:=33 to 40 do numkeyboard.SetSelect(i,mainkeyboard.GetKeySelection(i));
        numkeyboard.SetSelect(45,mainkeyboard.GetKeySelection(45));
        numkeyboard.SetSelect(46,mainkeyboard.GetKeySelection(46));
      end;
      numkeyboard.SetSelect(13,mainkeyboard.GetKeySelection(13));
      LbDopNew.Font.Color:=frHotKeys.Font.Color;
      LbDopNew.Caption:=LbDopCurr.Caption;
    end;
    mainkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
    LbOsnNew.Caption:=LbOsnCurr.Caption;
    //exit;
  end else begin
    if res in [16,17,18] then begin
      mainkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
      LbOsnNew.Caption:=LbOsnCurr.Caption;
    end else begin
      if cmd=cmd1 then begin
        if res in [13,33..40,45,46] then begin
          numkeyboard.ClearSelectWithoutControl;
          numkeyboard.SetSelect(res,mainkeyboard.GetKeySelection(res));
        end;
      end;
      LbOsnNew.Font.Color:=KEYColorNew;
      cmd := cmd + res;
      LbOsnNew.Caption:=WordToStringKeys(cmd);
    end;
  end;
  numkeyboard.Draw(image2.Canvas);
  Image2.Repaint;
  mainkeyboard.Draw(image1.Canvas);
  Image1.Repaint;
end;

procedure TfrHotKeys.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var res : byte;
    cmd : word;
    s : string;
begin
  res := numkeyboard.MoveMouse(Image2.Canvas, X,Y);
  if res=255 then begin
    Label7.Caption:='';
    exit;
  end;
  cmd := numkeyboard.GetControlValue + res;
  if numkeyboard.GetKeyBusy(res) then begin
    Label7.Caption:=WordToStringKeys(cmd) + ' | ' +combobox2.Items.Strings[ListHotKeys.GetSection(cmd)]
                     + ' | ' + ListHotKeys.GetAction(combobox2.ItemIndex, cmd);
  end else begin
    s:=WordToStringKeys(cmd);
    if s='NUM'
      then Label7.Caption:='Включение/выключение клавиши NUM производится с клавиатуры.'
      else Label7.Caption:=WordToStringKeys(cmd)+' не используется';
  end;
  numkeyboard.Draw(Image2.Canvas);
  Image2.Repaint;
end;

procedure TfrHotKeys.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i, res : byte;
    cmd, cmd1 : word;
    bl : boolean;
begin
  res := numkeyboard.ClickMouse(Image2.Canvas, X,Y);
  cmd := numkeyboard.GetControlValue  and ($FFFF-512);
  cmd1 := mainkeyboard.GetControlValue;
  LbDopNew.Font.Color:=frHotKeys.Font.Color;
  if res=255 then begin
    LbDopNew.Caption:=LbDopCurr.Caption;
    if not numkeyboard.GetKeySelection(16) then numkeyboard.SwapKeys;
    if cmd=cmd1 then begin
      if not numkeyboard.GetKeySelection('NUM') or numkeyboard.GetKeySelection(16) then begin
        for i:=33 to 40 do mainkeyboard.SetSelect(i,numkeyboard.GetKeySelection(i));
        mainkeyboard.SetSelect(45,numkeyboard.GetKeySelection(45));
        mainkeyboard.SetSelect(46,numkeyboard.GetKeySelection(46));
      end;
      mainkeyboard.SetSelect(13,numkeyboard.GetKeySelection(13));
      LbOsnNew.Font.Color:=frHotKeys.Font.Color;
      LbOsnNew.Caption:=LbOsnCurr.Caption;
    end;
    numkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  end else begin
    if res in [16,17,18] then begin
      if res=16 then begin
        numkeyboard.SwapKeys;
      end;
      numkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
      LbDopNew.Caption:=LbDopCurr.Caption;
    end else begin
      if res=144 then begin
        if GetKeyState(VK_NUMLOCK)=1
          then numkeyboard.SetSelect('NUM',true) else numkeyboard.SetSelect('NUM',false);
          numkeyboard.SwapKeys;

      end else begin
        if cmd=cmd1 then begin
          if res in [13,33..40,45,46] then begin
            mainkeyboard.ClearSelectWithoutControl;
            mainkeyboard.SetSelect(res,numkeyboard.GetKeySelection(res));
            LbOsnNew.Font.Color:=KEYColorNew;
            cmd1 := cmd1 + res;
            LbOsnNew.Caption:=WordToStringKeys(cmd1);
          end;
        end;
        LbDopNew.Font.Color:=KEYColorNew;
        cmd := cmd + res;
        LbDopNew.Caption:=WordToStringKeys(cmd);
      end;
    end;
  end;
  numkeyboard.Draw(Image2.Canvas);
  Image2.Repaint;
  mainkeyboard.Draw(Image1.Canvas);
  Image1.Repaint;
end;

constructor TMyHotKey.Create;
begin
  Mode    :=255;
  Action  :='';
  Command :=$ffff;
  mainkey := $ffff;
  addkey1 := $ffff;
  addkey2 := $ffff;
end;

destructor TMyHotKey.Destroy;
begin
  freemem(@Mode);
  freemem(@Action);
  freemem(@Command);
  freemem(@mainkey);
  freemem(@addkey1);
  freemem(@addkey2);
end;

procedure TMyHotKey.Clear;
begin
  Mode    := 255;
  Action  := '';
  Command := $ffff;
  mainkey := $ffff;
  addkey1 := $ffff;
  addkey2 := $ffff;
end;

procedure TMyHotKey.Assign(MHK : TMyHotKey);
begin
  Mode    := MHK.Mode;
  Action  := MHK.Action;
  Command := MHK.Command;
  mainkey := MHK.mainkey;
  addkey1 := MHK.addkey1;
  addkey2 := MHK.addkey2;
end;

procedure TMyHotKey.WriteToStream(F : Tstream);
begin
  F.WriteBuffer(Mode,SizeOf(byte));
  //WriteToStreamStr(Action);
  F.WriteBuffer(Command,SizeOf(word));
  F.WriteBuffer(mainkey,SizeOf(word));
  F.WriteBuffer(addkey1,SizeOf(word));
  F.WriteBuffer(addkey2,SizeOf(word));
end;

procedure TMyHotKey.ReadFromStream(F : Tstream);
begin
  F.ReadBuffer(Mode,SizeOf(byte));
  //ReadFromStreamStr(Action);
  F.ReadBuffer(Command,SizeOf(word));
  F.ReadBuffer(mainkey,SizeOf(word));
  F.ReadBuffer(addkey1,SizeOf(word));
  F.ReadBuffer(addkey2,SizeOf(word));
end;

Constructor TMyListHotKeys.Create(Name : string);
begin
  DefaultKeys := 1;
  Name := 'По умолчанию';
  Number := 0;
  Count := 0;
end;

procedure TMyListHotKeys.Clear;
var i : integer;
begin
  DefaultKeys := 1;
  Name := 'По умолчанию';
  Number := 0;
  for i:=Count-1 downto 0 do begin
    List[Count-1].FreeInstance;
    Count:=Count-1;
    setlength(List,Count);
  end;
  Count:=0;
end;

procedure TMyListHotKeys.Assign(LHK : TMyListHotKeys);
var i : integer;
begin
  Clear;
  DefaultKeys := LHK.DefaultKeys;
  Name := LHK.Name;
  Number := LHK.Number;
  for i:=0 to LHK.Count-1 do begin
    Count:=Count+1;
    Setlength(List,Count);
    List[Count-1] := TMyHotKey.Create;
    List[Count-1].Assign(LHK.List[i]);
  end;
end;

Destructor TMyListHotKeys.Destroy;
begin
  freemem(@DefaultKeys);
  freemem(@Name);
  freemem(@Number);
  Clear;
  freemem(@Count);
  freemem(@List);
end;

procedure TMyListHotKeys.SetDefault;
begin
  clear;
  AddString('0|1|Открыть панель «Проекты»|SHIFT+Q');
  AddString('0|2|Открыть панель «Клипы»|SHIFT+W');
  AddString('0|3|Открыть панель «Активный плей-лист»|SHIFT+E');
  AddString('0|4|Открыть панель «Подготовка»|SHIFT+R');
  AddString('0|5|Открыть панель «Эфир»|SHIFT+T');
  AddString('1|6|Создать новый проект|SHIFT+N');
  AddString('1|7|Удалить проект/проекты из списка|SHIFT+D');
  AddString('1|8|Открыть проект|CTRL+O');
  AddString('1|9|Сохранить проект как|SHIFT+ S');  AddString('1|10|Блокировать/разблокировать текущий проект|SHIFT+B');
  //AddString('1|11|Переключение между списками окна проектов|TAB');
  AddString('1|12|Создать новую тайм-линию|CTRL+PLUS');  AddString('1|13|Удалить выбранную тайм-линию|CTRL+MINUS');
  AddString('1|14|Редактировать выбранную тайм-линию|CTRL+T');
  AddString('1|15|Создать новый плей-лист|CTRL+N');
  AddString('1|16|Удалитьплей-лист|CTRL+D');
  AddString('1|17|Сохранить текущий проекта|CTRL+S');
  AddString('1|18|Сортировать элементы списка (плей-листы, шаблоны)|ALT+S');
  //AddString('1|19|Открыть список «Плей-листы»|ALT+P');  AddString('1|20|Открыть список «Графические шаблоны»|ALT+G');
  AddString('1|21|Открыть список «Текстовые шаблоны»|ALT+T');
  AddString('2|22|Импортировать клипы в систему|CTRL+I');
  AddString('2|23|Удалить клип/клипы из списка|DELETE');
  AddString('2|24|Загрузить выбранный клип в окно подготовки|CTRL+P');  AddString('2|25|Сортировать список клипов|CTRL+S');  AddString('2|26|Загрузить клип/клипы в активный плей-лист|CTRL+L');  AddString('2|72|Создать новый клип|CTRL+N');  AddString('3|27|Удалить клип/клипы из система|DELETE');
  AddString('3|28|Загрузить выбранный клип в окно подготовки|CTRL+P');
  AddString('3|73|Создать новый плей лист|CTRL+N');
  AddString('3|74|Редактировать список клипов текущего плей листа|CTRL+R');
  AddString('4|29|Запустить/Остановить воспроизведение клипа|SPACE');
  AddString('4|30|На один кадр влево|LEFT');
  AddString('4|31|На один кадр вправо|RIGHT');
  AddString('4|32|В начало предыдущего клипа|SHIFT+LEFT');  AddString('4|33|В начало следующего клипа|SHIFT+RIGHT');
  AddString('4|34|На десять кадров влево|CTRL+LEFT');
  AddString('4|35|На десять кадров вправо|CTRL+RIGHT');
  AddString('4|36|Перейти к точке начала воспроизведения|HOME');  AddString('4|37|Перейти в точку окончания воспроизведения|END');  AddString('4|38|Перейти в начало клипа|SHIFT+HOME');
  AddString('4|39|Перейти в конец клипа |SHIFT+END');
  AddString('4|40|Отменить предыдущее действие|CTRL+Z');
  AddString('4|41|Уменьшить скорость воспроизведения в 2 раза|CTRL+<');
  AddString('4|42|Увеличить скорость воспроизведения в 2 раза|CTRL+>');
  AddString('4|43|Уменьшить скорость воспроизведения в 4 раза|SHIFT+<');  AddString('4|44|Увеличить скорость воспроизведения в 4 раза|SHIFT+>');  AddString('4|45|Подтянуть границу события находящуюся слева от курсора|C');  AddString('4|46|Подтянуть границу события находящуюся справа от курсора|V');  AddString('4|47|Сдвинуть тайм-линию/линии на заданное количество кадров|CTRL+S');
  AddString('4|48|Установить короткие номера событий|CTRL+D');
  AddString('4|49|Вырезать событие/события в буфер обмена|CTRL+X');
  AddString('4|50|Копировать событие/события в буфер обмена|CTRL+C');  AddString('4|51|Вставить событие/события из буфера обмена|CTRL+V');  AddString('4|52|Удалить событие/события без возможности восстановления|DELETE');
  AddString('4|53|Загрузить предыдущее событие из списка (клипы, плей-лист)|SHIFT+A');
  AddString('4|54|Загрузить следующее событие из списка (клипы, плей-лист)|SHIFT+S');
  AddString('4|55|Открыть/Закрыть список графических шаблонов|SHIFT+G');
  AddString('4|56|Открыть панель воспроизведения видео|SHIFT+D');
  AddString('4|57|Открыть панель воспроизведения шаблонов|SHIFT+F');  AddString('4|58|Установить начальную точку воспроизведения|I');
  AddString('4|59|Установить конечную точку воспроизведения|O');  AddString('4|70|Установить нулевую точку|CTRL+O');  AddString('4|71|Установить время запуска клипа|CTRL+ALT+M');  AddString('4|101|Установить событие для устройства 1|1|NUMPAD1');  AddString('4|102|Установить событие для устройства 2|2|NUMPAD2');  AddString('4|103|Установить событие для устройства 3|3|NUMPAD3');  AddString('4|104|Установить событие для устройства 4|4|NUMPAD4');  AddString('4|105|Установить событие для устройства 5|5|NUMPAD5');  AddString('4|106|Установить событие для устройства 6|6|NUMPAD6');  AddString('4|107|Установить событие для устройства 7|7|NUMPAD7');  AddString('4|108|Установить событие для устройства 8|8|NUMPAD8');  AddString('4|109|Установить событие для устройства 9|9|NUMPAD9');  AddString('4|110|Установить событие для устройства 10|0|NUMPAD0');  AddString('4|111|Установить событие для устройств 11|CTRL+1|CTRL+NUMPAD1');  AddString('4|112|Установить событие для устройств 12|CTRL+2|CTRL+NUMPAD2');  AddString('4|113|Установить событие для устройств 13|CTRL+3|CTRL+NUMPAD3');  AddString('4|114|Установить событие для устройств 14|CTRL+4|CTRL+NUMPAD4');  AddString('4|115|Установить событие для устройств 15|CTRL+5|CTRL+NUMPAD5');  AddString('4|116|Установить событие для устройств 16|CTRL+6|CTRL+NUMPAD6');  AddString('4|117|Установить событие для устройств 17|CTRL+7|CTRL+NUMPAD7');  AddString('4|118|Установить событие для устройств 18|CTRL+8|CTRL+NUMPAD8');  AddString('4|119|Установить событие для устройств 19|CTRL+9|CTRL+NUMPAD9');  AddString('4|120|Установить событие для устройств 20|CTRL+0|CTRL+NUMPAD0');  AddString('4|121|Установить событие для устройств 21|SHIFT+1');  AddString('4|122|Установить событие для устройств 22|SHIFT+2');
  AddString('4|123|Установить событие для устройств 23|SHIFT+3');
  AddString('4|124|Установить событие для устройств 24|SHIFT+4');
  AddString('4|125|Установить событие для устройств 25|SHIFT+5');  AddString('4|126|Установить событие для устройств 26|SHIFT+6');
  AddString('4|127|Установить событие для устройств 27|SHIFT+7');  AddString('4|128|Установить событие для устройств 28|SHIFT+8');
  AddString('4|129|Установить событие для устройств 29|SHIFT+9');  AddString('4|130|Установить событие для устройств 30|SHIFT+0');  AddString('4|131|Установить событие для устройств 31|ALT+1|ALT+NUMPAD1');  AddString('4|132|Установить событие для устройств 32|ALT+2|ALT+NUMPAD2');  AddString('4|60|Текстовая тайм-линия: Разделить событие на части по курсору|ALT+C');  //AddString('4|61|Установить нулевую точку|ALT+Z');  AddString('4|62|Редактирование медиа таймлинии: Установить маркер|CTRL+M');
  AddString('4|63|Редактирование медиа таймлинии: Удалить маркер|ALT+M');
  AddString('4|200|Увеличить масштаб тайм-линий по вертикали|SHIFT+PLUS|SHIFT+NUMPADPLUS');
  AddString('4|201|Уменьшить масштаб тайм-линий по вертикали|SHIFT+MINUS|SHIFT+NUMPADMINUS');
  AddString('4|202|Увеличить масштаб тайм-линий по горизонтали|CTRL+PLUS|CTRL+NUMPADPLUS');
  AddString('4|203|Уменьшить масштаб тайм-линий по горизонтали|CTRL+MINUS|CTRL+NUMPADMINUS');
end;

function TMyListHotKeys.GetAction(section, cmd : word) : string;
var i : integer;
begin
  if cmd=$ffff then begin
    result:='';
    exit;
  end;
  for i:=0 to Count-1 do begin
    if (List[i].Mode=section) and ((cmd=List[i].mainkey) or (cmd=List[i].addkey1) or (cmd=List[i].addkey2))
    then begin
      result := List[i].Action;
      exit;
    end;
  end;
end;

function TMyListHotKeys.GetSection(cmd : word) : integer;
var i : integer;
begin
  if cmd=$ffff then begin
    result:=cmd;
    exit;
  end;
  for i:=0 to Count-1 do begin
    if (cmd=List[i].mainkey) or (cmd=List[i].addkey1) or (cmd=List[i].addkey2)
    then begin
      result := List[i].Mode;
      exit;
    end;
  end;
end;

function TMyListHotKeys.GetCommand(section, cmd : word) : integer;
var i : integer;
begin
  result:=$FFFF;
  if cmd=$ffff then exit;

  for i:=0 to Count-1 do begin
    if (List[i].Mode=section) and ((cmd=List[i].mainkey) or (cmd=List[i].addkey1) or (cmd=List[i].addkey2))
    then begin
      result := List[i].Command;
      exit;
    end;
  end;
end;

function TMyListHotKeys.CommandExists(cmd : word) : Boolean;
var i : integer;
begin
  result:=false;
  if cmd=$ffff then exit;
  for i:=0 to Count-1 do begin
    if (cmd=List[i].mainkey) or (cmd=List[i].addkey1) or (cmd=List[i].addkey2)
    then begin
      result := true;
      exit;
    end;
  end;
end;

function TMyListHotKeys.CommandExists(mode : byte; cmd : word) : boolean;
var i : integer;
begin
  result:=false;
  if cmd=$ffff then exit;
  for i:=0 to Count-1 do begin
    if (List[i].Mode=mode) and ((cmd=List[i].mainkey) or (cmd=List[i].addkey1) or (cmd=List[i].addkey2))
    then begin
      result := true;
      exit;
    end;
  end;
end;

procedure TMyListHotKeys.AddString(s : string);
var ps : integer;
    ss, sm, sc, sa, sdef, sadd1, sadd2 : string;
begin
  sm:=''; sc:=''; sa:=''; sdef:=''; sadd1:=''; sadd2:='';
  ss:=trim(s);
  ps := Pos('|',ss);
  sm := trim(Copy(ss,1,ps-1));
  ss := trim(Copy(ss,ps+1,length(ss)));
  if ss<>'' then begin //1
    ps := Pos('|',ss);
    sc := trim(Copy(ss,1,ps-1));
    ss := trim(Copy(ss,ps+1,length(ss)));
    if ss<>'' then begin //2
      ps := Pos('|',ss);
      sa := trim(Copy(ss,1,ps-1));
      ss := trim(Copy(ss,ps+1,length(ss)));
      if ss<>'' then begin  //3
        ps := Pos('|',ss);
        if ps<>0 then begin //4
          sdef := trim(Copy(ss,1,ps-1));
          ss := trim(Copy(ss,ps+1,length(ss)));
        end else begin
          sdef:=ss;
          ss:='';
        end; //4
        if ss<>'' then begin //5
          ps := Pos('|',ss);
          if ps<>0 then begin //6
            sadd1 := trim(Copy(ss,1,ps-1));
            sadd2 := trim(Copy(ss,ps+1,length(ss)));
          end else begin
            sadd1:=ss;
            sadd2:='';
          end; //6
        end; //5
      end; //3
    end; //2
  end; //1

  Count := Count + 1;
  Setlength(List,Count);
  List[Count-1] := TMyHotKey.Create;
  if sm<>'' then List[Count-1].Mode:=strtoint(sm) else List[Count-1].Mode:=$ff;
  if sc<>'' then List[Count-1].Command:=strtoint(sc) else List[Count-1].Command:=$ffff;
  if sa<>'' then List[Count-1].Action:=sa else List[Count-1].Action:='';
  if sdef<>'' then List[Count-1].mainkey:=StringKeysToWord(sdef) else List[Count-1].mainkey:=$ffff;
  if sadd1<>'' then List[Count-1].addkey1:=StringKeysToWord(sadd1) else List[Count-1].addkey1:=$ffff;
  if sadd2<>'' then List[Count-1].addkey2:=StringKeysToWord(sadd2) else List[Count-1].addkey2:=$ffff;
end;

procedure TMyListHotKeys.UpdateCommand(s : string; cmd1,cmd2 : word);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if lowercase(trim(List[i].Action))=lowercase(trim(s)) then begin
      List[i].mainkey:=cmd1;
      List[i].addkey1:=cmd2;
    end;
  end;
end;

procedure TMyListHotKeys.UpdateCommand(cmd, mkey, akey1, akey2 : word);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if list[i].Command=cmd then begin
      list[i].mainkey:=mkey;
      list[i].addkey1:=akey1;
      list[i].addkey2:=akey2;
    end;
  end;
end;

procedure TMyListHotKeys.WriteToStream(F : tstream);
var i : integer;
begin
  //WriteBufferStr(NAMEKeyLayout);
  F.WriteBuffer(Count,SizeOf(integer));
  for i :=0 to Count-1 do begin
    F.WriteBuffer(List[i].Command,SizeOf(WORD));
    F.WriteBuffer(List[i].mainkey,SizeOf(WORD));
    F.WriteBuffer(List[i].addkey1,SizeOf(WORD));
    F.WriteBuffer(List[i].addkey2,SizeOf(WORD));
  end;
end;

procedure TMyListHotKeys.ReadFromStream(F : tstream);
var i, cnt : integer;
    cmd, mk, ak1, ak2 : word;
    stri : string;
begin
  //ReadBufferStr(F,stri);
  //NAMEKeyLayout:=stri;
  F.ReadBuffer(cnt,SizeOf(integer));
  for i:=0 to cnt-1 do begin
    F.ReadBuffer(cmd,SizeOf(WORD));
    F.ReadBuffer(mk,SizeOf(WORD));
    F.ReadBuffer(ak1,SizeOf(WORD));
    F.ReadBuffer(ak2,SizeOf(WORD));
    UpdateCommand(cmd, mk, ak1, ak2);
  end;
end;

procedure TMyListHotKeys.SaveToFile(FileName : string);
var Stream : TFileStream;
    i, j, rw, ph : integer;
    sz, ps : longint;
    renm : string;
    path, name, ext : string;
begin
  path:=extractfilepath(FileName);
  name:=extractfilename(FileName);
  ext := extractfileext(FileName);
  //if trim(ext)='' then name:=path+PathKeyLayouts+'\'+name+'.klns' else name:=path+PathKeyLayouts+'\'+name;
  if trim(ext)='' then name:=path+name+'.klns' else name:=path+name;
  if not directoryexists(path) then ForceDirectories(path);

  if FileExists(name) then begin
    renm := path + 'Temp.evns';
    RenameFile(name,renm);
    DeleteFile(renm);
  end;
  Stream := TFileStream.Create(name, fmCreate or fmShareDenyNone);
  try
    ListHotKeys.WriteToStream(Stream);
  finally
    FreeAndNil(Stream);
  end;
end;

procedure TMyListHotKeys.LoadFromFile(FileName : string);
var Stream : TFileStream;
begin
  if not FileExists(FileName) then exit;
  Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  try
    ListHotKeys.ReadFromStream(Stream);
  finally
    FreeAndNil(Stream);
  end;
end;

procedure TfrHotKeys.LoadHotKeysGrid;
var rw, i :integer;
begin
  Stringgrid1.RowCount:=2;
  rw:=1;
  for i:=0 to ListHotKeys.Count-1 do begin
    if ListHotKeys.List[i].Mode=ComboBox2.ItemIndex then begin
       Stringgrid1.RowCount:=rw+1;
       StringGrid1.Cells[0,rw]:=inttostr(rw);
       StringGrid1.Cells[1,rw]:=ListHotKeys.List[i].Action;
       if ListHotKeys.List[i].mainkey=$ffff then StringGrid1.Cells[2,rw]:=''
       else StringGrid1.Cells[2,rw]:=WordToStringKeys(ListHotKeys.List[i].mainkey);
       if ListHotKeys.List[i].addkey1=$ffff then StringGrid1.Cells[3,rw]:=''
       else StringGrid1.Cells[3,rw]:=WordToStringKeys(ListHotKeys.List[i].addkey1);
       if ListHotKeys.List[i].addkey2=$ffff then StringGrid1.Cells[4,rw]:=''
       else StringGrid1.Cells[4,rw]:=WordToStringKeys(ListHotKeys.List[i].addkey2);
       rw:=rw+1;
    end;
  end;
end;

procedure TfrHotKeys.SpeedButton1Click(Sender: TObject);
begin
  opendialog1.InitialDir:=PathKeylayouts;
  opendialog1.Filter:='Список горячих клавиш (*.klns) | *.KLNS';
  opendialog1.FilterIndex:=0;
  if not opendialog1.Execute then exit;
  ListHotKeys.LoadFromFile(opendialog1.FileName);
  LoadHotKeysGrid;
end;

procedure TfrHotKeys.SpeedButton2Click(Sender: TObject);
begin
  savedialog1.InitialDir:=PathKeylayouts;
  savedialog1.Filter:='Список горячих клавиш (*.klns) | *.KLNS';
  savedialog1.FilterIndex:=0;
  if not savedialog1.Execute then exit;
  ListHotKeys.SaveToFile(savedialog1.FileName);
end;

procedure TfrHotKeys.SpeedButton4Click(Sender: TObject);
begin
  frHotKeys.ModalResult:=mrOk;
end;

procedure TfrHotKeys.SpeedButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrHotKeys.SpeedButton6Click(Sender: TObject);
var ocmd1, ocmd2, ncmd1, ncmd2 : word;
begin
  if (stringgrid1.Row>0) and (stringgrid1.Row<stringgrid1.RowCount) then begin
    ocmd1:=StringKeysToWord(lbOsnCurr.Caption);
    ocmd2:=StringKeysToWord(lbDopCurr.Caption);
    ncmd1:=StringKeysToWord(lbOsnNew.Caption);
    ncmd2:=StringKeysToWord(lbDopNew.Caption);
    stringgrid1.Cells[2,stringgrid1.Row]:=lbOsnNew.Caption;
    stringgrid1.Cells[3,stringgrid1.Row]:=lbDopNew.Caption;
    ListHotKeys.UpdateCommand(stringgrid1.Cells[1,stringgrid1.Row],ncmd1,ncmd2);
    LbOsnCurr.Caption:=LbOsnNew.Caption;
    LbDopCurr.Caption:=LbDopNew.Caption;
    mainkeyboard.SetKeySelected(LbOsnCurr.Caption);
    numkeyboard.SetKeySelected(LbDopCurr.Caption);
    mainkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
    numkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
    lbOsnNew.Font.Color:=frHotKeys.Font.Color;
    lbDopNew.Font.Color:=frHotKeys.Font.Color;
    mainkeyboard.Draw(Image1.Canvas);
    numkeyboard.Draw(Image2.Canvas);
    image1.Repaint;
    image2.Repaint;
  end;
end;

procedure TfrHotKeys.SpeedButton7Click(Sender: TObject);
begin
  ListHotKeys.SetDefault;
  LoadHotKeysGrid;
  mainkeyboard := tmainkeyboard.create;
  mainkeyboard.init(image1.Width,image1.Height);
  mainkeyboard.Draw(image1.Canvas);
  mainkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  mainkeyboard.Draw(Image1.Canvas);
  image1.Repaint;
  numkeyboard := tnumkeyboard.create;
  numkeyboard.init(image2.Width,image2.Height);
  numkeyboard.SwapKeys;
  numkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  numkeyboard.Draw(Image2.Canvas);
  image2.Repaint;
end;

procedure TfrHotKeys.SpeedButton8Click(Sender: TObject);
var i : integer;
begin
  for i:=0 to ListHotKeys.Count-1 do begin
    ListHotKeys.List[i].mainkey:=$ffff;
    ListHotKeys.List[i].addkey1:=$ffff;
    ListHotKeys.List[i].addkey2:=$ffff;
  end;
  LoadHotKeysGrid;
  mainkeyboard := tmainkeyboard.create;
  mainkeyboard.init(image1.Width,image1.Height);
  mainkeyboard.Draw(image1.Canvas);
  mainkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  mainkeyboard.Draw(Image1.Canvas);
  image1.Repaint;
  numkeyboard := tnumkeyboard.create;
  numkeyboard.init(image2.Width,image2.Height);
  numkeyboard.SwapKeys;
  numkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  numkeyboard.Draw(Image2.Canvas);
  image2.Repaint;
end;

procedure TfrHotKeys.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var rt : trect;
begin
  if (arow>0) and (acol>0) then begin
    if (ARow mod 2) = 0
      then Stringgrid1.Canvas.Brush.Color:=GridColorRow1
      else Stringgrid1.Canvas.Brush.Color:=GridColorRow2;//SmoothColor(GridColorRow1,48);
    if stringgrid1.Row=ARow then Stringgrid1.Canvas.Brush.Color:=GridColorSelection;
    rt.Left := Rect.Left-1;
    rt.Top := Rect.Top-1;
    rt.Right := rect.Right+1;
    rt.Bottom := rect.Bottom+1;
    Stringgrid1.Canvas.FillRect(Rt);
    Stringgrid1.Canvas.TextRect(Rt,rect.left+2,rect.Top+1,stringgrid1.Cells[ACol,ARow]);
  end;
end;

procedure TfrHotKeys.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var i : integer;
begin
  //label1.Caption:=inttostr(ARow);
  if (mainkeyboard<>nil) and (numkeyboard<>nil) then begin
    LbAction.Caption:=Stringgrid1.Cells[1,ARow];
    LbOsnCurr.Caption:=Stringgrid1.Cells[2,ARow];
    mainkeyboard.SetKeySelected(LbOsnCurr.Caption);
    LbDopCurr.Caption:=Stringgrid1.Cells[3,ARow];
    numkeyboard.SetKeySelected(LbDopCurr.Caption);
    LbOsnNew.Caption:=Stringgrid1.Cells[2,ARow];
    LbDopNew.Caption:=Stringgrid1.Cells[3,ARow];
    //LbOsnNew.Caption:='';
    //LbDopNew.Caption:='';
    //if
    mainkeyboard.SetBusyHotKeys(ComboBox2.ItemIndex,ListHotKeys);
    mainkeyboard.Draw(Image1.Canvas);
    image1.Repaint;
    numkeyboard.SetBusyHotKeys(ComboBox2.ItemIndex,ListHotKeys);
    numkeyboard.Draw(Image2.Canvas);
    image2.Repaint;
  end;
end;

procedure TfrHotKeys.StringGrid1TopLeftChanged(Sender: TObject);
begin
 Stringgrid1.LeftCol:=1;
end;

procedure TfrHotKeys.ComboBox1Change(Sender: TObject);
var FileName : string;
begin
  FileName:=extractfilepath(Application.ExeName) + PathKeylayouts + '\'
            + ComboBox1.Items.Strings[Combobox1.ItemIndex] + '.klns';
  if not fileexists(FileName) then begin
     ComboBox1.ItemIndex:=0;
     exit;
  end;
  ListHotKeys.LoadFromFile(FileName);
  LoadHotKeysGrid;
end;

procedure TfrHotKeys.ComboBox2Change(Sender: TObject);
begin
  LoadHotKeysGrid;
  mainkeyboard.SetBusyHotKeys(ComboBox2.ItemIndex,ListHotKeys);
  mainkeyboard.Draw(Image1.Canvas);
  image1.Repaint;
  numkeyboard.SetBusyHotKeys(ComboBox2.ItemIndex,ListHotKeys);
  numkeyboard.Draw(Image2.Canvas);
  image2.Repaint;
  frHotKeys.ActiveControl:=stringgrid1;
end;

procedure TfrHotKeys.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  if frHotKeys.IsChanges
//    then if MessageDlg('Список был изменен. Сохранить изменения?',
//                        mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes
//           then SpeedButton4Click(nil);
end;

procedure TfrHotKeys.FormCreate(Sender: TObject);
var cs : boolean;
begin
  InitfrHotKeys;
 // stringgrid1.Cells[4,0]:='Доп. клав. [NumLock - Off]';

  ListHotKeys := TMyListHotKeys.Create('Настройки по умолчанию');
  ListHotKeys.SetDefault;
  ComboBox2.Clear;
  ComboBox2.Items.Add('Общие для всех окон');
  ComboBox2.Items.Add('Окно «Проекты»');
  ComboBox2.Items.Add('Окно «Клипы»');
  ComboBox2.Items.Add('Окно «Плей-лист»');
  ComboBox2.Items.Add('Окно «Подготовки/Эфира»');
  //ComboBox2.Items.Add('Редактирование тайм-линии устройств');
  //ComboBox2.Items.Add('Редактирование текстовой тайм-линии');
  //ComboBox2.Items.Add('Редактирование медиа тайм-линии');
  ReadKeyLayouts(extractfilepath(Application.ExeName) + PathKeylayouts);
  ComboBox2.ItemIndex:=0;
  LoadHotKeysGrid;
  mainkeyboard := tmainkeyboard.create;
  mainkeyboard.init(image1.Width,image1.Height);
  mainkeyboard.Draw(image1.Canvas);
  mainkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  mainkeyboard.Draw(Image1.Canvas);
  image1.Repaint;
  numkeyboard := tnumkeyboard.create;
  numkeyboard.init(image2.Width,image2.Height);
  numkeyboard.SwapKeys;
  numkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  numkeyboard.Draw(Image2.Canvas);
  image2.Repaint;
  cs:=true;
  StringGrid1SelectCell(nil,0,1,cs);
  label7.Caption:='';
end;

procedure TfrHotKeys.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var s, serr1, serr2 : string;
    res : word;
    key1 : byte;
begin
//if not (frHotKeys.ActiveControl=stringgrid1) then begin
  s:='';
  res:=0;
  mainkeyboard.ClearSelect;
  numkeyboard.ClearSelect;
  if ssCtrl in Shift then begin
    s:='CTRL';
    mainkeyboard.SetSelect('CTRL',true);
    numkeyboard.SetSelect('CTRL',true);
    //res:=res or $0100;
  end;
  if ssShift in Shift then begin
    s:=addplus(s) + 'SHIFT';
    mainkeyboard.SetSelect('SHIFT',true);
    numkeyboard.SetSelect('SHIFT',true);
    numkeyboard.MyShift:=true;
    //res:=res or $0200;
  end;
  if ssAlt in Shift then begin
    s:=addplus(s) + 'ALT';
    mainkeyboard.SetSelect('ALT',true);
    numkeyboard.SetSelect('ALT',true);
    //res:=res or $0400;
  end;
  mainkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  key1:=Key;
  serr1 := '';
  if not ((key1=16) or (key1=17) or (key1=18)) then begin
    if not mainkeyboard.GetKeyBusy(key1) then begin
      mainkeyboard.SetSelect(KeyToName(Key1),true);
      if not (key1 in [96..107,109..111]) then LbOsnNew.Caption:=addplus(s) + KeyToName(Key1);
      serr1:='Осн. клавиатура: ' + LbOsnNew.Caption + '  свободна ';
    end else serr1:='Осн. клавиатура: Недоступно ';
    if not numkeyboard.GetKeyBusy(key1) then begin
       numkeyboard.SetSelect(KeyToName(Key1),true);
       LbDopNew.Caption:=addplus(s) + KeyToName(Key1);
       serr2:='Доп. клавиатура: ' + LbDopNew.Caption + ' не используются ';
    end else serr2 := 'Доп. клавиатура: Недоступно';// else serr2 :=WordToStringKeys(cmd) + ' | ' +combobox2.Items.Strings[ListHotKeys.GetSection(cmd)]
        //             + ' | ' + ListHotKeys.GetAction(cmd);
    label7.Caption := serr1 + ' | ' + serr2;
  end;

  mainkeyboard.Draw(image1.Canvas);
  image1.Repaint;
  numkeyboard.SwapKeys;
  numkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  numkeyboard.Draw(image2.Canvas);
  image2.Repaint;
//end;
end;

procedure TfrHotKeys.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var s : string;
    res : word;
begin
  Key:=0;
  numkeyboard.SwapKeys;
  numkeyboard.SetBusyHotKeys(frHotKeys.ComboBox2.ItemIndex,ListHotKeys);
  numkeyboard.Draw(image2.Canvas);
  image2.Repaint;
  numkeyboard.myshift := false;
end;

procedure TfrHotKeys.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var res : byte;
    cmd : word;
begin
  res := mainkeyboard.MoveMouse(Image1.Canvas, X,Y);
  if res=255 then begin
    Label7.Caption:='';
    exit;
  end;
  cmd := mainkeyboard.GetControlValue + res;
  if mainkeyboard.GetKeyBusy(res) then begin
    Label7.Caption:=WordToStringKeys(cmd) + ' | ' +combobox2.Items.Strings[ListHotKeys.GetSection(cmd)]
                     + ' | ' + ListHotKeys.GetAction(combobox2.ItemIndex, cmd);
  end else begin
    if not (res in [16,17,18])
      then Label7.Caption:=WordToStringKeys(cmd)+' не используется'
      else Label7.Caption:='';
  end;
  mainkeyboard.Draw(Image1.Canvas);
  Image1.Repaint;
end;

end.
