unit UGridSort;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids, Math, FastDIB, FastFX, FastSize,
  FastFiles, FConvert, FastBlend, uimgbuttons;

type
  TTypeMySort = (tstext, tsint, tsdate, tstime, tsnone);
  TMyRadioButton = record
    Name : string;
    Field : string;
    TypeData : TTypeMySort;
  end;

  TSortOneStr = class
    Rt        : trect;
    Name        : String;
    Field       : String;
    TypeData    : TTypeMySort;
    Proc        : integer;
    select      : boolean;
    smouse      : boolean;
    constructor Create;//(Nm, Fld : string; TpDt : TTypeMySort; Prc : integer);
    procedure   Draw(dib : tfastdib);
    destructor  destroy;
  end;

  TMySortList = class
    rttext      : trect;
    rtdir       : trect;
    direction   : boolean;
    Count       : integer;
    List        : array of TSortOneStr;
    procedure   clear;
    procedure   Add(Name,Field : string; TypeData : TTypeMySort; Proc : integer);
    procedure   Init(cv : tcanvas);
    procedure   Draw(cv : tcanvas);
    function    selectindex : integer;
    function    MouseMove(cv : tcanvas; X, Y : integer) : integer;
    function    MouseClick(cv : tcanvas; X, Y : integer) : integer;
    constructor create;
    destructor  destroy;
  end;

  TFrSortGrid = class(TForm)
    Image3: TImage;
    Image4: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    Direction : boolean;
  public
    { Public declarations }
  end;

var
  FrSortGrid: TFrSortGrid;
  //SortMyList : array[0..4] of TMyRadioButton;
  mysortlist : tmysortlist;
  sortbuttons : TBTNSPanel;

  Procedure GridSort(Grid: tstringgrid; StartRow, ACol : integer);
  //procedure  SortMyListClear;

implementation
uses ucommon, uInitForms, ugrid, umyfiles, uhotkeys;

{$R *.dfm}

constructor TSortOneStr.Create;//(Nm, Fld : string; TpDt : TTypeMySort; Prc : integer);
begin
  Name      := '';
  Field     := '';
  TypeData  := tsnone;
  Proc      := 0;
  select    := false;
  smouse    := false;
  rt.Left   := 0;
  rt.Top    := 0;
  rt.Right  := 0;
  rt.Bottom := 0;
end;

procedure   TSortOneStr.Draw(dib : tfastdib);
var wd, ht : integer;
    rts, rtt : trect;
begin
  dib.SetTextColor(colortorgb(FrSortGrid.Font.Color));
  ht:=rt.Bottom-rt.Top-6;

  if smouse then begin
    dib.SetBrush(bs_Solid,0,colortorgb(smoothcolor(FrSortGrid.Color,48)));
  end else begin
    dib.SetBrush(bs_Solid,0,colortorgb(FrSortGrid.Color));
  end;
  dib.FillRect(rt);
  rts.Left:=rt.Left;
  rts.Top:=rt.Top+3;
  rts.Right:=rt.Left+ht-2;
  rts.Bottom:=rt.Top+1+ht;

  rtt.Left:=rt.Left+ht+5;
  rtt.Top:=rt.Top;
  rtt.Right:=rt.Right;
  rtt.Bottom:=rt.Bottom;
  //wd:=trunc(ht*0.45);
  //dib.SetFontEx(FrSortGrid.Font.Name,wd,ht,1,false,false,false);
  dib.SetPen(ps_Solid,1,ColorToRGB(FrSortGrid.Font.Color));
  dib.Rectangle(rt.Left,rt.Top+3,rt.Left+ht-2,rt.Top+1+ht);

  dib.SetFont(FrSortGrid.Font.Name,ht);
  dib.DrawText(Name,rtt,DT_VCENTER);
  if select then dib.DrawText('X',rts,DT_CENTER);
end;

destructor TSortOneStr.destroy;
begin
  freemem(@rt.Left);
  freemem(@rt.Top);
  freemem(@rt.Right);
  freemem(@rt.Bottom);
  freemem(@Name);
  freemem(@Field);
  freemem(@TypeData);
  freemem(@Proc);
  freemem(@select);
  freemem(@smouse);
