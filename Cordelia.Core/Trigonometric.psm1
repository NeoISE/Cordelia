#Requires -Version 3
#Requires -Module SignNumbers
#Requires -Module Powers
Set-StrictMode -Version Latest

# Constants that used throughout the module
[Double]$PI = [Math]::PI;
[Double]$HalfPI = 1.5707963267948966192313216916398;
[Double]$TwoPI = 6.283185307179586476925286766559;


<#
    .SYNOPSIS
        Returns the inverse cosine of a specified number.

    .Description
        This function returns the inverse cosine of a specified number as double-precision floating-point number.
        The value returned is an angle between 0 and [Math]::PI where the cosine of this value will be the number specified by the user.
		The angle will be in Radians, multiply by ([Math]::PI / 180) for Degrees. This function is an alternative to [Math]::Acos(...) .

    .Parameter Ratio
        A number that represents a cosine that will be used to find the corresponding angle.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Link
        https://msdn.microsoft.com/en-us/library/system.math.acos(v=vs.110).aspx

    .Example
        Get-ArcCosine 0.5
		1.0471975511966
#>
function Get-ArcCosine
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Ratio
    )

    if([Double]::IsNaN($Ratio) -or [Double]::IsInfinity($Ratio) -or ($Ratio -gt 1.0) -or ($Ratio -lt -1.0))
    {
        return [Double]::NaN;
    }
    elseif($Ratio -eq 1.0)
    {
        return 0.0;
    }
    elseif($Ratio -eq -1.0)
    {
        return $PI;
    }

    return $HalfPI - (Get-ArcSine $Ratio);		# PI/2 - arcsin(Ratio)
}

<#
    .SYNOPSIS
        Returns the inverse sine of a specified number.

    .Description
        This function returns the inverse sine of a specified number as double-precision floating-point number.
        The value returned is an angle between negative and positive ([Math]::PI / 2) where the sine of this value will be the number specified by the user.
		The angle will be in Radians, multiply by ([Math]::PI / 180) for Degrees. This function is an alternative to [Math]::Asin(...) .

    .Parameter Ratio
        A number that represents a sine that will be used to find the corresponding angle.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Notes
        Due to bad convergence near endpoints of the curve, there is a quick-and-dirty manipulation with Ratio to increase convergence.

    .Link
        https://msdn.microsoft.com/en-us/library/system.math.asin(v=vs.110).aspx

    .Example
        Get-ArcSine 1
        1.5707963267949
#>
function Get-ArcSine
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Ratio
    )

    if([Double]::IsNaN($Ratio) -or [Double]::IsInfinity($Ratio) -or ($Ratio -gt 1.0) -or ($Ratio -lt -1.0))
    {
        return [Double]::NaN;
    }
    elseif((Get-AbsoluteValue $Ratio) -eq 1.0)
    {
        return (Get-Sign $Ratio) * $HalfPI;		# positive or negative PI/2
    }

    # Newton's method (for finding roots to functions)
    #[Double]$result = $Ratio / 2.0;
    #[Double]$diff = 0.0;
    #do
    #{
    #    $diff = $result;
    #    $result = $result + ((Get-SineTiny $result) + $Ratio) / (Get-CosineTiny $result);
    #}
    #while($diff -ne $result)

    [Double]$abs = (Get-AbsoluteValue $Ratio);
    [Double]$result = 0.0;     # Initial guess, x_0
    [Int]$iterations = 0;      # If the loop exceeds 10, the value is assumed to be approximated;
    [Double]$scale = 1.0;

    if($abs -gt 0.9999)
    {
        # Halley's method fails when the denominator becomes too small or zero; this tends to happen when Ratio approaches the edge of the domain.
        # This leads to having to map [-1,1] to [-pi/4, pi/4] by using an arcsin(...) to arcsin(...) relationship.
        $scale = 2.0;
        $abs = 0.70710678118655 * $abs / (1.0 + (Get-SquareRoot (1.0 - $abs * $abs)));
    }

    if($abs -gt 0.9006)
    {
        $result = 3.2025630761017 * $abs - 1.7891990247932;    # Initial guess, x_0, of the recursive method
    }
    elseif($abs -gt 0.6881)
    {
        $result = (5.0 * $abs - 1.2181143459954) / 3.0;    # Initial guess, x_0, of the recursive method, good below 0.9006
    }
    elseif($abs -gt 0.3475)
    {
        $result = 1.1547005383792 * $abs - 0.0537514935913;    # Initial guess, x_0, of the recursive method, good below 0.6881
    }
    else
    {
        $result = $abs;      # Initial guess, x_0, of the recursive method, good below 0.3475
    }

    [Double]$previous 		= 0.0;			# Holds the previous result, if diff == result;
	[Double]$negSin 		= 0.0;			# Equals -1 * sin(x_i)
	[Double]$cos 			= 0.0;			# Equals cos(x_i)

	do
    {
        $previous 		= $result;
        $negSin 		= (Get-SineTiny $result);
        $cos 			= (Get-CosineTiny $result);

        $result = $result + 2.0 * $cos * ($negSin + $abs) / (2.0 + $negSin * ($abs - $negSin));
    }
    while(($previous -ne $result) -and (($iterations++) -lt 10));

    return (Get-Sign $Ratio) * $scale * $result;
}

