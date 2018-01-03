object Form1: TForm1
  Left = 192
  Top = 146
  Width = 1305
  Height = 675
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
  object PopupMenu1: TPopupMenu
    Left = 200
    Top = 184
    object RestoreItem: TMenuItem
      Caption = 'RestoreItem'
      OnClick = RestoreItemClick
    end
    object N1: TMenuItem
      Caption = 'N1'
    end
    object FileExitItem1: TMenuItem
      Caption = 'FileExitItem1'
      OnClick = FileExitItem1Click
    end
    object HideItem: TMenuItem
      Caption = 'HideItem'
      OnClick = HideItemClick
    end
  end
end
