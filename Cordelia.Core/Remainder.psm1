#Requires -Version 3
#Requires -Module Rounding
Set-StrictMode -Version Latest

<#
.SYNOPSIS
Returns the remainder resulting from the division of a specified number by another specified number.

.Description
This function returns the remainder resulting from the division of two IEEE 754 Floating Point numbers.
This function is an alternative to [Math]::IEEERemainder(...) .

.Parameter Dividend
The number that specifies a dividend.

.Parameter Divisor
The number that specified a divisor.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Notes
As stated on MSDN:
This operation complies with the remainder operation defined in Section 5.1 of ANSI/IEEE Std 754-1985;
IEEE Standard for Binary Floating-Point Arithmetic; Institute of Electrical and Electronics Engineers, Inc; 1985.
The IEEERemainder method is not the same as the modulus operator. Although both return the remainder after division, the formulas they use are different.
The formula for the IEEERemainder method is:
IEEERemainder = dividend - (divisor * Math.Round(dividend / divisor))
In contrast, the formula for the modulus operator is:
Modulus = (Math.Abs(dividend) - (Math.Abs(divisor) * (Math.Floor(Math.Abs(dividend) / Math.Abs(divisor))))) * Math.Sign(dividend)

This implementation differs from the official Microsoft method in that there is no distinction between -0 and +0.

.Link
https://msdn.microsoft.com/en-us/library/system.math.ieeeremainder(v=vs.110).aspx

.Example
Get-IEEERemainder 3 2
-1
#>
function Get-IEEERemainder
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Dividend,
        [Parameter(Mandatory = $true, Position = 1)]
        [Double]$Divisor
    )

    if($Divisor -eq 0.0)
    {
        return [Double]::NaN;
    }

    return $Dividend - ($Divisor * (Get-Rounded ($Dividend / $Divisor)));
}
