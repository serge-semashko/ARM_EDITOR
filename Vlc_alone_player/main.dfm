object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 293
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object toolPanel: TPanel
    Left = 0
    Top = 0
    Width = 89
    Height = 293
    Align = alLeft
    TabOrder = 0
    object btnPlay: TSpeedButton
      Left = 8
      Top = 16
      Width = 57
      Height = 33
      Caption = 'Play'
      OnClick = btnPlayClick
    end
    object btnStop: TSpeedButton
      Left = 8
      Top = 55
      Width = 57
      Height = 33
      Caption = 'Stop'
      OnClick = btnStopClick
    end
    object SpeedButton3: TSpeedButton
      Left = 8
      Top = 92
      Width = 57
      Height = 33
      Caption = 'Pause'
      OnClick = SpeedButton3Click
    end
  end
  object Panel1: TPanel
    Left = 89
    Top = 0
    Width = 544
    Height = 293
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 240
    ExplicitTop = 55
    ExplicitWidth = 185
    ExplicitHeight = 41
  end
  object od1: TOpenDialog
    Left = 32
    Top = 144
  end
end
