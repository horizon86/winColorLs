#ifdef UNICODE
    typedef wchar_t *LPTSTR;
    #define TEXT(quote) L##quote
#else
    typedef char *LPTSTR;
    #define TEXT(quote) quote
#endif

int run(const LPTSTR CMD);
