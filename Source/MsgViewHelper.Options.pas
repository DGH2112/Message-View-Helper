(**

  This module contains a concrete class to implement the IMVHOptions interface - an interface
  to the applications options whic are loaded and saved to an INI file.

  @Author  David Hoyle
  @Version 1.0
  @Date    01 Mar 2017

**)
Unit MsgViewHelper.Options;

Interface

{$INCLUDE CompilerDefinitions.inc}

Uses
  {$IFDEF DXE20}System.Classes{$ELSE}Classes{$ENDIF},
  MsgViewHelper.Types,
  MsgViewHelper.Interfaces;

Type
  (** A class which implements the IMVHOptions interface. **)
  TMVHOptions = Class(TInterfacedObject, IMVHOptions)
  Strict Private
    Class Var
      (** A class variable to hold the instance of the application options interface. **)
      FMVHOptions : IMVHOptions;
  Strict Private
    FMessageViewShortCut:  TShortcut;
    FHideMessageViewDelay: Integer;
    FBoolOptions:          TMVHBoolOptions;
    FINIFileName:          String;
  Strict Protected
    Function  GetHideMessageViewDelay: Integer;
    Function  GetMessageViewShortcut: TShortcut;
    Procedure SetHideMessageViewDelay(Const iDelayInMSec: Integer);
    Procedure SetMessageViewShortcut(Const iShortcut: TShortcut);
    Function  GetOptions: TMVHBoolOptions;
    Procedure SetOptions(Const sOptions: TMVHBoolOptions);
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Class Function MVHOptions : IMVHOptions;
  End;

Implementation

Uses
  MsgViewHelper.Constants,
  INIFiles,
  MsgViewHelper.Functions,
  {$IFDEF DXE20}VCL.Menus{$ELSE}Menus{$ENDIF};

{ TMVHOptions }

(**

  A constructor for the TMVHOptions class.

  @precon  None.
  @postcon The applications settings are loaded from the INI file.

**)
Constructor TMVHOptions.Create;

Var
  INIFile: TMemIniFile;
  iOp:     TMVHBoolOption;

Begin
  FINIFileName := INIFileName;
  INIFile := TMemIniFile.Create(FINIFileName);
  Try
    FMessageViewShortCut := TextToShortcut(
      INIFile.ReadString('Setup', 'MessageViewShortcut', 'Shift+Alt+M'));
    FHideMessageViewDelay := INIFile.ReadInteger('Setup', 'HideMessageViewDelay', 5000);
    FBoolOptions := [];
    For iOp := Low(TMVHBoolOption) To High(TMVHBoolOption) Do
      If INIFile.ReadBool('Options', DefaultOptions[iOp].FOptionName,
        DefaultOptions[iOp].FDefault) Then
        Include(FBoolOptions, iOp);
  Finally
    INIFile.Free;
  End;
End;

(**

  A destructor for the TMVHOptions class.

  @precon  None.
  @postcon The applications settings are asved to the INI file.

**)
Destructor TMVHOptions.Destroy;

Var
  INIFile: TMemIniFile;
  iOp: TMVHBoolOption;

Begin
  INIFile := TMemIniFile.Create(FINIFileName);
  Try
    INIFile.WriteString('Setup', 'MessageViewShortcut', ShortCutToText(FMessageViewShortCut));
    INIFile.WriteInteger('Setup', 'HideMessageViewDelay', FHideMessageViewDelay);
    For iOp := Low(TMVHBoolOption) To High(TMVHBoolOption) Do
      INIFile.WriteBool('Options', DefaultOptions[iOp].FOptionName, iOp In FBoolOptions);
    INIFile.UpdateFile;
  Finally
    INIFile.Free;
  End;
  Inherited Destroy;
End;

(**

  This is a getter method for the HideMessageViewDelay property.

  @precon  None.
  @postcon The time in millisecond before the message view should be hidden is after a
           successful compilation is returned.

  @return  an Integer

**)
Function TMVHOptions.GetHideMessageViewDelay: Integer;

Begin
  Result := FHideMessageViewDelay;
End;

(**

  This is a getter method for the MessageViewShortcut property.

  @precon  None.
  @postcon The shortcut to be associated with the showing.hiding of the message view is returned.

  @return  a TShortcut

**)
Function TMVHOptions.GetMessageViewShortcut: TShortcut;

Begin
  Result := FMessageViewShortCut;
End;

(**

  This is a getter method for the Options property.

  @precon  None.
  @postcon The set of boolean options is returned.

  @return  a TMVHBoolOptions

**)
Function TMVHOptions.GetOptions: TMVHBoolOptions;

Begin
  Result := FBoolOptions;
End;

(**

  This is a class method to provide a singleton interfaces to the applications options.

  @precon  None.
  @postcon If the options do not exist they are created and reference to a class var for future
           use.

  @return  an IMVHOptions

**)
Class Function TMVHOptions.MVHOptions: IMVHOptions;

Begin
  If Not Assigned(FMVHOptions) Then
    FMVHOptions := TMVHOptions.Create;
  Result := FMVHOptions;
End;

(**

  This is a setter method for the HideMessageViewDelay property.

  @precon  None.
  @postcon The delay in milliseconds is updated.

  @param   iDelayInMSec as an Integer as a constant

**)
Procedure TMVHOptions.SetHideMessageViewDelay(Const iDelayInMSec: Integer);

Begin
  If iDelayInMSec <> FHideMessageViewDelay Then
    FHideMessageViewDelay := iDelayInMSec;
End;

(**

  This is a setter method for the MessageViewShortcut property.

  @precon  None.
  @postcon The shortcut for hidingshowing the message view is updated.

  @param   iShortcut as a TShortcut as a constant

**)
Procedure TMVHOptions.SetMessageViewShortcut(Const iShortcut: TShortcut);

Begin
  If iShortcut <> FMessageViewShortCut Then
    FMessageViewShortCut := iShortcut;
End;

(**

  This is a setter method for the Options property.

  @precon  None.
  @postcon The boolean options are updated.

  @param   sOptions as a TMVHBoolOptions as a constant

**)
Procedure TMVHOptions.SetOptions(Const sOptions: TMVHBoolOptions);

Begin
  If sOptions <> FBoolOptions Then
    FBoolOptions := sOptions;;
End;

End.
