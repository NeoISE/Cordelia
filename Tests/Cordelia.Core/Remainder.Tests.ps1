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

[Double]${2 PI}      = 6.283185307179586476925286766559


Describe "Get-IEEERemainder" {
    Context "Arguments are given as Parameters" {
        [Double]$PI          = 3.1415926535897932384626433832795
        [Double]${Neg. PI}   = -3.1415926535897932384626433832795
        [Double]${4 PI}      = 12.566370614359172953850573533118
        [Double]${9 PI}      = 28.274333882308139146163790449516
        [Double]${Neg. 5 PI} = -15.707963267948966192313216916398

        It "Should return '<Expected Display>' when given dividend '<Dividend Display>' and divisor '<Divisor Display>'" -TestCases @(
            @{ Expected = 0.0 ; Dividend = ${4 PI} ; Divisor = ${2 PI}
               'Expected Display' = 0.0 ; 'Dividend Display' = '(4 * PI)' ; 'Divisor Display' = '(2 * PI)' }

            @{ Expected = $PI ; Dividend = ${9 PI} ; Divisor = ${2 PI}
               'Expected Display' = 'PI' ; 'Dividend Display' = '(9 * PI)' ; 'Divisor Display' = '(2 * PI)' }

            @{ Expected = ${Neg. PI} ; Dividend = ${Neg. 5 PI} ; Divisor = ${2 PI}
               'Expected Display' = '-(PI)' ; 'Dividend Display' = '-(5 * PI)' ; 'Divisor Display' = '(2 * PI)' }
        ) {
            param($Expected, $Dividend, $Divisor, ${Expected Display}, ${Dividend Display}, ${Divisor Display})

            $ans = Get-IEEERemainder $Dividend $Divisor
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}
