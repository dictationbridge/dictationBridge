/*
Jaws script installer
Written by Dang Manh Cuong <dangmanhcuong@gmail.com> and Gary Campbell <campg2003@gmail.com>
This installer requires the NSIS program from http://nsis.sourceforge.net

This installer has the following features and limitations:
Features:
. Installs into all English versions of Jaws. This will be true as long as Freedom Scientific does not change the place to put scripts.
. The user can choose whether to install scripts for all users or the current user.
. Gets the correct install path of Jaws from the registry.
. Checks for a Jaws installation before starting setup. If Jaws is not installed, displays a warning message and quits.
. contains macros for extracting, compiling, deleting, and modifying scripts, so user can create a package containing multiple scripts quickly and easily.
. Macro to copy script from all users to current user.
Limitations:
Date created: Wednesday, September 20, 2012
Last updated: 2016-09-21

Modifications:


*/

/*
    Copyright (C) 2012-2016  Gary Campbell and Dang Manh Cuong.  All rights reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
    
    See the file copying.txt for details.
*/

!ifndef __JAWSSCRIPTSINCLUDED
!define __JAWSSCRIPTSINCLUDED

!ifndef JAWSMINVERSION
  !define JAWSMINVERSION "" ; min version of JAWS for which this script can be installed
!endif
!ifndef JAWSMAXVERSION
!define JAWSMAXVERSION "" ; max version of JAWS for which this script can be installed
!endif
;If you want to enable support for choosing to install in either the current user or all users, define JAWSALLOWALLUSERS before including this file.  If not defined, the default is to install into the current user.  If you execute SetShellVarContext you should also set the variable JAWSSHELLCONTEXT to match.
!ifdef JAWSALLOWALLUSERS
!echo "Including support for choosing between current user and all users."
!else
!warning "Support for installing for all users is not enabled.  To enable, define JAWSALLOWALLUSERS before including this file."
!EndIf ; else not JAWSALLOWALLUSERS

!ifndef JAWSSrcDir
!define JAWSSrcDir "script\" ;Folder relative to current folder containing JAWS scripts, empty or ends with backslash.
!EndIf

!ifndef JAWSDefaultProgDir
!define JAWSDefaultProgDir "$JAWSPROGDIR" ;Default directory containing JAWS program files (in JAWSDefaultProgDir\<JAWSVersion>)
!EndIf

!Define InstallFile $instdir\Install.ini ; file that stores information for the uninstaller
!Define tempFile $temp\Install.ini
!Define UnInstaller "Uninst.exe"
!Define JawsDir "$appdata\Freedom Scientific\Jaws" ;the folder where app data for Jaws 6.0 and above is located
!Define ScriptVerLangSep "/" ;separates JAWS version and language string.  The language string is the folder under ScriptDir for the scripts.
!ifndef JAWSScriptLangs
!Define JAWSScriptLangs "" ;default supported languages.
!EndIf
!Define ScriptDefaultLang "enu" ;default language string, these script jsm files will be in the script source directory.
!Define Scriptdir "Settings" ;folder in $JawsDir for current user or earlier than 17.0, the script is put in a language folder under this folder
!Define JawsApp "JFW.EXE" ;Used to check if Jaws is installed
!Define Compiler "Scompile.exe" ;Used to compile script after installation

; Name of folder relative to $INSTDIR in which to install the installer source files.
!define JAWSINSTALLERSRC "Installer Source"

;We include langstring header after the MUI_LANGUAGE macro.
!include "uninstlog.nsh"
!include "logging.nsh"
!include "strfunc.nsh" ; used in DisplayJawsList to check for a digit, and other things
!include "filefunc.nsh" ; used to get language subfolders
!Include "WordFunc.nsh" ;for Version Compare
;!include "stack.nsh" ; debug

; Declare used functions from strfunc.nsh.
!ifndef StrTok_INCLUDED
${StrTok}
!endif
!ifndef StrLoc_INCLUDED
${StrLoc}
!endif

!include "nsDialogs.nsh"

;Multiuser configuration
!define MULTIUSER_EXECUTIONLEVEL Highest
!Define MULTIUSER_INSTALLMODE_INSTDIR "${ScriptName}"
;We don't want to use the registry key!
;!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_KEY "${UNINSTALLKEY}\${ScriptName}"
;!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_VALUENAME "UninstallString"
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_FUNCTION JAWSMuInstallMode
!define MULTIUSER_MUI
!include "multiuser.nsh"

;Modern UI configurations
!Include "MUI2.nsh"

;Timestamp of this run for messages.
!define /DATE MsgTimeStamp "%Y-%m-%d %H:%M"
;!define MUI_FINISHPAGE_NOAUTOCLOSE ; debug

;Global variables

var JAWSPROGDIR ; directory containing the JAWS programs.
var JAWSDLG ; handle of JAWS page dialog
var JAWSLV ; handle of JAWS versions list view
var JAWSGB
var JAWSRB1
var JAWSRB2
var JAWSREADME ;location of the README file for the Finish page

;-----
;Multi-language script support
function GetVersionLangs
  ;$0 -- JAWS version
  ;Returns language subfolders separated by | in $1, count in $2.
  ;Uses defines ${JawsDir} and ${ScriptDir}.
  push $R1
push $R2
  Push $R6
  Push $R7
  Push $R8
  Push $R9
  StrCpy $R1 "" ;accumulator
StrCpy $R2 0 ; count
  ${Locate} "${JawsDir}\$0\${ScriptDir}" "/L=D /G=0 /M=???" "GetVersionLangsHelper"
  Pop $R9
  Pop $R8
  Pop $R7
  Pop $R6
  StrCpy $2 $R2
  pop $R2
  StrCpy $1 $R1
  Pop $R1
  ${if} $1 != ""
    StrCpy $1 $1 -1
  ${endif}
FunctionEnd ;GetVersionLangs
  
Function GetVersionLangsHelper
StrCpy $R1 "$R1$R7|"
intop $R2 $R2 + 1 ;count
Push $R1 ;used to stop execution
FunctionEnd ; GetVersionLangsHelper

Function GetVerLang
  ;Separate version and lang dir.
  ;$0 - ver/lang pair, or just ver which will use default for lang
  ;Return: TOS = lang  dir (default lang dir if none given), TOS -1 = ver
  ;Uses ${ScriptVerLangSep}, ${ScriptDefaultDir}
push $1 ; used for version
push $3 ;used for lang dir
${StrLoc} $3 "$0" "${ScriptVerLangSep}" ">"
${if} $3 != ""
  ${StrTok} $1 "$0" "${ScriptVerLangSep}" "0" "0"
  ${StrTok} $3 "$0" "${ScriptVerLangSep}" "1" "0"
${else}
  ;Assume $0 is just a version, so copy it.
  StrCpy $1 "$0"
  StrCpy $3 "${ScriptDefaultLang}"
${endif}
;$1 = version, $3 = lang dir
;TOS = old $3, TOS-1 = old $1
exch 
; TOS = old $1, TOS-1 = old $3
exch $1 ; TOS = ver
exch ; TOS = old $3, TOS-1 = ver
exch $3 ; TOS = lang
FunctionEnd ;GetVerLang

!ifndef StrLoc_INCLUDED
  ${StrLoc}
!endif
function _StrContainsTok
  ;Report if token $1 is in $0 where $0 is a list of tokens with separator $2.  $2 must be a single character.
  ; Returns "" in $3 if not found, a number >= 0 otherwise.
  Push $R0
  StrCpy $R0 "$2$0$2"
  ${StrLoc} $3 $R0 "$2$1$2" ">"
  pop $R0
FunctionEnd ;_StrContainsTok

!macro StrContainsTok rslt list tok sep
  ;Determine if string tok is a token in list which is separated by character sep.
  ;Returns 1 in rslt if found, 0 otherwise.
  push $3
  push $0
  push $1
  push $2
  StrCpy $0 "${list}"
  StrCpy $1 "${tok}"
  StrCpy $2 "${sep}"
  call _StrContainsTok
  ${If} $3 == ""
    ;MessageBox MB_OK "StrContainsTok: $1 not found" ; debug
    StrCpy $3 0
  ${Else}
    StrCpy $3 1
    ${EndIf}
  pop $2
  pop $1
  pop $0
  exch $3
  pop ${rslt}
!MacroEnd ;StrContainsTok
!define StrContainsTok "!InsertMacro strContainsTok"

;-----

;Additional scripts from Cuong's cjfw.nsh
!Macro CompileSingle JAWSVer Source
;Assumes $OUTDIR points to folder where source file is and compiled file will be placed.
;JAWSVer - JAWS version/lang or version, i.e. "10.0/enu" or "10.0"
;Source - name of script to compile without .jss extension
;return: writes error message on failure, returns exit code of scompile (0 if successful) in $1.
;Recommend for scripts wich have only one source (*.JSS) file, or don't make any modification to any original files
;This macro saves time because it doesn't store and delete any temporary files.
push $0
strcpy $0 ${JAWSVer}
push $R1
;StrCpy $R1 "$OUTDIR\${Source}"
StrCpy $R1 "${Source}"
call __CompileSingle
pop $R1
pop $0
!MacroEnd

Function __CompileSingle
;$0 - JAWS version/lang or version, i.e. "10.0/enu" or "10.0"
;$R1 - name of script to compile without .jss extension
push $R0
push $R2 ;stdout/stderr output of scompile.
call GetVerLang
pop $0 ;lang, we don't need it
pop $0 ;version
call GetJawsProgDir
pop $R0
; $R0 has backslash at end of path.
StrCpy $R0 "$R0${Compiler}"
;StrCpy $R1 "$OUTDIR\${Source}"
;${GetFileAttributes} "$R1.jss" "all" $1
;DetailPrint "Attributes of file $R1.jss: $1"
!ifndef JAWSDEBUG ; debug
IfFileExists "$R0" +1 csNoCompile
!endif ; debug
!ifdef JAWSDEBUG
  MessageBox MB_OK `Pretending to run nsexec::Exec '"$R0" "$R1.jss"'`
  !Else ; not JAWSJEBUG
    DetailPrint `Executing command '"$R0" "$R1.jss"'` ; debug
  ;nsexec::Exec '"$R0" "$R1.jss"'
  ;pop $1 ;exit code of scompile
  ;StrCpy $R0 "c:\progra~2\mingw_sylvan\win32\wbin\cp" ; debug
  ;nsexec::ExecToStack '"$R0" "$R1.jss" "$R1.jsb"' ; debug
  nsexec::ExecToStack '"$R0" "$R1.jss"'
  pop $1 ;exit code of scompile
  pop $R2 ;scompile output
    ;MessageBox MB_OK "compile $R1.jss, SCompile returned $1$\r$\n$$OutDir=$OutDir, Output:$\R$\N$R2" ; debug
    IntCmp $1 0 csGoodCompile +1 +1
    DetailPrint "Could not compile $R1.jss, SCompile returned $1$\r$\n$$OutDir=$OutDir, Output:$\r$\n$R2$\r$\n"
    MessageBox MB_OK "$(CouldNotCompile)"
    GoTo csEnd
  csGoodCompile:
    DetailPrint "Compiled $R1.jss"
!EndIf ; else not JAWSDEBUG
GoTo csEnd
csNoCompile:
DetailPrint "Could not find JAWS script compiler $R0.  You will need to compile it with JAWS Script Manager to use it."
MessageBox MB_OK "$(CouldNotFindCompiler)"
strcpy $1 1 ; return error
  csEnd:
    pop $R2
  pop $R0
  FunctionEnd ;__CompileSingle

!Macro AdvanceCompileSingle JAWSVer Path Source
;Assumes $OUTDIR points to folder where source file is and compiled file will be placed.
;JAWSVer - JAWS version/lang or version, i.e. "10.0/enu" or "10.0"
;Path - desired context, either "current" or "all".
;Source - name of script to compile without .jss extension
;return: writes error message on failure, returns exit code of scompile (0 if successful)-- actually returns 1 on failure.
${If} "${Path}" = "current"
  SetShellVarContext current
  ${Else}
    SetShellVarContext all
    ${EndIf}
