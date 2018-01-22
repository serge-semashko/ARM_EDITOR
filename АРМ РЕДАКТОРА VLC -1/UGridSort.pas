unit UGridSort;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids;

type
  TTypeMySort = (tstext, tsint, tsdate, tsnone);
  TMyRadioButton = record
    Name : string;
    Field : string;
    TypeData : TTypeMySort;
  end;

  TFrSortGrid = class(TForm)
    RadioGroup1: TRadioGroup;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    Direction : boolean;
  public
    { Public declarations }
  end;

var
  FrSortGrid: TFrSortGrid;
  SortMyList : array[0..4] of TMyRadioButton;

  Procedure GridSort(Grid: tstringgrid; StartRow, ACol : integer);
  procedure  SortMyListClear;

implementation
uses ucommon, uInitForms, ugrid, umyfiles;

{$R *.dfm}

procedure  SortMyListClear;
var i : integer;
begin
  for i:=0 to 4 do begin
    SortMyList[i].Name:='';
    SortMyList[i].Field:='';
    SortMyList[i].TypeData:=tsnone;
  end;
  if makelogging then WriteLog('MAIN', 'USortGrid..SortMyListClear');
end;

Procedure LoadListRadioButton;
var i : integer;
begin
  FrSortGrid.RadioGroup1.Items.Clear;
  for i:=0 to 4 do begin
    if trim(SortMyList[i].Name)='' then exit;
    FrSortGrid.RadioGroup1.Items.Add(SortMyList[i].Name);
    if makelogging then WriteLog('MAIN', 'USortGrid..LoadListRadioButton Name=' + SortMyList[i].Name);
  end;
end;

procedure execsorting(Grid: tstringgrid; StartRow, ACol : integer);
begin
       case SortMyList[FrSortGrid.RadioGroup1.ItemIndex].TypeData of
  tstext : begin
             SortGridAlphabet(Grid, StartRow, ACol, SortMyList[FrSortGrid.RadioGroup1.ItemIndex].Field, FrSortGrid.Direction);
             if makelogging then WriteLog('MAIN', 'USortGrid..execsorting tstext Grid=' + Grid.Name + ' StartRow=' + inttostr(StartRow) + ' Col=' + inttostr(ACol));
           end;

  tsint  : begin end;
  tsdate : begin
             SortGridDate(Grid, StartRow, ACol, SortMyList[FrSortGrid.RadioGroup1.ItemIndex].Field, FrSortGrid.Direction);
             if makelogging then WriteLog('MAIN', 'USortGrid..execsorting tsdate Grid=' + Grid.Name + ' StartRow=' + inttostr(StartRow) + ' Col=' + inttostr(ACol));
           end;
       end; //case
end;

Procedure GridSort(Grid: tstringgrid; StartRow, ACol : integer);
begin
  try
  if makelogging then WriteLog('MAIN', 'USortGrid.GridSort Start Grid=' + Grid.Name + ' StartRow=' + inttostr(StartRow) + ' Col=' + inttostr(ACol));
  LoadListRadioButton;
  if FrSortGrid.RadioGroup1.Items.Count>0 then FrSortGrid.RadioGroup1.ItemIndex:=0;
  FrSortGrid.ShowModal;
  if FrSortGrid.ModalResult = mrok then begin
    if FrSortGrid.RadioGroup1.ItemIndex<0 then exit;
    execsorting(Grid, StartRow, ACol);
    if makelogging then WriteLog('MAIN', 'USortGrid..GridSort Finish Grid=' + Grid.Name + ' StartRow=' + inttostr(StartRow) + ' Col=' + inttostr(ACol));
  end;
  except
    on E: Exception do WriteLog('MAIN', 'USortGrid..GridSort | ' + E.Message);
  end;
end;


procedure TFrSortGrid.FormCreate(Sender: TObject);
begin
  InitFrSortGrid;
  speedbutton3.Glyph.Assign(Image1.Picture.Graphic);
  Direction := true;
end;

procedure TFrSortGrid.SpeedButton3Click(Sender: TObject);
begin
  Direction := not Direction;
  if Direction
  then speedbutton3.Glyph.Assign(Image1.Picture.Graphic)
  else speedbutton3.Glyph.Assign(Image2.Picture.Graphic);
  if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid.SpeedButton3Click');
end;

procedure TFrSortGrid.SpeedButton2Click(Sender: TObject);
begin
  if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid.SpeedButton2Click ModalResult := mrcancel');
  ModalResult := mrcancel;
end;

procedure TFrSortGrid.SpeedButton1Click(Sender: TObject);
begin
  if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid.SpeedButton1Click ModalResult := mrOk');
  ModalResult := mrOk;
end;

procedure TFrSortGrid.FormKeyPress(Sender: TObject; var Key: Char);
begin
     case Key of
  #13 : begin
          if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid.FormKeyPress Key=13 ModalResult := mrOk');
          ModalResult := mrOk;
        end;
  #27 : begin
          if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid.FormKeyPress Key=27 ModalResult := mrCancel');
          Modalresult := mrCancel;
        end;
     end;
end;

end.
