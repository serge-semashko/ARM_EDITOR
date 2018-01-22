unit UInitForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Grids, ImgList, umediacopy,
  USetTC, JPEG;

  procedure InputInSystem;
  procedure InitMainForm;
  Procedure InitPanelPrepare;
  procedure InitPanelAir;
  Procedure UpdatePanelPrepare;
  Procedure UpdatePanelAir;
  procedure InitPanelProject;
  procedure InitPanelControl;
  Procedure InitPanelClips;
  Procedure InitPanelPlayList;

  procedure InitNewProject;
  procedure InitPlaylists;
  procedure InitTextTemplates;
  procedure InitMyMessage;
  procedure InitEditTimeline;
  procedure InitImageTemplate;
  Procedure InitImportFiles;
  procedure InitFrSetTemplate;
  procedure InitFrSetEventData;
  procedure InitFrButtonOptions;
  procedure InitFrSortGrid;
  procedure InitFrShiftTL;
  procedure InitFrShortNum;
  procedure InitFrMediaCopy;
  procedure InitfrMyPrint;
  procedure InitFPageSetup;
  procedure InitFrLTC;
  procedure InitfrTimeCode;
  procedure InitfrMyTextTemplate;
  procedure InitfrNewList;

implementation

uses UMain, UCommon, UImgButtons, UDrawTimelines, UTimeline, UProject, UGrid,
     UGRTimelines, umyevents, uplaylists, utexttemplate, umymessage, uimagetemplate,
     uairdraw, uimportfiles, umyfiles, usettemplate, useteventdata, ubuttonoptions,
     ugridsort, UMyMediaSwitcher, ushifttl, ushortnum, umyprint, upagesetup, umyltc,
     umytexttemplate, umynewlist, uplayer;

procedure InputInSystem;
begin
  WriteLog('MAIN', 'UInitForms.InputInSystem');
  with Form1 do begin
    InputPanel.Color:=ProgrammColor;
    InputPanel.Font.Name:=ProgrammFontName;
    InputPanel.Font.Size:=ProgrammFontSize+1;
    InputPanel.Font.Color:=ProgrammFontColor;

    InputPanel.Left:=0;
    InputPanel.Width:=Form1.ClientWidth;
    InputPanel.Top:=0;
    InputPanel.Height:=Form1.ClientHeight;

    Label14.Color:=ProgrammColor;
    Label14.Font.Name:=ProgrammFontName;
    Label14.Font.Size:=ProgrammFontSize+1;
    Label14.Font.Color:=ProgrammFontColor;

    Label8.Color:=ProgrammColor;
    Label8.Font.Name:=ProgrammFontName;
    Label8.Font.Size:=ProgrammFontSize+1;
    Label8.Font.Color:=ProgrammFontColor;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=FormsFontSize + 1;
    Edit1.Font.Name:=FormsFontName;

    Edit2.Color:=FormsEditColor;
    Edit2.Font.Color:=FormsEditFontColor;
    Edit2.Font.Size:=FormsFontSize + 1;
    Edit2.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+1;
    SpeedButton1.Font.Name:=FormsFontName;

    Edit1.Width := 250;
    EDIT2.Width := 250;

    Edit1.Left:=(Width-Edit1.Width) div 2;
    Edit2.Left:=Edit1.Left;
    Label14.Left:=Edit1.Left;
    Label8.Left:=Edit1.Left;
    SpeedButton1.Left:=(Width-SpeedButton1.Width) div 2;

    Label14.Top:=Height div 2 - 50;
    Edit2.Top:=Label14.Top + Label14.Height+1;
    SpeedButton1.Top:=Edit2.Top + Edit2.Height + 10;
    Edit1.Top:=Label14.Top - 10 - Edit1.Height;
    Label8.Top:=Edit1.Top - Label8.Height-1;


    repeat
      application.ProcessMessages;
    until Form1.InputPanel.Visible;
    WriteLog('MAIN', 'UInitForms.InputInSystem - Вход в систему выполнен');
  end;
end;

procedure InitPanelAir;
begin
  WriteLog('MAIN', 'UInitForms.InitPanelAir');
  with Form1 do begin
    PanelAir.DoubleBuffered:=true;
    PanelAir.Left:=PanelPrepare.Left;
    PanelAir.Width:=PanelPrepare.Width;
    PanelAir.Top:=PanelPrepare.Top;
    PanelAir.Height:=Panel3.Height + TLHeights.Scaler + TLHeights.IntervalEdit + TLHeights.Edit + TLHeights.Interval;

    imgDevices.Picture.Bitmap.Width:=imgDevices.Width;
    imgDevices.Picture.Bitmap.Height:=imgDevices.Height;

    imgEvents.Top:=PanelAir.Top;
    ImgEvents.Left:=PanelAir.Left;
    imgEvents.Width:=imgDevices.Width;
    imgEvents.Height:=PanelAir.Height-imgDevices.Height;
    imgEvents.Picture.Bitmap.Width:=imgEvents.Width;
    imgEvents.Picture.Bitmap.Height:=imgEvents.Height;

    PanelAir.Color:=ProgrammColor;
    PanelAir.Font.Name:=ProgrammFontName;
    PanelAir.Font.Size:=ProgrammFontSize;
    PanelAir.Font.Color:=ProgrammFontColor;

    imgDevices.Canvas.Brush.Color:=ProgrammColor;
    imgDevices.Canvas.Font.Name:=ProgrammFontName;
    imgDevices.Canvas.Font.Size:=ProgrammFontSize;
    imgDevices.Canvas.Font.Color:=ProgrammFontColor;
    imgDevices.Canvas.Pen.Color:=ProgrammFontColor;

    imgEvents.Canvas.Brush.Color:=SmoothColor(ProgrammColor,32);
    imgEvents.Canvas.Font.Name:=ProgrammFontName;
    imgEvents.Canvas.Font.Size:=ProgrammFontSize;
    imgEvents.Canvas.Font.Color:=ProgrammFontColor;
    imgEvents.Canvas.Pen.Color:=ProgrammFontColor;

    imgDevices.Width := PanelPrepare.Width;
    imgDevices.Picture.Bitmap.Width:=imgDevices.Width;
    imgDevices.Picture.Bitmap.Height:=imgDevices.Height;

    imgDevices.Repaint;
    imgEvents.Repaint;
  end;
end;

Procedure UpdatePanelAir;
begin
  WriteLog('MAIN', 'UInitForms.UpdatePanelAir');
  with Form1 do begin
    PanelAir.Left:=PanelPrepare.Left;
    PanelAir.Width:=PanelPrepare.Width;
    PanelAir.Top:=PanelPrepare.Top;
    PanelAir.Height:=Panel3.Height + TLHeights.Scaler + TLHeights.IntervalEdit + TLHeights.Edit + TLHeights.Interval;

    imgDevices.Width := PanelPrepare.Width;
    imgDevices.Picture.Bitmap.Width:=imgDevices.Width;
    imgDevices.Picture.Bitmap.Height:=imgDevices.Height;

    imgDevices.Repaint;
    Application.ProcessMessages;
    imgEvents.Top:=0;//PanelAir.Top;
    ImgEvents.Left:=0;//PanelAir.Left;
    imgEvents.Width:=imgDevices.Width;
    imgEvents.Height:=PanelAir.Height-imgDevices.Height;
    imgEvents.Picture.Bitmap.Width:=imgEvents.Width;
    imgEvents.Picture.Bitmap.Height:=PanelAir.Height-imgDevices.Height;//imgEvents.Height;
    imgEvents.Repaint;
    Application.ProcessMessages;
    //mypanelair.SetValues;
    mypanelair.AirEvents.Init(imgEvents.Canvas);
    mypanelair.SetValues;
    MyPanelAir.Draw(ImgDevices.Canvas,ImgEvents.Canvas,TLZone.TLEditor.Index);
    Application.ProcessMessages;
  end;
end;

Procedure InitPanelPrepare;
begin
  WriteLog('MAIN', 'UInitForms.InitPanelPrepare');
  with form1 do begin
//Избавляемся от мирцания экрана при прорисовке
    PanelPrepare.DoubleBuffered:=true;
    Panel3.DoubleBuffered:=true;
    pnTypeMovie.DoubleBuffered:=true;
//    imgTypeMovie.Parent.DoubleBuffered:=true;
    pnPrepareCTL.DoubleBuffered:=true;
    imgCTLPrepare1.Parent.DoubleBuffered:=true;
    pnPrepareSong.DoubleBuffered:=true;
    imgSongLock.Parent.DoubleBuffered:=true;
    pnDevTL.DoubleBuffered:=true;
    imgDeviceTL.Parent.DoubleBuffered:=true;
    pnMediaTL.DoubleBuffered:=true;
    spDeleteTemplate.Parent.DoubleBuffered:=true;
    sbSinhronization.Parent.DoubleBuffered := true;
    panel13.DoubleBuffered:=true;
    panel14.DoubleBuffered:=true;
    panel15.DoubleBuffered:=true;
    panel16.DoubleBuffered:=true;

    panel17.DoubleBuffered:=true;
    panel18.DoubleBuffered:=true;
    panel19.DoubleBuffered:=true;
    panel20.DoubleBuffered:=true;
    panel21.DoubleBuffered:=true;
    panel22.DoubleBuffered:=true;
    Label3.Parent.DoubleBuffered:=true;
    Label6.Parent.DoubleBuffered:=true;
    lbMediaTotalDur.Parent.DoubleBuffered:=true;
    //Label8.Parent.DoubleBuffered:=true;
    Label9.Parent.DoubleBuffered:=true;
    lbMediaDuration.Parent.DoubleBuffered:=true;
    lbMediaNTK.Parent.DoubleBuffered:=true;
    lbMediaKTK.Parent.DoubleBuffered:=true;
    lbMediaCurTK.Parent.DoubleBuffered:=true;

    Label1.Parent.DoubleBuffered:=true;
    GridGRTemplate.DoubleBuffered:=true;
    CheckBox1.DoubleBuffered:=true;
    CheckBox2.DoubleBuffered:=true;
    imgMediaTL.Parent.DoubleBuffered:=true;
    pnTextTL.DoubleBuffered:=true;
    imgTextTL.Parent.DoubleBuffered:=true;
    pnMovie.DoubleBuffered:=true;
    Panel4.DoubleBuffered:=true;
    lbCTLTimeCode.Parent.DoubleBuffered:=true;
    lbTypeTC.Parent.DoubleBuffered:=true;
    imgCTLBottomR.Parent.DoubleBuffered:=true;
    imgCTLBottomL.Parent.DoubleBuffered:=true;
    imgTimelines.Parent.DoubleBuffered:=true;
   // ControlStyle := ControlStyle + [ csOpaque ] ;
   //   InvalidateRect( imgTimelines.Canvas.Handle, NIL, FALSE ) ;
   //   imgTimelines.ControlStyle := imgTimelines.ControlStyle + [ csOpaque ] ;
    imgLayer0.Parent.DoubleBuffered:=true;
   //   imgLayer0.ControlStyle := imgLayer0.ControlStyle + [ csOpaque ] ;
   //   InvalidateRect( imgLayer0.Canvas.Handle, NIL, FALSE ) ;
    imgLayer1.Parent.DoubleBuffered:=true;
   //   imgLayer1.ControlStyle := imgLayer1.ControlStyle + [ csOpaque ] ;
   //   InvalidateRect( imgLayer1.Canvas.Handle, NIL, FALSE ) ;
    imgLayer2.Parent.DoubleBuffered:=true;
   //   imgLayer2.ControlStyle := imgLayer2.ControlStyle + [ csOpaque ] ;
   //   InvalidateRect( imgLayer2.Canvas.Handle, NIL, FALSE ) ;
    imgTLNames.Parent.DoubleBuffered:=true;



    ImgTimelines.Width:=Panel4.Width-imgTLNames.Width - 2*Panel4.BorderWidth;
    ImgTimelines.Picture.Bitmap.Width:=ImgTimelines.Width;
    ImgTimelines.Picture.Bitmap.Height:=ImgTimelines.Height;
