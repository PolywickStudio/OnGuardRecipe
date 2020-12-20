object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'OnGuard License'
  ClientHeight = 171
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object StatusLbl: TLabel
    Left = 32
    Top = 24
    Width = 25
    Height = 13
    Caption = 'Label'
  end
  object CodeLbl: TLabel
    Left = 32
    Top = 51
    Width = 25
    Height = 13
    Caption = 'Label'
  end
  object btnReg: TButton
    Left = 200
    Top = 138
    Width = 129
    Height = 25
    Caption = 'Enter Registration...'
    TabOrder = 1
    OnClick = btnRegClick
  end
  object btnRemoveReg: TButton
    Left = 65
    Top = 138
    Width = 129
    Height = 25
    Caption = 'Remove Registration'
    TabOrder = 0
    OnClick = btnRemoveRegClick
  end
  object OgRegistrationCode1: TOgRegistrationCode
    OnChecked = OgRegistrationCode1Checked
    OnGetKey = OgRegistrationCode1GetKey
    OnGetCode = OgRegistrationCode1GetCode
    OnGetRegString = OgRegistrationCode1GetRegString
    Left = 120
    Top = 72
  end
end
