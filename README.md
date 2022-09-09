# What's this?
On linux you can find
`alias ls=ls --color=auto`
in `~/.bashrc`.

But on windows, you can not do this elegantly.

So this wrapper automatically add the `--color=auto` parameter to ls, grep and other commands on Windows.

# Use

1. Download from [release](https://github.com/horizon86/winColorLs/releases/latest) and add to environment `PATH`.
2. Set environment variable `LSPATH` is the folder where the real ls.exe is located.

# Compile

There are 2 versions: static link and dynamic link.

See the [compile.bat](compile.bat) file for details.
