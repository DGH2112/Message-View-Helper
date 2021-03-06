(**

  This module contains simlpes types for use throughout the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    27 Feb 2017

**)
Unit MsgViewHelper.Types;

Interface

Type
  (** An enumerate to define state for the message window. **)
  TMsgViewState = (
    mvsVisible,  // Is visible in the IDE
    mvsFocused   // Has focus
  );
  (** A set of the above states. **)
  TMsgViewStates = Set Of TMsgViewState;
  (** An enumerate of boolean options for the application. **)
  TMVHBoolOption = (
    mvhoEnabled  // Enable automatic closing of the message window
  );
  (** A set of the above options. **)
  TMVHBoolOptions = Set Of TMVHBoolOption;
  (** A record to describe the default options constant for the apps boolean options. **)
  TDefaultOptions = Record
    FOptionName : String;
    FDefault    : Boolean;
  End;

Implementation

End.
