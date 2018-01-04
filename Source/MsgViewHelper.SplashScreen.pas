(**

  This module contains the OTA code to add an entry to the IDEs splash screen for the plug-in.

  @Author  David Hoyle
  @Version 1.0
  @Date    04 Jan 2018

**)
Unit MsgViewHelper.SplashScreen;

Interface

  Procedure AddSplashScreen;

Implementation

Uses
  ToolsAPI,
  SysUtils,
  Windows,
  Forms,
  MsgViewHelper.Functions,
  MsgViewHelper.ResourceStrings;

(**

  This method adds an entry to the RAD Studio IDE splash screen.

  @precon  None.
  @postcon An entry is added to the RAD Studio IDE slplash screen if the version of RAD
           Studio is 2005 and above.

**)
Procedure AddSplashScreen;

Const
  strMessageViewHelper = 'MessageViewHelper24x24';

Var
  iMajor : Integer;
  iMinor : Integer;
  iBugFix : Integer;
  iBuild : Integer;
  bmSplashScreen : HBITMAP;
  SSServices : IOTASplashScreenServices;

Begin
  BuildNumber(iMajor, iMinor, iBugFix, iBuild);
  bmSplashScreen := LoadBitmap(hInstance, strMessageViewHelper);
  If Supports(SplashScreenServices, IOTASplashScreenServices, SSServices) Then
    SSServices.AddPluginBitmap(
      Format(strSplashScreenName, [iMajor, iMinor, Copy(strRevision, iBugFix + 1, 1),
        Application.Title]),
      bmSplashScreen,
      {$IFDEF DEBUG} True {$ELSE} False {$ENDIF},
      Format(strSplashScreenBuild, [iMajor, iMinor, iBugfix, iBuild]), ''
    );
End;

End.
