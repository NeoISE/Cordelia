# Cordelia - A simple math library for PowerShell

## Background
PowerShell is a powerful scripting (and programming) environment for many popular OSes, but there are restrictions on some devices that prevent the use of some features like the use of .NET **classes** and **methods**.
will not allow certain function calls due to language modes.

## What about the static Math class?
Since PowerShell runs off of the .NET framework, PowerShell can take advantage of the static `[System.Math]` class from C#.
However, there is a caveat, `LANGUAGE MODES` in PowerShell can limit what can be performed in the shell, which dictates how certain method calls can be made.

Try running the following in `CONSTRINED LANGUAGE` mode on PowerShell:
```PowerShell
C:\> [Math]::Sin(90)
```
The fancy error message reports that *methods* cannot be called in this environment.

PowerShell makes a distinction between a method and a function:
* Functions are loose bodied statements like in C.
* Methods are bodied statements like functions, but *methods belong to classes*. In the case above, *Sin* is a method of *System.Math*.

## The Fix
Well, there looks to be no way to go around `RESTRICTED LANGUAGE`, but `CONSTRAINED LANGUAGE` mode can be *fixed*.
By utilizing only *functions* (not *methods*) for mathematical commands (like `sin`, `cos`, `tan`, etc.) and using *classes* from the .NET framework that is known to work in `CONSTRAINED LANGUAGE` mode, we can perform complex math calculations in PowerShell without errors.

## Additional Note
Since this is written in the PowerShell native language, features like `pipelining` could be supported in the future.
