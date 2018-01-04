(**

  This module contains code for creating the about box entry in RAD Studio.

  @Author  David Hoyle
  @Version 1.0
  @Date    04 Jan 2018

**)
Unit MsgViewHelper.AboutBox;

Interface

  Function  AddAboutBoxEntry : Integer;
  Procedure RemoveAboutBoxEntry(Const iIndex : Integer);

Implementation

Uses
  ToolsAPI,
  SysUtils,
  Windows,
  MsgViewHelper.Functions,
  Forms,
  MsgViewHelper.ResourceStrings;

(**

  This procedure adds the about box entry to the RAD Studio IDE.

  @precon  None.
  @postcon If the version of RAD Studio is equal to or above 2005 the about box entry is added to
           the IDE.

  @return  an Integer

**)
Function AddAboutBoxEntry : Integer;

ResourceString
  strSKUBuild = 'SKU Build %d.%d.%d.%d';

Const
  strMessageViewHelper = 'MessageViewHelper48x48';

Var
  iMajor : Integer;
  iMinor : Integer;
  iBugFix : Integer;
  iBuild : Integer;
  bmSplashScreen : HBITMAP;
  AboutBoxServices : IOTAAboutBoxServices;

Begin
  Result := -1;
  BuildNumber(iMajor, iMinor, iBugFix, iBuild);
  bmSplashScreen := LoadBitmap(hInstance, strMessageViewHelper);
  If Supports(BorlandIDEServices, IOTAAboutBoxServices, AboutBoxServices) Then
    Result := AboutBoxServices.AddPluginInfo(
      Format(strSplashScreenName, [iMajor, iMinor, Copy(strRevision, iBugFix + 1, 1),
        Application.Title]),
      strAboutBoxDescription,
      bmSplashScreen,
      {$IFDEF DEBUG} True {$ELSE} False {$ENDIF},
      Format(strSplashScreenBuild, [iMajor, iMinor, iBugfix, iBuild]),
      Format(strSKUBuild, [iMajor, iMinor, iBugfix, iBuild]));
End;

(**

  This procedure removes the about box entry from the IDE.

  @precon  None.
  @postcon The about box entry is removed from the IDE.

  @param   iIndex as an Integer as a constant

**)
Procedure RemoveAboutBoxEntry(Const iIndex : Integer);

Var
  AboutBoxServices : IOTAAboutBoxServices;

Begin
  If iIndex > -1 Then
    If Supports(BorlandIDEServices, IOTAAboutBoxServices, AboutBoxServices) Then
      AboutBoxServices.RemovePluginInfo(iIndex);
End;

End.
