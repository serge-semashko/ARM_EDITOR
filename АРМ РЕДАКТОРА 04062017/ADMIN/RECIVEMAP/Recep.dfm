object Form1: TForm1
  Left = 305
  Top = 157
  Width = 513
  Height = 287
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
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 41
    Height = 16
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 32
    Top = 168
    Width = 119
    Height = 46
    Caption = 'Label2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 264
    Top = 96
    Width = 89
    Height = 22
    OnClick = SpeedButton1Click
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 264
    Top = 48
  end
end
