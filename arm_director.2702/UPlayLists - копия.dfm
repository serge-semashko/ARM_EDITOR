object FPlayLists: TFPlayLists
  Left = 335
  Top = 249
  BorderStyle = bsDialog
  Caption = #1055#1083#1077#1081'-'#1083#1080#1089#1090
  ClientHeight = 286
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 120
  TextHeight = 20
  object Label1: TLabel
    Left = 10
    Top = 30
    Width = 87
    Height = 20
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Label2: TLabel
    Left = 10
    Top = 80
    Width = 142
    Height = 20
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
  end
  object Label3: TLabel
    Left = 10
    Top = 130
    Width = 120
    Height = 20
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
  end
  object edNamePL: TEdit
    Left = 165
    Top = 30
    Width = 400
    Height = 26
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 240
    Width = 581
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 404
      Top = 2
      Width = 160
      Height = 35
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 232
      Top = 2
      Width = 160
      Height = 35
      Caption = #1054#1090#1084#1077#1085#1072
      Flat = True
      OnClick = SpeedButton2Click
    end
  end
  object dtpEndDate: TDateTimePicker
    Left = 165
    Top = 80
    Width = 400
    Height = 28
    BevelInner = bvNone
    BevelOuter = bvNone
    BevelKind = bkFlat
    Date = 42650.836373958340000000
    Time = 42650.836373958340000000
    TabOrder = 2
  end
  object mmCommentPL: TMemo
    Left = 165
    Top = 130
    Width = 400
    Height = 89
    BevelInner = bvNone
    BevelKind = bkFlat
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
  end
end