<#
    .SYNOPSIS
        Returns the inverse tangent of a specified number or the inverse tangent of a specified Cartesian coordinate.

    .Description
        This function returns the inverse tangent of a specified number or the inverse tangent of a specified Cartesian coordinate as double-precision floating-point number.
        For a specified number, the value returned is an angle between negative and positive ([Math]::PI / 2) where the tangent of this value will be the number specified by the user.
		For a Cartesian coordinate (x, y), the value returned is an angle between negative and positive ([Math]::PI); this angle represents the angle between the positive X-axis and the line that contains the origin and the specified point.
		The angle will be in Radians, multiply by ([Math]::PI / 180) for Degrees. This function is an alternative to [Math]::Atan(...) and [Math]::Atan2(..., ...).

    .Parameter Ratio
        A number that represents a tangent that will be used to find the corresponding angle.

	.Parameter X
		The X-axis coordinate of a point on a line through the origin, used to find the angle between the positive X-axis (Cartesian) and the line that runs through the origin and the specified point.

	.Parameter Y
		The Y-axis coordinate of a point on a line through the origin, used to find the angle between the positive X-axis (Cartesian) and the line that runs through the origin and the specified point.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Notes
        Due to bad convergence near endpoints of the curve, there is a quick-and-dirty manipulation with Ratio to increase convergence.

    .Link
        https://msdn.microsoft.com/en-us/library/system.math.atan(v=vs.110).aspx

	.Link
		https://msdn.microsoft.com/en-us/library/system.math.atan2(v=vs.110).aspx

    .Example
        Get-ArcTangent 1
		0.785398163397448
