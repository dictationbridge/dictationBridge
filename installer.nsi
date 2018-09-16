/*
This installer makes history in that it provides support for an app BEFORE it is released!  It supports the amazing VWAPP from VaporWare Inc.  While we are anxiously waiting its release, it also serves as an example of how to use the JFW.nsh NSIS header file.

To use this sample, copy this file and the script folder, along with JFW.nsh, logging.nsh, and uninstlog.nsh and supporting files to a folder and run makensis vwapp.nsi.
*/
!include "WinMessages.nsh"

RequestExecutionLevel admin

SetCompressor /solid lzma ;create the smallest file
;Name of script (displayed on screens, install folder, etc.) here
!Define ScriptName "DictationBridge"
; This needs to match the main script.
; We currently only have one, but this is going to be a problem in future if we get a second.
; Note that I hacked out the compilation, so we also need the below macro.
!define ScriptApp "dd10renx" ; the base name of the app the scripts are for
!define VERSION "0.1"
;!define JAWSMINVERSION "" ; min version of JAWS for which this script can be installed
;!define JAWSMAXVERSION "" ; max version of JAWS for which this script can be installed
!define JAWSALLOWALLUSERS ; comment this line if you don't want to allow installation for all users.
;Uncomment and change if the scripts are in another location.
;!define JAWSSrcDir "script\" ;Folder relative to current folder containing JAWS scripts, empty or ends with backslash.

;!Define JAWSScriptLangs "esn" ;Supported languages (not including English; these folders must exist in the script source lang directory ${JAWSSrcDir}\lang.

;Will be omitted if not defined.
;!define LegalCopyright "$(CopyrightMsg)"
;The file name of the license file in ${JAWSSrcDir}.  If not defined, no license page will be included.
;!define JAWSLicenseFile "copying.txt" ; should be defined in langstring file if LangString messages are used.

;Optional installer finish page features
;Assigns default if not defined.
;!define MUI_FINISHPAGE_SHOWREADME "$instdir\${ScriptApp}_readme.txt"
!define JAWSNoReadme ;uncomment if you don't have a README.
;!define MUI_FINISHPAGE_LINK "$(GoToAuthorsPage)"
;!define MUI_FINISHPAGE_LINK_LOCATION "http://"

;SetCompressor is outside the header because including uninstlog.nsh produces code.  setOverWriteDefault should not be in code used to add JAWS to another installer, although we probably want it in the default installer macro.
SetOverwrite on ;always overwrite files
;Allows us to change overwrite and set it back to the default.
!define SetOverwriteDefault "on"

;Uninstlog langstring files are included after inserting the JAWSScriptInstaller macro.
;!include "uninstlog.nsh"
;Remove the ; from the following line and matching close comment to cause the default JAWSInstallScriptItems macro to be used.
;/*
!macro JAWSInstallScriptItems
;$0 is version, e.g. "17.0", $1 is JAWS language folder, e.g. "enu" or "esn".
${JawsScriptFile} "${JAWSSrcDir}" "dd10renx.jss"
; We don't need the following lines. I've left them in for illustrative purposes.
;${JawsScriptFile} "${JAWSSrcDir}" "vwapp.qs"
;${JawsScriptFile} "${JAWSSrcDir}" "vwapp.jcf"
;${JawsScriptFile} "${JAWSSrcDir}" "vwapp.jgf"


/*
;Language-specific files can be added this way:
${Switch} $1
;Each case entry must contain an item for each file that has a language-specific file.  If a file does not exist for a particular language, include the default language file.
${Case} "esn"
${JawsScriptFile} "${JAWSSrcDir}lang\esn\" "vwapp.jsd"
${JawsScriptFile} "${JAWSSrcDir}lang\esn\" "vwapp.jsm"
${JawsScriptFile} "${JAWSSrcDir}lang\esn\" "vwapp.jkm"
${JawsScriptFile} "${JAWSSrcDir}lang\esn\" "vwapp.jdf"
${JawsScriptFile} "${JAWSSrcDir}lang\esn\" "vwapp.qsm"
${JawsScriptFile} "${JAWSSrcDir}" "vwapp.jbs" ;from default lang folder
${Break}
${Default}
;The default language files for every file that has a language-specific file must appear here.
;English
${JawsScriptFile} "${JAWSSrcDir}" "vwapp.jsd"
${JawsScriptFile} "${JAWSSrcDir}" "vwapp.jsm"
${JawsScriptFile} "${JAWSSrcDir}" "vwapp.jkm"
${JawsScriptFile} "${JAWSSrcDir}" "vwapp.jdf"
${JawsScriptFile} "${JAWSSrcDir}" "vwapp.qsm"
${JawsScriptFile} "${JAWSSrcDir}" "vwapp.jbs"
${Break}
${EndSwitch}
*/
!macroend ;JAWSInstallScriptItems

/*
;Optional: Items to be placed in the installation folder in a full install.
!macro JAWSInstallFullItems
!macroend ;JAWSInstallFullItems
*/

;-----
!include "jfw.nsh"

!insertmacro JAWSScriptInstaller
;Strange though it seems, the language file includes must follow the invocation of JAWSScriptInstaller.
  ;!include "uninstlog_enu.nsh"
  ;!include "uninstlog_esn.nsh"

  Function .onInit
  ; The package we are using provides a .onInit as well, so I renamed it and we call through here.
  ; This would be JawsOnInit, but that name is already used.
  call OldOnInit
  strcpy $INSTDIR "$PROGRAMFILES32\DictationBridge for JAWS"
  FunctionEnd
  
section "-instCore"
push $OUTDIR
CreateDirectory "$INSTDIR"
strcpy $OUTDIR "$INSTDIR"
file /r "dist\*"
exec "DictationBridgeJFWHelper.exe"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "DictationBridgeJFW" "$INSTDIR\DictationBridgeJFWHelper.exe"
pop $OUTDIR
SectionEnd

section "un.Core"
FindWindow $R0 "DictationBridgeJFWHelper"
IntCmp $0 0 Core NoCore Core
Core:
SendMessage $R0 WM_CLOSE 0 0
; Give the core time to exit. If it still exists after a second, just reboot because it's crashed.
sleep 1000
NoCore:
DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "DictationBridgeJFW"
rmdir /R /REBOOTOK "$INSTDIR"
IfRebootFlag 0 noreboot
    MessageBox MB_YESNO "A reboot is required to finish the installation. Do you wish to reboot now?" IDNO noreboot
    Reboot
noreboot:
SectionEnd
