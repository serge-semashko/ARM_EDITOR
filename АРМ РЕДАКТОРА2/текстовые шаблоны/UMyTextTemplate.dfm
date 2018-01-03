object frMyTextTemplate: TfrMyTextTemplate
  Left = 359
  Top = 124
  Width = 938
  Height = 636
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1090#1077#1082#1089#1090#1086#1074#1099#1093' '#1096#1072#1073#1083#1086#1085#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 498
    Width = 922
    Height = 100
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    object Bevel1: TBevel
      Left = 198
      Top = 3
      Width = 51
      Height = 29
      Shape = bsFrame
    end
    object SpeedButton1: TSpeedButton
      Left = 15
      Top = 66
      Width = 121
      Height = 30
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnClick = SpeedButton1Click
    end
    object Label1: TLabel
      Left = 155
      Top = 120
      Width = 53
      Height = 13
      AutoSize = False
      Visible = False
    end
    object Label2: TLabel
      Left = 16
      Top = 37
      Width = 149
      Height = 16
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1090#1086#1083#1073#1094#1086#1074': '
    end
    object Label3: TLabel
      Left = 201
      Top = 4
      Width = 43
      Height = 25
      AutoSize = False
      Layout = tlCenter
    end
    object SpeedButton2: TSpeedButton
      Left = 138
      Top = 66
      Width = 121
      Height = 30
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 263
      Top = 66
      Width = 231
      Height = 30
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnClick = SpeedButton3Click
    end
    object Label4: TLabel
      Left = 16
      Top = 8
      Width = 137
      Height = 16
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1087#1080#1089#1082#1086#1074':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 261
      Top = 16
      Width = 108
      Height = 17
      Caption = #1058#1077#1082#1091#1097#1080#1081' '#1089#1087#1080#1089#1086#1082':'
    end
    object SpeedButton4: TSpeedButton
      Left = 536
      Top = 16
      Width = 97
      Height = 65
      OnClick = SpeedButton4Click
    end
    object SpeedButton6: TSpeedButton
      Left = 744
      Top = 16
      Width = 160
      Height = 33
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnClick = SpeedButton6Click
    end
    object SpeedButton7: TSpeedButton
      Left = 744
      Top = 56
      Width = 160
      Height = 33
      Caption = #1042#1099#1093#1086#1076
      OnClick = SpeedButton7Click
    end
    object SpinEdit1: TSpinEdit
      Left = 198
      Top = 35
      Width = 50
      Height = 26
      Ctl3D = False
      MaxValue = 9
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 0
      Value = 1
      OnChange = SpinEdit1Change
      OnKeyPress = SpinEdit1KeyPress
      OnKeyUp = SpinEdit1KeyUp
    end
    object ComboBox1: TComboBox
      Left = 260
      Top = 36
      Width = 234
      Height = 24
      BevelInner = bvLowered
      BevelKind = bkFlat
      Style = csDropDownList
      Ctl3D = False
      ItemHeight = 16
      ParentCtl3D = False
      TabOrder = 1
      OnChange = ComboBox1Change
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 922
    Height = 398
    Align = alClient
    BevelOuter = bvLowered
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 398
    Width = 922
    Height = 100
    Align = alBottom
    TabOrder = 2
    Visible = False
    object SpeedButton5: TSpeedButton
      Left = 504
      Top = 56
      Width = 23
      Height = 22
      OnClick = SpeedButton5Click
    end
    object SpeedButton8: TSpeedButton
      Left = 744
      Top = 53
      Width = 160
      Height = 33
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton8Click
    end
    object SpeedButton9: TSpeedButton
      Left = 576
      Top = 53
      Width = 160
      Height = 33
      Caption = #1042#1099#1093#1086#1076
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton9Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 14
      Width = 905
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
end
