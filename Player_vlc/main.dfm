object MainForm: TMainForm
  Left = 285
  Top = 87
  Caption = 'Main'
  ClientHeight = 708
  ClientWidth = 1147
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object Panel1: TPanel
    Left = 648
    Top = 0
    Width = 499
    Height = 674
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 0
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 497
      Height = 584
      Align = alTop
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 648
    Height = 674
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 674
    Width = 1147
    Height = 34
    Panels = <
      item
        Width = 120
      end
      item
        Width = 120
      end
      item
        Width = 120
      end
      item
        Width = 200
      end
      item
        Width = 120
      end
      item
        Width = 120
      end
      item
        Width = 50
      end>
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.*'
    Title = 'Select file to play'
    Left = 8
    Top = 12
  end
  object MainMenu: TMainMenu
    Left = 44
    Top = 12
    object MenuFile: TMenuItem
      AutoCheck = True
      Caption = 'File'
      object Load1: TMenuItem
        Caption = 'Load'
        OnClick = Load1Click
      end
      object Pause1: TMenuItem
        Caption = 'Pause'
        OnClick = Pause1Click
      end
      object Backward1: TMenuItem
        Caption = 'Backward'
        OnClick = Backward1Click
      end
      object Forward1: TMenuItem
        Caption = 'Forward'
        OnClick = Forward1Click
      end
      object Begin1: TMenuItem
        Caption = 'Begin'
        OnClick = Begin1Click
      end
      object End1: TMenuItem
        Caption = 'End'
        OnClick = End1Click
      end
      object MenuFileQuit: TMenuItem
        Caption = 'Quit'
        OnClick = MenuFileQuitClick
      end
    end
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 648
    Top = 16
  end
end
