import ctypes
from ctypes import wintypes
import os
import sys
py3 = sys.version_info.major == 3
if py3:
	import winreg
else:
	import _winreg as winreg
import addonHandler
from logHandler import log
import winUser
import config
#Don't rely on win32con constants, they might be disappearing   in NVDA soon.
HWND_BROADCAST=0xffff
WM_SETTINGCHANGE = 0x1a


def sendMessageTimeout(hwnd, msg, wParam, lParam, flags=0, timeout=5000):
	dwResult = wintypes.DWORD()
	lResult = ctypes.windll.user32.SendMessageTimeoutW(hwnd, msg, wParam, lParam, flags, timeout, ctypes.byref(dwResult))
	return lResult, dwResult

def onInstall(postPathBug = False):
	#Add ourself to the path, so that commands when spoken can be queried to us.
	#Only if we are truely installing though.
	addons = []
	if not postPathBug:
		addons = addonHandler.getAvailableAddons()
	for addon in addons:
		if addon.name=="DictationBridge":
			#Hack to work around condition where
			#the uninstaller removes this addon from the path
			#After the installer for the updator ran.
			#We could use version specific directories, but wsr macros Does not
			#play nice with refreshing the path environment after path updates,
			# requiring a complete reboot of wsr, or commands spontaneously break cripticly.
			with open(os.path.join(config.getUserDefaultConfigPath(), ".dbInstall"), 
				"w") as fi:
				fi.write("dbInstall")
				return
	key = winreg.OpenKeyEx(winreg.HKEY_CURRENT_USER, "Environment", 0, winreg.KEY_READ | winreg.KEY_WRITE)
	try:
		value, typ = winreg.QueryValueEx(key, "Path")
	except:
		value, typ = None, winreg.REG_EXPAND_SZ
	if value is None:
		value = ""
	dir = os.path.dirname(__file__)
	unicodestr = str if py3 else unicode
	if not isinstance(dir, unicodestr):
		dir = dir.decode(sys.getfilesystemencoding())
	dir = dir.replace(addonHandler.ADDON_PENDINGINSTALL_SUFFIX, "")
	log.info("addon directory: %r" % dir)
	log.info("current PATH: %r" % value)
	if value.lower().find(dir.lower()) == -1:
		if value != "":
			value += ";"
		value += dir
		log.info("new PATH: %r" % value)
		winreg.SetValueEx(key, "Path", None, typ, value)
		sendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, u"Environment")
def onUninstall():
	path = os.path.join(config.getUserDefaultConfigPath(), ".dbInstall")
	if os.path.exists(path):
		#This is an update. Bail.
		os.remove(path)
		return
	key = winreg.OpenKeyEx(winreg.HKEY_CURRENT_USER, "Environment", 0, winreg.KEY_READ | winreg.KEY_WRITE)
	try:
		value, typ = winreg.QueryValueEx(key, "Path")
	except:
		return
	if value is None or value == "":
		return
	dir = os.path.dirname(__file__)
	unicodestr = str if py3 else unicode
	if not isinstance(dir, unicodestr):
		dir = dir.decode(sys.getfilesystemencoding())
	dir = dir.replace(addonHandler.DELETEDIR_SUFFIX, "")
	if value.find(dir) != -1:
		value = value.replace(";" + dir, "")
		value = value.replace(dir + ";", "")
		value = value.replace(dir, "")
		winreg.SetValueEx(key, "Path", None, typ, value)
		sendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0, u"Environment")