!insertmacro CompileSingle ${JAWSVer} ${Source}
${If} "$JAWSSHELLCONTEXT" = "current"
  SetShellVarContext current
  ${Else}
    SetShellVarContext all
    ${EndIf}
/*
ReadIniStr $0 ${TempFile} Install ${Path}
ReadIniStr $1 ${TempFile} Install Compiler
;Exec the sCompile.exe hiddently
;The extention of script source has been added
nsExec::Exec '"$1" "$0\${Source}.jss"'
*/
!MacroEnd

!Macro AddHotkey JKM Key Script
;Add hotkeys to *.jkm file
;Usually used by advanced user
;Assumes JKM file is in $OUTDIR.
;JKM - name of JKM file without the .jkm extension.
;key - string containing the key sequence, like "CTRL+JAWSKey+a".
;Script - name of script to bind to key.
;Entries will be added to the "Common Keys" section.
push $0
WriteIniStr "$OUTDIR\${JKM}.jkm" "Common Keys" "${Key}" "${Script}"
pop $0
!MacroEnd

!Macro CopyScript JAWSVer Name
;Use to copy any script source from share folder
push $0
push $1
SetShellVarContext "current"
strcpy $0 ${JAWSVer}
call GetJawsScriptDir
pop $0
IfFileExists $0\${Name} end
SetShellVarContext "all"
push $0
strcpy $0 ${JAWSVer}
call GetJAWSScriptDir
pop $1
pop $0
CopyFiles /silent "$1\${Name}" "$0\${Name}"
end:
SetShellVarContext $JAWSShellContext
pop $1
pop $0
!Macroend

!macro ModifyScript JAWSVer File Code
;Use to add some code to the existing script
;Like adding: use "skypewatch.jsb"" to default.jss
push $0
push $1
strcpy $0 $JAWSVer
call GetJAWSScriptDir
pop $0
FileOpen $1 "$0\${File}"
;Go to the botum of file
FileSeek $1 0 end
;Add a blank line to safely modify
FileWrite $1 `$\r$\n${Code}$\r$\n`
FileClose $1
pop $1
pop $0
!Macroend

!macro AdvanceModifyScript JAWSVer Path File Code
;Use to add some code to the existing script
;Like adding: use "skypewatch.jsb"" to default.jss
SetShellVarContext ${Path}
!insertmacro ModifyScript "${JAWSVer}" "${File}" "${Code}"
SetShellVarContext $JAWSShellContext
/*
ReadIniStr $0 ${TempFile} Install ${Path}
FileOpen $1 $0\${File} a
;Go to the bottom of file
FileSeek $1 0 end
;Add a blank lines to safely modify
FileWrite $1 "$\r$\n"
FileWrite $1 `${Code}`
FileClose $1
*/
!Macroend

!Macro Un.RemoveHotkey JAWSVer JKM Key
push $0
strcpy $0 ${JAWSVer}
call GetJAWSScriptDir
pop $1
DeleteIniStr "$1\${jkm}.jkm" "Common Keys" ${Key}"
pop $1
!macroend

;JAWS uninstall log macros.
;This file uses uninstlog macros UNINSTLOG_OPENINSTALL, UNINSTLOG_CLOSEINSTALL, File, FileDated, AddItem, and AddItemAlways.
!ifdef UNINSTALLLOGINCLUDED
!define JAWSLOGFILENAME "jawsuninstlog.txt"
!macro JAWSLOG_OPENINSTALL
push $UninstLog
!ifdef UninstLog
!define __JAWSLOGTemp ${UninstLog}
undef Uninstlog
!EndIf
!define UninstLog ${JAWSLOGFILENAME}
!insertmacro UNINSTLOG_OPENINSTALL
!macroend ;JAWSLOG_OPENINSTALL

!macro JAWSLOG_CLOSEINSTALL
!insertmacro UNINSTLOG_CLOSEINSTALL
pop $UninstLog
!undef UninstLog
!ifdef __JAWSLOGTemp
!define UninstLog ${__JAWSLOGTemp}
!undef __JAWSLOGTemp
!EndIf
!macroend ;JAWSLOG_CLOSEINSTALL

!macro JAWSLOG_UNINSTALL
push $UninstLog ; save log file handle if it exists
; if the log file name is defined, save it.
!ifdef UninstLog
!define __JAWSLOGTemp ${UninstLog}
!undef UninstLog
!EndIf
!define UninstLog ${JAWSLOGFILENAME}
!insertmacro UNINSTLOG_UNINSTALL
pop $UninstLog ; restore log file handle
!undef UninstLog
;If the log file name was previously defined, restore it.
!ifdef __JAWSLOGTemp
!define UninstLog ${__JAWSLOGTemp}
!undef __JAWSLOGTemp
!EndIf
!macroend ;JAWSLOG_UNINSTALL

;-----
; The following goes in the .nsh file.
!macro __FileDatedNF path item
!define __FileDatedNFUID ${__LINE__}
File /nonfatal "${path}${item}"
IfFileExists "$OUTDIR\${item}" 0 end${__FileDatedNFUID}
${AddItemDated} "$OUTDIR\${item}"
end${__FileDatedNFUID}:
!undef __FileDatedNFUID
!macroend
!define FileDatedNF "!insertmacro __FileDatedNF"
!else
;uninstlog not included, define dummy stuff to make everything work.
var UninstLogAlwaysLog
!macro JAWSLOG_OPENINSTALL
!macroend ;JAWSLOG_OPENINSTALL

!macro JAWSLOG_CLOSEINSTALL
!macroend ;JAWSLOG_CLOSEINSTALL

!macro JAWSLOG_UNINSTALL
!macroend ;JAWSLOG_UNINSTALL

!macro __FileDatedNF path item
File /nonfatal "${path}${item}"
!macroend
!define FileDatedNF "!insertmacro __FileDatedNF"

    !define AddItem "!insertmacro AddItem"
  !macro AddItem Path
  !macroend
 
  !macro File FilePath FileName
     File "${FilePath}${FileName}"
  !macroend
 
  !macro WriteUninstaller Path
    WriteUninstaller "${Path}"
  !macroend

    !define AddItemAlways "!insertmacro AddItem"
    !define AddItemDated "!insertmacro AddItem"
    !define File "!insertmacro File"
    !define FileDated "!insertmacro File"
    !define WriteUninstaller "!insertmacro WriteUninstaller"
!define SetOutPath "SetOutPath"
!define CreateDirectory CreateDirectory
  !macro UNINSTLOG_OPENINSTALL
  !macroend
  !macro UNINSTLOG_CLOSEINSTALL
  !macroend

!endif ;else uninstlog not included

!macro ReadCurrentRegStr dest subkey name
;Read from HKCU or HKLM depending on $JAWSSHELLCONTEXT
${If} $JAWSSHELLCONTEXT == "current"
readregstr ${dest} HKCU "${subkey}" "${name}"
${Else}
readregstr ${dest} HKLM "${subkey}" "${name}"
${EndIf}
!MacroEnd ;ReadCurrentRegStr
!Define ReadCurrentRegStr "!insertmacro ReadCurrentRegStr"

!macro WriteCurrentRegStr subkey name value
;Write to HKCU or HKLM depending on $JAWSSHELLCONTEXT
;!echo 'WriteCurrentRegStr: subkey=${subkey}, name=${name}, value=${value}' ; debug
${If} $JAWSSHELLCONTEXT == "current"
DetailPrint 'Writing to registry HKCU "${subkey}" "${name}" ${value}'
WriteRegStr HKCU "${subkey}" "${name}" '${value}'
${Else}
DetailPrint 'Writing to registry HKLM "${subkey}" "${name}" ${value}'
WriteRegStr HKLM "${subkey}" "${name}" '${value}'
${EndIf}
!MacroEnd ;WriteCurrentRegStr
!Define WriteCurrentRegStr "!insertmacro WriteCurrentRegStr"

!macro JAWSSetShellVarContext context
;So we can pass context as a variable.
${if} ${context} == "current"
  DetailPrint "Setting shell context to current"
  SetShellVarContext current
${Else}
  DetailPrint "Setting shell context to all"
  SetShellVarContext all
  ${EndIf}
!MacroEnd
!define JAWSSetShellVarContext "!insertmacro JAWSSetShellVarContext"

!Define JAWSScriptExt "|jsh|jss|qs|"
!Define JAWSScriptLangExt "|jbs|jkm|jsd|"
!Define JAWSSettingsExt "|jcf|jdf|jgf|"
;jsm and qsm are handled specially-- if $1 == enu they are placed in scripts, otherwise in the language folder.
!macro JawsScriptSetPath ext
;Set $OUTDIR to proper location for script file type ext.
;Usage: ${JawsScriptSetPath} ext
;ext -- script file extension.

  ;Assumes $0 = version, $1 = lang, shell var context is set to $SHELLSCRIPTCONTEXT.
DetailPrint "JawsScriptSetExt: ext=${ext}, version=$0, lang=$1, context=$JAWSSCRIPTCONTEXT" ; debug
  Push $R1 ;scratch
Push $R2 ;$OUTDIR
StrCpy $R2 "$OUTDIR"
${VersionCompare} $0 "17.0" $R1
  ${If} $JAWSSCRIPTCONTEXT == "current"
  ${OrIf} $R1 = 2 ;< 17.0
    ;OutDir is set, do nothing.
  ${Else}
    ;17 or later and shared
    ${Do} ; a block we can exit out of
    ;if in JAWSScriptExt
    ${StrLoc} $R1 "${JAWSScriptExt}" "|${ext}|" ">"
    ${If} $R1 != ""
DetailPrint "JawsScriptSetPath: Setting path for ext in scriptext, strloc returned $R1" ; debug
      StrCpy $R2 "${JAWSDir}\$0\Scripts"
      ${ExitDo}
    ${EndIf}
    ;if in ScriptLang
    ${StrLoc} $R1 "${JAWSScriptLangExt}" "|${ext}|" ">"
    ${If} $R1 != ""
DetailPrint "JawsScriptSetPath: Setting path for ext in scriptLangext, strloc returned $R1" ; debug
      StrCpy $R2 "${JAWSDir}\$0\Scripts\$1"
      ${ExitDo}
    ${EndIf}
    ${If} ${ext} == "jsm"
${OrIf} ${ext} == "qsm"
      ${If} $1 == "${ScriptDefaultLang}"
DetailPrint "JawsScriptSetPath: ext=jsm, setting path for default lang ${ScriptDefaultLang}" ; debug
      StrCpy $R2 "${JAWSDir}\$0\Scripts"
      ${Else}
DetailPrint "JawsScriptSetPath: ext=jsm, setting path for lang" ; debug
      StrCpy $R2 "${JAWSDir}\$0\Scripts\$1"
	${EndIf} ;${Else} not enu
      ${ExitDo}
    ${EndIf} ;jsm
      
    ${StrLoc} $R1 "${JAWSSettingsExt}" "|${ext}|" ">"
    ${If} $R1 != ""
DetailPrint "JawsScriptSetPath: Setting path for SettingsExt, strloc returned $R1" ; debug
      StrCpy $R2 "${JAWSDir}\$0\SETTINGS\$1"
      ${ExitDo}
    ${EndIf}
    DetailPrint "Warning: shouldn't be here, version=$0, lang=$1, ext=${ext}" ; debug
    ${ExitDo}
    ${Loop} ; end of block
    ${EndIf} ;${Else} shared
${If} $R2 != $OUTDIR
${SetOutPath} "$R2"
${EndIf}
Pop $R2
  Pop $R1
!MacroEnd ;JawsScriptSetPath
!define JawsScriptSetPath "!insertmacro JawsScriptSetPath"


