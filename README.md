# Cordelia - A simple math library for PowerShell

## Background
Powershell is available on almost all platforms of Windows (i.e. Windows RT, Windows 7/8/10, etc.), but there are restrictions on some devices that will not allow certain function calls due to language modes.

## What about the static Math class?
Since PowerShell runs off of the .NET framework, PowerShell can take advantage of the static `[System.Math]` class from C#.
However, there is a caveat, `LANGUAGE MODES` in PowerShell can limit what can be performed in the shell, which dictates how certain method calls can be made.

Try running the following in `CONSTRINED LANGUAGE` mode on PowerShell (i.e. Surface RT):
```PowerShell
C:\> [Math]::Sin(90)
```
The fancy error message reports that "methods" cannot be called in this environment.

Powershell makes a distinction between a method and a function:
* Functions are loose bodied statements like in C.
* Methods are bodied statements like functions, but *methods belong to classes*.

## The Fix
Well, there looks to be no way to go around `RESTRICTED LANGUAGE`, but `CONSTRAINED LANGUAGE` mode can be "fixed".
By utilizing only functions (without classes) for methods like `sin`, `cos`, `tan`, etc., PowerShell will allow complex math functions to be run on `CONSTRAINED LANGUAGE` mode. 

## Additional Note
Since this is written in the PowerShell native language, features like `piping` could be supported in the future.