#>
function Get-ArcTangent
{
    param(
        [Parameter(ParameterSetName = "Ratio", Mandatory = $true, Position = 0)]
        [Double]$Ratio,
		[Parameter(ParameterSetName = "Point", Mandatory = $true, Position = 1)]
		[Double]$X,
		[Parameter(ParameterSetName = "Point", Mandatory = $true, Position = 0)]
		[Double]$Y
    )

	switch($PSCmdlet.ParameterSetName)
	{
		"Ratio" {
			if([Double]::IsNaN($Ratio))
		    {
		        return $Ratio;
		    }
		    elseif([Double]::IsInfinity($Ratio))
		    {
		        return (Get-Sign $Ratio) * $HalfPI;
		    }

		    # Interestingly, the arctan formula can be reduced:
		    # arctan(x) = 2 * arctan(x / (1 + sqrt(x^2 + 1))) = ...
		    # The argument on the right hand-side is guaranteed to be below 1
		    [Double]$reduced = (Get-AbsoluteValue $Ratio);
		    [Double]$steps = 1.0;		# The constant factor that needs to be multiplied to get back to the leftmost arctangent.

		    while($reduced -gt 0.90)
		    {
				# perform the transformation to get a small enough argument for arctangent -> thus the constant factor also increases.
		        $reduced = $reduced / (1.0 + (Get-SquareRoot (1.0 + $reduced * $reduced)));
		        $steps = 2.0 * $steps;
		    }

			[Double]$result = $reduced / (Get-SquareRoot (1.0 + $reduced * $reduced));

		    return (Get-Sign $Ratio) * $steps * (Get-ArcSine $result);		# arctan(x) = arcsin(x / sqrt(1 + x^2))
		}

		"Point" {
			if([Double]::IsNaN($Y) -or [Double]::IsNaN($X) -or [Double]::IsInfinity($Y) -or [Double]::IsInfinity($X))
			{
				return [Double]::NaN;
			}
			elseif($Y -eq 0.0)
			{
				if($X -gt 0.0)
				{
					return 0.0;
				}
				elseif($X -lt 0.0)
				{
					return $PI;
				}
				else
				{
					# X == 0
					return 0;
				}
			}
			elseif($X -eq 0.0)
			{
				if($Y -gt 0.0)
				{
					return $HalfPI;
				}
				else
				{
					# Since Y == 0 and X == 0 is already covered, only Y < 0 and X == 0 is left
					return -1.0 * $HalfPI;
				}
			}

			# It seems quadrant 1 and 4 can be computed using Ratio easily, but quadrant 2 and 3 needs to be adjusted to get the Ratio value working.
			elseif($X -lt 0.0)
			{
				if($Y -gt 0.0)
				{
					# Y > 0
					return $PI + (Get-ArcTangent ($Y / $X));
				}
				else
				{
					# Y < 0
					return (Get-ArcTangent ($Y / $X)) - $PI;
				}
			}
			else
			{
				# X > 0
				return (Get-ArcTangent ($Y / $X));
			}
		}
	}
}

<#
    .SYNOPSIS
        Returns the cosine of a specified angle.

    .Description
        This function returns the cosine of a specified angle as double-precision floating-point number.
        The angle will be in Radians, multiply by ([Math]::PI / 180) for Degrees. This function is an alternative to [Math]::Cos(...) .

    .Parameter Angle
        An angle that is measured in radians. For degrees, multiply by ([Math]::PI / 180) to get radians.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Link
        https://msdn.microsoft.com/en-us/library/system.math.cos(v=vs.110).aspx

    .Example
        Get-Cosine ([Math]::PI)
        -1
#>
function Get-Cosine
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

    if([Double]::IsNaN($Angle) -or [Double]::IsInfinity($Angle))
    {
        return [Double]::NaN;
    }

    # Due to being an even function.
    # cos(-x) = cos(x)
    # cos(0x) = 1
    # cos(+x) = cos(x)

    # Corrects the domain down to [-pi, pi].
    $Angle = (Get-DomainReduction $Angle);

    # This reduces the domain to [0, pi], since cos(x) = cos(abs(x))
    $Angle = (Get-AbsoluteValue $Angle);

    # cos(x) = cos(abs(x))
    # cos(x) = -sin(abs(x) - pi / 2), 0 < abs(x) < pi
    # cos(x) = -sin(y), y = abs(x) - pi / 2, -pi / 2 < y < pi / 2

    # the above relationship helps to create faster convergence since the "radius" of convergence changes
    # from r <= pi to r <= (pi / 2), potentially lessening the number of terms.

    # x -> [0, pi] to x -> [-pi/2, pi/2]
    return (Get-SineTiny ($Angle - $HalfPI));
}

<#
    .SYNOPSIS
        Returns the sine of a specified angle.

    .Description
        This function returns the sine of a specified angle as double-precision floating-point number.
        The angle must be in Radians, multiply by ([Math]::PI / 180) for Degrees. This function is an alternative to [Math]::Sin(...) .

    .Parameter Angle
        An angle that is measured in radians. For degrees, multiply by ([Math]::PI / 180) to get radians.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Link
        https://msdn.microsoft.com/en-us/library/system.math.sin(v=vs.110).aspx

    .Example
        Get-Sine ([Math]::PI)
        0
