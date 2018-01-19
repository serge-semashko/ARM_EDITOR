object FEditTimeline: TFEditTimeline
  Left = 266
  Top = 235
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'FEditTimeline'
  ClientHeight = 416
  ClientWidth = 773
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 773
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 15
      Width = 154
      Height = 20
      Caption = #1058#1080#1087' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SpeedButton6: TSpeedButton
      Left = 480
      Top = 12
      Width = 257
      Height = 30
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1103
      Flat = True
      OnClick = SpeedButton6Click
    end
    object ComboBox1: TComboBox
      Left = 176
      Top = 11
      Width = 154
      Height = 28
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvRaised
      Style = csDropDownList
      Color = clBtnFace
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 20
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      OnChange = ComboBox1Change
      Items.Strings = (
        #1059#1089#1090#1088#1086#1081#1089#1090#1074#1072
        #1058#1077#1082#1089#1090
        #1052#1077#1076#1080#1072)
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 361
    Width = 773
    Height = 55
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 581
      Top = 10
      Width = 185
      Height = 37
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 388
      Top = 10
      Width = 184
      Height = 37
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object Image2: TImage
      Left = 20
      Top = 15
      Width = 316
      Height = 37
      OnMouseUp = Image2MouseUp
    end
    object Label7: TLabel
      Left = 20
      Top = -2
      Width = 267
      Height = 16
      Caption = #1057#1080#1084#1074#1086#1083#1100#1085#1086#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1080':'
    end
  end
  object pnDevice: TPanel
    Left = 20
    Top = 69
    Width = 690
    Height = 287
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object Label2: TLabel
      Left = 6
      Top = 65
      Width = 87
      Height = 20
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Image1: TImage
      Left = 325
      Top = 0
      Width = 365
      Height = 287
      Align = alRight
      OnMouseMove = Image1MouseMove
      OnMouseUp = Image1MouseUp
    end
    object Label3: TLabel
      Left = 6
      Top = 103
      Width = 196
      Height = 20
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091#1089#1090#1088#1086#1081#1089#1090#1074':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 0
      Top = 242
      Width = 316
      Height = 41
      Shape = bsFrame
      Style = bsRaised
    end
    object SpeedButton3: TSpeedButton
      Left = 68
      Top = 249
      Width = 80
      Height = 27
      Caption = '+ T'#1077#1082#1089#1090
      Flat = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 150
      Top = 249
      Width = 80
      Height = 27
      Caption = '- '#1058#1077#1082#1089#1090
      Flat = True
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 233
      Top = 249
      Width = 80
      Height = 27
      Caption = #1053#1086#1084#1077#1088#1072
      Flat = True
      OnClick = SpeedButton5Click
    end
    object Edit1: TEdit
      Left = 122
      Top = 64
      Width = 199
      Height = 26
      BevelInner = bvNone
      BevelOuter = bvRaised
      Color = clBtnFace
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = 'Edit1'
    end
    object SpinEdit1: TSpinEdit
      Left = 245
      Top = 101
      Width = 74
      Height = 31
      Color = clBtnFace
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 32
      MinValue = 1
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      Value = 1
      OnChange = SpinEdit1Change
    end
    object Edit2: TEdit
      Left = 6
      Top = 251
      Width = 60
      Height = 26
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object pnDelete: TPanel
    Left = 364
    Top = 148
    Width = 405
    Height = 99
    BevelOuter = bvNone
    Caption = 'pnDelete'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    object Label4: TLabel
      Left = 0
      Top = 0
      Width = 405
      Height = 99
      Align = alClient
      Alignment = taCenter
      Caption = 'Label4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
  end
  object pnText: TPanel
    Left = 16
    Top = 56
    Width = 607
    Height = 273
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    object Label8: TLabel
      Left = 20
      Top = 90
      Width = 266
      Height = 16
      Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1076#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1089#1086#1073#1099#1090#1080#1103': '
    end
    object Label9: TLabel
      Left = 20
      Top = 170
      Width = 96
      Height = 16
      Caption = #1062#1074#1077#1090' '#1089#1086#1073#1099#1090#1080#1103
    end
    object Label10: TLabel
      Left = 439
      Top = 90
      Width = 48
      Height = 16
      Caption = #1082#1072#1076#1088#1086#1074
    end
    object Label11: TLabel
      Left = 20
      Top = 130
      Width = 282
      Height = 16
      Caption = #1059#1089#1088#1077#1076#1085#1105#1085#1085#1072#1103' '#1076#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1086#1076#1085#1086#1081' '#1073#1091#1082#1074#1099':'
    end
    object Label12: TLabel
      Left = 20
      Top = 50
      Width = 70
      Height = 16
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
    end
    object Label13: TLabel
      Left = 441
      Top = 130
      Width = 33
      Height = 16
      Caption = #1084#1089#1077#1082
    end
    object Bevel2: TBevel
      Left = 345
      Top = 167
      Width = 90
      Height = 30
      Shape = bsFrame
    end
    object Image3: TImage
      Left = 347
      Top = 169
      Width = 83
      Height = 25
    end
    object sbTextEvent: TSpeedButton
      Left = 23
      Top = 214
      Width = 322
      Height = 30
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1089#1086#1073#1099#1090#1080#1103
      Flat = True
      OnClick = sbTextEventClick
    end
    object SpinEdit2: TSpinEdit
      Left = 344
      Top = 88
      Width = 90
      Height = 26
      MaxValue = 600
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
    object Edit3: TEdit
      Left = 344
      Top = 48
      Width = 305
      Height = 22
      TabOrder = 0
      Text = #1058#1077#1082#1089#1090
    end
    object SpinEdit3: TSpinEdit
      Left = 345
      Top = 128
      Width = 90
      Height = 26
      Increment = 10
      MaxValue = 1000
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
  object pnMedia: TPanel
    Left = 546
    Top = 56
    Width = 617
    Height = 273
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    object Label5: TLabel
      Left = 20
      Top = 80
      Width = 70
      Height = 16
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077';'
    end
    object Label6: TLabel
      Left = 20
      Top = 120
      Width = 124
      Height = 16
      Caption = #1062#1074#1077#1090' '#1090#1072#1081#1084'-'#1083#1080#1085#1080#1080':'
    end
    object Bevel3: TBevel
      Left = 243
      Top = 115
      Width = 94
      Height = 25
      Shape = bsFrame
    end
    object Image4: TImage
      Left = 248
      Top = 120
      Width = 73
      Height = 17
      OnClick = Image4Click
    end
    object SpeedButton7: TSpeedButton
      Left = 24
      Top = 152
      Width = 273
      Height = 31
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1089#1086#1073#1099#1090#1080#1103
      Flat = True
      OnClick = SpeedButton7Click
    end
    object Edit4: TEdit
      Left = 241
      Top = 77
      Width = 369
      Height = 22
      TabOrder = 0
      Text = 'Media'
    end
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen]
    Left = 392
    Top = 8
  end
end
