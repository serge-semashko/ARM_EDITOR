unit UMySetTC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TFrSetTC = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrSetTC: TFrSetTC;

procedure SetTC;

implementation
uses umywork, UAddCommand;

{$R *.dfm}

procedure SetTC;
var i : integer;
    dts : ttime;
begin
  frSetTC.Edit1.Text:=MyTimeToStr(Now);
  frSetTC.ShowModal;
  if frSetTc.ModalResult=mrOk then begin
    frMyWork.TimeStart:=MyStrToTime(frSetTC.Edit1.Text);
    for i:=1 to FrMyWork.StringGrid1.RowCount-1 do begin
      if trim(FrMyWork.StringGrid1.Cells[1,i])=''
        then dts:=MyStrToTime('00:00:00:00') else dts:=MyStrToTime(FrMyWork.StringGrid1.Cells[1,i]);
      FrMyWork.StringGrid1.Cells[1,i]:=MyTimeToStr(frMyWork.TimeStart+dts);
    end;
  end;
end;

procedure TFrSetTC.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=46 then key:=0;
end;

procedure TFrSetTC.Edit1KeyPress(Sender: TObject; var Key: Char);
var s : string;
  i,p1,p2,p3 : integer;
begin
  if not (key in ['0'..'9',#8]) then begin
   key:=#0;
   exit;
  end;
  s:=edit1.Text;
  p2:=edit1.SelStart;
     Case Key of
       #8  : begin
               if edit1.SelLength=0 then begin
                 if (p2<>3) and (p2<>6) and (p2<>9) then begin
                    s[p2]:='0';
                    edit1.Text:=s;
                    key:=#0;
                    if p2>0 then edit1.SelStart:=p2-1;
                 end else begin
                    s[p2]:=':';
                    edit1.Text:=s;
                    key:=#0;
                    if p2>0 then edit1.SelStart:=p2-1;
                 end;
               end else begin
                 for i:=p2+1 to p2+edit1.SelLength do begin
                   if (i<>3) and (i<>6) and (i<>9) then s[i]:='0';
                 end;
                 edit1.SelLength:=0;
                 edit1.Text:=s;
                 if (p2=2) or (p2=5) or (p2=8) then edit1.SelStart:=p2+1;
                 if p2>0 then key:=s[p2-1];
               end;
             end;
  '0'..'9' : begin
               if (p2=2) or (p2=5) or (p2=8) then p2:=p2+1;
               if (p2<>2) and (p2<>5) and (p2<>8) then begin
                 if p2<11 then p2:=p2+1 else p2:=12;
                   case p2 of
               1 : if strtoint(Key)>2 then Key:='2';
               2 : if s[1]='2' then if strtoint(Key)>3 then Key:='3';
               4 : if strtoint(Key)>5 then Key:='5';
               7 : if strtoint(Key)>5 then Key:='5';
               10: if strtoint(Key)>2 then Key:='2';
               11: if s[10]='2' then if strtoint(Key)>4 then Key:='4';
                   end;
                 s[p2]:=Key;
                 edit1.Text:=s;
                 key:=#0;
                 if p2<=11 then begin
                   if (p2=2) or (p2=5) or (p2=8) then edit1.SelStart:=p2+1 else edit1.SelStart:=p2;
                 end;
               end;
             end;
     End;
end;

procedure TFrSetTC.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var s : string;
begin
  s:=trim(Edit1.Text);
  if length(s)>11 then s:=Copy(s,1,11);
  Edit1.Text:=s;
end;

end.
