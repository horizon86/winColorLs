#include <windows.h>
#include <tchar.h>
#include <strsafe.h>
#include <locale>

#define BUF_SIZE 300
#define CMD TEXT("\\grep.exe")

const TCHAR err[] = TEXT("请设置 LSPATH\n");
LPTSTR getCmdlineAgr1(const LPTSTR cmdLine);


int main(int argc, char *argv[])
{
    TCHAR cmd[ BUF_SIZE];
    DWORD dwFlags=0;
    BOOL fSuccess;
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    DWORD exitCode;
    setlocale(LC_ALL, "");

    if(!GetEnvironmentVariable(TEXT("LSPATH"), cmd, BUF_SIZE - 10))
    {
        // WriteConsole(GetStdHandle(STD_ERROR_HANDLE), err, _tcslen(err), nullptr,nullptr);
        _ftprintf(stderr, err);
        return 3;
    }
    // D:\MyTools\PortableGit-2.30.0.2-64-bit.7z\usr\bin
    // 
    StringCchCat(cmd, BUF_SIZE, CMD);
    // D:\MyTools\PortableGit-2.30.0.2-64-bit.7z\usr\bin\ls.exe
    
    const LPTSTR cmdLine = GetCommandLine();
    // _ftprintf(stderr, TEXT("原始cmdLine:\n"));
    // _ftprintf(stderr, cmdLine);
    // printf("\n");
    // ls-static.exe   ls.cpp

    // ""
    size_t argsLen = _tcslen(cmdLine) + _tcslen(TEXT("--color=auto")) + 10;
    LPTSTR newCmdLine = new TCHAR[argsLen];
    StringCchCopy(newCmdLine, argsLen, cmdLine);
    // ls-static.exe   ls.cpp
    StringCchCat(newCmdLine, argsLen, TEXT(" --color=auto"));
    // _ftprintf(stderr, TEXT("手动加了 --color=auto\n"));
    // _ftprintf(stderr, newCmdLine);
    // printf("\n");
    // ls-static.exe  ls.cpp --color=auto
    LPTSTR arg1Pos = getCmdlineAgr1(newCmdLine);
    // _ftprintf(stderr, TEXT("手动获取第一个参数的位置，准备给cmd:\n"));
    // _ftprintf(stderr, arg1Pos);
    // printf("\n");
    *--arg1Pos = TEXT(' ');

    StringCchCat(cmd, BUF_SIZE, arg1Pos);
    // _ftprintf(stderr, cmd);

    SecureZeroMemory(&si, sizeof(STARTUPINFO));
    si.cb = sizeof(STARTUPINFO);    
#ifdef UNICODE
    dwFlags = CREATE_UNICODE_ENVIRONMENT;
#endif


    // _tprintf(TEXT("cmd %s\n"),cmd);
    // _tprintf(TEXT("args %s\n"),arg1Pos);
    
    fSuccess = CreateProcess(
        nullptr,
        cmd,
        nullptr,
        nullptr,
        TRUE,
        dwFlags,
        nullptr,
        nullptr,
        &si,
        &pi);
    if (! fSuccess)
    {
        DWORD errCode = GetLastError();
        LPTSTR errBuf=nullptr;
        FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | 
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        errCode,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        errBuf,
        0,NULL
        );
        _ftprintf(stderr, TEXT("创建进程失败 (%d): %s\n"), errCode, errBuf);
        LocalFree(errBuf);
        exitCode = 4;
        goto EXIT;
    }

    WaitForSingleObject(pi.hProcess, INFINITE);
    GetExitCodeProcess(pi.hProcess, &exitCode);

EXIT:
    delete newCmdLine;
    return exitCode;
}
// "C:\.   ..\ls.exe"  
LPTSTR getCmdlineAgr1(const LPTSTR cmdLine)
{
    bool findDelim = false;
    LPTSTR delim = (LPTSTR)TEXT(R"( ")");
    // 如果开头是引号，delimId就是1，不然就是0
    size_t delimId = *cmdLine == delim[1];
    LPTSTR p = cmdLine + 1, end = cmdLine + _tcslen(cmdLine);
    // 找到第一个delim
    for(;p < end && *p != delim[delimId]; p++);

    if(p == end) return nullptr;
    
    for(p++;p < end && *p == delim[0];p++);

    if(p == end) return nullptr;
    return p;
}