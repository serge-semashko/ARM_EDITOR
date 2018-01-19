unit UWaiting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,  MMSystem;

type
  TFWaiting = class(TForm)
    procedure FormCreate(Sender: TObject);
   // procedure TimeCallBack(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); stdcall;
  private
    { Private declarations }


    //mmResult : integer;
    //TimeCallBack(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); pascal;
  public
    { Public declarations }
    TimerWord : string;
    Position : integer;
    //procedure Start(wrd : string);
    //Procedure Stop;
    Procedure Draw;

  end;

var
  FWaiting: TFWaiting;
  //Position1 : integer;

implementation
uses ucommon;

{$R *.dfm}

procedure TFWaiting.Draw;
var step, i : integer;
    cl : array[0..11] of tcolor;
begin
  Canvas.brush.Style := bsClear;
  Canvas.brush.Color:=clWhite;
  Canvas.FillRect(canvas.ClipRect);
  //Canvas.pen.Color:=clsilver;

  //step := width div 4;
  for i:=0 to 11 do cl[i]:=clWhite;
  step := Position mod 12;
  cl[step] := clSilver;
  Canvas.Brush.Color:=cl[11];
  Canvas.Pie(10,10,Width-10, height-10, 300 , 0, 200, 0);
  Canvas.Brush.Color:=cl[10];
  Canvas.Pie(10,10,Width-10, height-10, 180 , 0, 120, 0);
  Canvas.Brush.Color:=cl[9];
  Canvas.Pie(10,10,Width-10, height-10, 100 , 0, 0, 0);

  Canvas.Brush.Color:=cl[8];
  Canvas.Pie(10,10,Width-10, height-10, 0, 20, 0, 100);
  Canvas.Brush.Color:=cl[7];
  Canvas.Pie(10,10,Width-10, height-10, 0 , 120, 0, 180);
  Canvas.Brush.Color:=cl[6];
  Canvas.Pie(10,10,Width-10, height-10, 0 , 200, 0, 280);

  Canvas.Brush.Color:=cl[5];
  Canvas.Pie(10,10,Width-10, height-10, 0, 300, 100, 300);
  Canvas.Brush.Color:=cl[4];
  Canvas.Pie(10,10,Width-10, height-10, 120 , 300, 180, 300);
  Canvas.Brush.Color:=cl[3];
  Canvas.Pie(10,10,Width-10, height-10, 200 , 300, 300, 300);

  Canvas.Brush.Color:=cl[2];
  Canvas.Pie(10,10,Width-10, height-10, 300, 280, 300, 200);
  Canvas.Brush.Color:=cl[1];
  Canvas.Pie(10,10,Width-10, height-10, 300 , 180, 300, 120);
  Canvas.Brush.Color:=cl[0];
  Canvas.Pie(10,10,Width-10, height-10, 300 , 100, 300, 20);

  canvas.Brush.Color:=SmoothColor(clWhite,16);
  Canvas.Font.Color:=clBlue;
  Canvas.TextOut((Width-Canvas.TextWidth(TimerWord)) div 2, (Height - Canvas.TextHeight(TimerWord)) div 2, TimerWord);

  Show;
end;

procedure TFWaiting.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=true;
  Canvas.brush.Style := bsClear;
  Canvas.brush.Color:=clWhite;
  Canvas.FillRect(canvas.ClipRect);
  Canvas.pen.Color:=clsilver;
  Canvas.Font.Size:=ProgrammFontSize+2;
  Canvas.Font.Name:=ProgrammFontName;
  Draw;
end;

end.