!macro JawsScriptFile SrcDir file
;Install a JAWS script file into the proper location.  Takes into account whether installing into current user's scripts or shared scripts, JAWS version, and language.
;Usage: ${JawsScriptFile} SrcDir file
;SrcDir -- folder containing source file, used in FileDated macro.
;File -- name of file in SrcDir, used in FileDated macro and elsewhere.
;Assumes uninstlog macros available (either the real thing or dummies defined here) -- for SetOutPath and FileDated.
;Assumes $0 = version, $1 = lang, shell var context is set to $SHELLSCRIPTCONTEXT.
  Push $R0 ;extension
DetailPrint "Enter JawsScriptFile: SrcDir=${SrcDir}, file=${File}, $$0=$0," 
StrCpy $R2 $OUTDIR
${GetFileExt} ${file} $R0
${JawsScriptSetPath} $r0
    ;install file
  ${FileDated} ${SrcDir} "${file}"
;${If} "$OUTDIR" != $R2
;;Make sure we exit with the same $OUTDIR we started with.
;${SetOutPath} "$R2"
;${EndIf}
  Pop $R0
!MacroEnd ;JawsScriptFile
!define JawsScriptFile "!insertmacro JawsScriptFile"

; If not defined, we use this default macro.  It copies the jss file, then tries to copy every other kind of script file if it exists.
!ifmacrondef JAWSInstallScriptItems
!macro JAWSInstallScriptItems
${FileDated} "${JAWSSrcDir}" "${ScriptApp}.jss"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jbf"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jbs"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jbt"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jcf"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jdf"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jfd"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jff"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jgf"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jkm"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jsd"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jsh"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jsm"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.qs"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.qsm"
!macroend ; JAWSInstallScriptItems
!EndIf ;macro JAWSInstallScriptItems not defined


;-----
; These are section indexes of sections whose state we need to know to write the installation summary.  They are set by code in macro JAWSAfterInstallSections and used in function JAWSInstConfirmPre.
var JAWSSecInstSrc
var JAWSSecUninstaller
!ifmacrodef JAWSInstallFullItems
var JAWSSecInstDirFiles
!EndIf ;if JAWSInstallFullItems

;-----
;Now deals with version/language pairs.
Var INSTALLEDJAWSVERSIONS ;separated by |
var INSTALLEDJAWSVERSIONCOUNT
var SELECTEDJAWSVERSIONS
var SELECTEDJAWSVERSIONCOUNT
var JAWSSHELLCONTEXT ; value for SetShellVarContext-- current or all, default set in .OnInit
var JAWSSCRIPTCONTEXT ;whether to install the scripts for all users or current user, can be "all" or "current"
Var JAWSORIGINSTALLMODE ;original install mode, used to display Install For radio group

;-----

; Multiline edit box for nsdialogs
!define __NSD_TextMultiline_CLASS EDIT
!define __NSD_TextMultiline_STYLE ${DEFAULT_STYLES}|${WS_TABSTOP}|${ES_MULTILINE}
!define __NSD_TextMultiline_EXSTYLE ${WS_EX_WINDOWEDGE}|${WS_EX_CLIENTEDGE}
!insertmacro __NSD_DefineControl TextMultiline

;-----

;Remove a style from a control.
!macro _NSD_RemoveStyle CONTROL STYLE
	Push $0
push $1

	System::Call "user32::GetWindowLong(i ${CONTROL}, i ${GWL_STYLE}) i .r0"
	intop $1 ${STYLE} ~
	intop $0 $0 & $1
	System::Call "user32::SetWindowLong(i ${CONTROL}, i ${GWL_STYLE}, i $0)"

	pop $1
	Pop $0

!macroend ;_NSD_RemoveStyle

!define NSD_RemoveStyle "!insertmacro _NSD_RemoveStyle"

;-----
!macro _ForJawsVersions
; Execute a block of code for each selected JAWS version.
; Place before the code to be executed for each selected JAWS version.
; Follow the code block with _ForJawsVersionsEnd.  These macros can be used more than once but they cannot be nested.
;In the code block $0 contains the current version and $R0 contains the 0-based index of this version in $SELECTEDJAWSVERSIONS.  The code block must protect $R0 since it is the loop index.
!ifndef _ForJawsVersionsCounter
!define _ForJawsVersionsCounter 0
!else
!define /math _ForJawsVersionsCounterTemp ${_ForJawsVersionsCounter} + 1
!undef _ForJawsVersionsCounter
!define _ForJawsVersionsCounter ${_ForJawsVersionsCounterTemp}
!undef _ForJawsVersionsCounterTemp
!endif
push $0
push $R0
strcpy $R0 0
_ForJawsVersionsLoop${_ForJawsVersionsCounter}:
${StrTok} $0 "$SELECTEDJAWSVERSIONS" "|" $R0 0
Push $R0 ; protect loop index
;DetailPrint "ForJawsVersions: running code block with $$R0 = $R0" ; debug
!macroend ; _ForJawsVersions
!define ForJawsVersions "!insertmacro _ForJawsVersions"

!macro _ForJawsversionsEnd
; Place after the code that installs scripts to a version.
Pop $R0 ;restore loop index
;DetailPrint "ForJawsVersionsEnd: before incrementing, $$R0 = $R0" ; debug
intop $R0 $R0 + 1
intcmp $R0 $SELECTEDJAWSVERSIONCOUNT 0 _ForJawsVersionsLoop${_ForJawsVersionsCounter} 0
pop $R0
pop $0
!macroend
!define ForJawsVersionsEnd "!insertmacro _ForJawsVersionsEnd"



;-----
;Pages
!macro JAWSWelcomePage
!define MUI_WELCOMEPAGE_TITLE "$(WelcomePageTitle)"

!ifdef LegalCopyright
!define MUI_WELCOMEPAGE_TEXT "$(WelcomeTextCopyright)"
!else
!define MUI_WELCOMEPAGE_TEXT "$(WelcomeTextNoCopyright)"
!EndIf
!Insertmacro Mui_Page_Welcome
!macroend ; JAWSWelcomePage

!macro JAWSComponentsPage
;The order of the insstype commands is important.
; First is 0, so hacking these out should just be commenting.
;insttype "$(InstTypeFull)"
;insttype "$(InstTypeJustScripts)"
;insttype /NOCUSTOM
;insttype /COMPONENTSONLYONCUSTOM
!define INST_FULL 1
!define INST_JUSTSCRIPTS 2
;!define INST_CUSTOM 33
!define INST_CUSTOM 32

; Displays 3 lines of about 98 chars.
;!define MUI_COMPONENTSPAGE_TEXT_TOP "$(InstTypeFullMsg)"
;!define MUI_COMPONENTSPAGE_TEXT_COMPLIST text
;!define MUI_COMPONENTSPAGE_TEXT_INSTTYPE text
;!define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_TITLE text
;!define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_INFO text ;Text to display inside the description box when no section is selected.
;!define MUI_PAGE_CUSTOMFUNCTION_LEAVE ComponentsPageLeave
;!insertmacro mui_page_Components

function ComponentsPageLeave
getcurinsttype $0
intop $0 $0 + 1
;messagebox MB_OK "ComponentsPageLeave: insttype = $0, justscripts = ${INST_JUSTSCRIPTS}" ; debug
;sectiongetflags $JAWSSecInstSrc $1 ; debug
;messagebox MB_OK "ComponentsPageLeave: SecInstSrc flags = $1" ; debug
intcmp $0 ${INST_JUSTSCRIPTS} end +1 +1
;sectiongetflags $JAWSSecUninstaller $1 ; debug
;messagebox MB_OK "ComponentsPageLeave: before selecting insttype = $0, section flags = $1" ; debug

!insertmacro SelectSection $JAWSSecUninstaller
!ifmacrodef JAWSInstallFullItems
!insertmacro SelectSection $JAWSSecInstDirFiles
!EndIf ;if JAWSInstallFullItems
;sectiongetflags $JAWSSecUninstaller $1 ; debug
;messagebox MB_OK "ComponentsPageLeave: after selecting section flags = $1" ; debug
end:
functionend
!macroend ;JAWSComponentsPage

;-----

; List view control

;(Windows) Messages, styles, and structs for handling a list view.
!IfNDef LVM_GETITEMCOUNT
  ;Assume that if LVM_GETITEMCOUNT is defined, then the others are also defined.
;!define LVM_FIRST           0x1000
!define /math LVM_GETITEMCOUNT ${LVM_FIRST} + 4
!define /math LVM_GETITEMTEXTA ${LVM_FIRST} + 45
!define /math LVM_GETITEMTEXTW ${LVM_FIRST} + 115
!define LVM_GETUNICODEFORMAT 0x2006
!define /math LVM_GETITEMSTATE ${LVM_FIRST} + 44
!define /math LVM_SETITEMSTATE ${LVM_FIRST} + 43
!define /math LVM_GETITEMA ${LVM_FIRST} + 5
!define /math LVM_GETITEMW ${LVM_FIRST} + 75
!define /math LVM_SETITEMA ${LVM_FIRST} + 6
!define /math LVM_INSERTITEMA ${LVM_FIRST} + 7
!define /math LVM_INSERTITEMW ${LVM_FIRST} + 77
!define /math LVM_INSERTCOLUMNA ${LVM_FIRST} + 27
!define /math LVM_INSERTCOLUMNW ${LVM_FIRST} + 97
!define /math LVM_GETEXTENDEDLISTVIEWSTYLE ${LVM_FIRST} + 55
!define /math LVM_SETEXTENDEDLISTVIEWSTYLE ${LVM_FIRST} + 54 ; wparam is mask, lparam is style, returns old style
!EndIf ;NDef LVM_GETITEMCOUNT


;!define LVS_DEFAULT 0x0000000D ; Default control style  LVS_SHOWSELALWAYS + LVS_SINGLESEL + LVS_REPORT
; Itt looks like LVS_REPORT causes the items to disappear from the screen (but JAWS can still read them).
!define LVS_DEFAULT 0x0000000 ; Default control style  
;!define LVS_LIST 0x0003 ; This style specifies list view
;!define LVS_NOCOLUMNHEADER 0x4000 ; Column headers are not displayed in report view
;!define LVS_REPORT 0x0001 ; This style specifies report view
;!define LVS_EX_CHECKBOXES 0x00000004 ; Enables check boxes for items

;This is similar to the code that defines a control in nsdialogs.nsh.
!define __NSD_ListView_CLASS SysListView32
;!define __NSD_ListView_STYLE ${DEFAULT_STYLES}|${WS_TABSTOP}|${WS_VSCROLL}|${LVS_DEFAULT}|${LVS_NOCOLUMNHEADER}
!define __NSD_ListView_STYLE ${DEFAULT_STYLES}|${WS_TABSTOP}|${WS_VSCROLL}|${LVS_DEFAULT}|${LVS_LIST} ; debug
!define __NSD_ListView_EXSTYLE ${WS_EX_WINDOWEDGE}|${WS_EX_CLIENTEDGE}|${LVS_EX_CHECKBOXES}
;!define __NSD_ListView_EXSTYLE 0 ; debug
;!define __NSD_ListView_EXSTYLE ${LVS_EX_CHECKBOXES} ; debug
; This is an "internal" macro from nsdialogs.nsh.
!insertmacro __NSD_DefineControl ListView
; values for LVITEM struct mask field
;!define LVIF_TEXT 0x00000001
;!define LVIF_STATE 0x00000008

/* I got these struct definitions from AutoIt v3.3.8.1 structureconstants.au3
$tagLVITEM = "uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & _
		"int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup"
*/

