object Form1: TForm1
  Left = 419
  Top = 231
  Width = 938
  Height = 475
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 7
    Top = 16
    Width = 533
    Height = 177
  end
  object Label1: TLabel
    Left = 497
    Top = 2
    Width = 32
    Height = 13
    Caption = 'Label1'
    Visible = False
  end
  object Label2: TLabel
    Left = 7
    Top = 202
    Width = 533
    Height = 78
    Alignment = taCenter
    AutoSize = False
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1091'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object SpeedButton1: TSpeedButton
    Left = 144
    Top = 360
    Width = 113
    Height = 25
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1058#1057
    OnClick = SpeedButton1Click
  end
  object Button1: TButton
    Left = 366
    Top = 310
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 451
    Top = 310
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 546
    Top = 13
    Width = 189
    Height = 332
    Lines.Strings = (
      'Memo1')
    MaxLength = -1
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 20
    Top = 311
    Width = 280
    Height = 14
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1092#1086#1088#1084#1091' '#1089#1080#1075#1085#1072#1083#1072
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 20
    Top = 329
    Width = 286
    Height = 14
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1089#1077' '#1086#1090#1089#1095#1077#1090#1099
    TabOrder = 4
  end
  object CheckBox3: TCheckBox
    Left = 20
    Top = 293
    Width = 338
    Height = 13
    Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1079#1072#1087#1091#1089#1082#1072#1090#1100' '#1087#1088#1080' '#1079#1072#1075#1088#1091#1079#1082#1077' Windows'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object Edit1: TEdit
    Left = 24
    Top = 360
    Width = 113
    Height = 21
    TabOrder = 6
    Text = '00:00:00:00'
  end
  object CheckBox4: TCheckBox
    Left = 288
    Top = 368
    Width = 97
    Height = 17
    Caption = 'CheckBox4'
    TabOrder = 7
  end
  object PopupMenu1: TPopupMenu
    Left = 488
    Top = 136
    object RestoreItem: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1086#1082#1085#1086' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      OnClick = RestoreItemClick
    end
    object N1: TMenuItem
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
    end
    object FileExitItem1: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084#1091
      OnClick = FileExitItem1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object HideItem: TMenuItem
      Caption = #1057#1074#1077#1088#1085#1091#1090#1100' '#1086#1082#1085#1086' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      OnClick = HideItemClick
    end
  end
end
