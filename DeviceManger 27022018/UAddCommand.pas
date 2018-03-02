unit UAddCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrAddCommand = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ListBox1: TListBox;
    Edit2: TEdit;
    Image1: TImage;
    Panel4: TPanel;
    BitBtn3: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit2Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
    CRow : integer;
    function FindCommandPosition : integer;
  public
    { Public declarations }
  end;

var
  FrAddCommand: TFrAddCommand;

function MyStrToTime(stri : string) : ttime;

Procedure AddCommand(ARow : integer);

implementation
uses umywork, mainunit, umychars, comportunit, umyinitfile;

{$R *.dfm}

function MyStrToTime(stri : string) : ttime;
var s, hh, mm, ss, ff : string;
begin
  s:=trim(stri);
  hh:=s[1]+s[2];
  mm:=s[4]+s[5];
  ss:=s[7]+s[8];
  ff:=s[10]+s[11];
  result:=EncodeTime(strtoint(hh),strtoint(mm),strtoint(ss),strtoint(ff)*40);
end;

procedure TFrAddCommand.BitBtn1Click(Sender: TObject);
var i, ps, pcmn : integer;
    s : string;
begin
  if Listbox1.ItemIndex<0 then ModalResult:=mrNone;
  if FrAddCommand.CRow>0 then frMyWork.GridDeleteRow(FrAddCommand.CRow);
  ps:=FrAddCommand.FindCommandPosition;
  pcmn:=Form3.NamePosition(FrAddCommand.ListBox1.Items.Strings[FrAddCommand.ListBox1.ItemIndex]);
  if ps=FrMyWork.StringGrid1.RowCount then begin
    if (FrMyWork.StringGrid1.RowCount=2) and (trim(FrMyWork.StringGrid1.Cells[1,1])='') then begin
      FrMyWork.StringGrid1.Cells[0,1]:='1';
      if frMyWork.SpeedButton2.Enabled
        then FrMyWork.StringGrid1.Cells[1,1]:=MyTimeToStr(frMyWork.TimeStart + MyStrToTime(FrAddCommand.Edit1.Text))
        else FrMyWork.StringGrid1.Cells[1,1]:=FrAddCommand.Edit1.Text;
      FrMyWork.StringGrid1.Cells[2,1]:=Form3.StringGrid1.Cells[1,pcmn];
      FrMyWork.StringGrid1.Cells[3,1]:=Form3.StringGrid1.Cells[2,pcmn];
      FrMyWork.StringGrid1.Row:=1;
      FrAddCommand.CRow:=1;
    end else begin
      FrMyWork.StringGrid1.RowCount:=FrMyWork.StringGrid1.RowCount+1;
      FrMyWork.StringGrid1.Cells[0,FrMyWork.StringGrid1.RowCount-1]:=inttostr(FrMyWork.StringGrid1.RowCount-1);
      if frMyWork.SpeedButton2.Enabled
        then FrMyWork.StringGrid1.Cells[1,FrMyWork.StringGrid1.RowCount-1]:=MyTimeToStr(frMyWork.TimeStart + MyStrToTime(FrAddCommand.Edit1.Text))
        else FrMyWork.StringGrid1.Cells[1,FrMyWork.StringGrid1.RowCount-1]:=FrAddCommand.Edit1.Text;
      FrMyWork.StringGrid1.Cells[2,FrMyWork.StringGrid1.RowCount-1]:=Form3.StringGrid1.Cells[1,pcmn];
      FrMyWork.StringGrid1.Cells[3,FrMyWork.StringGrid1.RowCount-1]:=Form3.StringGrid1.Cells[2,pcmn];
      FrMyWork.StringGrid1.Row:=FrMyWork.StringGrid1.RowCount-1;
      FrAddCommand.CRow:=FrMyWork.StringGrid1.RowCount-1;
    end;
  end else begin
    FrMyWork.StringGrid1.RowCount:=FrMyWork.StringGrid1.RowCount+1;
    for i:=FrMyWork.StringGrid1.RowCount-1 downto ps+1 do begin
      FrMyWork.StringGrid1.Cells[0,i]:=inttostr(i+1);
      FrMyWork.StringGrid1.Cells[1,i]:=FrMyWork.StringGrid1.Cells[1,i-1];
      FrMyWork.StringGrid1.Cells[2,i]:=FrMyWork.StringGrid1.Cells[2,i-1];
      FrMyWork.StringGrid1.Cells[3,i]:=FrMyWork.StringGrid1.Cells[3,i-1];
    end;
    FrMyWork.StringGrid1.Cells[0,ps]:=inttostr(ps);
    if frMyWork.SpeedButton2.Enabled
      then FrMyWork.StringGrid1.Cells[1,ps]:=MyTimeToStr(frMyWork.TimeStart + MyStrToTime(FrAddCommand.Edit1.Text))
      else FrMyWork.StringGrid1.Cells[1,ps]:=FrAddCommand.Edit1.Text;
    FrMyWork.StringGrid1.Cells[2,ps]:=Form3.StringGrid1.Cells[1,pcmn];
    FrMyWork.StringGrid1.Cells[3,ps]:=Form3.StringGrid1.Cells[2,pcmn];
    FrMyWork.StringGrid1.Row:=ps;
    FrAddCommand.CRow:=ps;
  end;
