#Requires -Version 3
#Requires -Module SignNumbers
#Requires -Module Rounding
Set-StrictMode -Version Latest

<#
.SYNOPSIS
Returns the result of [Math]::E raised to the specified power.

.Description
This function returns the result of the natural number, e, raised to the specified power. This function is an alternative to [Math]::Exp(...) .

.Parameter Power
The number that specifies a power.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Notes
This function uses the Maclaurin Series to approximate e^x with x being -1 < x < 1.
For powers outside this range, the integral and fractional part of the power is stripped apart with the integral part performed seperately.

.Link
https://msdn.microsoft.com/en-us/library/system.math.exp(v=vs.110).aspx

.Example
Get-NaturalExponentiation 1
2.71828182845905
#>
function Get-NaturalExponentiation
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Power
    )

    if([Double]::IsNaN($Power) -or [Double]::IsPositiveInfinity($Power))
    {
        return $Power;
    }
    elseif([Double]::IsNegativeInfinity($Power) -or ($Power -le -745.0))
    {
        # Any power less than this value gives results smaller (in significance) than
        # [double]::Epsilon which means the system will only interpret it as 0 anyways.
        return 0.0;
    }
    elseif($Power -gt 709.782712893384)
    {
        # The problem with values bigger than 709.782712893384 is that it exceed the
        # range of double precision.
        return [Double]::PositiveInfinity;
    }

    [Double]$integralPart = (Get-AbsoluteValue (Get-Truncated $Power));
    [Double]$fractionalResult = (Get-ExpTiny ($Power - $integralPart));    # The fractional part of x is handled seperately.
    [Double]$integralResult = 1.0;
    [Double]$EConst = [Math]::E;

    while($integralPart -gt 0.0)
    {
        $integralResult = $integralResult * $EConst;
        $integralPart = $integralPart - 1.0;
    }

    if($Power -lt 0.0)
    {
        return $fractionalResult / $integralResult;
    }
    else
    {
        return $integralResult * $fractionalResult;
    }
}

<#
.SYNOPSIS
Returns the result of a specified number (base) raised to the specified power.

.Description
This function returns the power of a specified number such that (Base)^(Power). This function is an alternative to [Math]::Pow(...) .

.Parameter Base
The number to be raised to a power.

.Parameter Power
The number that specifies a power.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
https://msdn.microsoft.com/en-us/library/system.math.pow(v=vs.110).aspx

.Example
Get-GeneralExponentiation 2 2
4
#>
function Get-GeneralExponentiation
{
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [Double]$Power,
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Base
    )

    [Double]$integralPart = (Get-Truncated $Power);

    if([Double]::IsNaN($Base) -or [Double]::IsNaN($Power))
    {
        return [Double]::NaN;
    }
    elseif($Power -eq 0.0)
    {
        return 1.0;
    }
    elseif([Double]::IsNegativeInfinity($Base))
    {
        [Double]$temp = 2.0 * (Get-Truncated ($integralPart / 2.0));    # Should match the integral part of the power if the integral part is an even integer
        if($Power -lt 0.0)
        {
            return 0.0;
        }
        elseif(($Power -eq $integralPart) -and ($Power -gt 0.0))
        {
            # Positive integer
            if($temp -ne $integralPart)
            {
                # Odd int.
                return [Double]::NegativeInfinity;
            }
            else
            {
                return [Double]::PositiveInfinity;
            }
        }
    }
    elseif($Base -lt 0.0)
    {
        if(($Power -ne $integralPart) -and (-not [Double]::IsInfinity($Power))) # Not an integer, nor infinities
        {
            # Cannot handle complex nums., so its going to be NaN
            return [Double]::NaN;
        }
    }
    elseif($Base -eq 0.0)
    {
        if($Power -gt 0.0)
        {
            return 0.0;
        }
        else
        {
            # Remember all cases of power of 0 is resolved in the second (major) case above, so this is only for Power < 0
            # While "x/0" is indeterminate, the definition lim(x/y,y->0) is valid, thus the return is based on the limit definition.
            return [Double]::PositiveInfinity;
        }
    }
    elseif((Get-AbsoluteValue $Base) -lt 1.0)
    {
        if([Double]::IsPositiveInfinity($Power))
        {
            return 0.0;
        }
        else
        {
            return [Double]::PositiveInfinity;
        }
    }
    elseif((Get-AbsoluteValue $Base) -gt 1.0)
    {
        if([Double]::IsPositiveInfinity($Power))
        {
            return [Double]::PositiveInfinity;
        }
        else
        {
            return 0.0;
        }
    }
    elseif($Base -eq 1.0)
    {
        return 1.0;
    }
    elseif([Double]::IsPositiveInfinity($Base))
    {
        if($Power -lt 0.0)
        {
            return 0.0;
        }
        else
        {
            return [Double]::PositiveInfinity;
        }
    }

    [Double]$fractionalPart = $Power - $integralPart;
    $integralPart = (Get-AbsoluteValue $integralPart);
    [Double]$integralResult = 1.0;

    # loop through and multiply by Base.
    while($integralPart -gt 0.0)
    {
        $integralResult = $integralResult * $Base;
        $integralPart = $integralPart - 1.0;
    }

    if($Power -lt 0.0)
    {
        $integralResult = 1.0 / $integralResult;
    }

    return $integralResult * (Get-NaturalExponentiation ($fractionalPart * (Get-NaturalLogarithm ($Base))));
}

