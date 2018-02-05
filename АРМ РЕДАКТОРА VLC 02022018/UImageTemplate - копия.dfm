object FGRTemplate: TFGRTemplate
  Left = 454
  Top = 211
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1081' '#1096#1072#1073#1083#1086#1085
  ClientHeight = 638
  ClientWidth = 1050
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object Image1: TImage
    Left = 0
    Top = 44
    Width = 731
    Height = 540
    Align = alClient
  end
  object Layer1: TImage
    Left = 8
    Top = 56
    Width = 449
    Height = 337
    Transparent = True
    OnClick = Layer1Click
    OnMouseDown = Layer1MouseDown
    OnMouseMove = Layer1MouseMove
    OnMouseUp = Layer1MouseUp
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1050
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 625
      Height = 33
      Alignment = taCenter
      AutoSize = False
      Caption = #1053#1086#1074#1099#1081' '#1096#1072#1073#1083#1086#1085
      Layout = tlCenter
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 584
    Width = 1050
    Height = 54
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object SpeedButton3: TSpeedButton
      Left = 448
      Top = 15
      Width = 180
      Height = 30
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Flat = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton1: TSpeedButton
      Left = 40
      Top = 15
      Width = 180
      Height = 30
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083
      Flat = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 825
      Top = 15
      Width = 180
      Height = 30
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1096#1072#1073#1083#1086#1085
      Flat = True
      OnClick = SpeedButton2Click
    end
  end
  object Panel3: TPanel
    Left = 731
    Top = 44
    Width = 319
    Height = 540
    Align = alRight
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object Label1: TLabel
      Left = 5
      Top = 329
      Width = 40
      Height = 16
      Caption = #1058#1077#1082#1089#1090
    end
    object Label3: TLabel
      Left = 7
      Top = 9
      Width = 148
      Height = 16
      Caption = #1057#1086#1086#1090#1085#1086#1096#1077#1085#1080#1077' '#1089#1090#1086#1088#1086#1085':'
    end
    object Label4: TLabel
      Left = 8
      Top = 90
      Width = 149
      Height = 16
      Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1081' '#1096#1072#1073#1083#1086#1085
    end
    object Panel4: TPanel
      Left = 0
      Top = 109
      Width = 319
      Height = 208
      Align = alCustom
      BevelOuter = bvNone
      TabOrder = 0
      object Bevel1: TBevel
        Left = 10
        Top = 10
        Width = 296
        Height = 188
        Shape = bsFrame
      end
      object Image2: TImage
        Left = 20
        Top = 20
        Width = 277
        Height = 168
      end
    end
    object Edit1: TEdit
      Left = 6
      Top = 349
      Width = 305
      Height = 22
      TabOrder = 1
    end
    object ComboBox1: TComboBox
      Left = 217
      Top = 5
      Width = 80
      Height = 24
      BevelInner = bvNone
      BevelKind = bkFlat
      Style = csDropDownList
      Ctl3D = False
      ItemHeight = 16
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 2
      Text = '16x9'
      OnChange = ComboBox1Change
      Items.Strings = (
        '16x9'
        '4x3')
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 824
    Top = 8
  end
end