end;

procedure TFrAddCommand.BitBtn2Click(Sender: TObject);
begin
  close;
end;

procedure TFrAddCommand.BitBtn3Click(Sender: TObject);
begin
  FrAddCommand.CRow:=-1;
  BitBtn1.Click;
end;

procedure TFrAddCommand.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=46 then key:=0;
end;

procedure TFrAddCommand.Edit1KeyPress(Sender: TObject; var Key: Char);
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

procedure TFrAddCommand.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var s : string;
begin
  s:=trim(Edit1.Text);
  if length(s)>11 then s:=Copy(s,1,11);
  Edit1.Text:=s;
end;

procedure TFrAddCommand.Edit2Change(Sender: TObject);
var i, ps : integer;
    sg, ss : string;
begin
  ss:=lowercase(trim(edit2.Text));
  ListBox1.Clear;
  if ss='' then begin
    for i:=1 to Form3.StringGrid1.RowCount-1 do begin
      ListBox1.Items.Add(trim(form3.StringGrid1.Cells[1,i]))
    end;
  end else begin
    for i:=1 to Form3.StringGrid1.RowCount-1 do begin
       sg:=lowercase(trim(form3.StringGrid1.Cells[1,i]));
       ps := pos(ss,sg);
       if  ps>0 then begin
         ListBox1.Items.Add(trim(form3.StringGrid1.Cells[1,i]))
       end;
    end;
  end;
end;

function TFrAddCommand.FindCommandPosition : integer;
var i : integer;
    dte, dts : ttime;
begin
//  if (FrMyWork.StringGrid1.RowCount=2) and (trim(FrMyWork.StringGrid1.Cells[1,1])='') then begin
//    result:=1;
//    exit;
//  end;

  result:=FrMyWork.StringGrid1.RowCount;
  if frMyWork.SpeedButton2.Enabled then dte:=FrMyWork.TimeStart + MyStrToTime(Edit1.Text) else dte:=MyStrToTime(Edit1.Text);
  for i:=1 to FrMyWork.StringGrid1.RowCount-1 do begin
    if trim(FrMyWork.StringGrid1.Cells[1,i])='' then begin
      if frMyWork.SpeedButton2.Enabled then dts:=FrMyWork.TimeStart else dts:=MyStrToTime('00:00:00:00')
    end else dts:=MyStrToTime(FrMyWork.StringGrid1.Cells[1,i]);
    if dte<dts then begin
      result:=i;
      exit;
    end;
  end;
end;

Procedure AddCommand(ARow : integer);
var i, ps, pcmn : integer;
    s : string;
begin
  FrAddCommand.CRow:=ARow;
  FrAddCommand.ListBox1.Clear;
  for i:=1 to Form3.StringGrid1.RowCount-1 do begin
    s:=trim(Form3.StringGrid1.Cells[1,i]);//+'['+trim(Form3.StringGrid1.Cells[2,i])+']';
    FrAddCommand.ListBox1.Items.Add(s)
  end;

  if ARow=-1 then begin
    FrAddCommand.Edit1.Text:='00:00:00:00';
    FrAddCommand.ListBox1.ItemIndex:=-1
  end else begin
    if trim(FrMyWork.StringGrid1.Cells[1,ARow])='' then FrAddCommand.Edit1.Text:='00:00:00:00'
    else begin
      if frMyWork.SpeedButton2.Enabled
        then FrAddCommand.Edit1.Text:=MyTimeToStr(MyStrToTime(FrMyWork.StringGrid1.Cells[1,ARow]) - frMyWork.TimeStart)
        else FrAddCommand.Edit1.Text:=FrMyWork.StringGrid1.Cells[1,ARow];
    end;
    s:=Trim(frMyWork.StringGrid1.Cells[2,ARow]);//+'['+trim(frMyWork.StringGrid1.Cells[3,ARow])+']';
    FrAddCommand.ListBox1.ItemIndex:=FrAddCommand.ListBox1.Items.IndexOf(s);
  end;
  FrAddCommand.Show;