//Устанавливаем параметры по умолчанию
    PanelPrepare.Color:=ProgrammColor;
    PanelPrepare.Font.Name:=ProgrammFontName;
    PanelPrepare.Font.Size:=ProgrammFontSize;
    PanelPrepare.Font.Color:=ProgrammFontColor;

    Panel3.Color:=ProgrammColor;
    Panel3.Font.Name:=ProgrammFontName;
    Panel3.Font.Size:=ProgrammFontSize;
    Panel3.Font.Color:=ProgrammFontColor;

    pnTypeMovie.Color:=ProgrammColor;
    pnTypeMovie.Font.Name:=ProgrammFontName;
    pnTypeMovie.Font.Size:=ProgrammFontSize;
    pnTypeMovie.Font.Color:=ProgrammFontColor;

    panel13.Color:=ProgrammColor;
    panel13.Font.Name:=ProgrammFontName;
    panel13.Font.Size:=ProgrammFontSize;
    panel13.Font.Color:=ProgrammFontColor;

    panel14.Color:=ProgrammColor;
    panel14.Font.Name:=ProgrammFontName;
    panel14.Font.Size:=ProgrammFontSize;
    panel14.Font.Color:=ProgrammFontColor;

    panel15.Color:=ProgrammColor;
    panel15.Font.Name:=ProgrammFontName;
    panel15.Font.Size:=ProgrammFontSize;
    panel15.Font.Color:=ProgrammFontColor;

    panel16.Color:=ProgrammColor;
    panel16.Font.Name:=ProgrammFontName;
    panel16.Font.Size:=ProgrammFontSize;
    panel16.Font.Color:=ProgrammFontColor;

    panel17.Color:=ProgrammColor;
    panel17.Font.Name:=ProgrammFontName;
    panel17.Font.Size:=ProgrammFontSize;
    panel17.Font.Color:=ProgrammFontColor;

    panel18.Color:=ProgrammColor;
    panel18.Font.Name:=ProgrammFontName;
    panel18.Font.Size:=ProgrammFontSize;
    panel18.Font.Color:=ProgrammFontColor;

    panel19.Color:=ProgrammColor;
    panel19.Font.Name:=ProgrammFontName;
    panel19.Font.Size:=ProgrammFontSize;
    panel19.Font.Color:=ProgrammFontColor;

    panel20.Color:=ProgrammColor;
    panel20.Font.Name:=ProgrammFontName;
    panel20.Font.Size:=ProgrammFontSize;
    panel20.Font.Color:=ProgrammFontColor;

    panel21.Color:=ProgrammColor;
    panel21.Font.Name:=ProgrammFontName;
    panel21.Font.Size:=ProgrammFontSize;
    panel21.Font.Color:=ProgrammFontColor;

    panel22.Color:=ProgrammColor;
    panel22.Font.Name:=ProgrammFontName;
    panel22.Font.Size:=ProgrammFontSize;
    panel22.Font.Color:=ProgrammFontColor;

    //cbSinhronization.Color:=ProgrammColor;
    sbSinhronization.Font.Name:=ProgrammFontName;
    sbSinhronization.Font.Size:=ProgrammFontSize;
    sbSinhronization.Font.Color:=ProgrammFontColor;

    spDeleteTemplate.Font.Name:=ProgrammFontName;
    spDeleteTemplate.Font.Size:=ProgrammFontSize;
    spDeleteTemplate.Font.Color:=ProgrammFontColor;

    pnImageScreen.Color:=ProgrammColor;
    pnImageScreen.Font.Name:=ProgrammFontName;
    pnImageScreen.Font.Size:=ProgrammFontSize;
    pnImageScreen.Font.Color:=SmoothColor(ProgrammFontColor,24);

    Label13.Color:=ProgrammColor;
    Label13.Font.Name:=ProgrammFontName;
    Label13.Font.Size:=ProgrammFontSize-1;
    Label13.Font.Color:=ProgrammFontColor;

    Label16.Color:=ProgrammColor;
    Label16.Font.Name:=ProgrammFontName;
    Label16.Font.Size:=ProgrammFontSize-1;
    Label16.Font.Color:=ProgrammFontColor;

    Label18.Color:=ProgrammColor;
    Label18.Font.Name:=ProgrammFontName;
    Label18.Font.Size:=ProgrammFontSize-1;
    Label18.Font.Color:=ProgrammFontColor;

    Label19.Color:=ProgrammColor;
    Label19.Font.Name:=ProgrammFontName;
    Label19.Font.Size:=ProgrammFontSize-1;
    Label19.Font.Color:=ProgrammFontColor;

    lbMediaTotalDur.Color:=ProgrammColor;
    lbMediaTotalDur.Font.Name:=ProgrammFontName;
    lbMediaTotalDur.Font.Size:=ProgrammFontSize-1;
    lbMediaTotalDur.Font.Color:=ProgrammFontColor;

    lbMediaDuration.Color:=ProgrammColor;
    lbMediaDuration.Font.Name:=ProgrammFontName;
    lbMediaDuration.Font.Size:=ProgrammFontSize-1;
    lbMediaDuration.Font.Color:=ProgrammFontColor;

    lbMediaNTK.Color:=ProgrammColor;
    lbMediaNTK.Font.Name:=ProgrammFontName;
    lbMediaNTK.Font.Size:=ProgrammFontSize-1;
    lbMediaNTK.Font.Color:=ProgrammFontColor;

    lbMediaKTK.Color:=ProgrammColor;
    lbMediaKTK.Font.Name:=ProgrammFontName;
    lbMediaKTK.Font.Size:=ProgrammFontSize-1;
    lbMediaKTK.Font.Color:=ProgrammFontColor;

    lbMediaCurTK.Color:=ProgrammColor;
    lbMediaCurTk.Font.Name:=ProgrammFontName;
    lbMediaCurTK.Font.Size:=ProgrammFontSize + 4;
    lbMediaCurTK.Font.Color:=ProgrammFontColor;

    Label1.Color:=ProgrammColor;
    Label1.Font.Name:=ProgrammFontName;
    Label1.Font.Size:=ProgrammFontSize;
    Label1.Font.Color:=ProgrammFontColor;

    CheckBox2.Color:=ProgrammColor;
    CheckBox2.Font.Name:=ProgrammFontName;
    CheckBox2.Font.Size:=ProgrammFontSize;
    CheckBox2.Font.Color:=ProgrammFontColor;

    CheckBox1.Color:=ProgrammColor;
    CheckBox1.Font.Name:=ProgrammFontName;
    CheckBox1.Font.Size:=ProgrammFontSize;
    CheckBox1.Font.Color:=ProgrammFontColor;

    GridGRTemplate.FixedColor := ProgrammColor;
    GridGRTemplate.Color      := SmoothColor(GridColorRow1,16);
    GridGRTemplate.Font.Color := GridMainFontColor;
    GridGRTemplate.Font.Size  := ProgrammFontSize + 2;
    GridGRTemplate.Font.Name  := ProgrammFontName;

    CheckBox1Click(nil);

    imgTypeMovie.Canvas.Brush.Color:=ProgrammColor;
    imgTypeMovie.Canvas.Font.Name:=ProgrammFontName;
    imgTypeMovie.Canvas.Font.Size:=ProgrammFontSize;
    imgTypeMovie.Canvas.Font.Color:=ProgrammFontColor;
    imgTypeMovie.Canvas.FillRect(imgTypeMovie.Canvas.ClipRect);

    pnPrepareCTL.Color:=ProgrammColor;
    pnPrepareCTL.Font.Name:=ProgrammFontName;
    pnPrepareCTL.Font.Size:=ProgrammFontSize;
    pnPrepareCTL.Font.Color:=ProgrammFontColor;

    imgCTLPrepare1.Canvas.Brush.Color:=ProgrammColor;
    imgCTLPrepare1.Canvas.Font.Name:=ProgrammFontName;
    imgCTLPrepare1.Canvas.Font.Size:=ProgrammFontSize;
    imgCTLPrepare1.Canvas.Font.Color:=ProgrammFontColor;
    imgCTLPrepare1.Canvas.FillRect(imgCTLPrepare1.Canvas.ClipRect);

    pnPrepareSong.Color:=ProgrammColor;
    pnPrepareSong.Font.Name:=ProgrammFontName;
    pnPrepareSong.Font.Size:=ProgrammFontSize;
    pnPrepareSong.Font.Color:=ProgrammFontColor;

    lbClipName.Color:=ProgrammColor;
    lbClipName.Font.Name:=ProgrammFontName;
    lbClipName.Font.Size:=ProgrammFontSize + 2;
    lbClipName.Font.Color:=ProgrammFontColor;

    lbNomClips.Color:=ProgrammColor;
    lbNomClips.Font.Name:=ProgrammFontName;
    lbNomClips.Font.Size:=ProgrammFontSize + 6;
    lbNomClips.Font.Color:=ProgrammFontColor;

    lbSongName.Color:=ProgrammColor;
    lbSongName.Font.Name:=ProgrammFontName;
    lbSongName.Font.Size:=ProgrammFontSize+1;
    lbSongName.Font.Color:=ProgrammFontColor;

    lbSongSinger.Color:=ProgrammColor;
    lbSongSinger.Font.Name:=ProgrammFontName;
    lbSongSinger.Font.Size:=ProgrammFontSize;
    lbSongSinger.Font.Color:=ProgrammFontColor;

    imgSongLock.Canvas.Brush.Color:=ProgrammColor;
    imgSongLock.Canvas.Font.Name:=ProgrammFontName;
    imgSongLock.Canvas.Font.Size:=ProgrammFontSize;
    imgSongLock.Canvas.Font.Color:=ProgrammFontColor;
    imgSongLock.Canvas.FillRect(imgSongLock.Canvas.ClipRect);
    LoadBMPFromRes(imgSongLock.Canvas, imgSongLock.Canvas.ClipRect , 20, 20, 'LOCK');
    
    pnDevTL.Color:=ProgrammColor;
    pnDevTL.Font.Name:=ProgrammFontName;
    pnDevTL.Font.Size:=ProgrammFontSize;
    pnDevTL.Font.Color:=ProgrammFontColor;

    imgDeviceTL.Canvas.Brush.Color:=ProgrammColor;
    imgDeviceTL.Canvas.Font.Name:=ProgrammFontName;
    imgDeviceTL.Canvas.Font.Size:=ProgrammFontSize;
    imgDeviceTL.Canvas.Font.Color:=ProgrammFontColor;
    imgDeviceTL.Canvas.FillRect(imgDeviceTL.Canvas.ClipRect);

    pnMediaTL.Color:=ProgrammColor;
    pnMediaTL.Font.Name:=ProgrammFontName;
    pnMediaTL.Font.Size:=ProgrammFontSize;
    pnMediaTL.Font.Color:=ProgrammFontColor;

    imgMediaTL.Canvas.Brush.Color:=ProgrammColor;
    imgMediaTL.Canvas.Font.Name:=ProgrammFontName;
    imgMediaTL.Canvas.Font.Size:=ProgrammFontSize;
    imgMediaTL.Canvas.Font.Color:=ProgrammFontColor;
    imgMediaTL.Canvas.FillRect(imgMediaTL.Canvas.ClipRect);

    pnTextTL.Color:=ProgrammColor;
    pnTextTL.Font.Name:=ProgrammFontName;
    pnTextTL.Font.Size:=ProgrammFontSize;
    pnTextTL.Font.Color:=ProgrammFontColor;

    imgTextTL.Canvas.Brush.Color:=ProgrammColor;
    imgTextTL.Canvas.Font.Name:=ProgrammFontName;
    imgTextTL.Canvas.Font.Size:=ProgrammFontSize;
    imgTextTL.Canvas.Font.Color:=ProgrammFontColor;
    imgTextTL.Canvas.FillRect(imgTextTL.Canvas.ClipRect);
    imgTextTL.Width:=pnPrepareCTL.Width;
    imgTextTL.Picture.Bitmap.Width:=imgTextTL.Width;

    RichEdit1.Color:=ProgrammEditColor;
    RichEdit1.Font.Name :=ProgrammEditFontName;
    RichEdit1.Font.Size :=ProgrammEditFontSize;
    RichEdit1.Font.Color :=ProgrammEditFontColor;

    pnMovie.Color:=smoothColor(ProgrammColor,4);
    pnMovie.Font.Name:=ProgrammFontName;
    pnMovie.Font.Size:=ProgrammFontSize;
    pnMovie.Font.Color:=ProgrammFontColor;

    Panel4.Color:=ProgrammColor;
    Panel4.Font.Name:=ProgrammFontName;
    Panel4.Font.Size:=ProgrammFontSize;
    Panel4.Font.Color:=ProgrammFontColor;

    Panel7.Color:=ProgrammColor;
    Panel7.Font.Name:=ProgrammFontName;
    Panel7.Font.Size:=ProgrammFontSize;
    Panel7.Font.Color:=ProgrammFontColor;

    Panel8.Color:=ProgrammColor;
    Panel8.Font.Name:=ProgrammFontName;
    Panel8.Font.Size:=ProgrammFontSize;
    Panel8.Font.Color:=ProgrammFontColor;

    Panel9.Color:=ProgrammColor;
    Panel9.Font.Name:=ProgrammFontName;
    Panel9.Font.Size:=ProgrammFontSize;
    Panel9.Font.Color:=ProgrammFontColor;

    lbCTLTimeCode.Color:=ProgrammColor;
    lbCTLTimeCode.Font.Name:=ProgrammFontName;
    lbCTLTimeCode.Font.Size:=ProgrammFontSize + 4;
    lbCTLTimeCode.Font.Color:=ProgrammFontColor;

    lbTypeTC.Color:=ProgrammColor;
    lbTypeTC.Font.Name:=ProgrammFontName;
    lbTypeTC.Font.Size:=ProgrammFontSize;
    lbTypeTC.Font.Color:=ProgrammFontColor;

    LBTimeCode1.Color:=ProgrammColor;
    LBTimeCode1.Font.Name:=ProgrammFontName;
    LBTimeCode1.Font.Size:=ProgrammFontSize + 4;
    LBTimeCode1.Font.Color:=ProgrammFontColor;

    imgCTLBottomL.Canvas.Brush.Color:=ProgrammColor;
    imgCTLBottomL.Canvas.Font.Name:=ProgrammFontName;
    imgCTLBottomL.Canvas.Font.Size:=ProgrammFontSize;
    imgCTLBottomL.Canvas.Font.Color:=ProgrammFontColor;
    imgCTLBottomL.Canvas.FillRect(imgCTLBottomL.Canvas.ClipRect);

    lbusesclpidlst.Color:=ProgrammColor;
    lbusesclpidlst.Font.Name:=ProgrammFontName;
    lbusesclpidlst.Font.Size:=ProgrammFontSize;
    lbusesclpidlst.Font.Color:=ProgrammFontColor;

    imgCTLBottomR.Canvas.Brush.Color:=ProgrammColor;
    imgCTLBottomR.Canvas.Font.Name:=ProgrammFontName;
    imgCTLBottomR.Canvas.Font.Size:=ProgrammFontSize;
    imgCTLBottomR.Canvas.Font.Color:=ProgrammFontColor;
    imgCTLBottomR.Canvas.FillRect(imgCTLBottomR.Canvas.ClipRect);

    imgTimelines.Canvas.Brush.Color:=TLBackGround;
    imgTimelines.Canvas.Font.Name:=ProgrammFontName;
    imgTimelines.Canvas.Font.Size:=ProgrammFontSize;
    imgTimelines.Canvas.Font.Color:=ProgrammFontColor;
    imgTimelines.Canvas.FillRect(imgtimelines.Canvas.ClipRect);

    //imgLayer0.Canvas.Brush.Color:=TLBackGround;
    imgLayer0.Picture.Bitmap.TransparentColor:=clWhite;
    //TLParameters.lrTransperent0:=imgLayer0.Picture.Bitmap.TransparentColor;
    imgLayer0.Canvas.Font.Name:=ProgrammFontName;
    imgLayer0.Canvas.Font.Size:=ProgrammFontSize;
    imgLayer0.Canvas.Font.Color:=ProgrammFontColor;
    imgLayer0.Top:=imgTimelines.Top;
    imgLayer0.Left:=imgTimelines.Left;
    imgLayer0.Width:=Panel4.Width-imgTLNames.Width - 2*Panel4.BorderWidth;
    imgLayer0.Height:=imgTimelines.Height;
    imgLayer0.Picture.Bitmap.Width:=imgLayer0.Width;
    imgLayer0.Picture.Bitmap.Height:=imgLayer0.Height;
    imgLayer0.Canvas.FillRect(imgLayer0.Canvas.ClipRect);

    //imgLayer1.Canvas.Brush.Color:=TLBackGround;
    imgLayer1.Picture.Bitmap.TransparentColor:=clWhite;
    //TLParameters.lrTransperent1:=imgLayer1.Picture.Bitmap.TransparentColor;
    imgLayer1.Canvas.Font.Name:=ProgrammFontName;
    imgLayer1.Canvas.Font.Size:=ProgrammFontSize;
    imgLayer1.Canvas.Font.Color:=ProgrammFontColor;
    imgLayer1.Top:=imgTimelines.Top;
    imgLayer1.Left:=imgTimelines.Left;
    imgLayer1.Width:=Panel4.Width-imgTLNames.Width - 2*Panel4.BorderWidth;
    imgLayer1.Height:=imgTimelines.Height;
    imgLayer1.Picture.Bitmap.Width:=imgLayer1.Width;
    imgLayer1.Picture.Bitmap.Height:=imgLayer1.Height;
    imgLayer1.Canvas.FillRect(imgLayer1.Canvas.ClipRect);

    //imgLayer2.Canvas.Brush.Color:=TLBackGround;
    imgLayer2.Picture.Bitmap.TransparentColor:=clWhite;
    //TLParameters.lrTransperent2:=imgLayer2.Picture.Bitmap.TransparentColor;
    imgLayer2.Canvas.Font.Name:=ProgrammFontName;
    imgLayer2.Canvas.Font.Size:=Layer2FontSize;
    imgLayer2.Canvas.Font.Color:=Layer2FontColor;
    imgLayer2.Top:=imgTimelines.Top;
    imgLayer2.Left:=imgTimelines.Left;
    imgLayer2.Width:=Panel4.Width-imgTLNames.Width - 2*Panel4.BorderWidth;
    imgLayer2.Height:=imgTimelines.Height;
    imgLayer2.Picture.Bitmap.Width:=imgLayer2.Width;
    imgLayer2.Picture.Bitmap.Height:=imgLayer2.Height;
    imgLayer2.Canvas.FillRect(imgLayer2.Canvas.ClipRect);
    //imgLayer2.Canvas.Rectangle(10,10,200,150);

   // TLZone.DrawLayer2;

    imgTLNames.Canvas.Brush.Color:=TLBackGround;
    imgTLNames.Canvas.Font.Name:=TLZoneNamesFontName;
    imgTLNames.Canvas.Font.Size:=TLZoneNamesFontSize;
    imgTLNames.Canvas.Font.Color:=TLZoneNamesFontColor;
    imgTLNames.Canvas.FillRect(imgTLnames.Canvas.ClipRect);
//Устанавливаем рабочие панели
    Panel4.Align:=alBottom;
    pnTextTL.Align:=alClient;
    pnMediaTL.Align:=alClient;
    pnDevTL.Align:=alClient;
//Рисуем управляющие кнопки
    btnspanel1.SetDefaultFonts;
    btnspanel1.Draw(imgCTLPrepare1.Canvas);
    btnsctlleft.SetDefaultFonts;
    btnsctlleft.Draw(imgCTLBottomL.Canvas);
    btnsctlright.SetDefaultFonts;
    btnsctlright.Draw(imgCTLBottomR.Canvas);
    btnstexttl.SetDefaultFonts;
    btnstexttl.Draw(imgTextTL.Canvas);

    CheckBox1.Width:=Panel14.Width;
    initgrid(GridGRTemplate, RowGridListGR, Panel14.Width);
    spDeleteTemplate.Left:= Panel14.Width - 10 - spDeleteTemplate.Width;

    imgMediaTL.Picture.Bitmap.Width := Form1.imgMediaTL.Width;
    imgMediaTL.Picture.Bitmap.Height := Form1.imgMediaTL.Height;
    btnsmediatl.Top:=Form1.imgMediaTL.Height div 2 - 35;
    btnsmediatl.SetDefaultFonts;
    btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
    //TLHeights.Height;
    //ZoneNames.BackGround:=ProgrammColor;
    TLParameters.MyCursor:=pnPrepareCtl.Width-imgTLNames.Width;
    ZoneNames.SetDefaultFonts;
    ZoneNames.Draw(imgTLNames.Canvas, GridTimelines, true);
    MyMediaSwitcher.Draw(imgTypeMovie.Canvas);
    if Form1.Image3.Picture.Graphic is TJPEGImage then begin
      TJPEGImage(Form1.Image3.Picture.Graphic).DIBNeeded;
    end;
    if TLZone.TLEditor.Index=0 then TLZone.TLEditor.Index:=1;
    MyPanelAir.SetValues;
    MyPanelAir.AirDevices.Init(Form1.ImgDevices.Canvas,TLZone.TLEditor.Index);
   // MyPanelAir.AirDevices.Draw(Form1.ImgDevices.Canvas);
  end;//with
  //UpdatePanelAir;
end;

Procedure UpdatePanelPrepare;
var i, WDTH, HGHT, DLT, APos : integer;
begin
  WriteLog('MAIN', 'UInitForms.UpdatePanelPrepare');
  with form1 do begin

    Panel4.Height:=TLHeights.Height + Panel7.Height + Panel4.BorderWidth*2;
    imgTLNames.Height:=TLHeights.Height;
    imgTLNames.Picture.Bitmap.Height:=TLHeights.Height;
    imgTimelines.Height:=TLHeights.Height;
    ImgTimelines.Width:=Panel4.Width-imgTLNames.Width - 2*Panel4.BorderWidth;
    imgTimelines.Picture.Bitmap.Height:=TLHeights.Height;
    imgTimelines.Picture.Bitmap.Width:=imgTimelines.Width;
    imgTimelines.Repaint;

    TLParameters.lrTransperent0:=clWhite;//imgLayer0.Canvas.Brush.Color;
    imgLayer0.Top:=imgTimelines.Top;
    imgLayer0.Left:=imgTimelines.Left;
    imgLayer0.Width:=Panel4.Width-imgTLNames.Width - 2*Panel4.BorderWidth;
    imgLayer0.Height:=TLHeights.Height;
    imgLayer0.Picture.Bitmap.Width:=imgLayer0.Width;
    imgLayer0.Picture.Bitmap.Height:=imgLayer0.Height;

    TLParameters.lrTransperent1:=clWhite;//imgLayer1.Canvas.Brush.Color;
    imgLayer1.Top:=imgTimelines.Top;
    imgLayer1.Left:=imgTimelines.Left;
    imgLayer1.Width:=Panel4.Width-imgTLNames.Width - 2*Panel4.BorderWidth;
    imgLayer1.Height:=TLHeights.Height;
    imgLayer1.Picture.Bitmap.Width:=imgLayer1.Width;
    imgLayer1.Picture.Bitmap.Height:=imgLayer1.Height;

    TLParameters.lrTransperent2:=clWhite;imgLayer2.Canvas.Brush.Color;
    imgLayer2.Top:=imgTimelines.Top;
    imgLayer2.Left:=imgTimelines.Left;
    imgLayer2.Width:=Panel4.Width-imgTLNames.Width - 2*Panel4.BorderWidth;
    imgLayer2.Height:=TLHeights.Height;
    imgLayer2.Picture.Bitmap.Width:=imgLayer2.Width;
    imgLayer2.Picture.Bitmap.Height:=imgLayer2.Height;
    Application.ProcessMessages;
    imgCTLBottomL.Picture.Bitmap.Width:=imgCTLBottomL.Width;
    imgCTLBottomR.Picture.Bitmap.Width:=imgCTLBottomR.Width;
    Panel3.Height := PanelPrepare.Height-panel4.Height;
    imgCTLBottomL.Repaint;