#>
function Get-Sine
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

    if([Double]::IsNaN($Angle) -or [Double]::IsInfinity($Angle))
    {
        return [Double]::NaN;
    }

    # Due to being an odd function.
    # sin(-x) = -sin(x)
    # sin(0x) = 0sin(x)
    # sin(+x) = +sin(x)

    # Corrects the domain down to [-pi, pi].
    $Angle = (Get-DomainReduction $Angle);

    [Double]$reduced = (Get-AbsoluteValue $Angle);

    # sin(x) = sgn(x)sin(abs(x))
    # sin(x) = sgn(x)cos(x - pi/2), 0 < x < pi
    # sin(x) = sgn(x)cos(y), y = x - pi / 2, -pi / 2 < y < pi / 2

    # the above relationship helps to create faster convergence since the "radius" of convergence changes
    # from r <= pi to r <= (pi / 2), potentially lessening the number of terms.

    # x -> [0, pi] to x -> [-pi/2, pi/2]
    return (Get-Sign $Angle) * (Get-CosineTiny ($reduced - $HalfPI));
}

<#
    .SYNOPSIS
        Returns the tangent of a specified angle.

    .Description
        This function returns the tangent of a specified angle as double-precision floating-point number.
        The angle must be in Radians, multiply by ([Math]::PI / 180) for Degrees. This function is an alternative to [Math]::Tan(...) .

    .Parameter Angle
        An angle that is measured in radians. For degrees, multiply by ([Math]::PI / 180) to get radians.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Link
        https://msdn.microsoft.com/en-us/library/system.math.tan(v=vs.110).aspx

    .Example
        Get-Tangent 1
        1.5574077246549
#>
function Get-Tangent
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

    if([Double]::IsNaN($Angle) -or [Double]::IsInfinity($Angle))
    {
        return [Double]::NaN;
    }

	# Corrects the domain down to [-pi, pi].
    $Angle = (Get-DomainReduction $Angle);

	# Corrects the domain down to [-pi/2, pi/2]
	if((Get-AbsoluteValue $Angle) -gt $HalfPI)
	{
		$Angle = (Get-Sign $Angle) * ((Get-AbsoluteValue $Angle) - $PI);
	}

	# tan(x) = sin(x) / cos(x)
	# tan(x) = sgn(x) * sin(abs(x)) / cos(x)
	# tan(x) = -sgn(x) * -sin(abs(x)) / cos(x)

	if((Get-AbsoluteValue $Angle) -eq $HalfPI)
	{
		# Equals to positive or negative pi/2
		return [Double]::NaN;
	}
	elseif($Angle -eq 0.0)
	{
		return 0.0;
	}

	return -1.0 * (Get-Sign $Angle) * (Get-SineTiny $Angle) / (Get-Cosine $Angle);
}

<#
    .SYNOPSIS
        Returns the cosecant of a specified angle.

    .Description
        This function returns the cosecant of a specified angle as double-precision floating-point number.
        The angle will be in Radians, multiply by ([Math]::PI / 180) for Degrees.
		This function will provide better results than the typical approach of the reciprocal of the sine of the specified angle.

    .Parameter Angle
        An angle that is measured in radians. For degrees, multiply by ([Math]::PI / 180) to get radians.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Link
        http://mathworld.wolfram.com/Cosecant.html

    .Example
        Get-Cosecant ([Math]::PI / 2.0)
        1
