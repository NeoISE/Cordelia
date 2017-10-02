#Requires -Version 3
Set-StrictMode -Version Latest

<#
.SYNOPSIS
Returns the factorial of a specified value.

.Description
Returns the n-th factorial where n is the value passed into the function.

.Parameter Alpha
Specifies the value to be used to find the factorial.

.Inputs
[System.Numerics.BigInteger]

.Outputs
[System.Numerics.BigInteger]

.Link
http://mathworld.wolfram.com/Factorial.html

.Example
Get-Factorial 20
2432902008176640000
#>
function Get-Factorial
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [BigInt]$Alpha
    )

    if($Alpha.CompareTo([BigInt]::Zero) -lt 0)
    {
        return [BigInt]::One
    }

    return Get-FactorialHelper $Alpha ([BigInt]::One)
}


##################################################################################################################
#
# Helper function for the tail recursion in Get-Factorial
#
##################################################################################################################
function Get-FactorialHelper
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [BigInt]$current,
        [Parameter(Mandatory = $true, Position = 1)]
        [BigInt]$accum
    )

    if($current.Equals([BigInt]::Zero) -or $current.Equals([BigInt]::One))
    {
        return $accum
    }
    else
    {
        return Get-FactorialHelper ([BigInt]::Subtract($current, ([BigInt]::One))) ([BigInt]::Multiply($accum, $current))
    }
}
