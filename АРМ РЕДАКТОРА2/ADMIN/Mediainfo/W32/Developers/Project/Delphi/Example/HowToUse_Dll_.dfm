object Form1: TForm1
  Left = 282
  Top = 214
  Width = 1235
  Height = 692
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'MediaInfo.Dll Example'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object SpeedButton1: TSpeedButton
    Left = 904
    Top = 72
    Width = 289
    Height = 41
    OnClick = SpeedButton1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 873
    Height = 631
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 936
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object OpenDialog1: TOpenDialog
    Left = 1000
    Top = 120
  end
end
