(**

  This module contains a frame for configuring the applications options.
  This frame is either installed in the IDEs options dialogue or in a separate option dialogue
  depending upon the IDe version.

  @Author  David Hoyle
  @Version 1.0
  @Date    26 Feb 2017

**)
Unit MsgViewHelper.OptionsFrame;

Interface

Uses
  Vcl.Forms,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Controls,
  System.Classes,
  Vcl.ExtCtrls;

Type
  (** A frame to host the applications options so they can be shown in either the IDEs options
      dialogue or in a form. **)
  TframeMVHOptions = Class(TFrame)
    lblToggleMessageView: TLabel;
    hkTogglerMessageView: THotKey;
    chkEnable: TCheckBox;
    gbxOptions: TRadioGroup;
  Private
    { Private declarations }
  Public
    { Public declarations }
    Procedure InitialiseFrame;
    Procedure FinaliseFrame;
  End;

Implementation

Uses
  MsgViewHelper.Options,
  MsgViewHelper.Types;

{$R *.dfm}

{ TFrame1 }

(**

  This method saves the asettings from the dialogue to the applciations options interface.

  @precon  None.
  @postcon The applications options are updated.

**)
Procedure TframeMVHOptions.FinaliseFrame;

Var
  Ops : TMVHBoolOptions;

Begin
  MVHOptions.MessageViewShortCut := hkTogglerMessageView.HotKey;
  Ops := [];
  If chkEnable.Checked Then
    Include(Ops, mvhoEnabled);
  If gbxOptions.ItemIndex = 0 Then
    Include(Ops, mvhoPanel)
  Else
    Include(Ops, mvhoTabs);
  MVHOptions.Options := Ops;
End;

(**

  This method configures the dialogue with the applications options.

  @precon  None.
  @postcon The diaogue is configured with the current options.

**)
Procedure TframeMVHOptions.InitialiseFrame;

Begin
  hkTogglerMessageView.HotKey := MVHOptions.MessageViewShortCut;
  chkEnable.Checked := mvhoEnabled In MVHOptions.Options;
  If mvhoPanel In MVHOptions.Options Then
    gbxOptions.ItemIndex := 0
  Else
    gbxOptions.ItemIndex := 1;
End;

End.
