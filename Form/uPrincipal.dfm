object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bsb Zap Versao V10.24.013.v2'
  ClientHeight = 616
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 922
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 918
    object GbInstancia: TGroupBox
      Left = 9
      Top = 9
      Width = 897
      Height = 76
      Caption = 'Inst'#226'ncia'
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 11
        Height = 13
        Caption = 'ID'
      end
      object Label2: TLabel
        Left = 382
        Top = 16
        Width = 37
        Height = 13
        Caption = 'Api-Key'
      end
      object edtID: TEdit
        Left = 16
        Top = 35
        Width = 321
        Height = 21
        TabOrder = 0
      end
      object edtSenha: TEdit
        Left = 382
        Top = 35
        Width = 370
        Height = 21
        TabOrder = 1
      end
      object Button2: TButton
        Left = 773
        Top = 28
        Width = 98
        Height = 25
        Caption = 'Conectar'
        TabOrder = 2
        OnClick = Button2Click
      end
    end
  end
  object PnlEnvios: TPanel
    Left = 0
    Top = 103
    Width = 922
    Height = 513
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 102
    ExplicitWidth = 918
    object GbFoto: TGroupBox
      Left = 632
      Top = 10
      Width = 274
      Height = 297
      Caption = 'Foto'
      Enabled = False
      TabOrder = 0
      object ImgQrCode: TImage
        Left = 20
        Top = 84
        Width = 242
        Height = 167
        Center = True
        Proportional = True
      end
      object Label8: TLabel
        Left = 16
        Top = 14
        Width = 102
        Height = 14
        Caption = '(DDD + N'#250'mero)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BtnCarregaFoto: TButton
        Left = 74
        Top = 260
        Width = 135
        Height = 25
        Caption = 'Carregar foto Contato'
        Enabled = False
        TabOrder = 0
        OnClick = BtnCarregaFotoClick
      end
      object EdtNumeroFoto: TEdit
        Left = 16
        Top = 34
        Width = 225
        Height = 39
        Hint = 
          'Use a v'#237'rgula para informar mais de 1 n'#250'mero.'#13#10'Ex.: 84900001111,' +
          ' 83911110000'
        Color = 9435290
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
    end
    object GbDadosEnvio: TGroupBox
      Left = 9
      Top = 10
      Width = 592
      Height = 495
      Caption = 'Dados Envio Mensagem'
      Enabled = False
      TabOrder = 1
      object Label4: TLabel
        Left = 16
        Top = 23
        Width = 137
        Height = 14
        Caption = 'Para  (DDD + N'#250'mero)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 16
        Top = 87
        Width = 65
        Height = 14
        Align = alCustom
        Caption = 'Mensagem'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LbAnexos: TLabel
        Left = 18
        Top = 225
        Width = 45
        Height = 14
        Align = alCustom
        Caption = 'Anexos'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object ButAnexar: TSpeedButton
        Left = 463
        Top = 262
        Width = 110
        Height = 35
        Caption = 'Adicionar  [F3]'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Glyph.Data = {
          9A0B0000424D9A0B00000000000036000000280000001B0000001B0000000100
          200000000000640B000000000000000000000000000000000000FFFFFF00FFFF
          FF00FFFFFF00F7F6F600D9D1CE00B2AEAA00858C7D007F837900BBBABA00E4E4
          E400EEEEEE00F3F3F300F8F8F800FBFBFB00FCFCFC00FDFDFD00FEFEFE00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00F7F6F500D0B6AA009B614200525728003289
          2000356F23005B5B44008F766A00A0897D00A6979000B2AAA500C0BBB900CBC8
          C700D3D1D100DEDDDD00E7E7E700EEEEEE00F3F3F300F7F7F700FBFBFB00FDFD
          FD00FEFEFE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F9F9F900D7C0B500A96A
          3E007E6E2A0048AB3A0033CF330030B6240039721100754B1200B7592300B35F
          2D00A76338009F65420099674900966B540096746100977F7200A0908800ABA0
          9C00B5AFAE00C1C0C000CFCFCF00E5E5E500FAFAFA00FFFFFF00FFFFFF00FFFF
          FF00E9DFDA009D7855006F7B320060BC560045D3480031C82E0032C2280030B2
          1E003D8313008A611400ED7B2800F6852C00EF812B00E47C2A00DC772900D374
          2B00C2682800A9592900AC673D00A4643C009A65430092665000A0958F00E5E5
          E500FEFEFE00FFFFFF00F6F6F5009DA18C004D812C004EC3490047D3470034CC
          330031C52B0032BE250032B91E0030AE150030890C007B621100E6842900FF93
          2F00FF942F00FF943000FF933000F98D2C00E2782900E89D6400EFA55C00E9A8
          6900BC6E3B008A5B4400C4C4C400FBFBFB00FFFFFF00A7B29F003484240031BE
          300042D0420046D145003BCA360030BF250031B91F0032B31A0033AC140030A2
          0C00257F040062631000DE8A2D00FF9B3700FF9B3700FE9B3700FD9B3600EE8B
          2C00DB844400F5B67D00FCB86A00CD7333009F5A2B00A8A09B00F1F1F100FFFF
          FF00B0BDA300627636004C7F220061CA5D0073DE74006DDB6D0053CC4B003BBA
          270033AF16002EA50D00386B09007A7119008B752000D88E3600FB9F4200F99E
          4400F39C4600EF9B4800EE9E4D00E18A3E00E2956000F7B67600BD5F1A00AA61
          24009B847400E1E1E100FEFEFE00F5F1EE00BB9779007A85390072CD70008BE4
          8B008BE38B008AE18A0078D671005BC449003CAB20004E690F00F1944000F8A2
          4B00F2A25200F1A55900F0A86100F2AC6700F8B16B00FDB66E00FCB56B00E38E
          4A00E5955F00AA521500A95F1E009A725300CECCCB00FCFCFC00F5EFEB00BD92
          710081964D0084D18100A4EAA400A3E8A300A3E8A300A4E9A500A2E9A10080D1
          770053721E00EAA15E00F7B36F00F6B57600F9BA7B00FDBE7E00FFBF8000FFBE
          7D00FFBC7900FFBB7600F8B26900D87A3700924C1C00A76422009F693C00B4AD
          A900F8F8F800F6ECE700C1916500859E5A0097D49200BDF0BD00BBEEBB00BBEE
          BB00BBEEBB00C1F1C300A5E2A400597A2B00F1B47A00FEC38600FFC28800FFC4
          8900FFC38900FFC38800FFC18400FFBF8000FFBC7A00FFBD7700EBA15C008F62
          3F00A46A2E00AC6426009E8C8100ECECEC00F3E5DC00C894640089A46400B1D7
          AB00E3FBE400E0FBE100E0FBE100DFFBE100E5FBE800C4E7C2005B7C3000F3BA
          8200FFC78C00FFC68E00FFC99100FFC89100FFC89000FFC68C00FFC48700FFC0
          8100FFC07E00E59F5E0098786300A4754500C46C1E0092725D00D8D7D700ECD8
          CB00D8A2740099AD780072A05E008AB578008AB578008AB4770089B578008DB6
          7C0073A5610070884B00FCD4AF00FFD6AA00FFD2A400FFD0A000FFCE9C00FFCD
          9900FFCB9500FFC89000FFC48900FFC68700CF8B4B00A48C8100AA8B6E00D67C
          26009A653A00BAB5B200DCC5B700EBB68C00E7DCC500B4B58B00A8AE7D00A9AE
          7B00A8AC7600A5A87400A7AF7E00AAB38300E1CDAC00FFE1C100FFDEBB00FFDB
          B600FFD9B100FFD7AC00FFD3A400FFCE9C00FFCB9500FFC78E00FFC88900C27F
          4400B29F9A00B7A19300C97B3000B1652900B7ACA500D7B59D00F0C29C00FFEA
          DC00FEE5D100FFE4CD00FFE4C700FDE1C100F7D9BB00F9E2C800FFE8CF00FFE5
          C900FFE1C200FFDFBF00FFDDBB00FFDCB700FFDAB300FFD7AD00FFD3A500FFCD
          9B00FFC99100FFC58800B9794200C2B4B300C1B5B20098705600C1917100E5DC
          D700D6A68200F5D0AE00FFE7D700FEE3CF00FFE2CC00FFE2C600FEE1C200F6D9
          BA00F6DBC000FEE5CC00FFE5CB00FFE4C700FFE2C400FFE1C100FFDFBD00FFDD
          B900FFD9B300FFD7AC00FFD2A400FFCD9700FABF8100B3784800D0C7C900D3CC
          CC008B868600C0BDBD00FAF9F900D2986C00F9DFC500FFECDF00FFE6D500FFE5
          D300FFE3CD00FFE5CD00F9E0C500F3DABF00FCE5CD00FFE6CE00FFE6CB00FFE4
          C800FFE3C500FFE1C100FFDFBD00FFDCB700FFD9B100FFD5AB00FFD2A000EFB2
          7300B07F5800DAD6DA00E5DCDC009A949500A6A5A500F4F4F400D68E4B00FEBC
          7F00FFC08A00FFC29000FFC79B00FFD2AB00FAD9B800F6DDC100F0D9C000F8E5
          D000FDEAD600FEE8D100FEE7CE00FFE5CB00FFE3C800FFE1C300FFDFBD00FFDB
          B700FFD9B000FFD7AB00E5A86800B18C6E00E4E1E500F0E9E800B4AEAE008C8C
          8C00E4E4E400DD9D6200F7C89600FCD0A000FDCA9700FFC69100FCBE8300D785
          3C00CE946100DAA27200DDA97A00E9B68800EEC19600F1CAA600F2D1B000F6D7
          B500F9DABA00FADCBD00FBDDBB00FDDBB600FEDDB600DEA26600B79B8300ECEB
          ED00F5F0EF00D4CECE0085828200C9C9C900EFD2B900E8B88C00EAC09600E9BC
          9100ECBD8F00E9B17A00CCA07C00E6E3E200E5DCD600CBBBAF00E9CFB600E6C3
          A400E6BD9A00E5B99100E7BA9000EABC9200E9BB9100E8BA8B00EBBA8B00EEBE
          8D00D7965900D0BDAE00F4F3F600F8F4F400EEE9E9008C8A8A00A9A9A900FEFC
          FA00F7EBE100F1DBC900EED4BE00EFD0B600EED0B600EDE7E300FFFFFF00F8F8
          F800C5C5C600F5F4F400FCFCFD00FAF8F900F9F5F200F8F1EA00F7ECE200F3E3
          D400F1D9C400EFD4BC00EDCDAF00EAC8A900F6EFEB00FBF9FA00FBF9F900FBF9
          F900AAA7A7008B8B8B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00C9C9C900E9E9E900FFFEFE00FEFEFF00FEFE
          FF00FFFFFF00FFFFFF00FFFEFE00FFFEFE00FEFEFE00FDFDFC00FDFCFA00FFFE
          FE00FEFEFE00FEFEFE00FFFEFE00D4CECE0085848400FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEDEDE00C9C9
          C900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FEFDFD00FAFAFA00F5F3F300CAC6C600ADAC
          AC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FCFCFC00B3B3B300FDFCFC00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FEFEFE00FAFAFA00F1F1F100EAEAEA00DAD5D500C3C0
          C000B9B6B600C5C5C500F1F1F100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C2C2C200E9E8E800FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FBFAFA00E9E8E800DBDADA00D0CFCF00C5C3
          C300C4C3C300C7C7C700E8E8E800FCFCFC00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00E9E9E900C7C6C600FEFEFE00F8F8F800E5E4E400D4D3D300C4C4C400C9C7
          C700D1CFCF00D7D6D600E5E5E500FAFAFA00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FBFBFB00BBBABA00BEBEBE00BBBBBB00C2C1
          C100D7D6D600DFDFDF00EEEEEE00FCFCFC00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F5F5
          F500F1F1F100F1F0F000F4F4F400FBFBFB00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
        Margin = 4
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = ButAnexarClick
      end
      object MemoMensagem: TMemo
        Left = 16
        Top = 107
        Width = 511
        Height = 112
        Align = alCustom
        Color = clWhite
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
      end
      object EdtPara: TEdit
        Left = 16
        Top = 37
        Width = 311
        Height = 39
        Color = 9435290
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object ListBoxAnexos: TListBox
        Left = 16
        Top = 245
        Width = 441
        Height = 76
        Align = alCustom
        Color = clBtnFace
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 14
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
      end
      object GbContato: TGroupBox
        Left = 16
        Top = 347
        Width = 439
        Height = 94
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        object Label5: TLabel
          Left = 9
          Top = 17
          Width = 39
          Height = 18
          Caption = 'Nome'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 247
          Top = 17
          Width = 177
          Height = 18
          Caption = 'Telefone (DDD + N'#250'mero)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 5
          Top = 71
          Width = 416
          Height = 13
          Caption = 
            'Nesta op'#231#227'o, '#233' poss'#237'vel adicionar um contato que ser'#225' enviado ju' +
            'nto com a mensagem'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 6176518
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object EdtNomeContato: TEdit
          Left = 6
          Top = 41
          Width = 203
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object EdtNumeroContato: TEdit
          Left = 247
          Top = 41
          Width = 161
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
      object ChkContato: TCheckBox
        Left = 36
        Top = 338
        Width = 113
        Height = 17
        Caption = 'Enviar Contato'
        TabOrder = 4
        OnClick = ChkContatoClick
      end
      object ButEnviar: TBitBtn
        Left = 18
        Top = 447
        Width = 110
        Height = 40
        Caption = 'Enviar '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Glyph.Data = {
          F6060000424DF606000000000000360000002800000018000000180000000100
          180000000000C006000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFEDD6BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB87735F9F2EAFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEB87735B97D
          3EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          F3E6D7B87735FFFCF2BB8447FBF4EEF7EDE2F8EEE3F8EEE2F8EEE3F8EDE2F6EB
          DFFDFAF6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7EDE3FFFFFFFFFFFFFFFFFFFF
          FFFFFDFAF7F3E6D7B87735B87735FFFFFFB87735B87735B87735B87735B87735
          B87735B87735B87735B87735F1E1CFFFFFFFFFFFFFFFFFFFFFFFFFB87735E7CF
          B6FFFFFFFFFFFFFFFFFFF3E6D7B87735FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB87735F1E1CFFFFFFFFFFFFF
          FFFFFFB87735B87735FDFAF7FFFFFFFBF7F1B87735FFFFFFFFFFFFFFFFFFFFFF
          FDFFFFFDFFFEF7FFFDF4FFF9F1FCF3E7FEF4E5FDF1E1F8EBD7FFFFF8FFFFFFB8
          7735FFFFFFFFFFFFFFFFFFB87735FFFFFFB87735FFFFFFFFFFFFB87735FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFBFFFBF2FFF8F0FFF7
          EBFFFEF3FFFFFFB87735FFFFFFECD5BDB87735B87735FFFFFFF6EBDBA86218AF
          6E26B87735FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE
          FFFFFCFFFFF8FFF8EDFFFFFDFFFFFFB87735F2E2D1B87735FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFF8EDDEB87735FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFEF8FFFFFFFFFFFFB87735B87735FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFEFFFFFFF7ECDDB87735FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFB8
          7735B87735FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8EDDEB87735FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FEFFFFFFFFFFFFB87735B87735FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7
          ECDDB87735FDEDDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFDEDDFB87735B87735FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFF6EBDBB87735FDEDDFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEDDFB87735FFFFFFB87735FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8EDDEB87735B87735B877
          35B87735B87735B87735B87735B87735B87735B87735B87735B87735FFFFFFFF
          FFFFB87735FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFDEDDFBE8348FEFDFCFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFB87735FFF5E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEDDFB87735FFFEFDFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAF2EAB87735FDEDDFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEDDFB87735FB
          F4EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF4ED
          B87735B87735B87735B87735B87735B87735B87735B87735B87735B87735B877
          35B87735FBF4EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentFont = False
        Spacing = -1
        TabOrder = 5
        OnClick = ButEnviarClick
      end
    end
  end
  object TimerQrCode: TTimer
    Enabled = False
    Interval = 6000
    OnTimer = TimerQrCodeTimer
    Left = 830
    Top = 420
  end
  object ODAnexos: TOpenDialog
    Title = 'Selecione o anexo'
    Left = 831
    Top = 497
  end
end