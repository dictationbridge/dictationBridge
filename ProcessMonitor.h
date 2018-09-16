// ProcessMonitor.h

#ifndef PROCESSMONITOR_H
#define PROCESSMONITOR_H
#define UNICODE
#define _WIN32_DCOM

#include <iostream>
#include <atlbase.h>
#include <atlsafe.h>
#include <comutil.h>
#include <Wbemidl.h>
#include <string>
using namespace std;
# pragma comment(lib, "wbemuuid.lib")
#include <windows.h>

//The windows messages we need.
#define DBJH_PROCESSSTARTED WM_USER +1
#define DBJH_PROCESSTERMINATED WM_USER +2

class ProcessMonitor: public IWbemObjectSink
{
    LONG m_lRef;
    bool bDone;
	HWND hNotificationWindow;

public:
	ProcessMonitor()
	{
		m_lRef = 0;
		hNotificationWindow = nullptr;
	}
	
	~ProcessMonitor() 
	{ 
		bDone = true; 
	}

    virtual ULONG STDMETHODCALLTYPE AddRef();
    virtual ULONG STDMETHODCALLTYPE Release();        
    virtual HRESULT 
        STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppv);

	virtual HRESULT STDMETHODCALLTYPE Indicate(
		LONG lObjectCount,
		IWbemClassObject __RPC_FAR *__RPC_FAR *apObjArray);
    virtual HRESULT STDMETHODCALLTYPE SetStatus( 
            /* [in] */ LONG lFlags,
            /* [in] */ HRESULT hResult,
            /* [in] */ BSTR strParam,
            /* [in] */ IWbemClassObject __RPC_FAR *pObjParam
            );

	void SetProcessNotificationWindow(HWND window);
};
#endif    // end of EventSink.h