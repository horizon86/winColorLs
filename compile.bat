@echo off
set SRC=src
set BUILD=build\g++
set MSVC_BUILD=build\msvc
set MSVC_OBJ_DIR=build\msvc\obj\
MD %BUILD%
MD %MSVC_BUILD%
MD %MSVC_OBJ_DIR%

@REM 静态编译
g++ -Os -flto -s -DUNICODE -D_UNICODE -o %BUILD%/ls-static %SRC%/ls.cpp
g++ -Os -flto -s -DUNICODE -D_UNICODE -o %BUILD%/grep-static %SRC%/grep.cpp

@REM 编译动态库和程序
g++ -shared -Wl,--exclude-all-symbols -Wl,--out-implib,%BUILD%/libcolorls.a -Wl,--enable-auto-import -Os -flto -s -DUNICODE -D_UNICODE -o %BUILD%/libcolorls.dll %SRC%/libcolorls.cpp

g++ -L%BUILD% -lcolorls -Os -flto -s -DUNICODE -D_UNICODE -o %BUILD%/ls %BUILD%/libcolorls.dll %SRC%/share-ls.cpp
g++ -L%BUILD% -lcolorls -Os -flto -s -DUNICODE -D_UNICODE -o %BUILD%/grep %BUILD%/libcolorls.dll %SRC%/share-grep.cpp

@REM x64 Native Tools Command Prompt for VS 2022
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

@REM MSVC静态库
cl /MD /EHsc /nologo /O1 /GF /source-charset:utf-8 /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/ls-static.exe %SRC%/ls.cpp
cl /MD /EHsc /nologo /O1 /GF /source-charset:utf-8 /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/grep-static.exe %SRC%/grep.cpp

@REM MSVC动态库
cl /LD /MD /EHsc /nologo /O1 /GF /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/libcolorls /source-charset:utf-8 %SRC%/libcolorls.cpp
cl /MD /EHsc /nologo /O1 /GF /source-charset:utf-8 /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/ls.exe %SRC%/share-ls.cpp %MSVC_BUILD%/libcolorls.lib
cl /MD /EHsc /nologo /O1 /GF /source-charset:utf-8 /Fo: %MSVC_OBJ_DIR% /Fe: %MSVC_BUILD%/grep.exe %SRC%/share-grep.cpp %MSVC_BUILD%/libcolorls.lib

@REM 所以你不要把MSVC_OBJ_DIR设置的和MSVC_BUILD一样了
rmdir /S /Q %MSVC_OBJ_DIR%