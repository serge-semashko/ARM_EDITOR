object FButtonOptions: TFButtonOptions
  Left = 575
  Top = 244
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1082#1085#1086#1087#1082#1080
  ClientHeight = 139
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 14
    Width = 95
    Height = 16
    Caption = #1053#1086#1084#1077#1088' '#1082#1085#1086#1087#1082#1080':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbNumber: TLabel
    Left = 162
    Top = 13
    Width = 91
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 15
    Top = 43
    Width = 118
    Height = 16
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1082#1085#1086#1087#1082#1080':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 160
    Top = 69
    Width = 97
    Height = 27
  end
  object Image1: TImage
    Left = 162
    Top = 71
    Width = 92
    Height = 23
    OnClick = Image1Click
  end
  object Label2: TLabel
    Left = 15
    Top = 72
    Width = 81
    Height = 16
    Caption = #1062#1074#1077#1090' '#1082#1085#1086#1087#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 160
    Top = 10
    Width = 97
    Height = 25
  end
  object Panel1: TPanel
    Left = 0
    Top = 98
    Width = 277
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 143
      Top = 7
      Width = 125
      Height = 30
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 7
      Top = 7
      Width = 125
      Height = 30
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
  end
  object Edit1: TEdit
    Left = 160
    Top = 40
    Width = 97
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Text = 'Edit1'
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen]
    Left = 128
    Top = 8
  end
end
