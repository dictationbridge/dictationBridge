/*
Spanish User-visible messages for JFW.nsh (updated 2016-09-21)
Translation of file JFW_lang_enu.nsh last updated 2016-09-21.
This file last updated 2016-09-21.
Translated by Fernando Gregoire.
Does not include debug messages or messages printed to log file/log window.
*/

;Do not translate text inside ${...}.  These will be replaced with their values.  Also true for things like $variablename, $0, or $R1.  (To cause a $ to appear in text, it is doubled, like $$R0 will appear as $0.)

!ifndef JFW_ESN_INCLUDED
  !define JFW_ESN_INCLUDED

;$R1=script file name without extension, $1=exit code (number), $R2=text output by program.
LangString CouldNotCompile ${LANG_SPANISH} "No se pudo compilar $R1.jss, SCompile devolvi� $1$\r$\n$$OutDir=$OutDir, Salida:$\r$\n$R2."

LangString CouldNotFindCompiler ${LANG_SPANISH} "No se encontr� el compilador de scripts de JAWS $R0. Para usar esto, necesitar� compilarlo con el Asistente de Scripts de JAWS."

LangString NoVersionSelected ${LANG_SPANISH} "No se seleccionaron versiones."

LangString InstallFolderExists ${LANG_SPANISH} "La carpeta especificada existe, lo cual muy probablemente significa que ${ScriptName} ya est� instalado. Si desea instalar sobre la instalaci�n actual, elija S�."

LangString InstDirNotFolder ${LANG_SPANISH} "�$INSTDIR existe y no es una carpeta!"

LangString InstConfirmHdr ${LANG_SPANISH} "Confirmar configuraci�n de instalaci�n"

LangString InstConfirmText ${LANG_SPANISH} "Lo siguiente resume las acciones que efectuar� esta instalaci�n. Para cambiar la configuraci�n, haga clic en Atr�s. Para continuar, haga clic en Instalar (Alt+I)."
LangString InstConfirmCurrentUser ${LANG_SPANISH} "el usuario actual"
LangString InstConfirmAllUsers ${LANG_SPANISH} "todos los usuarios"