end;

constructor tmysortlist.create;
begin
  rttext.Left   := 0;
  rttext.Top    := 0;
  rttext.Right  := 0;
  rttext.Bottom := 0;
  rtdir.Left    := 0;
  rtdir.Top     := 0;
  rtdir.Right   := 0;
  rtdir.Bottom  := 0;
  direction     := false;
  Count         := 0;
end;

procedure tmysortlist.clear;
var i : integer;
begin
  rttext.Left   := 0;
  rttext.Top    := 0;
  rttext.Right  := 0;
  rttext.Bottom := 0;
  rtdir.Left    := 0;
  rtdir.Top     := 0;
  rtdir.Right   := 0;
  rtdir.Bottom  := 0;
  direction     := false;
  for i:=Count-1 downto 0 do begin
    List[Count-1].FreeInstance;
    Count:=Count-1;
    Setlength(List,Count);
  end;
end;

procedure tmysortlist.Add(Name,Field : string; TypeData : TTypeMySort; Proc : integer);
begin
  Count:=Count+1;
  Setlength(List,Count);
  List[Count-1]:=tsortonestr.Create;//(Name,Field,TypeData,Proc);
  List[Count-1].Name:=Name;
  List[Count-1].Field:=Field;
  List[Count-1].TypeData:=TypeData;
  List[Count-1].Proc:=proc;
end;

function tmysortlist.selectindex : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to Count-1 do begin
    if List[i].select then begin
      result := i;
      exit;
    end;
  end;
end;

procedure tmysortlist.Init(cv : tcanvas);
var i, wdth, hght, hrw, ps : integer;
begin
  wdth:=cv.ClipRect.Right - cv.ClipRect.Left;
  hght := Count *25 + 10;
  if hght-10 > cv.ClipRect.Bottom - cv.ClipRect.Top
    then hght:=cv.ClipRect.Bottom - cv.ClipRect.Top;

  //hght:=cv.ClipRect.Bottom - cv.ClipRect.Top;
  hrw := (hght-10) div Count;
  ps := 5;
  for i := 0 to Count-1 do begin
    List[i].Rt.Left:=5;
    List[i].Rt.Top:=ps;
    List[i].Rt.Right:=wdth-5;
    List[i].Rt.Bottom:=List[i].Rt.Top+hrw;
    ps:=List[i].Rt.Bottom;
  end;
  rtdir.Top:=ps;
  rtdir.Bottom:=rtdir.Top+hrw;
  rtdir.Right:=wdth - 5;
  rtdir.Left:=rtdir.Right-(wdth div 3);
  rttext.Top:=ps;
  rttext.Bottom:=rttext.Top + hrw;
  rttext.Left:=5;
  rttext.Right:=rtdir.Left-5;
  if count=1 then List[0].select:=true;

end;

procedure tmysortlist.Draw(cv : tcanvas);
var tmp : tfastdib;
    i : integer;
    rt: trect;
begin
   init(cv);
   tmp := tfastdib.Create;
   try
     tmp.SetSize(cv.ClipRect.Right-cv.ClipRect.Left,cv.ClipRect.Bottom-cv.ClipRect.Top,32);
     tmp.Clear(TColorToTfcolor(FrSortGrid.Color));
     tmp.SetBrush(bs_solid,0,colortorgb(FrSortGrid.Color));
     tmp.FillRect(Rect(0,0,tmp.Width,tmp.Height));
     tmp.SetTransparent(true);
     tmp.SetPen(ps_Solid,1,ColorToRGB(FrSortGrid.Font.Color));
     tmp.Rectangle(1,1,cv.ClipRect.Right-1,cv.ClipRect.Bottom-1);
     for i:=0 to Count-1 do List[i].Draw(tmp);
     tmp.SetTransparent(false);
     tmp.DrawRect(cv.Handle,cv.ClipRect.Left,cv.ClipRect.Top,cv.ClipRect.Right,cv.ClipRect.Bottom,0,0);
     cv.Refresh;
   finally
     tmp.Free;
   end;
end;

