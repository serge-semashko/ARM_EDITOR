object Form1: TForm1
  Left = 208
  Top = 117
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = #1040#1056#1052' '#1056#1077#1078#1080#1089#1089#1077#1088#1072
  ClientHeight = 360
  ClientWidth = 638
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  StyleElements = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 144
    Top = 296
    Width = 97
    Height = 22
    Caption = #1057#1090#1072#1088#1090
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 264
    Top = 296
    Width = 97
    Height = 22
    Caption = #1057#1090#1086#1087
    OnClick = SpeedButton2Click
  end
  object Label1: TLabel
    Left = 48
    Top = 40
    Width = 193
    Height = 24
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton3: TSpeedButton
    Left = 448
    Top = 296
    Width = 89
    Height = 22
    Caption = 'Load'
    OnClick = SpeedButton3Click
  end
  object Label2: TLabel
    Left = 48
    Top = 70
    Width = 65
    Height = 13
    AutoSize = False
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 48
    Top = 96
    Width = 65
    Height = 13
    AutoSize = False
    Caption = 'Label3'
  end
  object Label4: TLabel
    Left = 272
    Top = 40
    Width = 177
    Height = 24
    AutoSize = False
    Caption = 'Label4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 48
    Top = 128
    Width = 417
    Height = 129
    Lines.Strings = (
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      '')
    TabOrder = 0
  end
  object ApplicationEvents1: TApplicationEvents
    Left = 589
    Top = 64
  end
  object OpenDialog1: TOpenDialog
    Left = 501
    Top = 72
  end
  object Timer1: TTimer
    Interval = 80
    Left = 593
    Top = 8
  end
  object OpenDialog2: TOpenDialog
    Filter = #39#1060#1072#1081#1083' '#1089#1091#1073#1090#1080#1090#1088#1086#1074#39'|*.srt|'#39#1042#1089#1077' '#1092#1072#1081#1083#1099#39'|*.*'
    Left = 508
    Top = 8
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 250
    Left = 554
    Top = 9
  end
  object SaveDialog1: TSaveDialog
    Left = 585
    Top = 120
  end
end
