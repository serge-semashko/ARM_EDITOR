object frNewUser: TfrNewUser
  Left = 585
  Top = 323
  BorderStyle = bsDialog
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  ClientHeight = 300
  ClientWidth = 511
  Color = clInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 10
    Top = 23
    Width = 160
    Height = 30
    AutoSize = False
    Caption = '*'#1060#1072#1084#1080#1083#1080#1103
    StyleElements = []
  end
  object Label2: TLabel
    Left = 10
    Top = 58
    Width = 160
    Height = 30
    AutoSize = False
    Caption = '*'#1048#1084#1103
    StyleElements = []
  end
  object Label3: TLabel
    Left = 10
    Top = 93
    Width = 160
    Height = 30
    AutoSize = False
    Caption = #1054#1090#1095#1077#1089#1090#1086#1074#1086
    StyleElements = []
  end
  object Label4: TLabel
    Left = 10
    Top = 128
    Width = 160
    Height = 30
    AutoSize = False
    Caption = #1050#1086#1088#1086#1090#1082#1086#1077' '#1080#1084#1103
    StyleElements = []
  end
  object Label5: TLabel
    Left = 10
    Top = 163
    Width = 160
    Height = 30
    AutoSize = False
    Caption = '*'#1051#1086#1075#1080#1085
    StyleElements = []
  end
  object Label6: TLabel
    Left = 10
    Top = 198
    Width = 160
    Height = 30
    AutoSize = False
    Caption = #1055#1072#1088#1086#1083#1100
    StyleElements = []
  end
  object SpeedButton1: TSpeedButton
    Left = 15
    Top = 260
    Width = 240
    Height = 33
    Caption = #1054#1090#1084#1077#1085#1072
    Flat = True
    StyleElements = []
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 255
    Top = 260
    Width = 240
    Height = 33
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Flat = True
    StyleElements = []
    OnClick = SpeedButton2Click
  end
  object Label7: TLabel
    Left = 8
    Top = 230
    Width = 495
    Height = 26
    Alignment = taCenter
    AutoSize = False
    Caption = '* '#1055#1086#1083#1103' '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1077' '#1076#1083#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103
    Layout = tlCenter
  end
  object edFamily: TEdit
    Left = 184
    Top = 20
    Width = 313
    Height = 22
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    StyleElements = []
  end
  object edName: TEdit
    Left = 184
    Top = 55
    Width = 313
    Height = 22
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    StyleElements = []
  end
  object edSubname: TEdit
    Left = 184
    Top = 90
    Width = 313
    Height = 22
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    StyleElements = []
  end
  object edShortName: TEdit
    Left = 184
    Top = 125
    Width = 313
    Height = 22
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    StyleElements = []
  end
  object edLogin: TEdit
    Left = 184
    Top = 160
    Width = 313
    Height = 22
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    StyleElements = []
  end
  object edPassword: TEdit
    Left = 184
    Top = 195
    Width = 313
    Height = 22
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    StyleElements = []
  end
end
