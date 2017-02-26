(**

  This module contains an a class to handle the installation of the options frame into the IDEs
  options dialogue.

  @Author  David Hoyle
  @Version 1.0
  @Date    26 Feb 2017

**)
Unit MsgViewHelper.OptionsIDEInterface;

Interface

Uses
  ToolsAPI,
  MsgViewHelper.OptionsFrame,
  VCL.Forms;

Type
  (** A class which implements the INTAAddingOptions interface to added options frames
      to the IDEs options dialogue. **)
  TMVHIDEOptionsHandler = Class(TInterfacedObject, INTAAddInOptions)
  Strict Private
    Class Var
      (** A class variable to hold the instance reference for this IDE options handler. **)
      FMVHIDEOptions : TMVHIDEOptionsHandler;
  Strict Private
    FMVHFrame : TframeMVHOptions;
  Strict Protected
  Public
    Procedure DialogClosed(Accepted: Boolean);
    Procedure FrameCreated(AFrame: TCustomFrame);
    Function GetArea: String;
    Function GetCaption: String;
    Function GetFrameClass: TCustomFrameClass;
    Function GetHelpContext: Integer;
    Function IncludeInIDEInsight: Boolean;
    Function ValidateContents: Boolean;
    Class Procedure AddOptionsFrameHandler;
    Class Procedure RemoveOptionsFrameHandler;
  End;

Implementation

Uses
  System.SysUtils;

(**

  This is a class method to add the options frame handler to the IDEs options dialogue.

  @precon  None.
  @postcon The IDE options handler is installed into the IDE.

**)
Class Procedure TMVHIDEOptionsHandler.AddOptionsFrameHandler;

Var
  EnvironmentOptionsServices : INTAEnvironmentOptionsServices;

Begin
  FMVHIDEOptions := TMVHIDEOptionsHandler.Create;
  If Supports(BorlandIDEServices, INTAEnvironmentOptionsServices, EnvironmentOptionsServices) Then
    EnvironmentOptionsServices.RegisterAddInOptions(FMVHIDEOptions);
End;

(**

  This method is called by the IDE when the IDEs options dialogue is closed.

  @precon  None.
  @postcon If the dialogue was accepted and the frame supports the interface then it saves
           the frame settings.

  @param   Accepted as a Boolean

**)
Procedure TMVHIDEOptionsHandler.DialogClosed(Accepted: Boolean);

Begin
  If Accepted Then
    FMVHFrame.FinaliseFrame;
End;

(**

  This method is called by the IDe when the frame is created.

  @precon  None.
  @postcon If the frame supports the interface its settings are loaded.

  @param   AFrame as a TCustomFrame

**)
Procedure TMVHIDEOptionsHandler.FrameCreated(AFrame: TCustomFrame);

Begin
  FMVHFrame := AFrame As TframeMVHOptions;
  FMVHFrame.InitialiseFrame;
End;

(**

  This is a getter method for the Area property.

  @precon  None.
  @postcon Called by the IDE. NULL string is returned to place the options frame under the
           third party node.

  @return  a String

**)
Function TMVHIDEOptionsHandler.GetArea: String;

Begin
  Result := '';
End;

(**

  This is a getter method for the Caption property.

  @precon  None.
  @postcon This is called by the IDe to get the caption of the options frame in the IDEs
           options dialogue in the left treeview.

  @return  a String

**)
Function TMVHIDEOptionsHandler.GetCaption: String;

Begin
  Result := 'Message View Helper';
End;

(**

  This is a getter method for the FrameClass property.

  @precon  None.
  @postcon This is called by the IDE to get the frame class to create when displaying the
           options dialogue.

  @return  a TCustomFrameClass

**)
Function TMVHIDEOptionsHandler.GetFrameClass: TCustomFrameClass;

Begin
  Result := TframeMVHOptions;
End;

(**

  This is a getter method for the HelpContext property.

  @precon  None.
  @postcon This is called by the IDe and returns 0 to signify no help.

  @return  an Integer

**)
Function TMVHIDEOptionsHandler.GetHelpContext: Integer;

Begin
  Result := 0;
End;

(**

  This is called by the IDE to determine whether the controls on the options frame are
  displayed in the IDE Insight search.

  @precon  None.
  @postcon Returns true to be include in IDE Insight.

  @return  a Boolean

**)
Function TMVHIDEOptionsHandler.IncludeInIDEInsight: Boolean;

Begin
  Result := True;
End;

(**

  This is a class method to remove the options frame handler from the IDEs options dialogue.

  @precon  None.
  @postcon The IDE options handler is removed from the IDE.

**)
Class Procedure TMVHIDEOptionsHandler.RemoveOptionsFrameHandler;

Var
  EnvironmentOptionsServices : INTAEnvironmentOptionsServices;

Begin
  If Supports(BorlandIDEServices, INTAEnvironmentOptionsServices, EnvironmentOptionsServices) Then
    EnvironmentOptionsServices.UnregisterAddInOptions(FMVHIDEOptions);
End;

(**

  This method is called by the IDE to validate the frame.

  @precon  None.
  @postcon Not used so returns true.

  @return  a Boolean

**)
Function TMVHIDEOptionsHandler.ValidateContents: Boolean;

Begin
  Result := True;
End;

End.
