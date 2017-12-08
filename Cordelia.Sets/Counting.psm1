#Requires -Version 3
#Requires -Module Cordelia.Core
#Requires -Module Factorial
Set-StrictMode -Version Latest

<#
.SYNOPSIS
Returns the permutation of choosing a subset of elements of size Trial from a set of size Total.

.Description
Returns the number of possible ordered subsets of a specified amount of elements from a larger set of elements.
In other words, this function returns the number of ways of obtaining distinct, ordered subset (of size Trial) from a set (of size Total).

.Parameter Total
Specifies the total number of elements (in the set).

.Parameter Trial
Specifies the amount of elements (in the subset).

.Inputs
[System.Numerics.BigInteger]

.Outputs
[System.Numerics.BigInteger]

.Link
http://mathworld.wolfram.com/Permutation.html

.Example
Get-Permutation 5 4
120
#>
function Get-Permutation
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [BigInt]$Total,
        [Parameter(Mandatory = $true, Position = 1)]
        [BigInt]$Trial
    )

    if(($Total -le [BigInt]::Zero) -or ($Trial -gt $Total) -or ($Trial -lt [BigInt]::Zero))
    {
        return [BigInt]::Zero;
    }

    return Get-PartialFactorial $Total ([BigInt]::Subtract($Total, $Trial))
}


<#
.SYNOPSIS
Returns the combination of choosing a subset of elements of size Trial from a set of size Total.

.Description
Returns the number of possible subsets of a specified amount of elements from a larger set of elementst.
In other words, this function returns the number of ways of obtaining distinct, unordered subset (of size Trial) from a set (of size Total).

.Parameter Total
Specifies the total number of elements (in the set).

.Parameter Trial
Specifies the amount of elements (in the subset).

.Inputs
[System.Numerics.BigInteger]

.Outputs
[System.Numerics.BigInteger]

.Link
http://mathworld.wolfram.com/Combination.html

.Example
Get-Combination 6 3
20
#>
function Get-Combination
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [BigInt]$Total,
        [Parameter(Mandatory = $true, Position = 1)]
        [BigInt]$Trial
    )

    if(($Total -le [BigInt]::Zero) -or ($Trial -gt $Total) -or ($Trial -lt [BigInt]::Zero))
    {
        return [BigInt]::Zero
    }
    elseif(($Trial -eq $Total) -or ($Trial -eq [BigInt]::Zero))
    {
        return [BigInt]::One
    }

    # The following algorithm works because C(n,r) = (1 / r!) * n! / (n - r)!, thus the second term simplies to
    # n * (n - 1) * (n - 2) * (...) * (n - r + 1), and the "r" factorial expands to
    # 1 *    2    *    3    * (...) *     (r), thus for every term multiplied, there is an increasing term that is divided out.

    [BigInt]$second = [BigInt]::Subtract($Total, $Trial)
    [BigInt]$lowBound = [BigInt]::Zero

    if($second -lt $Trial)
    {
        $lowBound = $Trial
    }
    else
    {
        $lowBound = $second
    }

    [BigInt]$result = Get-PartialFactorial $Total $lowBound
    for(; $lowBound -ge 2; $lowBound = [BigInt]::Subtract($lowBound, ([BigInt]::One)))
    {
        $result = [BigInt]::Divide($result, $lowBound)
    }

    return $result
}
