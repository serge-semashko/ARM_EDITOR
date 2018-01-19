object frSetEventData: TfrSetEventData
  Left = 551
  Top = 390
  BorderStyle = bsDialog
  ClientHeight = 164
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 120
  TextHeight = 16
  object SpeedButton1: TSpeedButton
    Left = 440
    Top = 116
    Width = 200
    Height = 33
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 241
    Top = 116
    Width = 200
    Height = 33
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    Flat = True
    OnClick = SpeedButton2Click
  end
  object Label1: TLabel
    Left = 8
    Top = 0
    Width = 633
    Height = 49
    Align = alCustom
    AutoSize = False
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Layout = tlBottom
  end
  object Label2: TLabel
    Left = 8
    Top = 96
    Width = 225
    Height = 49
    AutoSize = False
    Caption = 'Label2'
  end
  object Edit1: TEdit
    Left = 8
    Top = 60
    Width = 385
    Height = 33
    AutoSize = False
    BevelInner = bvNone
    BevelKind = bkTile
    BevelOuter = bvNone
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Text = 'Edit1'
  end
  object ComboBox1: TComboBox
    Left = 312
    Top = 60
    Width = 329
    Height = 33
    BevelInner = bvNone
    BevelOuter = bvNone
    Style = csDropDownList
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 25
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
  end
  object SpinEdit1: TSpinEdit
    Left = 128
    Top = 56
    Width = 121
    Height = 36
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxValue = 0
    MinValue = 0
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Value = 0
    OnChange = SpinEdit1Change
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 120
    Width = 193
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 3
    Visible = False
  end
end
