unit UInitForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids;

  Procedure initPanelMenu;
  Procedure initmainprogram;
  procedure initUsersPanel;
  procedure initPanelProg;

  procedure initfrNewUser;

implementation
uses umain, ucommon, UIMGButtons, ugrid, unewuser;

Procedure initmainprogram;
begin
  with form1 do begin
    DoubleBuffered := true;

    Color := ProgrammColor;
    Font.Name := ProgrammFontName;
    Font.Color := ProgrammFontColor;
    Font.Size := ProgrammFontSize;
  end;
end;

procedure initPanelProg;
var
  i: TForm1;
begin
  With Form1 do begin
    PanelProg.Align:=alClient;
    PanelProg.DoubleBuffered := true;
    pnctrlprog.DoubleBuffered := true;
    pnviewprog.DoubleBuffered := true;
    pnsampleprog.DoubleBuffered :=true;
    panel1.DoubleBuffered := true;
    Label1.Parent.DoubleBuffered := true;
    Label2.Parent.DoubleBuffered := true;
    GridSample.DoubleBuffered := true;
    ComboBox1.DoubleBuffered := true;
  //  RadioGroup1.DoubleBuffered := true;

    PanelProg.Color := ProgrammColor;
    PanelProg.Font.Name := ProgrammFontName;
    PanelProg.Font.Color := ProgrammFontColor;
    PanelProg.Font.Size := ProgrammFontSize;

    Panel1.Color := ProgrammColor;
    Panel1.Font.Name := ProgrammFontName;
    Panel1.Font.Color := ProgrammFontColor;
    Panel1.Font.Size := ProgrammFontSize;

    ComboBox1.Color := ProgrammColor;
    ComboBox1.Font.Name := ProgrammFontName;
    ComboBox1.Font.Color := ProgrammFontColor;
    ComboBox1.Font.Size := ProgrammFontSize+2;

    Panel2.Color := SmoothColor(ProgrammColor,32);
    Panel2.Font.Name := ProgrammFontName;
    Panel2.Font.Color := ProgrammFontColor;
    Panel2.Font.Size := ProgrammFontSize;

    pnctrlprog.Color := ProgrammColor;
    pnctrlprog.Font.Name := ProgrammFontName;
    pnctrlprog.Font.Color := ProgrammFontColor;
    pnctrlprog.Font.Size := ProgrammFontSize;

    pnviewprog.Color := SmoothColor(ProgrammColor,16);
    pnviewprog.Font.Name := ProgrammFontName;
    pnviewprog.Font.Color := ProgrammFontColor;
    pnviewprog.Font.Size := ProgrammFontSize;

    pnsampleprog.Color := ProgrammColor;
    pnsampleprog.Font.Name := ProgrammFontName;
    pnsampleprog.Font.Color := ProgrammFontColor;
    pnsampleprog.Font.Size := ProgrammFontSize;

    pnsampleprog.Left := 40;
    pnsampleprog.Width := pnviewprog.Width - 80;

    pnsampleprog.Top := 40;
    pnsampleprog.Height := pnviewprog.Height - 80;

    GridSample.Color := SmoothColor(ProgrammColor,8);
    GridSample.Font.Name := ProgrammFontName;
    GridSample.Font.Color := ProgrammFontColor;
    GridSample.Font.Size := ProgrammFontSize;
    GridSample.FixedColor := ProgrammColor;

    btnspanelsample.Draw(imgsamplebtn.Canvas);
    image1.Width:=128;

    GridSample.RowCount:=4;
    GridSample.ColCount:=1;
    //GridColorRow1:=SmoothColor(ProgrammColor,24);
    //GridColorRow2:=SmoothColor(ProgrammColor,72);
    initgrid(GridSample, RowGridSample, pnviewprog.Width - 80);
    //for i := Low to High do
    GridSample.RowCount:=GridSample.RowCount;

  end;
end;

