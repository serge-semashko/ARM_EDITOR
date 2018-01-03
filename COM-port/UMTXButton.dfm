object fmMTX: TfmMTX
  Left = 192
  Top = 114
  BorderStyle = bsNone
  Caption = 'fmMTX'
  ClientHeight = 276
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 529
    Height = 276
    Align = alClient
    OnMouseDown = Image1MouseDown
    OnMouseUp = Image1MouseUp
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 456
    Top = 64
  end
end
