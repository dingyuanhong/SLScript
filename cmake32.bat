set DIR=%~dp0/extra/cmake-3.9.1-win32-x86/
takeown /f %DIR% /r /d y
cacls %DIR%/. /T /C /G administrators:F users:F