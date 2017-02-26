object frameMVHOptions: TframeMVHOptions
  Left = 0
  Top = 0
  Width = 354
  Height = 188
  TabOrder = 0
  DesignSize = (
    354
    188)
  object lblToggleMessageView: TLabel
    Left = 3
    Top = 3
    Width = 348
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Toggle Message View &Shortcut'
    FocusControl = hkTogglerMessageView
    ExplicitWidth = 341
  end
  object hkTogglerMessageView: THotKey
    Left = 3
    Top = 19
    Width = 348
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    HotKey = 32833
    TabOrder = 0
  end
  object chkEnable: TCheckBox
    Left = 3
    Top = 44
    Width = 348
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = '&Enable Automatic Hiding After Successfult Compilation'
    TabOrder = 1
  end
  object gbxOptions: TRadioGroup
    Left = 3
    Top = 67
    Width = 348
    Height = 70
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Options'
    Items.Strings = (
      'Hide / Show Docking &Panel'
      'Hide / Show Docking &Tabs')
    TabOrder = 2
  end
end
