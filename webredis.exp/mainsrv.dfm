object HTTPSRVForm: THTTPSRVForm
  Left = 327
  Top = 19
  Caption = 'WEB srv'
  ClientHeight = 555
  ClientWidth = 914
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 914
    Height = 99
    Align = alTop
    TabOrder = 0
    OnClick = Panel1Click
    object SpeedButton1: TSpeedButton
      Left = 16
      Top = 16
      Width = 33
      Height = 33
      OnClick = SpeedButton1Click
    end
    object URLED: TEdit
      Left = 8
      Top = 64
      Width = 625
      Height = 24
      TabOrder = 0
      Text = 'http://nucloweb.jinr.ru/kgu/Cache/get_data.php?callback=?'
    end
    object BitBtn1: TBitBtn
      Left = 792
      Top = 24
      Width = 75
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 1
      OnClick = Panel1Click
    end
  end
  object Memo2: TMemo
    Left = 0
    Top = 99
    Width = 914
    Height = 91
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 465
  end
  object Chart1: TChart
    Left = 0
    Top = 190
    Width = 914
    Height = 365
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    View3D = False
    Align = alClient
    TabOrder = 2
    ExplicitTop = 360
    ExplicitHeight = 195
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object chartbox: TCheckBox
      Left = 128
      Top = 6
      Width = 97
      Height = 17
      Caption = #1043#1088#1072#1092#1080#1082#1080
      TabOrder = 0
    end
    object Series1: TLineSeries
      SeriesColor = clRed
      Title = 'Min'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TLineSeries
      SeriesColor = clGreen
      Title = 'Max'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series3: TLineSeries
      SeriesColor = clBlue
      Title = 'mean'
      Brush.BackColor = clDefault
      Pointer.HorizSize = 2
      Pointer.InflateMargins = True
      Pointer.Pen.Visible = False
      Pointer.Style = psRectangle
      Pointer.VertSize = 2
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series4: TLineSeries
      SeriesColor = clFuchsia
      Title = 'Updates'
      VertAxis = aRightAxis
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = SpeedButton1Click
    Left = 368
    Top = 128
  end
  object PopupMenu1: TPopupMenu
    Left = 656
    Top = 24
    object terminate1: TMenuItem
      Caption = 'terminate'
      OnClick = terminate1Click
    end
  end
end
