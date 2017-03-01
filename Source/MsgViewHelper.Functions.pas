(**

  This module contains generial functions for use throughout the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    01 Mar 2017

**)
Unit MsgViewHelper.Functions;

Interface

{$INCLUDE CompilerDefinitions.inc}

  Function INIFileName : String;
  Procedure BuildNumber(var iMajor, iMinor, iBugFix, iBuild : Integer);

Implementation

Uses
  {$IFDEF DXE20}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  {$IFDEF DXE20}WinAPI.Windows{$ELSE}Windows{$ENDIF},
  {$IFDEF DXE20}WinAPI.SHFolder{$ELSE}SHFolder{$ENDIF};

(**

  This function returns the users logon name as a String.

  @precon  None.
  @postcon Returns the users logon name as a String.

  @return  a String

**)
Function UserName : String;

Var
  iSize : Cardinal;

Begin
  iSize := 1024;
  SetLength(Result, iSize);
  GetUserName(@Result[1], iSize);
  Win32Check(LongBool(iSize));
  SetLength(Result, iSize - 1);
End;

(**

  This function returns the users computer name as a String.

  @precon  None.
  @postcon Returns the users computer name as a String.

  @return  a String

**)
Function ComputerName : String;

Var
  iSize : Cardinal;

Begin
  iSize := 1024;
  SetLength(Result, iSize);
  GetComputerName(@Result[1], iSize);
  Win32Check(LongBool(iSize));
  SetLength(Result, iSize);
End;

(**

  This method returns an INI filename for the application specific to the user and computer and
  located in the users roaming profile.

  @precon  None.
  @postcon A string is returned which it the name and path of the INI file.

  @return  a String

**)
Function INIFileName : String;

ResourceString
  strINIPattern = '%s Settings for %s on %s.INI';
  strSeasonsFall = '\Season''s Fall\';

Var
  strUserAppDataPath: String;
  strBuffer: String;
  iSize: Integer;

Begin
  // Get module name
  SetLength(Result, MAX_PATH);
  iSize := GetModuleFileName(hInstance, PChar(Result), MAX_PATH);
  SetLength(Result, iSize);
  Result := ChangeFileExt(ExtractFileName(Result), '');
  // Strip numbers (platform)
  While (Length(Result) > 0) Do
    Case Result[Length(Result)] Of
      '0'..'9': Result := Copy(Result, 1, Length(Result) - 1);
    Else
      Break;
    End;
  // Build INI name
  Result := Format(strINIPattern, [Result, UserName, ComputerName]);
  // Get Roaming User Path
  SetLength(strBuffer, MAX_PATH);
  SHGetFolderPath(0, CSIDL_APPDATA Or CSIDL_FLAG_CREATE, 0, SHGFP_TYPE_CURRENT, PChar(strBuffer));
  strBuffer := StrPas(PChar(strBuffer));
  strUserAppDataPath := strBuffer + strSeasonsFall;
  If Not DirectoryExists(strUserAppDataPath) Then
    ForceDirectories(strUserAppDataPath);
  Result := strUserAppDataPath + Result;
End;

(**

  This is a method which obtains information about the package from is
  version information with the package resources.

  @precon  None.
  @postcon Extracts and display the applications version number present within
           the EXE file.

  @param   iMajor  as an Integer as a reference
  @param   iMinor  as an Integer as a reference
  @param   iBugFix as an Integer as a reference
  @param   iBuild  as an Integer as a reference

**)
Procedure BuildNumber(var iMajor, iMinor, iBugFix, iBuild : Integer);

Var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  strBuffer : Array[0..MAX_PATH] Of Char;

Begin
  iMajor := 0;
  iMinor := 0;
  iBugFix := 0;
  iBuild := 0;
  GetModuleFilename(hInstance, strBuffer, MAX_PATH);
  VerInfoSize := GetFileVersionInfoSize(strBuffer, Dummy);
  If VerInfoSize <> 0 Then
    Begin
      GetMem(VerInfo, VerInfoSize);
      Try
        GetFileVersionInfo(strBuffer, 0, VerInfoSize, VerInfo);
        VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
        With VerValue^ Do
          Begin
            iMajor := dwFileVersionMS shr 16;
            iMinor := dwFileVersionMS and $FFFF;
            iBugFix := dwFileVersionLS shr 16;
            iBuild := dwFileVersionLS and $FFFF;
          End;
      Finally
        FreeMem(VerInfo, VerInfoSize);
      End;
    End;
End;

End.
