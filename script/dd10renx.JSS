include "hjglobal.jsh"
include "hjconst.jsh"
include "msaaconst.jsh"
const 
CSCNoDialog =0,
CSCCorrectionDialog =1,
CSCSpellDialog =2

Globals
int giJustEnteredCorrectionBox, ;used to indicate when we have just entered the correction box as aposed to alt-tabbing away.
int giDragonLoading,
int giCorrectionBoxAlreadyActive, ;used to indicate if the correction box is already active when autostart/autofixinish fire.
int giBoxTypeActive

int Function HandleCustomAppWindows (handle hWnd)
var
handle hPlayThatBack,
string msgCorrectionAndSpellBoxOpenedPrompt_L = "%1 box opened.",
string strBoxOpenedMessage

if StringCompare (GetWindowName (hwnd), "Loading Dragon NaturallySpeaking", false) ==0
;We are loading dragon.
giDragonLoading =1
endif
if StringCompare ("ClsSpellDialog", GetWindowClass (hWnd), false) ==0 && giJustEnteredCorrectionBox==0 ;only run this code if we have entered the correction box and the correction box has just been opened.
if giJustEnteredCorrectionBox ==0 
hPlayThatBack =FindDescendantWindow (hwnd, 11162)
if !IsWindowDisabled (hPlayThatBack)
strBoxOpenedMessage =FormatString (msgCorrectionAndSpellBoxOpenedPrompt_l, "Correction")
giBoxTypeActive =CSCCorrectionDialog 
else
strBoxOpenedMessage =FormatString (msgCorrectionAndSpellBoxOpenedPrompt_l, "Spell")
giBoxTypeActive =CSCSpellDialog 
endif
SayUsingVoice (vctx_message, strBoxOpenedMessage, ot_dialog_name)
giDragonLoading =0
giJustEnteredCorrectionBox  =1
giCorrectionBoxAlreadyActive =1
return true
endif
else 
return HandleCustomAppWindows (hWnd)
endif
EndFunction

void function ProcessSayFocusWindowOnFocusChange(string RealWindowName, handle FocusWindow)
if giJustEnteredCorrectionBox ==1
return
else
return ProcessSayFocusWindowOnFocusChange(RealWindowName, FocusWindow)
Endif
EndFunction

Void Function FocusChangedEvent (handle FocusWindow, handle PrevWindow)
if giJustEnteredCorrectionBox  ==1
let giJustEnteredCorrectionBox  =0
endif
return FocusChangedEvent (FocusWindow, PrevWindow)
EndFunction

Void Function SayHighLightedText (handle hwnd, string buffer)
if (giJustEnteredCorrectionBox ==1)
return
else
return SayHighLightedText (hwnd, buffer)
endif
EndFunction

function AutoFinishEvent()
var
string msgCorrectionAndSpellBoxClosedPrompt_L = "%1 box closed.",
string strBoxClosedMessage,
handle correctionBoxWindow =FindTopLevelWindow ("ClsSpellDialog", "")
if !IsWindowVisible (correctionBoxWindow) && giDragonLoading ==0
if giBoxTypeActive ==CSCCorrectionDialog 
strBoxClosedMessage =FormatString(msgCorrectionAndSpellBoxClosedPrompt_l, "Correction")
else if giBoxTypeActive ==cscSpellDialog
strBoxClosedMessage =FormatString(msgCorrectionAndSpellBoxClosedPrompt_l, "Spell")
endif
endif
SayUsingVoice (vctx_message, strBoxClosedMessage, ot_string)
giCorrectionBoxAlreadyActive =0
giJustEnteredCorrectionBox =0
giBoxTypeActive =0
Endif
endfunction

int Function HandleCustomWindows (handle hWnd)
if GetControlID (hwnd) ==11035
SayControlEx (hwnd, GetWindowName(hwnd), GetObjectSubtype (), GetObjectState (), "", "", GetWindowTextEx (hwnd, 1, 0, 1), "x2", "")
return true
else
return HandleCustomWindows(hwnd)
endif
EndFunction

script SayLine()
var 
string windowText
if GetControlID (GetFocus()) ==11035
let windowText =GetWindowTextEx (GetFocus(), 1, 0, 1)
if IsSameScript ()
SayUsingVoice (vctx_pccursor, windowText, ot_spell)
else
SayUsingVoice (vctx_pccursor, windowText, ot_line)
endif
endif
EndScript

script SayPriorLine()
if GetControlID (GetFocus()) ==11035
PriorLine ()
SayUsingVoice (vctx_pccursor, GetWindowTextEx (GetFocus(), 1, 0, 1), ot_line)
else
PerformScript SayPriorLine()
endif
endscript

script SayNextLine()
if GetControlID (GetFocus()) ==11035
NextLine ()
SayUsingVoice (vctx_pccursor, GetWindowTextEx (GetFocus(), 1, 0, 1), ot_line)
else
PerformScript SayNextLine()
endif
endscript