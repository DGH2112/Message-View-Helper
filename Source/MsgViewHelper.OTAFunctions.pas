(**

  This module contains function which either call the Open Tools API or call into the internals
  of the IDE to find controls.

  @Author  David Hoyle
  @Version 1.0
  @Date    04 Jan 2018

**)
Unit MsgViewHelper.OTAFunctions;

Interface

{$INCLUDE CompilerDefinitions.inc}

Procedure ToggleMessageView;
Procedure HideMessageView;
Function CurrentDesktopName: String;
Function HasErrorOrWarningMsgs: Boolean;

Implementation

Uses
  //CodeSiteLogging,
  ToolsAPI,
  Classes,
  RTTI,
  {$IFDEF DXE20}VCL.Forms{$ELSE}Forms{$ENDIF},
  {$IFDEF DXE20}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  {$IFDEF DXE20}VCL.Controls{$ELSE}Controls{$ENDIF},
  {$IFDEF DXE20}VCL.ExtCtrls{$ELSE}ExtCtrls{$ENDIF},
  {$IFDEF DXE20}VCL.StdCtrls{$ELSE}StdCtrls{$ENDIF},
  MsgViewHelper.Constants,
  MsgViewHelper.Types;

Function FindForm(Const strFormName: String): TForm; Forward;
Function FindComponent(Const Form: TForm; Const strComponentName: String): TComponent; Forward;
Function IsDockableClassName(Const P: TWinControl): Boolean; Forward;
Function IsMessageViewVisible(Var Form: TForm; Var DockSite: TWinControl) : TMsgViewStates; Forward;

(**

  This function returns the current name of the desktop.

  @precon  None.
  @postcon Returns the current name of the desktop.

  @return  a String

**)

Function CurrentDesktopName: String;

ResourceString
  strNotFound = '(not found)';

Const
  strAppBuilder = 'AppBuilder';
  strCbDesktopName = 'cbDesktop';
  strTextProperty = 'Text';

Var
  F: TForm;
  C: TComponent;
  CB: TCustomComboBox;
  Ctx: TRttiContext;
  T: TRttiType;
  P: TRttiProperty;
  V: TValue;

Begin
  Result := strNotFound;
  F := FindForm(strAppBuilder);
  If Assigned(F) Then
    Begin
      C := FindComponent(F, strCbDesktopName);
      If Assigned(C) And (C Is TCustomComboBox) Then
        Begin
          CB := C As TCustomComboBox;
          Ctx := TRttiContext.Create;
          Try
            T := Ctx.GetType(CB.ClassType);
            P := T.GetProperty(strTextProperty);
            If Assigned(P) Then
              Begin
                V := P.GetValue(CB);
                Result := V.AsString;
              End;
          Finally
            Ctx.Free;
          End;
        End;
    End;
End;

(**

  This function returns an instance of the named componenot in the given form if found else returns nil.

  @precon  Form must be a valid instance.
  @postcon Returns an instance of the named componenot in the given form if found else returns nil.

  @param   Form             as a TForm as a constant
  @param   strComponentName as a String as a constant
  @return  a TComponent

**)
Function FindComponent(Const Form: TForm; Const strComponentName: String): TComponent;

Var
  iComponent: Integer;

Begin
  Result := Nil;
  For iComponent := 0 To Form.ComponentCount - 1 Do
    If CompareText(Form.Components[iComponent].Name, strComponentName) = 0 Then
      Begin
        Result := Form.Components[iComponent];
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

Function FindDockSite(Const SourceControl: TWinControl): TWinControl;

Var
  P: TWinControl;

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

  This method attempts to find an named form in the IDEs list of forms.

  @precon  None.
  @postcon If the form is found a reference to the form is returned.

  @param   strFormName as a String as a constant
  @return  a TForm

**)

Function FindForm(Const strFormName: String): TForm;

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

//: @nodocumentation @nochecks @nometrics
Function HasErrorOrWarningMsgs: Boolean;

Var
  F: TForm;
  {C: TComponent;
  P : TRttiProperty;
  Ctx: TRttiContext;
  T: TRttiType;
  M: TRttiMethod;
  V : TValue;
  iNodeCount: Integer;
  iNode: Integer;
  Ptr: Pointer;
  i : Integer;
  Arg1 : TValue;
  Arg2 : TValue;}

