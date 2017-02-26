(**

  This module contains resource strings for use throughout the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    26 Feb 2017

**)
Unit MsgViewHelper.ResourceStrings;

Interface

ResourceString
  (** This is a text string of revision from nil and a to z. **)
  strRevision = ' abcdefghijklmnopqrstuvwxyz';
  (** Universal name for all IDEs for use in the splash screen and about boxes. **)
  strSplashScreenName = 'Message View Helper %d.%d%s for %s';
  (** This is another message string to appear in the BDS 2005/6 splash screen **)
  strSplashScreenBuild = 'Freeware by David Hoyle (Build %d.%d.%d.%d)';
  (** Describes the purpose of the IDE plug-in **)
  strAboutBoxDescription = 'An IDE plug-in to provide quick access to hide and show the message ' +
    'view and automatically hide the message view if compilation is successful.';

Implementation

End.