<#
.SYNOPSIS
Returns the natural (base E) logarithm of a specified number.

.Description
This function returns the logarithm of a specified number in Base [Math]::E. This function is an alternative to [Math]::Log(...) .

.Parameter Value
The number whose logarithm is to be found.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
http://mathworld.wolfram.com/Logarithm.html

.Example
Get-Logarithm ([Math]::E)
1
#>
function Get-NaturalLogarithm
{
    param(
        [parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if($Value -eq 0.0)
    {
        return [Double]::NegativeInfinity;
    }
    elseif([Double]::IsPositiveInfinity($Value))
    {
        return [Double]::PositiveInfinity;
    }
    elseif($Value -lt 0.0 -or [Double]::IsNegativeInfinity($Value) -or [Double]::IsNaN($Value))
    {
        return [Double]::NaN;
    }

    # ln(x) = ln((1-y)/(1+y)) = 2*(y + y^3/3 + ...)

    [Double]$adjustedValue = $Value;
    [Double]$exponent = 0.0;

    # adjustedValue must be in [1, 10)
    if($adjustedValue -ge 10.0)
    {
        do
        {
            $adjustedValue = $adjustedValue / 10.0;
            $exponent = $exponent + 1.0;
        }
        while($adjustedValue -ge 10.0)
    }
    elseif($adjustedValue -lt 1.0)
    {
        do
        {
            $adjustedValue = $adjustedValue * 10.0;
            $exponent = $exponent - 1.0;
        }
        while($adjustedValue -lt 1.0)
    }

    [Double]$rate = ($adjustedValue - 1.0) / ($adjustedValue + 1.0);    # y = (x - 1) / (x + 1)
    [Double]$rate2 = $rate;                                                 # represents the term y^(2i+1) for 0 <= i <= 100
    [Double]$result = 0.0;              # The approx. answer
    [Double]$i = 0.0;

    for(; $i -le 100.0; ++$i)
    {
        $result = $result + $rate2 / ($i * 2.0 + 1.0);          # (1 / (2i + 1)) * y^(2i+1)
        $rate2 = $rate2 * $rate * $rate;                        # y^(2*(i+1)+1) = y^(2i+1) * y^2
    }

    $result = $result + $rate2 / ($i * 2.0 + 1.0);              # the 101-th term, since the values were left from the buffer.

    return (2.0 * $result) + $exponent * 2.3025850929940456840179914546844;             # Equivalent to ln(x / 10^n) + n*ln(10)
}

<#
.SYNOPSIS
Returns the logarithm of a specified number in a specified base.

.Description
This function returns the logarithm of a specified number in a particular base, that may be specified by the caller,
but by default, the base of the logarithm is Base-10. This function is an alternative to [Math]::Log(... , ...) and [Math]::Log10(...) .

.Parameter Value
The number whose logarithm is to be found.

.Parameter Base
The base of the logarithm.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
http://mathworld.wolfram.com/Logarithm.html

.Example
Get-Logarithm 10
1

.Example
Get-Logarithm 2 2
1
#>
function Get-GeneralLogarithm
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value,
        [Parameter(Mandatory = $false, Position = 1)]
        [Double]$Base = 10.0
    )

    if(($Base -lt 0.0) -or ($Base -eq 1.0) -or ([Double]::IsNaN($Base)) -or ($Value -lt 0.0) -or [Double]::IsNaN($Value))
    {
        return [Double]::NaN;
    }
    elseif($Value -ne 1.0 -and ($Base -eq 0.0 -or [Double]::IsPositiveInfinity($Base)))
    {
        return [Double]::NaN;
    }
    elseif($Value -eq 0.0)
    {
        if($Base -gt 1.0)
        {
            return [Double]::NegativeInfinity;
        }
        elseif(($Base -lt 1.0) -and ($Base -gt 0.0))
        {
            return [Double]::PositiveInfinity;
        }
    }
    elseif([Double]::IsPositiveInfinity($Value))
    {
        if($Base -gt 1.0)
        {
            return [Double]::PositiveInfinity;
        }
        elseif(($Base -lt 1.0) -and ($Base -gt 0.0))
        {
            return [Double]::NegativeInfinity;
        }
    }
    elseif($Value -eq 1.0 -and ($Base -eq 0.0 -or [Double]::IsPositiveInfinity($Base)))
    {
        return 0.0;
    }

    if($Base -eq 10.0)
    {
        # Quickly spit out the result for Base-10
        return (Get-NaturalLogarithm $Value) / 2.3025850929940456840179914546844;
    }
    elseif($Base -eq 2.0)
    {
        # Quickly spit out the result for Base-2
        return (Get-NaturalLogarithm $Value) / 0.69314718055994530941723212145818;
    }
    elseif($Base -eq 8.0)
    {
        # Quickly spit out the result for Base-8
        return (Get-NaturalLogarithm $Value) / 2.0794415416798359282516963643745;
    }
    elseif($Base -eq 16.0)
    {
        # Quickly spit out the result for Base-16;
        return (Get-NaturalLogarithm $Value) / 2.7725887222397812376689284858327;
    }
    else
    {
        # return the logarithm with uncommon bases
        return (Get-NaturalLogarithm $Value) / (Get-NaturalLogarithm $Base);
    }
}

