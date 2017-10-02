#Requires -Version 3
Set-StrictMode -Version Latest

<#
.SYNOPSIS
Returns the larger of two numbers.

.Description
Returns the number that is the largest out of two numbers specified by the user. As such, this is an alternative to [Math]::Max(...).
Unlike [Math]::Max(...), this function can be used to compute the smallest value in a set.

.PARAMETER Alpha
Specifies the first number used to be checked for largest.

.PARAMETER Beta
Specifies the second number used to be checked for largest.

.PARAMETER Values
Specifies a set of numbers that the function will search in for the largest number.

.Inputs
[System.Double] or [System.Double[]]

.Outputs
[System.Double]

.Link
https://msdn.microsoft.com/en-us/library/7x97k0y4(v=vs.110).aspx

.Example
Get-Maximum 4 45
45

.EXAMPLE
Get-Maximum 1,2,3,-1
3
#>
function Get-Maximum
{
    param(
        [parameter(ParameterSetName = "Singular", Mandatory = $true, Position = 0)]
        [Double]$Alpha,
        [parameter(ParameterSetName = "Singular", Mandatory = $true, Position = 1)]
        [Double]$Beta,
        [Parameter(ParameterSetName = "Sets", Mandatory = $true, Position = 0)]
        [Double[]]$Values
    )

    switch($PSCmdlet.ParameterSetName)
    {
        "Singular" {
            if([Double]::IsNaN($Alpha) -or [Double]::IsNaN($Beta))
            {
                return [Double]::NaN;
            }
            elseif($Alpha -gt $Beta)
            {
                return $Alpha;
            }
            else
            {
                return $Beta;
            }
        }

        "Sets" {
            if($Values.Length -eq 0)
            {
                # Empty set, no existance of values
                return [Double]::NaN;
            }

            [Double]$min = $Values[0];

            foreach ($i in $Values)
            {
                if($i -gt $min)
                {
                    $min = $i;
                }
            }

            return $min;
        }
    }
}

<#
.SYNOPSIS
Returns the smaller of two or more numbers.

.DESCRIPTION
Returns the number that is the smallest in value out of two numbers specified by the user. As such, this funciton is an alternative to [Math]::Min(...).
Unlike [Math]::Min(...), this function can be used to compute the smallest value in a set.

.PARAMETER Alpha
Specifies the first number to be used to check for smallest.

.PARAMETER Beta
Specifies the second number to be used to check for smallest.

.PARAMETER Values
Specifies a set of numbers that the function will search in for the smallest number.

.INPUTS
[System.Double] or [System.Double[]]

.OUTPUTS
[System.Double]

.LINK
https://msdn.microsoft.com/en-us/library/xcd487wd(v=vs.110).aspx

.EXAMPLE
Get-Minimum 4 45
4

.EXAMPLE
Get-Minimum 1,2,3,-1
-1
#>
function Get-Minimum
{
    param(
        [parameter(ParameterSetName = "Singular", Mandatory = $true, Position = 0)]
        [Double]$Alpha,
        [parameter(ParameterSetName = "Singular", Mandatory = $true, Position = 1)]
        [Double]$Beta,
        [Parameter(ParameterSetName = "Sets", Mandatory = $true, Position = 0)]
        [Double[]]$Values
    )

    switch($PSCmdlet.ParameterSetName)
    {
        "Singular" {
            if([Double]::IsNaN($Alpha) -or [Double]::IsNaN($Beta))
            {
                return [Double]::NaN;
            }
            elseif($Alpha -lt $Beta) {
                return $Alpha;
            }
            else
            {
                return $Beta;
            }
        }

        "Sets" {
            if($Values.Length -eq 0)
            {
                # Empty set, no existance of values
                return [Double]::NaN;
            }

            [Double]$min = $Values[0];

            foreach ($i in $Values)
            {
                if($i -lt $min)
                {
                    $min = $i;
                }
            }

            return $min;
        }
    }
}
