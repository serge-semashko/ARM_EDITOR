unit UMyOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Math, FastDIB,
  FastFX, FastSize, FastFiles, FConvert, FastBlend, Vcl.StdCtrls;

type
  TMyTypeOption = (tomInteger, tomFloat, tomString, tomBoolean, tomColor, tomFontName);
  TOneOption = class
    Name        : string;
    rtname      : trect;
    Value       : String;
    rtval       : trect;
    TypeData    : TMyTypeOption;
    Variants    : tstrings;
    procedure   Draw(dib : tfastdib);
    constructor Create(SName, SValue : string; TypeD : TMyTypeOption; Left, Top, Width, Height : integer);
    destructor  destroy;
  end;

  TGroupOptions = class
    Count : integer;
    Options : array of TOneOption;
    function  adddata(SName, SValue : string; TypeD : TMyTypeOption;  Left, Top, Width, Height : integer) : integer;
    procedure   setdata(SName : string; SValue : string); overload;
    procedure   setdata(Posi : integer; SValue : string); overload;
    function    getdata(SName : string) : string; overload;
    function    getdata(Posi : integer) : string; overload;
    procedure   AddVariant(Name : string; Variant : string); overload;
    procedure   AddVariant(Posi : integer; Variant : string); overload;
    procedure   ClearVariants(Name : string); overload;
    procedure   ClearVariants(Posi : integer); overload;
    procedure   setborder(posi, left, width : integer);
    procedure   Draw(cv : tcanvas);
    function    MouseClick(cv : tcanvas; X, Y : integer) : integer;
    procedure   clear;
    constructor create;
    destructor  destroy;
  end;

  TListOptions = class
    Count       : integer;
    Groups      : array of TGroupOptions;
    procedure   clear;
    function    Add : integer;
    procedure   LoadData;
    procedure   SaveData;
    constructor create;
    destructor  destroy;
  end;

   TOnePartition = class
    Text : string;
    Select : boolean;
    Rect : trect;
    constructor create(Txt : string; RT : TRect);
    destructor destroy;
  end;

  TListPartitions = class
    RowHeight   : integer;
    Count       : integer;
    List        : array of TOnePartition;
    procedure   clear;
    procedure   Add(Text : string);
    procedure   init;
    function    index : integer;
    procedure   Draw(cv : tcanvas);
    procedure   MouseMove(cv : tcanvas; X, Y : integer);
    function    MouseClick(cv : tcanvas; X, Y : integer) : integer;
    constructor create;
    destructor  destroy;
  end;

  TFrMyOptions = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    imgPartitions: TImage;
    imgOptions: TImage;
    imgButtons: TImage;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ColorDialog1: TColorDialog;
    procedure Panel1Resize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgPartitionsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgButtonsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgButtonsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgOptionsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgPartitionsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    TypeEditor     : TMyTypeOption;
    IndexPartition : integer;
    IndexOption    : integer;
  public
    { Public declarations }
  end;

var
  FrMyOptions: TFrMyOptions;
  ListPartitions : TListPartitions;
  ListOptions : TListOptions;
procedure SetOptions;

implementation
uses umain, ucommon, uinitforms, uimgbuttons, umytexttable, ugrid, ubuttonoptions,
     uimagetemplate;

{$R *.dfm}


procedure SetOptions;
var indx : integer;
begin
  FrMyOptions.Edit1.Visible:=false;
  FrMyOptions.ComboBox1.Visible:=false;
  indx := ListPartitions.index;
  if indx=-1 then begin
    ListPartitions.List[0].Select:=true;
    indx:=0;
  end;
  ListOptions.LoadData;
  ListPartitions.Draw(FrMyOptions.imgPartitions.Canvas);
  FrMyOptions.imgPartitions.Repaint;
  ListOptions.Groups[indx].Draw(FrMyOptions.imgOptions.Canvas);
  FrMyOptions.imgOptions.Repaint;
  FrMyOptions.ShowModal;
  if FrMyOptions.ModalResult=mrOk then begin
    FrMyOptions.Edit1.Visible:=false;
    FrMyOptions.ComboBox1.Visible:=false;
  end;
end;


constructor TListOptions.create;
begin
  Count:=0;
end;

destructor TListOptions.destroy;
begin
  clear;
  freemem(@Count);
  freemem(@Groups);
end;

procedure TListOptions.clear;
var i : integer;
begin
  for i:=Count-1 downto 0 do begin
    Groups[Count-1].FreeInstance;
    Count:=Count-1;
    SetLength(Groups,Count);
  end;
  Count := 0;
end;

function TListOptions.Add : integer;
begin
  Count:=Count+1;
  SetLength(Groups,Count);
  Groups[Count-1] := TGroupOptions.create;
  result:=Count-1;
end;

constructor TOnePartition.create(Txt : string; RT : TRect);
begin
  Text := Txt;
  Select := false;
  Rect.Left := RT.Left;
  Rect.Right := RT.Right;
  Rect.Top := RT.Top;
  Rect.Bottom := RT.Bottom;
end;

destructor TOnePartition.destroy;
begin
  freemem(@Text);
  freemem(@Select);
  freemem(@Rect);
end;

constructor TListPartitions.create;
begin
  RowHeight:=22;
  Count:=0;
end;

destructor TListPartitions.destroy;
begin
  freemem(@RowHeight);
  Clear;
  freemem(@Count);
  freemem(@List);
end;

procedure TListPartitions.init;
begin
  Clear;
  Add('����� ���������');
  Add('�������� ���� ���������');
  Add('�������������� ����');
  Add('����� ������');
  Add('������ ������');
  Add('������� ������');
  Add('������� ����-�����');
  Add('��������� �������');
  Add('���� ���� ');
  Add('������');
end;

function TListPartitions.Index : integer;
var i : integer;
begin
  result:=0;
  for i:=0 to Count-1 do begin
    if List[i].Select then begin
      result:=i;
      exit;
    end;
  end;
end;

procedure TListPartitions.clear;
var i : integer;
begin
  for i:=Count-1 downto 0 do begin
    List[Count-1].FreeInstance;
    Count:=Count-1;
    setlength(List,Count);
  end;
  Count:=0;
end;

procedure TListPartitions.Add(Text : string);
var rt : trect;
begin
  Count:=Count+1;
  SetLength(List,Count);
  rt.Left:=10;
  rt.Right:=100;
  rt.Top:=30 + (Count-1)*RowHeight;
  rt.Bottom:=rt.Top+RowHeight;
  List[Count-1] := TOnePartition.create(Text,rt);
end;

procedure TListOptions.LoadData;
var ARow, ps, i, j : integer;
    strdt : string;
    clr : tcolor;
    ch : char;
