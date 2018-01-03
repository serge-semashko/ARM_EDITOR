object Form1: TForm1
  Left = 192
  Top = 146
  Width = 1395
  Height = 855
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1377
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 2
      Top = 1
      Width = 175
      Height = 40
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      Flat = True
    end
    object SpeedButton2: TSpeedButton
      Left = 179
      Top = 1
      Width = 175
      Height = 40
      Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072
      Flat = True
    end
    object SpeedButton3: TSpeedButton
      Left = 355
      Top = 1
      Width = 175
      Height = 40
      Caption = #1060#1086#1088#1084#1099
      Flat = True
    end
    object SpeedButton4: TSpeedButton
      Left = 531
      Top = 1
      Width = 175
      Height = 40
      Caption = #1057#1087#1080#1089#1082#1080
      Flat = True
    end
    object SpeedButton5: TSpeedButton
      Left = 707
      Top = 1
      Width = 175
      Height = 40
      Caption = #1057#1086#1073#1099#1090#1080#1103
      Flat = True
    end
    object SpeedButton6: TSpeedButton
      Left = 884
      Top = 0
      Width = 175
      Height = 40
      Caption = #1043#1086#1088#1103#1095#1080#1077' '#1082#1083#1072#1074#1080#1096#1080
      Flat = True
    end
  end
  object PanelUsers: TPanel
    Left = 0
    Top = 41
    Width = 937
    Height = 600
    Align = alCustom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    OnResize = PanelUsersResize
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 352
      Height = 600
      Align = alLeft
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      object imgbtnsusers: TImage
        Left = 0
        Top = 0
        Width = 352
        Height = 165
        Align = alTop
        OnMouseMove = imgbtnsusersMouseMove
        OnMouseUp = imgbtnsusersMouseUp
      end
    end
    object StringGrid1: TStringGrid
      Left = 352
      Top = 0
      Width = 585
      Height = 600
      Align = alClient
      BorderStyle = bsNone
      FixedCols = 0
      GridLineWidth = 0
      TabOrder = 1
      OnDblClick = StringGrid1DblClick
      OnDrawCell = StringGrid1DrawCell
    end
  end
end
