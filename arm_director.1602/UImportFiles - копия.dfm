object FImportFiles: TFImportFiles
  Left = 602
  Top = 225
  BorderStyle = bsDialog
  Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1082#1083#1080#1087#1072
  ClientHeight = 561
  ClientWidth = 905
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 120
  TextHeight = 16
  object Panel2: TPanel
    Left = 0
    Top = 519
    Width = 905
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 709
      Top = 1
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
      Left = 519
      Top = 1
      Width = 185
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
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 905
    Height = 519
    Align = alClient
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object lbClip: TLabel
      Left = 12
      Top = 74
      Width = 259
      Height = 24
      AutoSize = False
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1082#1083#1080#1087#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lbSong: TLabel
      Left = 12
      Top = 111
      Width = 259
      Height = 24
      AutoSize = False
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1089#1085#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lbSinger: TLabel
      Left = 12
      Top = 252
      Width = 259
      Height = 25
      AutoSize = False
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lbDateImpTxt: TLabel
      Left = 12
      Top = 289
      Width = 259
      Height = 25
      AutoSize = False
      Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lbDateEnd: TLabel
      Left = 12
      Top = 326
      Width = 259
      Height = 25
      AutoSize = False
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lbTotalDurTxt: TLabel
      Left = 12
      Top = 363
      Width = 259
      Height = 25
      AutoSize = False
      Caption = #1054#1073#1097#1080#1081' '#1093#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lbNTKTxt: TLabel
      Left = 12
      Top = 400
      Width = 259
      Height = 25
      AutoSize = False
      Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1090#1072#1081#1084#1082#1086#1076':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lbDURTxt: TLabel
      Left = 12
      Top = 437
      Width = 259
      Height = 25
      AutoSize = False
      Caption = #1061#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lbTypeTxt: TLabel
      Left = 12
      Top = 474
      Width = 259
      Height = 24
      AutoSize = False
      Caption = #1058#1080#1087' '#1084#1077#1076#1080#1072'-'#1076#1072#1085#1085#1099#1093
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lbType: TLabel
      Left = 277
      Top = 474
      Width = 123
      Height = 24
      AutoSize = False
      Caption = 'lbType'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object lbDateReg: TLabel
      Left = 277
      Top = 289
      Width = 123
      Height = 25
      AutoSize = False
      Caption = 'lbDateReg'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object lbTotalDur: TLabel
      Left = 277
      Top = 363
      Width = 123
      Height = 25
      AutoSize = False
      Caption = 'lbTotalDur'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object lbNTK: TLabel
      Left = 277
      Top = 400
      Width = 123
      Height = 25
      AutoSize = False
      Caption = 'lbNTK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object lbDur: TLabel
      Left = 277
      Top = 437
      Width = 123
      Height = 25
      AutoSize = False
      Caption = 'lbDur'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Bevel1: TBevel
      Left = 578
      Top = 69
      Width = 308
      Height = 433
      Shape = bsFrame
    end
    object Label15: TLabel
      Left = 581
      Top = 70
      Width = 301
      Height = 427
      Alignment = taCenter
      AutoSize = False
      Caption = 'Label15'
      WordWrap = True
    end
    object lbFile: TLabel
      Left = 12
      Top = 4
      Width = 875
      Height = 56
      Alignment = taCenter
      AutoSize = False
      Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1091#1077#1084#1099#1081' '#1092#1072#1081#1083
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object Label1: TLabel
      Left = 12
      Top = 148
      Width = 259
      Height = 24
      AutoSize = False
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object edClip: TEdit
      Left = 277
      Top = 74
      Width = 287
      Height = 26
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = 'edClip'
    end
    object edSong: TEdit
      Left = 277
      Top = 111
      Width = 287
      Height = 26
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      Text = 'edSong'
    end
    object edSinger: TEdit
      Left = 277
      Top = 252
      Width = 287
      Height = 26
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      Text = 'edSinger'
    end
    object dtpDateEnd: TDateTimePicker
      Left = 277
      Top = 325
      Width = 123
      Height = 28
      BevelEdges = [beTop, beRight, beBottom]
      BevelInner = bvNone
      BevelOuter = bvNone
      BevelKind = bkFlat
      Date = 42640.938928194450000000
      Time = 42640.938928194450000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object mmComment: TMemo
      Left = 277
      Top = 148
      Width = 287
      Height = 96
      Ctl3D = False
      Lines.Strings = (
        'mmComment')
      ParentCtl3D = False
      TabOrder = 4
    end
  end
  object Panel1: TPanel
    Left = 480
    Top = 184
    Width = 297
    Height = 233
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 297
      Height = 64
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1077': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object mmMistakes: TMemo
      Left = 0
      Top = 64
      Width = 297
      Height = 169
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'mmMistakes')
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      #1060#1072#1081#1083#1099' '#1084#1091#1083#1100#1090#1080#1084#1077#1076#1080#1072'|*.mp3;*.wma;*.wav;*.vob;*.avi;*.mpg;*.mp4;*.mo' +
      'v;*.mpeg;*.flv;*.wmv;*.qt;|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Title = #1054#1090#1082#1088#1099#1090#1080#1077' '#1084#1091#1083#1100#1090#1080#1084#1077#1076#1080#1072' '#1092#1072#1081#1083#1086#1074
    Left = 304
    Top = 16
  end
end
