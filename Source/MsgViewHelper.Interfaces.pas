(**

  This module contains interfaces for objects created by the application (which are not already
  interfaced by the OTA).

  @Author  David Hoyle
  @Version 1.0
  @Date    25 Feb 2017

**)
Unit MsgViewHelper.Interfaces;

Interface

Uses
  System.Classes,
  MsgViewHelper.Types;

Type
  (** This interface provides access to the applications options. **)
  IMVHOptions = Interface
  ['{721E35AE-94EF-442F-970A-C3D99DDA76DD}']
    Function  GetMessageViewShortcut : TShortcut;
    Procedure SetMessageViewShortcut(Const iShortcut : TShortcut);
    Function  GetHideMessageViewDelay : Integer;
    Procedure SetHideMessageViewDelay(Const iDelayInMSec : Integer);
    Function  GetOptions : TMVHBoolOptions;
    Procedure SetOptions(Const setOptions : TMVHBoolOptions);
    (**
      This property defines the shortcut that is used to toggles the display of the message view.
      @precon  None.
      @postcon Gets or sets the shortcut for the toggling of the message view.
      @return  a TShortcut
    **)
    Property MessageViewShortCut : TShortcut Read GetMessageViewShortCut
      Write SetMessageViewShortCut;
    (**
      This property defines the delay period after compilation completion before the message view
      is hidden.
      @precon  None.
      @postcon Gets and sets the delay period.
      @return  an Integer
    **)
    Property HideMessageViewDelay : Integer Read GetHideMessageViewDelay
      Write SetHideMessageViewDelay;
    (**
      This poperty is a set of boolean options for the application.
      @precon  None.
      @postcon Get and sets the options.
      @return  a TMVHBoolOptions
    **)
    Property Options : TMVHBoolOptions Read GetOptions Write SetOptions;
  End;

Implementation

End.
