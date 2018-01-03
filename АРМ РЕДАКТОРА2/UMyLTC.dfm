object frLTC: TfrLTC
  Left = 192
  Top = 146
  BorderStyle = bsDialog
  Caption = #1056#1077#1078#1080#1084' '#1089#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1080
  ClientHeight = 202
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 16
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 171
    Width = 163
    Height = 24
    Caption = #1054#1090#1084#1077#1085#1072
    Flat = True
    StyleElements = []
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 184
    Top = 171
    Width = 162
    Height = 24
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
    Flat = True
    StyleElements = []
    OnClick = SpeedButton2Click
  end
  object Label2: TLabel
    Left = 28
    Top = 130
    Width = 192
    Height = 16
    Caption = #1042#1088#1077#1084#1103' '#1089#1090#1072#1088#1090#1072' (HH:MM:SS:FF)'
    StyleElements = []
  end
  object CheckBox1: TCheckBox
    Left = 33
    Top = 20
    Width = 312
    Height = 20
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1102' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    StyleElements = []
    OnClick = CheckBox1Click
  end
  object RadioButton1: TRadioButton
    Left = 33
    Top = 58
    Width = 319
    Height = 14
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1080#1089#1090#1077#1084#1085#1086#1077' '#1074#1088#1077#1084#1103' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    StyleElements = []
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 32
    Top = 91
    Width = 326
    Height = 14
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1085#1077#1096#1085#1080#1081' '#1090#1072#1081#1084'-'#1082#1086#1076' LTC '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    StyleElements = []
    OnClick = RadioButton2Click
  end
  object Edit1: TEdit
    Left = 234
    Top = 124
    Width = 98
    Height = 26
    AutoSize = False
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 11
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = '00:00:00:00'
    StyleElements = []
    OnKeyDown = Edit1KeyDown
    OnKeyPress = Edit1KeyPress
  end
end
