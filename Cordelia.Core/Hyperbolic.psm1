#Requires -Version 3
#Requires -Module Powers
Set-StrictMode -Version Latest

<#
.SYNOPSIS
Returns the inverse hyperbolic cosine of a specified number.

.Description
This function returns the inverse hyperbolic cosine of a specified number as double-precision floating-point number.
The value returned is a hyperbolic angle where the hyperbolic cosine of this value will be the number specified by the user.

.Parameter Value
A number that represents a hyperbolic cosine that will be used to find the corresponding hyperbolic angle.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
http://mathworld.wolfram.com/InverseHyperbolicCosine.html

.Example
Get-AreaHyperbolicCosine 5
2.29243166956118
#>
function Get-AreaHyperbolicCosine
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if(([Double]::IsNaN($Value)) -or ($Value -lt 1.0))
    {
        return [Double]::NaN;
    }
    elseif([Double]::IsPositiveInfinity($Value))
    {
        return [Double]::PositiveInfinity;
    }
    elseif($Value -eq 1.0)
    {
        return 0.0;
    }

    return (Get-NaturalLogarithm ($Value + (Get-SquareRoot (1.0 + $Value * $Value))));
}

<#
.SYNOPSIS
Returns the inverse hyperbolic sine of a specified number.

.Description
This function returns the inverse hyperbolic sine of a specified number as double-precision floating-point number.
The value returned is a hyperbolic angle where the hyperbolic sine of this value will be the number specified by the user.

.Parameter Value
A number that represents a hyperbolic sine that will be used to find the corresponding hyperbolic angle.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
http://mathworld.wolfram.com/InverseHyperbolicSine.html

.Example
Get-AreaHyperbolicSine 2.3
1.57027854348498
#>
function Get-AreaHyperbolicSine
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if(([Double]::IsNaN($Value)) -or ([Double]::IsInfinity($Value)))
    {
        return $Value;
    }
    elseif($Value -eq 0.0)
    {
        return 0.0;
    }

    return (Get-NaturalLogarithm ($Value + (Get-SquareRoot (1.0 + $Value * $Value))));
}

<#
.SYNOPSIS
Returns the inverse hyperbolic tangent of a specified number.

.Description
This function returns the inverse hyperbolic tangent of a specified number as double-precision floating-point number.
The value returned is a hyperbolic angle where the hyperbolic tangent of this value will be the number specified by the user.

.Parameter Value
A number that represents a hyperbolic tangent that will be used to find the corresponding hyperbolic angle.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
http://mathworld.wolfram.com/InverseHyperbolicTangent.html

.Example
Get-AreaHyperbolicTangent 0.5
0.549306144334055
#>
function Get-AreaHyperbolicTangent
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Value
    )

    if(([Double]::IsNaN($Value)) -or ($Value -gt 1.0) -or ($Value -lt -1.0))
    {
        return [Double]::NaN;
    }
    elseif($Value -eq 1.0)
    {
        return [Double]::PositiveInfinity;
    }
    elseif($Value -eq -1.0)
    {
        return [Double]::NegativeInfinity;
    }
    elseif($Value -eq 0.0)
    {
        return 0.0;
    }

    return 0.5 * (Get-NaturalLogarithm ((1.0 + $Value) / (1.0 - $Value)))
}

<#
.SYNOPSIS
Returns the hyperbolic cosine of a specified angle.

.Description
This function returns the hyperbolic cosine of a specified hyperbolic angle as double-precision floating-point number.
This function is an alternative to [Math]::Cosh(...) .

.Parameter Angle
A hyperbolic angle that will be used to find the corresponding hyperbolic cosine.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
https://msdn.microsoft.com/en-us/library/system.math.cosh(v=vs.110).aspx

.Example
Get-HyperbolicCosine 1.2
1.81065556732437
#>
function Get-HyperbolicCosine
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

    if([Double]::IsInfinity($Angle))
    {
        return [Double]::PositiveInfinity;
    }
    elseif([Double]::IsNaN($Angle))
    {
        return [Double]::NaN;
    }

    [Double]$temp = (Get-NaturalExponentiation $Angle);

    return ($temp * $temp + 1.0) / (2.0 * $temp);
}

<#
.SYNOPSIS
Returns the hyperbolic sine of a specified angle.

.Description
This function returns the hyperbolic sine of a specified hyperbolic angle as double-precision floating-point number.
This function is an alternative to [Math]::Sinh(...) .

.Parameter Angle
A hyperbolic angle that will be used to find the corresponding hyperbolic sine.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
https://msdn.microsoft.com/en-us/library/system.math.sinh(v=vs.110).aspx

.Example
Get-HyperbolicSine 2.1
4.02185674215733
#>
function Get-HyperbolicSine
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

    if([Double]::IsNaN($Angle) -or [Double]::IsInfinity($Angle))
    {
        return $Angle;
    }
    elseif($Angle -ge 710.5)
    {
        return [Double]::PositiveInfinity;
    }
    elseif($Angle -le -710.5)
    {
        return [Double]::NegativeInfinity;
    }

    [Double]$temp = (Get-NaturalExponentiation $Angle);

    return ($temp * $temp - 1.0) / (2.0 * $temp);
}

<#
.SYNOPSIS
Returns the hyperbolic tangent of a specified angle.

.Description
This function returns the hyperbolic tangent of a specified hyperbolic angle as double-precision floating-point number.
This function is an alternative to [Math]::Tanh(...) .

.Parameter Angle
A hyperbolic angle that will be used to find the corresponding hyperbolic tangent.

.Inputs
[System.Double]

.Outputs
[System.Double]

.Link
https://msdn.microsoft.com/en-us/library/system.math.tanh(v=vs.110).aspx

.Example
Get-HyperbolicTangent -1.1
-0.80049902176063
#>
function Get-HyperbolicTangent
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

    if([Double]::IsNaN($Angle))
    {
        return $Angle;
    }
    elseif([Double]::IsNegativeInfinity($Angle) -or ($Angle -le -18.0))
    {
        # Tests with the .NET Tanh(...) function shows that numbers lesser than -18 (below -17.96...) returns -1.0.
        return -1.0;
    }
    elseif([Double]::IsPositiveInfinity($Angle) -or ($Angle -ge 18.0))
    {
        # Tests with the .NET Tanh(...) function shows that numbers greater than 18 (below 17.96...) returns 1.0.
        return 1.0;
    }

    [Double]$temp = (Get-NaturalExponentiation $Angle);
    $temp = $temp * $temp; # e^x * e^x = e^2x

    return ($temp - 1.0) / ($temp + 1.0);
}
