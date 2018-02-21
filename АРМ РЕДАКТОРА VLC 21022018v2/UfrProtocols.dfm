object FrProtocols: TFrProtocols
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' '#1074#1080#1076#1077#1086#1084#1080#1082#1096#1080#1088#1086#1084
  ClientHeight = 564
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 522
    Width = 429
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object imgButtons: TImage
      Left = 114
      Top = 0
      Width = 315
      Height = 42
      Align = alRight
      OnMouseMove = imgButtonsMouseMove
      OnMouseUp = imgButtonsMouseUp
      ExplicitLeft = 2
      ExplicitTop = 1
      ExplicitHeight = 40
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 429
    Height = 522
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object imgAddParam: TImage
      Left = 2
      Top = 249
      Width = 425
      Height = 271
      Align = alClient
      OnMouseMove = imgAddParamMouseMove
      ExplicitLeft = 4
      ExplicitTop = 250
    end
    object Panel4: TPanel
      Left = 2
      Top = 2
      Width = 425
      Height = 247
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel4'
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object GroupBox1: TGroupBox
        Left = 230
        Top = 0
        Width = 192
        Height = 244
        Caption = #1055#1086#1088#1090' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103':'
        TabOrder = 0
        object imgPorts: TImage
          Left = 2
          Top = 15
          Width = 188
          Height = 227
          Align = alClient
          OnMouseMove = imgPortsMouseMove
          OnMouseUp = imgPortsMouseUp
          ExplicitLeft = 56
          ExplicitTop = 80
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
        object ComboBox4: TComboBox
          Left = 5
          Top = 15
          Width = 87
          Height = 22
          BevelInner = bvNone
          BevelKind = bkSoft
          Style = csOwnerDrawFixed
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 0
          Visible = False
          StyleElements = []
          OnChange = ComboBox4Change
        end
        object Edit1: TEdit
          Left = 75
          Top = 16
          Width = 92
          Height = 19
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 1
          Text = '000.000.000.000'
          Visible = False
          OnChange = Edit1Change
          OnKeyDown = Edit1KeyDown
          OnKeyPress = Edit1KeyPress
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 0
        Width = 226
        Height = 119
        Caption = #1054#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1077
        TabOrder = 1
        object imgDevice: TImage
          Left = 2
          Top = 15
          Width = 222
          Height = 102
          Align = alClient
          OnMouseMove = imgDeviceMouseMove
          OnMouseUp = imgDeviceMouseUp
          ExplicitWidth = 217
          ExplicitHeight = 95
        end
        object ComboBox1: TComboBox
          Left = 88
          Top = 36
          Width = 121
          Height = 22
          BevelInner = bvNone
          BevelKind = bkSoft
          Style = csOwnerDrawFixed
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 0
          Visible = False
          StyleElements = []
          OnChange = ComboBox1Change
        end
      end
      object GroupBox3: TGroupBox
        Left = 5
        Top = 120
        Width = 222
        Height = 124
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099':'
        TabOrder = 2
        object imgMainParam: TImage
          Left = 2
          Top = 15
          Width = 218
          Height = 107
          Align = alClient
          OnMouseMove = imgMainParamMouseMove
          ExplicitWidth = 219
        end
        object ComboBox3: TComboBox
          Left = 96
          Top = 84
          Width = 89
          Height = 21
          BevelInner = bvNone
          BevelKind = bkSoft
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 0
          Text = 'ComboBox3'
        end
      end
    end
  end
end