; You can't use /* */ in the definition because the params for system::call is a NSIS string, but this is a good reference.
;!define tagLVITEM "u /*Mask*/, i /*Item*/, i /*SubItem*/, u /*State*/, u /*StateMask*/, t /*Text*/, i /*TextMax*/, i /*Image*/, i /*Param*/, i /*Indent*/, i /*GroupID*/, u /*Columns*/, i /*pColumns*/, i /*piColFmt*/, i /*iGroup*/"
!define LVIS_IMAGESTATEMASK 0xf000
!define LVIS_IMAGESTATECHECKED 0x2000 ; item is checked
!define LVIS_IMAGESTATEUNCHECKED 0x1000 ; item is unchecked

/*
!define tagLVCOLUMN "uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order;int cxMin;int cxDefault;int cxIdeal"
*/

;!define LVCF_FMT 0x0001
;!define LVCF_TEXT 0x0004
;!define LVCF_WIDTH 0x0002

; i is integers, I think t is a pointer to a text string.
!define tagLVCOLUMN "i, i, i, t, i, i, i, i, i, i, i"

; debug function
function DisplayLVItem
; Display the LVITEM struct for item $0 in $JAWSLV.  For debugging.
;store manipulates the stack: p# pushes $#, P# pushes $R#, r# pops into $#, R# pops into $R#.
;This pushes $1-7 and $R0-2.
system::store "p1p2p3p4p5p6p7P0P1P2"
;This allocates a struct.  A register without a . stores that register into the struct, .r# reads into $#, .R# reads into $R#, result address to $4
system::call "*(i -1, i $0, i .r2, i .r3, i 0xffff, t .r5, i .r6, i, i, i, i, i .r7, i, i, i) i .r4"
SendMessage $JAWSLV ${LVM_GETITEMA} 0 $4
;Read from the struct.
system::call "*$4(i -1, i .r1, i .r2, i .r3, i 0xffff, t .r5, i .r6, i, i, i, i, i .r7, i, i, i)"
intfmt $R1 "%x" $3
;intfmt $R2 "%x" $4
strcpy $R0 "item $1, subitem $2, state 0x$R1, text $5, len $6, columns $7"
messagebox MB_OK "LVItem: $R0"
system::free $4
;Pop registers stored at start.
system::store "R2R1R0r7r6r5r4r3r2r1"
functionend
!macro _DisplayLVItem item
push $0
strcpy $0 ${item}
call DisplayLVItem
pop $0
!macroend
!define DisplayLVItem "!insertmacro _DisplayLVItem"

; Adapted from AutoIt include file winapi.au3.
!macro GetStockObject obj
; return is on stack.
system::call "gdi32::GetStockObject(${obj}) i .s"
!macroend

; Adapted from AutoIt include file guilistview.au3.
!define GUI_DEFAULT_FONT 17
!macro _LVSetFont font
push $0
!insertmacro GetStockObject ${font}
;Do we need to pop to $0?
;$0 is WPARAM, 1 is LPARAM, no return.
SendMessage $JAWSLV ${WM_SETFONT} $0 1
pop $0
!macroend
!define LVSetFont "!insertmacro _LVSetFont"

!macro _NSD_GetStyle CONTROL
; Window style of CONTROL, returned on stack.
; GWL_STYLE is defined in nsdialogs.nsh.
	System::Call "user32::GetWindowLong(i ${CONTROL}, i ${GWL_STYLE}) i .s"
!macroend
!define NSD_GetStyle "!insertmacro _NSD_GetStyle"

!macro LVGetExStyle
; Returns extended style on stack.
push $0
SendMessage $JAWSLV ${LVM_GETEXTENDEDLISTVIEWSTYLE} 0 0 $0
;Result in $0.
exch $0
!macroend

function LVInsertItem
; $0 - item number
; $1 - item text
; Assumes the list view handle is in variable $JAWSLV.
push $R0
push $R1
push $R2
strlen $R0 $1 ; length of item text
intop $R0 $R0 + 1 ; for terminating null in case we need it.
intop $R0 $R0 * 2 ; unicode?
;Allocate a struct, its address placed in $R1.
;u doesn't seem to allocate memory, changed to i.
system::call "*(i ${LVIF_TEXT}, i r0, i 0, i, i, t r1, i R0, i, i, i, i, i, i, i, i) i .R1"
SendMessage $JAWSLV ${LVM_INSERTITEMA} 0 $R1 $R2 ; result in $R2
intcmp $R2 -1 0 +2 +2
; returned -1, error
messagebox MB_OK "LVInsertItem: LVM_INSERTITEMA failed for item $0" ; debug
system::free $R1
;messagebox MB_OK "added item $R2" ; debug
pop $R2
pop $R1
pop $R0
functionend ; LVInsertItem

!macro _LVAddItem text
; Add an item to the end of the list view.  Does not handle subitems.
; text - text of item
;The list view handle is in variable $JAWSLV.

push $0
push $1
strcpy $0 9999 ; item number, larger than current number of items
strcpy $1 "${text}"
call LvInsertItem
pop $1
pop $0
!macroend
!define LVAddItem "!insertmacro _LVAddItem"

function LVIsItemChecked
; $0 - (in) item index
; $1 - (out) true if checked
;The list view handle is in variable $JAWSLV.
push $R0
; set up the LVitem struct.
;system::call "*(u ${LVIF_STATE}, i $0, i 0, u, u 0xffff, t, i, i, i, i, i, u, i, i,i) i .R0"
SendMessage $JAWSLV ${LVM_GETITEMSTATE} $0 ${LVIS_IMAGESTATEMASK} $1 ; result in $1
;push $R0 ; debug
;intfmt $R0 "%x" $1 ; debug
;messagebox MB_OK "LVIsItemChecked: item state = 0x$R0" ; debug
;pop $R0 ; debug
intop $1 $1 & ${LVIS_IMAGESTATECHECKED} ; mask all but desired bit
;system::free $R0
pop $R0
;messagebox MB_OK "LVIsItemChecked: returning $1" ; debug
functionend

function LVCheckItem
; $0 - item index
; $1 - 0 = unchecked, else checked.
;10/31/15 Result of SendMessage ${LVM_SETITEMSTATE} in $R3.  Is this intended or a bug?
push $2
push $R0
strcpy $2 ${LVIS_IMAGESTATECHECKED}
intcmp $1 0 +1 +2 +2
strcpy $2 ${LVIS_IMAGESTATEUNCHECKED} ; unchecked
;Allocate struct, ptr to it in $R0.
; We probably don't need to set LVIF_STATE or item.
system::call "*(i ${LVIF_STATE}, i r0, i 0, i r2, i ${LVIS_IMAGESTATEMASK}, t, i, i, i, i, i, i, i, i, i) i .R0"
;messagebox MB_OK "LVCheckItem: setting item $0 to $2 in $JAWSLV" ; debug
SendMessage $JAWSLV ${LVM_SETITEMSTATE} $0 $R0 $R3 ;result in $R3
system::free $R0
;SendMessage $JAWSLV ${LVM_GETITEMSTATE} $0 ${LVIS_IMAGESTATEMASK} $R4 ; debug
;intfmt $R4 "%x" $R4 ; debug
;messagebox MB_OK "GetItemState returned 0x$R4, SetItemState returned $R3" ; debug
pop $R0
pop $2
functionend ;LVCheckItem

!macro _LVCheckItem item checked
push $0
push $1
strcpy $0 ${item}
strcpy $1 ${checked}
call LVCheckItem
pop $1
pop $0
!macroend
!define LVCheckItem "!insertmacro _LVCheckItem"