#>
function Get-Cosecant
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

	if([Double]::IsNaN($Angle) -or [Double]::IsInfinity($Angle))
    {
        return [Double]::NaN;
    }

	# Corrects the domain to [-pi, pi]
	$Angle = (Get-DomainReduction $Angle);
	[Double]$reduced = (Get-AbsoluteValue $Angle);		# [0, pi]

	# csc(x) = 1 / sin(x)
	# csc(x) = sgn(x) / sin(abs(x))			-pi < x < 0 and 0 < x < pi
	# csc(x) = sgn(x) / (cos(abs(x) - pi/2))		-pi / 2 < x < 0 and 0 < x < pi / 2

	if(($reduced -eq 0.0) -or ($reduced -eq $PI))
	{
		# sin(x) goes to 0 here, so the value is undefined
		return [Double]::NaN;
	}
	else
	{
		return (Get-Sign $Angle) / (Get-CosineTiny ($reduced - $HalfPI));
	}
}

<#
    .SYNOPSIS
        Returns the secant of a specified angle.

    .Description
        This function returns the secant of a specified angle as double-precision floating-point number.
        The angle must be in Radians, multiply by ([Math]::PI / 180) for Degrees.
		This function will provide better results than the typical approach of the reciprocal of the cosine of the specified angle.

    .Parameter Angle
        An angle that is measured in radians. For degrees, multiply by ([Math]::PI / 180) to get radians.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Link
        http://mathworld.wolfram.com/Secant.html

    .Example
        Get-Secant 0
        1
