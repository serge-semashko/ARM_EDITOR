unit UMyChars;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.ExtCtrls, Vcl.Menus;

type
  TForm3 = class(TForm)
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    SpeedButton2: TSpeedButton;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PopupMenu1: TPopupMenu;
    popDelete: TMenuItem;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure StringGrid1TopLeftChanged(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure popDeleteClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function NamePosition(Name: string) : integer;
    function ValuePosition(Name: string) : integer;
  end;

var
  Form3: TForm3;
  InBuffCount : integer = 0;

procedure GridToFile(FileName : string);
procedure GridFromFile(FileName : string);
function DataToBuffIn(strd : string) : integer;
procedure WriteBufferStr(F : tStream; astr : widestring);
Procedure ReadBufferStr(F : tStream; out astr : String); overload;
Procedure ReadBufferStr(F : tStream; out astr : tfontname); overload;
Procedure ReadBufferStr(F : tStream; out astr : widestring); overload;

implementation
uses mainunit, comportunit, umyinitfile;

{$R *.dfm}

function TForm3.NamePosition(Name: string) : integer;
var i : integer;
begin
  result:=-1;
  if trim(Name)='' then exit;
  for i:=1 to Stringgrid1.RowCount-1 do begin
    if lowercase(trim(Name))=lowercase(trim(Stringgrid1.Cells[1,i])) then begin
      result:=i;
      exit;
    end;
  end;
end;

function TForm3.ValuePosition(Name: string) : integer;
var i : integer;
begin
  result:=-1;
  if trim(Name)='' then exit;
  for i:=1 to Stringgrid1.RowCount-1 do begin
    if lowercase(trim(Name))=lowercase(trim(Stringgrid1.Cells[2,i])) then begin
      result:=i;
      exit;
    end;
  end;
end;

procedure WriteBufferStr(F : tStream; astr : widestring);
var Len : longint;
begin
  len:=length(astr);
  F.WriteBuffer(Len, SizeOf(Len));
  if Len > 0 then F.WriteBuffer(astr[1],Length(astr)*SizeOf(astr[1]));
end;

Procedure ReadBufferStr(F : tStream; out astr : String); overload;
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

Procedure ReadBufferStr(F : tStream; out astr : tfontname); overload;
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

Procedure ReadBufferStr(F : tStream; out astr : widestring); overload;
var len : longint;
    ws : widestring;
begin
    F.ReadBuffer(len,sizeof(len));
    Setlength(ws,len);
    if len > 0 then F.ReadBuffer(ws[1],length(ws)*sizeof(ws[1]));
    astr:=ws;
end;

procedure GridToFile(FileName : string);
var Stream : TFileStream;
    i, j, rw, ph : integer;
    sz, ps : longint;
    renm : string;
begin
  if FileExists(FileName) then begin
    renm := ExtractFilePath(FileName) + 'Temp.prjl';
    RenameFile(FileName,renm);
    DeleteFile(renm);
  end;
  Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
  Stream.WriteBuffer(Form3.Stringgrid1.RowCount,SizeOf(integer));
  for i := 0 to Form3.Stringgrid1.RowCount-1 do begin
    // WriteBufferStr(Stream,Form3.StringGrid1.Cells[0,i]);
     WriteBufferStr(Stream,Form3.StringGrid1.Cells[1,i]);
     WriteBufferStr(Stream,Form3.StringGrid1.Cells[2,i]);
  end;
end;

procedure GridFromFile(FileName : string);
var Stream : TFileStream;
    i, j, rw, ph, pp, cnt, cnt1, cnt2 : integer;
    sz, ps : longint;
    renm, s0, s1, s2 : string;
begin
  if not FileExists(FileName) then exit;
  Stream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
  Stream.ReadBuffer(cnt,SizeOf(integer));
  Form3.Stringgrid1.RowCount:=cnt;
  for i := 0 to Form3.Stringgrid1.RowCount-1 do begin
     //ReadBufferStr(Stream,s0);
     if i<>0 then Form3.StringGrid1.Cells[0,i]:=inttostr(i);
     ReadBufferStr(Stream,s1);
     Form3.StringGrid1.Cells[1,i]:=s1;
     ReadBufferStr(Stream,s2);
     Form3.StringGrid1.Cells[2,i]:=s2;
  end;
end;

function chartohex(ch:char) : byte;
begin
     case ch of
  '0','1','2','3','4','5','6','7','8','9' : result:=strtoint(ch);
  'a','A' : result:=10;
  'b','B' : result:=11;
  'c','C' : result:=12;
  'd','D' : result:=13;
  'e','E' : result:=14;
  'f','F' : result:=15;
     end;
end;

function StrToByte(stri : string) : byte;
var ch1, ch2 : char;
begin
   ch2:=stri[1];
   ch1:=stri[2];
   result := chartohex(ch2) * 16 + chartohex(ch1);
end;

function DataToBuffIn(strd : string) : integer;
var stri, shex : string;
    i, j : integer;
    bt : byte;
begin
  stri:=trim(strd);
  if (length(stri) div 2)<>0 then stri:=stri+'0';
  i:=1;
  j:=0;
  while i<length(stri) do begin
    shex:=stri[i]+stri[i+1];
    bt:=StrToByte(shex);
    InBuff[j]:=AnsiChar(chr(bt));
    i:=i+2;
    j:=j+1;
  end;
  result:=j
end;

procedure TForm3.Edit1Change(Sender: TObject);
var stri, shex : string;
    i, j : integer;
    bt : byte;
begin
  stri:=trim(Edit1.Text);
  if (length(stri) div 2)<>0 then stri:=stri+'0';
  i:=1;
  j:=0;
  Label4.Caption:='';
  while i<length(stri) do begin
    shex:=stri[i]+stri[i+1];
    bt:=StrToByte(shex);
    Label4.Caption:=Label4.Caption+'['+inttohex(bt)+']';
    InBuff[j]:=AnsiChar(chr(bt));
    i:=i+2;
    j:=j+1;
  end;
  inbuffcount:=j
end;

procedure TForm3.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if key=46 then key:=0;
end;

procedure TForm3.Edit1KeyPress(Sender: TObject; var Key: Char);
var s : string;
begin
       case key of
  'ф','Ф','a' : key:='A';
  'и','И','b' : key:='B';
  'с','С','c' : key:='C';
  'в','В','d' : key:='D';
  'у','У','e' : key:='E';
  'а','А','f' : key:='F';
       end;
  if Not (Key in [#8,'0','1'..'9','a','A','b','B','c','C','d','D','e','E','f','F']) then begin
    Key:=#0;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Edit1.Text:='';
  label4.Caption:='';
  Stringgrid1.RowCount:=2;
  Stringgrid1.ColCount:=3;
  Stringgrid1.Cells[0,0]:='№';
  Stringgrid1.Cells[1,0]:='Команда';
  Stringgrid1.Cells[2,0]:='Значение';
  Stringgrid1.ColWidths[0]:=50;
  Stringgrid1.ColWidths[1]:=200;
  Stringgrid1.ColWidths[2]:=Stringgrid1.Width-Stringgrid1.ColWidths[1]-Stringgrid1.ColWidths[0];
  SpeedButton2.Enabled:=false;
  Caption:='COM-порт неинициализирован';
  GridFromFile(GridFile);
end;

procedure TForm3.FormResize(Sender: TObject);
begin
  Edit1.Width:=Panel4.Width;
  Edit2.Width:=Panel4.Width;
end;

procedure TForm3.popDeleteClick(Sender: TObject);
var i : integer;
begin
  if stringgrid1.RowCount=2 then begin
     Stringgrid1.Cells[0,1]:='';
     Stringgrid1.Cells[1,1]:='';
     Stringgrid1.Cells[2,1]:='';
  end else begin
     if stringgrid1.Row>0 then begin
       for i:=stringgrid1.Row to stringgrid1.RowCount-2 do begin
         Stringgrid1.Cells[0,i]:=inttostr(i);
         Stringgrid1.Cells[1,i]:=Stringgrid1.Cells[1,i+1];
         Stringgrid1.Cells[2,i]:=Stringgrid1.Cells[2,i+1];
       end;
       stringgrid1.RowCount:=stringgrid1.RowCount-1;
     end;
  end;
  Edit1.Text:='';
  Edit2.Text:='';
end;

procedure TForm3.SpeedButton1Click(Sender: TObject);
var i, posi, posv : integer;
begin
  posi:=NamePosition(Edit2.Text);
  posv:=ValuePosition(Edit1.Text);
  if posv<>-1 then begin
     if lowercase(trim(Stringgrid1.Cells[1,posv]))<>lowercase(trim(Edit2.Text)) then begin
       if MessageDlg('Значение <' + trim(Edit1.Text) + '> уже существует.  Переименовать?',
            mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then begin
               Stringgrid1.Cells[1,posv]:=trim(Edit2.Text);
               Stringgrid1.Row:=posv;
            end;
     end;
  end else begin
   if posi=-1 then begin
      if Edit2.Text<>'' then begin
        if (trim(Stringgrid1.Cells[1,1])='') and (Stringgrid1.RowCount=2) then begin
          Stringgrid1.Cells[0,1]:='1';
          Stringgrid1.Cells[1,1]:=trim(Edit2.Text);
          Stringgrid1.Cells[2,1]:=trim(Edit1.Text);
          Stringgrid1.Row:=1;
        end else begin
          stringgrid1.RowCount:=stringgrid1.RowCount+1;
          Stringgrid1.Cells[0,stringgrid1.RowCount-1]:=inttostr(stringgrid1.RowCount-1);
          Stringgrid1.Cells[1,stringgrid1.RowCount-1]:=trim(Edit2.Text);
          Stringgrid1.Cells[2,stringgrid1.RowCount-1]:=trim(Edit1.Text);
          Stringgrid1.Row:=stringgrid1.RowCount-1;
        end;
      end;
    end else begin
      if MessageDlg('Команда <' + trim(Edit2.Text) + '> уже существует.  Заменить?',
            mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then begin
        Stringgrid1.Cells[2,posi]:=trim(Edit1.Text);
        Stringgrid1.Row:=posi;
      end;
    end;
  end;
end;

procedure TForm3.SpeedButton2Click(Sender: TObject);
begin
  Edit1Change(nil);
  WriteBuffToPort(InBuffCount);
  //fmMain.edWriteStr.Clear;
  //fmMain.edWriteStr.Text:=Label3.Caption;
end;

procedure TForm3.SpeedButton3Click(Sender: TObject);
begin
  Edit1.Text:='';
  Edit2.Text:='';
end;

procedure TForm3.SpeedButton4Click(Sender: TObject);
begin
  opendialog1.FileName:=extractfilename(GridFile);
  if not opendialog1.Execute then exit;
  GridFile:=opendialog1.FileName;
  GridFromFile(GridFile);
end;

procedure TForm3.SpeedButton5Click(Sender: TObject);
var ext : string;
begin
  savedialog1.FileName:=extractfilename(GridFile);
  if not savedialog1.Execute then exit;
  GridFile:=savedialog1.FileName;
  ext:=extractfileext(GridFile);
  if trim(ext)='' then GridFile:=CommandFile+'.grid';
  GridToFile(GridFile);
end;

procedure TForm3.SpeedButton6Click(Sender: TObject);
begin
  Stringgrid1.RowCount:=2;
  Stringgrid1.Cells[0,1]:='';
  Stringgrid1.Cells[1,1]:='';
  Stringgrid1.Cells[2,1]:='';
end;

procedure TForm3.StringGrid1Click(Sender: TObject);
begin
  if stringgrid1.Row>0 then begin
    Edit1.Text:=Stringgrid1.Cells[2,Stringgrid1.Row];
    Edit2.Text:=Stringgrid1.Cells[1,Stringgrid1.Row];
  end;
end;

procedure TForm3.StringGrid1TopLeftChanged(Sender: TObject);
begin
  StringGrid1.LeftCol:=1;
end;

end.