//Устанавливаем размер области воспроизведения видео
    //pnMovie.Width:=pnMovie.Height div 9 * 16;
    Panel17.Width:=pnMovie.Height div 9 * 16;
    pnImageScreen.Width:=pnMovie.Width;
    pnImageScreen.Height:=pnMovie.Height;
    Image3.Width:=pnMovie.Width;
    Image3.Height:=pnMovie.Height;
    Image3.Picture.Bitmap.Width:=Image3.Width;
    Image3.Picture.Bitmap.Height:=Image3.Height;
    Image3.Canvas.Brush.Color := SmoothColor(ProgrammColor,24);
    Image3.Canvas.Brush.Style := bsSolid;
    Image3.Width:=Form1.pnImageScreen.Width;
    Image3.Height:=Form1.pnImageScreen.Height;
    Image3.Picture.Bitmap.Width:=Form1.pnImageScreen.Width;
    Image3.Picture.Bitmap.Height:=Form1.pnImageScreen.Height;
    Image3.Canvas.FillRect(Form1.Image3.Canvas.ClipRect);
    pnTypeMovie.Width:=Width -pnPrepareCTL.Width - pnMovie.Height div 9 * 16 - 2 * BorderWidth;
//Перерисовываем область выбора типа воспроизведения данных видео/шаблоны
    imgTypeMovie.Picture.Bitmap.Width:=imgTypeMovie.Width;
    imgTypeMovie.Picture.Bitmap.Height:=imgTypeMovie.Height;
    MyMediaSwitcher.Draw(imgTypeMovie.Canvas);
    ZoneNames.Draw(imgTLNames.Canvas, GridTimelines, true);
    imgTypeMovie.Repaint;
    Application.ProcessMessages;
//Перерисовать панель кнопок тайм-лайна Устройств
    imgDeviceTL.Picture.Bitmap.Width:=imgDeviceTL.Width;
    imgDeviceTL.Picture.Bitmap.Height:=imgDeviceTL.Height;
    APos:=ZoneNames.Edit.GridPosition(GridTimelines,ZoneNames.Edit.IDTimeline);
    imgDeviceTL.Repaint;
    If APos<=0 then APos:=1;
    if GridTimelines.Objects[0,APos] is TTimelineOptions then begin
      ZoneNames.Edit.IDTimeline:=(GridTimelines.Objects[0,APos] as TTimelineOptions).IDTimeline;
      TLZone.TLEditor.IDTimeline:=(GridTimelines.Objects[0,APos] as TTimelineOptions).IDTimeline;
    end;
    if GridTimelines.Objects[0,APos] is TTimelineOptions then begin //?????????????
      btnsdevicepr.BackGround:=ProgrammColor;
      InitBTNSDEVICE(imgDeviceTL.Canvas, (GridTimelines.Objects[0,APos] as TTimelineOptions), btnsdevicepr);
    end;
    btnspanel1.Draw(imgCTLPrepare1.Canvas);
    imgCTLPrepare1.Repaint;
    Application.ProcessMessages;
//Перерисовать панель кнопок Медиа
   // imgMediaTL.Picture.Bitmap.Width:=imgMediaTL.Width;
   // imgMediaTL.Picture.Bitmap.Height:=imgMediaTL.Height;
   // btnsmediatl.Draw(imgMediaTL.Canvas);
    imgMediaTL.Picture.Bitmap.Width := Form1.imgMediaTL.Width;
    imgMediaTL.Picture.Bitmap.Height := Form1.imgMediaTL.Height;
    btnsmediatl.Top:=Form1.imgMediaTL.Height div 2 - 35;
    if btnsmediatl.Top < 5 then btnsmediatl.Top:=5;
    btnsmediatl.HeightRow:=35;
    btnsmediatl.Draw(Form1.imgMediaTL.Canvas);
    imgMediaTL.Repaint;

    CheckBox1.Font.Color:=ProgrammFontColor;
    CheckBox2.Font.Color:=ProgrammFontColor;
//Перерисовать панель кнопок Tекст

    imgTextTL.Picture.Bitmap.Width:=imgTextTL.Width;
    imgTextTL.Picture.Bitmap.Height:=imgTextTL.Height;
    imgTextTL.Repaint;
    pnPrepareSong.Repaint;
    imgTLnames.Repaint;
    pnMovie.Repaint;
    Application.ProcessMessages;

    CheckBox1.Width:=Panel14.Width;
    GridGRTemplate.Width := Panel14.Width;

    WDTH:=0;
    if GridGRTemplate.ColCount>=2 then begin
      For i:=0 to GridGRTemplate.ColCount-2 do WDTH:=WDTH + GridGRTemplate.ColWidths[i];
      if GridGRTemplate.RowCount > 1 then begin
        for i:=0 to GridGRTemplate.RowCount-1
          do GridGRTemplate.ColWidths[GridGRTemplate.ColCount-1] := GridGRTemplate.Width - WDTH;
      end;
    end;

    HGHT := Panel14.Height - Panel15.Height;
    if GridGRTemplate.Objects[0,0] is TGridRows then begin
      dlt := HGHT mod (GridGRTemplate.Objects[0,0] as TGridRows).HeightRow;
      Panel16.Height:=dlt;
      GridGRTemplate.Height:=HGHT-DLT;
    end;

    if Panel16.Height < Canvas.TextHeight(Label1.Caption)
      then Label1.Visible:=false else Label1.Visible:=true;

    Panel16.Repaint;
    Panel19.Repaint;
    if UpdateGridTemplate then begin
      initgrid(GridGRTemplate, RowGridListGR, Panel14.Width);
      LoadGridFromFile(PathTemp + '\ImageTemplates.lst', GridGRTemplate);
      GridGRTemplate.Repaint;
      application.ProcessMessages;
      GridImageReload(GridGRTemplate);
    end;
    GridGRTemplate.Repaint;
    UpdateGridTemplate:=false;
    FWait.Close;

    if Form1.Image3.Picture.Graphic is TJPEGImage then begin
      TJPEGImage(Form1.Image3.Picture.Graphic).DIBNeeded;
    end;

    lbClipName.Width:=pnPrepareCTL.Width-lbClipName.Left-10;
    lbSongName.Width:=pnPrepareCTL.Width-lbSongName.Left-10;
    lbSongSinger.Width:=pnPrepareCTL.Width-lbSongSinger.Left-10;
    //if FileExists(lbPlayerFile.Caption)  then VLCPlayerWindow(pnMovie);
  end;

  UpdatePanelAir;
  FWait.Close;
  //Application.ProcessMessages;
end;

procedure InitPanelProject;
begin
  WriteLog('MAIN', 'UInitForms.InitPanelProject');
  with form1 do begin
//Убираем мерцание при перерисовке элементов панели проектов
    PanelProject.DoubleBuffered:=true;

    Panel2.DoubleBuffered:=true;
    Panel23.DoubleBuffered:=true;
    Panel24.DoubleBuffered:=true;
    Panel2.Width := PanelControlBtns.Width-1;
    GridTimelines.DoubleBuffered:=true;
    imgBlockProjects.Parent.DoubleBuffered:=true;
    imgButtonsControlProj.Parent.DoubleBuffered:=true;
    imgButtonsProject.Parent.DoubleBuffered:=true;
    Label3.Parent.DoubleBuffered:=true;
    Label4.Parent.DoubleBuffered:=true;
    Label5.Parent.DoubleBuffered:=true;
    lbDateEnd.Parent.DoubleBuffered:=true;
    lbDateStart.Parent.DoubleBuffered:=true;
    lbProjectName.Parent.DoubleBuffered:=true;
    lbpComment.Parent.DoubleBuffered:=true;

    Panel6.DoubleBuffered:=true;
    Panel10.DoubleBuffered:=true;
    GridLists.DoubleBuffered:=true;

    Panel11.DoubleBuffered:=true;
    //Bevel4.Parent.DoubleBuffered:=true;
    //Bevel5.Parent.DoubleBuffered:=true;
    //sbListGraphTemplates.Parent.DoubleBuffered:=true;
    //sbListPlayLists.Parent.DoubleBuffered:=true;

    Panel5.DoubleBuffered:=true;
    GridProjects.DoubleBuffered:=true;

//Устанавливаем параметры элементов панели по умолчанию

    PanelProject.Color      := ProgrammColor;
    PanelProject.Font.Color := ProgrammFontColor;
    PanelProject.Font.Size  := ProgrammFontSize;
    PanelProject.Font.Name  := ProgrammFontName;

    Panel2.Color      := ProgrammColor;
    Panel2.Font.Color := ProgrammFontColor;
    Panel2.Font.Size  := ProgrammFontSize;
    Panel2.Font.Name  := ProgrammFontName;

    Panel23.Color      := ProgrammColor;
    Panel23.Font.Color := ProgrammFontColor;
    Panel23.Font.Size  := ProgrammFontSize;
    Panel23.Font.Name  := ProgrammFontName;

    Panel24.Color      := ProgrammColor;
    Panel24.Font.Color := ProgrammFontColor;
    Panel24.Font.Size  := ProgrammFontSize;
    Panel24.Font.Name  := ProgrammFontName;

    GridTimeLines.Color      := ProgrammColor;
    GridTimeLines.FixedColor := ProgrammColor;
    GridTimeLines.Font.Color := ProgrammFontColor;
    GridTimeLines.Font.Size  := ProgrammFontSize;
    GridTimeLines.Font.Name  := ProgrammFontName;

    imgBlockProjects.Canvas.Brush.Color := ProgrammColor;
    imgBlockProjects.Canvas.Pen.Color   := ProgrammFontColor;
    imgBlockProjects.Canvas.Font.Color  := ProgrammFontColor;
    imgBlockProjects.Canvas.Font.Size   := ProgrammFontSize;
    imgBlockProjects.Canvas.Font.Name   := ProgrammFontName;

    imgButtonsControlProj.Canvas.Brush.Color := ProgrammColor;
    imgButtonsControlProj.Canvas.Pen.Color   := ProgrammFontColor;
    imgButtonsControlProj.Canvas.Font.Color  := ProgrammFontColor;
    imgButtonsControlProj.Canvas.Font.Size   := ProgrammFontSize;
    imgButtonsControlProj.Canvas.Font.Name   := ProgrammFontName;

    imgButtonsProject.Canvas.Brush.Color := ProgrammColor;
    imgButtonsProject.Canvas.Pen.Color   := ProgrammFontColor;
    imgButtonsProject.Canvas.Font.Color  := ProgrammFontColor;
    imgButtonsProject.Canvas.Font.Size   := ProgrammFontSize;
    imgButtonsProject.Canvas.Font.Name   := ProgrammFontName;

    Label3.Color      := ProgrammColor;
    Label3.Font.Color := ProgrammFontColor;
    Label3.Font.Size  := ProgrammFontSize;
    Label3.Font.Name  := ProgrammFontName;

    Label4.Color      := ProgrammColor;
    Label4.Font.Color := ProgrammFontColor;
    Label4.Font.Size  := ProgrammFontSize;
    Label4.Font.Name  := ProgrammFontName;

    Label5.Color      := ProgrammColor;
    Label5.Font.Color := ProgrammFontColor;
    Label5.Font.Size  := ProgrammFontSize;
    Label5.Font.Name  := ProgrammFontName;

    Label15.Color      := ProgrammColor;
    Label15.Font.Color := ProgrammFontColor;
    Label15.Font.Size  := ProgrammFontSize+2;
    Label15.Font.Name  := ProgrammFontName;

    lbDateEnd.Color      := ProgrammColor;
    lbDateEnd.Font.Color := ProgrammFontColor;
    lbDateEnd.Font.Size  := ProgrammFontSize;
    lbDateEnd.Font.Name  := ProgrammFontName;

    lbDateStart.Color      := ProgrammColor;
    lbDateStart.Font.Color := ProgrammFontColor;
    lbDateStart.Font.Size  := ProgrammFontSize;
    lbDateStart.Font.Name  := ProgrammFontName;

    lbEditor.Color      := ProgrammColor;
    lbEditor.Font.Color := ProgrammFontColor;
    lbEditor.Font.Size  := ProgrammFontSize;
    lbEditor.Font.Name  := ProgrammFontName;
    lbEditor.Caption    := CurrentUser;

    lbProjectName.Color      := ProgrammColor;
    lbProjectName.Font.Color := ProgrammFontColor;
    lbProjectName.Font.Size  := ProgrammFontSize + 2;
    lbProjectName.Font.Name  := ProgrammFontName;
    lbProjectName.Font.Style := lbProjectName.Font.Style + [fsBold];

    lbpComment.Color      := ProgrammColor;
    lbpComment.Font.Color := SmoothColor(ProgrammColor,90);
    lbpComment.Font.Size  := ProgrammFontSize;
    lbpComment.Font.Name  := ProgrammFontName;

    Panel6.Color      := ProgrammColor;
    Panel6.Font.Color := ProgrammFontColor;
    Panel6.Font.Size  := ProgrammFontSize;
    Panel6.Font.Name  := ProgrammFontName;

    Panel10.Color      := ProgrammColor;
    Panel10.Font.Color := ProgrammFontColor;
    Panel10.Font.Size  := ProgrammFontSize;
    Panel10.Font.Name  := ProgrammFontName;

    GridLists.FixedColor := ProgrammColor;
    GridLists.Color      := GridBackGround;//SmoothColor(GridColorRow1,16);
    GridLists.Font.Color := GridMainFontColor;
    GridLists.Font.Size  := ProgrammFontSize + 2;
    GridLists.Font.Name  := ProgrammFontName;

    Panel11.Color      := ProgrammColor;
    Panel11.Font.Color := ProgrammFontColor;
    Panel11.Font.Size  := ProgrammFontSize;
    Panel11.Font.Name  := ProgrammFontName;

    Panel5.Color      := ProgrammColor;
    Panel5.Font.Color := ProgrammFontColor;
    Panel5.Font.Size  := ProgrammFontSize;
    Panel5.Font.Name  := ProgrammFontName;

    GridProjects.FixedColor := ProgrammColor;
    GridProjects.Color      := GridBackGround;//SmoothColor(GridColorRow1,16);
    GridProjects.Font.Color := GridMainFontColor;
    GridProjects.Font.Size  := ProgrammFontSize;
    GridProjects.Font.Name  := ProgrammFontName;

    Splitter1.Color := ProgrammColor;


    initgrid(gridprojects, RowGridProject,Width-Panel2.Width);

    initgrid(gridlists, RowGridListPL,Width-Panel2.Width);

    pnlprojcntl.SetDefaultFonts;
    pnlprojcntl.Draw(imgButtonsControlProj.Canvas);
    pnlprojects.SetDefaultFonts;
    pnlprojects.Draw(imgButtonsProject.Canvas);

    ImgButtonsPL.Width:=Width-Panel2.Width;
    //ImgButtonsPL.Height:=50;//Width-Panel2.Width;
    ImgButtonsPL.Picture.Bitmap.Width:=ImgButtonsPL.Width;
    ImgButtonsPL.Picture.Bitmap.Height:=ImgButtonsPL.Height;
    pnlplaylsts.Left:=(Width-Panel2.Width-640) div 2;
    pnlplaylsts.Right:=pnlplaylsts.Left;

    pnlplaylsts.SetDefaultFonts;
    pnlplaylsts.Draw(ImgButtonsPL.Canvas);

  end;

end;

procedure InitPanelControl;
begin
  WriteLog('MAIN', 'UInitForms.InitPanelControl');
  with form1 do begin
    PanelControl.DoubleBuffered:=true;
    PanelControlBtns.DoubleBuffered:=true;
    Bevel2.Parent.DoubleBuffered:=true;
    Bevel3.Parent.DoubleBuffered:=true;
    sbClips.Parent.DoubleBuffered:=true;
    sbPlayList.Parent.DoubleBuffered:=true;
    sbProject.Parent.DoubleBuffered:=true;
    PanelControlClip.DoubleBuffered:=true;
    Bevel1.Parent.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;
    sbPredClip.Parent.DoubleBuffered:=true;
    sbNextClip.Parent.DoubleBuffered:=true;
    PanelControlMode.DoubleBuffered:=true;
    lbMode.Parent.DoubleBuffered:=true;

    PanelControl.Color      := ProgrammColor;
    PanelControl.Font.Color := ProgrammFontColor;
    PanelControl.Font.Size  := ProgrammFontSize;
    PanelControl.Font.Name  := ProgrammFontName;

    PanelControlBtns.Color      := ProgrammColor;
    PanelControlBtns.Font.Color := ProgrammFontColor;
    PanelControlBtns.Font.Size  := ProgrammFontSize;
    PanelControlBtns.Font.Name  := ProgrammFontName;

    sbClips.Font.Color := ProgrammFontColor;
    sbClips.Font.Size  := ProgrammFontSize + 2;
    sbClips.Font.Name  := ProgrammFontName;

    sbProject.Font.Color := ProgrammFontColor;
    sbProject.Font.Size  := ProgrammFontSize + 2;
    sbProject.Font.Name  := ProgrammFontName;

    sbPlayList.Font.Color := ProgrammFontColor;
    sbPlayList.Font.Size  := ProgrammFontSize + 2;
    sbPlayList.Font.Name  := ProgrammFontName;

    PanelControlClip.Color      := ProgrammColor;
    PanelControlClip.Font.Color := ProgrammFontColor;
    PanelControlClip.Font.Size  := ProgrammFontSize;
    PanelControlClip.Font.Name  := ProgrammFontName;

    Label2.Color      := ProgrammColor;
    Label2.Font.Color := ProgrammFontColor;
    Label2.Font.Size  := ProgrammFontSize + 2;
    Label2.Font.Name  := ProgrammFontName;

    sbPredClip.Font.Color := ProgrammFontColor;
    sbPredClip.Font.Size  := ProgrammFontSize + 2;
    sbPredClip.Font.Name  := ProgrammFontName;

    sbNextClip.Font.Color := ProgrammFontColor;
    sbNextClip.Font.Size  := ProgrammFontSize + 2;
    sbNextClip.Font.Name  := ProgrammFontName;

    PanelControlMode.Color      := ProgrammColor;
    PanelControlMode.Font.Color := ProgrammFontColor;
    PanelControlMode.Font.Size  := ProgrammFontSize;
    PanelControlMode.Font.Name  := ProgrammFontName;

    lbMode.Color      := ProgrammColor;
    lbMode.Font.Color := ProgrammFontColor;
    lbMode.Font.Size  := ProgrammFontSize + 4;
    lbMode.Font.Name  := ProgrammFontName;

    SetMainGridPanel(projects);
    Form1.ActiveControl:=PanelProject;
  end;
