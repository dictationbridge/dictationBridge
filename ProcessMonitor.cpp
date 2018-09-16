// ProcessMonitor.cpp

#include "ProcessMonitor.h"

ULONG ProcessMonitor::AddRef()
{
	return InterlockedIncrement(&m_lRef);
}

ULONG ProcessMonitor::Release()
{
	LONG lRef = InterlockedDecrement(&m_lRef);
	if (lRef == 0)
		delete this;
	return lRef;
}

HRESULT ProcessMonitor::QueryInterface(REFIID riid, void** ppv)
{
	if (riid == IID_IUnknown || riid == IID_IWbemObjectSink)
	{
		*ppv = (IWbemObjectSink *) this;
		AddRef();
		return WBEM_S_NO_ERROR;
	}
	else return E_NOINTERFACE;
}


HRESULT ProcessMonitor::Indicate(long lObjectCount,
	IWbemClassObject **apObjArray)
{
	HRESULT hres = S_OK;
	CComVariant vData = NULL;
	CComPtr<IWbemClassObject> pTargetInstance;
	CComBSTR bClassPropertyName = L"__CLASS";
	CComBSTR bTargetInstancePropertyName = L"TargetInstance";
	CComBSTR bProcessName = L"Name";
	CComBSTR bProcessId = L"ProcessId";
	LPCWSTR lzClass;
	LPCWSTR lzProcessName;
	DWORD dProcessId;

	for (int i = 0; i < lObjectCount; i++)
	{
		//get the target instance property.
		hres = apObjArray[i]->Get(bTargetInstancePropertyName, 0, &vData, 0, 0);
		if (SUCCEEDED(hres))
		{
			//Obtained the TargetInstance property, now query fo the IWBEMCLASSOBJECT interface.				CComPtr<IWbemClassObject> pTargetInstance;
			IUnknown* str = vData.punkVal;
			hres = str->QueryInterface(IID_IWbemClassObject, reinterpret_cast<void**>(&pTargetInstance));
			if (SUCCEEDED(hres))
			{
				//Obtain the process name.
				lzProcessName = L"";
				hres = pTargetInstance->Get(bProcessName, 0, &vData, 0, 0);
				if (SUCCEEDED(hres))
				{
					lzProcessName = vData.bstrVal;
					lzClass = L"";
					hres = apObjArray[i]->Get(bClassPropertyName, 0, &vData, 0, 0);
					if (SUCCEEDED(hres))
					{
						lzClass = vData.bstrVal;
						if (wcsicmp(lzClass, L"__InstanceCreationEvent") == 0)
						{
							//A process has been created so we need the process id.
							hres = pTargetInstance->Get(bProcessId, 0, &vData, 0, 0);
							if (SUCCEEDED(hres))
							{
								dProcessId = vData.lVal;
								if (hNotificationWindow != nullptr)
								{
									PostMessage(hNotificationWindow, DBJH_PROCESSSTARTED, (WPARAM)lzProcessName, (LPARAM)dProcessId);
								}
								}
						}
						else if (wcsicmp(lzClass, L"__InstanceDeletionEvent") == 0)
						{
							//A process has been terminated.
							if (hNotificationWindow != nullptr)
							{
								PostMessage(hNotificationWindow, DBJH_PROCESSTERMINATED, (WPARAM)lzProcessName, 0);
							}
						}
					}
				}
			}
		}
 }
return WBEM_S_NO_ERROR;
}

HRESULT ProcessMonitor::SetStatus(
            /* [in] */ LONG lFlags,
            /* [in] */ HRESULT hResult,
            /* [in] */ BSTR strParam,
            /* [in] */ IWbemClassObject __RPC_FAR *pObjParam
        )
{
    return WBEM_S_NO_ERROR;
}    

void ProcessMonitor::SetProcessNotificationWindow(HWND window)
{
	hNotificationWindow = window;
}
// end of ProcessMonitor.cpp