Begin
  Result := False;
  F := FindForm(strMessageViewForm);
  If Assigned(F) Then
    Begin
    {C := FindComponent(F, 'MessageTreeView0');
    CodeSite.SendFmtMsg('%s: %s', [C.Name, C.ClassName]);
    Ctx := TRttiContext.Create;
    Try
      T := Ctx.GetType(C.ClassType);
      P := T.GetProperty('RootNodeCount');
      V := P.GetValue(C);
      CodeSite.Send('RootNodeCount', V.AsInteger);
      P := T.GetProperty('RootNode');
      V := P.GetValue(C);
      CodeSite.SendEnum('V', TypeInfo(TTypeKind), Ord(V.Kind));
      V.ExtractRawData(@Ptr);
      CodeSite.SendFmtMsg('RootNode: %p', [Ptr]);
      M := T.GetMethod('GetFirstChild');
      Arg1.From(Ptr);
      V := M.Invoke(C, [Arg1]);
      V.ExtractRawData(@Ptr);
      CodeSite.SendFmtMsg('GetFirstChild: %p', [Ptr]);
      //While Ptr <> Nil Do
        Begin
          M := T.GetMethod('GetNextSibling');
          Arg1.From(Ptr);
          V := M.Invoke(C, [Arg1]);
          V.ExtractRawData(@Ptr);
          CodeSite.SendFmtMsg('GetNextSibling: %p', [Ptr]);

          //M := T.GetMethod('ZombieGetText');
          //CodeSite.Send('M', M.ToString);
          //Arg1.From(Ptr);
          //Arg2 := 0;
          //V := M.Invoke(C, [Arg1, Arg2]);
        End;
    Finally
      Ctx.Free;
    End;}
    End;
End;

(**

  This method atempts to hide the message view or if dicked its dock host.

  @precon  None.
  @postcon The message view is hidden if found.

**)

Procedure HideMessageView;

Var
  MsgViewState: TMsgViewStates;
  Form: TForm;
  DockSite: TWinControl;

Begin
  MsgViewState := IsMessageViewVisible(Form, DockSite);
  If Assigned(Form) Then
    If Assigned(DockSite) Then
      DockSite.Hide
    Else
      Form.Hide;
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

Function IsDockableClassName(Const P: TWinControl): Boolean;

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

  This method determines whether the message view has focus by looking at what the main forms
  active control is. Returns true if the active control has the classname
  "TBetterHintWindowVirtualDrawTree".

  @precon  None.
  @postcon Returns true of the message view is the active control.

  @return  a Boolean

**)

Function IsMessageViewFocused: Boolean;

Const
  strTBetterHintWindowVirtualDrawTree = 'TBetterHintWindowVirtualDrawTree';

Var
  strActiveControl: String;

Begin
  Result := False;
  If Assigned(Application.MainForm.ActiveControl) Then
    Begin
      strActiveControl := Application.MainForm.ActiveControl.ClassName;
      Result := CompareText(strActiveControl, strTBetterHintWindowVirtualDrawTree) = 0;
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

Function IsMessageViewVisible(Var Form: TForm; Var DockSite: TWinControl) : TMsgViewStates;

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
        End
      Else
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
                End
              Else
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

  @param   Form     as a TForm as a constant
  @param   DockSite as a TWinControl as a constant

**)
Procedure ShowMessageView(Const Form: TForm; Const DockSite: TWinControl);

Const
  strBuildPage = 'Build';
  strMessageTreeViewName = 'MessageTreeView0';

Var
  MsgServices: IOTAMessageServices;
  C: TComponent;

Begin
  If Assigned(DockSite) Then
    DockSite.Show
  Else
    Form.Show;
  // This is needed at IDE startup as the message view might not be visible in the dock control.
  If Not Form.Visible Then
    Form.Show;
  Form.SetFocus;
  If Supports(BorlandIDEServices, IOTAMessageServices, MsgServices) Then
    MsgServices.ShowMessageView(MsgServices.GetGroup(strBuildPage));
  C := FindComponent(Form, strMessageTreeViewName);
  If Assigned(C) Then
    If C Is TWinControl Then
      (C As TWinControl).SetFocus;
End;

(**

  This method shows the message view if it is not visible or hides it if it is.

  @precon  None.
  @postcon The message view is either hidden or shown.

**)

Procedure ToggleMessageView;

Const
  strEditWindowName = 'EditWindow_0';
  strEditorName = 'Editor';

Var
  Form: TForm;
  DockSite: TWinControl;
  MsgViewStates: TMsgViewStates;
  F: TForm;
  C: TComponent;

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
              F := FindForm(strEditWindowName);
              If Assigned(F) Then
                Begin
                  C := FindComponent(F, strEditorName);
                  If Assigned(C) Then
                    If (C As TWinControl).CanFocus Then
                      (C As TWinControl).SetFocus;
                End;
          End
        Else
          ShowMessageView(Form, DockSite);
      End
    Else
      ShowMessageView(Form, DockSite);
End;
End.