end;

procedure InitMainForm;
var r : trect;
begin
  WriteLog('MAIN', 'UInitForms.InitMainForm');
  with form1 do begin
    Width:=Screen.Width;
    Height:=Screen.Height;
    Left:=BorderWidth;
    Top:=BorderWidth;
    //formstyle := fsStayOnTop;

    PanelProject.Align:=alClient;
    PanelPlayList.Align:=alClient;
    PanelClips.Align:=alClient;
    PanelPrepare.Align:=alClient;

    DoubleBuffered:=true;

    Color      := ProgrammColor;
    Font.Color := ProgrammFontColor;
    Font.Size  := ProgrammFontSize;
    Font.Name  := ProgrammFontName;

    GridColorRow1 := SmoothColor(GridBackGround,72);
    GridColorRow2 := SmoothColor(GridBackGround,40);//$201E1E;//$bbeebb;
    GridColorSelection := GridBackGround;//$212020;/
  end;
end;

Procedure InitPanelClips;
begin
  WriteLog('MAIN', 'UInitForms.InitPanelClips');
  with Form1 do begin
    PanelClips.Width:=Width - BorderWidth * 2;
    PanelClips.DoubleBuffered:=true;
    Panel12.DoubleBuffered:=true;
    Panel12.Width:=PanelControlBtns.Width-1;
    lbClip.Parent.DoubleBuffered:=true;
    label10.Parent.DoubleBuffered:=true;
    label11.Parent.DoubleBuffered:=true;
    label12.Parent.DoubleBuffered:=true;
    label6.Parent.DoubleBuffered:=true;
    label9.Parent.DoubleBuffered:=true;
    lbClipSong.Parent.DoubleBuffered:=true;
    lbClipDur.Parent.DoubleBuffered:=true;
    //lbClipDur.Width:=Panel12.Width-lbClipDur.Left-10;
    lbClipNTK.Parent.DoubleBuffered:=true;
    //lbClipNTK.Width:=Panel12.Width-lbClipNTK.Left-10;
    lbClipSinger.Parent.DoubleBuffered:=true;
    //lbClipSinger.Width:=Panel12.Width-lbClipSinger.Left-10;
    lbClipTotalDur.Parent.DoubleBuffered:=true;
    //lbClipTotalDur.Width:=Panel12.Width-lbClipTotalDur.Left-10;
    lbClipType.Parent.DoubleBuffered:=true;
    //lbClipType.Width:=Panel12.Width-lbClipType.Left-10;
    lbClipComment.Parent.DoubleBuffered:=true;
    //lbClipComment.Width:=Panel12.Width-lbClipComment.Left-10;
    lbClipPath.Parent.DoubleBuffered:=true;
    //lbClipPath.Width:=Panel12.Width-lbClipPath.Left-10;
    lbClipFullDur.Parent.DoubleBuffered:=true;
    //lbClipFullDur.Left := lbClipType.Left;
    //lbClipFullDur.Width:=Panel12.Width-lbClipFullDur.Left-10;
    lbClipActPL.Width:=Panel12.Width-lbClipActPL.Left-10;
    imgpnlbtnsclips.Parent.DoubleBuffered:=true;
    GridClips.DoubleBuffered:=true;

    PanelClips.Color      := ProgrammColor;
    PanelClips.Font.Color := ProgrammFontColor;
    PanelClips.Font.Size  := ProgrammFontSize;
    PanelClips.Font.Name  := ProgrammFontName;

    Panel12.Color      := ProgrammColor;
    Panel12.Font.Color := ProgrammFontColor;
    Panel12.Font.Size  := ProgrammFontSize;
    Panel12.Font.Name  := ProgrammFontName;

    Panel26.Color      := ProgrammColor;
    Panel26.Font.Color := ProgrammFontColor;
    Panel26.Font.Size  := ProgrammFontSize;
    Panel26.Font.Name  := ProgrammFontName;

    lbClip.Color      := ProgrammColor;
    lbClip.Font.Color := ProgrammFontColor;
    lbClip.Font.Size  := ProgrammFontSize;
    lbClip.Font.Name  := ProgrammFontName;

    lbClipSong.Color      := ProgrammColor;
    lbClipSong.Font.Color := ProgrammFontColor;
    lbClipSong.Font.Size  := ProgrammFontSize;
    lbClipSong.Font.Name  := ProgrammFontName;

    label10.Color      := ProgrammColor;
    label10.Font.Color := ProgrammFontColor;
    label10.Font.Size  := ProgrammFontSize;
    label10.Font.Name  := ProgrammFontName;

    label11.Color      := ProgrammColor;
    label11.Font.Color := ProgrammFontColor;
    label11.Font.Size  := ProgrammFontSize;
    label11.Font.Name  := ProgrammFontName;

    label12.Color      := ProgrammColor;
    label12.Font.Color := ProgrammFontColor;
    label12.Font.Size  := ProgrammFontSize;
    label12.Font.Name  := ProgrammFontName;

    label6.Color      := ProgrammColor;
    label6.Font.Color := ProgrammFontColor;
    label6.Font.Size  := ProgrammFontSize;
    label6.Font.Name  := ProgrammFontName;

    label9.Color      := ProgrammColor;
    label9.Font.Color := ProgrammFontColor;
    label9.Font.Size  := ProgrammFontSize;
    label9.Font.Name  := ProgrammFontName;

    lbClipComment.Color      := ProgrammColor;
    lbClipComment.Font.Color := SmoothColor(ProgrammColor,96);
    lbClipComment.Font.Size  := ProgrammFontSize;
    lbClipComment.Font.Name  := ProgrammFontName;

    lbClipDur.Color      := ProgrammColor;
    lbClipDur.Font.Color := ProgrammFontColor;
    lbClipDur.Font.Size  := ProgrammFontSize;
    lbClipDur.Font.Name  := ProgrammFontName;

    lbClipNTK.Color      := ProgrammColor;
    lbClipNTK.Font.Color := ProgrammFontColor;
    lbClipNTK.Font.Size  := ProgrammFontSize;
    lbClipNTK.Font.Name  := ProgrammFontName;

    lbClipPath.Color      := ProgrammColor;
    lbClipPath.Font.Color := SmoothColor(ProgrammColor,96);
    lbClipPath.Font.Size  := ProgrammFontSize;
    lbClipPath.Font.Name  := ProgrammFontName;

    lbClipSinger.Color      := ProgrammColor;
    lbClipSinger.Font.Color := ProgrammFontColor;
    lbClipSinger.Font.Size  := ProgrammFontSize;
    lbClipSinger.Font.Name  := ProgrammFontName;

    lbClipTotalDur.Color      := ProgrammColor;
    lbClipTotalDur.Font.Color := ProgrammFontColor;
    lbClipTotalDur.Font.Size  := ProgrammFontSize;
    lbClipTotalDur.Font.Name  := ProgrammFontName;

    lbClipActPL.Color      := ProgrammColor;
    lbClipActPL.Font.Color := ProgrammFontColor;
    lbClipActPL.Font.Size  := ProgrammFontSize;
    lbClipActPL.Font.Name  := ProgrammFontName;

    //lbClipStopUse.Color      := ProgrammColor;
    //lbClipStopUse.Font.Color := ProgrammFontColor;
    //lbClipStopUse.Font.Size  := ProgrammFontSize;
    //lbClipStopUse.Font.Name  := ProgrammFontName;

    imgpnlbtnsclips.Canvas.Brush.Color := ProgrammColor;
    imgpnlbtnsclips.Canvas.Pen.Color   := ProgrammFontColor;
    imgpnlbtnsclips.Canvas.Font.Color  := ProgrammFontColor;
    imgpnlbtnsclips.Canvas.Font.Size   := ProgrammFontSize;
    imgpnlbtnsclips.Canvas.Font.Name   := ProgrammFontName;

    GridClips.FixedColor := ProgrammColor;
    GridClips.Color      := GridBackGround;
    GridClips.Font.Color := GridMainFontColor;
    GridClips.Font.Size  := ProgrammFontSize;
    GridClips.Font.Name  := ProgrammFontName;

    imgpnlbtnsclips.Width:=Panel12.Width;
    imgpnlbtnsclips.Picture.Bitmap.Width:=imgpnlbtnsclips.Width;
    imgpnlbtnsclips.Picture.Bitmap.Height:=imgpnlbtnsclips.Height;

    initgrid(gridclips, RowGridClips,PanelClips.Width-Panel12.Width);

    (gridclips.Objects[0,0] as TGridRows).MyCells[0].Used:=false;
    (gridclips.Objects[0,0] as TGridRows).MyCells[1].Used:=false;
    (gridclips.Objects[0,0] as TGridRows).MyCells[2].Used:=false;

    pnlbtnsclips.SetDefaultFonts;
    pnlbtnsclips.Draw(imgpnlbtnsclips.Canvas);
    //lbPLName.Caption:='';
  end;
end;

Procedure InitPanelPlayList;
begin
  WriteLog('MAIN', 'UInitForms.InitPanelPlayList');
  with Form1 do begin
    PanelPlayList.DoubleBuffered:=true;
    PanelPlayList.Width:=Width- BorderWidth * 2;
    Panel1.DoubleBuffered:=true;
    Panel1.Width:=PanelControlBtns.Width-1;
    Panel25.DoubleBuffered := true;
    //cbPlayLists.DoubleBuffered := true;
    ListBox1.DoubleBuffered := true;
    //label14.Parent.DoubleBuffered:=true;
    //label15.Parent.DoubleBuffered:=true;
    lbPlayList1.Parent.DoubleBuffered:=true;
    lbPLComment.Parent.DoubleBuffered:=true;
    lbPLComment.Width:=Panel1.Width-20;
    //lbPLCreate.Parent.DoubleBuffered:=true;
    //lbPLCreate.Width:=Panel1.Width-lbPLCreate.Left-10;
    //lbPLEnd.Parent.DoubleBuffered:=true;
    //lbPLEnd.Width:=Panel1.Width-lbPLEnd.Left-10;
    imgpnlbtnspl.Parent.DoubleBuffered:=true;
    GridActPlayList.DoubleBuffered:=true;
    Panel27.DoubleBuffered:=true;
    //cbPlayList.DoubleBuffered:=true;

    PanelPlayList.Color      := ProgrammColor;
    PanelPlayList.Font.Color := ProgrammFontColor;
    PanelPlayList.Font.Size  := ProgrammFontSize;
    PanelPlayList.Font.Name  := ProgrammFontName;

    Panel1.Color      := ProgrammColor;
    Panel1.Font.Color := ProgrammFontColor;
    Panel1.Font.Size  := ProgrammFontSize;
    Panel1.Font.Name  := ProgrammFontName;

    Panel25.Color      := ProgrammColor;
    Panel25.Font.Color := ProgrammFontColor;
    Panel25.Font.Size  := ProgrammFontSize;
    Panel25.Font.Name  := ProgrammFontName;

    Panel27.Color      := ProgrammColor;
    Panel27.Font.Color := ProgrammFontColor;
    Panel27.Font.Size  := ProgrammFontSize;
    Panel27.Font.Name  := ProgrammFontName;

    ListBox1.Color      := ProgrammColor;
    ListBox1.Font.Color := ProgrammFontColor;
    ListBox1.Font.Size  := ProgrammFontSize+3;
    ListBox1.Font.Name  := ProgrammFontName;

    lbCurrActPL.Color      := ProgrammColor;
    lbCurrActPL.Font.Color := ProgrammFontColor;
    lbCurrActPL.Font.Size  := ProgrammFontSize+4;
    lbCurrActPL.Font.Name  := ProgrammFontName;

    //label15.Color      := ProgrammColor;
    //label15.Font.Color := ProgrammFontColor;
    //label15.Font.Size  := ProgrammFontSize;
    //label15.Font.Name  := ProgrammFontName;

    lbPlayList1.Color      := ProgrammColor;
    lbPlayList1.Font.Color := ProgrammFontColor;
    lbPlayList1.Font.Size  := ProgrammFontSize;
    lbPlayList1.Font.Name  := ProgrammFontName;

    //cbPlayList.Color      := ProgrammColor;
    //cbPlayList.Font.Color := ProgrammFontColor;
    //cbPlayList.Font.Size  := ProgrammFontSize + 4;
    //cbPlayList.Font.Name  := ProgrammFontName;

    lbPLComment.Color      := ProgrammColor;
    lbPLComment.Font.Color := SmoothColor(ProgrammColor,96);
    lbPLComment.Font.Size  := ProgrammFontSize;
    lbPLComment.Font.Name  := ProgrammFontName;

    lbPLClpComment.Color      := ProgrammColor;
    lbPLClpComment.Font.Color := SmoothColor(ProgrammColor,96);
    lbPLClpComment.Font.Size  := ProgrammFontSize;
    lbPLClpComment.Font.Name  := ProgrammFontName;

    lbplfile.Color      := ProgrammColor;
    lbplfile.Font.Color := SmoothColor(ProgrammColor,96);
    lbplfile.Font.Size  := ProgrammFontSize;
    lbplfile.Font.Name  := ProgrammFontName;

    //lbPLEnd.Color      := ProgrammColor;
    //lbPLEnd.Font.Color := ProgrammFontColor;
    //lbPLEnd.Font.Size  := ProgrammFontSize;
    //lbPLEnd.Font.Name  := ProgrammFontName;

    //lbPLCreate.Color      := ProgrammColor;
    //lbPLCreate.Font.Color := ProgrammFontColor;
    //lbPLCreate.Font.Size  := ProgrammFontSize;
    //lbPLCreate.Font.Name  := ProgrammFontName;

    imgpnlbtnspl.Canvas.Brush.Color := ProgrammColor;
    imgpnlbtnspl.Canvas.Pen.Color   := ProgrammFontColor;
    imgpnlbtnspl.Canvas.Font.Color  := ProgrammFontColor;
    imgpnlbtnspl.Canvas.Font.Size   := ProgrammFontSize;
    imgpnlbtnspl.Canvas.Font.Name   := ProgrammFontName;

    GridActPlayList.FixedColor := ProgrammColor;
    GridActPlayList.Color      := GridBackGround;
    GridActPlayList.Font.Color := GridMainFontColor;
    GridActPlayList.Font.Size  := ProgrammFontSize;
    GridActPlayList.Font.Name  := ProgrammFontName;

    imgpnlbtnspl.Width:=Panel1.Width;
    imgpnlbtnspl.Picture.Bitmap.Width:=imgpnlbtnspl.Width;
    imgpnlbtnspl.Picture.Bitmap.Height:=imgpnlbtnspl.Height;

    initgrid(gridactplaylist, RowGridClips,PanelPlayList.Width-Panel1.Width);

    (gridactplaylist.Objects[0,0] as TGridRows).MyCells[0].Used:=false;
    (gridactplaylist.Objects[0,0] as TGridRows).MyCells[1].Used:=false;
    (gridactplaylist.Objects[0,0] as TGridRows).MyCells[2].Used:=false;
    (gridactplaylist.Objects[0,0] as TGridRows).MyCells[3].Title:='Активный плей-лист';

    lbplclip.Left:=10;
    lbplclip.Width := Panel1.Width - 20;
    lbplsong.Left:=10;
    lbplsong.Width := Panel1.Width - 20;
    lbplcomment.Left:=10;
    lbplcomment.Width := Panel1.Width - 20;
    lbplsinger.Left:=10;
    lbplsinger.Width := Panel1.Width - 20;
    lbplaylist1.Left:=10;
    lbplaylist1.Width := Panel1.Width - 20;
    lbplsinger.Left:=10;
    lbplsinger.Width := Panel1.Width - 20;
    //cbplaylists.Left:=10;
    //cbplaylists.Width := Panel1.Width - 20;

    pnlbtnspl.SetDefaultFonts;
    pnlbtnspl.Draw(imgpnlbtnspl.Canvas);
  end;
end;

procedure InitNewProject;
begin
  WriteLog('MAIN', 'UInitForms.InitNewProject');
  with FNewProject do begin
    Color := FormsColor;
    Font.Color := FormsFontColor;
    Font.Size := FormsFontSize;
    Font.Name := FormsFontName;

    Label1.Color := FormsColor;
    Label1.Font.Color := FormsFontColor;
    Label1.Font.Size := FormsFontSize;
    Label1.Font.Name := FormsFontName;

    Label2.Color := FormsColor;
    Label2.Font.Color := FormsFontColor;
    Label2.Font.Size := FormsFontSize;
    Label2.Font.Name := FormsFontName;

    Label3.Color := FormsColor;
    Label3.Font.Color := FormsFontColor;
    Label3.Font.Size := FormsFontSize;
    Label3.Font.Name := FormsFontName;

    DateTimePicker1.Color := FormsEditColor;
    DateTimePicker1.Font.Color := FormsEditFontColor;
    DateTimePicker1.Font.Size := FormsEditFontSize;
    DateTimePicker1.Font.Name := FormsEditFontName;

    Edit1.Color := FormsEditColor;
    Edit1.Font.Color := FormsEditFontColor;
    Edit1.Font.Size := FormsEditFontSize;
    Edit1.Font.Name := FormsEditFontName;

    Memo1.Color := FormsEditColor;
    Memo1.Font.Color := FormsEditFontColor;
    Memo1.Font.Size := FormsEditFontSize;
    Memo1.Font.Name := FormsEditFontName;

    Speedbutton1.Font.Color := FormsFontColor;
    Speedbutton1.Font.Size  := FormsFontSize + 1;
    Speedbutton1.Font.Name  := FormsFontName;

    Speedbutton2.Font.Color := FormsFontColor;
    Speedbutton2.Font.Size  := FormsFontSize + 1;
    Speedbutton2.Font.Name  := FormsFontName;

  end;
