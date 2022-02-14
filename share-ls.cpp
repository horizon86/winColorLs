#include "libcolorls.h"
#define CMD TEXT("\\ls.exe")

int main(int argc, char *argv[])
{
    return run((LPTSTR)CMD);
}
