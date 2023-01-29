# 27 Jan 2023 09:24

Name "JXXX"
SetCompressor /SOLID lzma
Unicode True

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION YYY
!define COMPANY Jsoftware
!define URL http://www.jsoftware.com

# MultiUser Symbol Definitions
!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_MUI
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_VALUENAME MultiUserInstallMode
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR "$(^Name)"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUE "Path"
!define MULTIUSER_USE_PROGRAMFILES64

# MUI Symbol Definitions
!define MUI_ICON "resources\inst.ico"
!define MUI_UNICON "resources\uninst.ico"
!define MUI_HEADERIMAGE_BITMAP "resources\sm.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "resources\lg.bmp"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT SHCTX
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "$(^Name)"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
!define MUI_HEADERIMAGE_RIGHT
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include MultiUser.nsh
!include Sections.nsh
!include MUI2.nsh
!include x64.nsh
!include LogicLib.nsh
!include CPUFeatures.nsh

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE resources\x64\license.txt
!insertmacro MULTIUSER_PAGE_INSTALLMODE
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
Outfile jXXX_win64ZZZ.exe
# InstallDir "$(^Name)"
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion "${VERSION}.0"
VIAddVersionKey ProductName "$(^Name)"
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright ""
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
Section -Main SEC0000
    SetRegView 64
    SetOutPath $INSTDIR
    SetOverwrite on
    File /r resources\x64\*
    SetOutPath $INSTDIR\bin
    ${If} ${CPUSupports} "AVX1"
      File /oname=j.dll resources\je\javx.dll
    ${EndIf}
    ${If} ${CPUSupports} "AVX2"
      File /oname=j.dll resources\je\javx2.dll
    ${EndIf}
    CreateDirectory "$SMPROGRAMS\$StartMenuGroup"
    SetOutPath $PROFILE
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\JXXX.lnk" "$INSTDIR\bin\jqt.exe"
    CreateShortcut "$DESKTOP\JXXX.lnk" "$INSTDIR\bin\jqt.exe"
    WriteRegStr SHCTX "${REGKEY}\Components" Main 1
SectionEnd

Section -post SEC0001
    SetRegView 64
    ExecWait '"$INSTDIR\jreg.cmd"'
    WriteRegStr SHCTX "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    WriteRegStr SHCTX "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr SHCTX "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr SHCTX "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr SHCTX "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr SHCTX "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr SHCTX "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString "$INSTDIR\uninstall.exe /$MultiUser.InstallMode"
    WriteRegDWORD SHCTX "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD SHCTX "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

# Uninstaller sections
Section un.Main UNSEC0000
    SetRegView 64
    ExecWait '"$INSTDIR\junreg.cmd"'
    Delete /REBOOTOK $INSTDIR\jconsole.cmd
    Delete /REBOOTOK $INSTDIR\jqt.cmd
    Delete /REBOOTOK $INSTDIR\jreg.cmd
    Delete /REBOOTOK $INSTDIR\junreg.cmd
    Delete /REBOOTOK $INSTDIR\readme.txt
    Delete /REBOOTOK $INSTDIR\updatejqt.cmd
    Delete /REBOOTOK $INSTDIR\updateje.cmd
    Delete /REBOOTOK $INSTDIR\license.txt
    RmDir /R /REBOOTOK $INSTDIR\addons
    RmDir /R /REBOOTOK $INSTDIR\bin
    RmDir /R /REBOOTOK $INSTDIR\system
    RmDir /R /REBOOTOK $INSTDIR\tools
    Delete /REBOOTOK "$DESKTOP\JXXX.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\JXXX.lnk"
    DeleteRegValue SHCTX "${REGKEY}\Components" Main
    DeleteRegKey SHCTX "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue SHCTX "${REGKEY}" StartMenuGroup
    DeleteRegValue SHCTX "${REGKEY}" Path
    DeleteRegKey /IfEmpty SHCTX "${REGKEY}\Components"
    DeleteRegKey /IfEmpty SHCTX "${REGKEY}"
    RmDir /R /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
    !insertmacro MULTIUSER_INIT
    ${IfNot} ${Runningx64}
      MessageBox MB_OK "JXXX must be installed on 64-bit Windows. Will abort."
      Abort ; causes installer to quit.
    ${EndIf}
FunctionEnd
# Uninstaller functions
Function un.onInit
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro MULTIUSER_UNINIT
FunctionEnd