end;

procedure InitPlaylists;
begin
  WriteLog('MAIN', 'UInitForms.InitPlaylists');
  with FPlaylists do begin

    Color := FormsColor;
    Font.Color := FormsFontColor;
    Font.Size := FormsFontSize;
    Font.Name := FormsFontName;

    panel1.Color := FormsColor;
    panel1.Font.Color := FormsFontColor;
    panel1.Font.Size := FormsFontSize;
    panel1.Font.Name := FormsFontName;

    panel2.Color := FormsColor;
    panel2.Font.Color := FormsFontColor;
    panel2.Font.Size := FormsFontSize;
    panel2.Font.Name := FormsFontName;

    panel3.Color := FormsColor;
    panel3.Font.Color := FormsFontColor;
    panel3.Font.Size := FormsFontSize;
    panel3.Font.Name := FormsFontName;

    panel4.Color := FormsColor;
    panel4.Font.Color := FormsFontColor;
    panel4.Font.Size := FormsFontSize;
    panel4.Font.Name := FormsFontName;

    panel5.Color := FormsColor;
    panel5.Font.Color := FormsFontColor;
    panel5.Font.Size := FormsFontSize;
    panel5.Font.Name := FormsFontName;

    Label1.Color := FormsColor;
    Label1.Font.Color := FormsFontColor;
    Label1.Font.Size := FormsFontSize+2;
    Label1.Font.Name := FormsFontName;

    Label2.Color := FormsColor;
    Label2.Font.Color := FormsFontColor;
    Label2.Font.Size := FormsFontSize+2;
    Label2.Font.Name := FormsFontName;

    Label3.Color := FormsColor;
    Label3.Font.Color := FormsFontColor;
    Label3.Font.Size := FormsFontSize+1;
    Label3.Font.Name := FormsFontName;

    Label4.Color := FormsColor;
    Label4.Font.Color := FormsFontColor;
    Label4.Font.Size := FormsFontSize+2;
    Label4.Font.Name := FormsFontName;

//    dtpEndDate.Color := FormsEditColor;
//    dtpEndDate.Font.Color := FormsEditFontColor;
//    dtpEndDate.Font.Size := FormsEditFontSize;
//    dtpEndDate.Font.Name := FormsEditFontName;

    edNamePL.Color := FormsColor;
    edNamePL.Font.Color := FormsFontColor;
    edNamePL.Font.Size := FormsFontSize+2;
    edNamePL.Font.Name := FormsFontName;

    ListBox1.Color := FormsColor;
    ListBox1.Font.Color := FormsFontColor;
    ListBox1.Font.Size := FormsFontSize+1;
    ListBox1.Font.Name := FormsFontName;
    ListBox1.ItemHeight := 30;

    ListBox2.Color := FormsColor;
    ListBox2.Font.Color := FormsFontColor;
    ListBox2.Font.Size := FormsFontSize+1;
    ListBox2.Font.Name := FormsFontName;
    ListBox2.ItemHeight := 30;

    mmCommentPL.Color := FormsColor;
    mmCommentPL.Font.Color := FormsFontColor;
    mmCommentPL.Font.Size := FormsFontSize;
    mmCommentPL.Font.Name := FormsFontName;

    Speedbutton1.Font.Color := FormsFontColor;
    Speedbutton1.Font.Size  := FormsFontSize + 1;
    Speedbutton1.Font.Name  := FormsFontName;

    Speedbutton2.Font.Color := FormsFontColor;
    Speedbutton2.Font.Size  := FormsFontSize + 1;
    Speedbutton2.Font.Name  := FormsFontName;

  end;
end;

procedure InitTextTemplates;
begin
  WriteLog('MAIN', 'UInitForms.InitTextTemplates');
  with FTextTemplate do begin
    Color := FormsColor;
    Font.Color := FormsFontColor;
    Font.Size := FormsFontSize;
    Font.Name := FormsFontName;

    panel1.Color := FormsColor;
    panel1.Font.Color := FormsFontColor;
    panel1.Font.Size := FormsFontSize;
    panel1.Font.Name := FormsFontName;

    Speedbutton1.Font.Color := FormsFontColor;
    Speedbutton1.Font.Size  := FormsFontSize + 1;
    Speedbutton1.Font.Name  := FormsFontName;

    Speedbutton2.Font.Color := FormsFontColor;
    Speedbutton2.Font.Size  := FormsFontSize + 1;
    Speedbutton2.Font.Name  := FormsFontName;

    panel2.Color := FormsColor;
    panel2.Font.Color := FormsFontColor;
    panel2.Font.Size := FormsFontSize;
    panel2.Font.Name := FormsFontName;

    Speedbutton3.Font.Color := FormsFontColor;
    Speedbutton3.Font.Size  := FormsFontSize + 1;
    Speedbutton3.Font.Name  := FormsFontName;

    Speedbutton4.Font.Color := FormsFontColor;
    Speedbutton4.Font.Size  := FormsFontSize + 1;
    Speedbutton4.Font.Name  := FormsFontName;

    Speedbutton5.Font.Color := FormsFontColor;
    Speedbutton5.Font.Size  := FormsFontSize + 1;
    Speedbutton5.Font.Name  := FormsFontName;

    Edit1.Color := FormsEditColor;
    Edit1.Font.Color := FormsEditFontColor;
    Edit1.Font.Size := FormsEditFontSize;
    Edit1.Font.Name := FormsEditFontName;

    CheckListBox1.Color := FormsEditColor;
    CheckListBox1.Font.Color := FormsEditFontColor;
    CheckListBox1.Font.Size := FormsEditFontSize;
    CheckListBox1.Font.Name := FormsEditFontName;
  end;
end;

procedure InitMyMessage;
begin
  WriteLog('MAIN', 'UInitForms.InitMyMessage');
  with FMyMessage do begin
    Color := FormsColor;
    Font.Color := FormsFontColor;
    Font.Size := FormsFontSize;
    Font.Name := FormsFontName;

    Label1.Color := FormsColor;
    Label1.Font.Color := FormsFontColor;
    Label1.Font.Size := FormsFontSize + 2;
    Label1.Font.Name := FormsFontName;

    spbNot.Font.Color := FormsFontColor;
    spbNot.Font.Size  := FormsFontSize + 1;
    spbNot.Font.Name  := FormsFontName;

    spbYes.Font.Color := FormsFontColor;
    spbYes.Font.Size  := FormsFontSize + 1;
    spbYes.Font.Name  := FormsFontName;
  end;
end;

procedure InitEditTimeline;
var RT : TRect;
    lft : integer;
begin
  WriteLog('MAIN', 'UInitForms.InitEditTimeline');
  with FEditTimeline do begin
    FEditTimeline.DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    ComboBox1.DoubleBuffered:=true;
    panel2.DoubleBuffered:=true;
    Image2.Parent.DoubleBuffered:=true;
    pnDelete.DoubleBuffered:=true;
    pnDevice.DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;
    Edit2.DoubleBuffered:=true;
    Image1.Parent.DoubleBuffered:=true;
    SpinEdit1.DoubleBuffered:=true;
    pnMedia.DoubleBuffered:=true;
    pnText.DoubleBuffered:=true;
    sbTextEvent.Parent.DoubleBuffered:=true;

    pnDevice.Align:=alClient;
    pnText.Align:=alClient;
    pnMedia.Align:=alClient;
    pnDelete.Align:=alClient;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;
  //Panel1
    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize;
    Label1.Font.Name:=FormsFontName;

    ComboBox1.Color:=FormsEditColor;
    ComboBox1.Font.Color:=FormsEditFontColor;
    ComboBox1.Font.Size:=FormsFontSize;
    ComboBox1.Font.Name:=FormsFontName;
    //Panel2
    Panel2.Color:=FormsColor;
    Panel2.Font.Color:=FormsFontColor;
    Panel2.Font.Size:=FormsFontSize;
    Panel2.Font.Name:=FormsFontName;
    //SpeedButton1;
    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+1;
    SpeedButton1.Font.Name:=FormsFontName;
    //SpeedButton2;
    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+1;
    SpeedButton2.Font.Name:=FormsFontName;
    //pnDelete
    pnDelete.Color:=FormsColor;
    pnDelete.Font.Color:=FormsFontColor;
    pnDelete.Font.Size:=FormsFontSize;
    pnDelete.Font.Name:=FormsFontName;

    Label4.Color:=FormsColor;
    Label4.Font.Color:=FormsFontColor;
    Label4.Font.Size:=FormsFontSize+2;
    Label4.Font.Name:=FormsFontName;
    //pnDevice
    pnDevice.Color:=FormsColor;
    pnDevice.Font.Color:=FormsFontColor;
    pnDevice.Font.Size:=FormsFontSize;
    pnDevice.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize;
    Label2.Font.Name:=FormsFontName;

    Label3.Color:=FormsColor;
    Label3.Font.Color:=FormsFontColor;
    Label3.Font.Size:=FormsFontSize;
    Label3.Font.Name:=FormsFontName;

    Label7.Color:=FormsColor;
    Label7.Font.Color:=FormsFontColor;
    Label7.Font.Size:=FormsSmallFont;
    Label7.Font.Name:=FormsFontName;

    SpinEdit1.Color:=FormsEditColor;
    SpinEdit1.Font.Color:=FormsEditFontColor;
    SpinEdit1.Font.Size:=FormsFontSize;
    SpinEdit1.Font.Name:=FormsFontName;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=FormsFontSize;
    Edit1.Font.Name:=FormsFontName;

    Edit2.Color:=FormsEditColor;
    Edit2.Font.Color:=FormsEditFontColor;
    Edit2.Font.Size:=FormsFontSize;
    Edit2.Font.Name:=FormsFontName;

    Image1.Canvas.Brush.Color:=FormsColor;
    Image1.Canvas.Font.Color:=FormsFontColor;
    Image1.Canvas.Font.Size:=FormsFontSize;
    Image1.Canvas.Font.Name:=FormsFontName;

    Image2.Canvas.Brush.Color:=FormsColor;
    Image2.Canvas.Font.Color:=FormsFontColor;
    Image2.Canvas.Font.Size:=FormsFontSize;
    Image2.Canvas.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsSmallFont;
    SpeedButton3.Font.Name:=FormsFontName;

    SpeedButton4.Font.Color:=FormsFontColor;
    SpeedButton4.Font.Size:=FormsSmallFont;
    SpeedButton4.Font.Name:=FormsFontName;

    SpeedButton5.Font.Color:=FormsFontColor;
    SpeedButton5.Font.Size:=FormsSmallFont;
    SpeedButton5.Font.Name:=FormsFontName;

    SpeedButton6.Font.Color:=FormsFontColor;
    SpeedButton6.Font.Size:=FormsFontSize;
    SpeedButton6.Font.Name:=FormsFontName;

    //pnText
    pnText.Color:=FormsColor;
    pnText.Font.Color:=FormsFontColor;
    pnText.Font.Size:=FormsFontSize;
    pnDevice.Font.Name:=FormsFontName;

    Edit3.Color:=FormsEditColor;
    Edit3.Font.Color:=FormsEditFontColor;
    Edit3.Font.Size:=FormsFontSize;
    Edit3.Font.Name:=FormsFontName;

    Image3.Canvas.Brush.Color:=FormsColor;
    Image3.Canvas.Font.Color:=FormsFontColor;
    Image3.Canvas.Font.Size:=FormsFontSize;
    Image3.Canvas.Font.Name:=FormsFontName;

    SpinEdit2.Color:=FormsEditColor;
    SpinEdit2.Font.Color:=FormsEditFontColor;
    SpinEdit2.Font.Size:=FormsFontSize;
    SpinEdit2.Font.Name:=FormsFontName;

    SpinEdit3.Color:=FormsEditColor;
    SpinEdit3.Font.Color:=FormsEditFontColor;
    SpinEdit3.Font.Size:=FormsFontSize;
    SpinEdit3.Font.Name:=FormsFontName;

    Label8.Color:=FormsColor;
    Label8.Font.Color:=FormsFontColor;
    Label8.Font.Size:=FormsFontSize;
    Label8.Font.Name:=FormsFontName;

    Label9.Color:=FormsColor;
    Label9.Font.Color:=FormsFontColor;
    Label9.Font.Size:=FormsFontSize;
    Label9.Font.Name:=FormsFontName;

    Label10.Color:=FormsColor;
    Label10.Font.Color:=FormsFontColor;
    Label10.Font.Size:=FormsFontSize;
    Label10.Font.Name:=FormsFontName;

    Label11.Color:=FormsColor;
    Label11.Font.Color:=FormsFontColor;
    Label11.Font.Size:=FormsFontSize;
    Label11.Font.Name:=FormsFontName;

    Label12.Color:=FormsColor;
    Label12.Font.Color:=FormsFontColor;
    Label12.Font.Size:=FormsFontSize;
    Label12.Font.Name:=FormsFontName;

    Label13.Color:=FormsColor;
    Label13.Font.Color:=FormsFontColor;
    Label13.Font.Size:=FormsFontSize;
    Label13.Font.Name:=FormsFontName;
    
  //pnMedia
    pnMedia.Color:=FormsColor;
    pnMedia.Font.Color:=FormsFontColor;
    pnMedia.Font.Size:=FormsFontSize;
    pnMedia.Font.Name:=FormsFontName;

    Edit4.Color:=FormsEditColor;
    Edit4.Font.Color:=FormsEditFontColor;
    Edit4.Font.Size:=FormsFontSize;
    Edit4.Font.Name:=FormsFontName;

    Image4.Canvas.Brush.Color:=FormsColor;
    Image4.Canvas.Font.Color:=FormsFontColor;
    Image4.Canvas.Font.Size:=FormsFontSize;
    Image4.Canvas.Font.Name:=FormsFontName;

    Label5.Color:=FormsColor;
    Label5.Font.Color:=FormsFontColor;
    Label5.Font.Size:=FormsFontSize;
    Label5.Font.Name:=FormsFontName;

    Label6.Color:=FormsColor;
    Label6.Font.Color:=FormsFontColor;
    Label6.Font.Size:=FormsFontSize;
    Label6.Font.Name:=FormsFontName;


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  if OPTTimeline=nil then OPTTimeline:=TTimelineOptions.Create;
  //Настройка панели Устройств
  Image1.Width:=pnDevice.Width div 2;
  Image1.Picture.Bitmap.Width:=pnDevice.Width div 2;
  Label2.Left:=15;
  Label3.Left:=15;
  Edit1.Left:=30 + Label2.Width;
  Edit1.Width:=(pnDevice.Width div 2) - Edit1.Left - 5;
  SpinEdit1.Left:=(pnDevice.Width div 2) - SpinEdit1.Width - 5;
  Bevel1.Left:=10;
  Bevel1.Width:= (pnDevice.Width div 2) - 10;
  Image2.Left:=Bevel1.Left+3;
  Image2.Width:=Bevel1.Width-6;
  Image2.Picture.Bitmap.Width:=Bevel1.Width-6;
  Image2.Canvas.FillRect(Image2.Canvas.ClipRect);
  RT.Left:=15;
  RT.Top:=3;
  RT.Right:=40;
  RT.Bottom:=28;
  Image2.Canvas.Pen.Color:=clWhite;
  Image2.Canvas.Pen.Width:=1;
  RT.Left:=55;
  RT.Top:=3;
  RT.Right:=80;
  RT.Bottom:=28;
  Image2.Canvas.Pen.Color:=clWhite;
  Image2.Canvas.Pen.Width:=1;
  SpeedButton3.Left:=Bevel1.Left+5;
  SpeedButton4.Left:=SpeedButton3.Left + SpeedButton3.Width + 2;
  SpeedButton5.Left:=SpeedButton4.Left + SpeedButton4.Width + 2;
  Edit2.Left:=SpeedButton5.Left + SpeedButton5.Width + 5;
  Edit2.Width:=Bevel1.Width - Edit2.Left -5 + Bevel1.Left;
  Label7.Left:=Bevel1.Left + 5;
  //pnText
  lft:=Width div 2 -5;
  Edit3.Left:=lft;
  Edit3.Width:=lft -20;
  SpinEdit2.Left:=lft;
  SpinEdit3.Left:=lft;
  Label10.Left:=lft + SpinEdit2.Width + 2;
  Label13.Left:=lft + SpinEdit3.Width + 2;
  Bevel2.Left:=lft;
  Image3.Left:=Bevel2.Left + 2;
  Image3.Width:=Bevel2.Width -3;
  Image3.Top:=Bevel2.Top+2;
  Image3.Height:=Bevel2.Height-3;
  Image3.Picture.Bitmap.Width:=Image3.Width;
  Image3.Picture.Bitmap.Height:=Image3.Height;
  Image3.Canvas.FillRect(Image3.Canvas.ClipRect);
  //pnMedia
  Edit4.Left:=lft;
  Edit4.Width:=lft -20;
  Bevel3.Left:=lft;
  Image4.Left:=Bevel3.Left + 2;
  Image4.Width:=Bevel3.Width -3;
  Image4.Top:=Bevel3.Top+2;
  Image4.Height:=Bevel3.Height-3;
  Image4.Picture.Bitmap.Width:=Image4.Width;
  Image4.Picture.Bitmap.Height:=Image4.Height;
  Image4.Canvas.FillRect(Image4.Canvas.ClipRect);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  end;
end;

