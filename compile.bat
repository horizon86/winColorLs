@REM 静态编译
g++ -Os -flto -s -DUNICODE -D_UNICODE -o ls-static ls.cpp 

@REM 编译动态库和程序
g++ -shared -Wl,--exclude-all-symbols -Wl,--out-implib,libcolorls.a -Wl,--enable-auto-import -Os -flto -s -DUNICODE -D_UNICODE -o libcolorls.dll libcolorls.cpp

g++ -L. -lcolorls -Os -flto -s -DUNICODE -D_UNICODE -o ls libcolorls.dll share-ls.cpp
g++ -L. -lcolorls -Os -flto -s -DUNICODE -D_UNICODE -o grep libcolorls.dll share-grep.cpp
