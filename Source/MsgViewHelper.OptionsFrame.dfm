object frameMVHOptions: TframeMVHOptions
  Left = 0
  Top = 0
  Width = 357
  Height = 173
  TabOrder = 0
  DesignSize = (
    357
    173)
  object lblToggleMessageView: TLabel
    Left = 3
    Top = 3
    Width = 351
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Toggle Message View &Shortcut'
    FocusControl = hkTogglerMessageView
    ExplicitWidth = 341
  end
  object lblAutomaticDelay: TLabel
    Left = 3
    Top = 70
    Width = 282
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Automatic Delay Period for closing the message view'
    ExplicitWidth = 264
  end
  object hkTogglerMessageView: THotKey
    Left = 3
    Top = 19
    Width = 351
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    HotKey = 32833
    TabOrder = 0
    ExplicitWidth = 348
  end
  object chkEnable: TCheckBox
    Left = 3
    Top = 44
    Width = 351
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = '&Enable Automatic Hiding After Successfult Compilation'
    TabOrder = 1
    ExplicitWidth = 348
  end
  object edtAutomaticDelay: TEdit
    Left = 291
    Top = 67
    Width = 49
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 2
    Text = '0'
    ExplicitLeft = 288
  end
  object udAutomaticDelay: TUpDown
    Left = 337
    Top = 67
    Width = 16
    Height = 21
    Anchors = [akTop, akRight]
    Associate = edtAutomaticDelay
    Max = 3600
    TabOrder = 3
  end
end
