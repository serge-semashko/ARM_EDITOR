object Form1: TForm1
  Left = 350
  Top = 463
  Width = 575
  Height = 261
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object SpeedButton1: TSpeedButton
    Left = 72
    Top = 120
    Width = 185
    Height = 33
    OnClick = SpeedButton1Click
  end
  object Label1: TLabel
    Left = 16
    Top = 160
    Width = 119
    Height = 46
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -40
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 80
    Top = 56
    Width = 145
    Height = 24
    TabOrder = 0
    Text = 'Edit1'
    OnChange = Edit1Change
    OnKeyPress = Edit1KeyPress
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 360
    Top = 32
  end
end
