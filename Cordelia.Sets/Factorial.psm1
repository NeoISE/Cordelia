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

##################################################################################################################
#
# Calculates the partial factorial (i.e. n!/r! = n * (n-1) * ... * (r+1)
#
##################################################################################################################
function Get-PartialFactorial
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [BigInt]$value,
        [Parameter(Mandatory = $true, Position = 1)]
        [BigInt]$limit
    )

    if($limit -gt $value -or ($value -eq [BigInt]::Zero) -or ($limit -lt [BigInt]::Zero))
    {
        return [BigInt]::Zero
    }
    elseif($limit -eq $value)
    {
        return [BigInt]::One
    }

    # instead of tail-call, we use an iterative method
    $result = [BigInt]::One
    for($counter = [BigInt]::Add($limit, ([BigInt]::One));
        $counter -le $value;
        $counter = [BigInt]::Add($counter, ([BigInt]::One)))
    {
        $result = [BigInt]::Multiply($counter, $result)
    }

    return $result
}
