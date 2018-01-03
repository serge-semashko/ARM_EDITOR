object Form1: TForm1
  Left = 192
  Top = 124
  Width = 573
  Height = 287
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 56
    Top = 48
    Width = 209
    Height = 21
    MaxLength = 11
    TabOrder = 0
    Text = '00:00:00:00'
    OnKeyDown = Edit1KeyDown
    OnKeyPress = Edit1KeyPress
  end
end
