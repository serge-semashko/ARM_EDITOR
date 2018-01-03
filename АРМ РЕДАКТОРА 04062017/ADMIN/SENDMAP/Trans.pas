unit Trans;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

 CONST
   WM_TRANSFER = WM_USER + 1;  // Определяем сообщение

 type
PCompartido =^TCompartido;
  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero    : Integer;
    Shift     : Double;
    Cadena    : String[20];
  end;

(*  -------------------------------------- *)


type
  TForm1 = class(TForm)
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Timer1: TTimer;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    Compartido : PCompartido;
    FicheroM   : THandle;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  myShift : double = 0;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit1.MaxLength:=20;
// создаем память для файла
//  FicheroM:=CreateFileMapping( $FFFFFFFF,nil,PAGE_READWRITE,0,
//                               SizeOf(TCompartido),'MiFichero');
// если создается файл, заполним его нулями
//  if FicheroM=0 then raise Exception.Create( 'Не удалось создать файл'+'/Ошибка при создании файла');

  { Посмотрим, существует ли файл }
  FicheroM:=OpenFileMapping(FILE_MAP_ALL_ACCESS, False,'MiFichero');
  { Если нет, то ошибка }
  if FicheroM = 0 then  FicheroM:=CreateFileMapping( $FFFFFFFF,nil,PAGE_READWRITE,0,SizeOf(TCompartido),'MiFichero');
// если создается файл, заполним его нулями
  if FicheroM=0 then raise Exception.Create( 'Не удалось создать файл'+'/Ошибка при создании файла');


  Compartido:=MapViewOfFile(FicheroM,FILE_MAP_WRITE,0,0,0);

// запись данных в файл памяти
  Compartido^.Manejador1:=Handle;
  Compartido^.Numero:=777;
  Compartido^.Shift := Now;
  Compartido^.Cadena:=Edit1.text;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  { закрываем файл }
  UnmapViewOfFile(Compartido);
   { закрыли ссылку на него }
  CloseHandle(FicheroM);
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  Compartido^.Cadena:=Edit1.Text;
  Compartido^.Shift := Now;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var HH, MM, SS, MS : WORD;
    s, sthh, stmm, stss, stms : string;
    myTime : double;
    dt : tdatetime;
    ps : integer;
begin
  s:=trim(Edit1.Text);

  ps:=pos(':',s);
  sthh := copy(s,1,ps-1);
  s:=copy(s,ps+1,length(s));
  if trim(sthh)='' then sthh:='0';
  hh := strtoint(sthh);
  if hh>23 then hh:=0;

  ps:=pos(':',s);
  stmm := copy(s,1,ps-1);
  s:=copy(s,ps+1,length(s));
  if trim(stmm)='' then stmm:='0';
  mm := strtoint(stmm);
  if mm>59 then mm:=0;

  ps:=pos(':',s);
  stss := copy(s,1,ps-1);
  if trim(stss)='' then stss:='0';
  stms:=copy(s,ps+1,length(s));
  if trim(stms)='' then stms:='0';

  ss := strtoint(stss);
  ms := strtoint(stms);

  if ss>59 then ss:=0;
  if ms>24 then ms:=0;

  myTime := EncodeTime(hh, mm, ss, ms*40);
  dt := Now;
  myShift := dt - (Trunc(dt) + myTime);
  Compartido^.Shift :=myShift;
  if compartido^.Manejador2 <> 0 then PostMessage(Compartido^.Manejador2, WM_TRANSFER,0, 0);
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',':',#8]) then begin
    key:=#0;
    exit;
  end;
end;

function TwoInt(vl : word) : string;
begin
  if vl<=9 then result := '0' + inttostr(vl) else result := inttostr(vl);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var hh, mm, ss, ms : word;
    dt, tm : double;
begin
  dt := now-myshift;
  DecodeTime(dt,hh,mm,ss,ms);
  Label1.Caption:= DateToStr(dt) + '  ' + TwoInt(hh) + ':' + TwoInt(mm) + ':' + TwoInt(ss) + ':' + TwoInt(trunc(ms/40));
end;

end.