<#
.SYNOPSIS
Returns the square root of a specified number.

.Description
This function returns the square root of a number and provides an easy call for square root. This function is an alternative to [Math]::Sqrt(...) .

.Parameter Value
The number that needs to be square-rooted.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Notes
Unlike the typical approach of using exp(.5 * ln(x)), this function will be less expensive in terms of floating-point operations.
However, the typical approach is used for 0 <= x <= 0.25.

.Link
http://mathworld.wolfram.com/SquareRoot.html

.Example
Get-SquareRoot 25
5
#>
function Get-SquareRoot
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if([Double]::IsNaN($Value) -or [Double]::IsNegativeInfinity($Value) -or ($Value -lt 0.0))
    {
        return [Double]::NaN;
    }
    elseif([Double]::IsPositiveInfinity($Value))
    {
        return [Double]::PositiveInfinity;
    }
    elseif($Value -eq 0.0)
    {
        return 0.0;
    }

    [Double]$result = 0.0;    # The approx. answer
    [Int]$iterations = 0;     # If the loop exceeds 400, the value is assumed to be approximated;

    if($Value -le 0.25)
    {
        # Using Householder's methods (i.e. Newton's method and Halley's method) for sqrt fails to converge properly near 0.0;
# Thus, the logarithm is used.
return (Get-NaturalExponentiation (0.5 * (Get-NaturalLogarithm $Value)));
}
elseif($Value -le 0.542)
{
    # Initial guess, good below 0.542
    $result = 0.0;
}
elseif($Value -le 30.15)
{
    # Initial guess, good below 30.15
    # The following inital guess is great for 3 <= x <= 5
    $result = (Get-NaturalLogarithm $Value) + 0.6125;
}
elseif($Value -lt 2000.0)
{
    # Initial guess, good below 2000
    $result = [Math]::PI * 5.25 - (1000 / ($Value + 50));
}
else
{
    $result = (Get-RootApproximation $Value -Scale 2);
}

[Double]$previous = 0.0;        # The previous result, if previous == result, then exit.
[Double]$resultSquared = 0.0;   # Equivalent to (result * result)