;$2=$(InstConfirmCurrentUser or $(InstConfirmAllUsers followed by a space, $1=comma-separated list of versions.
LangString InstConfirmVersions ${LANG_SPANISH} "Los scripts se instalar�n para $2 en las versiones de JAWS siguientes:$\r$\n$1.$\r$\n"

;$0=previous text, should not be followed by space.  $1=list of versions.
LangString InstConfirmHaveFiles ${LANG_SPANISH} "$0Las versiones de JAWS siguientes contienen archivos para esta aplicaci�n (archivos coincidentes con ${ScriptApp}.*): $1$\r$\nEstos archivos se pueden sobreescribir durante la instalaci�n.$\r$\n"

LangString InstConfirmUninstAddRemovePrograms ${LANG_SPANISH} "$0Carpeta de instalaci�n: $INSTDIR.$\r$\nEsta instalaci�n se ha de desinstalar a trav�s de Agregar o quitar programas.$\r$\n"

;$0=previous text.
LangString InstConfirmExistingInstall ${LANG_SPANISH} "$0En esta m�quina ya existe una instalaci�n de ${ScriptName}.$\r$\n"

LangString InstConfirmInstallerSrc ${LANG_SPANISH} "$0El c�digo fuente del instalador se instalar� en $INSTDIR\${JAWSINSTALLERSRC}."
LangString InstConfirmNotInstalled ${LANG_SPANISH} "$0Esta instalaci�n no se puede desinstalar a trav�s de Agregar o quitar programas."
LangString OverwriteScriptsQuery ${LANG_SPANISH} "Ya hay scripts para ${ScriptName} en $2. �Desea sobreescribirlos?"

LangString JawsNotInstalled ${LANG_SPANISH} "No se puede iniciar el instalador porque el programa Jaws no est� instalado en el sistema."

LangString CantFindJawsProgDir ${LANG_SPANISH} "No se encontr� la carpeta $0 ya sea en $programfiles o $programfiles64. La instalaci�n puede continuar, pero quiz� deba compilar los scripts usted."

LangString BrandingText ${LANG_SPANISH} "${ScriptName}"
LangString SuccessfullyRemoved ${LANG_SPANISH} "${ScriptName} se ha quitado correctamente del equipo."
LangString InstallFolderNotRemoved ${LANG_SPANISH} "Advertencia: la carpeta de instalaci�n $INSTDIR no se quit�. Probablemente contenga archivos que no se hayan eliminado."
LangString SureYouWantToUninstall ${LANG_SPANISH} "�Est� seguro de que desea quitar por completo $(^Name) y todos sus componentes?"
LangString UninstallUnsuccessful ${LANG_SPANISH} "La desinstalaci�n no se realiz� correctamente, c�digo de salida $1. Elija Aceptar para instalar de todos modos, o Cancelar para salir."
LangString AlreadyInstalled ${LANG_SPANISH} "${ScriptName} ya est� instalado en este equipo. Se recomienda encarecidamente que antes de continuar lo desinstale. �Desea desinstalarlo?"

;e.g. V2.0 ...
LangString VersionMsg ${LANG_SPANISH} "V${VERSION}"

;Messages in the Install Type combo box.
LangString InstTypeFull ${LANG_SPANISH} "Completa"
LangString InstTypeJustScripts ${LANG_SPANISH} "S�lo scripts"

;Text at the top of the Components page.
LangString InstTypeFullMsg ${LANG_SPANISH} "Completa le permite desinstalar utilizando Agregar o quitar programas.  $\n\
S�lo Scripts instala los scripts y el L�AME, no pudi�ndose desinstalar desde Agregar o quitar programas."

;Name of the Installer Sourse section (the Install Source custom component)
LangString SecInstallerSource ${LANG_SPANISH} "C�digo fuente del instalador"

LangString WelcomePageTitle ${LANG_SPANISH} "Instalaci�n de ${ScriptName}"

!if VERSION != ""
!define _VERSIONMSG " $(VersionMsg)"
!else
!define _VERSIONMSG ""
!endif

LangString WelcomeTextCopyright ${LANG_SPANISH} "Le damos la bienvenida a la instalaci�n de ${ScriptName}${_VERSIONMSG}.$\n\
Este asistente le guiar� por la instalaci�n de ${ScriptName}.$\n\
${LegalCopyright}$\n"
LangString WelcomeTextNoCopyright ${LANG_SPANISH} "Le damos la bienvenida a la instalaci�n de ${ScriptName}${_VERSIONMSG}.$\n\
Este asistente le guiar� por la instalaci�n de ${ScriptName}.$\n"
!undef _VERSIONMSG

;list view
;Text at the top of the Select JAWS Versions/Languages dialog.
LangString SelectJawsVersions ${LANG_SPANISH} "Seleccione las versiones/idiomas de JAWS en que instalar los scripts:"

;JAWS versions/languages list view caption
LangString LVLangVersionCaption ${LANG_SPANISH} "Versiones e idiomas de JAWS"

;Install for All/Current user group box ($JAWSGB)
LangString GBInstallForCaption ${LANG_SPANISH} "Instalar para"
LangString RBCurrentUser ${LANG_SPANISH} "El usuario a&ctual" ;$JAWSRB1
LangString RBAllUsers ${LANG_SPANISH} "&Todos los usuarios" ;$JAWSRB2

LangString DirPageText ${LANG_SPANISH} "Elija la carpeta en que almacenar archivos de instalaci�n de ${ScriptName} tales como el desinstalador, la ayuda u otros archivos. $\n\
El instalador almacenar� la instalaci�n de ${ScriptName} en la carpeta siguiente. Para instalar en una carpeta diferente, haga clic en Examinar y seleccione otra carpeta."

LangString ViewReadmeFile ${LANG_SPANISH} "Ver archivo L�AME"
!EndIf ;JFW_ESN_INCLUDED