#>
function Get-Secant
{
    param(
		[Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

	if([Double]::IsNaN($Angle) -or [Double]::IsInfinity($Angle))
    {
        return [Double]::NaN;
    }

	# Corrects the domain to [-pi, pi]
	$Angle = (Get-DomainReduction $Angle);
	[Double]$reduced = (Get-AbsoluteValue $Angle);		# [0, pi]

	# sec(x) = 1 / cos(abs(x))
	# sec(x) = 1 / sin(abs(x) - pi/2)

	if($reduced -eq $HalfPI)
	{
		return [Double]::NaN;
	}
	else
	{
		return (1.0 / (Get-SineTiny ($reduced - $HalfPI)));
	}
}

<#
    .SYNOPSIS
        Returns the cotangent of a specified angle.

    .Description
        This function returns the cotangent of a specified angle as double-precision floating-point number.
        The angle must be in Radians, multiply by ([Math]::PI / 180) for Degrees.
		This function will provide better results than the typical approach of the reciprocal of the tangent of the specified angle.

    .Parameter Angle
        An angle that is measured in radians. For degrees, multiply by ([Math]::PI / 180) to get radians.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Link
        http://mathworld.wolfram.com/Cotangent.html

    .Example
        Get-Cotangent ([Math]::PI / 2)
		0
#>
function Get-Cotangent
{
    param(
		[Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

	if([Double]::IsNaN($Angle) -or [Double]::IsInfinity($Angle))
    {
        return [Double]::NaN;
    }

	# Corrects the domain to [-pi, pi]
	$Angle = (Get-DomainReduction $Angle);
	[Double]$reduced = (Get-AbsoluteValue $Angle);		# [0, pi]

	# cot(x) = 1 / tan(x)
	# cot(x) = cos(x) / sin(x)
	# cot(x) = sgn(x) * sin(abs(x) - pi / 2) / cos(abs(x) - pi / 2)

	if(($reduced -eq 0.0) -or ($reduced -eq $PI))
	{
		# sin(x) goes to 0 here, so the value is undefined
		return [Double]::NaN;
	}
	else
	{
		$reduced = $reduced - $HalfPI;
		return (Get-Sign $Angle) * (Get-SineTiny ($reduced)) / (Get-CosineTiny ($reduced));
	}
}

###################################################################################################################
###### Since the following inverse functions are not common, there will not be optimizations for them yet. ########
###################################################################################################################

<#
    .SYNOPSIS
        Returns the inverse cosecant of a specified number.

    .Description
        This function returns the inverse cosecant of a specified number as double-precision floating-point number.
        The value returned is an angle between negative and positive ([Math]::PI / 2) where the cosecant of this value will be the number specified by the user.
		The angle will be in Radians, therefore, multiply by ([Math]::PI / 180) for Degrees.

    .Parameter Ratio
        A number that represents a cosecant that will be used to find the corresponding angle. Either less than -1.0 or greater than 1.0.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Notes
        Due to an uncommon demand for this inverse, there is less optimizations performed in the function. Much of the function itself will be heavily relied on inverse sine.

    .Link
        http://mathworld.wolfram.com/InverseCosecant.html

    .Example
        Get-ArcCosecant 1
		1.5707963267949
#>
function Get-ArcCosecant
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Ratio
    )

	if([Double]::IsNaN($Ratio) -or (($Ratio -lt 1.0) -and ($Ratio -gt -1.0)))
	{
		return [Double]::NaN;
	}
	elseif([Double]::IsInfinity($Ratio))
	{
		return 0.0;
	}
	elseif((Get-AbsoluteValue $Ratio) -eq 1.0)
	{
		return $HalfPI * (Get-Sign $Ratio);
	}

    return (Get-ArcSine (1.0 / $Ratio));
}

<#
    .SYNOPSIS
        Returns the inverse secant of a specified number.

    .Description
        This function returns the inverse secant of a specified number as double-precision floating-point number.
        The value returned is an angle between 0 and [Math]::PI where the secant of this value will be the number specified by the user.
		The angle will be in Radians, therefore, multiply by ([Math]::PI / 180) for Degrees.

    .Parameter Ratio
        A number that represents a secant that will be used to find the corresponding angle. Either less than -1.0 or greater than 1.0.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Notes
        Due to an uncommon demand for this inverse, there is less optimizations performed in the function. Much of the function itself will be heavily relied on inverse cosine.

    .Link
        http://mathworld.wolfram.com/InverseSecant.html

    .Example
        Get-ArcSecant 1
		0
#>
function Get-ArcSecant
{
    param(
		[Parameter(Mandatory = $true, Position = 0)]
        [Double]$Ratio
    )

	if([Double]::IsNaN($Ratio) -or (($Ratio -lt 1.0) -and ($Ratio -gt -1.0)))
	{
		return [Double]::NaN;
	}
	elseif([Double]::IsInfinity($Ratio))
	{
		return $HalfPI;
	}
	elseif((Get-AbsoluteValue $Ratio) -eq 1.0)
	{
		return $HalfPI * (1.0 - (Get-Sign $Ratio));
	}

    return (Get-ArcCosine (1.0 / $Ratio));
}

<#
    .SYNOPSIS
        Returns the inverse cotangent of a specified number.

    .Description
        This function returns the inverse cotangent of a specified number as double-precision floating-point number.
        The value returned is an angle between 0 and [Math]::PI where the cotangent of this value will be the number specified by the user.
		The angle will be in Radians, therefore, multiply by ([Math]::PI / 180) for Degrees.

    .Parameter Ratio
        A number that represents a cotangent that will be used to find the corresponding angle.

    .Inputs
        [System.Double]

    .Outputs
        [System.Double]

    .Notes
        Due to an uncommon demand for this inverse, there is less optimizations performed in the function. Much of the function itself will be heavily relied on inverse tangent.

    .Link
        http://mathworld.wolfram.com/InverseCotangent.html

    .Example
        Get-ArcCotangent 0
		1.5707963267949
#>
function Get-ArcCotangent
{
    param(
		[Parameter(Mandatory = $true, Position = 0)]
        [Double]$Ratio
    )

	if([Double]::IsNaN($Ratio))
    {
        return [Double]::NaN;
    }
	elseif([Double]::IsInfinity($Ratio) -or ($Ratio -eq 0.0))
	{
		return $HalfPI * (1.0 - (Get-Sign $Ratio));
	}

    return [Math]::PI / 2.0 - (Get-ArcTangent $Ratio);
}


###################################################################################################################
#
#    Domain Reduction for cos(x) and sin(x), also known as "Angle Correction Algorithm" (ACA).
#
###################################################################################################################
function Get-DomainReduction
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$LargeAngle
    )

    # The functions, cos(x) and sin(x), will handle NaN, +infty, and -infty, so the function will proceed with
    # reducing the angle.

    # Mapping (-infty, +infty) to [-pi, pi]. The orginal angle is assumed to be out of the domain of [-pi, pi].
    [Double]$reduced = (Get-AbsoluteValue $LargeAngle);    # [0, +infty)

    # Much more cache/Memory friendly than look-up table in mapping LargeAngle into the domain of [-pi, pi].
    while($reduced -gt $PI)
    {
        $reduced = $reduced - $TwoPI;
    }

    # At this point, x will be in [-pi, pi].
    # This applies a correction factor for negative values of Angle.
    return (Get-Sign $LargeAngle) * $reduced;
}


