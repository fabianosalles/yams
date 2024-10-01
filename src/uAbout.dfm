object frmAbout: TfrmAbout
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 320
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 297
    Height = 273
    BevelInner = bvRaised
    BevelOuter = bvLowered
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object Panel2: TPanel
      Left = 7
      Top = 7
      Width = 283
      Height = 100
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Version: TLabel
        Left = 72
        Top = 28
        Width = 150
        Height = 13
        Caption = 'Yet Another Mine Sweeper'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        IsControl = True
      end
      object ProductName: TLabel
        Left = 72
        Top = 6
        Width = 73
        Height = 23
        Caption = 'Y.A.M.S'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        IsControl = True
      end
      object ProgramIcon: TImage
        Left = 8
        Top = 3
        Width = 50
        Height = 50
        Picture.Data = {
          07544269746D6170AA030000424DAA0300000000000036000000280000001100
          000011000000010018000000000074030000120B0000120B0000000000000000
          0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000000000000000000000
          000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000C0C0C0C0C0C0C0C0C0C0
          C0C000000000000000FFFF00FFFF00FFFF00FFFF00FFFF000000000000C0C0C0
          C0C0C0C0C0C0C0C0C000C0C0C0C0C0C0C0C0C000000000FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF000000C0C0C0C0C0C0C0C0C000C0C0
          C0C0C0C000000000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF000000C0C0C0C0C0C000C0C0C000000000FFFF00FFFF00FF
          FF00FFFF00000000000000000000000000000000FFFF00FFFF00FFFF00FFFF00
          0000C0C0C000C0C0C000000000FFFF00FFFF00FFFF00000000FFFF00FFFF00FF
          FF00FFFF00FFFF00000000FFFF00FFFF00FFFF000000C0C0C00000000000FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF0000000000000000FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF0000
          000000000000000000FFFF00FFFF00808000000000000000FFFF00FFFF00FFFF
          00000000000000808000FFFF00FFFF0000000000000000000000FFFF00000000
          FFFF00000000000000000000000000FFFF00000000000000000000000000FFFF
          00000000FFFF0000000000000000FFFF00FFFF00000000000000000000000000
          000000FFFF00000000000000000000000000000000FFFF00FFFF00000000C0C0
          C000000000FFFF00FFFF00000000000000000000000000000000000000000000
          000000000000FFFF00FFFF000000C0C0C000C0C0C000000000FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          0000C0C0C000C0C0C0C0C0C000000000FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF000000C0C0C0C0C0C000C0C0C0C0C0C0
          C0C0C000000000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF000000C0C0C0C0C0C0C0C0C000C0C0C0C0C0C0C0C0C0C0C0C0000000000000
          00FFFF00FFFF00FFFF00FFFF00FFFF000000000000C0C0C0C0C0C0C0C0C0C0C0
          C000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000000000000000000000
          000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000}
        Stretch = True
        Transparent = True
        IsControl = True
      end
      object Copyright: TLabel
        Left = 72
        Top = 64
        Width = 81
        Height = 13
        Caption = 'By Fabiano Sales'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        IsControl = True
      end
      object Bevel1: TBevel
        Left = 8
        Top = 58
        Width = 270
        Height = 2
      end
      object Label2: TLabel
        Left = 72
        Top = 43
        Width = 22
        Height = 11
        Caption = 'v.0.9'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        IsControl = True
      end
    end
    object Memo1: TMemo
      Left = 79
      Top = 90
      Width = 206
      Height = 167
      Color = clBtnFace
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'This game was originally written in '
        'Delphi 7 at the end of 2003 as a '
        'learning exercise of both Object '
        'Pascal language and Windows game '
        'programming.'
        ''
        'The original source code was '
        'published in the good old Delphi Pages '
        'site which now is, unfortunately, '
        'dead. It was an awesome lucky '
        'moment when I found a nearly '
        'finished version of its source in a '
        'dusty backup CDROM and now I'#39'm '
        'making it available again on Git Hub.'
        ''
        'It opened and was compiled flawlessly '
        '21 years after, in Delphi 12. Dude, '
        'that'#39's just awesome!!')
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      WantReturns = False
    end
  end
  object OKButton: TButton
    Left = 229
    Top = 287
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OKButtonClick
  end
end
