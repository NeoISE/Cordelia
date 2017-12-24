#Requires -Version 3
Set-StrictMode -Version Latest

# We cannot compare values of doubles directly (i.e. rounding errors)
# So it is wise to compare the absolute difference of expected and actual instead
# Thus, 'equality' becomes 'less than' and 'not equals' becomes 'greater than or equal to' (or 'not less than') to a maximum allowed "Tolerance" which can be derived from:
#   n = percent_error / 100 = relative_error = abs(Expected - Actual) / abs(Expected) ->
#   abs(Expected - Actual) = n * abs(Expected) = Tolerance
# For simplicity, we let
#   Expected = 10^15,
#   Actual   = 10^15 + 1 ->
#   n = 1/(10^15) = 10^(-15)
[Double]$PRECISION = [Math]::Pow(10, -15)


Describe "Get-Permutation" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given a total size of '<Total Size Display>' and sample size of '<Sample Size Display>'" -TestCases @(
            @{ Expected = 1680.0 ; 'Total Size' = 8.0 ; 'Sample Size' = 4.0 ;
               'Expected Display' = 1680.0 ; 'Total Size Display' = 8.0 ; 'Sample Size Display' = 4.0 }

            @{ Expected = 56.0 ; 'Total Size' = 8.0 ; 'Sample Size' = 2.0 ;
               'Expected Display' = 1680.0 ; 'Total Size Display' = 8.0 ; 'Sample Size Display' = 2.0 }

            @{ Expected = 60480.0 ; 'Total Size' = 9.0 ; 'Sample Size' = 6.0 ;
               'Expected Display' = 60480.0 ; 'Total Size Display' = 9.0 ; 'Sample Size Display' = 6.0 }
        ) {
            param($Expected, ${Total Size}, ${Sample Size}, ${Expected Display}, ${Total Size Display}, ${Sample Size Display})

            $ans = Get-Permutation ${Total Size} ${Sample Size}
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-Combination" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given a total size of '<Total Size Display>' and sample size of '<Sample Size Display>'" -TestCases @(
            @{ Expected = 70.0 ; 'Total Size' = 8.0 ; 'Sample Size' = 4.0 ;
               'Expected Display' = 70.0 ; 'Total Size Display' = 8.0 ; 'Sample Size Display' = 4.0 }

            @{ Expected = 28.0 ; 'Total Size' = 8.0 ; 'Sample Size' = 2.0 ;
               'Expected Display' = 28.0 ; 'Total Size Display' = 8.0 ; 'Sample Size Display' = 2.0 }

            @{ Expected = 84.0 ; 'Total Size' = 9.0 ; 'Sample Size' = 6.0 ;
               'Expected Display' = 84.0 ; 'Total Size Display' = 9.0 ; 'Sample Size Display' = 6.0 }
        ) {
            param($Expected, ${Total Size}, ${Sample Size}, ${Expected Display}, ${Total Size Display}, ${Sample Size Display})

            $ans = Get-Combination ${Total Size} ${Sample Size}
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}