; Adapted from NSDialogs ${NSD_LB_GetSelection, has not been used.
!macro __NSD_LV_GetSelection CONTROL VAR

	SendMessage ${CONTROL} ${LVM_GETCURSEL} 0 0 ${VAR}
	System::Call 'user32::SendMessage(i ${CONTROL}, i ${LVM_GETITEMTEXT}, i ${VAR}, t .s)' ;result seems to be passed back in LPARAM, returned on stack
	Pop ${VAR} ; placed in ${VAR}

!macroend ;__NSD_LV_GetSelection

!define NSD_LV_GetSelection `!insertmacro __NSD_LV_GetSelection`

;-----

!macro JAWSSelectVersionsPage
page custom DisplayJawsList DisplayJawsListLeave ;Select Jaws version page
function MarkSelectedVersions
; Causes the list view items for the JAWS versions that have been previously selected to be checked.  This is to restore the selections if the user comes back to the JAWS versions page.
intcmp $SELECTEDJAWSVERSIONCOUNT 0 0 +2 +2
return ; return if no selected versions
;messagebox MB_OK "Enter MarkSelectedVersions" ; debug
push $0 ; index in $INSTALLEDJAWSVERSIONS
push $1 ; index in $SELECTEDJAWSVERSIONS
push $2 ; value we're looking for
push $3 ; value we're examining
strcpy $0 0
strcpy $1 0
${StrTok} $2 "$SELECTEDJAWSVERSIONS" "|" $1 0 ; index of first checked version in $2
strcpy $3 ""
loop:
intcmp $0 $INSTALLEDJAWSVERSIONCOUNT done 0 done ;jump out if index >= count
intcmp $1 $SELECTEDJAWSVERSIONCOUNT done 0 done
${StrTok} $3 "$INSTALLEDJAWSVERSIONS" "|" $0 0
;messagebox MB_OK "MarkSelectedVersions: checking item $0 $3 against $1 $2" ; debug
${If} $2 == $3
${LVCheckItem} $0 1
intop $1 $1 + 1 ; inc $1
${StrTok} $2 "$SELECTEDJAWSVERSIONS" "|" $1 0 ;next value we're looking for
${EndIf}
intop $0 $0 + 1 ;index for installed version
goto loop
done:
pop $3
pop $2
pop $1
pop $0
functionend ; MarkSelectedVersions

;Create installed JAWS versions page.
Function DisplayJawsList
  ;If no versions installed writes message and aborts (what is aborted? the page?).
;!InsertMacro SectionFlagIsSet ${SecJAWS} ${SF_SELECTED} DoJawsPage ""
goto DoJawsPage ; to debug, uncomment section selected test above.
DetailPrint "DisplayJawsList: install JAWS section not selected" ; debug
abort ; JAWS script install section not selected
  DoJawsPage:
    ;MessageBox MB_OK "Enter DisplayJawsList" ; debug
; .oninit has determined that there is at least 1 JAWS version installed, but we'll check here so maybe we can eliminate checking in .oninit.
; I use ${If} here so that I can include a debug message which can later be commented out without rewriting the code.
${JAWSSetShellVarContext} $JAWSSCRIPTCONTEXT
call GetJAWSVersions
pop $INSTALLEDJAWSVERSIONS
pop $INSTALLEDJAWSVERSIONCOUNT
${JAWSSetShellVarContext} $JAWSSHELLCONTEXT
DetailPrint "DisplayJawsList: found  $INSTALLEDJAWSVERSIONCOUNT versions: $INSTALLEDJAWSVERSIONS" ; debug
;messagebox MB_OK "DisplayJawsList: Found $INSTALLEDJAWSVERSIONCOUNT installed JAWS versions compatible with this application: $INSTALLEDJAWSVERSIONS" ; debug
${If} $INSTALLEDJAWSVERSIONCOUNT = 0
DetailPrint "DisplayJawsList: JAWS is not installed, skipping JAWS versions page" ; debug
messagebox MB_OK "DisplayJawsList: JAWS is not installed, skipping JAWS versions page" ; debug
abort ; no JAWS
${EndIf}

;If we allow install for all users then we need to show the JAWS Versions page even if there is only 1 version installed.
!ifdef JAWSALLOWALLUSERS
  ;We use $JAWSORIGINSTALLMODE instead of $JAWSSHELLCONTEXT in this function so that the Install For radio buttons will be displayed even if the user chooses current user, then Next, and then Back.  Otherwise, the Install For group disappears when coming back to this page.
  ${If} $JAWSORIGINSTALLMODE == "CurrentUser"
  !endif ; if allow install to all users
  ;If we don't allow installing the scripts for all users or the install is only for the current user.
${If} $INSTALLEDJAWSVERSIONCOUNT = 1
DetailPrint "DisplayJawsList: 1 JAWS version/lang, skipping JAWS versions page" ; debug
;MessageBox MB_OK "DisplayJawsList: 1 JAWS version $INSTALLEDJAWSVERSIONS, skipping JAWS versions page" /SD IDOK ; debug
strcpy $SELECTEDJAWSVERSIONS $INSTALLEDJAWSVERSIONS
strcpy $SELECTEDJAWSVERSIONCOUNT $INSTALLEDJAWSVERSIONCOUNT
;quit ; debug
abort ; only 1 JAWS version
${EndIf} ; if 1 version installed
!ifdef JAWSALLOWALLUSERS
${EndIf} ;install for current user
!endif ; if allow install to all users
nsDialogs::Create 1018
pop $JAWSDLG
;The versions do not include those installed that are outside JAWSMINVRSION and JAWSMAXVERSION.
${NSD_CreateLabel} 0 0 100% 10u "$(SelectJawsVersions)"
Pop $0 ; label handle not needed
;math::script 'r0 = ${__NSD_ListView_EXSTYLE}' ; debug
;IntFmt $0 "%x" $0 ; debug
;messagebox MB_OK "Before creating list view ex style = 0x$0, defined is '${__NSD_ListView_EXSTYLE}'" ; debug
${NSD_CreateListView} 3u 12u 55u 100u "$(LVLangVersionCaption)"
Pop $JAWSLV
math::script 'r0 = ${__NSD_ListView_EXSTYLE}'
SendMessage $JAWSLV ${LVM_SetExtendedListViewStyle} 0 $0 $1
;IntFmt $0 "%x" $0 ; debug
;messagebox MB_OK "After sending LVM_SetExtendedListViewStyle, old ex style = 0x$0" ; debug
${LVSetFont} ${GUI_DEFAULT_FONT}

; Set column header
/*
; Doesn't work, don't know why.
push $R0
push $R1
;Allocate struct, ptr to it in $R0
system::call "*(${tagLVCOLUMN}) (${LVCF_TEXT}, , , t "Version", 7) i .$R0"
SendMessage $JAWSLV ${LVM_INSERTCOLUMNA} 0 $R0 $R1 ;result in $R1
system::free $R0
${If} $R1 = -1
messagebox MB_OK "DisplayJawsList: unable to insert column, returned $R1"
${EndIf}
pop $R1
pop $R0
*/ ; column header
push $0
push $1
push $2
push $3
push $4
StrCpy $3 "${ScriptDefaultLang}|${JawsScriptLangs}" ; all the supported languages.
;MessageBox MB_OK "DisplayJawsList: before loop Supported languages ($$3) = $3" ; debug
strcpy $0 0
  ${While} $0 < $INSTALLEDJAWSVERSIONCOUNT
  ${strtok} $1 $INSTALLEDJAWSVERSIONS "|" $0 0 ;get the version/language pair
  ;MessageBox MB_OK "DisplayJawsList: got $1 from InstalledJawsVersions" ; debug
  push $0
  StrCpy $0 $1
  ;MessageBox MB_OK "DisplayJawsList: before GetVerLang $$1=$1" ; debug
  call GetVerLang
  exch
  pop $2 ;version, we don't need it
  pop $2 ;lang dir
  pop $0 ; restore the loop counter
  ;MessageBox MB_OK "DisplayJawsList: got language $2, $$1=$1" ; debug
  ${StrContainsTok} $4 "$3" "$2" "|"
  ${If} $4 == 0
    StrCpy $1 "$1*"
  ${EndIf}
  ;MessageBox MB_OK "DisplayJawsList: adding $1 to list view" ; debug
  ${LVAddItem} "$1"
  intop $0 $0 + 1
${EndWhile}  ;$0 < version count
;messagebox MB_OK "DisplayJawsList: added $0 of $INSTALLEDJAWSVERSIONCOUNT items" ; debug
pop $4
pop $3
pop $2
pop $1
pop $0


!ifdef JAWSALLOWALLUSERS
${If} $INSTALLEDJAWSVERSIONCOUNT = 1
${LVCheckItem} 0 1
${EndIf}
; Install for group box
${If} $JAWSORIGINSTALLMODE == "AllUsers"
${NSD_CreateGroupBox} 80u 12u 60u 40u "$(GBInstallForCaption)"
pop $JAWSGB
${NSD_CreateRadioButton} 85u 22u 55u 10u "$(RBCurrentUser)"
pop $JAWSRB1
${NSD_AddStyle} $JAWSRB1 ${BS_AUTORADIOBUTTON}
${NSD_CreateRadioButton} 85u 35u 55u 10u "$(RBAllUsers)"
pop $JAWSRB2
${NSD_AddStyle} $JAWSRB2 ${BS_AUTORADIOBUTTON}
;Assumes $JAWSSCRIPTCONTEXT is set to default value when page is displayed for the first time.
${If} $JAWSSCRIPTCONTEXT == "current"
${NSD_Check} $JAWSRB1
;Initially remove the unselected button from the tabbing order.
${NSD_RemoveStyle} $JAWSRB2 ${WS_TABSTOP}
${Else}
${NSD_Check} $JAWSRB2
;Initially remove the unselected button from the tabbing order.
${NSD_RemoveStyle} $JAWSRB1 ${WS_TABSTOP}
${EndIf} ; else all users
${EndIf} ;all users context
;Set initial focus
${If} $INSTALLEDJAWSVERSIONCOUNT = 1
  ${LVCheckItem} 0 1
  ${If} $JAWSSCRIPTCONTEXT == "current"
    ${NSD_SetFocus} $JAWSRB1
    ${Else}
    ${NSD_SetFocus} $JAWSRB2
  ${EndIf}
${Else}
  ; more than one version
  ${NSD_SETFOCUS} $JAWSLV
${EndIf} ; else more than one version

!else
;Don't allow all users.  We won't be here if only 1 installed version.
${NSD_SETFOCUS} $JAWSLV
!endif ; JAWSALLOWALLUSERS

; In case we come back to this page check the previously selected versions.
call MarkSelectedVersions
nsDialogs::Show
FunctionEnd ; DisplayJawsList

Function DisplayJawsListLeave
  ; On exit, var $SELECTEDJAWSVERSIONS contains the list of selected version/language pairs separated by | and $SELECTEDJAWSVERSIONCOUNT contains the number of version/language pairs selected.
  ;$JAWSSHELLCONTEXT and $JAWSSCRIPTCONTEXT are set.  (They are now set to the same value.)
push $0
push $1
push $3
/*
${NSD_GetStyle} $JAWSLV ; debug
pop $0 ; debug
IntFmt $1 "%x" $0 ; debug
!insertmacro LVGetExStyle ; debug
pop $0 ; debug
IntFmt $3 "%x" $0 ; debug
;messagebox MB_OK "Enter DisplayJawsListLeave with $INSTALLEDJAWSVERSIONCOUNT versions installed$\r$\nList view style = 0x$1, extended style = 0x$3." ; debug
*/
;messagebox MB_OK "Enter DisplayJawsListLeave with $INSTALLEDJAWSVERSIONCOUNT versions installed"

StrCpy $JAWSSCRIPTCONTEXT "current" ;default
!ifdef JAWSALLOWALLUSERS
${If} $JAWSORIGINSTALLMODE == "AllUsers"
  ; Get the selected context.
${NSD_GetState} $JAWSRB1 $0
  ${If} $0 = ${BST_CHECKED}
  strcpy $JAWSSCRIPTCONTEXT "current"
  ;SetShellVarContext current
${Else}
  strcpy $JAWSSCRIPTCONTEXT "all"
  ;SetShellVarContext all
${EndIf}
${EndIf} ;shell var context all
;We set the shell var context the same as the script context.
StrCpy $JAWSSHELLCONTEXT $JAWSSCRIPTCONTEXT
;messagebox MB_OK "Shell context is $JAWSSHELLCONTEXT, script context is $JAWSSCRIPTCONTEXT" ; debug
!EndIf ;if JAWSALLOWALLUSERS

;$JAWSSHELLCONTEXT is now the same as $JAWSSCRIPTCONTEXT, but we leave the machinery to separate them.
;We have to call the multiuser function because it sets the InstDir.
${If} $JAWSSHELLCONTEXT == "current"
  call MultiUser.InstallMode.CurrentUser
${Else}
  call MultiUser.InstallMode.AllUsers
${EndIf} ;${Else} all users

;See if the program is already installed
${ReadCurrentRegStr} $0 "${UNINSTALLKEY}\${ScriptName}" "UninstallString"
iferrors notinstalled
  messagebox MB_YESNOCANCEL "$(AlreadyInstalled)" /SD IDCANCEL IDNO notinstalled IDYES +2
    abort ; cancel
    ${StoreDetailPrint} "Uninstalling $0"
    ;If the string is quoted, remove them.  Note that this only works if the whole string is quoted.  If it were something like "installstring" /silent, it would fail.
    StrCpy $3 $0 1 ;first character
    ${If} $3 == '"'
      StrCpy $0 $0 -1 1 ;remove quotes
      ${EndIf}
    ;MessageBox MB_OK "uninstall string: $0" ; debug
    ${GetParent} $0 $3
    ;MessageBox MB_OK "Copying to $3" ; debug
  CopyFiles /silent $3\${uninstaller} $TEMP
  ;messagebox MB_OK "Executing $\"$TEMP\${uninstaller}$\" /S _?=$3" ; debug
  nsexec::Exec '"$TEMP\${uninstaller}" /S /logfile="$TEMP\uninstaller.log" _?=$3'
  pop $1
  ${StoreDetailPrint} "Uninstall returned exit code $1"
  Delete $TEMP\${uninstaller}
  FileOpen $0 "$TEMP\uninstaller.log" "r"
  ;${StoreDetailPrint} "fileopen returned $0" ; debug
  ${If} $0 <> 0
    ${StoreDetailPrint} "Uninstaller log:"
    ${Do}
      FileRead $0 $3
      ${If} ${Errors}
	${ExitDo}
      ${EndIf}
      StrCpy $3 $3 -2 ;remove CRLF
      ${StoreDetailPrint} "$3"
    ${Loop}
    FileClose $0
    Delete $TEMP\uninstaller.log
    ${StoreDetailPrint} "--- end uninstaller log$\r$\n"
  ${EndIf} ;if file opened
  intcmp $1 0 +3
    messagebox MB_OKCANCEL|MB_DEFBUTTON2 "$(UninstallUnsuccessful)" IDOK +2
    abort
notinstalled:

; Get the selected JAWS version/language pairs.
strcpy $SELECTEDJAWSVERSIONS ""
strcpy $SELECTEDJAWSVERSIONCOUNT 0
strcpy $0 0
${JAWSSetShellVarContext} $JAWSSCRIPTCONTEXT
  ${While} $0 < $INSTALLEDJAWSVERSIONCOUNT ;over installed version/language pairs
;${DisplayLVItem} $0 ; debug
call LVIsItemChecked
; $1 is nonzero if item $0 is checked
;messagebox MB_OK "after LVIsItemChecked $$1 = $1" ; debug
${If} $1 <> 0 ;checked

;messagebox MB_OK "item $0 is checked" ; debug
${strtok} $3 $INSTALLEDJAWSVERSIONS "|" $0 0
; CheckScriptExists expects version string in $0.
push $0
strcpy $0 $3
call CheckScriptExists
pop $0
; $1 = 0 if script does not exist or user chooses to overwrite.
;MessageBox MB_OK "DisplayJawsListLeave: CheckScriptExists returned $1" ; debug
${If} $1 = 0
  strcpy $SELECTEDJAWSVERSIONS "$SELECTEDJAWSVERSIONS$3|"
  intop $SELECTEDJAWSVERSIONCOUNT $SELECTEDJAWSVERSIONCOUNT + 1
${Else}
  ${LVCheckItem} $0 0 ; uncheck
${EndIf} ; else $1 != 1
${EndIf} ;if checked
intop $0 $0 + 1
${EndWhile} ;over installed version/language pairs

; If any were checked, remove final separator.
strcmp $SELECTEDJAWSVERSIONS "" +2
strcpy $SELECTEDJAWSVERSIONS $SELECTEDJAWSVERSIONS -1 ; remove trailing |
${StoreDetailPrint} "DisplayJawsListLeave: found  $SELECTEDJAWSVERSIONCOUNT versions: $SELECTEDJAWSVERSIONS" ; debug
;messagebox MB_OK "DisplayJawsListLeave: found  $SELECTEDJAWSVERSIONCOUNT versions: $SELECTEDJAWSVERSIONS" ; debug
${If} $SELECTEDJAWSVERSIONCOUNT = 0
  messagebox MB_OK "$(NoVersionSelected)"
  abort
${EndIf} ; if no versions

pop $3
pop $1
pop $0
;quit ; debug
functionend ; DisplayJawsListLeave
!macroend ;JAWSSelectVersionsPage

!macro JAWSMultiuserInstallModePage
;Includes a page to allow the user to choose whether to install for all users or the current user.
;This macro has been tested but is not currently used.
!insertmacro MULTIUSER_PAGE_INSTALLMODE

!macroend ;JAWSMultiuserInstallModePage

function JAWSMuInstallMode
  ${If} $MultiUser.InstallMode == "AllUsers"
    StrCpy $JAWSSHELLCONTEXT "all"
  ${Else}
    StrCpy $JAWSSHELLCONTEXT "current"
  ${EndIf}
FunctionEnd ;JAWSMuInstallMode

!macro JAWSDirectoryPage
; Empty because we hacked out the directory page.
!macroend ;JAWSDirectoryPage

!macro JAWSInstConfirmPage
page custom PageInstConfirmPre

!ifndef StrRepIncluded
${StrRep}
!EndIf

function PageInstConfirmPre
!insertmacro MUI_HEADER_TEXT "$(InstConfirmHdr)" "$(InstConfirmText)"
${StrRep} $1 "$SELECTEDJAWSVERSIONS" "|" ", "

; multiuser.nsh sets $INSTDIR, and we absolutely need to change it afterwords.
; We do it here because anywhere else is going to be more annoying.
strcpy $INSTDIR "$PROGRAMFILES32\DictationBridge for JAWS"

;${StoreDetailPrint} messages should not be translated.
${StoreDetailPrint} "Installation settings:"
;!ifdef JAWSALLOWALLUSERS
; These messages (added to $2) need to have a trailing space.
${If} $JAWSSCRIPTCONTEXT == "current"
  strcpy $2 "$(InstConfirmCurrentUser) "
  ${StoreDetailPrint} "Installing for the current user into JAWS versions $1."
${Else}
  strcpy $2 "$(InstConfirmAllUsers) "
  ${StoreDetailPrint} "Installing for all users into JAWS versions $1."
${EndIf}
;!Else
;strcpy $2 "$(InstConfirmCurrentUser) "
;${StoreDetailPrint} "Installing for the current user into JAWS versions $1."
;!EndIf

;$2 contains the trailing space if nonempty.
;Langstrings contain references to registers.  Those that strcpy to $0 contain $0, so they append.
strcpy $0 "$(InstConfirmVersions)"
;See if any of the selected JAWS versions contain files for this app.
${JAWSSetShellVarContext} $JAWSSCRIPTCONTEXT
strcpy $1 "" ;versions containing files
${ForJawsVersions}
  ;$0 contains current version, $R0 contains index.
  call GetJawsScriptDir
  pop $2
  strcpy $2 "$2\${ScriptApp}.*"
  ${If} ${FileExists} $2
    strcpy $1 "$1$0, "
  ${EndIf} ; files exist
${ForJawsVersionsEnd}
${JAWSSetShellVarContext} $JAWSSHELLCONTEXT
${If} $1 != ""
  ; Remove final comma and space.
  strcpy $1 $1 -2
  strcpy $0 "$(InstConfirmHaveFiles)"
  ${StoreDetailPrint} "The following JAWS versions contain files for this application (files that match ${ScriptApp}.*) and may be overwritten: $1."
${EndIf} ; if versions

;getcurinsttype $2 ; debug
;messagebox MB_OK "PageInstConfirmPRE: inst type $2" ; debug
${If} ${SectionIsSelected} $JAWSSecUninstaller
  strcpy $0 "$(InstConfirmUninstAddRemovePrograms)"
  ${StoreDetailPrint} "Installation folder: $INSTDIR.$\r$\nThis installation should be uninstalled via Add/Remove Programs."
  ${If} ${FileExists} "$INSTDIR\*.*"
    strcpy $0 "$(InstConfirmExistingInstall)"
    ${StoreDetailPrint} "There is an existing installation of ${ScriptName} on this machine."
  ${EndIf} ; $INSTDIR exists
  ${If} ${SectionIsSelected} $JAWSSecInstSrc ; SecInstSrc
    strcpy $0 "$(InstConfirmInstallerSrc)"
    ${StoreDetailPrint} "The installer source will be installed in $INSTDIR\${JAWSINSTALLERSRC}."
  ${EndIf} ; installer source
${Else}
  strcpy $0 "$(InstConfirmNotInstalled)"
  ${StoreDetailPrint} "This installation cannot be uninstalled via Add/Remove Programs."
${EndIf} ; else uninstaller section not selected


nsDialogs::create 1018
pop $2

${NSD_CreateTextMultiline} 0u 0u 100% 100% "$0"
pop $3
${NSD_AddStyle} $3 ${ES_READONLY}

${NSD_SetFocus} $3
nsDialogs::show
functionend
!macroend ;JAWSInstConfirmPage

!macro JAWSInstallScriptsSectionCode
; Insert this inside the section that installs the scripts.
; Assumes setOverWrite is set.
; Must be inserted before function JawsInstallVersion.
GetCurInstType $0
IntOp $0 $0 + 1 ;make it the same as for SectionIn
${If} $0 <> ${INST_JUSTSCRIPTS}
  !insertmacro JAWSLOG_OPENINSTALL
${EndIf} ;logging
${JAWSSetShellVarContext} $JAWSSCRIPTCONTEXT
${ForJawsVersions}
  ; $0 contains the version/lang pair string, $R0 contains the index into $SELECTEDJAWSVERSIONS.
  call JawsInstallVersion
${ForJawsVersionsEnd}
${JAWSSetShellVarContext} $JAWSSHELLCONTEXT
GetCurInstType $0
IntOp $0 $0 + 1 ;make it the same as for SectionIn
${If} $0 <> ${INST_JUSTSCRIPTS}
  !insertmacro JAWSLOG_CLOSEINSTALL
${EndIf} ;logging
!macroend

!macro JAWSJFWNSHInstallerSrc
  ${File} "" "uninstlog.nsh"
  ${File} "" "JFW_lang_enu.nsh"
  ${File} "" "JFW_lang_esn.nsh"
  ${File} "" "logging.nsh"
${File} "" "JFW.nsh"
  ${File} "" "readme.md"
!MacroEnd ;JAWSJFWNSHInstallerSrc

/*
!ifmacrondef JAWSInstallerSrc
!macro JAWSInstallerSrc
!InsertMacro JAWSJFWNSHInstallerSrc
!MacroEnd ;JAWSInstallerSrc
!EndIf ;ifmacrondef JAWSInstallerSrc
*/


!macro JAWSAfterInstallSections
;Insert this after your last installer section.
function JAWSOnInit
;To be called from .OnInit.  Quits if JAWS is not installed.
strCpy $0 0 ; index into registry keys
EnumRegkey $1 hklm "software\Freedom Scientific\Jaws" $0
${If} $1 == ""
  MessageBox MB_ICONINFORMATION|MB_OK "$(JawsNotInstalled)" /SD IDOK
  quit
${EndIf} ; if JAWS not installed

functionend ;JAWSOnInit

Function JAWSOnInstSuccess
IfFileExists ${TempFile} 0 +2
delete ${TempFile}
SetAutoClose false ; debug
FunctionEnd ;JAWSOnInstSuccess

function GetSecIDs
; Places the section index of the Get Installer Source and the SecUninstaller sections in variables.  This is because SecInstSrc is not defined before the code for PageInstConfirmPre that references them.
strcpy $JAWSSecInstSrc ${SecInstSrc}
strcpy $JAWSSecUninstaller ${SecUninstaller}
!ifmacrodef JAWSInstallFullItems
strcpy $JAWSSecInstDirFiles ${SecInstDirFiles}
!EndIf ;if JAWSInstallFullItems
;messagebox MB_OK "GetSecIDs:$$JAWSSecUninstaller = $JAWSSecUninstaller, $$JAWSSecInstSrc = $JAWSSecInstSrc" ; debug 
functionend
!macroend ;JAWSAfterInstallSections

function CheckScriptExists
; See if there are scripts for this app installed in the target dir, if so ask user if they should be overwritten.
; $0 string containing JAWS version to check.
; Returns 1 in $1 if scripts not present or user says they can be overwritten, else 0.
;Assumes shell var context is set to the script shell context.
push $2
strcpy $1 0 ; return value
;Entry: $0 = version string like "6.0".
call GetJAWSScriptDir
pop $2
; $2 = full script destination path.
;StrCpy $2 "${JAWSSCRIPTROOT}\$0\${ScriptDir}"
;StrCpy $JAWSPROGDIR "${JAWSPROGROOT}\$0"
;StrCpy $JAWSSCRIPTDEST $2
;messagebox MB_OK "CheckScriptExists: checking $2\${ScriptApp}.*" ; debug
IfFileExists "$2\${ScriptApp}.*" 0 end
;Don't know if we have to save registers used by ${Locate}, but we'll be safe
Push $R0
Push $R1
Push $R6
Push $R7
Push $R8
Push $R9
StrCpy $R0 0 ;result of ${Locate}
${Locate} "$2" "/L=F /M=${ScriptApp}.*" "CheckScriptExistsCB"
${If} $R0 <> 0
MessageBox MB_YESNO "$(OverwriteScriptsQuery)" IDYES +2
strcpy $1 1 ; no
  End:
    ${EndIf}
Pop $R9
Pop $R8
Pop $R7
Pop $R6
Pop $R1
Pop $R0
pop $2
;!ifdef JAWSDEBUG ; debug
;strcpy $1 1 ; debug
;!endif ; debug
;messagebox MB_OK "CheckScriptExists: returning $1" ; debug
FunctionEnd

Function CheckScriptExistsCB
  ${If} "$R7" == "${ScriptApp}.jcf"
    ;Skip .jcf file
    StrCpy $R1 0
  ${Else}
    ;Found one we don't want to skip.
    StrCpy $R0 1
    StrCpy $R1 StopLocate
  ${EndIf}
  Push $R1
FunctionEnd ;CheckScriptExistsCB


function GetJawsScriptDir
  ; Get the JAWS script directory based on its version, language, and user/shared setting.  If there is just a version use the default lang dir.  (This is intended for transitioning.)
  ;Assumes shell var context is set to $JAWSSCRIPTCONTEXT.
; $0 - string containing JAWS version number or version-lang pair.
; Returns script directory on stack.  For V17.0 or later and shared scripts this is the <version>\Scripts folder.  Otherwise it is <version>\settings\<lang>.
; Does logicLib support the >= test for strings? yes!
push $2 ;used for return value
push $1 ; used for version
push $3 ;used for lang dir
Push $4 ;scratch
;messagebox MB_OK "GetJawsScriptDir: checking version/lang $0" ; debug
call GetVerLang
pop $3 ;lang dir
pop $1 ;version
;MessageBox MB_OK "GetJawsScriptDir: version ($$1) = $1, langdir ($$3) = $3" ; debug
${VersionCompare} $1 "6.0" $4
${If} $4 < 2 ;Current selected version is 6.0 or later
  ${VersionCompare} $1 "17.0" $4
  ${If} $4 < 2
    ${AndIf} $JAWSSCRIPTCONTEXT == "all"
    ;V17.0 or later and installing to shared scripts folder.
    DetailPrint "GetJawsScriptDir 17 all: context=$JAWSSCRIPTCONTEXT, $${JawsDir}=${JawsDir}, $$1=$1, $$3=$3" ; debug
    strcpy $2 "${JawsDir}\$1\Scripts" ;get the script location from current user
  ${Else}
    ;before 17 or current
    DetailPrint "GetJawsScriptDir before 17 or current: context=$JAWSSCRIPTCONTEXT, $${JawsDir}=${JawsDir}, $$1=$1, $$3=$3" ; debug
      strcpy $2 "${JawsDir}\$1\Settings\$3" ;get the script location from current user
      ${EndIf} ;${Else} before 17 or current
;messagebox MB_OK "GetJawsScriptDir: $${JawsScriptDir} = ${JawsScriptDir}, returning $2" ; debug
${Else}
;Jaws 5.0 or erlier, the language folder is inside the folder containing the JAWS program, so we'll find the path by reading from the registry.
ReadRegStr $2 HKLM "SOFTWARE\Freedom Scientific\Jaws\$1" "Target"
strcpy $2 "$2\${ScriptDir}\$3"
${EndIf}
Pop $4
pop $3
pop $1
exch $2 ; return value
functionend

function GetJawsProgDir
; Get the JAWS program directory based on its version.
; $0 - string containing JAWS version number.
; Returns JAWS program directory on stack.
;If registry key not found uses ${JAWSDefaultProgDir}\$0\.
push $2
ReadRegStr $2 HKLM "SOFTWARE\Freedom Scientific\Jaws\$0" "Target"
  ;StrCpy $2 "" ; test ReadRegStr failure
${If} $2 == ""
  strCpy $2 "${JAWSDefaultProgDir}\$0\"
  ;MessageBox MB_OKCANCEL `GetJawsProgDir: error reading registry key HKLM "SOFTWARE\Freedom Scientific\Jaws\$0" "Target": Using default program dir $2$\r$\nThis is probably okay, but please advise the JAWS script developers.` IDOK +2
    ;abort ; camcel
${EndIf}
exch $2 ; return to TOS, $2 same as before call
functionend


/*
; for debugging
!ifndef StrTok_INCLUDED
${StrTok}
!endif


!macro tstenumjawsversions var root key index
; Resembles enumregkey to test GetJAWSVersions.
strcpy ${var} ""
; compare with number of items in strtok.
intcmp ${index} 6 tstenumskip 0 tstenumskip
${strtok} ${var} "5.0|6.0|9.0|10.0|11.0|12.0" "|" ${index} 0
;intcmp ${index} 3 tstenumskip 0 tstenumskip
;${strtok} ${var} "9.0|10.2|11.0" "|" ${index} 0
tstenumskip:
!macroend
*/

function GetJAWSVersions
; Makes a list of installed JAWS version/language pairs.  If ${JAWSMINVERSION} or ${JAWSMAXVERSION} are defined, versions outside of their limits are excluded.
; return: TOS - string containing list of JAWS version/language pairs separated by |, TOS-1 - number of JAWS versions found.
;Assumes ${JawsDir} (and therefore $APPDATA) is properly set.
push $5
push $6
push $R0
push $7
push $8
push $9
;Yes, an odd order, long story, you don't want to know!
push $0
push $1
push $2
push $3
push $4
strCpy $R0 0 ; registry entry index
strcpy $6 0 ; number of JAWS versions found
strcpy $5 "" ; JAWS versions found
loop:
EnumRegkey $7 hklm "software\Freedom Scientific\Jaws" $R0 ;Enumerate the existing version of Jaws
;!insertmacro tstEnumJawsversions $7 hklm "software\Freedom Scientific\Jaws" $R0 ;test Enumerate the existing versions of Jaws
;messagebox MB_OK "GetJawsVersions: got version $7 at index $R0" ; debug
strcmp $7 "" done ; exit loop if after last JAWS version
IntOp $R0 $R0 + 1 ;increase the registry key index by one unit
; Is this registry key a version number?  I have seen "Common" Victor checks for "Registration", and I don't know of any version that doesn't start with a digit.
; We search for the first character of the entry in a string of digits.  If we find it, we know it starts with a digit.  If not, we can skip this entry.
strcpy $8 $7 1 ; copy first character
${StrLoc} $9 "0123456789" $8 ">"
strcmp $9 "" loop ; if "", the character was not found
; character is in "0" through "9"
; Starts with a digit, is a version.

;Is it within min and max version limits?
${If} "${JAWSMINVERSION}" == ""
${OrIf} $7 >= "${JAWSMINVERSION}"
;messagebox MB_OK "passed minversion" ; debug
${If} "${JAWSMAXVERSION}" == ""
${OrIf} $7 <= "${JAWSMAXVERSION}"
  ;messagebox MB_OK "passed minversion" ; debug
  ;Get the languages for this version
  StrCpy $0 $7 ; version
  call GetVersionLangs  ;$1 contains langs separated by |, $2 contains number of langs.
  ;Index of last lang is $2 - 1.
  loop2:
  IntOp $2 $2 - 1
${StrTok} $3  "$1" "|" "$2" "0"
intop $6 $6 + 1 ; increment version/langs count
;Add this version/lang to the Jaws versions we have already found if any
strcpy $5 "$5$7${ScriptVerLangSep}$3|"
IntCmp $2 0 0 0 loop2
${EndIf} ; meets max version conditions
${EndIf} ; meets min version condition
goto loop ;continue checking

done: ; done with loop
strcmp $5 "" +2 ; Did we find any JAWS versions?
strcpy $5 $5 -1 ;yes, remove trailing |
detailprint "GetJAWSVersions: got $6 versions: $5" ; debug
;messagebox MB_OK "GetJAWSVersions: got $6 versions: $5" ; debug
pop $4
pop $3
pop $2
pop $1
pop $0
pop $9
pop $8
pop $7
;messagebox MB_OK "After popping $$7 $$9 = $9, $$8 = $8, $$7 = $7" ; debug
pop $R0
; Put the return values on the stack and restore to the registers their original values.
exch $6
exch
exch $5
; stack contains: versions, version count
functionend

;VAR STACKSIZE ; debug
function JawsInstallVersion
; Installs scripts to a JAWS version/lang.
; $0 - string containing JAWS version/lang pair or version.
; Assumes overwrite is set to on.
;Assumes shell context is set for installing the scripts.
; On exit $outDir set to script directory for the version.
; Should we return an error indication if the script did not compile?
;DetailPrint "JawsInstallVersion: on entry $$R0 = $R0" ; debug
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "  stack size = $STACKSIZE" ; debug
push $1
push $R0
push $R1
call GetJawsScriptDir
pop $R1 ; script dir
DetailPrint "JawsInstallVersion: GetJawsScriptDir returned $R1, JawsDir=${JawsDir}" ; debug
${SetOutPath} "$R1"
!ifndef JAWSDEBUG
StrCpy $UninstLogAlwaysLog 1
DetailPrint "JAWSInstallVersion: invoking macro JAWSInstallScriptItems for version $0" ; debug
push $0 ; save version/lang
push $1
call GetVerLang
pop $1
pop $0
; $0 = version, $1 = lang
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "Before JAWSInstallScriptItems stack size = $STACKSIZE" ; debug
!insertmacro JAWSInstallScriptItems
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "After JAWSInstallVersion stack size = $STACKSIZE" ; debug
;Assumes version in $0 and lang in $1!
${JawsScriptSetPath} jss ;set $OUTDIR for compile
pop $1
pop $0 ; restore version/lang
StrCpy $UninstLogAlwaysLog ""
!EndIf ;ifndef JAWSDEBUG
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "Before CompileSingle stack size = $STACKSIZE" ; debug
!insertmacro CompileSingle $0 "${ScriptApp}"
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "after CompileSingle stack size = $STACKSIZE" ; debug
!ifdef JAWSDEBUG
  ;$R0 doesn't contain compiler!!
  ;MessageBox MB_OK `Pretending to run ExecWait '"$R0" "$R1.jss"' $$1`
!Else ; not JAWSDEBUG
  IntCmp $1 0 GoodCompile +1 +1
    ;MessageBox MB_OK "Could not compile $R1, CompileSingle returned $1"
    ;GoTo End
    goto NoCompile
  GoodCompile:
  ;Add .jsb file to log
  strCpy $R0 "$UninstLogAlwaysLog"
  StrCpy $UninstLogAlwaysLog "1"
  ${AddItemDated} "$OUTDIR\${ScriptApp}.jsb"
  StrCpy $UninstLogAlwaysLog "$R0"
!EndIf ; else not JAWSDEBUG
GoTo End
NoCompile:
/*
;$R0 isn't compiler here!
MessageBox MB_OK "$(CouldNotFindCompiler)"
*/
End:
pop $R1
pop $R0
pop $1
;DetailPrint "JawsInstallVersion: on exit $$R0 = $R0" ; debug
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "  stack size = $STACKSIZE" ; debug
functionend ; JawsInstallVersion

;-----
;Save/restore uninstaller information

function JAWSSaveInstallInfo
;Store information needed by the uninstaller.  Only JAWSShellContext is needed right now but we store versions and version count for future use.
;Writes to ${TempFile}.
writeinistr "${TempFile}" "Install" JAWSVersionLangs $SELECTEDJAWSVERSIONS
writeinistr "${TempFile}" "Install" JAWSVersionLangsCount $SELECTEDJAWSVERSIONCOUNT
!ifdef JAWSALLOWALLUSERS
  writeinistr "${TempFile}" "Install" JAWSShellContext $JAWSSHELLCONTEXT
  writeinistr "${TempFile}" "Install" JAWSSScriptContext $JAWSSCRIPTCONTEXT
!EndIf
functionend ; JAWSSaveInstallInfo

function un.JAWSRestoreInstallInfo
;Restore installation info from ini file.  All we need right now is JAWSShELLCONTEXT but we'll get the other stuff anyway.
;Reads from ${InstallFile}.
readinistr $SELECTEDJAWSVERSIONS "${InstallFile}" "Install" JAWSVersionLangs
readinistr $SELECTEDJAWSVERSIONCOUNT "${InstallFile}" "Install" JAWSVersionLangsCount
!ifdef JAWSALLOWALLUSERS
  readinistr $JAWSSHELLCONTEXT "${InstallFile}" "Install" JAWSShellContext
  readinistr $JAWSSCRIPTCONTEXT "${InstallFile}" "Install" JAWSScriptContext
!EndIf
functionend ; un.JAWSRestoreInstallInfo

!macro JAWSSectionRemoveScript
Section Un.RemoveScript
;!insertmacro un.DeleteScript "${ScriptApp}*.*"
;SetShellVarContext all
!insertmacro JAWSLOG_UNINSTALL
SetOutPath "$INSTDIR"

!ifdef UNINSTALLLOGINCLUDED
Delete "${JAWSLOGFILENAME}"
!EndIf

SectionEnd
!macroend ;JAWSSectionRemoveScript

;-----
!macro JAWSDumpUninstLog
  ;If command line switch present dump uninstaller log to specified file.
  Push $0
  Push $1
  ${GetParameters} $0
  ${GetOptions} "$0" "/logfile=" $1
  ${If} $1 != ""
    Push $1
    call un.logging_Write
  ${EndIf}
  Pop $1
  Pop $0
!MacroEnd ;JAWSDumpUninstLog
!Define JAWSDumpUninstLog "!InsertMacro JAWSDumpUninstLog"

;-----

  !macro JAWSScriptInstaller
;defines for product info and paths
!ifndef VERSION
!searchparse /ignorecase /file "${JAWSSrcDir}${ScriptApp}.jss" `const CS_SCRIPT_VERSION = "` VERSION `"`
;Get script version.
!ifndef VERSION
!warn "VERSION not gotten from source file, defining it here."
;!define VERSION "0.8.0.00"
!define VERSION ""
!endif ;ifdef VERSION
!endif ;first ifdef VERSION
!echo "VERSION='${VERSION}'"

;Language string files.  They are here because they have to come after the definition of ${VERSION}.


;The registry key in HKLM or HKCU where the uninstall information is stored.
!define UNINSTALLKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall"

ShowInstDetails Show ; debug
AutoCloseWindow False ; debug
;Name shown to user, also name of installer file
Name "${ScriptName}"
;The executable file to write
OutFile "${ScriptName}.exe"
;installation directory
InstallDir "$programfiles\${scriptName}" 
;In case it is already installed.
;Is this done in Multiuser.nsh?
;installdirregkey HKLM "${UNINSTALLKEY}\${ScriptName}" "UninstallString"
BrandingText "$(BrandingText)"

  !define MUI_ABORTWARNING
  !define MUI_UNABORTWARNING
!ifndef JAWSNoReadme
!ifndef MUI_FINISHPAGE_SHOWREADME
;!define MUI_FINISHPAGE_SHOWREADME "$instdir\${SCriptApp}_readme.txt"
!define MUI_FINISHPAGE_SHOWREADME "$JAWSREADME"
!EndIf
!define MUI_FINISHPAGE_SHOWREADME_TEXT "$(ViewReadmeFile)"
!EndIf ;ifndef JAWSNoReadme
!define MUI_FINISHPAGE_TEXT_LARGE


!insertmacro JAWSWelcomePage ; ::nsi

!ifdef JAWSLicenseFile
;JAWSSrcDir is empty or contains a trailing backslash.
!insertmacro MUI_PAGE_LICENSE "$(JAWSLicenseFile)"
!EndIf

!insertmacro JAWSComponentsPage

;Currently not used.
;!insertmacro JAWSMultiuserInstallModePage

!insertmacro JAWSSelectVersionsPage

!insertmacro JAWSDirectoryPage

!insertmacro JAWSInstConfirmPage

!define mui_page_customfunction_leave InstFilesLeave
!insertmacro mui_page_instfiles

Function InstFilesLeave
;If we are installing just scripts we don't have the folder in program files, so we don't dump the log file to not clutter up the scripts folder.
  GetCurInstType $0
IntOp $0 $0 + 1 ;make it like SectionIn
${IfNot} $0 = ${INST_JUSTSCRIPTS}
  !insertmacro JAWSLOG_OPENINSTALL
  DetailPrint "Adding $INSTDIR\installer.log."
  ${AddItemAlways} "$INSTDIR\installer.log"
  !insertmacro JAWSLOG_CLOSEINSTALL
  push "$INSTDIR\installer.log"
  call logging_DumpLog
${EndIf}
FunctionEnd ; InstFilesLeave
  
!insertmacro mui_page_Finish

;Uninstall pages
;  !insertmacro MUI_UNPAGE_COMPONENTS
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "Spanish"
  !include "uninstlog_enu.nsh"
  !include "uninstlog_esn.nsh"
!include "JFW_lang_enu.nsh" ;English language strings for this file
!include "JFW_lang_esn.nsh" ;Spanish language strings for this file

; Used to be .onInit, renamed and called from ours.
Function OldOnInit
  ${StoreDetailPrintInit}
  !insertmacro MULTIUSER_INIT
  StrCpy $JAWSORIGINSTALLMODE $MultiUser.InstallMode
;Shell var context has been set by Multiuser.  Set $JAWSSHELLCONTEXT to match.
${If} $Multiuser.InstallMode == "CurrentUser"
strcpy $JAWSSHELLCONTEXT "current" ; default context
${Else}
strcpy $JAWSSHELLCONTEXT "all" ; default context
${EndIf}
;MessageBox MB_OK ".oninit: MULTIUSER.PRIVILEGES = $MULTIUSER.PRIVILEGES, JAWSSHELLCONTEXT = $JAWSSHELLCONTEXT" ; debug
StrCpy $JAWSSCRIPTCONTEXT "current" ;where JAWS scripts are installed

!insertmacro MUI_LANGDLL_DISPLAY
  ;Find where the JAWS program files are located.
push $0
strcpy $0 "Freedom Scientific\JAWS"
${If} ${FileExists} "$programfiles\$0"
  StrCpy $JAWSPROGDIR "$programfiles\$0"
${ElseIf} ${FileExists} "$programfiles64\$0"
  StrCpy $JAWSPROGDIR "$programfiles64\$0"
${Else}
  ; couldn't find one.
  DetailPrint "Couldn't find the folder $0 in either $programfiles or $programfiles64."
  messagebox MB_OK "$(CantFindJawsProgDir)"
${EndIf}
pop $0

call GetSecIDs ; Initializes variables with some section indexes.
call JAWSOnInit
FunctionEnd ; .OnInit

Function .OnInstSuccess
call JAWSOnInstSuccess
functionend ;JAWSOnInstSuccess


Section -Install
/*
;This won't work here because the install will set it!
!ifdef MUI_FINISHPAGE_SHOWREADME
${If} $JAWSREADME == ""
;No location has been defined for the README file.  We'll try to give it a default since we can't tell the Finish page there isn't one, and there might be one if the define doesn't reference $JAWSREADME.  If it doesn't use $JAWSREADME, no harm is done.
StrCpy $JAWSREADME "$InstDir\${ScriptApp}_README.txt"
${EndIf}
!EndIf ; ifdef MUI_FINISHPAGE_SHOWREADME
*/
${GetTime} "" "l" $R0 $R1 $R2 $R3 $R4 $R5 $R6
DetailPrint "Installing ${ScriptName}, installer compiled at ${MsgTimeStamp}, installed at $R2-$R1-$R0 $R4:$R5."
nsexec::ExecToSTack "cmd /C ver"
pop $R7 ;exet code
pop $R7 ;output-- OS version
UserInfo::GetAccountType
Pop $R8
DetailPrint "Target system OS: $R7 with account type $R8"
${DetailPrintStored}
;Print messages stored during previous execution-- Init, pages, etc.
SectionEnd

!ifmacrodef JAWSInstallFullItems
section "-install files in instdir" SecInstDirFiles
SectionIn ${INST_FULL}
SetOutPath $INSTDIR
!insertmacro JAWSLOG_OPENINSTALL
!insertmacro JAWSInstallFullItems
!insertmacro JAWSLOG_CLOSEINSTALL
sectionend
!EndIf ;if JAWSInstallFullItems

!ifdef UNINSTALLLOGINCLUDED
  ;Only write the uninstaller if uninstlog is included.
Section -Uninstaller SecUninstaller
;Writes the uninstaller and supporting info.
sectionIn ${INST_FULL}
!insertmacro JAWSLOG_OPENINSTALL
;Set up for uninstallation.
call JAWSSaveInstallInfo ; saves to ${TempFile}
${AddItemAlways} ${InstallFile} ; won't log it if after copy (but now we use AddItemAlways)
CopyFiles /silent ${TempFile} ${InstallFile} ;copy the install.ini to the instal directory
;Write the uninstaller and add it to the uninstall log.
${WriteUninstaller} "$Instdir\${UnInstaller}"
;Add the app to Add or Remove programs.
${WriteCurrentRegStr} "${UNINSTALLKEY}\${ScriptName}" "DisplayName" "${ScriptName} (remove only)"
;The uninstall command is quoted because the Audacity uninstall string contains quotes.  I have observed other apps that do not quote their uninstall strings, I think even if they contain spaces.
${WriteCurrentRegStr} "${UNINSTALLKEY}\${ScriptName}" "UninstallString" '"$INSTDIR\${UnInstaller}"'
!insertmacro JAWSLOG_CLOSEINSTALL
sectionEnd
!EndIf ;UNINSTALLLOGINCLUDED

;---
; Install JAWS Scripts section
Section "-Install JAWS Scripts" SecJAWS
SectionIn ${INST_FULL} ${INST_JUSTSCRIPTS}
SetOverwrite on ;Always overwrite
!insertmacro JAWSInstallScriptsSectionCode
SetOverwrite ${SetOverwriteDefault}
SectionEnd ;Install JAWS scripts

;This allows us to try not having an installer source section-- comment out macro JAWSInstallerSrc.
!ifmacrodef JAWSInstallerSrc
  section "Installer Source" SecInstSrc
;SectionIn ${INST_FULL}
!insertmacro JAWSLOG_OPENINSTALL
${CreateDirectory} "$INSTDIR\${JAWSINSTALLERSRC}"
SetOutPath  "$INSTDIR\${JAWSINSTALLERSRC}"
!insertmacro JAWSInstallerSrc
SetOutPath $INSTDIR
!insertmacro JAWSLOG_CLOSEINSTALL
SectionEnd
!EndIf ;ifmacrodef JAWSInstallerSrc

!insertmacro JAWSAfterInstallSections

;-----
;From NSIS user manual appendix:
/*
To use it, push a file name and call it. It will dump the log to the file specified. For example:

GetTempFileName $0
Push $0
Call DumpLog
*/
;These are defined in list view stuff.
;!define LVM_GETITEMCOUNT 0x1004
;!define LVM_GETITEMTEXT 0x102D


;-----
;Uninstaller function and Section
Function un.onInit
  !insertmacro MULTIUSER_UNINIT
  ${StoreDetailPrintInit}
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(SureYouWantToUninstall)" /SD IDYES IDYES +2
  Abort
  call un.JAWSRestoreInstallInfo
  ${If} $JAWSSHELLCONTEXT == "all"
    ;messagebox MB_OK "Setting all users context" ; debug
    SetShellVarContext all
  ${Else}
    SetShellVarContext current
  ${EndIf}
FunctionEnd

Function un.OnUninstSuccess
  ;!Insertmacro RemoveTempFile
  HideWindow
  ${If} ${FileExists} "$INSTDIR"
    MessageBox MB_ICONEXCLAMATION|MB_OK "$(InstallFolderNotRemoved)" /SD IDOK
    ${logging_DetailPrint} "un.OnUnInstSuccess:install folder  $INSTDIR not removed" 
  ${Else}
    MessageBox MB_ICONINFORMATION|MB_OK "$(SuccessfullyRemoved)" /SD IDOK
    ${logging_DetailPrint} "un.OnUnInstSuccess:install folder  $INSTDIR successfully removed" 
  ${EndIf} ;${Else} instdir removed
  ;Dump the log if command line option specified.
  ${JAWSDumpUninstLog}
FunctionEnd ;un.OnUninstSuccess

Function un.OnUnInstFailed
  ${logging_DetailPrint} "un.OnInstFailed: dumping log if requested"
  ;Dump the log if command line option specified.
  ${JAWSDumpUninstLog}
  FunctionEnd ;un.OnUnInstFailed

!insertmacro JAWSSectionRemoveScript

Section un.Uninstaller
${If} $JAWSSHELLCONTEXT == "current"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ScriptName}"
${Else}
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ScriptName}"
${EndIf}
  ; Set outpath to somewhere else, ProgramFiles for now, should be maybe parent of $INSTDIR.
SetOutPath "$PROGRAMFILES"
${logging_DetailPrint} "Attempting to remove $INSTDIR$\r$\n"
;We don't use rmdir /r in case user chose something like c:\Program Files as install dir.
Rmdir "$INSTDIR" 
SetAutoclose true
SectionEnd
!macroend ;JAWSScriptInstaller

!EndIf ;__JAWSSCRIPTSINCLUDED





;-----

/*
;Install JAWS scripts.
; I don't think these two are used, maybe they should be.
!define JAWSPROGROOT "$PROGRAMFILES\Freedom Scientific\JAWS"
!define JAWSSCRIPTROOT "$APPDATA\Freedom Scientific\JAWS" ; for v6.0 and later
*/


