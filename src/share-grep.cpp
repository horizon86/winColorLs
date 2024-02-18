#include "libcolorls.h"
#define CMD TEXT("\\grep.exe")

int main(int argc, char *argv[])
{
    return run((LPTSTR)CMD);
}