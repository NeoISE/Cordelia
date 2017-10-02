#Requires -Version 3
#Requires -Module Cordelia.Core
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
[System.Double]

.Outputs
[System.Double]

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
        [Double]$Total,
        [Parameter(Mandatory = $true, Position = 1)]
        [Double]$Trial
    )

    if([Double]::IsNaN($Total) -or [Double]::IsInfinity($Total) -or ($Total -lt 0.0))
    {
        return [Double]::NaN;
    }
    elseif([Double]::IsNaN($Trial) -or [Double]::IsInfinity($Trial) -or ($Trial -lt 0.0))
    {
        return [Double]::NaN;
    }

    # Take only the integral parts
    [Double]$n = (Get-Truncated $Total);
    [Double]$r = (Get-Truncated $Trial);

    if(($n -eq 0.0) -or ($r -gt $n))
    {
        return 0.0;
    }
    elseif($r -eq 0.0)
    {
        return 1.0;
    }

    [Double]$result = $n--;
    [Double]$lowBound = (Get-Maximum ($n - $r) 1.0);    # There's no need to multiply by 1

    for(; $n -gt $lowBound; --$n)
    {
        $result = $result * $n;
    }

    return $result;
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
[System.Double]

.Outputs
[System.Double]

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
        [Double]$Total,
        [Parameter(Mandatory = $true, Position = 1)]
        [Double]$Trial
    )

    if([Double]::IsNaN($Total) -or [Double]::IsInfinity($Total) -or ($Total -lt 0.0))
    {
        return [Double]::NaN;
    }
    elseif([Double]::IsNaN($Trial) -or [Double]::IsInfinity($Trial) -or ($Trial -lt 0.0))
    {
        return [Double]::NaN;
    }

    # Takes only the integral parts
    [Double]$n = (Get-Truncated $Total);
    [Double]$r = (Get-Truncated $Trial);

    if(($n -eq 0.0) -or ($r -gt $n))
    {
        return 0.0;
    }
    elseif(($r -eq 0.0) -or ($n -eq $r))
    {
        return 1.0;
    }

    # The following algorithm works because C(n,r) = (1 / r!) * n! / (n - r)!, thus the second term simplies to
    # n * (n - 1) * (n - 2) * (...) * (n - r + 1), and the "r" factorial expands to
    # 1 *    2    *    3    * (...) *     (r), thus for every term multiplied, there is an increasing term that is divided out.

    [Double]$lowBound = (Get-Maximum ($n - $r) $r);
    [Double]$result = $n--;

    for([Double]$i = 2; $n -gt $lowBound; --$n, ++$i)
    {
        $result = $result * $n / $i;
    }

    return $result;
}
