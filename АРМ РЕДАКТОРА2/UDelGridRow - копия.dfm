object FDelGridRow: TFDelGridRow
  Left = 444
  Top = 195
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1059#1076#1072#1083#1080#1090#1100
  ClientHeight = 258
  ClientWidth = 676
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 208
    Width = 676
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    Color = clBackground
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 492
      Top = 5
      Width = 173
      Height = 39
      Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 315
      Top = 5
      Width = 172
      Height = 39
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
  end
  object pnChoiseDel: TPanel
    Left = 354
    Top = 128
    Width = 317
    Height = 73
    BevelOuter = bvNone
    TabOrder = 1
    object RadioGroup1: TRadioGroup
      Left = 0
      Top = 0
      Width = 317
      Height = 73
      Align = alClient
      Color = clBackground
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Items.Strings = (
        #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1088#1086#1077#1082#1090
        #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1077' '#1087#1088#1086#1077#1082#1090#1099
        #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1086#1077#1082#1090#1099' '#1076#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1082#1086#1090#1086#1088#1099#1093' '#1084#1077#1085#1100#1096#1077' '#1079#1072#1076#1072#1085#1085#1086#1081
        #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1086#1077#1082#1090#1099' '#1076#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1082#1086#1090#1086#1088#1099#1093' '#1084#1077#1085#1100#1096#1077' '#1079#1072#1076#1072#1085#1085#1086#1081' ')
      ParentColor = False
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
    end
  end
  object pnDate: TPanel
    Left = 167
    Top = 20
    Width = 494
    Height = 178
    TabOrder = 2
    OnResize = pnDateResize
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 134
      Height = 176
      Align = alLeft
      Alignment = taRightJustify
      Caption = #1042#1099#1073#1080#1088#1077#1090#1077' '#1076#1072#1090#1091':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object DateTimePicker1: TDateTimePicker
      Left = 276
      Top = 89
      Width = 218
      Height = 28
      BevelInner = bvNone
      BevelOuter = bvNone
      BevelKind = bkTile
      CalColors.TextColor = clBlack
      Date = 42597.500822303240000000
      Time = 42597.500822303240000000
      DateFormat = dfLong
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object pnLabel: TPanel
    Left = -34
    Top = 161
    Width = 444
    Height = 120
    BevelOuter = bvNone
    TabOrder = 3
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 444
      Height = 120
      Align = alClient
      Alignment = taCenter
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
  end
  object pnList: TPanel
    Left = 20
    Top = 59
    Width = 346
    Height = 149
    BevelOuter = bvNone
    Caption = 'pnList'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 346
      Height = 38
      Align = alTop
      AutoSize = False
      Caption = '   '#1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1077' c'#1083#1077#1076#1091#1102#1097#1080#1077' '#1079#1072#1087#1080#1089#1080' '#1085#1077' '#1073#1091#1076#1091#1090' '#1091#1076#1072#1083#1077#1085#1099':'
      Color = clBackground
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Bevel1: TBevel
      Left = 0
      Top = 38
      Width = 346
      Height = 3
      Align = alTop
      Shape = bsBottomLine
      Style = bsRaised
    end
    object RichEdit1: TRichEdit
      Left = 0
      Top = 41
      Width = 346
      Height = 108
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBackground
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'RichEdit1')
      ParentFont = False
      TabOrder = 0
    end
  end
end
