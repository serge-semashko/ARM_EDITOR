object FNewProject: TFNewProject
  Left = 503
  Top = 217
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1055#1088#1086#1077#1082#1090
  ClientHeight = 231
  ClientWidth = 569
  Color = clBackground
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 1
    Top = 21
    Width = 179
    Height = 20
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 26
    Top = 65
    Width = 158
    Height = 20
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 47
    Top = 110
    Width = 133
    Height = 20
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 436
    Top = 187
    Width = 129
    Height = 33
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 302
    Top = 187
    Width = 129
    Height = 36
    Caption = #1054#1090#1084#1077#1085#1072
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object Edit1: TEdit
    Left = 178
    Top = 20
    Width = 388
    Height = 28
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
  end
  object DateTimePicker1: TDateTimePicker
    Left = 178
    Top = 60
    Width = 388
    Height = 28
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BevelKind = bkFlat
    Date = 42594.480064907410000000
    Time = 42594.480064907410000000
    DateFormat = dfLong
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 178
    Top = 102
    Width = 388
    Height = 70
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 2
  end
end
