#Requires -Version 3
#Requires -Module Cordelia.Core
Set-StrictMode -Version Latest

# To save on the factorial usage, factorials of 3 <= n <= 170 are saved to a text file to reduce factorial usage.
# Below is a table for accessing the saved factorial table.
[String[]]$FactorialTable = (Get-Content "$PSScriptRoot\FactorialTable.txt");

<#
.SYNOPSIS
Returns the factorial of a specified value.

.Description
Returns the n-th factorial where n is the value passed into the function.

.Parameter Alpha
Specifies the value to be used to find the factorial.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
http://mathworld.wolfram.com/Factorial.html

.Example
Get-Factorial 1
1
#>
function Get-Factorial
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Alpha
    )

    # Sadly, the largest factorial to fit in a double is 170! = 7.2574156153079989673967282111293e+306.
    # Values larger will result in infinity.

    # There is much better performance to cache the factorial, so the function
    # will just access a file rather than purely calculate the factorial of a number.

    if($Alpha -lt 0.0 -or [Double]::IsNegativeInfinity($Alpha))
    {
        return [Double]::NaN;
    }
    elseif([Double]::IsPositiveInfinity($Alpha) -or ($Alpha -gt 170.0))
    {
        return [Double]::PositiveInfinity;
    }

    # Integers pass this point
    [Double]$val = (Get-Truncated $Alpha);

    [Double]$result = 1.0;

    if($val -le 2.0)
    {
        return (Get-Maximum $val 1.0)
    }
    else
    {
        return [Double]::Parse($FactorialTable[$val - 3]);
    }
}
