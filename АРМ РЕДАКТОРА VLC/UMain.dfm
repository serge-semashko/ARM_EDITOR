object Form1: TForm1
  Left = 208
  Top = 117
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = #1040#1056#1052' '#1056#1077#1078#1080#1089#1089#1077#1088#1072
  ClientHeight = 880
  ClientWidth = 1455
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  StyleElements = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PanelControl: TPanel
    Left = 0
    Top = 0
    Width = 1455
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object Bevel6: TBevel
      Left = 0
      Top = 33
      Width = 1455
      Height = 2
      Align = alBottom
      Shape = bsBottomLine
      Style = bsRaised
      ExplicitWidth = 1457
    end
    object PanelControlBtns: TPanel
      Left = 0
      Top = 0
      Width = 289
      Height = 33
      Align = alLeft
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object sbProject: TSpeedButton
        Left = 0
        Top = 0
        Width = 96
        Height = 33
        Caption = #1055#1088#1086#1077#1082#1090
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        OnClick = sbProjectClick
        OnDblClick = sbProjectClick
      end
      object sbClips: TSpeedButton
        Left = 98
        Top = 0
        Width = 99
        Height = 33
        Caption = #1050#1083#1080#1087#1099
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        OnClick = sbClipsClick
        OnDblClick = sbClipsClick
      end
      object sbPlayList: TSpeedButton
        Left = 198
        Top = 0
        Width = 90
        Height = 33
        Caption = #1055#1083#1077#1081'-'#1083#1080#1089#1090
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        StyleElements = []
        OnClick = sbPlayListClick
      end
      object Bevel2: TBevel
        Left = 96
        Top = 1
        Width = 2
        Height = 31
        Shape = bsLeftLine
        Visible = False
      end
      object Bevel3: TBevel
        Left = 197
        Top = 0
        Width = 2
        Height = 32
        Shape = bsLeftLine
        Visible = False
      end
    end
    object PanelControlMode: TPanel
      Left = 1270
      Top = 0
      Width = 185
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      Caption = 'PanelControlMode'
      ShowCaption = False
      TabOrder = 1
      StyleElements = []
      object lbMode: TLabel
        Left = 0
        Top = 0
        Width = 185
        Height = 33
        Align = alClient
        Alignment = taCenter
        Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1082#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
        OnClick = lbModeClick
        OnDblClick = lbModeClick
        ExplicitWidth = 107
        ExplicitHeight = 24
      end
    end
    object PanelControlClip: TPanel
      Left = 289
      Top = 0
      Width = 981
      Height = 33
      Align = alClient
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 2
      StyleElements = []
      object Bevel1: TBevel
        Left = 34
        Top = 2
        Width = 459
        Height = 26
        Shape = bsFrame
        Visible = False
      end
      object Label2: TLabel
        Left = 43
        Top = 4
        Width = 447
        Height = 23
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
        OnClick = Label2Click
      end
      object lbActiveClipID: TLabel
        Left = 541
        Top = 13
        Width = 29
        Height = 13
        AutoSize = False
        Visible = False
        StyleElements = []
      end
      object Bevel5: TBevel
        Left = 2
        Top = 1
        Width = 32
        Height = 31
        Shape = bsFrame
      end
      object Bevel13: TBevel
        Left = 495
        Top = 1
        Width = 32
        Height = 31
        Shape = bsFrame
      end
      object sbPredClip: TSpeedButton
        Left = 3
        Top = 2
        Width = 30
        Height = 29
        Flat = True
        Glyph.Data = {
          A2070000424DA207000000000000360000002800000019000000190000000100
          1800000000006C07000000000000000000000000000000000000C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFF
          FFC3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFF
          FFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFF
          FFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFF
          FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C300C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3
          C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C300}
        StyleElements = []
        OnClick = sbPredClipClick
      end
      object sbNextClip: TSpeedButton
        Left = 496
        Top = 2
        Width = 30
        Height = 29
        Flat = True
        Glyph.Data = {
          A2070000424DA207000000000000360000002800000019000000190000000100
          1800000000006C07000000000000000000000000000000000000C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3
          C3C3FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFF
          FFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFF
          FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFC3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFF
          FFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3FFFF
          FFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3
          C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C300C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C300}
        StyleElements = []
        OnClick = sbNextClipClick
      end
      object LBTimeCode1: TLabel
        Left = 624
        Top = 0
        Width = 169
        Height = 33
        AutoSize = False
        Caption = '00:00:00:00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
    end
  end
  object PanelProject: TPanel
    Left = 0
    Top = 33
    Width = 1134
    Height = 596
    BevelOuter = bvNone
    Caption = #1055#1088#1086#1077#1082#1090
    ShowCaption = False
    TabOrder = 1
    Visible = False
    StyleElements = []
    object Panel6: TPanel
      Left = 288
      Top = 0
      Width = 846
      Height = 596
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel6'
      Ctl3D = False
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object Splitter1: TSplitter
        Left = 0
        Top = 88
        Width = 846
        Height = 5
        Cursor = crVSplit
        Align = alTop
        StyleElements = []
      end
      object Panel10: TPanel
        Left = 0
        Top = 93
        Width = 846
        Height = 503
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel10'
        ShowCaption = False
        TabOrder = 0
        StyleElements = []
        object Panel11: TPanel
          Left = 0
          Top = 0
          Width = 846
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          TabStop = True
          StyleElements = []
          object Label15: TLabel
            Left = 0
            Top = 3
            Width = 846
            Height = 30
            Align = alClient
            Alignment = taCenter
            AutoSize = False
            Caption = #1057#1087#1080#1089#1086#1082' '#1087#1083#1077#1081'-'#1083#1080#1089#1090#1086#1074' '#1087#1088#1086#1077#1082#1090#1072
            Layout = tlCenter
            StyleElements = []
          end
          object Bevel12: TBevel
            Left = 0
            Top = 0
            Width = 846
            Height = 3
            Align = alTop
            Shape = bsTopLine
          end
        end
        object GridLists: TStringGrid
          Left = 0
          Top = 33
          Width = 846
          Height = 420
          Align = alClient
          BorderStyle = bsNone
          Color = clMoneyGreen
          Ctl3D = False
          DrawingStyle = gdsClassic
          FixedCols = 0
          GridLineWidth = 0
          Options = [goFixedHorzLine, goHorzLine, goRowSelect]
          ParentCtl3D = False
          ScrollBars = ssNone
          TabOrder = 1
          StyleElements = []
          OnDblClick = GridListsDblClick
          OnDrawCell = GridListsDrawCell
          OnMouseDown = GridListsMouseDown
          OnMouseUp = GridListsMouseUp
          OnTopLeftChanged = GridListsTopLeftChanged
          ColWidths = (
            64
            64
            64
            64
            64)
          RowHeights = (
            24
            24
            24
            24
            24)
        end
        object Panel24: TPanel
          Left = 0
          Top = 453
          Width = 846
          Height = 50
          Align = alBottom
          BevelOuter = bvNone
          Ctl3D = True
          ParentCtl3D = False
          ShowCaption = False
          TabOrder = 2
          TabStop = True
          StyleElements = []
          object ImgButtonsPL: TImage
            Left = 0
            Top = 0
            Width = 846
            Height = 50
            Align = alClient
            OnMouseMove = ImgButtonsPLMouseMove
            OnMouseUp = ImgButtonsPLMouseUp
            ExplicitLeft = 6
            ExplicitHeight = 55
          end
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 846
        Height = 88
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel5'
        Ctl3D = False
        ParentCtl3D = False
        ShowCaption = False
        TabOrder = 1
        StyleElements = []
        OnResize = Panel5Resize
        object GridProjects: TStringGrid
          Left = 0
          Top = 0
          Width = 846
          Height = 88
          Align = alClient
          BorderStyle = bsNone
          Color = clMoneyGreen
          Ctl3D = False
          DefaultRowHeight = 30
          DrawingStyle = gdsClassic
          FixedCols = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GridLineWidth = 0
          Options = [goFixedHorzLine, goHorzLine, goRowMoving, goRowSelect]
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssNone
          TabOrder = 0
          StyleElements = []
          OnDblClick = GridProjectsDblClick
          OnDrawCell = GridProjectsDrawCell
          OnMouseDown = GridProjectsMouseDown
          OnMouseUp = GridProjectsMouseUp
          OnRowMoved = GridProjectsRowMoved
          OnTopLeftChanged = GridProjectsTopLeftChanged
          ColWidths = (
            64
            64
            64
            64
            64)
          RowHeights = (
            30
            30
            30
            30
            30)
        end
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 288
      Height = 596
      Align = alLeft
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 1
      StyleElements = []
      object imgButtonsProject: TImage
        Left = 0
        Top = 455
        Width = 288
        Height = 141
        Align = alBottom
        OnMouseMove = imgButtonsProjectMouseMove
        OnMouseUp = imgButtonsProjectMouseUp
      end
      object lbProjectName: TLabel
        Left = 0
        Top = 0
        Width = 288
        Height = 65
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = #1055#1088#1086#1077#1082#1090' '#1085#1077' '#1074#1099#1073#1088#1072#1085
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
        StyleElements = []
      end
      object imgButtonsControlProj: TImage
        Left = 0
        Top = 382
        Width = 288
        Height = 68
        Align = alBottom
        OnMouseMove = imgButtonsControlProj1MouseMove
        OnMouseUp = imgButtonsControlProj1MouseUp
      end
      object Bevel7: TBevel
        Left = 0
        Top = 65
        Width = 288
        Height = 5
        Align = alTop
        Shape = bsTopLine
      end
      object Bevel8: TBevel
        Left = 0
        Top = 253
        Width = 288
        Height = 5
        Align = alTop
        Shape = bsBottomLine
        ExplicitTop = 257
      end
      object Bevel9: TBevel
        Left = 0
        Top = 450
        Width = 288
        Height = 5
        Align = alBottom
        Shape = bsBottomLine
        ExplicitTop = 451
      end
      object GridTimeLines: TStringGrid
        Left = -4
        Top = 264
        Width = 286
        Height = 56
        Align = alCustom
        BorderStyle = bsNone
        Color = clBtnFace
        ColCount = 3
        Ctl3D = False
        DefaultRowHeight = 22
        DoubleBuffered = True
        DrawingStyle = gdsClassic
        FixedCols = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        GridLineWidth = 0
        Options = [goRowSelect]
        ParentCtl3D = False
        ParentDoubleBuffered = False
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 0
        StyleElements = []
        OnDblClick = GridTimeLinesDblClick
        OnDrawCell = GridTimeLinesDrawCell
        OnTopLeftChanged = GridTimeLinesTopLeftChanged
        ColWidths = (
          34
          102
          142)
        RowHeights = (
          22
          22
          22
          22
          22)
      end
      object Panel23: TPanel
        Left = 0
        Top = 70
        Width = 288
        Height = 183
        Align = alTop
        BevelOuter = bvNone
        Ctl3D = False
        ParentCtl3D = False
        ShowCaption = False
        TabOrder = 1
        StyleElements = []
        object Label3: TLabel
          Left = 15
          Top = 6
          Width = 120
          Height = 25
          AutoSize = False
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          StyleElements = []
        end
        object lbEditor: TLabel
          Left = 150
          Top = 6
          Width = 125
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Layout = tlCenter
          StyleElements = []
        end
        object Label4: TLabel
          Left = 15
          Top = 33
          Width = 120
          Height = 23
          AutoSize = False
          Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          StyleElements = []
        end
        object Label5: TLabel
          Left = 15
          Top = 58
          Width = 120
          Height = 26
          AutoSize = False
          Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          StyleElements = []
        end
        object lbDateEnd: TLabel
          Left = 150
          Top = 58
          Width = 125
          Height = 25
          Align = alCustom
          Alignment = taCenter
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          StyleElements = []
        end
        object lbDateStart: TLabel
          Left = 150
          Top = 33
          Width = 125
          Height = 25
          Align = alCustom
          Alignment = taCenter
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          StyleElements = []
        end
        object lbpComment: TLabel
          Left = -6
          Top = 109
          Width = 288
          Height = 79
          Align = alCustom
          Alignment = taCenter
          AutoSize = False
          Layout = tlCenter
          WordWrap = True
          StyleElements = []
        end
        object imgBlockProjects: TImage
          Left = 10
          Top = 86
          Width = 26
          Height = 23
          Picture.Data = {
            07544269746D6170A2070000424DA20700000000000036000000280000001900
            00001900000001001800000000006C0700000000000000000000000000000000
            0000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
            E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
            C8E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
            E7BFC8E7BFC80000000000000000000000000000000000000000000000000000
            00000000000000000000000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8
            E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3
            C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000E7BFC8E7
            BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDE
            DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
            DEDEC3C3C3C3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
            C8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7FFF
            FFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BF
            C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDE
            DEDEDEDEDEC3C3C37F7F7FFFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3
            000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FF
            FFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7F7F7F7FC3C3C3FFFFFFDEDEDE
            DEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
            BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7F
            7F7F7FC3C3C3FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BF
            C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDE
            DEDEDEDEDEDEDEDEDEC3C3C37F7F7FFFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDE
            DEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
            000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
            DEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8
            E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFFFFFFDEDEDEDEDEDEDEDEDEDEDE
            DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7
            BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF7F7F7F000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
            C8E7BFC8E7BFC800000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000E7BFC8E7BFC8E7BFC800E7BF
            C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE00
            0000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8
            E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7
            BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000
            FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
            BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8
            E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BF
            C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFF
            DEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE0000
            00E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
            E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BF
            C8000000DEDEDEDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8
            E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BF
            C8E7BFC8E7BFC8E7BFC8E7BFC8000000DEDEDEDEDEDE000000E7BFC8E7BFC8E7
            BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC80000
            00FFFFFFDEDEDEDEDEDE000000000000000000000000000000DEDEDEFFFFFFDE
            DEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
            C8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
            DEDEDEDEDEFFFFFFFFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BF
            C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEDEDE000000E7BFC8E7BFC8
            E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7
            BFC8E7BFC8000000000000000000000000000000000000000000000000000000
            000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
            BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
            E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
            C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
            E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
            C8E7BFC8E7BFC8E7BFC8E7BFC800}
          Stretch = True
          Transparent = True
          OnClick = imgBlockProjectsClick
        end
      end
    end
  end
  object PanelClips: TPanel
    Left = 312
    Top = 104
    Width = 1008
    Height = 745
    ShowCaption = False
    TabOrder = 2
    Visible = False
    StyleElements = []
    object Panel12: TPanel
      Left = 1
      Top = 1
      Width = 248
      Height = 743
      Align = alLeft
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object imgpnlbtnsclips: TImage
        Left = 0
        Top = 592
        Width = 248
        Height = 151
        Align = alBottom
        OnMouseMove = imgpnlbtnsclipsMouseMove
        OnMouseUp = imgpnlbtnsclipsMouseUp
      end
      object lbClip: TLabel
        Left = 8
        Top = 35
        Width = 240
        Height = 55
        Align = alCustom
        AutoSize = False
        Caption = #1050#1083#1080#1087
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        StyleElements = []
      end
      object Label6: TLabel
        Left = 10
        Top = 237
        Width = 90
        Height = 21
        AutoSize = False
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
      object Label9: TLabel
        Left = 10
        Top = 271
        Width = 160
        Height = 20
        AutoSize = False
        Caption = #1061#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078' '#1084#1077#1076#1080#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
      object Label10: TLabel
        Left = 10
        Top = 291
        Width = 160
        Height = 20
        AutoSize = False
        Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1090#1072#1081#1084#1082#1086#1076':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
      object Label11: TLabel
        Left = 10
        Top = 310
        Width = 170
        Height = 20
        AutoSize = False
        Caption = #1061#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
      object Label12: TLabel
        Left = 10
        Top = 331
        Width = 160
        Height = 20
        AutoSize = False
        Caption = #1042#1088#1077#1084#1103' '#1089#1090#1072#1088#1090#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
      object lbClipSinger: TLabel
        Left = 105
        Top = 237
        Width = 131
        Height = 21
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
        StyleElements = []
      end
      object lbClipTotalDur: TLabel
        Left = 185
        Top = 271
        Width = 70
        Height = 20
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
        StyleElements = []
      end
      object lbClipNTK: TLabel
        Left = 185
        Top = 291
        Width = 70
        Height = 20
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
        StyleElements = []
      end
      object lbClipDur: TLabel
        Left = 185
        Top = 310
        Width = 70
        Height = 20
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
        StyleElements = []
      end
      object lbClipType: TLabel
        Left = 185
        Top = 331
        Width = 70
        Height = 20
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
        StyleElements = []
      end
      object lbClipSong: TLabel
        Left = 8
        Top = 95
        Width = 240
        Height = 55
        Align = alCustom
        AutoSize = False
        Caption = #1055#1077#1089#1085#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        StyleElements = []
      end
      object lbClipPath: TLabel
        Left = 10
        Top = 365
        Width = 233
        Height = 62
        AutoSize = False
        Caption = #1060#1072#1081#1083':'
        WordWrap = True
        StyleElements = []
      end
      object lbClipComment: TLabel
        Left = 10
        Top = 155
        Width = 233
        Height = 60
        AutoSize = False
        Caption = '...'
        WordWrap = True
        StyleElements = []
      end
      object Image2: TImage
        Left = 0
        Top = 474
        Width = 25
        Height = 25
        Picture.Data = {
          07544269746D6170A2070000424DA20700000000000036000000280000001900
          00001900000001001800000000006C0700000000000000000000000000000000
          0000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC80000000000000000000000000000000000000000000000000000
          00000000000000000000000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000E7BFC8E7
          BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDE
          DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEDEC3C3C3C3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7FFF
          FFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEC3C3C37F7F7FFFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3
          000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FF
          FFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7F7F7F7FC3C3C3FFFFFFDEDEDE
          DEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
          BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7F
          7F7F7FC3C3C3FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BF
          C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDE
          DEDEDEDEDEDEDEDEDEC3C3C37F7F7FFFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFFFFFFDEDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7
          BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF7F7F7F000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8E7BFC800000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000E7BFC8E7BFC8E7BFC800E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE00
          0000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8
          E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7
          BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000
          FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
          BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BF
          C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFF
          DEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE0000
          00E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8000000DEDEDEDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC8000000DEDEDEDEDEDE000000E7BFC8E7BFC8E7
          BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC80000
          00FFFFFFDEDEDEDEDEDE000000000000000000000000000000DEDEDEFFFFFFDE
          DEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEFFFFFFFFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEDEDE000000E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7
          BFC8E7BFC8000000000000000000000000000000000000000000000000000000
          000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
          BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC800}
        Stretch = True
        Transparent = True
        OnClick = Image2Click
      end
      object Label17: TLabel
        Left = 8
        Top = 440
        Width = 160
        Height = 20
        AutoSize = False
        Caption = #1054#1073#1097#1080#1081' '#1093#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078':'
        Layout = tlCenter
        StyleElements = []
      end
      object lbclipfulldur: TLabel
        Left = 185
        Top = 440
        Width = 70
        Height = 20
        Alignment = taCenter
        AutoSize = False
        Caption = '00:00:00:00'
        Layout = tlCenter
        StyleElements = []
      end
      object Panel26: TPanel
        Left = 0
        Top = 520
        Width = 248
        Height = 72
        Align = alBottom
        BevelOuter = bvNone
        Ctl3D = False
        ParentCtl3D = False
        ShowCaption = False
        TabOrder = 0
        StyleElements = []
        object Bevel10: TBevel
          Left = 0
          Top = 56
          Width = 248
          Height = 16
          Align = alBottom
          Shape = bsBottomLine
        end
        object Bevel11: TBevel
          Left = 0
          Top = 0
          Width = 248
          Height = 9
          Align = alTop
          Shape = bsTopLine
        end
        object Label20: TLabel
          Left = 10
          Top = 16
          Width = 106
          Height = 13
          Caption = #1040#1082#1090#1080#1074#1085#1099#1081' '#1087#1083#1077#1081'-'#1083#1080#1089#1090':'
          StyleElements = []
        end
        object lbclipactpl: TLabel
          Left = 10
          Top = 34
          Width = 233
          Height = 20
          AutoSize = False
          Caption = 'lbclipactpl'
          Layout = tlCenter
          StyleElements = []
        end
      end
    end
    object GridClips: TStringGrid
      Left = 249
      Top = 1
      Width = 758
      Height = 743
      Align = alClient
      BorderStyle = bsNone
      Ctl3D = False
      DefaultRowHeight = 35
      DrawingStyle = gdsClassic
      FixedCols = 0
      Options = [goRowSelect]
      ParentCtl3D = False
      ScrollBars = ssVertical
      TabOrder = 1
      StyleElements = []
      OnDblClick = GridClipsDblClick
      OnDrawCell = GridClipsDrawCell
      OnMouseDown = GridClipsMouseDown
      OnMouseUp = GridClipsMouseUp
      OnSelectCell = GridClipsSelectCell
      OnTopLeftChanged = GridClipsTopLeftChanged
      ColWidths = (
        64
        64
        64
        64
        64)
      RowHeights = (
        35
        35
        35
        35
        35)
    end
  end
  object PanelPlayList: TPanel
    Left = 100
    Top = 177
    Width = 944
    Height = 648
    Align = alCustom
    AutoSize = True
    ShowCaption = False
    TabOrder = 3
    Visible = False
    StyleElements = []
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 312
      Height = 646
      Align = alLeft
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object imgpnlbtnspl: TImage
        Left = 0
        Top = 496
        Width = 312
        Height = 150
        Align = alBottom
        OnMouseMove = imgpnlbtnsplMouseMove
        OnMouseUp = imgpnlbtnsplMouseUp
      end
      object Image1: TImage
        Left = 8
        Top = 472
        Width = 25
        Height = 25
        Picture.Data = {
          07544269746D617076050000424D760500000000000036000000280000001500
          0000150000000100180000000000400500000000000000000000000000000000
          0000C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3
          C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3
          C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300}
        Stretch = True
        Transparent = True
        Visible = False
      end
      object lbPLName: TLabel
        Left = 0
        Top = 617
        Width = 312
        Height = 13
        Align = alTop
        Visible = False
        StyleElements = []
        ExplicitWidth = 3
      end
      object Panel25: TPanel
        Left = 0
        Top = 0
        Width = 312
        Height = 617
        Align = alTop
        BevelOuter = bvNone
        Ctl3D = True
        ParentCtl3D = False
        ShowCaption = False
        TabOrder = 0
        StyleElements = []
        object lbPlayList1: TLabel
          Left = 0
          Top = 0
          Width = 312
          Height = 41
          Align = alTop
          AutoSize = False
          Caption = '   '#1040#1082#1090#1080#1074#1085#1099#1081' '#1087#1083#1077#1081'-'#1083#1080#1089#1090':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlBottom
          WordWrap = True
          StyleElements = []
          ExplicitLeft = -6
        end
        object lbPLCLPComment: TLabel
          Left = 8
          Top = 340
          Width = 296
          Height = 60
          Align = alCustom
          AutoSize = False
          Caption = '...'
          WordWrap = True
          StyleElements = []
        end
        object lbplclip: TLabel
          Left = 8
          Top = 220
          Width = 281
          Height = 55
          AutoSize = False
          Caption = #1050#1083#1080#1087':'
          WordWrap = True
          StyleElements = []
        end
        object Bevel4: TBevel
          Left = 0
          Top = 195
          Width = 313
          Height = 9
          Shape = bsTopLine
        end
        object lbplsong: TLabel
          Left = 10
          Top = 280
          Width = 305
          Height = 55
          AutoSize = False
          Caption = #1055#1077#1089#1085#1103':'
          WordWrap = True
          StyleElements = []
        end
        object lbplsinger: TLabel
          Left = 10
          Top = 407
          Width = 271
          Height = 20
          AutoSize = False
          Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100':'
          Layout = tlCenter
          StyleElements = []
        end
        object Label22: TLabel
          Left = 10
          Top = 457
          Width = 170
          Height = 20
          AutoSize = False
          Caption = #1061#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078' '#1084#1077#1076#1080#1072':'
          Layout = tlCenter
          StyleElements = []
        end
        object Label23: TLabel
          Left = 10
          Top = 477
          Width = 170
          Height = 20
          AutoSize = False
          Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1090#1072#1081#1084'-'#1082#1086#1076':'
          Layout = tlCenter
          StyleElements = []
        end
        object Label24: TLabel
          Left = 10
          Top = 497
          Width = 170
          Height = 20
          AutoSize = False
          Caption = #1061#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103':'
          Layout = tlCenter
          StyleElements = []
        end
        object lbplmdur: TLabel
          Left = 185
          Top = 457
          Width = 80
          Height = 17
          AutoSize = False
          Caption = '00:00:00:00'
          Layout = tlCenter
          StyleElements = []
        end
        object lbplntk: TLabel
          Left = 185
          Top = 477
          Width = 80
          Height = 20
          AutoSize = False
          Caption = '00:00:00:00'
          Layout = tlCenter
          StyleElements = []
        end
        object lbpldur: TLabel
          Left = 185
          Top = 497
          Width = 80
          Height = 17
          AutoSize = False
          Caption = '00:00:00:00'
          Layout = tlCenter
          StyleElements = []
        end
        object Label25: TLabel
          Left = 11
          Top = 155
          Width = 170
          Height = 20
          AutoSize = False
          Caption = #1061#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078' '#1087#1083#1077#1081'-'#1083#1080#1089#1090#1072
          Layout = tlCenter
          StyleElements = []
        end
        object lbplfulldur: TLabel
          Left = 185
          Top = 155
          Width = 85
          Height = 20
          AutoSize = False
          Caption = '00:00:00:00'
          Layout = tlCenter
          StyleElements = []
        end
        object Label27: TLabel
          Left = 10
          Top = 517
          Width = 170
          Height = 20
          AutoSize = False
          Caption = #1042#1088#1077#1084#1103' '#1089#1090#1072#1088#1090#1072':'
          Layout = tlCenter
          StyleElements = []
        end
        object lbplstrt: TLabel
          Left = 185
          Top = 517
          Width = 80
          Height = 20
          AutoSize = False
          Caption = '00:00:00:00'
          Layout = tlCenter
          StyleElements = []
        end
        object lbplfile: TLabel
          Left = 10
          Top = 555
          Width = 273
          Height = 55
          AutoSize = False
          Caption = #1060#1072#1081#1083':'
          WordWrap = True
          StyleElements = []
        end
        object lbplcomment: TLabel
          Left = 10
          Top = 95
          Width = 233
          Height = 47
          AutoSize = False
          Caption = '...'
          StyleElements = []
        end
        object Panel27: TPanel
          Left = 0
          Top = 41
          Width = 312
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel27'
          ShowCaption = False
          TabOrder = 0
          StyleElements = []
          object SpeedButton3: TSpeedButton
            Left = 272
            Top = 0
            Width = 40
            Height = 40
            Align = alRight
            Flat = True
            Glyph.Data = {
              F2060000424DF206000000000000360400002800000019000000190000000100
              080000000000BC02000000000000000000000001000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
              A6000020400000206000002080000020A0000020C0000020E000004000000040
              20000040400000406000004080000040A0000040C0000040E000006000000060
              20000060400000606000006080000060A0000060C0000060E000008000000080
              20000080400000806000008080000080A0000080C0000080E00000A0000000A0
              200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
              200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
              200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
              20004000400040006000400080004000A0004000C0004000E000402000004020
              20004020400040206000402080004020A0004020C0004020E000404000004040
              20004040400040406000404080004040A0004040C0004040E000406000004060
              20004060400040606000406080004060A0004060C0004060E000408000004080
              20004080400040806000408080004080A0004080C0004080E00040A0000040A0
              200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
              200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
              200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
              20008000400080006000800080008000A0008000C0008000E000802000008020
              20008020400080206000802080008020A0008020C0008020E000804000008040
              20008040400080406000804080008040A0008040C0008040E000806000008060
              20008060400080606000806080008060A0008060C0008060E000808000008080
              20008080400080806000808080008080A0008080C0008080E00080A0000080A0
              200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
              200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
              200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
              2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
              2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
              2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
              2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
              2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
              2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
              2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00080808080808
              0808080808080808080808080808080808080800000008080808080808080808
              0808080808080808080808080808080000000808080808080808080808080808
              0808080808080808080808000000080808080808080808080808080808080808
              08080808080808000000080808080808080808080808FFFF0808080808080808
              080808000000080808080808080808080808FFFF080808080808080808080800
              00000808080808080808080808FFFFFFFF080808080808080808080000000808
              080808080808080808FFFFFFFF08080808080808080808000000080808080808
              08080808FFFFFFFFFFFF08080808080808080800000008080808080808080808
              FFFFFFFFFFFF080808080808080808000000080808080808080808FFFFFFFFFF
              FFFFFF0808080808080808000000080808080808080808FFFFFFFFFFFFFFFF08
              080808080808080000000808080808080808FFFFFFFFFFFFFFFFFFFF08080808
              0808080000000808080808080808FFFFFFFFFFFFFFFFFFFF0808080808080800
              000008080808080808FFFFFFFFFFFFFFFFFFFFFFFF0808080808080000000808
              0808080808FFFFFFFFFFFFFFFFFFFFFFFF080808080808000000080808080808
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF0808080808000000080808080808FFFFFFFF
              FFFFFFFFFFFFFFFFFFFF08080808080000000808080808FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFF080808080000000808080808FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF0808080800000008080808FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              0808080000000808080808080808080808080808080808080808080808080800
              0000080808080808080808080808080808080808080808080808080000000808
              0808080808080808080808080808080808080808080808000000080808080808
              08080808080808080808080808080808080808000000}
            OnClick = SpeedButton3Click
          end
          object lbCurrActPL: TLabel
            Left = 0
            Top = 0
            Width = 272
            Height = 40
            Align = alClient
            Alignment = taCenter
            Layout = tlCenter
            OnClick = lbCurrActPLClick
            ExplicitWidth = 3
            ExplicitHeight = 13
          end
        end
        object ListBox1: TListBox
          Left = 139
          Top = 56
          Width = 93
          Height = 33
          Style = lbOwnerDrawFixed
          ItemHeight = 25
          TabOrder = 1
          Visible = False
          OnClick = ListBox1Click
        end
      end
    end
    object GridActPlayList: TStringGrid
      Left = 313
      Top = 1
      Width = 630
      Height = 646
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      DefaultRowHeight = 35
      DrawingStyle = gdsClassic
      FixedCols = 0
      Options = [goRowSelect]
      ParentCtl3D = False
      ScrollBars = ssNone
      TabOrder = 1
      StyleElements = []
      OnDrawCell = GridActPlayListDrawCell
      OnMouseDown = GridActPlayListMouseDown
      OnMouseUp = GridActPlayListMouseUp
      ColWidths = (
        64
        64
        64
        64
        64)
      RowHeights = (
        35
        35
        35
        35
        35)
    end
  end
  object PanelPrepare: TPanel
    Left = 524
    Top = 296
    Width = 923
    Height = 532
    BevelOuter = bvNone
    Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1082#1072
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 4
    Visible = False
    StyleElements = []
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 923
      Height = 341
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object pnPrepareCTL: TPanel
        Left = 0
        Top = 0
        Width = 296
        Height = 341
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'pnPrepareCTL'
        ShowCaption = False
        TabOrder = 0
        StyleElements = []
        object imgCTLPrepare1: TImage
          Left = 0
          Top = 240
          Width = 296
          Height = 101
          Align = alBottom
          OnMouseMove = imgCTLPrepare1MouseMove
          OnMouseUp = imgCTLPrepare1MouseUp
        end
        object pnPrepareSong: TPanel
          Left = 0
          Top = 0
          Width = 296
          Height = 138
          Align = alTop
          BevelOuter = bvNone
          Ctl3D = False
          ParentCtl3D = False
          ShowCaption = False
          TabOrder = 0
          StyleElements = []
          object lbSongName: TLabel
            Left = 64
            Top = 53
            Width = 193
            Height = 38
            AutoSize = False
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1089#1085#1080
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            WordWrap = True
            StyleElements = []
          end
          object lbNomClips: TLabel
            Left = 0
            Top = 5
            Width = 57
            Height = 41
            Alignment = taCenter
            AutoSize = False
            Caption = '...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -23
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            StyleElements = []
          end
          object lbSongSinger: TLabel
            Left = 64
            Top = 96
            Width = 193
            Height = 25
            AutoSize = False
            Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            WordWrap = True
            StyleElements = []
          end
          object lbClipName: TLabel
            Left = 64
            Top = 10
            Width = 185
            Height = 40
            AutoSize = False
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1082#1083#1080#1087#1072
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            WordWrap = True
            StyleElements = []
          end
          object imgSongLock: TImage
            Left = 16
            Top = 92
            Width = 25
            Height = 25
            Picture.Data = {
              07544269746D6170A2070000424DA20700000000000036000000280000001900
              00001900000001001800000000006C0700000000000000000000000000000000
              0000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
              E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
              C8E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
              E7BFC8E7BFC80000000000000000000000000000000000000000000000000000
              00000000000000000000000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8
              E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3
              C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000E7BFC8E7
              BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDE
              DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
              DEDEC3C3C3C3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
              C8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7FFF
              FFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BF
              C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDE
              DEDEDEDEDEC3C3C37F7F7FFFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3
              000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FF
              FFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7F7F7F7FC3C3C3FFFFFFDEDEDE
              DEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
              BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7F
              7F7F7FC3C3C3FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BF
              C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDE
              DEDEDEDEDEDEDEDEDEC3C3C37F7F7FFFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDE
              DEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
              000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
              DEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8
              E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFFFFFFDEDEDEDEDEDEDEDEDEDEDE
              DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7
              BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFF7F7F7F000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
              C8E7BFC8E7BFC800000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000E7BFC8E7BFC8E7BFC800E7BF
              C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE00
              0000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8
              E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7
              BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000
              FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
              BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8
              E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BF
              C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFF
              DEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE0000
              00E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
              E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BF
              C8000000DEDEDEDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8
              E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BF
              C8E7BFC8E7BFC8E7BFC8E7BFC8000000DEDEDEDEDEDE000000E7BFC8E7BFC8E7
              BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC80000
              00FFFFFFDEDEDEDEDEDE000000000000000000000000000000DEDEDEFFFFFFDE
              DEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
              C8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
              DEDEDEDEDEFFFFFFFFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BF
              C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEDEDE000000E7BFC8E7BFC8
              E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7
              BFC8E7BFC8000000000000000000000000000000000000000000000000000000
              000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
              BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
              E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
              C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
              E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
              C8E7BFC8E7BFC8E7BFC8E7BFC800}
            Stretch = True
            Transparent = True
          end
          object lbPlayerFile: TLabel
            Left = 20
            Top = 114
            Width = 53
            Height = 13
            Caption = 'lbPlayerFile'
            Visible = False
            StyleElements = []
          end
        end
        object PnDevTL: TPanel
          Left = 24
          Top = 144
          Width = 185
          Height = 41
          BevelOuter = bvNone
          Ctl3D = False
          ParentCtl3D = False
          ShowCaption = False
          TabOrder = 1
          StyleElements = []
          object imgDeviceTL: TImage
            Left = 0
            Top = 0
            Width = 185
            Height = 41
            Align = alClient
            OnMouseMove = imgDeviceTLMouseMove
            OnMouseUp = imgDeviceTLMouseUp
          end
        end
        object PnTextTL: TPanel
          Left = 21
          Top = 171
          Width = 184
          Height = 135
          BevelOuter = bvNone
          Ctl3D = False
          ParentCtl3D = False
          ShowCaption = False
          TabOrder = 2
          Visible = False
          StyleElements = []
          object imgTextTL: TImage
            Left = 0
            Top = 0
            Width = 184
            Height = 85
            Align = alTop
            OnMouseMove = imgTextTLMouseMove
            OnMouseUp = imgTextTLMouseUp
          end
          object RichEdit1: TRichEdit
            Left = 12
            Top = 85
            Width = 159
            Height = 50
            Align = alClient
            BevelKind = bkFlat
            BorderStyle = bsNone
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            StyleElements = []
            Zoom = 100
            OnKeyUp = RichEdit1KeyUp
            OnMouseDown = RichEdit1MouseDown
          end
          object Panel8: TPanel
            Left = 0
            Top = 85
            Width = 12
            Height = 50
            Align = alLeft
            BevelOuter = bvNone
            Ctl3D = False
            ParentCtl3D = False
            ShowCaption = False
            TabOrder = 1
            StyleElements = []
          end
          object Panel9: TPanel
            Left = 171
            Top = 85
            Width = 13
            Height = 50
            Align = alRight
            BevelOuter = bvNone
            Ctl3D = False
            ParentCtl3D = False
            ShowCaption = False
            TabOrder = 2
            StyleElements = []
          end
        end
        object pnMediaTL: TPanel
          Left = 79
          Top = 128
          Width = 185
          Height = 89
          BevelOuter = bvNone
          Caption = 'pnMediaTL'
          Ctl3D = False
          ParentCtl3D = False
          ShowCaption = False
          TabOrder = 3
          Visible = False
          StyleElements = []
          object imgMediaTL: TImage
            Left = 0
            Top = 0
            Width = 185
            Height = 89
            Align = alClient
            OnMouseMove = imgMediaTLMouseMove
            OnMouseUp = imgMediaTLMouseUp
          end
        end
      end
      object pnTypeMovie: TPanel
        Left = 507
        Top = 0
        Width = 416
        Height = 341
        Align = alRight
        BevelOuter = bvNone
        Caption = 'pnTypeMovie'
        ShowCaption = False
        TabOrder = 1
        StyleElements = []
        object Panel13: TPanel
          Left = 0
          Top = 0
          Width = 59
          Height = 341
          Align = alClient
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          StyleElements = []
          object imgTypeMovie: TImage
            Left = 0
            Top = 0
            Width = 59
            Height = 341
            Align = alClient
            OnMouseMove = imgTypeMovieMouseMove
            OnMouseUp = imgTypeMovieMouseUp
          end
        end
        object Panel14: TPanel
          Left = 59
          Top = 0
          Width = 357
          Height = 341
          Align = alRight
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 1
          StyleElements = []
          object Panel15: TPanel
            Left = 0
            Top = 291
            Width = 357
            Height = 50
            Align = alBottom
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 0
            StyleElements = []
            object spDeleteTemplate: TSpeedButton
              Left = 208
              Top = 2
              Width = 80
              Height = 23
              Caption = #1059#1076#1072#1083#1080#1090#1100
              Flat = True
              Visible = False
              StyleElements = []
              OnClick = spDeleteTemplateClick
            end
            object CheckBox1: TCheckBox
              Left = 4
              Top = 29
              Width = 205
              Height = 14
              ParentCustomHint = False
              BiDiMode = bdLeftToRight
              Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1075#1088#1072#1092#1080#1095#1077#1089#1082#1080#1077' '#1096#1072#1073#1083#1086#1085#1099
              Color = clBtnFace
              Ctl3D = False
              DoubleBuffered = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Pitch = fpFixed
              Font.Style = []
              ParentBiDiMode = False
              ParentColor = False
              ParentCtl3D = False
              ParentDoubleBuffered = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              StyleElements = []
              OnClick = CheckBox1Click
            end
            object CheckBox2: TCheckBox
              Left = 4
              Top = 7
              Width = 205
              Height = 13
              Caption = #1055#1088#1080#1089#1074#1072#1080#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1075#1088#1072#1092#1080#1082#1091
              Checked = True
              State = cbChecked
              TabOrder = 1
              StyleElements = []
            end
          end
          object GridGRTemplate: TStringGrid
            Left = 0
            Top = 33
            Width = 357
            Height = 258
            Align = alClient
            BorderStyle = bsNone
            Ctl3D = False
            DrawingStyle = gdsClassic
            FixedCols = 0
            RowCount = 2
            GridLineWidth = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
            ParentCtl3D = False
            ScrollBars = ssNone
            TabOrder = 1
            StyleElements = []
            OnDblClick = GridGRTemplateDblClick
            OnDrawCell = GridGRTemplateDrawCell
            OnMouseUp = GridGRTemplateMouseUp
            ColWidths = (
              64
              64
              64
              64
              64)
            RowHeights = (
              24
              24)
          end
          object Panel16: TPanel
            Left = 0
            Top = 0
            Width = 357
            Height = 33
            Align = alTop
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 2
            StyleElements = []
            object Label1: TLabel
              Left = 0
              Top = 0
              Width = 357
              Height = 33
              Align = alClient
              Alignment = taCenter
              Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1077' '#1096#1072#1073#1083#1086#1085#1099
              Layout = tlCenter
              StyleElements = []
              ExplicitWidth = 116
              ExplicitHeight = 13
            end
          end
        end
      end
      object Panel17: TPanel
        Left = 296
        Top = 0
        Width = 211
        Height = 341
        Align = alClient
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 2
        StyleElements = []
        object pnMovie: TPanel
          Left = 0
          Top = 10
          Width = 211
          Height = 281
          Align = alClient
          BevelOuter = bvNone
          BorderStyle = bsSingle
          Caption = 'pnMovie'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Times New Roman'
          Font.Style = []
          ParentFont = False
          ShowCaption = False
          TabOrder = 0
          StyleElements = []
          OnResize = pnMovieResize
        end
        object Panel18: TPanel
          Left = 0
          Top = 0
          Width = 211
          Height = 10
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 1
          StyleElements = []
        end
        object Panel19: TPanel
          Left = 0
          Top = 291
          Width = 211
          Height = 50
          Align = alBottom
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 2
          StyleElements = []
          object Panel20: TPanel
            Left = 0
            Top = 0
            Width = 138
            Height = 50
            Align = alLeft
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 0
            StyleElements = []
            object lbMediaNTK: TLabel
              Left = 61
              Top = 4
              Width = 73
              Height = 20
              AutoSize = False
              Caption = '00:00:00:00'
              Layout = tlCenter
              StyleElements = []
            end
            object Label13: TLabel
              Left = 4
              Top = 4
              Width = 55
              Height = 20
              AutoSize = False
              Caption = #1053'.'#1058'.'#1050'.'
              Layout = tlCenter
              StyleElements = []
            end
            object lbMediaDuration: TLabel
              Left = 61
              Top = 24
              Width = 73
              Height = 21
              AutoSize = False
              Caption = '00:00:00:00'
              Layout = tlCenter
              StyleElements = []
            end
            object Label16: TLabel
              Left = 4
              Top = 24
              Width = 55
              Height = 21
              AutoSize = False
              Caption = #1061#1088#1086#1085#1086#1084'.'
              Layout = tlCenter
              StyleElements = []
            end
          end
          object Panel21: TPanel
            Left = 72
            Top = 0
            Width = 139
            Height = 50
            Align = alRight
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 1
            StyleElements = []
            object lbMediaTotalDur: TLabel
              Left = 56
              Top = 24
              Width = 73
              Height = 21
              Alignment = taRightJustify
              AutoSize = False
              Caption = '00:00:00:00'
              Layout = tlCenter
              StyleElements = []
            end
            object lbMediaKTK: TLabel
              Left = 56
              Top = 4
              Width = 73
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              Caption = '00:00:00:00'
              Layout = tlCenter
              StyleElements = []
            end
            object Label18: TLabel
              Left = 0
              Top = 4
              Width = 49
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              Caption = #1050'.'#1058'.'#1050'.'
              Layout = tlCenter
              StyleElements = []
            end
            object Label19: TLabel
              Left = 0
              Top = 24
              Width = 49
              Height = 21
              Alignment = taRightJustify
              AutoSize = False
              Caption = #1054#1073#1097#1080#1081
              Layout = tlCenter
              StyleElements = []
            end
          end
          object Panel22: TPanel
            Left = 138
            Top = 0
            Width = 39
            Height = 50
            Align = alClient
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 2
            StyleElements = []
            object lbMediaCurTK: TLabel
              Left = 0
              Top = 0
              Width = 39
              Height = 50
              Align = alClient
              Alignment = taCenter
              Caption = '00:00:00:00'
              Layout = tlCenter
              StyleElements = []
              ExplicitWidth = 57
              ExplicitHeight = 13
            end
          end
        end
        object pnImageScreen: TPanel
          Left = 2
          Top = 119
          Width = 313
          Height = 140
          BevelOuter = bvNone
          Caption = 'pnImageScreen'
          ShowCaption = False
          TabOrder = 3
          Visible = False
          StyleElements = []
          object Image3: TImage
            Left = 0
            Top = 0
            Width = 313
            Height = 140
            Align = alClient
            Stretch = True
            ExplicitLeft = 4
            ExplicitTop = -1
          end
        end
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 341
      Width = 923
      Height = 191
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel4'
      ShowCaption = False
      TabOrder = 1
      StyleElements = []
      object imgTimelines: TImage
        Left = 185
        Top = 1
        Width = 829
        Height = 151
        Align = alCustom
      end
      object ImgLayer0: TImage
        Left = 208
        Top = 26
        Width = 306
        Height = 111
        Transparent = True
      end
      object imgTLNames: TImage
        Left = 1
        Top = 1
        Width = 184
        Height = 151
        Align = alCustom
        OnMouseMove = imgTLNamesMouseMove
        OnMouseUp = imgTLNamesMouseUp
      end
      object imgLayer1: TImage
        Left = 215
        Top = 33
        Width = 498
        Height = 128
        Transparent = True
      end
      object imgLayer2: TImage
        Left = 272
        Top = 8
        Width = 481
        Height = 145
        Transparent = True
        OnDblClick = imgLayer2DblClick
        OnMouseDown = imgLayer2MouseDown
        OnMouseMove = imgLayer2MouseMove
        OnMouseUp = imgLayer2MouseUp
      end
      object Panel7: TPanel
        Left = 0
        Top = 150
        Width = 923
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Caption = '.'
        Ctl3D = True
        ParentCtl3D = False
        ShowCaption = False
        TabOrder = 0
        StyleElements = []
        object imgCTLBottomL: TImage
          Left = 0
          Top = 0
          Width = 233
          Height = 41
          Align = alLeft
          OnMouseMove = imgCTLBottomLMouseMove
          OnMouseUp = imgCTLBottomLMouseUp
        end
        object lbCTLTimeCode: TLabel
          Left = 583
          Top = 0
          Width = 144
          Height = 41
          Align = alLeft
          AutoSize = False
          Caption = '0:00:00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          StyleElements = []
          ExplicitLeft = 738
        end
        object imgCtlBottomR: TImage
          Left = 714
          Top = 0
          Width = 209
          Height = 41
          Align = alRight
          OnMouseMove = imgCtlBottomRMouseMove
          OnMouseUp = imgCtlBottomRMouseUp
          ExplicitLeft = 346
          ExplicitTop = 7
        end
        object Label7: TLabel
          Left = 847
          Top = 13
          Width = 32
          Height = 13
          Caption = 'Label7'
          Visible = False
          StyleElements = []
        end
        object lbTypeTC: TLabel
          Left = 730
          Top = 0
          Width = 168
          Height = 41
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = 'LTC (00:00:00:00)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          StyleElements = []
          ExplicitLeft = 700
        end
        object sbSinhronization: TSpeedButton
          Left = 347
          Top = 0
          Width = 39
          Height = 41
          Align = alLeft
          Flat = True
          Glyph.Data = {
            F2060000424DF206000000000000360400002800000019000000190000000100
            080000000000BC02000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00080808080808
            080808FFFFFFFFFFFFFF08080808080808080800000008080808080808FFFFFF
            FFFFFFFFFFFFFFFF080808080808080000000808080808FFFFFFFFFF08080808
            08FFFFFFFFFF080808080800000008080808FFFFFF0808080808FFFF08080808
            FFFFFF08080808000000080808FFFFFF080808080808FFFF0808080808FFFFFF
            0808080000000808FFFFFF08080808080808FFFF080808080808FFFFFF080800
            00000808FFFF0808FF08080808080808080808FF080808FFFF080800000008FF
            FF08080808FF0808080808080808FF0808080808FFFF0800000008FFFF080808
            08080808080808080808080808080808FFFF08000000FFFF0808080808080808
            080808080808080808080808FFFFFF000000FFFF080808080808080808080808
            080808080808080808FFFF000000FFFF08FFFFFF0808FFFFFFFFFFFF08080808
            08FFFFFF08FFFF000000FFFF08FFFFFF08FFFFFFFFFFFFFFFF08080808FFFFFF
            08FFFF000000FFFF080808080808080808080808FFFF08080808080808FFFF00
            0000FFFF08080808080808080808080808FFFF080808080808FFFF000000FFFF
            0808080808080808080808080808FFFF08080808FFFFFF00000008FFFF080808
            0808080808080808080808FFFF080808FFFF0800000008FFFF08080808FF0808
            0808080808080808FFFF0808FFFF080000000808FFFF0808FF08080808080808
            0808080808FF08FFFF08080000000808FFFFFF08080808080808FFFF08080808
            0808FFFFFF0808000000080808FFFFFF080808080808FFFF0808080808FFFFFF
            08080800000008080808FFFFFF0808080808FFFF08080808FFFFFF0808080800
            00000808080808FFFFFFFF08080808080808FFFFFFFF08080808080000000808
            0808080808FFFFFFFFFFFFFFFFFFFFFF08080808080808000000080808080808
            080808FFFFFFFFFFFFFF080808080808080808000000}
          Layout = blGlyphRight
          StyleElements = []
          OnClick = sbSinhronizationClick
          ExplicitLeft = 672
        end
        object lbusesclpidlst: TLabel
          Left = 949
          Top = 0
          Width = 76
          Height = 41
          Align = alLeft
          Alignment = taCenter
          Caption = #1057#1087#1080#1089#1086#1082' '#1082#1083#1080#1087#1086#1074
          Layout = tlCenter
          StyleElements = []
          ExplicitHeight = 13
        end
        object Bevel14: TBevel
          Left = 727
          Top = 0
          Width = 3
          Height = 41
          Align = alLeft
          Shape = bsLeftLine
          ExplicitLeft = 619
        end
        object Bevel15: TBevel
          Left = 573
          Top = 0
          Width = 10
          Height = 41
          Align = alLeft
          Shape = bsLeftLine
          ExplicitLeft = 478
        end
        object lbSynchRegim: TLabel
          Left = 396
          Top = 0
          Width = 177
          Height = 41
          Align = alLeft
          AutoSize = False
          Caption = #1056#1091#1095#1085#1086#1081' '#1088#1077#1078#1080#1084
          Layout = tlCenter
          StyleElements = []
          ExplicitLeft = 292
          ExplicitTop = -7
        end
        object Bevel16: TBevel
          Left = 386
          Top = 0
          Width = 10
          Height = 41
          Align = alLeft
          Shape = bsLeftLine
          ExplicitLeft = 376
          ExplicitTop = -7
        end
        object Bevel18: TBevel
          Left = 939
          Top = 0
          Width = 10
          Height = 41
          Align = alLeft
          Shape = bsLeftLine
          ExplicitLeft = 917
        end
        object Bevel17: TBevel
          Left = 233
          Top = 0
          Width = 10
          Height = 41
          Align = alLeft
          Shape = bsLeftLine
        end
        object SpeedButton2: TSpeedButton
          Left = 898
          Top = 0
          Width = 41
          Height = 41
          Align = alLeft
          Flat = True
          Glyph.Data = {
            F2060000424DF206000000000000360400002800000019000000190000000100
            080000000000BC02000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00080808080808
            080808FFFFFFFFFFFFFF08080808080808080800000008080808080808FFFFFF
            FFFFFFFFFFFFFFFF080808080808080000000808080808FFFFFFFFFF08080808
            08FFFFFFFFFF080808080800000008080808FFFFFF0808080808FFFF08080808
            FFFFFF08080808000000080808FFFFFF080808080808FFFF0808080808FFFFFF
            0808080000000808FFFFFF08080808080808FFFF080808080808FFFFFF080800
            00000808FFFF0808FF08080808080808080808FF080808FFFF080800000008FF
            FF08080808FF0808080808080808FF0808080808FFFF0800000008FFFF080808
            08080808080808080808080808080808FFFF08000000FFFF0808080808080808
            080808080808080808080808FFFFFF000000FFFF080808080808080808080808
            080808080808080808FFFF000000FFFF08FFFFFF0808FFFFFFFFFFFF08080808
            08FFFFFF08FFFF000000FFFF08FFFFFF08FFFFFFFFFFFFFFFF08080808FFFFFF
            08FFFF000000FFFF080808080808080808080808FFFF08080808080808FFFF00
            0000FFFF08080808080808080808080808FFFF080808080808FFFF000000FFFF
            0808080808080808080808080808FFFF08080808FFFFFF00000008FFFF080808
            0808080808080808080808FFFF080808FFFF0800000008FFFF08080808FF0808
            0808080808080808FFFF0808FFFF080000000808FFFF0808FF08080808080808
            0808080808FF08FFFF08080000000808FFFFFF08080808080808FFFF08080808
            0808FFFFFF0808000000080808FFFFFF080808080808FFFF0808080808FFFFFF
            08080800000008080808FFFFFF0808080808FFFF08080808FFFFFF0808080800
            00000808080808FFFFFFFF08080808080808FFFFFFFF08080808080000000808
            0808080808FFFFFFFFFFFFFFFFFFFFFF08080808080808000000080808080808
            080808FFFFFFFFFFFFFF080808080808080808000000}
          StyleElements = []
          OnClick = SpeedButton2Click
          ExplicitLeft = 902
        end
        object MySynhro: TCheckBox
          Left = 243
          Top = 0
          Width = 104
          Height = 41
          Align = alLeft
          Caption = #1057#1080#1085#1093#1088#1086#1085'.'
          Ctl3D = False
          DoubleBuffered = True
          ParentCtl3D = False
          ParentDoubleBuffered = False
          TabOrder = 0
          StyleElements = []
          OnClick = MySynhroClick
        end
      end
    end
  end
  object PanelAir: TPanel
    Left = 1086
    Top = -211
    Width = 617
    Height = 368
    BevelOuter = bvNone
    Caption = #1069#1092#1080#1088
    ShowCaption = False
    TabOrder = 5
    Visible = False
    StyleElements = []
    object ImgDevices: TImage
      Left = 0
      Top = 255
      Width = 617
      Height = 113
      Align = alBottom
      OnMouseMove = ImgDevicesMouseMove
    end
    object imgEvents: TImage
      Left = -7
      Top = 55
      Width = 617
      Height = 255
      Align = alCustom
    end
  end
  object InputPanel: TPanel
    Left = -104
    Top = 488
    Width = 222
    Height = 229
    ShowCaption = False
    TabOrder = 6
    StyleElements = []
    object Label8: TLabel
      Left = 33
      Top = 34
      Width = 76
      Height = 13
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
      StyleElements = []
    end
    object Label14: TLabel
      Left = 33
      Top = 82
      Width = 41
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100':'
      StyleElements = []
    end
    object SpeedButton1: TSpeedButton
      Left = 52
      Top = 137
      Width = 111
      Height = 33
      Caption = #1042#1086#1081#1090#1080
      Flat = True
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object Edit1: TEdit
      Left = 33
      Top = 51
      Width = 150
      Height = 25
      AutoSize = False
      TabOrder = 0
      Text = 'Demo'
      StyleElements = []
    end
    object Edit2: TEdit
      Left = 33
      Top = 98
      Width = 150
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
      Text = 'Demo'
      StyleElements = []
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 901
    Top = 168
  end
  object OpenDialog1: TOpenDialog
    Left = 1045
    Top = 8
  end
  object Timer1: TTimer
    Interval = 80
    OnTimer = Timer1Timer
    Left = 993
    Top = 112
  end
  object OpenDialog2: TOpenDialog
    Filter = #39#1060#1072#1081#1083' '#1089#1091#1073#1090#1080#1090#1088#1086#1074#39'|*.srt|'#39#1042#1089#1077' '#1092#1072#1081#1083#1099#39'|*.*'
    Left = 900
    Top = 8
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 250
    Left = 906
    Top = 113
  end
end
