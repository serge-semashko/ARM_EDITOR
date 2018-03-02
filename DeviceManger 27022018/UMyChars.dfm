object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 342
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 529
    Height = 113
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 104
      Height = 111
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel2'
      Ctl3D = False
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object Label1: TLabel
        Left = 28
        Top = 36
        Width = 70
        Height = 16
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 9
        Top = 63
        Width = 89
        Height = 16
        Caption = #1057#1090#1088#1086#1082#1072' '#1073#1072#1081#1090':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 50
        Top = 91
        Width = 48
        Height = 16
        Caption = #1041#1072#1081#1090#1099':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SpeedButton4: TSpeedButton
        Left = 2
        Top = 2
        Width = 24
        Height = 24
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          5555555555555555555555555555555555555555555555555555555555555555
          555555555555555555555555555555555555555FFFFFFFFFF555550000000000
          55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
          B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
          000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
          555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
          55555575FFF75555555555700007555555555557777555555555555555555555
          5555555555555555555555555555555555555555555555555555}
        NumGlyphs = 2
        OnClick = SpeedButton4Click
      end
      object SpeedButton5: TSpeedButton
        Left = 28
        Top = 2
        Width = 24
        Height = 24
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
          00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
          00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
          00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
          00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
          00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
          00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
          0003737FFFFFFFFF7F7330099999999900333777777777777733}
        NumGlyphs = 2
        OnClick = SpeedButton5Click
      end
    end
    object Panel3: TPanel
      Left = 419
      Top = 1
      Width = 109
      Height = 111
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Panel3'
      Ctl3D = False
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 1
      StyleElements = []
      object SpeedButton1: TSpeedButton
        Left = 24
        Top = 34
        Width = 79
        Height = 22
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TSpeedButton
        Left = 0
        Top = 61
        Width = 103
        Height = 22
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton2Click
      end
      object SpeedButton3: TSpeedButton
        Left = 2
        Top = 34
        Width = 23
        Height = 22
        Caption = 'X'
        OnClick = SpeedButton3Click
      end
      object SpeedButton6: TSpeedButton
        Left = 0
        Top = 88
        Width = 105
        Height = 22
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton6Click
      end
    end
    object Panel4: TPanel
      Left = 105
      Top = 1
      Width = 314
      Height = 111
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel4'
      Ctl3D = False
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 2
      StyleElements = []
      object Label4: TLabel
        Left = 0
        Top = 91
        Width = 41
        Height = 16
        Caption = 'Label4'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Edit1: TEdit
        Left = 0
        Top = 61
        Width = 300
        Height = 22
        Ctl3D = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnChange = Edit1Change
        OnKeyDown = Edit1KeyDown
        OnKeyPress = Edit1KeyPress
      end
      object Edit2: TEdit
        Left = 0
        Top = 34
        Width = 300
        Height = 22
        Ctl3D = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 113
    Width = 529
    Height = 229
    Align = alClient
    Caption = 'Panel5'
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object StringGrid1: TStringGrid
      Left = 1
      Top = 1
      Width = 527
      Height = 227
      Align = alClient
      DefaultRowHeight = 18
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
      ParentFont = False
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnClick = StringGrid1Click
      OnTopLeftChanged = StringGrid1TopLeftChanged
      ColWidths = (
        64
        64
        64
        64
        64)
      RowHeights = (
        18
        18
        18
        18
        18)
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 352
    Top = 142
    object popDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = popDeleteClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 360
    Top = 225
  end
  object SaveDialog1: TSaveDialog
    Left = 424
    Top = 225
  end
end
