object fmMTXInput: TfmMTXInput
  Left = 211
  Top = 111
  BorderStyle = bsNone
  Caption = 'fmMTXInput'
  ClientHeight = 175
  ClientWidth = 391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 391
    Height = 175
    Align = alClient
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
  end
  object Timer1: TTimer
    Interval = 250
    OnTimer = Timer1Timer
    Left = 304
    Top = 56
  end
end