procedure InitImageTemplate;
begin
  WriteLog('MAIN', 'UInitForms.InitImageTemplate');
  with FGRTemplate do begin
    DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    Panel2.DoubleBuffered:=true;
    Panel3.DoubleBuffered:=true;
    Panel4.DoubleBuffered:=true;
    Image1.Parent.DoubleBuffered:=true;
    Image2.Parent.DoubleBuffered:=true;
    Layer1.Parent.DoubleBuffered:=true;
    GridImgTemplate.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Image1.Canvas.Brush.Color:=SmoothColor(FormsColor,32);
    FGRTemplate.BKGN := Image1.Canvas.Brush.Color;
    Image1.Canvas.Font.Color:=FormsFontColor;
    Image1.Canvas.Font.Name:=FormsFontName;
    Image1.Picture.Bitmap.PixelFormat:=pf24bit;
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);

    Layer1.Canvas.Brush.Color:=Layer1.Picture.Bitmap.TransparentColor;
    Layer1.Canvas.Font.Color:=FormsFontColor;
    Layer1.Canvas.Font.Name:=FormsFontName;
    Layer1.Canvas.FillRect(Image1.Canvas.ClipRect);

  //Panel1
    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize;
    Label2.Font.Name:=FormsFontName;

    //Panel2
    Panel2.Color:=FormsColor;
    Panel2.Font.Color:=FormsFontColor;
    Panel2.Font.Size:=FormsFontSize;
    Panel2.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize;
    SpeedButton2.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize+2;
    SpeedButton3.Font.Name:=FormsFontName;

    //SpeedButton4.Font.Color:=FormsFontColor;
    //SpeedButton4.Font.Size:=FormsFontSize+2;
    //SpeedButton4.Font.Name:=FormsFontName;

    SpeedButton5.Font.Color:=FormsFontColor;
    SpeedButton5.Font.Size:=FormsFontSize;
    SpeedButton5.Font.Name:=FormsFontName;

    SpeedButton6.Font.Color:=FormsFontColor;
    SpeedButton6.Font.Size:=FormsFontSize;
    SpeedButton6.Font.Name:=FormsFontName;

    SpeedButton7.Font.Color:=FormsFontColor;
    SpeedButton7.Font.Size:=FormsFontSize;
    SpeedButton7.Font.Name:=FormsFontName;

    //Panel2
    Panel3.Color:=FormsColor;
    Panel3.Font.Color:=FormsFontColor;
    Panel3.Font.Size:=FormsFontSize;
    Panel3.Font.Name:=FormsFontName;

    GridImgTemplate.Color:=FormsColor;
    GridImgTemplate.Font.Color:=FormsFontColor;
    GridImgTemplate.Font.Size:=FormsFontSize;
    GridImgTemplate.Font.Name:=FormsFontName;

    ComboBox1.Color:=FormsColor;
    ComboBox1.Font.Color:=FormsFontColor;
    ComboBox1.Font.Size:=FormsFontSize;
    ComboBox1.Font.Name:=FormsFontName;

    Edit1.Color:=FormsColor;
    Edit1.Font.Color:=FormsFontColor;
    Edit1.Font.Size:=FormsFontSize + 2;
    Edit1.Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize;
    Label1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize + 2;
    Label2.Font.Name:=FormsFontName;

    Label3.Color:=FormsColor;
    Label3.Font.Color:=FormsFontColor;
    Label3.Font.Size:=FormsFontSize;
    Label3.Font.Name:=FormsFontName;

    Label4.Color:=FormsColor;
    Label4.Font.Color:=FormsFontColor;
    Label4.Font.Size:=FormsFontSize;
    Label4.Font.Name:=FormsFontName;

    //Panel4
    Panel4.Color:=FormsColor;
    Panel4.Font.Color:=FormsFontColor;
    Panel4.Font.Size:=FormsFontSize;
    Panel4.Font.Name:=FormsFontName;

    Image2.Canvas.Brush.Color:=FormsColor;
    Image2.Canvas.Font.Color:=FormsFontColor;
    Image2.Canvas.Font.Name:=FormsFontName;
    Image2.Canvas.Brush.Color:=clSilver;
    Image2.Canvas.FillRect(Image1.Canvas.ClipRect);
  end;
end;

Procedure InitImportFiles;
begin
  WriteLog('MAIN', 'UInitForms.InitImportFiles');
  with FImportFiles do begin
    DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    Label3.Parent.DoubleBuffered:=true;
    mmMistakes.DoubleBuffered:=true;
    Panel2.DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;
    SpeedButton3.Parent.DoubleBuffered:=true;
    Panel3.DoubleBuffered:=true;
    Bevel1.Parent.DoubleBuffered:=true;
    //dtpDateEnd.DoubleBuffered:=true;
    edClip.DoubleBuffered:=true;
    edSinger.DoubleBuffered:=true;
    edSinger.DoubleBuffered:=true;
    edSong.DoubleBuffered:=true;
    mmcomment.DoubleBuffered:=true;
    Label1.Parent.DoubleBuffered:=true;
    //Label2.Parent.DoubleBuffered:=true;
    lbClip.Parent.DoubleBuffered:=true;
    GroupBox1.DoubleBuffered:=true;
    GroupBox2.DoubleBuffered:=true;
    CheckBox1.DoubleBuffered:=true;
    //lbDateReg.Parent.DoubleBuffered:=true;
    edDur.DoubleBuffered:=true;
    lbDurTxt.Parent.DoubleBuffered:=true;
    lbFile.Parent.DoubleBuffered:=true;
    edNTK.DoubleBuffered:=true;
    lbNTKTxt.Parent.DoubleBuffered:=true;
    edStartTime.DoubleBuffered:=true;
    lbStartTimeTxt.Parent.DoubleBuffered:=true;
    lbSinger.Parent.DoubleBuffered:=true;
    lbSong.Parent.DoubleBuffered:=true;
    edTotalDur.DoubleBuffered:=true;
    lbTotalDurTxt.Parent.DoubleBuffered:=true;
    lbType1.Parent.DoubleBuffered:=true;
    lbTypeTxt.Parent.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    Label3.Color:=FormsColor;
    Label3.Font.Color:=FormsFontColor;
    Label3.Font.Size:=FormsFontSize;
    Label3.Font.Name:=FormsFontName;

    CheckBox1.Color:=FormsColor;
    CheckBox1.Font.Color:=FormsFontColor;
    CheckBox1.Font.Size:=FormsFontSize;
    CheckBox1.Font.Name:=FormsFontName;

    //RadioButton2.Color:=FormsColor;
    //RadioButton2.Font.Color:=FormsFontColor;
    //RadioButton2.Font.Size:=FormsFontSize;
    //RadioButton2.Font.Name:=FormsFontName;

    //RadioButton1.Color:=FormsColor;
    //RadioButton1.Font.Color:=FormsFontColor;
    //RadioButton1.Font.Size:=FormsFontSize;
    //RadioButton1.Font.Name:=FormsFontName;

    mmMistakes.Color:=FormsColor;
    mmMistakes.Font.Color:=FormsFontColor;
    mmMistakes.Font.Size:=FormsFontSize;
    mmMistakes.Font.Name:=FormsFontName;

    Panel2.Color:=FormsColor;
    Panel2.Font.Color:=FormsFontColor;
    Panel2.Font.Size:=FormsFontSize;
    Panel2.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+1;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+1;
    SpeedButton2.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize+1;
    SpeedButton3.Font.Name:=FormsFontName;

    Panel3.Color:=FormsColor;
    Panel3.Font.Color:=FormsFontColor;
    Panel3.Font.Size:=FormsFontSize;
    Panel3.Font.Name:=FormsFontName;

    //dtpDateEnd.Color:=FormsEditColor;
    //dtpDateEnd.Font.Color:=FormsEditFontColor;
    //dtpDateEnd.Font.Size:=FormsFontSize;
    //dtpDateEnd.Font.Name:=FormsFontName;

    EdClip.Color:=FormsEditColor;
    EdClip.Font.Color:=FormsEditFontColor;
    EdClip.Font.Size:=FormsFontSize;
    EdClip.Font.Name:=FormsFontName;

    EdSinger.Color:=FormsEditColor;
    EdSinger.Font.Color:=FormsEditFontColor;
    EdSinger.Font.Size:=FormsFontSize;
    EdSinger.Font.Name:=FormsFontName;

    EdSong.Color:=FormsEditColor;
    EdSong.Font.Color:=FormsEditFontColor;
    EdSong.Font.Size:=FormsFontSize;
    EdSong.Font.Name:=FormsFontName;

    mmComment.Color:=FormsEditColor;
    mmComment.Font.Color:=FormsEditFontColor;
    mmComment.Font.Size:=FormsFontSize;
    mmComment.Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize;
    Label1.Font.Name:=FormsFontName;

    //Label2.Color:=FormsColor;
    //Label2.Font.Color:=FormsFontColor;
    //Label2.Font.Size:=FormsFontSize;
    //Label2.Font.Name:=FormsFontName;

    GroupBox1.Color:=FormsColor;
    GroupBox1.Font.Color:=FormsFontColor;
    GroupBox1.Font.Size:=FormsFontSize;
    GroupBox1.Font.Name:=FormsFontName;

    GroupBox2.Color:=FormsColor;
    GroupBox2.Font.Color:=FormsFontColor;
    GroupBox2.Font.Size:=FormsFontSize;
    GroupBox2.Font.Name:=FormsFontName;

    lbClip.Color:=FormsColor;
    lbClip.Font.Color:=FormsFontColor;
    lbClip.Font.Size:=FormsFontSize;
    lbClip.Font.Name:=FormsFontName;

    //lbDateEnd.Color:=FormsColor;
    //lbDateEnd.Font.Color:=FormsFontColor;
    //lbDateEnd.Font.Size:=FormsFontSize;
    //lbDateEnd.Font.Name:=FormsFontName;

    //lbDateImpTxt.Color:=FormsColor;
    //lbDateImpTxt.Font.Color:=FormsFontColor;
    //lbDateImpTxt.Font.Size:=FormsFontSize;
    //lbDateImpTxt.Font.Name:=FormsFontName;

    //lbDateReg.Color:=FormsColor;
    //lbDateReg.Font.Color:=FormsFontColor;
    //lbDateReg.Font.Size:=FormsFontSize;
    //lbDateReg.Font.Name:=FormsFontName;

    //lbDur.Color:=FormsColor;
    //lbDur.Font.Color:=FormsFontColor;
    //lbDur.Font.Size:=FormsFontSize;
    //lbDur.Font.Name:=FormsFontName;

    edDur.Color:=FormsEditColor;
    edDur.Font.Color:=FormsEditFontColor;
    edDur.Font.Size:=FormsFontSize+1;
    edDur.Font.Name:=FormsFontName;

    lbStartTimeTxt.Color:=FormsColor;
    lbStartTimeTxt.Font.Color:=FormsFontColor;
    lbStartTimeTxt.Font.Size:=FormsFontSize;
    lbStartTimeTxt.Font.Name:=FormsFontName;

    edStartTime.Color:=FormsEditColor;
    edStartTime.Font.Color:=FormsEditFontColor;
    edStartTime.Font.Size:=FormsFontSize+1;
    edStartTime.Font.Name:=FormsFontName;

    lbDurTxt.Color:=FormsColor;
    lbDurTxt.Font.Color:=FormsFontColor;
    lbDurTxt.Font.Size:=FormsFontSize;
    lbDurTxt.Font.Name:=FormsFontName;

    lbFile.Color:=FormsColor;
    lbFile.Font.Color:=FormsFontColor;
    lbFile.Font.Size:=FormsFontSize;
    lbFile.Font.Name:=FormsFontName;

    //lbNTK.Color:=FormsColor;
    //lbNTK.Font.Color:=FormsFontColor;
    //lbNTK.Font.Size:=FormsFontSize;
    //lbNTK.Font.Name:=FormsFontName;

    edNTK.Color:=FormsEditColor;
    edNTK.Font.Color:=FormsEditFontColor;
    edNTK.Font.Size:=FormsFontSize+1;
    edNTK.Font.Name:=FormsFontName;

    lbNTKTxt.Color:=FormsColor;
    lbNTKTxt.Font.Color:=FormsFontColor;
    lbNTKTxt.Font.Size:=FormsFontSize;
    lbNTKTxt.Font.Name:=FormsFontName;

    lbSinger.Color:=FormsColor;
    lbSinger.Font.Color:=FormsFontColor;
    lbSinger.Font.Size:=FormsFontSize;
    lbSinger.Font.Name:=FormsFontName;

    lbSong.Color:=FormsColor;
    lbSong.Font.Color:=FormsFontColor;
    lbSong.Font.Size:=FormsFontSize;
    lbSong.Font.Name:=FormsFontName;

    //lbTotalDur.Color:=FormsColor;
    //lbTotalDur.Font.Color:=FormsFontColor;
    //lbTotalDur.Font.Size:=FormsFontSize;
    //lbTotalDur.Font.Name:=FormsFontName;

    edTotalDur.Color:=FormsEditColor;
    edTotalDur.Font.Color:=FormsEditFontColor;
    edTotalDur.Font.Size:=FormsFontSize+1;
    edTotalDur.Font.Name:=FormsFontName;

    lbTotalDurTxt.Color:=FormsColor;
    lbTotalDurTxt.Font.Color:=FormsFontColor;
    lbTotalDurTxt.Font.Size:=FormsFontSize;
    lbTotalDurTxt.Font.Name:=FormsFontName;

    lbType1.Color:=FormsColor;
    lbType1.Font.Color:=FormsFontColor;
    lbType1.Font.Size:=FormsFontSize;
    lbType1.Font.Name:=FormsFontName;

    lbTypeTxt.Color:=FormsColor;
    lbTypeTxt.Font.Color:=FormsFontColor;
    lbTypeTxt.Font.Size:=FormsFontSize;
    lbTypeTxt.Font.Name:=FormsFontName;

  end;
end;

procedure InitFrSetTemplate;
begin
  WriteLog('MAIN', 'UInitForms.InitFrSetTemplate');
  With frSetTemplate do begin
    DoubleBuffered:=true;
    GridMyLists.DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    //Label1.Parent.DoubleBuffered:=true;
    Panel2.DoubleBuffered:=true;
    CheckBox1.DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton3.Parent.DoubleBuffered:=true;
    SpeedButton4.Parent.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    GridMyLists.FixedColor := FormsColor;
    GridMyLists.Color      := SmoothColor(GridColorRow1,16);
    GridMyLists.Font.Color := GridMainFontColor;
    GridMyLists.Font.Size  := FormsFontSize;
    GridMyLists.Font.Name  := FormsFontName;

    Panel2.Color:=FormsColor;
    Panel2.Font.Color:=FormsFontColor;
    Panel2.Font.Size:=FormsFontSize;
    Panel2.Font.Name:=FormsFontName;

    CheckBox1.Color:=FormsColor;
    CheckBox1.Font.Color:=FormsFontColor;
    CheckBox1.Font.Size:=FormsFontSize;
    CheckBox1.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+2;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize+2;
    SpeedButton3.Font.Name:=FormsFontName;

    SpeedButton4.Font.Color:=FormsFontColor;
    SpeedButton4.Font.Size:=FormsFontSize+2;
    SpeedButton4.Font.Name:=FormsFontName;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=FormsFontSize+2;
    Edit1.Font.Name:=FormsFontName;
  end;//with
end;

procedure InitFrSetEventData;
begin
  WriteLog('MAIN', 'UInitForms.InitFrSetEventData');
  with FrSetEventData do begin
    DoubleBuffered:=true;
    ComboBox1.DoubleBuffered:=true;
    Label1.Parent.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;
    CheckBox1.DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;
    SpinEdit1.DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+2;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+2;
    SpeedButton2.Font.Name:=FormsFontName;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=14;
    Edit1.Font.Name:=FormsFontName;

    SpinEdit1.Color:=FormsEditColor;
    SpinEdit1.Font.Color:=FormsEditFontColor;
    SpinEdit1.Font.Size:=14;
    SpinEdit1.Font.Name:=FormsFontName;

    ComboBox1.Color:=FormsEditColor;
    ComboBox1.Font.Color:=FormsEditFontColor;
    ComboBox1.Font.Size:=14;
    ComboBox1.Font.Name:=FormsFontName;

    CheckBox1.Color:=FormsColor;
    CheckBox1.Font.Color:=FormsFontColor;
    CheckBox1.Font.Size:=FormsFontSize;
    CheckBox1.Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=14;
    Label1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize;
    Label2.Font.Name:=FormsFontName;
  end;
end;