begin
  Clear;
  ARow:=Add;  //0
  Groups[ARow].clear;
  ps := 20;
  if InputWithoutUsers then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('���� ��� ������',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if MakeLogging then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('�������� �����������',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������� ������� UNDO',inttostr(DepthUNDO),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���������� ������� ������������� (msec)',inttostr(SynchDelay),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('����� ����� ������� �� ��������� (����)',inttostr(DeltaDateDelete),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('�������� ������ �������',inttostr(PrintEventShift),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('��� ����������� ������ ���� (�����)',inttostr(StepMouseWheel),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  //  PrintEventShift      : integer = 30;
  //�������� ��������� ���������
//  MainWindowStayOnTop : boolean = false;
//  MainWindowMove : boolean = true;
//  MainWindowSize : boolean = true;


//  WorkDirGRTemplate : string ='';
//  WorkDirTextTemplate  : string ='';
//  WorkDirClips  : string ='';
//  WorkDirSubtitors  : string ='';
//  WorkDirKeyLayouts : string = '';

  ARow:=Add; //1
  Groups[ARow].clear;
  ps := 20;
  Groups[ARow].adddata('���� ���� ���������',IntToStr(ProgrammColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('��� ������',ProgrammFontName,tomFontName,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������',inttostr(ProgrammFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=8 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ���� � ����������',inttostr(MTFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=8 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������',inttostr(ProgrammFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ���� ��������������',IntToStr(ProgrammEditColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('��� ������ ���� ��������������',ProgrammEditFontName,tomFontName,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ���� ��������������',inttostr(ProgrammEditFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=8 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������ ���� ��������������',IntToStr(ProgrammEditFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  //  ProgrammCommentColor : tcolor = clYellow;
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ������',inttostr(ProgrammBtnFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=8 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('��� ������ ���������� � ������',ProgrammHintBtnFontName,tomFontName,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������ ���������� � ������',IntToStr(ProgrammHintBTNSFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ��������� � ������',inttostr(ProgrammHintBTNSFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=8 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));

//�������� ��������� ��������������� ����
  ARow:=Add; //2
  Groups[ARow].clear;
  ps := 20;
  Groups[ARow].adddata('���� �����',IntToStr(FormsColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('��� ������',FormsFontName,tomFontName,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������',inttostr(FormsFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=8 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ���������������� ������',inttostr(FormsSmallFont),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=8 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������',inttostr(FormsFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ���� ��������������',IntToStr(FormsEditColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('��� ������ ���� ��������������',FormsEditFontName,tomFontName,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ���� ��������������',inttostr(FormsEditFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=8 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������ ���� ��������������',IntToStr(FormsEditFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

//�������� ����� ������

  ARow:=Add; //3
  Groups[ARow].clear;
  ps := 20;
  Groups[ARow].adddata('���� ���� �������',IntToStr(GridBackGround),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
//  ps:=ps + FrMyOptions.ComboBox1.Height;
//  Groups[ARow].adddata('���� ����� �������',IntToStr(GridColorPen),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
//  ps:=ps + FrMyOptions.ComboBox1.Height;
//  Groups[ARow].adddata('���� ��������� ������',IntToStr(GridMainFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������ ����� �������',IntToStr(GridColorRow1),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� �������� ����� �������',IntToStr(GridColorRow2),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ��������� ������ �������',IntToStr(GridColorSelection),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������ ��������������',IntToStr(PhraseErrorColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������ ������������ �����',IntToStr(PhrasePlayColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ���������� �������� ������',IntToStr(MyCellColorTrue),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� �� ���������� �������� ������',IntToStr(MyCellColorFalse),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� �������� ���������� �������',IntToStr(MyCellColorSelect),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);


//������ ������
  ARow:=Add; //4
  Groups[ARow].clear;

  ps:=20;
  Groups[ARow].adddata('��� ������ ���������',GridTitleFontName,tomFontName,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������ ���������',IntToStr(GridTitleFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ���������',IntToStr(GridTitleFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=8 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if GridTitleFontBold then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������� ����� ���������',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if GridTitleFontItalic then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('��������� ����� ���������',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if GridTitleFontUnderline then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������������ ����� ���������',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('��� ��������� ������',GridFontName,tomFontName,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ��������� ������',IntToStr(GridFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ��������� ������',IntToStr(GridFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=7 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if GridFontBold then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������� �������� �����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if GridFontItalic then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('��������� �������� �����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if GridFontUnderline then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������������ �������� �����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');
//
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('��� ��������������� ������',GridSubFontName,tomFontName,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ��������������� ������',IntToStr(GridSubFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ��������������� ������',IntToStr(GridSubFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=6 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if GridSubFontBold then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������� �������������� �����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if GridSubFontItalic then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('��������� �������������� �����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');
  ps:=ps + FrMyOptions.ComboBox1.Height;
  if GridSubFontUnderline then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������������ �������������� �����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');


//������� ������
  ARow:=Add; //5
  Groups[ARow].clear;

  ps:=20;
  //Groups[ARow].adddata('����-����� ������ ���������',IntToStr(ProjectHeightTitle),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  //ps:=ps + FrMyOptions.ComboBox1.Height;
  //Groups[ARow].adddata('����-����� ������ ������',IntToStr(ProjectHeightRow),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  //ps:=ps + FrMyOptions.ComboBox1.Height;
  //Groups[ARow].adddata('����-����� ������ ������ 1-�� ������',IntToStr(ProjectRowsTop),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  //ps:=ps + FrMyOptions.ComboBox1.Height;
  //Groups[ARow].adddata('����-����� ������ ������',IntToStr(ProjectRowsHeight),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  //ps:=ps + FrMyOptions.ComboBox1.Height;
  //Groups[ARow].adddata('����-����� �������� ����� ��������',IntToStr(ProjectRowsInterval),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);

  //ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ����-������ ������ ���������',IntToStr(PLHeightTitle),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ����-������ ������ ������',IntToStr(PLHeightRow),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ����-������ ������ ������ 1-�� ������',IntToStr(PLRowsTop),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ����-������ ������ ������',IntToStr(PLRowsHeight),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ����-������ �������� ����� ��������',IntToStr(PLRowsInterval),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ������ ���������',IntToStr(ClipsHeightTitle),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ������ ������',IntToStr(ClipsHeightRow),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ������ ������ 1-�� ������',IntToStr(ClipsRowsTop),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ ������ ������',IntToStr(ClipsRowsHeight),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ������ �������� ����� ��������',IntToStr(ClipsRowsInterval),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);


//
//  GridGrTemplateSelect : boolean = true;
//  RowGridGrTemplateSelect : integer = -1;
//
//�������� ��������� ����-�����
  ARow:=Add; //6
  Groups[ARow].clear;

  ps:=20;
  Groups[ARow].adddata('���� ������� ����',IntToStr(TLBackGround),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ��������� ����',IntToStr(TLZoneNamesColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('��� ��������� ������',TLZoneNamesFontName,tomFontName,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ��������� ������',IntToStr(TLZoneNamesFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������ ��� ��������',IntToStr(TLZoneFontColorSelect),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ��������� ������',IntToStr(TLZoneNamesFontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  for i:=7 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));

  ps:=ps + FrMyOptions.ComboBox1.Height;
  if TLZoneNamesFontBold then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������� �������� �����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');

  ps:=ps + FrMyOptions.ComboBox1.Height;
  if TLZoneNamesFontItalic then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('��������� �������� �����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');

  ps:=ps + FrMyOptions.ComboBox1.Height;
  if TLZoneNamesFontUnderline then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������������ �������� �����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');


  ps:=ps + FrMyOptions.ComboBox1.Height;
  if TLZoneEditFontBold then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������� ����� ������. ����-�����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');

  ps:=ps + FrMyOptions.ComboBox1.Height;
  if TLZoneEditFontItalic then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('��������� ����� ������. ����-�����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');

  ps:=ps + FrMyOptions.ComboBox1.Height;
  if TLZoneEditFontUnderline then strdt:='��' else strdt:='���';
  Groups[ARow].adddata('������������ ����� ������. ����-�����',strdt,tomBoolean,10,ps,300,FrMyOptions.ComboBox1.Height);
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'��');
  Groups[ARow].AddVariant(Groups[ARow].Count-1,'���');

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������� 1',IntToStr(StatusColor[0]),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������� 2',IntToStr(StatusColor[1]),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������� 3',IntToStr(StatusColor[2]),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������� 4',IntToStr(StatusColor[3]),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������� 5',IntToStr(StatusColor[4]),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������. ���-�� ����-�����',IntToStr(TLMaxCount),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('����. ���-�� ����-����� ���������',IntToStr(TLMaxDevice),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('����. ���-�� ��������� ����-�����',IntToStr(TLMaxText),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('����. ���-�� ����� ����-�����',IntToStr(TLMaxMedia),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);

  ARow:=Add; //7
  Groups[ARow].clear;

  ps:=20;
  Groups[ARow].adddata('����������� ������� ����� (�����)',inttostr(DefaultClipDuration),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���-�� ������ �� �������',inttostr(TLPreroll),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���-�� ������ ����� �������',inttostr(TLPostroll),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���-�� ������ �������',inttostr(TLFlashDuration),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������� ���',IntToStr(StartColorCursor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������� ���',IntToStr(EndColorCursor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  //ps:=ps + FrMyOptions.ComboBox1.Height;
  //Groups[ARow].adddata('���� ������ ����� �������',IntToStr(TLFontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);


  ARow:=Add; //8
  Groups[ARow].clear;

  ps:=20;
  Groups[ARow].adddata('���������� ������������ �������',IntToStr(RowsEvents),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������� ���� ���� �������',IntToStr(AirBackGround),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� �������� ���� ���� �������',IntToStr(AirForeGround),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� �������',IntToStr(AirColorTimeline),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ���� ���� ���������',IntToStr(DevBackGround),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ����� ����-����',IntToStr(TimeForeGround),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ��������� ��������',IntToStr(TimeSecondColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� ������ �����������',IntToStr(AirFontComment),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

//  ps:=ps + FrMyOptions.ComboBox1.Height;
//  Groups[ARow].adddata('���� ������ ����� �������',IntToStr(Layer2FontColor),tomColor,10,ps,300,FrMyOptions.ComboBox1.Height);

//  ps:=ps + FrMyOptions.ComboBox1.Height;
//  Groups[ARow].adddata('������ ������ ����� �������',IntToStr(Layer2FontSize),tomInteger,10,ps,300,FrMyOptions.ComboBox1.Height);
//  for i:=7 to 32 do Groups[ARow].AddVariant(Groups[ARow].Count-1,inttostr(i));


// DefaultMediaColor : tcolor = $00d8a520;
//  DefaultTextColor : tcolor = $00aceae1;

// //�������� ��������� ������
//  ProgBTNSFontName : tfontname = 'Arial';
//  ProgBTNSFontColor : tcolor = clWhite;
//  ProgBTNSFontSize : Integer = 10;
//  HintBTNSFontName : tfontname = 'Arial';
// HintBTNSFontColor : tcolor = clBlack;
//  HintBTNSFontSize : Integer = 9;


//�������� ��������� ������
  ARow:=Add; //9
  Groups[ARow].clear;
  ps := 20;
  ch:=formatsettings.DecimalSeparator;
  formatsettings.DecimalSeparator := '.';
  Groups[ARow].adddata('����� ����',FloatToStr(PrintSpaceLeft),tomfloat,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������� ����',FloatToStr(PrintSpaceTop),tomfloat,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ����',FloatToStr(PrintSpaceRight),tomfloat,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ����',FloatToStr(PrintSpaceBottom),tomfloat,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������� ����������',FloatToStr(PrintHeadLineTop),tomfloat,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('������ ����������',FloatToStr(PrintHeadLineBottom),tomfloat,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('�������� ������� �������',PrintCol1,tomstring,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('�������� ������� �������',PrintCol2,tomstring,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('�������� �������� �������',PrintCol3,tomstring,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('�������� ���������� �������',PrintCol4,tomstring,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('�������� ������ �������',PrintCol5,tomstring,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('�������� ������� ������� ���.1',PrintCol61,tomstring,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('�������� ������� ������� ���.2',PrintCol62,tomstring,10,ps,300,FrMyOptions.ComboBox1.Height);
  ps:=ps + FrMyOptions.ComboBox1.Height;
  Groups[ARow].adddata('���� �������� ����������',PrintDeviceName,tomstring,10,ps,300,FrMyOptions.ComboBox1.Height);
  formatsettings.DecimalSeparator := ch;


//
//  //�������� ��������� ������ ������� ������
//  KEYFontName    : tfontname;
//  KEYColorNew    : tcolor = clLime;
////  WorkHotKeys    : TMyListHotKeys;
///  NAMEKeyLayout  : string;
//

end;

procedure TListOptions.SaveData;
var s : string;
    APos : integer;
    i, j, k, n: Integer;
    ch : char;
begin
  APos:=0;
  if trim(Groups[APos].getdata('���� ��� ������'))='��'
    then InputWithoutUsers:=true else InputWithoutUsers:=false;

  if trim(Groups[APos].getdata('�������� �����������'))='��'
    then MakeLogging:=true else MakeLogging:=false;

  s:=trim(Groups[APos].getdata('������� ������� UNDO'));
  if s='' then DepthUNDO:=10 else DepthUNDO:=strtoint(s);

  s:=trim(Groups[APos].getdata('���������� ������� ������������� (msec)'));
  if s='' then SynchDelay:=0 else SynchDelay:=strtoint(s);

  s:=trim(Groups[APos].getdata('����� ����� ������� �� ��������� (����)'));
  if s='' then DeltaDateDelete:=0 else DeltaDateDelete:=strtoint(s);

  s:=trim(Groups[APos].getdata('�������� ������ �������'));
  if s='' then PrintEventShift:=0 else PrintEventShift:=strtoint(s);

  s:=trim(Groups[APos].getdata('��� ����������� ������ ���� (�����)'));
  if s='' then StepMouseWheel:=StepMouseWheel else StepMouseWheel:=strtoint(s);

//==============================================================================

  APos:=1;
  s:=trim(Groups[APos].getdata('���� ���� ���������'));
  if s='' then ProgrammColor:=ProgrammColor else ProgrammColor:=strtoint(s);

  s:=trim(Groups[APos].getdata('��� ������'));
  if s='' then ProgrammFontName:=ProgrammFontName else ProgrammFontName:=s;

  s:=trim(Groups[APos].getdata('������ ������'));
  if s='' then ProgrammFontSize:=ProgrammFontSize else ProgrammFontSize:=strtoint(s);

  s:=trim(Groups[APos].getdata('������ ������ ���� � ����������'));
  if s='' then MTFontSize:=MTFontSize else MTFontSize:=strtoint(s);
  MTFontSizeS :=MTFontSize + 1;
  MTFontSizeB :=MTFontSize + 3;

  s:=trim(Groups[APos].getdata('���� ������'));
  if s='' then ProgrammFontColor:=ProgrammFontColor else ProgrammFontColor:=strtoint(s);

  s:=trim(Groups[APos].getdata('���� ���� ��������������'));
  if s='' then ProgrammEditColor:=ProgrammEditColor else ProgrammEditColor:=strtoint(s);

  s:=trim(Groups[APos].getdata('��� ������ ���� ��������������'));
  if s='' then ProgrammEditFontName:=ProgrammEditFontName else ProgrammEditFontName:=s;

  s:=trim(Groups[APos].getdata('������ ������ ���� ��������������'));
  if s='' then ProgrammEditFontSize:=ProgrammEditFontSize else ProgrammEditFontSize:=strtoint(s);

  s:=trim(Groups[APos].getdata('���� ������ ���� ��������������'));
  if s='' then ProgrammEditFontColor:=ProgrammEditFontColor else ProgrammEditFontColor:=strtoint(s);

  s:=trim(Groups[APos].getdata('������ ������ ������'));
  if s='' then ProgrammBtnFontSize:=ProgrammBtnFontSize else ProgrammBtnFontSize:=strtoint(s);

  s:=trim(Groups[APos].getdata('��� ������ ���������� � ������'));
  if s='' then ProgrammHintBtnFontName:=ProgrammHintBtnFontName else ProgrammHintBtnFontName:=s;

  s:=trim(Groups[APos].getdata('���� ������ ���������� � ������'));
  if s='' then ProgrammHintBTNSFontColor:=ProgrammHintBTNSFontColor else ProgrammHintBTNSFontColor:=strtoint(s);

  s:=trim(Groups[APos].getdata('������ ������ ��������� � ������'));
  if s='' then ProgrammHintBTNSFontSize:=ProgrammHintBTNSFontSize else ProgrammHintBTNSFontSize:=strtoint(s);

//==============================================================================

  APos:=2;
  s:=trim(Groups[APos].getdata('���� �����'));
  if s='' then FormsColor:=FormsColor else FormsColor:=strtoint(s);

  s:=trim(Groups[APos].getdata('��� ������'));
  if s='' then FormsFontName:=FormsFontName else FormsFontName:=s;

  s:=trim(Groups[APos].getdata('������ ������'));
  if s='' then FormsFontSize:=FormsFontSize else FormsFontSize:=strtoint(s);

  s:=trim(Groups[APos].getdata('������ ���������������� ������'));
  if s='' then FormsSmallFont:=FormsSmallFont else FormsSmallFont:=strtoint(s);

  s:=trim(Groups[APos].getdata('���� ������'));
  if s='' then FormsFontColor:=FormsFontColor else FormsFontColor:=strtoint(s);

  s:=trim(Groups[APos].getdata('���� ���� ��������������'));
  if s='' then FormsEditColor:=FormsEditColor else FormsEditColor:=strtoint(s);

  s:=trim(Groups[APos].getdata('��� ������ ���� ��������������'));
  if s='' then FormsEditFontName:=FormsEditFontName else FormsEditFontName:=s;

  s:=trim(Groups[APos].getdata('������ ������ ���� ��������������'));
  if s='' then FormsEditFontSize:=FormsEditFontSize else FormsEditFontSize:=strtoint(s);

  s:=trim(Groups[APos].getdata('���� ������ ���� ��������������'));
  if s='' then FormsEditFontColor:=FormsEditFontColor else FormsEditFontColor:=strtoint(s);
//==============================================================================
  APos:=3;

  s:=trim(Groups[APos].getdata('���� ���� �������'));
  if s='' then GridBackGround:=GridBackGround else GridBackGround:=strtoint(s);
//  s:=trim(Groups[APos].getdata('���� ����� �������'));
//  if s='' then GridColorPen:=GridColorPen else GridColorPen:=strtoint(s);
//  s:=trim(Groups[APos].getdata('���� ��������� ������'));
//  if s='' then GridMainFontColor:=GridMainFontColor else GridMainFontColor:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������ ����� �������'));
  if s='' then GridColorRow1:=GridColorRow1 else GridColorRow1:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� �������� ����� �������'));
  if s='' then GridColorRow2:=GridColorRow2 else GridColorRow2:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ��������� ������ �������'));
  if s='' then GridColorSelection:=GridColorSelection else GridColorSelection:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������ ��������������'));
  if s='' then PhraseErrorColor:=PhraseErrorColor else PhraseErrorColor:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������ ������������ �����'));
  if s='' then PhrasePlayColor:=PhrasePlayColor else PhrasePlayColor:=strtoint(s);

  s:=trim(Groups[APos].getdata('���� ���������� �������� ������'));
  if s='' then MyCellColorTrue:=MyCellColorTrue else MyCellColorTrue:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� �� ���������� �������� ������'));
  if s='' then MyCellColorFalse:=MyCellColorFalse else MyCellColorFalse:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� �������� ���������� �������'));
  if s='' then MyCellColorSelect:=MyCellColorSelect else MyCellColorSelect:=strtoint(s);

//==============================================================================
  APos:=4;
  s:=trim(Groups[APos].getdata('��� ������ ���������'));
  if s='' then GridTitleFontName:=GridTitleFontName else GridTitleFontName:=s;
  s:=trim(Groups[APos].getdata('���� ������ ���������'));
  if s='' then GridTitleFontColor:=GridTitleFontColor else GridTitleFontColor:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ������ ���������'));
  if s='' then GridTitleFontSize:=GridTitleFontSize else GridTitleFontSize:=strtoint(s);
  if trim(Groups[APos].getdata('������� ����� ���������'))='��'
    then GridTitleFontBold:=true else GridTitleFontBold:=false;
  if trim(Groups[APos].getdata('��������� ����� ���������'))='��'
    then GridTitleFontItalic:=true else GridTitleFontItalic:=false;
  if trim(Groups[APos].getdata('������������ ����� ���������'))='��'
    then GridTitleFontUnderline:=true else GridTitleFontUnderline:=false;


  s:=trim(Groups[APos].getdata('��� ��������� ������'));
  if s='' then GridFontName:=GridFontName else GridFontName:=s;
  s:=trim(Groups[APos].getdata('���� ��������� ������'));
  if s='' then GridFontColor:=GridFontColor else GridFontColor:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ��������� ������'));
  if s='' then GridFontSize:=GridFontSize else GridFontSize:=strtoint(s);
  if trim(Groups[APos].getdata('������� �������� �����'))='��'
    then GridFontBold :=true else GridFontBold :=false;
  if trim(Groups[APos].getdata('��������� �������� �����'))='��'
    then GridFontItalic:=true else GridFontItalic:=false;
  if trim(Groups[APos].getdata('������������ �������� �����'))='��'
    then GridFontUnderline:=true else GridFontUnderline:=false;


  s:=trim(Groups[APos].getdata('��� ��������������� ������'));
  if s='' then GridSubFontName:=GridSubFontName else GridSubFontName:=s;
  s:=trim(Groups[APos].getdata('���� ��������������� ������'));
  if s='' then GridSubFontColor:=GridSubFontColor else GridSubFontColor:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ��������������� ������'));
  if s='' then GridSubFontSize:=GridSubFontSize else GridSubFontSize:=strtoint(s);
  if trim(Groups[APos].getdata('������� �������������� �����'))='��'
    then GridSubFontBold :=true else GridSubFontBold :=false;
  if trim(Groups[APos].getdata('��������� �������������� �����'))='��'
    then GridSubFontItalic:=true else GridSubFontItalic:=false;
  if trim(Groups[APos].getdata('������������ �������������� �����'))='��'
    then GridSubFontUnderline:=true else GridSubFontUnderline:=false;

//==============================================================================
  APos:=5;

  //s:=trim(Groups[APos].getdata('����-����� ������ ���������'));
  //if s='' then ProjectHeightTitle:=ProjectHeightTitle else ProjectHeightTitle:=strtoint(s);
  //s:=trim(Groups[APos].getdata('����-����� ������ ������'));
  //if s='' then ProjectHeightRow:=ProjectHeightRow else ProjectHeightRow:=strtoint(s);
  //s:=trim(Groups[APos].getdata('����-����� ������ ������ 1-�� ������'));
  //if s='' then ProjectRowsTop:=ProjectRowsTop else ProjectRowsTop:=strtoint(s);
  //s:=trim(Groups[APos].getdata('����-����� ������ ������'));
  //if s='' then ProjectRowsHeight:=ProjectRowsHeight else ProjectRowsHeight:=strtoint(s);
  //s:=trim(Groups[APos].getdata('����-����� �������� ����� ��������'));
  //if s='' then ProjectRowsInterval:=ProjectRowsInterval else ProjectRowsInterval:=strtoint(s);


  s:=trim(Groups[APos].getdata('������ ����-������ ������ ���������'));
  if s='' then PLHeightTitle:=PLHeightTitle else PLHeightTitle:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ����-������ ������ ������'));
  if s='' then PLHeightRow:=PLHeightRow else PLHeightRow:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ����-������ ������ ������ 1-�� ������'));
  if s='' then PLRowsTop:=PLRowsTop else PLRowsTop:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ����-������ ������ ������'));
  if s='' then PLRowsHeight:=PLRowsHeight else PLRowsHeight:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ����-������ �������� ����� ��������'));
  if s='' then PLRowsInterval:=PLRowsInterval else PLRowsInterval:=strtoint(s);

  s:=trim(Groups[APos].getdata('������ ������ ������ ���������'));
  if s='' then ClipsHeightTitle:=ClipsHeightTitle else ClipsHeightTitle:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ������ ������ ������'));
  if s='' then ClipsHeightRow:=ClipsHeightRow else ClipsHeightRow:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ������ ������ ������ 1-�� ������'));
  if s='' then ClipsRowsTop:=ClipsRowsTop else ClipsRowsTop:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ������ ������ ������'));
  if s='' then ClipsRowsHeight:=ClipsRowsHeight else ClipsRowsHeight:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ������ �������� ����� ��������'));
  if s='' then ClipsRowsInterval:=ClipsRowsInterval else ClipsRowsInterval:=strtoint(s);

//==============================================================================
  APos:=6;
  s:=trim(Groups[APos].getdata('���� ������� ����'));
  if s='' then TLBackGround:=TLBackGround else TLBackGround:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ��������� ����'));
  if s='' then TLZoneNamesColor:=TLZoneNamesColor else TLZoneNamesColor:=strtoint(s);
  s:=trim(Groups[APos].getdata('��� ��������� ������'));
  if s='' then TLZoneNamesFontName:=TLZoneNamesFontName else TLZoneNamesFontName:=s;
  s:=trim(Groups[APos].getdata('���� ��������� ������'));
  if s='' then TLZoneNamesFontColor:=TLZoneNamesFontColor else TLZoneNamesFontColor:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������ ��� ��������'));
  if s='' then TLZoneFontColorSelect:=TLZoneFontColorSelect else TLZoneFontColorSelect:=strtoint(s);
  s:=trim(Groups[APos].getdata('������ ��������� ������'));
  if s='' then TLZoneNamesFontSize:=TLZoneNamesFontSize else TLZoneNamesFontSize:=strtoint(s);

  if trim(Groups[APos].getdata('������� �������� �����'))='��'
    then TLZoneNamesFontBold:=true else TLZoneNamesFontBold:=false;
  if trim(Groups[APos].getdata('��������� �������� �����'))='��'
    then TLZoneNamesFontItalic:=true else TLZoneNamesFontItalic:=false;
  if trim(Groups[APos].getdata('������������ �������� �����'))='��'
    then TLZoneNamesFontUnderline:=true else TLZoneNamesFontUnderline:=false;

  if trim(Groups[APos].getdata('������� ����� ������. ����-�����'))='��'
    then TLZoneEditFontBold:=true else TLZoneEditFontBold:=false;
  if trim(Groups[APos].getdata('��������� ����� ������. ����-�����'))='��'
    then TLZoneEditFontItalic:=true else TLZoneEditFontItalic:=false;
  if trim(Groups[APos].getdata('������������ ����� ������. ����-�����'))='��'
    then TLZoneEditFontUnderline:=true else TLZoneEditFontUnderline:=false;

  s:=trim(Groups[APos].getdata('���� ������� 1'));
  if s='' then StatusColor[0]:=StatusColor[0] else StatusColor[0]:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������� 2'));
  if s='' then StatusColor[1]:=StatusColor[1] else StatusColor[1]:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������� 3'));
  if s='' then StatusColor[2]:=StatusColor[2] else StatusColor[2]:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������� 4'));
  if s='' then StatusColor[3]:=StatusColor[3] else StatusColor[3]:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������� 5'));
  if s='' then StatusColor[4]:=StatusColor[4] else StatusColor[4]:=strtoint(s);

  s:=trim(Groups[APos].getdata('������. ���-�� ����-�����'));
  if s='' then TLMaxCount:=TLMaxCount else TLMaxCount:=strtoint(s);
  s:=trim(Groups[APos].getdata('����. ���-�� ����-����� ���������'));
  if s='' then TLMaxDevice:=TLMaxDevice else TLMaxDevice:=strtoint(s);
  s:=trim(Groups[APos].getdata('����. ���-�� ��������� ����-�����'));
  if s='' then TLMaxText:=TLMaxText else TLMaxText:=strtoint(s);
  s:=trim(Groups[APos].getdata('����. ���-�� ����� ����-�����'));
  if s='' then TLMaxMedia:=TLMaxMedia else TLMaxMedia:=strtoint(s);


//  s:=trim(Groups[APos].getdata('���� ������ ����� �������'));
//  if s='' then Layer2FontColor:=Layer2FontColor else Layer2FontColor:=strtoint(s);
//  s:=trim(Groups[APos].getdata('������ ������ ����� �������'));
//  if s='' then Layer2FontSize:=Layer2FontSize else Layer2FontSize:=strtoint(s);

//==============================================================================
  APos:=7;


  s:=trim(Groups[APos].getdata('����������� ������� ����� (�����)'));
  if s='' then DefaultClipDuration:=10250 else DefaultClipDuration:=strtoint(s);
  s:=trim(Groups[APos].getdata('���-�� ������ �� �������'));
  if s='' then TLPreroll:=TLPreroll else TLPreroll:=strtoint(s);
  s:=trim(Groups[APos].getdata('���-�� ������ ����� �������'));
  if s='' then TLPostroll:=TLPostroll else TLPostroll:=strtoint(s);
  s:=trim(Groups[APos].getdata('���-�� ������ �������'));
  if s='' then TLFlashDuration:=TLFlashDuration else TLFlashDuration:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������� ���'));
  if s='' then StartColorCursor:=StartColorCursor else StartColorCursor:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������� ���'));
  if s='' then EndColorCursor:=EndColorCursor else EndColorCursor:=strtoint(s);
  //s:=trim(Groups[APos].getdata('���� ������ ����� �������'));
  //if s='' then TLFontColor:=TLFontColor else TLFontColor:=strtoint(s);

//==============================================================================
  APos:=8;

  s:=trim(Groups[APos].getdata('���������� ������������ �������'));
  if s='' then RowsEvents:=RowsEvents else RowsEvents:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������� ���� ���� �������'));
  if s='' then AirBackGround:=AirBackGround else AirBackGround:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� �������� ���� ���� �������'));
  if s='' then AirForeGround:=AirForeGround else AirForeGround:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� �������'));
  if s='' then AirColorTimeline:=AirColorTimeline else AirColorTimeline:=strtoint(s);

  s:=trim(Groups[APos].getdata('���� ���� ���� ���������'));
  if s='' then DevBackGround:=DevBackGround else DevBackGround:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ����� ����-����'));
  if s='' then TimeForeGround:=TimeForeGround else TimeForeGround:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ��������� ��������'));
  if s='' then TimeSecondColor:=TimeSecondColor else TimeSecondColor:=strtoint(s);
  s:=trim(Groups[APos].getdata('���� ������ �����������'));
  if s='' then AirFontComment:=AirFontComment else AirFontComment:=strtoint(s);

//==============================================================================
  APos:=9;
  ch := formatsettings.DecimalSeparator;
  formatsettings.DecimalSeparator := '.';
  s:=trim(Groups[APos].getdata('����� ����'));
  if s='' then PrintSpaceLeft:=PrintSpaceLeft else PrintSpaceLeft:=strtofloat(s);

  s:=trim(Groups[APos].getdata('������� ����'));
  if s='' then PrintSpaceTop:=PrintSpaceTop else PrintSpaceTop:=strtofloat(s);

  s:=trim(Groups[APos].getdata('������ ����'));
  if s='' then PrintSpaceRight:=PrintSpaceRight else PrintSpaceRight:=strtofloat(s);

  s:=trim(Groups[APos].getdata('������ ����'));
  if s='' then PrintSpaceBottom:=PrintSpaceBottom else PrintSpaceBottom:=strtofloat(s);

  s:=trim(Groups[APos].getdata('������� ����������'));
  if s='' then PrintHeadLineTop:=PrintHeadLineTop else PrintHeadLineTop:=strtofloat(s);

  s:=trim(Groups[APos].getdata('������ ����������'));
  if s='' then PrintHeadLineBottom:=PrintHeadLineBottom else PrintHeadLineBottom:=strtofloat(s);
  formatsettings.DecimalSeparator := ch;
  PrintCol1:=trim(Groups[APos].getdata('�������� ������� �������'));
  PrintCol2:=trim(Groups[APos].getdata('�������� ������� �������'));
  PrintCol3:=trim(Groups[APos].getdata('�������� �������� �������'));
  PrintCol4:=trim(Groups[APos].getdata('�������� ���������� �������'));
  PrintCol5:=trim(Groups[APos].getdata('�������� ������ �������'));
  PrintCol61:=trim(Groups[APos].getdata('�������� ������� ������� ���.1'));
  PrintCol62:=trim(Groups[APos].getdata('�������� ������� ������� ���.2'));
  PrintDeviceName:=trim(Groups[APos].getdata('���� �������� ����������'));
//==============================================================================
  RowGridClips.SetDefaultFonts;
  RowGridClips.HeightTitle:=ClipsHeightTitle;
  RowGridClips.HeightRow:=ClipsHeightRow;
    for j:=0 to RowGridClips.Count-1 do begin
      for k:=0 to RowGridClips.MyCells[j].Count-1 do begin
        RowGridClips.MyCells[j].Rows[k].Top:=PLRowsTop + k*(PLRowsHeight + PLRowsInterval);
        RowGridClips.MyCells[j].Rows[k].Height:=PLRowsHeight;
        for n:=0 to RowGridClips.MyCells[j].Rows[k].Count-1 do begin
          RowGridClips.MyCells[j].Rows[k].Phrases[n].Top:=RowGridClips.MyCells[j].Rows[k].Top;
          RowGridClips.MyCells[j].Rows[k].Phrases[n].Height:=RowGridClips.MyCells[j].Rows[k].Height;
        end;
      end;
    end;


  RowGridListPL.SetDefaultFonts;
  RowGridListPL.HeightTitle:=PLHeightTitle;
  RowGridListPL.HeightRow:=PLHeightRow;
    for j:=0 to RowGridListPL.Count-1 do begin
      for k:=0 to RowGridListPL.MyCells[j].Count-1 do begin
        RowGridListPL.MyCells[j].Rows[k].Top:=PLRowsTop + k*(PLRowsHeight + PLRowsInterval);
        RowGridListPL.MyCells[j].Rows[k].Height:=PLRowsHeight;
        for n:=0 to RowGridClips.MyCells[j].Rows[k].Count-1 do begin
          RowGridClips.MyCells[j].Rows[k].Phrases[n].Top:=RowGridClips.MyCells[j].Rows[k].Top;
          RowGridClips.MyCells[j].Rows[k].Phrases[n].Height:=RowGridClips.MyCells[j].Rows[k].Height;
        end;
      end;
    end;


  RowGridListTxt.SetDefaultFonts;
  RowGridListGR.SetDefaultFonts;
  TempGridRow.SetDefaultFonts;


  for i:=0 to Form1.GridLists.RowCount-1 do begin
    (Form1.GridLists.Objects[0,i] as tgridrows).SetDefaultFonts;
    (Form1.GridLists.Objects[0,i] as tgridrows).HeightTitle:=PLHeightTitle;
    (Form1.GridLists.Objects[0,i] as tgridrows).HeightRow:=PLHeightRow;
    with (Form1.GridLists.Objects[0,i] as tgridrows) do begin
      for j:=0 to Count-1 do begin
        for k:=0 to MyCells[j].Count-1 do begin
          MyCells[j].Rows[k].Top:=PLRowsTop + k*(PLRowsHeight + PLRowsInterval);
          MyCells[j].Rows[k].Height:=PLRowsHeight;
          for n:=0 to MyCells[j].Rows[k].Count-1 do begin
            MyCells[j].Rows[k].Phrases[n].Top:=MyCells[j].Rows[k].Top;
            MyCells[j].Rows[k].Phrases[n].Height:=MyCells[j].Rows[k].Height;
          end;
        end;
      end;
    end;
  end;

  for i:=0 to Form1.GridClips.RowCount-1 do begin
    (Form1.GridClips.Objects[0,i] as tgridrows).SetDefaultFonts;
    (Form1.GridClips.Objects[0,i] as tgridrows).HeightTitle:=ClipsHeightTitle;
    (Form1.GridClips.Objects[0,i] as tgridrows).HeightRow:=ClipsHeightRow;
    with (Form1.GridClips.Objects[0,i] as tgridrows) do begin
      for j:=0 to Count-1 do begin
        for k:=0 to MyCells[j].Count-1 do begin
          MyCells[j].Rows[k].Top:=ClipsRowsTop + k*(ClipsRowsHeight + ClipsRowsInterval);
          MyCells[j].Rows[k].Height:=ClipsRowsHeight;
          for n:=0 to MyCells[j].Rows[k].Count-1 do begin
            MyCells[j].Rows[k].Phrases[n].Top:=MyCells[j].Rows[k].Top;
            MyCells[j].Rows[k].Phrases[n].Height:=MyCells[j].Rows[k].Height;
          end;
        end;
      end;
    end;
  end;

  for i:=0 to Form1.GridActPlayList.RowCount-1 do begin
    (Form1.GridActPlayList.Objects[0,i] as tgridrows).SetDefaultFonts;
    (Form1.GridActPlayList.Objects[0,i] as tgridrows).HeightTitle:=ClipsHeightTitle;
    (Form1.GridActPlayList.Objects[0,i] as tgridrows).HeightRow:=ClipsHeightRow;
    with (Form1.GridActPlayList.Objects[0,i] as tgridrows) do begin
      for j:=0 to Count-1 do begin
        for k:=0 to MyCells[j].Count-1 do begin
          MyCells[j].Rows[k].Top:=ClipsRowsTop + k*(ClipsRowsHeight + ClipsRowsInterval);
          MyCells[j].Rows[k].Height:=ClipsRowsHeight;
          for n:=0 to MyCells[j].Rows[k].Count-1 do begin
            MyCells[j].Rows[k].Phrases[n].Top:=MyCells[j].Rows[k].Top;
            MyCells[j].Rows[k].Phrases[n].Height:=MyCells[j].Rows[k].Height;
          end;
        end;
      end;
    end;
  end;

  for i:=0 to Form1.GridGRTemplate.RowCount-1
    do (Form1.GridGRTemplate.Objects[0,i] as tgridrows).SetDefaultFonts;
  for i:=0 to FButtonOptions.Stringgrid1.RowCount-1
    do (FButtonOptions.Stringgrid1.Objects[0,i] as tgridrows).SetDefaultFonts;
  for i:=0 to FGRTemplate.GridImgTemplate.RowCount-1
    do (FGRTemplate.GridImgTemplate.Objects[0,i] as tgridrows).SetDefaultFonts;

  Form1.GridLists.Repaint;
  Form1.GridClips.Repaint;
  Form1.GridActPlayList.Repaint;
  Form1.GridGRTemplate.Repaint;
  FButtonOptions.Stringgrid1.Repaint;
  FGRTemplate.GridImgTemplate.Repaint;

//==============================================================================
//  pntlproj.Rows[0].Columns[0].FontSize:=MTFontSizeB;
//  pntlproj.Rows[0].Columns[1].FontSize:=MTFontSizeB;
//  pntlproj.Rows[1].Columns[0].FontSize:=MTFontSize;
//  pntlproj.Rows[1].Columns[1].FontSize:=MTFontSize-1;
//  pntlproj.Rows[2].Columns[0].FontSize:=MTFontSize;
//  pntlproj.Rows[2].Columns[1].FontSize:=MTFontSize-1;
//  pntlproj.Rows[3].Columns[0].FontSize:=MTFontSize;
//  pntlproj.Rows[3].Columns[1].FontSize:=MTFontSize;
//  pntlproj.Rows[4].Columns[0].FontSize:=MTFontSize;
//  pntlproj.Rows[4].Columns[1].FontSize:=MTFontSize;
//  pntlproj.Rows[5].Columns[0].FontSize:=MTFontSize;
//  pntlproj.Rows[5].Columns[1].FontSize:=MTFontSize;
//============================================================================
//  pntlclips.Rows[0].Columns[0].FontSize:=MTFontSizeB;
//  pntlclips.Rows[0].Columns[1].FontSize:=MTFontSizeS;
//  pntlclips.Rows[1].Columns[0].FontSize:=MTFontSizeS;
//  pntlclips.Rows[1].Columns[1].FontSize:=MTFontSizeS;
//  pntlclips.Rows[2].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[2].Columns[1].FontSize:=MTFontSize;
//  pntlclips.Rows[3].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[3].Columns[1].FontSize:=MTFontSize-1;
//  pntlclips.Rows[4].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[4].Columns[1].FontSize:=MTFontSize-1;
//  pntlclips.Rows[5].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[5].Columns[1].FontSize:=MTFontSize;
//  pntlclips.Rows[6].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[6].Columns[1].FontSize:=MTFontSize;
//  pntlclips.Rows[7].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[7].Columns[1].FontSize:=MTFontSize;
//  pntlclips.Rows[8].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[8].Columns[1].FontSize:=MTFontSize;
//  pntlclips.Rows[9].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[9].Columns[1].FontSize:=MTFontSize;
//  pntlclips.Rows[10].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[10].Columns[1].FontSize:=MTFontSize;
//  pntlclips.Rows[11].Columns[0].FontSize:=MTFontSize;
//  pntlclips.Rows[11].Columns[1].FontSize:=MTFontSize;
//============================================================================
//  pntlprep.Rows[0].Columns[0].FontSize:=MTFontSizeB;
//  pntlprep.Rows[0].Columns[1].FontSize:=MTFontSizeB;
//  pntlprep.Rows[0].Columns[2].FontSize:=MTFontSizeS;
//  pntlprep.Rows[1].Columns[0].FontSize:=MTFontSizeS;
//  pntlprep.Rows[1].Columns[1].FontSize:=MTFontSizeS;
//  pntlprep.Rows[2].Columns[0].FontSize:=MTFontSize;
//  pntlprep.Rows[2].Columns[1].FontSize:=MTFontSize;
//============================================================================
//  pntlplist.Rows[0].Columns[0].FontSize:=MTFontSizeB;
//  pntlplist.Rows[0].Columns[1].FontSize:=MTFontSizeS;
//  pntlplist.Rows[1].Columns[0].FontSize:=MTFontSizeS;
//  pntlplist.Rows[1].Columns[1].FontSize:=MTFontSizeS;
//  pntlplist.Rows[2].Columns[0].FontSize:=MTFontSize;
//  pntlplist.Rows[2].Columns[1].FontSize:=MTFontSize;
//  pntlplist.Rows[3].Columns[0].FontSize:=MTFontSize;
//  pntlplist.Rows[3].Columns[1].FontSize:=MTFontSize-1;
//  pntlplist.Rows[4].Columns[0].FontSize:=MTFontSize;
//  pntlplist.Rows[4].Columns[1].FontSize:=MTFontSize;
//  pntlplist.Rows[5].Columns[0].FontSize:=MTFontSize;
//  pntlplist.Rows[5].Columns[1].FontSize:=MTFontSize;
//  pntlplist.Rows[6].Columns[0].FontSize:=MTFontSize;
//  pntlplist.Rows[6].Columns[1].FontSize:=MTFontSize;
//  pntlplist.Rows[7].Columns[0].FontSize:=MTFontSize;
//  pntlplist.Rows[7].Columns[1].FontSize:=MTFontSize;
//  pntlplist.Rows[8].Columns[0].FontSize:=MTFontSize;
//  pntlplist.Rows[8].Columns[1].FontSize:=MTFontSize;
//  pntlplist.Rows[9].Columns[0].FontSize:=MTFontSize;
//  pntlplist.Rows[9].Columns[1].FontSize:=MTFontSize;
//=============================================================================
//  pntlapls.Rows[0].Columns[0].FontSize:=MTFontSize;
//  pntlapls.Rows[0].Columns[1].FontSize:=MTFontSize;
//  pntlapls.Rows[1].Columns[0].FontSize:=MTFontSize;
//  pntlapls.Rows[1].Columns[1].FontSize:=MTFontSize;
//==============================================================================
  //InputInSystem;
  InitMainForm;
  //InitPanelPrepare;
  //InitPanelAir;

  pnlprojects.BackGround:=ProgrammColor;
  pnlprojcntl.BackGround:=ProgrammColor;
  pnlplaylsts.BackGround:=ProgrammColor;

  InitPanelProject(false);
  InitPanelControl;
  InitPanelClips(false);
  InitPanelPlayList(false);
  InitPanelPrepare(false);
  //UpdatePanelPrepare;
  //UpdatePanelAir;
  InitPanelAir;

  InitNewProject;
  InitPlaylists;
  InitTextTemplates;
  InitMyMessage;
  InitEditTimeline;
  InitImageTemplate(false);
  InitImportFiles;
  InitFrSetTemplate;
  InitFrSetEventData;
  InitFrButtonOptions;
  InitFrSortGrid;
  InitFrShiftTL;
  InitFrShortNum;
  InitFrMediaCopy;
  InitfrMyPrint;
  InitFPageSetup;
  InitFrLTC;
  InitfrTimeCode;
  InitfrMyTextTemplate;
  InitfrNewList;
  //MyStartWindow;
  //InitMyStartWindow;
  //InitInputInSystem;
  InitFrSaveProject;
  InitfrHotKeys;
  InitFrListErrors;
  InitFrMyOptions;
  initFrSetProcent;
  InitFrProtocols;

end;

procedure TListPartitions.Draw(cv : tcanvas);
var tmp : tfastdib;
    //rt: trect;
    i, wdth, hght, rowhght : integer;
begin
   //init(cv);
   tmp := tfastdib.Create;
   try
     wdth := cv.ClipRect.Right-cv.ClipRect.Left;
     hght := cv.ClipRect.Bottom-cv.ClipRect.Top;
     tmp.SetSize(wdth, hght, 32);
     tmp.Clear(TColorToTfcolor(FormsColor));
     tmp.SetBrush(bs_solid,0,colortorgb(FormsColor));
     tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
     tmp.SetTransparent(true);
     tmp.SetPen(ps_Solid,1,ColorToRGB(FormsFontColor));
     tmp.SetTextColor(ColorToRGB(FormsFontColor));
     tmp.SetFont(FormsFontName, MTFontSize);
     for i:=0 to Count-1 do begin
       List[i].Rect.Right:=wdth-10;
       if List[i].Select
         then tmp.SetBrush(bs_solid,0,SmoothColor(colortorgb(FormsColor), 64))
         else tmp.SetBrush(bs_solid,0,colortorgb(FormsColor));
       tmp.FillRect(List[i].Rect);
       tmp.DrawText(inttostr(i+1),Rect(List[i].Rect.Left,List[i].Rect.Top,List[i].Rect.Left+25,List[i].Rect.Bottom),DT_CENTER);
       tmp.DrawText(trim(List[i].Text),Rect(List[i].Rect.Left+30,List[i].Rect.Top,List[i].Rect.Right,List[i].Rect.Bottom),DT_LEFT);
     end;
     tmp.SetTransparent(false);
     tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
     cv.Refresh;
   finally
     tmp.Free;
     tmp:=nil;
   end;
end;

procedure   TListPartitions.MouseMove(cv : tcanvas; X, Y : integer);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if (X>List[i].Rect.Left+1) and (X<List[i].Rect.Right-1) and (Y>List[i].Rect.Top+1)
       and (Y<List[i].Rect.Bottom-1)
    then begin
      //List[i].select:=true;
      //exit;
    end;
  end;
end;

function    TListPartitions.MouseClick(cv : tcanvas; X, Y : integer) : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to Count-1 do List[i].select:=false;
  for i:=0 to Count-1 do begin
    if (X>List[i].Rect.Left+1) and (X<List[i].Rect.Right-1) and (Y>List[i].Rect.Top+1)
       and (Y<List[i].Rect.Bottom-1)
    then begin
      List[i].select:=true;
      result:=i;
      exit;
    end;
  end;
end;

constructor TGroupOptions.create;
begin
  Count := 0;
end;

destructor TGroupOptions.destroy;
begin
  clear;
  freemem(@Count);
  freemem(@Options);
end;

procedure TGroupOptions.setdata(SName : string; SValue : String);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if lowercase(trim(Options[i].Name))=lowercase(trim(SName)) then begin
      Options[i].Value := SValue;
      exit;
    end;
  end;
end;

procedure TGroupOptions.setdata(Posi : integer; SValue : string);
begin
  Options[posi].Value := SValue;
end;

function TGroupOptions.getdata(SName : string) : string;
var i : integer;
begin
  result:='';
  for i:=0 to Count-1 do begin
    if lowercase(trim(Options[i].Name))=lowercase(trim(SName)) then begin
      result := Options[i].Value;
      exit;
    end;
  end;
end;

function TGroupOptions.getdata(Posi : integer) : string;
begin
  result := Options[posi].Value;
end;

procedure TGroupOptions.clear;
var i : integer;
begin
  for i:=count-1 downto 0 do begin
    Options[Count-1].Variants.Clear;
    Options[Count-1].Variants.Free;
    Options[Count-1].FreeInstance;
    Count:=Count-1;
    setlength(Options,Count);
  end;
  Count:=0;
end;

function TGroupOptions.adddata(SName, SValue : string; TypeD : TMyTypeOption;  Left, Top, Width, Height : integer) : integer;
begin
  Count:=Count+1;
  setlength(Options,Count);
  Options[Count-1] := TOneOption.Create(SName,SValue,TypeD,Left,Top,Width,Height);
  result := Count-1;
end;

procedure TGroupOptions.AddVariant(Name : String; Variant : string);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if lowercase(trim(Options[i].Name))=lowercase(trim(Name)) then begin
      Options[i].Variants.Add(Variant);
      exit;
    end;
  end;
end;

procedure TGroupOptions.AddVariant(Posi : integer; Variant : string);
begin
  Options[Posi].Variants.Add(Variant);
end;

procedure TGroupOptions.ClearVariants(Name : string);
var i : integer;
begin
  for i:=0 to Count-1 do begin
    if lowercase(trim(Options[i].Name))=lowercase(trim(Name)) then begin
      Options[i].Variants.Clear;
      exit;
    end;
  end;
end;

procedure TGroupOptions.ClearVariants(Posi : integer);
begin
  Options[Posi].Variants.Clear;
end;

procedure TGroupOptions.setborder(Posi, left, width : integer);
begin
  Options[Posi].rtname.Left := left;
  Options[Posi].rtname.Right:= left + (width div 7) * 5;
  Options[Posi].rtval.Left := Options[Posi].rtname.Right + 5;
  Options[Posi].rtval.Right := left + width;
end;

procedure TGroupOptions.Draw(cv : tcanvas);
var tmp : tfastdib;
    i, wdth, hght, rowhght : integer;
    clr : tcolor;
    intclr : longint;
    rt : trect;
begin
   tmp := tfastdib.Create;
   try
     wdth := cv.ClipRect.Right-cv.ClipRect.Left;
     hght := cv.ClipRect.Bottom-cv.ClipRect.Top;
     tmp.SetSize(wdth, hght, 32);
     tmp.Clear(TColorToTfcolor(FormsColor));
     tmp.SetBrush(bs_solid,0,colortorgb(FormsColor));
     tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
     tmp.SetTransparent(true);
     tmp.SetPen(ps_Solid,1,ColorToRGB(FormsFontColor));
     tmp.SetTextColor(ColorToRGB(FormsFontColor));
     tmp.SetFont(FormsFontName, MTFontSize);
     for i:=0 to Count-1 do begin
        setborder(i, 10, wdth-20);
       tmp.DrawText(Options[i].Name,Options[i].rtname,DT_VCENTER or DT_SINGLELINE);
       if Options[i].TypeData<>tomColor then begin
         tmp.DrawText(Options[i].Value,Options[i].rtval,DT_VCENTER or DT_SINGLELINE);
       end else begin
         if trim(Options[i].Value)=''
           then clr := FormsColor else clr:=StrToInt(Options[i].Value);
         tmp.SetBrush(bs_solid,0,colortorgb(clr));
         rt.Left:=Options[i].rtval.Left;
         rt.Right:=Options[i].rtval.Right;
         rt.Top:=Options[i].rtval.Top+1;
         rt.Bottom:=Options[i].rtval.Bottom-1;

         tmp.FillRect(rt);
         tmp.Rectangle(rt.Left,rt.Top,rt.Right,rt.Bottom);
         tmp.SetBrush(bs_solid,0,colortorgb(FormsColor));
       end;
     end;
     tmp.SetTransparent(false);
     tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
     cv.Refresh;
   finally
     tmp.Free;
     tmp:=nil;
   end
end;

function TGroupOptions.MouseClick(cv : tcanvas; X, Y : integer) : integer;
var i : integer;
    clr : tcolor;
begin
  result := -1;
  //for i:=0 to Count-1 do List[i].select:=false;
  for i:=0 to Count-1 do begin
    if (X>Options[i].rtval.Left+1) and (X<Options[i].rtval.Right-1) and (Y>Options[i].rtval.Top+1)
       and (Y<Options[i].rtval.Bottom-1)
    then begin
      if Options[i].TypeData<>tomColor then begin
        if (Options[i].Variants.Count>0) or (Options[i].TypeData=tomFontName) then begin
          FrMyOptions.ComboBox1.Left:=Options[i].rtval.Left+1;
          FrMyOptions.ComboBox1.Top:=Options[i].rtval.Top+1;
          FrMyOptions.ComboBox1.Width:=Options[i].rtval.Right-Options[i].rtval.Left;
          FrMyOptions.ComboBox1.Clear;
          if Options[i].TypeData=tomFontName then begin
            FrMyOptions.ComboBox1.Items.Assign(Screen.Fonts);
          end else begin
            FrMyOptions.ComboBox1.Items.Assign(Options[i].Variants);
          end;
          FrMyOptions.ComboBox1.ItemIndex:=FrMyOptions.ComboBox1.Items.IndexOf(trim(Options[i].Value));
          FrMyOptions.ComboBox1.Visible:=True;
          FrMyOptions.Edit1.Visible:=False;
        end else begin
          FrMyOptions.Edit1.Left:=Options[i].rtval.Left+1;
          FrMyOptions.Edit1.Top:=Options[i].rtval.Top+1;
          FrMyOptions.Edit1.Width:=Options[i].rtval.Right-Options[i].rtval.Left;
          FrMyOptions.Edit1.Text:=trim(Options[i].Value);
          FrMyOptions.ComboBox1.Visible:=false;
          FrMyOptions.Edit1.Visible:=true;
        end;
      end else begin
        FrMyOptions.ComboBox1.Visible:=false;
        FrMyOptions.Edit1.Visible:=false;
        if trim(Options[i].Value)=''
           then clr := FormsColor else clr:=StrToInt(Options[i].Value);
        FrMyOptions.ColorDialog1.Color:=clr;
        if Not FrMyOptions.ColorDialog1.Execute then exit;
        Options[i].Value:=inttostr(FrMyOptions.ColorDialog1.Color);

      end;
      result:=i;
      exit;
    end;
  end;
end;

constructor TOneOption.Create(SName, SValue : string; TypeD  : TMyTypeOption; Left, Top, Width, Height : integer);
begin
  Name     := SName;
  Value    := SValue;
  TypeData := TypeD;
  Variants := tstringlist.Create;
  Variants.Clear;
  rtname.Left:=Left;
  rtname.Top:=Top;
  rtname.Bottom:=Top+Height;
  rtname.Right:=Left+(Width div 7) * 5;
  rtval.Left:=rtname.Right;
  rtval.Right:=Left+Width;
  rtval.Top:=Top;
  rtval.Bottom:=Top+Height;
end;

destructor TOneOption.destroy;
begin
  freemem(@Name);
  freemem(@Value);
  freemem(@rtname);
  freemem(@rtval);
  freemem(@TypeData);
  Variants.Clear;
  Variants.Free;
  freemem(@Variants);
end;

procedure TOneOption.Draw(dib : tfastdib);
begin
  dib.SetTextColor(colortorgb(FormsFontColor));
  dib.SetFont(FormsFontName,MTFontSize);
  dib.DrawText(Name,rtname,DT_LEFT);
  dib.DrawText(Value,Rect(rtval.Left+5,rtval.Top,rtval.Right,rtval.Bottom),DT_LEFT);
end;

procedure TFrMyOptions.ComboBox1Change(Sender: TObject);
begin
  if (IndexPartition<>-1) and (IndexOption<>-1) then begin
    if ComboBox1.Visible
      then ListOptions.Groups[IndexPartition].Options[IndexOption].Value:=ComboBox1.Items.Strings[ComboBox1.ItemIndex];
  end;
end;

procedure TFrMyOptions.Edit1Change(Sender: TObject);
begin
  if (IndexPartition<>-1) and (IndexOption<>-1) then begin
    if Edit1.Visible then begin
      if trim(Edit1.Text)=''
        then if TypeEditor<>tomString then Edit1.Text:='0';
      ListOptions.Groups[IndexPartition].Options[IndexOption].Value:=Edit1.Text;
    end;
  end;

end;

procedure TFrMyOptions.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=0 then

end;

procedure TFrMyOptions.Edit1KeyPress(Sender: TObject; var Key: Char);
var ps : integer;
    ch : char;
begin
  ch := formatsettings.DecimalSeparator;
  formatsettings.DecimalSeparator := '.';
  if key='�' then key:='.';

     case TypeEditor of
  tomInteger : begin
                 if not (key in [#8,'0','1'..'9']) then key:=#0;
                 exit;
                 formatsettings.DecimalSeparator := ch;
               end;
  tomFloat   : begin
                 ps := pos(',',trim(Edit1.Text));
                 if ps<>0 then begin
                   if not (key in [#8,'0','1'..'9']) then key:=#0;
                 end else if not (key in [#8,'.','0','1'..'9']) then key:=#0;
                 formatsettings.DecimalSeparator := ch;
                 exit;
               end;
     end;
  formatsettings.DecimalSeparator := ch;
end;

procedure TFrMyOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Edit1.Visible:=false;
  ComboBox1.Visible:=false;
end;

procedure TFrMyOptions.FormCreate(Sender: TObject);
begin
  InitFrMyOptions;
  btnpnloptions.Draw(imgbuttons.Canvas);
end;

procedure TFrMyOptions.imgButtonsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnpnloptions.MouseMove(imgButtons.Canvas, X, Y);
  btnpnloptions.Draw(imgButtons.Canvas);
  imgButtons.Repaint;
end;

procedure TFrMyOptions.imgButtonsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res : integer;
begin
  res := btnpnloptions.ClickButton(imgButtons.Canvas, X, Y);
  btnpnloptions.Draw(imgButtons.Canvas);
  imgButtons.Repaint;
     case res of
  0 :  Modalresult:=mrOk;
  1 :  begin
         ListOptions.SaveData;
         Modalresult:=mrOk;
       end;
     end;
end;

procedure TFrMyOptions.imgOptionsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res, indx : integer;
begin
  if IndexPartition=-1 then exit;
  Edit1.Visible:=false;
  //IndexPartition  := ListPartitions.Index;
  IndexOption := ListOptions.Groups[IndexPartition].MouseClick(imgOptions.Canvas, X, Y);
  if IndexOption<>-1 then begin
    TypeEditor  := ListOptions.Groups[IndexPartition].Options[IndexOption].TypeData;
  end;
  ListOptions.Groups[IndexPartition].Draw(imgOptions.Canvas);
  imgOptions.Repaint;
end;

procedure TFrMyOptions.imgPartitionsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Edit1.Visible:=false;
  ComboBox1.Visible:=false;
end;

procedure TFrMyOptions.imgPartitionsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var res : integer;
begin
  IndexPartition := ListPartitions.MouseClick(imgPartitions.Canvas, X, Y);
  ListPartitions.Draw(imgPartitions.Canvas);
  imgPartitions.Repaint;
  if IndexPartition<>-1 then ListOptions.Groups[IndexPartition].Draw(FrMyOptions.imgOptions.Canvas);
  FrMyOptions.imgOptions.Repaint;
end;

procedure TFrMyOptions.Panel1Resize(Sender: TObject);
begin
  imgPartitions.Picture.Bitmap.Width:=imgPartitions.Width;
  imgPartitions.Picture.Bitmap.Height:=imgPartitions.Height;
  ListPartitions.Draw(imgPartitions.Canvas);
  imgPartitions.Repaint;
end;

initialization
  ListPartitions := TListPartitions.create;
  ListPartitions.init;
  ListPartitions.List[0].Select:=true;

  ListOptions := TListOptions.create;
  ListOptions.clear;

finalization
  ListPartitions.FreeInstance;
  ListPartitions := nil;

  ListOptions.FreeInstance;
  ListOptions := nil;

end.
