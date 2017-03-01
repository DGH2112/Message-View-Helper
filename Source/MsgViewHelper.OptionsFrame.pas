(**

  This module contains a frame for configuring the applications options.
  This frame is either installed in the IDEs options dialogue or in a separate option dialogue
  depending upon the IDe version.

  @Author  David Hoyle
  @Version 1.0
  @Date    01 Mar 2017

**)
Unit MsgViewHelper.OptionsFrame;

Interface

{$INCLUDE CompilerDefinitions.inc}

Uses
  {$IFDEF DXE20}Vcl.Forms{$ELSE}Forms{$ENDIF},
  {$IFDEF DXE20}Vcl.ComCtrls{$ELSE}ComCtrls{$ENDIF},
  {$IFDEF DXE20}Vcl.StdCtrls{$ELSE}StdCtrls{$ENDIF},
  {$IFDEF DXE20}Vcl.Controls{$ELSE}Controls{$ENDIF},
  {$IFDEF DXE20}System.Classes{$ELSE}Classes{$ENDIF};

Type
  (** A frame to host the applications options so they can be shown in either the IDEs options
      dialogue or in a form. **)
  TframeMVHOptions = Class(TFrame)
    lblToggleMessageView: TLabel;
    hkTogglerMessageView: THotKey;
    chkEnable: TCheckBox;
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
  TMVHOptions.MVHOptions.MessageViewShortCut := hkTogglerMessageView.HotKey;
  Ops := [];
  If chkEnable.Checked Then
    Include(Ops, mvhoEnabled);
  TMVHOptions.MVHOptions.Options := Ops;
End;

(**

  This method configures the dialogue with the applications options.

  @precon  None.
  @postcon The diaogue is configured with the current options.

**)
Procedure TframeMVHOptions.InitialiseFrame;

Begin
  hkTogglerMessageView.HotKey := TMVHOptions.MVHOptions.MessageViewShortCut;
  chkEnable.Checked := mvhoEnabled In TMVHOptions.MVHOptions.Options;
End;

End.