procedure initUsersPanel;
Begin
  With Form1 do begin
    PanelUsers.Align:=alClient;
    PanelUsers.DoubleBuffered := true;
    pnctrlusers.DoubleBuffered := true;
    Label1.Parent.DoubleBuffered := true;
    imgbtnsusers.Parent.DoubleBuffered := true;
    GridUsers.DoubleBuffered := true;

    PanelUsers.Color := ProgrammColor;
    PanelUsers.Font.Name := ProgrammFontName;
    PanelUsers.Font.Color := ProgrammFontColor;
    PanelUsers.Font.Size := ProgrammFontSize;

    pnctrlusers.Color := ProgrammColor;
    pnctrlusers.Font.Name := ProgrammFontName;
    pnctrlusers.Font.Color := ProgrammFontColor;
    pnctrlusers.Font.Size := ProgrammFontSize;

    Label1.Color := ProgrammColor;
    Label1.Font.Name := ProgrammFontName;
    Label1.Font.Color := ProgrammFontColor;
    Label1.Font.Size := ProgrammFontSize + 2;

    GridUsers.Color := SmoothColor(ProgrammColor,8);
    GridUsers.Font.Name := ProgrammFontName;
    GridUsers.Font.Color := ProgrammFontColor;
    GridUsers.Font.Size := ProgrammFontSize;

    imgbtnsusers.Canvas.Brush.Color := ProgrammColor;
    imgbtnsusers.Canvas.Font.Name := ProgrammFontName;
    imgbtnsusers.Canvas.Font.Color := ProgrammFontColor;
    imgbtnsusers.Canvas.Font.Size := ProgrammFontSize;

    btnspanelusers.Draw(imgbtnsusers.Canvas);
    GridUsers.RowCount:=2;
    GridUsers.ColCount:=1;
    GridColorRow1:=SmoothColor(ProgrammColor,24);
    GridColorRow2:=SmoothColor(ProgrammColor,72);
    initgrid(GridUsers, RowGridUsers, Form1.Width - pnctrlusers.Width);
    ReadUsersFromFile('workingdata.dll',GridUsers);
    GridUsers.Repaint;
  end;
End;

Procedure initPanelMenu;
begin
  with form1 do begin
    panelmenu.DoubleBuffered := true;
    sbpmusers.Parent.DoubleBuffered := true;
    sbpmprog.Parent.DoubleBuffered := true;
    sbpmform.Parent.DoubleBuffered := true;
    sbpmlist.Parent.DoubleBuffered := true;
    sbpmevent.Parent.DoubleBuffered := true;
    sbpmhotkey.Parent.DoubleBuffered := true;

    PanelMenu.Color := ProgrammColor;
    PanelMenu.Font.Name := ProgrammFontName;
    PanelMenu.Font.Color := ProgrammFontColor;
    PanelMenu.Font.Size := ProgrammFontSize;

    sbpmusers.Font.Name := ProgrammFontName;
    sbpmusers.Font.Color := ProgrammFontColor;
    sbpmusers.Font.Size := ProgrammFontSize + 2;

    sbpmprog.Font.Name := ProgrammFontName;
    sbpmprog.Font.Color := ProgrammFontColor;
    sbpmprog.Font.Size := ProgrammFontSize + 2;

    sbpmform.Font.Name := ProgrammFontName;
    sbpmform.Font.Color := ProgrammFontColor;
    sbpmform.Font.Size := ProgrammFontSize + 2;

    sbpmlist.Font.Name := ProgrammFontName;
    sbpmlist.Font.Color := ProgrammFontColor;
    sbpmlist.Font.Size := ProgrammFontSize + 2;

    sbpmevent.Font.Name := ProgrammFontName;
    sbpmevent.Font.Color := ProgrammFontColor;
    sbpmevent.Font.Size := ProgrammFontSize + 2;

    sbpmhotkey.Font.Name := ProgrammFontName;
    sbpmhotkey.Font.Color := ProgrammFontColor;
    sbpmhotkey.Font.Size := ProgrammFontSize + 2;
  end;
