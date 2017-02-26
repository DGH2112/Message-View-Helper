(**

  This module contains an IOTACompileNotifier for capturing when a compilation has been completed
  successfully.

  @Author  David Hoyle
  @Version 1.0
  @Date    26 Feb 2017

**)
Unit MsgViewHelper.CompilerNotifer;

Interface

Uses
  ToolsAPI,
  VCL.ExtCtrls,
  MsgViewHelper.Interfaces;

Type
  (** A class to implement the IOTACompileNotifier interface. **)
  TMVHCompileNotifier = Class(TInterfacedObject, IOTACompileNotifier)
  Strict Private
    FTimer      : TTimer;
  Strict Protected
    // IOTACompileNotifier
    Procedure ProjectCompileFinished(Const Project: IOTAProject; Result: TOTACompileResult);
    Procedure ProjectCompileStarted(Const Project: IOTAProject; Mode: TOTACompileMode);
    Procedure ProjectGroupCompileFinished(Result: TOTACompileResult);
    Procedure ProjectGroupCompileStarted(Mode: TOTACompileMode);
    // Other methods
    Procedure CloseMessageView(Sender : TObject);
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

  Function  InstallCompileNotifier : Integer;
  Procedure RemoveCompileNotifier(iIndex : Integer);

Implementation

Uses
  System.SysUtils,
  MsgViewHelper.OTAFunctions,
  MsgViewHelper.Options,
  MsgViewHelper.Types;

(**

  This function installs the compile notifier into the IDE and returns the index of the notifier
  which should be used when removing the notifier.

  @precon  None.
  @postcon The notifier is installed into the IDE.

  @return  an Integer

**)
Function  InstallCompileNotifier : Integer;

Var
  CS : IOTACompileServices;

Begin
  Result := -1;
  If Supports(BorlandIDEServices, IOTACompileServices, CS) Then
    Result := CS.AddNotifier(TMVHCompileNotifier.Create);
End;

(**

  This method removes the compile notifier from the IDE using the given index number.

  @precon  None.
  @postcon The compile notifier is removed from the IDE.

  @param   iIndex as an Integer

**)
Procedure RemoveCompileNotifier(iIndex : Integer);

Var
  CS : IOTACompileServices;

Begin
  If Supports(BorlandIDEServices, IOTACompileServices, CS) Then
    If iIndex > -1 Then
      CS.RemoveNotifier(iIndex);
End;

{ TMVHCompileNotifier }

(**

  This is an on timer event handler for the timer.

  @precon  None.
  @postcon Disables the timer and hide the message view.

  @param   Sender as a TObject

**)
Procedure TMVHCompileNotifier.CloseMessageView(Sender: TObject);

Begin
  FTimer.Enabled := False;
  HideMessageView;
End;

(**

  A constructor for the TMVHCompileNotifier class.

  @precon  None.
  @postcon Creates a disabled timer for timing the closing of the message view.

**)
Constructor TMVHCompileNotifier.Create;

Begin
  FTimer := TTimer.Create(Nil);
  FTimer.Enabled := False;
  FTimer.OnTimer := CloseMessageView;
End;

(**

  A destructor for the TMVHCompileNotifier class.

  @precon  None.
  @postcon Frees the timer.

**)
Destructor TMVHCompileNotifier.Destroy;

Begin
  FTimer.Free;
  Inherited Destroy;
End;

(**

  This event is called when a single project compilation is finished.

  @precon  None.
  @postcon None.

  @param   Project as an IOTAProject as a constant
  @param   Result  as a TOTACompileResult

**)
Procedure TMVHCompileNotifier.ProjectCompileFinished(Const Project: IOTAProject;
  Result: TOTACompileResult);

Begin //FI:W519
  // Do nothing
End;

(**

  This event is called when an individual project starts compiling.

  @precon  None.
  @postcon None.

  @param   Project as an IOTAProject as a constant
  @param   Mode    as a TOTACompileMode

**)
Procedure TMVHCompileNotifier.ProjectCompileStarted(Const Project: IOTAProject;
  Mode: TOTACompileMode);

Begin //FI:W519
  // Do nothing
End;

(**

  This event is called after all projects are compiled.

  @precon  None.
  @postcon If the complie is successful and auto hiding is enabled, the timer is started.

  @param   Result as a TOTACompileResult

**)
Procedure TMVHCompileNotifier.ProjectGroupCompileFinished(Result: TOTACompileResult);

Begin
  If (Result = crOTASucceeded) And (mvhoEnabled In MVHOptions.Options) Then
    Begin
      FTimer.Interval := MVHOptions.HideMessageViewDelay;
      FTimer.Enabled := True;
    End;
End;

(**

  This event is called before all projects are compiled.

  @precon  None.
  @postcon None.

  @param   Mode as a TOTACompileMode

**)
Procedure TMVHCompileNotifier.ProjectGroupCompileStarted(Mode: TOTACompileMode);

Begin //FI:W519
  // Do nothing.
End;

End.

