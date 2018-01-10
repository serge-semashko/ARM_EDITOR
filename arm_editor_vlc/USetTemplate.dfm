object FrSetTemplate: TFrSetTemplate
  Left = 432
  Top = 145
  BorderStyle = bsDialog
  Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1096#1072#1073#1083#1086#1085#1099
  ClientHeight = 668
  ClientWidth = 811
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
  object Panel2: TPanel
    Left = 0
    Top = 568
    Width = 811
    Height = 100
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object SpeedButton3: TSpeedButton
      Left = 620
      Top = 56
      Width = 180
      Height = 35
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Flat = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 439
      Top = 56
      Width = 180
      Height = 35
      Caption = #1054#1090#1084#1077#1085#1072
      Flat = True
      OnClick = SpeedButton4Click
    end
    object SpeedButton1: TSpeedButton
      Left = 708
      Top = 14
      Width = 93
      Height = 29
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Flat = True
      OnClick = SpeedButton1Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 12
      Width = 697
      Height = 31
      AutoSize = False
      TabOrder = 0
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 64
      Width = 345
      Height = 17
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1074' '#1088#1077#1078#1080#1084#1077' '#1101#1092#1080#1088
      TabOrder = 1
    end
  end
  object GridMyLists: TStringGrid
    Left = 0
    Top = 25
    Width = 811
    Height = 543
    Align = alClient
    BorderStyle = bsNone
    Ctl3D = False
    FixedCols = 0
    GridLineWidth = 0
    Options = [goRowSelect]
    ParentCtl3D = False
    ScrollBars = ssNone
    TabOrder = 1
    OnDblClick = GridMyListsDblClick
    OnDrawCell = GridMyListsDrawCell
    OnMouseUp = GridMyListsMouseUp
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 811
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
  end
end
