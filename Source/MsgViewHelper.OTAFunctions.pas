(**

  This module contains function which either call the Open Tools API or call into the internals
  of the IDE to find controls.

  @Author  David Hoyle
  @Version 1.0
  @Date    05 Mar 2017

**)
Unit MsgViewHelper.OTAFunctions;

Interface

{$INCLUDE CompilerDefinitions.inc}

  Procedure ToggleMessageView;
  Procedure HideMessageView;

Implementation

Uses
  ToolsAPI,
  {$IFDEF DXE20}VCL.Forms{$ELSE}Forms{$ENDIF},
  {$IFDEF DXE20}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  {$IFDEF DXE20}VCL.Controls{$ELSE}Controls{$ENDIF},
  {$IFDEF DXE20}Vcl.ExtCtrls{$ELSE}ExtCtrls{$ENDIF},
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
  P := SourceControl;
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

(**

  This method determines whether the message view has focus by looking at what the main forms
  active control is. Returns true if the active control has the classname
  "TBetterHintWindowVirtualDrawTree".

  @precon  None.
  @postcon Returns true of the message view is the active control.

  @return  a Boolean

**)
Function IsMessageViewFocused : Boolean;

Var
  strActiveControl: String;

Begin
  Result := False;
  If Assigned(Application.MainForm.ActiveControl) Then
    Begin
      strActiveControl := Application.MainForm.ActiveControl.ClassName;
      Result := CompareText(strActiveControl, 'TBetterHintWindowVirtualDrawTree') = 0;
    End;
End;

(**

  This method returned and set contain enumerate values saying whether the message window is
  visible and focused. It also returns via VAR parameter the message form instance and if docked
  the dock windows control reference.

  @precon  None.
  @postcon Returns a set says whether the message view is visible and focused along with the form
           instance and docking site (if docked).

  @param   Form     as a TForm as a reference
  @param   DockSite as a TWinControl as a reference
  @return  a TMsgViewStates

**)
Function IsMessageViewVisible(Var Form : TForm; Var DockSite : TWinControl) : TMsgViewStates;

Begin
  Result := [];
  Form := FindForm(strMessageViewForm);
  DockSite := Nil;
  If Assigned(Form) Then
    Begin
      If Form.Floating Then
        // If floating
        Begin
          If Form.Visible Then
            Include(Result, mvsVisible);
          If Form.Active Then
            Include(Result, mvsFocused);
        End Else
        // If Docked
        Begin
          DockSite := FindDockSite(Form);
          If DockSite Is TWinControl Then
            Begin
              // If docked to a panel we don't want to hide the panel but the message window.
              If DockSite Is TPanel Then
                Begin
                  If Form.Visible Then
                    Begin
                      Include(Result, mvsVisible);
                      If IsMessageViewFocused Then
                        Include(Result, mvsFocused);
                    End;
                  DockSite := Nil;
                End Else
                // If docked to a tabset we do want to hide the dock tabset
                Begin
                  If DockSite.Visible Then
                    Begin
                      Include(Result, mvsVisible);
                      If IsMessageViewFocused Then
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

  @param   Form     as a TForm
  @param   DockSite as a TWinControl

**)
Procedure ShowMessageView(Form : TForm; DockSite : TWinControl);

Var
  MsgServices: IOTAMessageServices;

Begin
  If Assigned(DockSite) Then
    DockSite.Show
  Else
    Form.Show;
  Form.SetFocus;
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
  MsgViewStates : TMsgViewStates;

Begin
  MsgViewStates := IsMessageViewVisible(Form, DockSite);
  If Assigned(Form) Then
    If mvsVisible In MsgViewStates Then
      Begin
        If mvsFocused In MsgViewStates Then
          Begin
            If Assigned(DockSite) Then
              DockSite.Hide
            Else
              Form.Hide;
          End Else
            ShowMessageView(Form, DockSite);
      End Else
        ShowMessageView(Form, DockSite);
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










