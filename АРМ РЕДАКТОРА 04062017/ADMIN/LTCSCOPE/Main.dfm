object Form1: TForm1
  Left = 419
  Top = 231
  Width = 1412
  Height = 698
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object PaintBox1: TPaintBox
    Left = 8
    Top = 20
    Width = 1377
    Height = 218
  end
  object Label1: TLabel
    Left = 612
    Top = 2
    Width = 41
    Height = 16
    Caption = 'Label1'
    Visible = False
  end
  object Label2: TLabel
    Left = 8
    Top = 248
    Width = 657
    Height = 97
    Alignment = taCenter
    AutoSize = False
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1091'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Button1: TButton
    Left = 451
    Top = 381
    Width = 92
    Height = 31
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 555
    Top = 381
    Width = 92
    Height = 31
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 672
    Top = 248
    Width = 233
    Height = 369
    Lines.Strings = (
      'Memo1')
    MaxLength = -1
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 383
    Width = 345
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1092#1086#1088#1084#1091' '#1089#1080#1075#1085#1072#1083#1072
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 24
    Top = 405
    Width = 353
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1089#1077' '#1086#1090#1089#1095#1077#1090#1099
    TabOrder = 4
  end
  object CheckBox3: TCheckBox
    Left = 24
    Top = 360
    Width = 417
    Height = 17
    Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1079#1072#1087#1091#1089#1082#1072#1090#1100' '#1087#1088#1080' '#1079#1072#1075#1088#1091#1079#1082#1077' Windows'
    Checked = True
    State = cbChecked
    TabOrder = 5
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
