object frmMVHOptions: TfrmMVHOptions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Message View Helper Options'
  ClientHeight = 256
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    429
    256)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlOptionsFrame: TPanel
    Left = 8
    Top = 8
    Width = 413
    Height = 209
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 265
    Top = 223
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
  object btnCancel: TBitBtn
    Left = 346
    Top = 223
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
