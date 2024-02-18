@echo off
setlocal
set SRC=src
set GCC_BUILD=build\g++
set MSVC_BUILD=build\msvc
set MSVC_OBJ_DIR=build\msvc\obj\
MD %GCC_BUILD%\shared
MD %GCC_BUILD%\static
MD %MSVC_BUILD%\shared
MD %MSVC_BUILD%\static
MD %MSVC_OBJ_DIR%

@REM 静态编译
g++ -Os -flto -s -DUNICODE -D_UNICODE -o %GCC_BUILD%/static/ls %SRC%/ls.cpp
g++ -Os -flto -s -DUNICODE -D_UNICODE -o %GCC_BUILD%/static/grep %SRC%/grep.cpp

@REM 编译动态库和程序
g++ -shared -Wl,--exclude-all-symbols -Wl,--out-implib,%GCC_BUILD%/shared/libcolorls.a -Wl,--enable-auto-import -Os -flto -s -DUNICODE -D_UNICODE -o %GCC_BUILD%/shared/libcolorls.dll %SRC%/libcolorls.cpp

g++ -L%GCC_BUILD%/shared -lcolorls -Os -flto -s -DUNICODE -D_UNICODE -o %GCC_BUILD%/shared/ls %GCC_BUILD%/shared/libcolorls.dll %SRC%/share-ls.cpp
g++ -L%GCC_BUILD%/shared -lcolorls -Os -flto -s -DUNICODE -D_UNICODE -o %GCC_BUILD%/shared/grep %GCC_BUILD%/shared/libcolorls.dll %SRC%/share-grep.cpp

@REM x64 Native Tools Command Prompt for VS 2022
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

@REM MSVC静态库
cl /MD /EHsc /nologo /O1 /GF /source-charset:utf-8 /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/static/ls.exe %SRC%/ls.cpp
cl /MD /EHsc /nologo /O1 /GF /source-charset:utf-8 /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/static/grep.exe %SRC%/grep.cpp

@REM MSVC动态库
cl /LD /MD /EHsc /nologo /O1 /GF /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/shared/libcolorls /source-charset:utf-8 %SRC%/libcolorls.cpp
cl /MD /EHsc /nologo /O1 /GF /source-charset:utf-8 /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/shared/ls.exe %SRC%/share-ls.cpp %MSVC_BUILD%/shared/libcolorls.lib
cl /MD /EHsc /nologo /O1 /GF /source-charset:utf-8 /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/shared/grep.exe %SRC%/share-grep.cpp %MSVC_BUILD%/shared/libcolorls.lib

@REM 所以你不要把MSVC_OBJ_DIR设置的和MSVC_BUILD一样了
rmdir /S /Q %MSVC_OBJ_DIR%
del %MSVC_BUILD%\shared\*.lib %MSVC_BUILD%\shared\*.exp
del %GCC_BUILD%\shared\*.a
endlocal