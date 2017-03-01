(**

  This module contains constants for use throughout the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    27 Feb 2017

**)
Unit MsgViewHelper.Constants;

Interface

Uses
  MsgViewHelper.Types;

Const
  (** The name of the message view form in the IDE. **)
  strMessageViewForm = 'MessageViewForm';
  (** A list of classnames of docking sites in the IDE. **)
  strDockClsNames : Array[1..3] Of String = (
    'TTabDockHostForm',
    'TIDEDockTabSet',
    'TEditorDockPanel'
  );
  (** A constant array of default options for the application (used to load and save ini
      information). **)
  DefaultOptions : Array[Low(TMVHBoolOption)..High(TMVHBoolOption)] Of TDefaultOptions = (
    (FOptionName: 'EnabledHiding'; FDefault: True)
  );

Implementation

End.