//  FrAddCommand.ShowModal;
//  if FrAddCommand.ModalResult=mrOk then begin
//    if ARow>0 then frMyWork.GridDeleteRow(ARow);
//    ps:=FrAddCommand.FindCommandPosition;
//    pcmn:=Form3.NamePosition(FrAddCommand.ListBox1.Items.Strings[FrAddCommand.ListBox1.ItemIndex]);
//    if ps=FrMyWork.StringGrid1.RowCount then begin
//      if (FrMyWork.StringGrid1.RowCount=2) and (trim(FrMyWork.StringGrid1.Cells[1,1])='') then begin
//        FrMyWork.StringGrid1.Cells[0,1]:='1';
//        //FrMyWork.StringGrid1.Cells[1,1]:=FrAddCommand.Edit1.Text;
//        if frMyWork.SpeedButton2.Enabled
//          then FrMyWork.StringGrid1.Cells[1,1]:=MyTimeToStr(frMyWork.TimeStart + MyStrToTime(FrAddCommand.Edit1.Text))
//          else FrMyWork.StringGrid1.Cells[1,1]:=FrAddCommand.Edit1.Text;
//        //FrMyWork.StringGrid1.Cells[2,1]:=Form3.StringGrid1.Cells[1,FrAddCommand.ListBox1.ItemIndex+1];
//        //FrMyWork.StringGrid1.Cells[3,1]:=Form3.StringGrid1.Cells[2,FrAddCommand.ListBox1.ItemIndex+1];
//        FrMyWork.StringGrid1.Cells[2,1]:=Form3.StringGrid1.Cells[1,pcmn];
//        FrMyWork.StringGrid1.Cells[3,1]:=Form3.StringGrid1.Cells[2,pcmn];
//      end else begin
//        FrMyWork.StringGrid1.RowCount:=FrMyWork.StringGrid1.RowCount+1;
//        FrMyWork.StringGrid1.Cells[0,FrMyWork.StringGrid1.RowCount-1]:=inttostr(FrMyWork.StringGrid1.RowCount-1);
//        //FrMyWork.StringGrid1.Cells[1,FrMyWork.StringGrid1.RowCount-1]:=FrAddCommand.Edit1.Text;
//        if frMyWork.SpeedButton2.Enabled
//          then FrMyWork.StringGrid1.Cells[1,FrMyWork.StringGrid1.RowCount-1]:=MyTimeToStr(frMyWork.TimeStart + MyStrToTime(FrAddCommand.Edit1.Text))
//          else FrMyWork.StringGrid1.Cells[1,FrMyWork.StringGrid1.RowCount-1]:=FrAddCommand.Edit1.Text;
//        //FrMyWork.StringGrid1.Cells[2,FrMyWork.StringGrid1.RowCount-1]:=Form3.StringGrid1.Cells[1,FrAddCommand.ListBox1.ItemIndex+1];
//        //FrMyWork.StringGrid1.Cells[3,FrMyWork.StringGrid1.RowCount-1]:=Form3.StringGrid1.Cells[2,FrAddCommand.ListBox1.ItemIndex+1];
//        FrMyWork.StringGrid1.Cells[2,1]:=Form3.StringGrid1.Cells[1,pcmn];
//        FrMyWork.StringGrid1.Cells[3,1]:=Form3.StringGrid1.Cells[2,pcmn];
//      end;
//    end else begin
//      FrMyWork.StringGrid1.RowCount:=FrMyWork.StringGrid1.RowCount+1;
//      for i:=FrMyWork.StringGrid1.RowCount-1 downto ps+1 do begin
//        FrMyWork.StringGrid1.Cells[0,i]:=inttostr(i+1);
//        FrMyWork.StringGrid1.Cells[1,i]:=FrMyWork.StringGrid1.Cells[1,i-1];
//        FrMyWork.StringGrid1.Cells[2,i]:=FrMyWork.StringGrid1.Cells[2,i-1];
//        FrMyWork.StringGrid1.Cells[3,i]:=FrMyWork.StringGrid1.Cells[3,i-1];
//      end;
//      FrMyWork.StringGrid1.Cells[0,ps]:=inttostr(ps);
//      if frMyWork.SpeedButton2.Enabled
//        then FrMyWork.StringGrid1.Cells[1,ps]:=MyTimeToStr(frMyWork.TimeStart + MyStrToTime(FrAddCommand.Edit1.Text))
//        else FrMyWork.StringGrid1.Cells[1,ps]:=FrAddCommand.Edit1.Text;
//      //FrMyWork.StringGrid1.Cells[2,ps]:=Form3.StringGrid1.Cells[1,FrAddCommand.ListBox1.ItemIndex+1];
//      //FrMyWork.StringGrid1.Cells[3,ps]:=Form3.StringGrid1.Cells[2,FrAddCommand.ListBox1.ItemIndex+1];
//      FrMyWork.StringGrid1.Cells[2,ps]:=Form3.StringGrid1.Cells[1,pcmn];
//      FrMyWork.StringGrid1.Cells[3,ps]:=Form3.StringGrid1.Cells[2,pcmn];
//    end;
//  end;
end;

end.