# Using Householder's methods (i.e. Newton's method and Halley's method) for sqrt with a counter to prevent infinite loops.
        do
        {
            $previous = $result;
            $resultSquared = $result * $result;
            $result = $result * ($resultSquared + 3.0 * $Value) / (3.0 * $resultSquared + $Value);
        }
        while(($previous -ne $result) -and (($iterations++) -lt 400))

        return $result;
    }

    <#
    .SYNOPSIS
    Returns the cube root of a specified number.

    .Description
    This function returns the cube root of a number and provides an easy call for cube root.

    .Parameter Value
    The number that needs to be cube-rooted.

    .Inputs
    [System.Double]

    .Outputs
    [System.Double]

    .Notes
    Unlike the typical approach of using exp(1/3 * ln(x)), this function will be less expensive in terms of floating-point operations.
    However, the typical approach is used for 0 <= x <= 0.25.

    .Link
    http://mathworld.wolfram.com/CubeRoot.html

    .Example
    Get-CubeRoot 27
    3
    #>
    function Get-CubeRoot
    {
        param(
            [Parameter(Mandatory = $true, Position = 0)]
            [Double]$Value
        )

        if([Double]::IsNaN($Value))
        {
            return [Double]::NaN;
        }
        elseif([Double]::IsInfinity($Value))
        {
            return $Value;
        }
        elseif($Value -eq 0.0)
        {
            return 0.0;
        }

        [Double]$abs = (Get-AbsoluteValue $Value);
        [Int]$iterations = 0;       # If counter value exceed 400, then exit.

        [Double]$result = 0.0;      # The approx. answer

        if($abs -le 0.25)
        {
            # Using Householder's methods (i.e. Newton's method and Halley's method) for cube root fails to converge properly near 0.0;
# Thus, the logarithm is used.
return (Get-NaturalExponentiation ((Get-NaturalLogarithm $Value) / 3.0));
}
elseif($abs -le 5.0)
{
    # Initial guess, good below 5.0
    $result = 1.0;
}
elseif($abs -lt 50000.0)
{
    # Initial guess, good below 50000.0
    $result = (Get-NaturalLogarithm $abs) - 0.5;
}
else
{
    $result = (Get-RootApproximation $abs -Scale 3);
}

[Double]$previous = 0.0;            # The previous result, if previous == result, then exit.
[Double]$tripleResult = 0.0;

do
{
    $previous = $result;
    $resultCubed = $result * $result * $result;
    $result = $result * ($resultCubed + 2.0 * $abs) / (2.0 * $resultCubed + $abs);
}
while(($previous -ne $result) -and (($iterations++) -lt 400))

return (Get-Sign $Value) * $result;
}


############################### Helper Functions - Will not be exposed ############################################

###################################################################################################################
#
#    Tiny exp(x). This is a standard exp(x) function that finds exp(x), -1 < x < 1, quickly.
#
###################################################################################################################
function Get-ExpTiny
{
    param(
        [Parameter(Mandatory = $true)]
        [Double]$Value
    )

    # The function will check if x is 0.0, which will easily produce the value of 1.
    if($Value -eq 0.0)
    {
        return 1.0;
    }

    [Double]$rate = $Value * $Value / 2.0;      # The "second" term of the Maclauren series expansion.
    [Double]$result = 1.0 + $Value;                 # The "zeroth" and "first" terms.

    # Lagrange Remainder shows that n = 177 seems to give error bounds smaller than [Double]::Epsilion,
    # the value in IEEE that is the smallest in significance before the system reads it as zero.
    for([Double]$i = 3.0; $i -le 177.0; ++$i)
    {
        $result = $result + $rate;
        $rate = $rate * $Value / $i;        # The i-th term of the Maclauren series expansion.
    }

    return $result + $rate;
}


###################################################################################################################
#
#    Counts the number of digits to the left of the decimal place; returns as int.
#
###################################################################################################################
function Get-DigitCount
{
    param(
        [Parameter(Mandatory = $true)]
        [Double]$Value
    )

    # Assume Value is a valid real number
    [Int]$result = 0;
    while($Value -ge 1.0)
    {
        $result = $result + 1;
        $Value = $Value / 10.0;
    }

    return $result;
}


###################################################################################################################
#
#    Returns a number with 1/Scale as many digits (to the left of the decimal place) for inital guess of root func.
#
###################################################################################################################
function Get-RootApproximation
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value,
        [Parameter(Mandatory = $true, Position = 1)]
        [Int]$Scale
    )

    [Int]$scaleDigits = (Get-DigitCount $Value) / $Scale;
    [Double]$result = 1.0;
    while(($scaleDigits--) -gt 1)
    {
        $result = $result * 10.0;
    }

    return $result;
}
