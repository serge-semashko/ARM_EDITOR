unit Recep;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

const
  WM_TRANSFER = WM_USER + 1;

type
  PCompartido =^TCompartido;
  TCompartido = record
    Manejador1: Cardinal;
    Manejador2: Cardinal;
    Numero    : Integer;
    Shift     : Double;
    Cadena    : String[20];
  end;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    Compartido : PCompartido;
    FicheroM   : THandle;
    procedure Reciviendo(var Msg: TMessage); message WM_TRANSFER;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  MyShift : Double = 0;
implementation

{$R *.dfm}

procedure Tform1.Reciviendo(var Msg: TMessage);
begin
  label1.Caption:=compartido^.Cadena;
  MyShift := compartido^.Shift;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  { Посмотрим, существует ли файл }
  FicheroM:=OpenFileMapping(FILE_MAP_ALL_ACCESS, False,'MiFichero');
  { Если нет, то ошибка }
  if FicheroM = 0 then  FicheroM:=CreateFileMapping( $FFFFFFFF,nil,PAGE_READWRITE,0,SizeOf(TCompartido),'MiFichero');
// если создается файл, заполним его нулями
  if FicheroM=0 then raise Exception.Create( 'Не удалось создать файл'+'/Ошибка при создании файла');

  Compartido:=MapViewOfFile(FicheroM,FILE_MAP_WRITE,0,0,0);
  compartido^.Manejador2:=Handle;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnmapViewOfFile(Compartido);
  CloseHandle(FicheroM);
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

  Label2.Caption:= DateToStr(dt) + '  ' + TwoInt(hh) + ':' + TwoInt(mm) + ':' + TwoInt(ss) + ':' + TwoInt(trunc(ms/40));
  //application.ProcessMessages;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  MyShift:=0;
end;

end.
