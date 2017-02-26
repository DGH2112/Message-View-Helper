(**

  This module contains function which either call the Open Tools API or call into the internals
  of the IDE to find controls.

  @Author  David Hoyle
  @Version 1.0
  @Date    26 Feb 2017

**)
Unit MsgViewHelper.OTAFunctions;

Interface

  Procedure ToggleMessageView;
  Procedure HideMessageView;

Implementation

Uses
  ToolsAPI,
  VCL.Forms,
  System.SysUtils,
  VCL.Controls,
  Vcl.ExtCtrls,
  MsgViewHelper.Constants,
  MsgViewHelper.Types;

(**

  This method attempts to find an named form in the IDEs list of forms.

  @precon  None.
  @postcon If the form is found a reference to the form is returned.

  @param   strFormName as a String as a constant
  @return  a TForm

**)
Function FindForm(Const strFormName : String) : TForm;

Var
  iForm: Integer;

Begin
  Result := Nil;
  For iForm := 0 To Screen.FormCount - 1 Do
    If CompareText(strFormName, Screen.Forms[iForm].Name) = 0 Then
      Begin
        Result := Screen.Forms[iForm];
        Break;
      End;
End;

(**

  This method returns true of the given windows control matches any of the dockable class names in
  the IDE.

  @precon  P must be a valid instance.
  @postcon Returns true of the given windows control matches any of the dockable class names in
           the IDE.

  @param   P as a TWinControl as a constant
  @return  a Boolean

**)
Function IsDockableClassName(Const P : TWinControl) : Boolean;

Var
  iDockClsName: Integer;

Begin
  Result := False;
  For iDockClsName := Low(strDockClsNames) To High(strDockClsNames) Do
    If CompareText(P.ClassName, strDockClsNames[iDockClsName]) = 0 Then
      Begin
        Result := True;
        Break;
      End;
End;

(**

  This method attempts to find the first dockable form or panel that is in the parnet chain of the
  given TWinControl.

  @precon  SourceForm must be a valid instance.
  @postcon If found returns a reference to the docksite else returns nil.

  @param   SourceControl as a TWinControl as a constant
  @return  a TWinControl

**)
Function FindDockSite(Const SourceControl : TWinControl) : TWinControl;

Var
  P : TWinControl;

Begin
  Result := Nil;
  P := SourceControl; // .Parent;
  While Assigned(P) Do
    Begin
      If IsDockableClassName(P) Then
        Begin
          Result := P;
          Break;
        End;
      P := P.Parent;
   End;
End;

Function IsMessageViewVisible(Var Form : TForm; Var DockSite : TWinControl) : TMsgViewStates;

Begin
  Result := [];
  Form := FindForm(strMessageViewForm);
  DockSite := Nil;
  If Assigned(Form) Then
    Begin
      If Form.Floating Then
        Begin
          If Form.Visible Then
            Include(Result, mvsVisible);
          If CompareText(Form.Caption, 'Messages') = 0 Then
            Include(Result, mvsFocused);
        End Else
        Begin
          DockSite := FindDockSite(Form);
          If DockSite Is TWinControl Then
            Begin
              If DockSite Is TPanel Then
                Begin
                  If Form.Visible Then
                    Include(Result, mvsVisible);
                  Include(Result, mvsFocused);
                  DockSite := Nil;
                End Else
                Begin
                  If DockSite.Visible Then
                    Begin
                      Include(Result, mvsVisible);
                      If DockSite Is TForm Then
                        If CompareText((DockSite As TForm).Caption, 'Messages') = 0 Then
                          Include(Result, mvsFocused);
                    End;
                End;
            End;
        End;
    End;
End;

(**

  This method shows the message view with the build tab focused.

  @precon  None.
  @postcon The message view is displayed.

**)
Procedure ShowMessageView;

Var
  MsgServices: IOTAMessageServices;

Begin
  If Supports(BorlandIDEServices, IOTAMessageServices, MsgServices) Then
    MsgServices.ShowMessageView(MsgServices.GetGroup('Build'));
End;

(**

  This method shows the message view if it is not visible or hides it if it is.

  @precon  None.
  @postcon The message view is either hidden or shown.

**)
Procedure ToggleMessageView;

Var
  Form: TForm;
  DockSite: TWinControl;
  MsgViewState : TMsgViewStates;

Begin
  MsgViewState := IsMessageViewVisible(Form, DockSite);
  If Assigned(Form) Then
    If mvsVisible In MsgViewState Then
      Begin
        If mvsFocused In MsgViewState Then
          Begin
            If Assigned(DockSite) Then
              DockSite.Hide
            Else
              Form.Hide;
          End Else
            ShowMessageView;
      End Else
        ShowMessageView;
End;

(**

  This method atempts to hide the message view or if dicked its dock host.

  @precon  None.
  @postcon The message view is hidden if found.

**)
Procedure HideMessageView;

Var
  MsgViewState: TMsgViewStates;
  Form : TForm;
  DockSite: TWinControl;

Begin
  MsgViewState := IsMessageViewVisible(Form, DockSite);
  If Assigned(Form) Then
    If Assigned(DockSite) Then
      DockSite.Hide
    Else
      Form.Hide;
End;

End.