procedure InitFrButtonOptions;
begin
  WriteLog('MAIN', 'UInitForms.InitFrButtonOptions');
  with FButtonOptions do begin
    DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;
    SpeedButton3.Parent.DoubleBuffered:=true;
    Panel2.DoubleBuffered:=true;
    Panel3.DoubleBuffered:=true;
    Panel4.DoubleBuffered:=true;
    Panel7.DoubleBuffered:=true;
    CheckBox1.DoubleBuffered:=true;
    Panel5.DoubleBuffered:=true;
    Image2.Parent.DoubleBuffered:=true;
    Panel6.DoubleBuffered:=true;
    Bevel1.Parent.DoubleBuffered:=true;
    Bevel1.Parent.DoubleBuffered:=true;
    cbFontName.DoubleBuffered:=true;
    cbMainFont.DoubleBuffered:=true;
    cbSubFont.DoubleBuffered:=true;
    ColorBox1.DoubleBuffered:=true;
    Image1.Parent.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;
    Label3.Parent.DoubleBuffered:=true;
    Label4.Parent.DoubleBuffered:=true;
    Label5.Parent.DoubleBuffered:=true;
    Label6.Parent.DoubleBuffered:=true;
    Label6.Parent.DoubleBuffered:=true;
    Label8.Parent.DoubleBuffered:=true;
    Panel8.DoubleBuffered:=true;
    Label1.Parent.DoubleBuffered:=true;
    Label9.Parent.DoubleBuffered:=true;
    lbNumber.Parent.DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+2;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+2;
    SpeedButton2.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize;
    SpeedButton3.Font.Name:=FormsFontName;

    Panel2.Color:=FormsColor;
    Panel2.Font.Color:=FormsFontColor;
    Panel2.Font.Size:=FormsFontSize;
    Panel2.Font.Name:=FormsFontName;

    Panel3.Color:=FormsColor;
    Panel3.Font.Color:=FormsFontColor;
    Panel3.Font.Size:=FormsFontSize;
    Panel3.Font.Name:=FormsFontName;

    Panel4.Color:=FormsColor;
    Panel4.Font.Color:=FormsFontColor;
    Panel4.Font.Size:=FormsFontSize;
    Panel4.Font.Name:=FormsFontName;

    Panel7.Color:=FormsColor;
    Panel7.Font.Color:=FormsFontColor;
    Panel7.Font.Size:=FormsFontSize;
    Panel7.Font.Name:=FormsFontName;

    CheckBox1.Color:=FormsColor;
    CheckBox1.Font.Color:=FormsFontColor;
    CheckBox1.Font.Size:=FormsFontSize;
    CheckBox1.Font.Name:=FormsFontName;

    Stringgrid1.FixedColor := ProgrammColor;
    Stringgrid1.Color      := SmoothColor(GridColorRow1,16);
    Stringgrid1.Font.Color := GridMainFontColor;
    Stringgrid1.Font.Size  := ProgrammFontSize + 2;
    Stringgrid1.Font.Name  := ProgrammFontName;

    Panel5.Color:=FormsColor;
    Panel5.Font.Color:=FormsFontColor;
    Panel5.Font.Size:=FormsFontSize;
    Panel5.Font.Name:=FormsFontName;

    Panel6.Color:=FormsColor;
    Panel6.Font.Color:=FormsFontColor;
    Panel6.Font.Size:=FormsFontSize;
    Panel6.Font.Name:=FormsFontName;

    cbFontName.Color:=FormsEditColor;
    cbFontName.Font.Color:=FormsEditFontColor;
    cbFontName.Font.Size:=FormsFontSize;
    cbFontName.Font.Name:=FormsFontName;

    cbMainFont.Color:=FormsEditColor;
    cbMainFont.Font.Color:=FormsEditFontColor;
    cbMainFont.Font.Size:=FormsFontSize;
    cbMainFont.Font.Name:=FormsFontName;

    cbSubFont.Color:=FormsEditColor;
    cbSubFont.Font.Color:=FormsEditFontColor;
    cbSubFont.Font.Size:=FormsFontSize;
    cbSubFont.Font.Name:=FormsFontName;

    ColorBox1.Color:=FormsEditColor;
    ColorBox1.Font.Color:=FormsEditFontColor;
    ColorBox1.Font.Size:=FormsFontSize;
    ColorBox1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize;
    Label2.Font.Name:=FormsFontName;

    Label3.Color:=FormsColor;
    Label3.Font.Color:=FormsFontColor;
    Label3.Font.Size:=FormsFontSize;
    Label3.Font.Name:=FormsFontName;

    Label4.Color:=FormsColor;
    Label4.Font.Color:=FormsFontColor;
    Label4.Font.Size:=FormsFontSize;
    Label4.Font.Name:=FormsFontName;

    Label5.Color:=FormsColor;
    Label5.Font.Color:=FormsFontColor;
    Label5.Font.Size:=FormsFontSize;
    Label5.Font.Name:=FormsFontName;

    Label6.Color:=FormsColor;
    Label6.Font.Color:=FormsFontColor;
    Label6.Font.Size:=FormsFontSize;
    Label6.Font.Name:=FormsFontName;

    Label7.Color:=FormsColor;
    Label7.Font.Color:=FormsFontColor;
    Label7.Font.Size:=FormsFontSize;
    Label7.Font.Name:=FormsFontName;

    Label8.Color:=FormsColor;
    Label8.Font.Color:=FormsFontColor;
    Label8.Font.Size:=FormsFontSize;
    Label8.Font.Name:=FormsFontName;

    Panel8.Color:=FormsColor;
    Panel8.Font.Color:=FormsFontColor;
    Panel8.Font.Size:=FormsFontSize;
    Panel8.Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize;
    Label1.Font.Name:=FormsFontName;

    Label9.Color:=FormsColor;
    Label9.Font.Color:=FormsFontColor;
    Label9.Font.Size:=FormsFontSize;
    Label9.Font.Name:=FormsFontName;

    lbNumber.Color:=FormsColor;
    lbNumber.Font.Color:=FormsFontColor;
    lbNumber.Font.Size:=FormsFontSize;
    lbNumber.Font.Name:=FormsFontName;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=FormsFontSize;
    Edit1.Font.Name:=FormsFontName;
  end;
end;

procedure InitFrSortGrid;
begin
  WriteLog('MAIN', 'UInitForms.InitFrSortGrid');
  with frsortgrid do begin
    DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;
    SpeedButton3.Parent.DoubleBuffered:=true;
    Image1.Parent.DoubleBuffered:=true;
    Image2.Parent.DoubleBuffered:=true;
    Label1.Parent.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;
    RadioGroup1.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize+2;
    Label1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize+2;
    Label2.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+2;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+2;
    SpeedButton2.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize;
    SpeedButton3.Font.Name:=FormsFontName;

    RadioGroup1.Color:=FormsColor;
    RadioGroup1.Font.Color:=FormsFontColor;
    RadioGroup1.Font.Size:=FormsFontSize+2;
    RadioGroup1.Font.Name:=FormsFontName;
  end;
end;

procedure InitFrShiftTL;
begin
  WriteLog('MAIN', 'UInitForms.InitFrShiftTL');
  with frShiftTL do begin
    DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    Label1.Parent.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;
    CheckBox1.DoubleBuffered:=true;
    SpinEdit1.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize+2;
    Label1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize+2;
    Label2.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+2;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+2;
    SpeedButton2.Font.Name:=FormsFontName;

    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    CheckBox1.Color:=FormsColor;
    CheckBox1.Font.Color:=FormsFontColor;
    CheckBox1.Font.Size:=FormsFontSize;
    CheckBox1.Font.Name:=FormsFontName;

    SpinEdit1.Color:=FormsEditColor;
    SpinEdit1.Font.Color:=FormsEditFontColor;
    SpinEdit1.Font.Size:=FormsFontSize + 2;
    SpinEdit1.Font.Name:=FormsFontName;
  end;
end;

procedure InitFrShortNum;
begin
  WriteLog('MAIN', 'UInitForms.InitFrShortNum');
  with frShortNum do begin
    DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    CheckBox1.DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+2;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+2;
    SpeedButton2.Font.Name:=FormsFontName;

    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    CheckBox1.Color:=FormsColor;
    CheckBox1.Font.Color:=FormsFontColor;
    CheckBox1.Font.Size:=FormsFontSize;
    CheckBox1.Font.Name:=FormsFontName;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=FormsFontSize + 2;
    Edit1.Font.Name:=FormsFontName;
  end;
end;

procedure InitFrMediaCopy;
begin
  WriteLog('MAIN', 'UInitForms.InitFrMediaCopy');
  with frMediaCopy do begin
    DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;
    Gauge1.Parent.DoubleBuffered:=true;
    Label1.Parent.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;
    Label3.Parent.DoubleBuffered:=true;
    Label4.Parent.DoubleBuffered:=true;
    Label5.Parent.DoubleBuffered:=true;
    Label6.Parent.DoubleBuffered:=true;
    Label7.Parent.DoubleBuffered:=true;
    Label8.Parent.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+2;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+2;
    SpeedButton2.Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize;
    Label1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize;
    Label2.Font.Name:=FormsFontName;

    Label3.Color:=FormsColor;
    Label3.Font.Color:=FormsFontColor;
    Label3.Font.Size:=FormsFontSize;
    Label3.Font.Name:=FormsFontName;

    Label4.Color:=FormsColor;
    Label4.Font.Color:=FormsFontColor;
    Label4.Font.Size:=FormsFontSize;
    Label4.Font.Name:=FormsFontName;

    Label5.Color:=FormsColor;
    Label5.Font.Color:=FormsFontColor;
    Label5.Font.Size:=FormsFontSize;
    Label5.Font.Name:=FormsFontName;

    Label6.Color:=FormsColor;
    Label6.Font.Color:=FormsFontColor;
    Label6.Font.Size:=FormsFontSize;
    Label6.Font.Name:=FormsFontName;

    Label7.Color:=FormsColor;
    Label7.Font.Color:=FormsFontColor;
    Label7.Font.Size:=FormsFontSize;
    Label7.Font.Name:=FormsFontName;

    Label8.Color:=FormsColor;
    Label8.Font.Color:=FormsFontColor;
    Label8.Font.Size:=FormsFontSize;
    Label8.Font.Name:=FormsFontName;

    Gauge1.Color:=FormsColor;
    Gauge1.Font.Color:=FormsFontColor;
    Gauge1.Font.Size:=FormsFontSize;
    Gauge1.Font.Name:=FormsFontName;

  end;
end;

procedure InitfrMyPrint;
begin
  WriteLog('MAIN', 'UInitForms.InitfrMyPrint');
  with frMyPrint do begin
    DoubleBuffered:=true;
    GroupBox1.DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    Panel2.DoubleBuffered:=true;
    Panel3.DoubleBuffered:=true;
    Panel4.DoubleBuffered:=true;
    Panel5.DoubleBuffered:=true;
    Image3.Parent.DoubleBuffered:=true;
    Label7.Parent.DoubleBuffered:=true;
    Label8.Parent.DoubleBuffered:=true;
    ComboBox1.DoubleBuffered:=true;
    GroupBox2.DoubleBuffered:=true;

    Label3.Parent.DoubleBuffered:=true;
    Label4.Parent.DoubleBuffered:=true;
    Label5.Parent.DoubleBuffered:=true;
    Label6.Parent.DoubleBuffered:=true;
    cbDataPrint.DoubleBuffered:=true;
    cbDevices.DoubleBuffered:=true;
    cbTexts.DoubleBuffered:=true;
    cbTypePrint.DoubleBuffered:=true;

    Label1.Parent.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;
    SpinEdit1.DoubleBuffered := true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;


    Panel1.Color:=SmoothColor(FormsColor,128);
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    Panel2.Color:=FormsColor;
    Panel2.Font.Color:=FormsFontColor;
    Panel2.Font.Size:=FormsFontSize;
    Panel2.Font.Name:=FormsFontName;

    Panel3.Color:=clWhite;
    Panel3.Font.Color:=FormsFontColor;
    Panel3.Font.Size:=FormsFontSize;
    Panel3.Font.Name:=FormsFontName;

    Panel4.Color:=FormsColor;
    Panel4.Font.Color:=FormsFontColor;
    Panel4.Font.Size:=FormsFontSize;
    Panel4.Font.Name:=FormsFontName;

    Panel5.Color:=FormsColor;
    Panel5.Font.Color:=FormsFontColor;
    Panel5.Font.Size:=FormsFontSize;
    Panel5.Font.Name:=FormsFontName;

    GroupBox1.Color:=FormsColor;
    GroupBox1.Font.Color:=FormsFontColor;
    GroupBox1.Font.Size:=FormsFontSize + 1;
    GroupBox1.Font.Name:=FormsFontName;

    GroupBox2.Color:=FormsColor;
    GroupBox2.Font.Color:=FormsFontColor;
    GroupBox2.Font.Size:=FormsFontSize + 1;
    GroupBox2.Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize + 2;
    Label1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize;
    Label2.Font.Name:=FormsFontName;

    Label3.Color:=FormsColor;
    Label3.Font.Color:=FormsFontColor;
    Label3.Font.Size:=FormsFontSize;
    Label3.Font.Name:=FormsFontName;

    Label4.Color:=FormsColor;
    Label4.Font.Color:=FormsFontColor;
    Label4.Font.Size:=FormsFontSize;
    Label4.Font.Name:=FormsFontName;

    Label5.Color:=FormsColor;
    Label5.Font.Color:=FormsFontColor;
    Label5.Font.Size:=FormsFontSize;
    Label5.Font.Name:=FormsFontName;

    Label6.Color:=FormsColor;
    Label6.Font.Color:=FormsFontColor;
    Label6.Font.Size:=FormsFontSize;
    Label6.Font.Name:=FormsFontName;

    Label7.Color:=FormsColor;
    Label7.Font.Color:=FormsFontColor;
    Label7.Font.Size:=FormsFontSize;
    Label7.Font.Name:=FormsFontName;

    Label8.Color:=FormsColor;
    Label8.Font.Color:=FormsFontColor;
    Label8.Font.Size:=FormsFontSize;
    Label8.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+1;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+1;
    SpeedButton2.Font.Name:=FormsFontName;

    ComboBox1.Color:=FormsEditColor;
    ComboBox1.Font.Color:=FormsEditFontColor;
    ComboBox1.Font.Size:=FormsFontSize;
    ComboBox1.Font.Name:=FormsFontName;

    cbDataPrint.Color:=FormsEditColor;
    cbDataPrint.Font.Color:=FormsEditFontColor;
    cbDataPrint.Font.Size:=FormsFontSize;
    cbDataPrint.Font.Name:=FormsFontName;

    cbDevices.Color:=FormsEditColor;
    cbDevices.Font.Color:=FormsEditFontColor;
    cbDevices.Font.Size:=FormsFontSize;
    cbDevices.Font.Name:=FormsFontName;

    cbTexts.Color:=FormsEditColor;
    cbTexts.Font.Color:=FormsEditFontColor;
    cbTexts.Font.Size:=FormsFontSize;
    cbTexts.Font.Name:=FormsFontName;

    cbTypePrint.Color:=FormsEditColor;
    cbTypePrint.Font.Color:=FormsEditFontColor;
    cbTypePrint.Font.Size:=FormsFontSize;
    cbTypePrint.Font.Name:=FormsFontName;

    SpinEdit1.Color:=FormsEditColor;
    SpinEdit1.Font.Color:=FormsEditFontColor;
    SpinEdit1.Font.Size:=FormsFontSize;
    SpinEdit1.Font.Name:=FormsFontName;

  end;
end;

