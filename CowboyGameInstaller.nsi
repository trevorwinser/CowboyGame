# define name of installer
Name "CowboyGame Installer"

OutFile "CowboyGameInstaller.exe"

# For removing Start Menu shortcut in Windows 7
RequestExecutionLevel user

Unicode True
 
# define installation directory
InstallDir $PROGRAMFILES64\CowboyGame

Page directory
Page instfiles

# start default section
Section ""
 
    # set the installation directory as the destination for the following actions
    SetOutPath $INSTDIR

    # Start Menu
    CreateDirectory "$SMPROGRAMS\Cowboy Game"
    CreateShortcut "$SMPROGRAMS\Cowboy Game\Cowboy Game.lnk" "$INSTDIR\CowboyGame.exe"
    CreateShortcut "$SMPROGRAMS\Cowboy Game\Uninstall Cowboy Game.lnk" "$INSTDIR\uninstall.exe"

 
    File /r "application.windows64\CowboyGame.exe"
    File /r "application.windows64\java"
    File /r "application.windows64\lib"

    SetOutPath $INSTDIR\images
    File /r "images\*.*"

    SetOutPath $INSTDIR
    # create the uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
 
SectionEnd
 

Section "uninstall"
    Delete $INSTDIR\CowboyGame.exe 
    RMDir /r $INSTDIR\images
    RMDir /r $INSTDIR\java
    RMDir /r $INSTDIR\lib
    Delete "$INSTDIR\uninstall.exe"

    RMDir $INSTDIR
 
    Delete "$SMPROGRAMS\Cowboy Game\Cowboy Game.lnk"
    Delete "$SMPROGRAMS\Cowboy Game\Uninstall Cowboy Game.lnk"
    RMDir "$SMPROGRAMS\Cowboy Game"

SectionEnd