end;

procedure initfrNewUser;
begin
  with frnewuser do begin
    DoubleBuffered := true;
    edFamily.DoubleBuffered := true;
    edName.DoubleBuffered := true;
    edSubname.DoubleBuffered := true;
    edShortName.DoubleBuffered := true;
    edLogin.DoubleBuffered := true;
    edPassword.DoubleBuffered := true;
    SpeedButton1.Parent.DoubleBuffered := true;
    SpeedButton2.Parent.DoubleBuffered := true;
    Label1.Parent.DoubleBuffered := true;
    Label2.Parent.DoubleBuffered := true;
    Label3.Parent.DoubleBuffered := true;
    Label4.Parent.DoubleBuffered := true;
    Label5.Parent.DoubleBuffered := true;
    Label6.Parent.DoubleBuffered := true;

    Color := FormsColor;
    Font.Name := FormsFontName;
    Font.Color := FormsFontColor;
    Font.Size := FormsFontSize;

    Label1.Color := FormsColor;
    Label1.Font.Name := FormsFontName;
    Label1.Font.Color := FormsFontColor;
    Label1.Font.Size := FormsFontSize;

    Label2.Color := FormsColor;
    Label2.Font.Name := FormsFontName;
    Label2.Font.Color := FormsFontColor;
    Label2.Font.Size := FormsFontSize;

    Label3.Color := FormsColor;
    Label3.Font.Name := FormsFontName;
    Label3.Font.Color := FormsFontColor;
    Label3.Font.Size := FormsFontSize;

    Label4.Color := FormsColor;
    Label4.Font.Name := FormsFontName;
    Label4.Font.Color := FormsFontColor;
    Label4.Font.Size := FormsFontSize;

    Label5.Color := FormsColor;
    Label5.Font.Name := FormsFontName;
    Label5.Font.Color := FormsFontColor;
    Label5.Font.Size := FormsFontSize;

    Label6.Color := FormsColor;
    Label6.Font.Name := FormsFontName;
    Label6.Font.Color := FormsFontColor;
    Label6.Font.Size := FormsFontSize;

    Label7.Color := FormsColor;
    Label7.Font.Name := FormsFontName;
    Label7.Font.Color := FormsFontColor;
    Label7.Font.Size := FormsFontSize;

    edFamily.Color := FormsEditColor;
    edFamily.Font.Name := FormsEditFontName;
    edFamily.Font.Color := FormsEditFontColor;
    edFamily.Font.Size := FormsEditFontSize;

    edName.Color := FormsEditColor;
    edName.Font.Name := FormsEditFontName;
    edName.Font.Color := FormsEditFontColor;
    edName.Font.Size := FormsEditFontSize;

    edSubname.Color := FormsEditColor;
    edSubname.Font.Name := FormsEditFontName;
    edSubname.Font.Color := FormsEditFontColor;
    edSubname.Font.Size := FormsEditFontSize;

    edShortname.Color := FormsEditColor;
    edShortname.Font.Name := FormsEditFontName;
    edShortname.Font.Color := FormsEditFontColor;
    edShortname.Font.Size := FormsEditFontSize;

    edLogin.Color := FormsEditColor;
    edLogin.Font.Name := FormsEditFontName;
    edLogin.Font.Color := FormsEditFontColor;
    edLogin.Font.Size := FormsEditFontSize;

    edPassword.Color := FormsEditColor;
    edPassword.Font.Name := FormsEditFontName;
    edPassword.Font.Color := FormsEditFontColor;
    edPassword.Font.Size := FormsEditFontSize;

    SpeedButton1.Font.Name := FormsFontName;
    SpeedButton1.Font.Color := FormsFontColor;
    SpeedButton1.Font.Size := FormsFontSize + 2;

    SpeedButton2.Font.Name := FormsFontName;
    SpeedButton2.Font.Color := FormsFontColor;
    SpeedButton2.Font.Size := FormsFontSize + 2;
  end;
end;


end.
