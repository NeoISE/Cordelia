#Requires -Version 3
Set-StrictMode -Version Latest

<#
    .SYNOPSIS
        Returns the absolute value of a specified number.

    .Description
        This function returns the absolute value of a specified double-precision floating-point number.
        This function is an alternative to [Math]::Abs(...) .

    .Parameter Value
        A number that is greater than or equal to [Double]::MinValue, but less than or equal to [Double]::MaxValue.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Link
        https://msdn.microsoft.com/en-us/library/f2yzeea2(v=vs.110).aspx

    .Example
        Get-AbsoluteValue -1.234567890
        1.23456789
#>
function Get-AbsoluteValue
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if([Double]::IsNaN($Value))
    {
		# if NaN, then NaN is returned
        return $Value;
    }
    elseif([Double]::IsInfinity($Value))
    {
        return [Double]::PositiveInfinity;
    }
    else
    {
        return (Get-Sign $Value) * $Value;
    }
}

<#
    .SYNOPSIS
        Returns an integer that indicates the sign of a specified number.

    .Description
        This function returns an integer that indicates the sign of a specified double-precision floating-point number.
        This function is an alternative to [Math]::Sign(...) .

    .Parameter Value
        A number that is signed.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Notes
        Unlike the Microsoft method, Get-Sign will be of return-type [System.Double] not [System.Int].
        Thus, when [Double]::NaN is provided to the cmdlet, the return value will also be [Double]::NaN.

    .Link
        https://msdn.microsoft.com/en-us/library/ywb0xks3(v=vs.110).aspx

    .Example
        Get-Sign -123
        -1
#>
function Get-Sign
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if([Double]::IsNaN($Value))
    {
		# if NaN, then NaN is returned.
        return $Value;
    }

    if($Value -lt 0.0)
    {
        return -1.0;
    }
    elseif($Value -gt 0.0)
    {
        return 1.0;
    }
    else
    {
        # equal to 0
        return 0.0;
    }
}
