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


Describe "Get-AbsoluteValue" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 1.234 ; Argument = -1.234 ;
               'Expected Display' = 1.234 ; 'Argument Display' = -1.234 }

            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = 1.234 ; Argument = 1.234 ;
               'Expected Display' = 1.234 ; 'Argument Display' = 1.234 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-AbsoluteValue $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-Sign" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = -1.0 ; Argument = -1.234 ;
               'Expected Display' = -1.0 ; 'Argument Display' = -1.234 }

            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = 1.0 ; Argument = 1.234 ;
               'Expected Display' = 1.0 ; 'Argument Display' = 1.234 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-Sign $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}