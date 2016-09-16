#Requires -Version 3
#Requires -Module SignNumbers
Set-StrictMode -Version Latest

<#
    .SYNOPSIS
        Returns the largest integer less than or equal to the specified number.

    .Description
        This function returns the largest integer less than or equal to the specified double-precision floating-point number.
        This function is an alternative to [Math]::Floor(...) .

    .Parameter Value
        The number that needs to be rounded towards negative infinity.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Notes
        This kind of rounding is sometimes called rounding toward negative infinity.

    .Link
        https://msdn.microsoft.com/en-us/library/e0b5f0xb(v=vs.110).aspx

    .Example
        Get-Floor 1.234567890
        1
#>
function Get-Floor
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if([Double]::IsNaN($Value) -or [Double]::IsInfinity($Value))
    {
        return $Value;
    }

    [Double]$val = (Get-Truncated $Value)

    # Equal to truncate when Value is positive;
    # Same for negative, but if has fractional part return one less

    if($Value -ne $val -and ($Value -lt 0.0))
    {
        return $val - 1.0;
    }

    return $val;
}


<#
    .SYNOPSIS
        Returns the largest integer greater than or equal to the specified number.

    .Description
        This function returns the largest integer greater than or equal to the specified double-precision floating-point number.
        This function is an alternative to [Math]::Ceiling(...) .

    .Parameter Value
        The number that needs to be rounded towards positive infinity.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Notes
        This kind of rounding is sometimes called rounding toward positive infinity.

    .Link
        https://msdn.microsoft.com/en-us/library/zx4t0t48(v=vs.110).aspx

    .Example
        Get-Ceiling 1.234567890
        2
#>
function Get-Ceiling
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if([Double]::IsNaN($Value) -or [Double]::IsInfinity($Value))
    {
        return $Value;
    }

    [Double]$val = (Get-Truncated $Value);

    # Equal to truncate when Value is negative;
    # Same for positives, but if fractional part return one more
    if($Value -ne $val -and ($Value -gt 0.0))
    {
        return $val + 1.0;
    }
    return $val;
}


<#
    .SYNOPSIS
        Calculates the integral part of a number.

    .Description
        This function calculates the integral part of a specified double-precision floating-point number.
        This function is an alternative to [Math]::Truncate(...) .

    .Parameter Value
        The number that needs to be truncated.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Link
        https://msdn.microsoft.com/en-us/library/c2eabd70(v=vs.110).aspx

    .Example
        Get-Truncated 1.234567890
        1
#>
function Get-Truncated
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if([Double]::IsNaN($Value) -or [Double]::IsInfinity($Value))
    {
        return $Value;
    }

    [Double]$val = Get-AbsoluteValue $Value;
    [Double]$trunc = 1D;

    for(;$val -gt 1.0; $val = $val / 2.0)
    {
        $trunc = $trunc * 2.0;
    }

    if($Value -lt 0.0)
    {
        $trunc = $trunc * -1.0;

        while($trunc -lt $Value)
        {
            $trunc = $trunc + 1.0;
        }
    }
    else
    {
        while($trunc -gt $Value)
        {
            $trunc = $trunc - 1.0;
        }
    }

    return $trunc;
}

<#
    .SYNOPSIS
        Rounds a double-precision floating-point value to the nearest number.

    .Description
        This function rounds the value of a specified double-precision floating-point number towards a specified number of digits along
        with specifying the behavior of rounding at the midpoint of two integers.
        This function is an alternative to [Math]::Round([Double],[Int],[MidpointRounding]) .

    .Parameter Value
        A number that is greater than or equal to [Double]::MinValue, but less than or equal to [Double]::MaxValue.

    .Parameter Digits
        Specifies the number of decimal places or digits after the decimal point.

    .Parameter Mode
        Specifies the behavior that is used to break a tie when Value is half way between two integers.

    .Inputs
        [System.Double] with accept additionally [System.Int] and [System.MidpointRounding]

    .Outputs
        [System.Double]

    .Notes
        Due to internally multiplying Value with 10^Digits, values like 2.135 will round to 2.13 rather than 2.14 due to loss of precision just like [Math]::Round(...). See Example 4.

    .Link
        https://msdn.microsoft.com/en-us/library/f5898377(v=vs.110).aspx

    .Example
        Get-Rounded 11.5
        12.0

    .Example
        Get-Rounded 12.12345 -Digits 3
        12.123

    .Example
        Get-Rounded 12.5 -Mode AwayFromZero
        13

    .Example
        Get-Rounded 2.135 -Digits 2
        2.13

    .Example
        Get-Rounded 12.12345 -Digits 4 -Mode AwayFromZero
        12.1235
#>
function Get-Rounded
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value,
        [Parameter(Mandatory = $false, Position = 1)]
        [Int]$Digits = 0,
        [Parameter(Mandatory = $false, Position = 2)]
        [System.MidpointRounding]$Mode = [System.MidpointRounding]::ToEven
    )

    if([Double]::IsNaN($Value) -or [Double]::IsInfinity($Value))
    {
        return $Value;
    }

    if($Digits -lt 0 -or $Digits -gt 15)
    {
        throw "Digits cannot be less than 0 or greater than 15";
    }

    [Double]$Scale = 1.0;

    while($Digits -gt 0.0)
    {
        $Scale = $Scale * 10.0;
        --$Digits;
    }

    [Double]$Value2 = $Value * $Scale;

    # The integral part of Value
    [Double]$val = (Get-Truncated $Value2)

    # The fractional part of Value
    [Double]$diff = Get-AbsoluteValue ($Value2 - $val);

    switch($Mode)
    {
        ([System.MidpointRounding]::AwayFromZero) {
            # 0 <= diff < 0.5, return trunc(value)
            # 0.5 <= diff < 1, return sgn(value) * (1 + abs(trunc($Value)))

            if($diff -lt 0.5)
            {
                return $val / $Scale;
            }
            else
            {
                return (Get-Sign $val) * (1.0 + (Get-AbsoluteValue $val)) / $Scale;
            }
        }

        ([System.MidpointRounding]::ToEven) {
            # 0 <= diff < 0.5, return trunc(value)
            # 0.5 < diff < 1, return sgn(value) * (1 + abs(trunc($Value)))
            # diff == 0.5, closest even

            if($diff -lt 0.5)
            {
                return $val / $Scale;
            }
            elseif($diff -gt 0.5)
            {
                return (Get-Sign $val) * (1.0 + (Get-AbsoluteValue $val)) / $Scale;
            }
            else # diff == 0.5
            {
                # Division by two to check for even numbers
                # If diff2 is not 0, then val is odd
                [Double]$diff2 = $val / 2.0 - (Get-Truncated ($val / 2.0));
                if($diff2 -ne 0.0)
                {
                    # not even
                    return ((Get-Sign $Value) * 0.5 + $Value) / $Scale;
                }
                else
                {
                    # even number
                    return $val / $Scale;
                }
            }
        }
    }
}