function tmysortlist.MouseMove(cv : tcanvas; X, Y : integer) : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to count-1 do begin
    //List[i].smouse:=false;
    if (Y>List[i].Rt.Top+5) and (Y<List[i].Rt.Bottom-5) then begin
      List[i].smouse:=true;
      result := i;
      exit;
    end else List[i].smouse:=false;
  end;
end;

function tmysortlist.MouseClick(cv : tcanvas; X, Y : integer) : integer;
var i : integer;
begin
  result := -1;
  for i:=0 to count-1 do begin
    //List[i].smouse:=false;
    if (Y>List[i].Rt.Top) and (Y<List[i].Rt.Bottom) then begin
      List[i].Select:=not List[i].Select;
      result := i;
    end else List[i].select:=false;
  end;
end;

destructor tmysortlist.destroy;
begin
  Clear;
  freemem(@List);
  freemem(@Count);
end;

procedure execsorting(Grid: tstringgrid; StartRow, ACol : integer);
var rw : integer;
begin
       //case SortMyList[FrSortGrid.RadioGroup1.ItemIndex].TypeData of
  rw := mysortlist.selectindex;
       case mysortlist.List[rw].TypeData of
  tstext : begin
             SortGridAlphabet(Grid, StartRow, ACol, mysortlist.List[rw].Field, FrSortGrid.Direction);
             if makelogging then WriteLog('MAIN', 'USortGrid.execsorting tstext Grid=' + Grid.Name + ' StartRow=' + inttostr(StartRow) + ' Col=' + inttostr(ACol));
           end;
  tstime : begin
             SortGridTime(Grid, StartRow, ACol, mysortlist.List[rw].Field, FrSortGrid.Direction);
             if makelogging then WriteLog('MAIN', 'USortGrid.execsorting tstime Grid=' + Grid.Name + ' StartRow=' + inttostr(StartRow) + ' Col=' + inttostr(ACol));
           end;
  tsdate : begin
                case mysortlist.List[rw].Proc of
           0 : SortGridDate(Grid, StartRow, ACol, mysortlist.List[rw].Field, FrSortGrid.Direction);
           1 : SortGridStartTime(Grid, FrSortGrid.Direction);
                end;
             if makelogging then WriteLog('MAIN', 'USortGrid.execsorting tsdate Grid=' + Grid.Name + ' StartRow=' + inttostr(StartRow) + ' Col=' + inttostr(ACol));
           end;
       end; //case
end;

Procedure GridSort(Grid: tstringgrid; StartRow, ACol : integer);
begin
  try
  sortbuttons.SetDefaultFonts;
  if makelogging then WriteLog('MAIN', 'USortGrid.GridSort Start Grid=' + Grid.Name + ' StartRow=' + inttostr(StartRow) + ' Col=' + inttostr(ACol));
  mysortlist.Draw(FrSortGrid.Image3.Canvas);
  FrSortGrid.ShowModal;
  if FrSortGrid.ModalResult = mrok then begin
    if mysortlist.selectindex<0 then exit;
    execsorting(Grid, StartRow, ACol);
    if makelogging then WriteLog('MAIN', 'USortGrid.GridSort Finish Grid=' + Grid.Name + ' StartRow=' + inttostr(StartRow) + ' Col=' + inttostr(ACol));
  end;
  except
    on E: Exception do WriteLog('MAIN', 'USortGrid.GridSort | ' + E.Message);
  end;
end;