procedure InitFPageSetup;
begin
  WriteLog('MAIN', 'UInitForms.InitFPageSetup');
  with FPage do begin
    DoubleBuffered:=true;
    sbBitBtn1.Parent.DoubleBuffered:=true;
    sbBitBtn2.Parent.DoubleBuffered:=true;
    CheckBox1.DoubleBuffered:=true;
    CheckBox2.DoubleBuffered:=true;
    CheckBox3.DoubleBuffered:=true;
    GroupBox1.DoubleBuffered:=true;
    Edit3.DoubleBuffered:=true;
    Edit4.DoubleBuffered:=true;
    Edit5.DoubleBuffered:=true;
    Edit6.DoubleBuffered:=true;
    Edit7.DoubleBuffered:=true;
    Edit8.DoubleBuffered:=true;
    Label3.Parent.DoubleBuffered:=true;
    Label4.Parent.DoubleBuffered:=true;
    Label5.Parent.DoubleBuffered:=true;
    Label6.Parent.DoubleBuffered:=true;
    Label7.Parent.DoubleBuffered:=true;
    Label8.Parent.DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    Panel2.DoubleBuffered:=true;
    Image1.Parent.DoubleBuffered:=true;
    Image2.Parent.DoubleBuffered:=true;
    Image3.Parent.DoubleBuffered:=true;
    Image4.Parent.DoubleBuffered:=true;
    Image5.Parent.DoubleBuffered:=true;
    Image6.Parent.DoubleBuffered:=true;
    Image7.Parent.DoubleBuffered:=true;
    SpinButton1.DoubleBuffered:=true;
    SpinButton2.DoubleBuffered:=true;
    SpinButton3.DoubleBuffered:=true;
    SpinButton4.DoubleBuffered:=true;
    SpinButton5.DoubleBuffered:=true;
    SpinButton6.DoubleBuffered:=true;

    GroupBox2.DoubleBuffered:=true;
    Image1.Parent.DoubleBuffered:=true;
    Image2.Parent.DoubleBuffered:=true;
    RadioButton1.DoubleBuffered:=true;
    RadioButton2.DoubleBuffered:=true;

    GroupBox3.DoubleBuffered:=true;
    ComboBox1.DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;
    Edit2.DoubleBuffered:=true;
    Label1.Parent.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;

    GroupBox4.DoubleBuffered:=true;
    ComboBox2.DoubleBuffered:=true;

    Image4.Parent.DoubleBuffered:=true;
    Image5.Parent.DoubleBuffered:=true;
    Image6.Parent.DoubleBuffered:=true;
    Image7.Parent.DoubleBuffered:=true;
    Label9.Parent.DoubleBuffered:=true;
    Label10.Parent.DoubleBuffered:=true;
    Label11.Parent.DoubleBuffered:=true;
    RadioButton3.DoubleBuffered:=true;
    RadioButton4.DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;
    SpeedButton3.Parent.DoubleBuffered:=true;
    SpeedButton4.Parent.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    sbBitBtn1.Font.Color:=FormsFontColor;
    sbBitBtn1.Font.Size:=FormsFontSize;
    sbBitBtn1.Font.Name:=FormsFontName;

    sbBitBtn2.Font.Color:=FormsFontColor;
    sbBitBtn2.Font.Size:=FormsFontSize;
    sbBitBtn2.Font.Name:=FormsFontName;

    CheckBox1.Color:=FormsColor;
    CheckBox1.Font.Color:=FormsFontColor;
    CheckBox1.Font.Size:=FormsFontSize;
    CheckBox1.Font.Name:=FormsFontName;

    CheckBox2.Color:=FormsColor;
    CheckBox2.Font.Color:=FormsFontColor;
    CheckBox2.Font.Size:=FormsFontSize;
    CheckBox2.Font.Name:=FormsFontName;

    CheckBox3.Color:=FormsColor;
    CheckBox3.Font.Color:=FormsFontColor;
    CheckBox3.Font.Size:=FormsFontSize;
    CheckBox3.Font.Name:=FormsFontName;

    GroupBox1.Color:=FormsColor;
    GroupBox1.Font.Color:=FormsFontColor;
    GroupBox1.Font.Size:=FormsFontSize;
    GroupBox1.Font.Name:=FormsFontName;

    GroupBox2.Color:=FormsColor;
    GroupBox2.Font.Color:=FormsFontColor;
    GroupBox2.Font.Size:=FormsFontSize;
    GroupBox2.Font.Name:=FormsFontName;

    GroupBox3.Color:=FormsColor;
    GroupBox3.Font.Color:=FormsFontColor;
    GroupBox3.Font.Size:=FormsFontSize+1;
    GroupBox3.Font.Name:=FormsFontName;

    GroupBox4.Color:=FormsColor;
    GroupBox4.Font.Color:=FormsFontColor;
    GroupBox4.Font.Size:=FormsFontSize;
    GroupBox4.Font.Name:=FormsFontName;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=FormsFontSize;
    Edit1.Font.Name:=FormsFontName;

    Edit2.Color:=FormsEditColor;
    Edit2.Font.Color:=FormsEditFontColor;
    Edit2.Font.Size:=FormsFontSize;
    Edit2.Font.Name:=FormsFontName;

    Edit3.Color:=FormsEditColor;
    Edit3.Font.Color:=FormsEditFontColor;
    Edit3.Font.Size:=FormsFontSize;
    Edit3.Font.Name:=FormsFontName;

    Edit4.Color:=FormsEditColor;
    Edit4.Font.Color:=FormsEditFontColor;
    Edit4.Font.Size:=FormsFontSize;
    Edit4.Font.Name:=FormsFontName;

    Edit5.Color:=FormsEditColor;
    Edit5.Font.Color:=FormsEditFontColor;
    Edit5.Font.Size:=FormsFontSize;
    Edit5.Font.Name:=FormsFontName;

    Edit6.Color:=FormsEditColor;
    Edit6.Font.Color:=FormsEditFontColor;
    Edit6.Font.Size:=FormsFontSize;
    Edit6.Font.Name:=FormsFontName;

    Edit7.Color:=FormsEditColor;
    Edit7.Font.Color:=FormsEditFontColor;
    Edit7.Font.Size:=FormsFontSize;
    Edit7.Font.Name:=FormsFontName;

    Edit8.Color:=FormsEditColor;
    Edit8.Font.Color:=FormsEditFontColor;
    Edit8.Font.Size:=FormsFontSize;
    Edit8.Font.Name:=FormsFontName;

    SpinButton1.Height:=Edit3.Height-1;
    SpinButton2.Height:=Edit4.Height-1;
    SpinButton3.Height:=Edit5.Height-1;
    SpinButton4.Height:=Edit6.Height-1;
    SpinButton5.Height:=Edit7.Height-1;
    SpinButton6.Height:=Edit8.Height-1;

    Panel1.Color:=SmoothColor(FormsColor,128);
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    Panel2.Color:=FormsColor;
    Panel2.Font.Color:=FormsFontColor;
    Panel2.Font.Size:=FormsFontSize;
    Panel2.Font.Name:=FormsFontName;

    Panel3.Color:=FormsColor;
    Panel3.Font.Color:=FormsFontColor;
    Panel3.Font.Size:=FormsFontSize;
    Panel3.Font.Name:=FormsFontName;

    Panel4.Color:=FormsColor;
    Panel4.Font.Color:=FormsFontColor;
    Panel4.Font.Size:=FormsFontSize;
    Panel4.Font.Name:=FormsFontName;

    Panel5.Color:=FormsColor;
    Panel5.Font.Color:=FormsFontColor;
    Panel5.Font.Size:=FormsFontSize;
    Panel5.Font.Name:=FormsFontName;

    Panel6.Color:=FormsColor;
    Panel6.Font.Color:=FormsFontColor;
    Panel6.Font.Size:=FormsFontSize;
    Panel6.Font.Name:=FormsFontName;

    Panel7.Color:=FormsColor;
    Panel7.Font.Color:=FormsFontColor;
    Panel7.Font.Size:=FormsFontSize;
    Panel7.Font.Name:=FormsFontName;

    Panel4.Align:=alClient;
    Panel5.Align:=alClient;
    Panel6.Align:=alClient;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize-1;
    Label1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize-1;
    Label2.Font.Name:=FormsFontName;

    Label3.Color:=FormsColor;
    Label3.Font.Color:=FormsFontColor;
    Label3.Font.Size:=FormsFontSize-1;
    Label3.Font.Name:=FormsFontName;

    Label4.Color:=FormsColor;
    Label4.Font.Color:=FormsFontColor;
    Label4.Font.Size:=FormsFontSize-1;
    Label4.Font.Name:=FormsFontName;

    Label5.Color:=FormsColor;
    Label5.Font.Color:=FormsFontColor;
    Label5.Font.Size:=FormsFontSize-1;
    Label5.Font.Name:=FormsFontName;

    Label6.Color:=FormsColor;
    Label6.Font.Color:=FormsFontColor;
    Label6.Font.Size:=FormsFontSize-1;
    Label6.Font.Name:=FormsFontName;

    Label7.Color:=FormsColor;
    Label7.Font.Color:=FormsFontColor;
    Label7.Font.Size:=FormsFontSize-1;
    Label7.Font.Name:=FormsFontName;

    Label8.Color:=FormsColor;
    Label8.Font.Color:=FormsFontColor;
    Label8.Font.Size:=FormsFontSize-1;
    Label8.Font.Name:=FormsFontName;

    Label9.Color:=FormsColor;
    Label9.Font.Color:=FormsFontColor;
    Label9.Font.Size:=FormsFontSize;
    Label9.Font.Name:=FormsFontName;

    Label10.Color:=FormsColor;
    Label10.Font.Color:=FormsFontColor;
    Label10.Font.Size:=FormsFontSize;
    Label10.Font.Name:=FormsFontName;

    Label11.Color:=FormsColor;
    Label11.Font.Color:=FormsFontColor;
    Label11.Font.Size:=FormsFontSize;
    Label11.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+1;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+1;
    SpeedButton2.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize+1;
    SpeedButton3.Font.Name:=FormsFontName;

    SpeedButton4.Font.Color:=FormsFontColor;
    SpeedButton4.Font.Size:=FormsFontSize+1;
    SpeedButton4.Font.Name:=FormsFontName;

    SpeedButton5.Font.Color:=FormsFontColor;
    SpeedButton5.Font.Size:=FormsFontSize+1;
    SpeedButton5.Font.Name:=FormsFontName;

    SpeedButton6.Font.Color:=FormsFontColor;
    SpeedButton6.Font.Size:=FormsFontSize+1;
    SpeedButton6.Font.Name:=FormsFontName;

    SpeedButton7.Font.Color:=FormsFontColor;
    SpeedButton7.Font.Size:=FormsFontSize+1;
    SpeedButton7.Font.Name:=FormsFontName;

    ComboBox1.Color:=FormsEditColor;
    ComboBox1.Font.Color:=FormsEditFontColor;
    ComboBox1.Font.Size:=FormsFontSize;
    ComboBox1.Font.Name:=FormsFontName;

    ComboBox2.Color:=FormsEditColor;
    ComboBox2.Font.Color:=FormsEditFontColor;
    ComboBox2.Font.Size:=FormsFontSize;
    ComboBox2.Font.Name:=FormsFontName;

    RadioButton1.Color:=FormsColor;
    RadioButton1.Font.Color:=FormsFontColor;
    RadioButton1.Font.Size:=FormsFontSize-1;
    RadioButton1.Font.Name:=FormsFontName;

    RadioButton2.Color:=FormsColor;
    RadioButton2.Font.Color:=FormsFontColor;
    RadioButton2.Font.Size:=FormsFontSize-1;
    RadioButton2.Font.Name:=FormsFontName;

    RadioButton3.Color:=FormsColor;
    RadioButton3.Font.Color:=FormsFontColor;
    RadioButton3.Font.Size:=FormsFontSize;
    RadioButton3.Font.Name:=FormsFontName;

    RadioButton4.Color:=FormsColor;
    RadioButton4.Font.Color:=FormsFontColor;
    RadioButton4.Font.Size:=FormsFontSize;
    RadioButton4.Font.Name:=FormsFontName;

  end;
end;

procedure InitFrLTC;
begin
  WriteLog('MAIN', 'UInitForms.InitFrLTC');
  with frLTC do begin
    DoubleBuffered:=true;
    RadioButton1.DoubleBuffered:=true;
    RadioButton2.DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize;
    Label2.Font.Name:=FormsFontName;

    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    Panel2.Color:=FormsColor;
    Panel2.Font.Color:=FormsFontColor;
    Panel2.Font.Size:=FormsFontSize;
    Panel2.Font.Name:=FormsFontName;

    Panel3.Color:=FormsColor;
    Panel3.Font.Color:=FormsFontColor;
    Panel3.Font.Size:=FormsFontSize;
    Panel3.Font.Name:=FormsFontName;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=FormsFontSize+2;
    Edit1.Font.Name:=FormsFontName;

    RadioButton1.Color:=FormsColor;
    RadioButton1.Font.Color:=FormsFontColor;
    RadioButton1.Font.Size:=FormsFontSize;
    RadioButton1.Font.Name:=FormsFontName;

    RadioButton2.Color:=FormsColor;
    RadioButton2.Font.Color:=FormsFontColor;
    RadioButton2.Font.Size:=FormsFontSize;
    RadioButton2.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+1;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+1;
    SpeedButton2.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize+1;
    SpeedButton3.Font.Name:=FormsFontName;

    panel1.Align := alClient;
    panel2.Align := alClient;
  end;
end;

procedure InitfrTimeCode;
begin
  WriteLog('MAIN', 'UInitForms.InitfrTimeCode');
  with frSetTC do begin
    DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=FormsFontSize+2;
    Edit1.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+1;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+1;
    SpeedButton2.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize+1;
    SpeedButton3.Font.Name:=FormsFontName;

    SpeedButton4.Font.Color:=FormsFontColor;
    SpeedButton4.Font.Size:=FormsFontSize+1;
    SpeedButton4.Font.Name:=FormsFontName;
  end;
end;

procedure InitfrMyTextTemplate;
begin
  WriteLog('MAIN', 'UInitForms.InitfrMyTextTemplate');
  with frMyTextTemplate do begin
    DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    Panel3.DoubleBuffered:=true;
    Panel4.DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;
    CheckBox1.DoubleBuffered:=true;
    ComboBox1.DoubleBuffered:=true;
    SpinEdit1.DoubleBuffered:=true;
    Label1.Parent.DoubleBuffered:=true;
    Label2.Parent.DoubleBuffered:=true;
    Label3.Parent.DoubleBuffered:=true;
    Label4.Parent.DoubleBuffered:=true;
    Label5.Parent.DoubleBuffered:=true;
    SpeedButton1.Parent.DoubleBuffered:=true;
    SpeedButton2.Parent.DoubleBuffered:=true;
    SpeedButton3.Parent.DoubleBuffered:=true;
    SpeedButton4.Parent.DoubleBuffered:=true;
    SpeedButton5.Parent.DoubleBuffered:=true;
    SpeedButton6.Parent.DoubleBuffered:=true;
    SpeedButton7.Parent.DoubleBuffered:=true;
    SpeedButton8.Parent.DoubleBuffered:=true;
    SpeedButton9.Parent.DoubleBuffered:=true;
    SpeedButton10.Parent.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    Panel3.Color:=FormsColor;
    Panel3.Font.Color:=FormsFontColor;
    Panel3.Font.Size:=FormsFontSize;
    Panel3.Font.Name:=FormsFontName;

    Panel4.Color:=FormsColor;
    Panel4.Font.Color:=FormsFontColor;
    Panel4.Font.Size:=FormsFontSize;
    Panel4.Font.Name:=FormsFontName;

    Edit1.Color:=FormsEditColor;
    Edit1.Font.Color:=FormsEditFontColor;
    Edit1.Font.Size:=FormsFontSize+2;
    Edit1.Font.Name:=FormsFontName;

    CheckBox1.Color:=FormsColor;
    CheckBox1.Font.Color:=FormsFontColor;
    CheckBox1.Font.Size:=FormsFontSize+1;
    CheckBox1.Font.Name:=FormsFontName;

    ComboBox1.Color:=FormsColor;
    ComboBox1.Font.Color:=FormsFontColor;
    ComboBox1.Font.Size:=FormsFontSize+1;
    ComboBox1.Font.Name:=FormsFontName;

    SpinEdit1.Color:=FormsColor;
    SpinEdit1.Font.Color:=FormsFontColor;
    SpinEdit1.Font.Size:=FormsFontSize;
    SpinEdit1.Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize;
    Label1.Font.Name:=FormsFontName;

    Label2.Color:=FormsColor;
    Label2.Font.Color:=FormsFontColor;
    Label2.Font.Size:=FormsFontSize+1;
    Label2.Font.Name:=FormsFontName;

    Label3.Color:=FormsColor;
    Label3.Font.Color:=FormsFontColor;
    Label3.Font.Size:=FormsFontSize;
    Label3.Font.Name:=FormsFontName;

    Label4.Color:=FormsColor;
    Label4.Font.Color:=FormsFontColor;
    Label4.Font.Size:=FormsFontSize+1;
    Label4.Font.Name:=FormsFontName;

    Label5.Color:=FormsColor;
    Label5.Font.Color:=FormsFontColor;
    Label5.Font.Size:=FormsFontSize+1;
    Label5.Font.Name:=FormsFontName;

    SpeedButton1.Font.Color:=FormsFontColor;
    SpeedButton1.Font.Size:=FormsFontSize+1;
    SpeedButton1.Font.Name:=FormsFontName;

    SpeedButton2.Font.Color:=FormsFontColor;
    SpeedButton2.Font.Size:=FormsFontSize+1;
    SpeedButton2.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize+1;
    SpeedButton3.Font.Name:=FormsFontName;

    SpeedButton4.Font.Color:=FormsFontColor;
    SpeedButton4.Font.Size:=FormsFontSize+1;
    SpeedButton4.Font.Name:=FormsFontName;

    SpeedButton5.Font.Color:=FormsFontColor;
    SpeedButton5.Font.Size:=FormsFontSize+1;
    SpeedButton5.Font.Name:=FormsFontName;

    SpeedButton6.Font.Color:=FormsFontColor;
    SpeedButton6.Font.Size:=FormsFontSize+1;
    SpeedButton6.Font.Name:=FormsFontName;

    SpeedButton7.Font.Color:=FormsFontColor;
    SpeedButton7.Font.Size:=FormsFontSize+1;
    SpeedButton7.Font.Name:=FormsFontName;

    SpeedButton8.Font.Color:=FormsFontColor;
    SpeedButton8.Font.Size:=FormsFontSize+1;
    SpeedButton8.Font.Name:=FormsFontName;

    SpeedButton9.Font.Color:=FormsFontColor;
    SpeedButton9.Font.Size:=FormsFontSize+1;
    SpeedButton9.Font.Name:=FormsFontName;

    SpeedButton10.Font.Color:=FormsFontColor;
    SpeedButton10.Font.Size:=FormsFontSize;
    SpeedButton10.Font.Name:=FormsFontName;

  end;
end;

procedure InitfrNewList;
begin
  WriteLog('MAIN', 'UInitForms.InitfrNewList');
  with frNewList do begin
    DoubleBuffered:=true;
    Panel1.DoubleBuffered:=true;
    Panel2.DoubleBuffered:=true;
    Edit1.DoubleBuffered:=true;
    Memo1.DoubleBuffered:=true;
    Label1.Parent.DoubleBuffered:=true;
    SpeedButton3.Parent.DoubleBuffered:=true;
    SpeedButton4.Parent.DoubleBuffered:=true;
    SpeedButton5.Parent.DoubleBuffered:=true;
    SpeedButton6.Parent.DoubleBuffered:=true;

    Color:=FormsColor;
    Font.Color:=FormsFontColor;
    Font.Size:=FormsFontSize;
    Font.Name:=FormsFontName;

    Panel1.Color:=FormsColor;
    Panel1.Font.Color:=FormsFontColor;
    Panel1.Font.Size:=FormsFontSize;
    Panel1.Font.Name:=FormsFontName;

    Panel2.Color:=FormsColor;
    Panel2.Font.Color:=FormsFontColor;
    Panel2.Font.Size:=FormsFontSize;
    Panel2.Font.Name:=FormsFontName;

    Edit1.Color:=FormsColor;
    Edit1.Font.Color:=FormsFontColor;
    Edit1.Font.Size:=FormsFontSize+1;
    Edit1.Font.Name:=FormsFontName;

    Memo1.Color:=FormsColor;
    Memo1.Font.Color:=FormsFontColor;
    Memo1.Font.Size:=FormsFontSize+1;
    Memo1.Font.Name:=FormsFontName;

    Label1.Color:=FormsColor;
    Label1.Font.Color:=FormsFontColor;
    Label1.Font.Size:=FormsFontSize+1;
    Label1.Font.Name:=FormsFontName;

    SpeedButton3.Font.Color:=FormsFontColor;
    SpeedButton3.Font.Size:=FormsFontSize+1;
    SpeedButton3.Font.Name:=FormsFontName;

    SpeedButton4.Font.Color:=FormsFontColor;
    SpeedButton4.Font.Size:=FormsFontSize+1;
    SpeedButton4.Font.Name:=FormsFontName;

    SpeedButton5.Font.Color:=FormsFontColor;
    SpeedButton5.Font.Size:=FormsFontSize+1;
    SpeedButton5.Font.Name:=FormsFontName;

    SpeedButton6.Font.Color:=FormsFontColor;
    SpeedButton6.Font.Size:=FormsFontSize+1;
    SpeedButton6.Font.Name:=FormsFontName;


  end;
end;

end.