###################################################################################################################
#
#    Tiny cos(x). This is a standard cosine function that finds cos(x), -pi/2 <= x <= pi/2, quickly.
#
###################################################################################################################
function Get-CosineTiny
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

    # Warning, this is an implementation method, that is guarenteed to work only for domain [-pi/2, pi/2] with 16
    # digits of accuracy; will not be exposed outside of this file.

    # cos(x) = cos(abs(x))
    # Thus, [-pi/2, pi/2] -> [0, pi/2].

    [Double]$reduced = (Get-AbsoluteValue $Angle);

    if($reduced -eq $HalfPI)
    {
        # The .NET function will not give the correct answer, this is a correction to that problem.
        return 0.0;
    }
    elseif($reduced -eq 0.0)
    {
        return 1.0;
    }

    [Double]$val = 1.0;                               # The first term in the Taylor Series.
    [Double]$rate = $reduced * $reduced * -0.5;       # The successive term

    # Manages the k-th term, k >= 2.
    # Lagrange Remainder shows that n = 194 or n = 195 seems to give error bounds smaller than [Double]::Epsilion,
    # the value in IEEE that is the smallest in significance before the system reads it as zero. Thus, the
    # (194)-th Taylor polynomial term is needed, but in terms of the sigma notation for Maclauren, (n / 2)-th
    # term is needed. n / 2 = 97.
    for([Double]$k = 2.0; $k -le 97.0; ++$k)
    {
        $val = $val + $rate;
        $rate = -1.0 * $rate * $reduced * $reduced / ($k * (4.0 * $k - 2.0));
    }

    return ($val + $rate);
}


###################################################################################################################
#
#    Tiny sin(x). This is a "negated" sine function that finds -sin(x), -pi/2 <= x <= pi/2, quickly.
#
###################################################################################################################
function Get-SineTiny
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Double]$Angle
    )

    # Warning, this is an implementation method, that is guarenteed to work only for domain [-pi/2, pi/2] with high
    # accuracy; will not be exposed outside of this file.

    # -sin(x) = -sgn(x)sin(abs(x))
    # Thus, [-pi/2, pi/2] -> [0, pi/2].

    [Double]$reduced = (Get-AbsoluteValue $Angle);

    if($reduced -eq $HalfPI)
    {
        return (Get-Sign $Angle) * -1.0;
    }
    elseif($reduced -eq 0.0)
    {
        return 0.0;
    }

    [Double]$val = -1.0 * $reduced;                             # The first term in the Taylor Series.
    [Double]$rate = $reduced * $reduced * $reduced / 6.0;       # The successive term

    # Manages the k-th term, k >= 2.
    # Lagrange Remainder shows that n = 194 or n = 195 seems to give error bounds smaller than [Double]::Epsilion,
    # the value in IEEE that is the smallest in significance before the system reads it as zero. Thus, the
    # (195)-th Taylor polynomial term is needed, but in terms of the sigma notation for Maclauren,
    # ((n - 1) / 2)-th term is needed. k = (n - 1) / 2 = 97.
    for([Double]$k = 2.0; $k -le 97.0; ++$k)
    {
        $val = $val + $rate;
        $rate = -1.0 * $rate * $reduced * $reduced / ($k * (4.0 * $k + 2.0));
    }

    return (Get-Sign $Angle) * ($val + $rate);
}