procedure TFrSortGrid.FormCreate(Sender: TObject);
var rw, btn : integer;
begin
  InitFrSortGrid;
  mysortlist:=tmysortlist.create;
  sortbuttons := TBTNSPanel.Create;
  sortbuttons.Top:=5;
  sortbuttons.Bottom:=5;
  sortbuttons.Left:=5;
  sortbuttons.Right:=10;
  sortbuttons.BackGround:=FrSortGrid.Color;
  sortbuttons.Interval:=5;
  sortbuttons.HeightRow:=25;
  rw:=sortbuttons.AddRow;
  btn:=sortbuttons.Rows[rw].AddButton('от А к Z', imnone);
  sortbuttons.Rows[rw].Btns[btn].Alignment:=psCenter;
  sortbuttons.Rows[rw].Btns[btn].Hint:='Сортировать от А к Z';
  //btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
  sortbuttons.Rows[rw].Btns[btn].HintShow:=true;
  sortbuttons.Rows[rw].Btns[btn].FontHint.Size:=8;
  sortbuttons.Rows[rw].Btns[btn].ColorBorder:=FrSortGrid.Font.Color;
  sortbuttons.Rows[rw].Btns[btn].Color:=FrSortGrid.Color;
  rw:=sortbuttons.AddRow;
  btn:=sortbuttons.Rows[rw].AddButton('от Z к А', imnone);
  sortbuttons.Rows[rw].Btns[btn].Alignment:=psCenter;
  sortbuttons.Rows[rw].Btns[btn].Hint:='Сортировать от Z к А';
  //btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
  sortbuttons.Rows[rw].Btns[btn].HintShow:=true;
  sortbuttons.Rows[rw].Btns[btn].FontHint.Size:=8;
  sortbuttons.Rows[rw].Btns[btn].ColorBorder:=FrSortGrid.Font.Color;
  sortbuttons.Rows[rw].Btns[btn].Color:=FrSortGrid.Color;
  rw:=sortbuttons.AddRow;
  btn:=sortbuttons.Rows[rw].AddButton('Отмена', imnone);
  sortbuttons.Rows[rw].Btns[btn].Alignment:=psCenter;
  sortbuttons.Rows[rw].Btns[btn].Hint:='Выход без сортировки';
  //btnsctlleft.Rows[RowTemp].Btns[BtnTemp].ImagePosition:=psCenter;
  sortbuttons.Rows[rw].Btns[btn].HintShow:=true;
  sortbuttons.Rows[rw].Btns[btn].FontHint.Size:=8;
  sortbuttons.Rows[rw].Btns[btn].ColorBorder:=FrSortGrid.Font.Color;
  sortbuttons.Rows[rw].Btns[btn].Color:=FrSortGrid.Color;
  sortbuttons.Draw(Image4.Canvas);

  //speedbutton3.Glyph.Assign(Image1.Picture.Graphic);
  Direction := true;
end;

procedure TFrSortGrid.FormDestroy(Sender: TObject);
begin
  MySortList.Free;
end;

procedure TFrSortGrid.FormKeyPress(Sender: TObject; var Key: Char);
begin
//     case Key of
//  #13 : begin
//          if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid.FormKeyPress Key=13 ModalResult := mrOk');
//          ModalResult := mrOk;
//        end;
  if Key=#27 then begin
    if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid.FormKeyPress Key=27 ModalResult := mrCancel');
    Modalresult := mrCancel;
  end;
//  end;
end;

procedure TFrSortGrid.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  mysortlist.MouseMove(Image3.Canvas, X, Y);
  mysortlist.Draw(Image3.Canvas);
  Image3.Repaint;
end;

procedure TFrSortGrid.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mysortlist.MouseClick(Image3.Canvas, X, Y);
  mysortlist.Draw(Image3.Canvas);
  Image3.Repaint;
end;

procedure TFrSortGrid.Image4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i : integer;
begin
  for i:=0 to mysortlist.Count-1 do mysortlist.List[i].smouse:=false;
  mysortlist.Draw(Image3.Canvas);
  Image3.Repaint;
  sortbuttons.MouseMove(Image4.Canvas,X,Y);
  //sortbuttons.Draw(Image4.Canvas);
  Image4.Repaint;
end;

procedure TFrSortGrid.Image4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var res : integer;
begin
  res := sortbuttons.ClickButton(Image4.Canvas,X,Y);
  sortbuttons.Draw(Image4.Canvas);
  Image4.Repaint;
    case res of
  0 : begin
        Direction := true;
        if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid Direction := true');
        ModalResult := mrOk;
      end;
  1 : begin
        Direction := false;
        if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid Direction := false');
        ModalResult := mrOk;
      end;
  2 : begin
        if makelogging then WriteLog('MAIN', 'USortGrid.TFrSortGrid Cansel');
        Close;
      end;
    end;
end;

end.
