(**

  This module contains the main plug-in wizard to be installed into the IDE. This wizard managed all
  other objects in the plug-in.

  @Author  David Hoyle
  @Version 1.0
  @Date    26 Feb 2017

**)
Unit MsgViewHelper.Wizard;

Interface

Uses
  VCL.ActnList,
  ToolsAPI,
  MsgViewHelper.Interfaces;

{$INCLUDE CompilerDefinitions.INC}

Type
  (** The plug-ins main wizard **)
  TMVHWizard = Class(TInterfacedObject, IOTAWizard {$IFNDEF DXE00}, IOTAMenuWizard{$ENDIF})
  Strict Private
    FToggleMsgViewAction:  TAction;
    FCompileNotifierIndex: Integer;
    FAboutBoxIndex:        Integer;
  Strict Protected
    // IOTAWizard
    Procedure Execute;
    Function  GetIDString: String;
    Function  GetName: String;
    Function  GetState: TWizardState;
    Procedure AfterSave;
    Procedure BeforeSave;
    Procedure Destroyed;
    Procedure Modified;
    {$IFNDEF DXE00}
    // IOTAMenuWizard
    Function  GetMenuText: String;
    {$ENDIF}
    // Other Methods
    Procedure ToggleMessageViewAction(Sender: TObject);
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

Procedure Register;

Implementation

Uses
  MsgViewHelper.OTAFunctions,
  VCL.Forms,
  System.SysUtils,
  VCL.Menus,
  MsgViewHelper.CompilerNotifer,
  MsgViewHelper.Options,
  Vcl.Controls,
  MsgViewHelper.Types,
  MsgViewHelper.SplashScreen,
  MsgViewHelper.AboutBox,
  MsgViewHelper.OptionsForm,
  MsgViewHelper.OptionsIDEInterface;

{$R MsgViewHelperImages.RES}
{$R ..\Packages\MsgViewHelperITHVerInfo.RES ..\Packages\MsgViewHelperITHVerInfo.RC}

(**

  This procedure registers the main plug-in wizard in the IDE as the package is loaded.

  @precon  None.
  @postcon The plug-in is registered with the IDE.

**)
Procedure Register;

Begin
  RegisterPackageWizard(TMVHWizard.Create);
End;

{ TMVHWizard }

(**

  This method is not called for an IOTAWizard or IOTAMenuWizard but is required by their interfaces.

  @precon  None.
  @postcon None.

**)
Procedure TMVHWizard.AfterSave;

Begin //FI:W519
  // Do nothing
End;

(**

  This method is not called for an IOTAWizard or IOTAMenuWizard but is required by their interfaces.

  @precon  None.
  @postcon None.

**)
Procedure TMVHWizard.BeforeSave;

Begin //FI:W519
  // Do nothing
End;

(**

  A constructor for the TMVHWizard class.

  @precon  None.
  @postcon Installs an action and secondary notifiers and objects into the IDE.

**)
Constructor TMVHWizard.Create;

Var
  NService: INTAServices;

Begin
  AddSplashScreen;
  FAboutBoxIndex := AddAboutBoxEntry;
  FToggleMsgViewAction := Nil;
  If Supports(BorlandIDEServices, INTAServices, NService) Then
    Begin
      FToggleMsgViewAction := TAction.Create(NService.ActionList);
      FToggleMsgViewAction.ActionList := NService.ActionList;
      FToggleMsgViewAction.Name := 'DGHMsgViewHelperToggleMessageView';
      FToggleMsgViewAction.Caption := 'Toggle Message View';
      FToggleMsgViewAction.OnExecute := ToggleMessageViewAction;
      FToggleMsgViewAction.ShortCut := MVHOptions.MessageViewShortCut;
      FToggleMsgViewAction.Category := 'OTATemplateMenus';
    End;
  FCompileNotifierIndex := InstallCompileNotifier;
  TMVHIDEOptionsHandler.AddOptionsFrameHandler;
End;

(**

  A destructor for the TMVHWizard class.

  @precon  None.
  @postcon Removes all secondary notifiers and objects from the IDE.

**)
Destructor TMVHWizard.Destroy;

Begin
  TMVHIDEOptionsHandler.RemoveOptionsFrameHandler;
  RemoveCompileNotifier(FCompileNotifierIndex);
  If FToggleMsgViewAction <> Nil Then
    FToggleMsgViewAction.Free;
  RemoveAboutBoxEntry(FAboutBoxIndex);
  Inherited Destroy;
End;

(**

  This method is not called for an IOTAWizard or IOTAMenuWizard but is required by their interfaces.

  @precon  None.
  @postcon None.

**)
Procedure TMVHWizard.Destroyed;

Begin //FI:W519
  // Do nothing
End;

(**

  This method dislpays the options in the IDEs options dialogue if XE or above else dislpay the
  option in a standard dialogue.

  @precon  None.
  @postcon The options are displayed.

**)
Procedure TMVHWizard.Execute;

Var
  Services : IOTAServices;

Begin
  {$IFDEF DXE00}
  If Supports(BorlandIDEServices, IOTAServices, Services) Then
    Services.GetEnvironmentOptions.EditOptions('', 'Message View Helper');
  {$ELSE}
  If TfrmMVHOptions.Execute Then
  {$ENDIF}
  FToggleMsgViewAction.ShortCut := MVHOptions.MessageViewShortCut;
End;

(**

  This is a getter method for the IDString property.

  @precon  None.
  @postcon Returns the ID string (must be unique) for the plug-in.

  @return  a String

**)
Function TMVHWizard.GetIDString: String;

Begin
  Result := 'DGH.MsgViewHelper.Wizard';
End;

{$IFNDEF DXE00}
(**

  This is a getter method for the MenuText property.

  @precon  None.
  @postcon The menu text for the plug-in is returned.

  @return  a String

**)
Function TMVHWizard.GetMenuText: String;

Begin
  Result := 'Message View Helper Options';
End;
{$ENDIF}

(**

  This is a getter method for the Name property.

  @precon  None.
  @postcon The name of the plug-in is returned.

  @return  a String

**)
Function TMVHWizard.GetName: String;

Begin
  Result := 'Message View Helper';
End;

(**

  This is a getter method for the WizardState property.

  @precon  None.
  @postcon Returns a value to indicate that the plug-in wizard is enabled.

  @return  a TWizardState

**)
Function TMVHWizard.GetState: TWizardState;

Begin
  Result := [wsEnabled];
End;

(**

  This method is not called for an IOTAWizard or IOTAMenuWizard but is required by their interfaces.

  @precon  None.
  @postcon None.

**)
Procedure TMVHWizard.Modified;

Begin //FI:W519
  // Do nothing
End;

(**

  This is an action on execute event handler for the hidden action that is added to the IDE.

  @precon  None.
  @postcon Toggles the visibility of the Message View.

  @param   Sender as a TObject

**)
Procedure TMVHWizard.ToggleMessageViewAction(Sender: TObject);

Begin
  ToggleMessageView;
End;

End.

