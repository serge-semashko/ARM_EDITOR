object Form1: TForm1
  Left = 217
  Top = 107
  Width = 1302
  Height = 877
  Caption = #1040#1056#1052' '#1056#1077#1078#1080#1089#1089#1077#1088#1072
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  PixelsPerInch = 120
  TextHeight = 16
  object PanelControl: TPanel
    Left = 0
    Top = 0
    Width = 1284
    Height = 43
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Bevel6: TBevel
      Left = 0
      Top = 41
      Width = 1284
      Height = 2
      Align = alBottom
      Shape = bsBottomLine
      Style = bsRaised
    end
    object PanelControlBtns: TPanel
      Left = 0
      Top = 0
      Width = 356
      Height = 41
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object sbProject: TSpeedButton
        Left = 0
        Top = 0
        Width = 118
        Height = 41
        Caption = #1055#1088#1086#1077#1082#1090
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = sbProjectClick
        OnDblClick = sbProjectClick
      end
      object sbClips: TSpeedButton
        Left = 121
        Top = 0
        Width = 121
        Height = 41
        Caption = #1050#1083#1080#1087#1099
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = sbClipsClick
        OnDblClick = sbClipsClick
      end
      object sbPlayList: TSpeedButton
        Left = 244
        Top = 0
        Width = 110
        Height = 41
        Caption = #1055#1083#1077#1081'-'#1083#1080#1089#1090
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = sbPlayListClick
      end
      object Bevel2: TBevel
        Left = 118
        Top = 1
        Width = 3
        Height = 38
        Shape = bsLeftLine
        Visible = False
      end
      object Bevel3: TBevel
        Left = 242
        Top = 0
        Width = 3
        Height = 39
        Shape = bsLeftLine
        Visible = False
      end
    end
    object PanelControlMode: TPanel
      Left = 1057
      Top = 0
      Width = 227
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      Caption = 'PanelControlMode'
      TabOrder = 1
      object lbMode: TLabel
        Left = 0
        Top = 0
        Width = 227
        Height = 41
        Align = alClient
        Alignment = taCenter
        Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1082#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        OnClick = lbModeClick
        OnDblClick = lbModeClick
      end
    end
    object PanelControlClip: TPanel
      Left = 356
      Top = 0
      Width = 701
      Height = 41
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object sbPredClip: TSpeedButton
        Left = 4
        Top = 0
        Width = 42
        Height = 39
        Flat = True
        Glyph.Data = {
          5A010000424D5A01000000000000760000002800000013000000130000000100
          040000000000E400000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          5555555888885555555555555555555000005555555555564555555000115555
          555555E64555555000CA555555555E6645555550003555555555E66645555550
          00005555555E6666455555500000555555E6666645555552000055555E666666
          4555555616085555E666666645555550000055555E6666664555555000005555
          55E666664555555000005555555E666645555550000055555555E66645555550
          0000555555555E664555555000005555555555E645555550000055555555555E
          655555500000555555555555555555500000555555555555555555520040}
        OnClick = sbPredClipClick
      end
      object Bevel1: TBevel
        Left = 47
        Top = 5
        Width = 347
        Height = 31
        Visible = False
      end
      object sbNextClip: TSpeedButton
        Left = 618
        Top = 0
        Width = 42
        Height = 39
        Flat = True
        Glyph.Data = {
          5A010000424D5A01000000000000760000002800000013000000130000000100
          040000000000E400000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          5555555490495555555555555555555C22E2555555E455555555555688C85555
          55E64555555555501100555555E66455555555502226555555E6664555555550
          1101555555E66664555555540141555555E66666455555502EA6555555E66666
          645555500001555555E66666666555547B82555555E666666E55555820025555
          55E66666E5555550444C555555E6666E555555500103555555E666E555555559
          E604555555E66E55555555514126555555E6E555555555512191555555EE5555
          5555555502545555555555555555555675F4555555555555555555530B0A}
        OnClick = sbNextClipClick
      end
      object Label2: TLabel
        Left = 53
        Top = 5
        Width = 559
        Height = 28
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        OnClick = Label2Click
      end
    end
  end
  object PanelProject: TPanel
    Left = 0
    Top = 41
    Width = 1396
    Height = 733
    BevelOuter = bvNone
    Caption = #1055#1088#1086#1077#1082#1090
    TabOrder = 1
    Visible = False
    object Panel6: TPanel
      Left = 354
      Top = 0
      Width = 1042
      Height = 733
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel6'
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      object Splitter1: TSplitter
        Left = 0
        Top = 108
        Width = 1042
        Height = 6
        Cursor = crVSplit
        Align = alTop
      end
      object Panel10: TPanel
        Left = 0
        Top = 114
        Width = 1042
        Height = 619
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel10'
        TabOrder = 0
        OnResize = Panel10Resize
        object Panel11: TPanel
          Left = 0
          Top = 0
          Width = 1042
          Height = 60
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object sbListPlayLists: TSpeedButton
            Left = 1
            Top = 23
            Width = 228
            Height = 37
            Caption = #1055#1083#1077#1081'-'#1083#1080#1089#1090#1099
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            OnClick = sbListPlayListsClick
            OnDblClick = sbListPlayListsClick
          end
          object sbListGraphTemplates: TSpeedButton
            Left = 230
            Top = 23
            Width = 228
            Height = 37
            Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1077' '#1096#1072#1073#1083#1086#1085#1099
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            OnClick = sbListGraphTemplatesClick
            OnDblClick = sbListGraphTemplatesClick
          end
          object sbListTextTemplates: TSpeedButton
            Left = 458
            Top = 23
            Width = 228
            Height = 37
            Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1096#1072#1073#1083#1086#1085#1099
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            OnClick = sbListTextTemplatesClick
            OnDblClick = sbListTextTemplatesClick
          end
          object Bevel4: TBevel
            Left = 228
            Top = 0
            Width = 2
            Height = 37
            Shape = bsLeftLine
            Visible = False
          end
          object Bevel5: TBevel
            Left = 457
            Top = 1
            Width = 2
            Height = 36
            Shape = bsLeftLine
            Visible = False
          end
        end
        object GridLists: TStringGrid
          Left = 0
          Top = 60
          Width = 1042
          Height = 559
          Align = alClient
          BorderStyle = bsNone
          Color = clMoneyGreen
          Ctl3D = False
          FixedCols = 0
          GridLineWidth = 0
          Options = [goFixedHorzLine, goHorzLine, goRowSelect]
          ParentCtl3D = False
          ScrollBars = ssNone
          TabOrder = 1
          OnDblClick = GridListsDblClick
          OnDrawCell = GridListsDrawCell
          OnMouseUp = GridListsMouseUp
          OnTopLeftChanged = GridListsTopLeftChanged
          ColWidths = (
            64
            64
            64
            64
            64)
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 1042
        Height = 108
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel5'
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        OnResize = Panel5Resize
        object GridProjects: TStringGrid
          Left = 0
          Top = 0
          Width = 1042
          Height = 108
          Align = alClient
          BorderStyle = bsNone
          Color = clMoneyGreen
          Ctl3D = False
          DefaultRowHeight = 30
          FixedCols = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GridLineWidth = 0
          Options = [goFixedHorzLine, goHorzLine, goRowSelect]
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssNone
          TabOrder = 0
          OnDblClick = GridProjectsDblClick
          OnDrawCell = GridProjectsDrawCell
          OnMouseUp = GridProjectsMouseUp
          OnTopLeftChanged = GridProjectsTopLeftChanged
        end
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 354
      Height = 733
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object imgButtonsProject: TImage
        Left = 0
        Top = 0
        Width = 354
        Height = 121
        Align = alTop
        OnMouseMove = imgButtonsProjectMouseMove
        OnMouseUp = imgButtonsProjectMouseUp
      end
      object imgBlockProjects: TImage
        Left = 18
        Top = 386
        Width = 31
        Height = 31
        Picture.Data = {
          07544269746D617022050000424D220500000000000036000000280000001300
          0000150000000100180000000000EC0400000000000000000000000000000000
          0000C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000C3C3
          C3C3C3C300639400639400639400639400639400639400639400639400639400
          6394006394006394006394006394C3C3C3C3C3C3C3C3C3000000C3C3C3C3C3C3
          006394D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4006394C3C3C3C3C3C3000000C3C3C3006394D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4006394C3C3C3000000C3C3C3006394D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4006394C3C3C3000000C3C3C3006394D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4006394C3C3C3000000C3C3C3006394D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4006394
          C3C3C3000000C3C3C3006394D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4006394C3C3C300
          0000C3C3C3006394D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4006394C3C3C3000000C3C3
          C3006394D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4006394C3C3C3000000C3C3C3006394
          D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4D4D4D4006394C3C3C3000000C3C3C3006394D4D4D4D4
          D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D4D4006394C3C3C3000000C3C3C3C3C3C3006394006394E7BF
          C8D4D4D4006394006394006394006394006394006394006394D4D4D4D4D4D400
          6394006394C3C3C3C3C3C3000000C3C3C3C3C3C3C3C3C3006394E7BFC8D4D4D4
          006394C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3006394D4D4D40094CE006394C3C3
          C3C3C3C3C3C3C3000000C3C3C3C3C3C3C3C3C3006394E7BFC8D4D4D4006394C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3006394D4D4D40094CE006394C3C3C3C3C3C3
          C3C3C3000000C3C3C3C3C3C3C3C3C3006394E7BFC8D4D4D4006394C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3006394D4D4D40094CE006394C3C3C3C3C3C3C3C3C300
          0000C3C3C3C3C3C3C3C3C3006394E7BFC8D4D4D4D4D4D4006394006394006394
          006394006394D4D4D4D4D4D40094CE006394C3C3C3C3C3C3C3C3C3000000C3C3
          C3C3C3C3C3C3C3006394E7BFC8D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4
          D4D4D4D4D4D4D4D40094CE006394C3C3C3C3C3C3C3C3C3000000C3C3C3C3C3C3
          C3C3C3C3C3C3006394E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8006394C3C3C3C3C3C3C3C3C3C3C3C3000000C3C3C3C3C3C3C3C3C3C3
          C3C3006394006394006394006394006394006394006394006394006394006394
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3000000}
        Stretch = True
        Transparent = True
        OnClick = imgBlockProjectsClick
      end
      object lbProjectName: TLabel
        Left = 0
        Top = 124
        Width = 354
        Height = 61
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Caption = #1055#1088#1086#1077#1082#1090' '#1085#1077' '#1074#1099#1073#1088#1072#1085
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
      end
      object lbDateEnd: TLabel
        Left = 185
        Top = 315
        Width = 153
        Height = 30
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object lbDateStart: TLabel
        Left = 185
        Top = 345
        Width = 153
        Height = 31
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object imgButtonsControlProj: TImage
        Left = 0
        Top = 568
        Width = 354
        Height = 165
        Align = alBottom
        OnMouseMove = imgButtonsControlProj1MouseMove
        OnMouseUp = imgButtonsControlProj1MouseUp
      end
      object Label3: TLabel
        Left = 18
        Top = 284
        Width = 148
        Height = 31
        AutoSize = False
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label4: TLabel
        Left = 18
        Top = 315
        Width = 148
        Height = 30
        AutoSize = False
        Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label5: TLabel
        Left = 18
        Top = 345
        Width = 148
        Height = 31
        AutoSize = False
        Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lbEditor: TLabel
        Left = 185
        Top = 284
        Width = 153
        Height = 31
        Alignment = taCenter
        AutoSize = False
        Layout = tlCenter
      end
      object lbpComment: TLabel
        Left = 0
        Top = 190
        Width = 353
        Height = 88
        Alignment = taCenter
        AutoSize = False
        Layout = tlCenter
        WordWrap = True
      end
      object GridTimeLines: TStringGrid
        Left = 1
        Top = 463
        Width = 352
        Height = 69
        Align = alCustom
        BorderStyle = bsNone
        Color = clBtnFace
        ColCount = 3
        Ctl3D = False
        DefaultRowHeight = 22
        FixedCols = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goRowSelect]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 0
        OnDblClick = GridTimeLinesDblClick
        OnDrawCell = GridTimeLinesDrawCell
        ColWidths = (
          34
          102
          142)
      end
    end
  end
  object PanelClips: TPanel
    Left = 105
    Top = 308
    Width = 1247
    Height = 715
    TabOrder = 2
    Visible = False
    object Panel12: TPanel
      Left = 1
      Top = 1
      Width = 305
      Height = 713
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object imgpnlbtnsclips: TImage
        Left = 0
        Top = 490
        Width = 305
        Height = 223
        Align = alBottom
        OnMouseMove = imgpnlbtnsclipsMouseMove
        OnMouseUp = imgpnlbtnsclipsMouseUp
      end
      object lbClip: TLabel
        Left = 0
        Top = 0
        Width = 305
        Height = 80
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1082#1083#1080#1087#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
      end
      object Label6: TLabel
        Left = 12
        Top = 235
        Width = 111
        Height = 25
        AutoSize = False
        Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label7: TLabel
        Left = 12
        Top = 260
        Width = 197
        Height = 24
        AutoSize = False
        Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label8: TLabel
        Left = 12
        Top = 284
        Width = 197
        Height = 25
        AutoSize = False
        Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label9: TLabel
        Left = 12
        Top = 309
        Width = 197
        Height = 25
        AutoSize = False
        Caption = #1054#1073#1097#1080#1081' '#1093#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label10: TLabel
        Left = 12
        Top = 334
        Width = 197
        Height = 24
        AutoSize = False
        Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1090#1072#1081#1084#1082#1086#1076':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label11: TLabel
        Left = 12
        Top = 358
        Width = 209
        Height = 25
        AutoSize = False
        Caption = #1061#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label12: TLabel
        Left = 12
        Top = 383
        Width = 197
        Height = 24
        AutoSize = False
        Caption = #1058#1080#1087' '#1084#1077#1076#1080#1072'-'#1076#1072#1085#1085#1099#1093
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lbClipSinger: TLabel
        Left = 129
        Top = 235
        Width = 161
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
      end
      object lbClipRegistr: TLabel
        Left = 215
        Top = 260
        Width = 74
        Height = 24
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
      end
      object lbClipStopUse: TLabel
        Left = 215
        Top = 284
        Width = 74
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
      end
      object lbClipTotalDur: TLabel
        Left = 215
        Top = 309
        Width = 74
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
      end
      object lbClipNTK: TLabel
        Left = 215
        Top = 334
        Width = 74
        Height = 24
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
      end
      object lbClipDur: TLabel
        Left = 215
        Top = 358
        Width = 74
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
      end
      object lbClipType: TLabel
        Left = 215
        Top = 383
        Width = 74
        Height = 24
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        Layout = tlCenter
      end
      object lbClipSong: TLabel
        Left = 0
        Top = 80
        Width = 305
        Height = 39
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1089#1085#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lbClipPath: TLabel
        Left = 12
        Top = 414
        Width = 287
        Height = 50
        AutoSize = False
        Caption = '...'
        WordWrap = True
      end
      object lbClipComment: TLabel
        Left = 12
        Top = 138
        Width = 287
        Height = 90
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
      end
      object Image2: TImage
        Left = 20
        Top = 482
        Width = 30
        Height = 31
        Picture.Data = {
          07544269746D617076050000424D760500000000000036000000280000001500
          0000150000000100180000000000400500000000000000000000000000000000
          0000C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3
          C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3
          C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300}
        Stretch = True
        Transparent = True
      end
    end
    object GridClips: TStringGrid
      Left = 306
      Top = 1
      Width = 940
      Height = 713
      Align = alClient
      BorderStyle = bsNone
      Ctl3D = False
      DefaultRowHeight = 35
      FixedCols = 0
      Options = [goRowSelect]
      ParentCtl3D = False
      ScrollBars = ssVertical
      TabOrder = 1
      OnDblClick = GridClipsDblClick
      OnDrawCell = GridClipsDrawCell
      OnMouseUp = GridClipsMouseUp
      OnSelectCell = GridClipsSelectCell
      OnTopLeftChanged = GridClipsTopLeftChanged
    end
  end
  object PanelPlayList: TPanel
    Left = 447
    Top = 441
    Width = 1168
    Height = 614
    Align = alCustom
    AutoSize = True
    TabOrder = 3
    Visible = False
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 384
      Height = 612
      Align = alLeft
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      object imgpnlbtnspl: TImage
        Left = 0
        Top = 372
        Width = 384
        Height = 240
        Align = alBottom
        OnMouseMove = imgpnlbtnsplMouseMove
        OnMouseUp = imgpnlbtnsplMouseUp
      end
      object lbPlayList: TLabel
        Left = 0
        Top = 0
        Width = 384
        Height = 90
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1083#1077#1081'-'#1083#1080#1089#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
      end
      object lbPLComment: TLabel
        Left = 0
        Top = 90
        Width = 384
        Height = 98
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
        WordWrap = True
      end
      object Label14: TLabel
        Left = 12
        Top = 197
        Width = 197
        Height = 25
        AutoSize = False
        Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label15: TLabel
        Left = 12
        Top = 222
        Width = 197
        Height = 24
        AutoSize = False
        Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lbPLCreate: TLabel
        Left = 209
        Top = 197
        Width = 123
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
      end
      object lbPLEnd: TLabel
        Left = 209
        Top = 222
        Width = 123
        Height = 24
        Alignment = taCenter
        AutoSize = False
        Caption = '...'
      end
      object Image1: TImage
        Left = 10
        Top = 256
        Width = 31
        Height = 31
        Picture.Data = {
          07544269746D617076050000424D760500000000000036000000280000001500
          0000150000000100180000000000400500000000000000000000000000000000
          0000C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3
          C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3
          C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C300}
        Stretch = True
        Transparent = True
        OnClick = Image1Click
      end
      object lbPLName: TLabel
        Left = 0
        Top = 320
        Width = 64
        Height = 16
        Caption = 'lbPLName'
      end
    end
    object GridActPlayList: TStringGrid
      Left = 385
      Top = 1
      Width = 782
      Height = 612
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      DefaultRowHeight = 35
      FixedCols = 0
      Options = [goRowSelect]
      ParentCtl3D = False
      ScrollBars = ssNone
      TabOrder = 1
      OnDrawCell = GridActPlayListDrawCell
      OnMouseUp = GridActPlayListMouseUp
    end
  end
  object PanelPrepare: TPanel
    Left = 648
    Top = 175
    Width = 1244
    Height = 666
    BevelOuter = bvNone
    Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1082#1072
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    Visible = False
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 1244
      Height = 430
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 0
      object pnPrepareCTL: TPanel
        Left = 0
        Top = 0
        Width = 364
        Height = 430
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'pnPrepareCTL'
        TabOrder = 0
        object imgCTLPrepare1: TImage
          Left = 0
          Top = 272
          Width = 364
          Height = 158
          Align = alBottom
          OnMouseMove = imgCTLPrepare1MouseMove
          OnMouseUp = imgCTLPrepare1MouseUp
        end
        object pnPrepareSong: TPanel
          Left = 0
          Top = 0
          Width = 364
          Height = 128
          Align = alTop
          BevelOuter = bvNone
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 0
          object lbSongName: TLabel
            Left = 79
            Top = 55
            Width = 237
            Height = 30
            AutoSize = False
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1089#1085#1080
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
          end
          object lbNomClips: TLabel
            Left = 0
            Top = 6
            Width = 70
            Height = 51
            Alignment = taCenter
            AutoSize = False
            Caption = '123'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -28
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
          end
          object lbSongSinger: TLabel
            Left = 79
            Top = 98
            Width = 237
            Height = 20
            AutoSize = False
            Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lbClipName: TLabel
            Left = 79
            Top = 10
            Width = 227
            Height = 40
            AutoSize = False
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1082#1083#1080#1087#1072
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -23
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
          end
          object imgSongLock: TImage
            Left = 20
            Top = 69
            Width = 30
            Height = 31
            Picture.Data = {
              07544269746D6170F6000000424DF60000000000000076000000280000001000
              000010000000010004000000000080000000120B0000120B0000100000000000
              0000000000000000800000800000008080008000000080008000808000008080
              8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00333333000003333333330088888003333330778707877033330888870788
              8803330777880887770333088880008888033307777000777703330888888888
              8803333000000000003333330803330803333333080333080333333308033308
              0333333377800087733333333088888033333333330000033333333333333333
              3333}
            Stretch = True
            Transparent = True
          end
          object lbPlayerFile: TLabel
            Left = 24
            Top = 112
            Width = 72
            Height = 16
            Caption = 'lbPlayerFile'
            Visible = False
          end
        end
        object PnDevTL: TPanel
          Left = 30
          Top = 177
          Width = 227
          Height = 51
          BevelOuter = bvNone
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 1
          object imgDeviceTL: TImage
            Left = 0
            Top = 0
            Width = 227
            Height = 51
            Align = alClient
            OnMouseMove = imgDeviceTLMouseMove
            OnMouseUp = imgDeviceTLMouseUp
          end
        end
        object PnTextTL: TPanel
          Left = 26
          Top = 210
          Width = 226
          Height = 167
          BevelOuter = bvNone
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 2
          Visible = False
          object imgTextTL: TImage
            Left = 0
            Top = 0
            Width = 226
            Height = 105
            Align = alTop
            OnMouseMove = imgTextTLMouseMove
            OnMouseUp = imgTextTLMouseUp
          end
          object RichEdit1: TRichEdit
            Left = 15
            Top = 105
            Width = 196
            Height = 62
            Align = alClient
            BevelKind = bkFlat
            BorderStyle = bsNone
            TabOrder = 0
          end
          object Panel8: TPanel
            Left = 0
            Top = 105
            Width = 15
            Height = 62
            Align = alLeft
            BevelOuter = bvNone
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 1
          end
          object Panel9: TPanel
            Left = 211
            Top = 105
            Width = 15
            Height = 62
            Align = alRight
            BevelOuter = bvNone
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 2
          end
        end
        object pnMediaTL: TPanel
          Left = 97
          Top = 158
          Width = 228
          Height = 109
          BevelOuter = bvNone
          Caption = 'pnMediaTL'
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 3
          Visible = False
          object imgMediaTL: TImage
            Left = 0
            Top = 0
            Width = 228
            Height = 109
            Align = alClient
            OnMouseMove = imgMediaTLMouseMove
            OnMouseUp = imgMediaTLMouseUp
          end
        end
      end
      object pnMovie: TPanel
        Left = 364
        Top = 0
        Width = 563
        Height = 430
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'pnMovie'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnResize = pnMovieResize
      end
      object pnTypeMovie: TPanel
        Left = 927
        Top = 0
        Width = 317
        Height = 430
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pnTypeMovie'
        TabOrder = 2
        object imgTypeMovie: TImage
          Left = 0
          Top = 0
          Width = 317
          Height = 430
          Align = alClient
        end
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 430
      Width = 1244
      Height = 236
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel4'
      TabOrder = 1
      object imgTimelines: TImage
        Left = 228
        Top = 1
        Width = 1020
        Height = 186
        Align = alCustom
      end
      object ImgLayer0: TImage
        Left = 256
        Top = 32
        Width = 377
        Height = 137
        Transparent = True
      end
      object imgTLNames: TImage
        Left = 1
        Top = 1
        Width = 227
        Height = 186
        Align = alCustom
        OnMouseMove = imgTLNamesMouseMove
        OnMouseUp = imgTLNamesMouseUp
      end
      object imgLayer1: TImage
        Left = 264
        Top = 40
        Width = 614
        Height = 158
        Transparent = True
      end
      object imgLayer2: TImage
        Left = 335
        Top = 10
        Width = 592
        Height = 178
        Transparent = True
        OnMouseDown = imgLayer2MouseDown
        OnMouseMove = imgLayer2MouseMove
        OnMouseUp = imgLayer2MouseUp
      end
      object Panel7: TPanel
        Left = 0
        Top = 186
        Width = 1244
        Height = 50
        Align = alBottom
        BevelOuter = bvNone
        Caption = '.'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        object imgCTLBottomL: TImage
          Left = 0
          Top = 0
          Width = 306
          Height = 50
          Align = alLeft
          OnMouseMove = imgCTLBottomLMouseMove
          OnMouseUp = imgCTLBottomLMouseUp
        end
        object lbCTLTimeCode: TLabel
          Left = 405
          Top = 0
          Width = 197
          Height = 50
          Align = alCustom
          AutoSize = False
          Caption = '0:00:00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        object imgCtlBottomR: TImage
          Left = 986
          Top = 0
          Width = 258
          Height = 50
          Align = alRight
          OnMouseMove = imgCtlBottomRMouseMove
          OnMouseUp = imgCtlBottomRMouseUp
        end
      end
    end
  end
  object PanelAir: TPanel
    Left = 1055
    Top = 49
    Width = 759
    Height = 453
    BevelOuter = bvNone
    Caption = #1069#1092#1080#1088
    TabOrder = 5
    Visible = False
    object ImgDevices: TImage
      Left = 0
      Top = 314
      Width = 759
      Height = 139
      Align = alBottom
    end
    object imgEvents: TImage
      Left = 0
      Top = 0
      Width = 759
      Height = 314
      Align = alCustom
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 1041
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Left = 1073
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 993
    Top = 112
  end
  object OpenDialog2: TOpenDialog
    Filter = #39#1060#1072#1081#1083' '#1089#1091#1073#1090#1080#1090#1088#1086#1074#39'|*.srt|'#39#1042#1089#1077' '#1092#1072#1081#1083#1099#39'|*.*'
    Left = 900
    Top = 8
  end
end
