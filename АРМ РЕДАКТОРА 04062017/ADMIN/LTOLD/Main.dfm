object Form1: TForm1
  Left = 192
  Top = 107
  Width = 1142
  Height = 656
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 48
    Top = 16
    Width = 1041
    Height = 177
  end
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 152
    Top = 568
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 360
    Top = 576
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object TrackBar1: TTrackBar
    Left = 624
    Top = 512
    Width = 321
    Height = 45
    Max = 40
    TabOrder = 2
    TickMarks = tmBoth
  end
  object Memo1: TMemo
    Left = 48
    Top = 208
    Width = 1041
    Height = 273
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
end
