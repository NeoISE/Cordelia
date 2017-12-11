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

[Double]$PI     = 3.1415926535897932384626433832795
[Double]${2 PI} = 6.283185307179586476925286766559

[Double]${PI Halves}      = 1.5707963267948966192313216916398
[Double]${Neg. PI Halves} = -1.5707963267948966192313216916398

[Double]${PI Fourths}      = 0.78539816339744830961566084581988
[Double]${Neg. PI Fourths} = -0.78539816339744830961566084581988

[Double]${PI Thirds}      = 1.0471975511965977461542144610932
[Double]${Neg. PI Thirds} = -1.0471975511965977461542144610932

[Double]${PI Sixths}      = 0.52359877559829887307710723054658
[Double]${Neg. PI Sixths} = -0.52359877559829887307710723054658

[Double]${Sqrt 2}      = 1.4142135623730950488016887242097
[Double]${Neg. Sqrt 2} = -1.4142135623730950488016887242097

[Double]${Sqrt 2 Div. by 2}      = 0.70710678118654752440084436210485
[Double]${Neg. Sqrt 2 Div. by 2} = -0.70710678118654752440084436210485

[Double]${Sqrt 3}      = 1.7320508075688772935274463415059
[Double]${Neg. Sqrt 3} = -1.7320508075688772935274463415059


Describe "Get-ArcCosine" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = $PI ; Argument = -1.0 ;
               'Expected Display' = 'PI' ; 'Argument Display' = -1.0 }

            @{ Expected = 0.0 ; Argument = 1.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 1.0 }

            @{ Expected = ${PI Halves} ; Argument = 0.0 ;
               'Expected Display' = '(PI/2)' ; 'Argument Display' = 0.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-ArcCosine $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -BeLessThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-ArcSine" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = ${PI Halves} ; Argument = 1.0 ;
               'Expected Display' = '(PI/2)' ; 'Argument Display' = 1.0 }

            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = ${Neg. PI Halves} ; Argument = -1.0 ;
               'Expected Display' = '-(PI/2)' ; 'Argument Display' = -1.0 }

            @{ Expected = ${PI Fourths} ; Argument = ${Sqrt 2 Div. by 2} ;
               'Expected Display' = '(PI/4)' ; 'Argument Display' = '(SQRT(2) / 2)' }

            @{ Expected = ${PI Sixths} ; Argument = 0.5 ;
               'Expected Display' = '(PI/6)' ; 'Argument Display' = 0.5 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-ArcSine $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -BeLessThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-ArcTangent" {
    Context "Arguments are given as Parameters; 'Ratio' Parameter Set" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = ${PI Fourths} ; Argument = 1.0 ;
               'Expected Display' = '(PI/4)' ; 'Argument Display' = 1.0 }

            @{ Expected = ${Neg. PI Thirds} ; Argument = ${Neg. Sqrt 3} ;
               'Expected Display' = '-(PI/3)' ; 'Argument Display' = '-SQRT(3)'}
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-ArcTangent $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -BeLessThan $Tolerance
        }
    }

    Context "Arguments are given as Parameters; 'Point' Parameter Set" {
        [Double]${Neg. 5 PI Sixths} = -2.6179938779914943653855361527329

        It "Should return '<Expected Display>' when given Cartesian Points: X = '<X Display>' and Y = '<Y Display>'" -TestCases @(
            @{ Expected = 0.0 ; X = 0.0 ; Y = 0.0 ;
               'Expected Display' = 0.0 ; 'X Display' = 0.0 ; 'Y Display' = 0.0 }

            @{ Expected = ${PI Fourths} ; X = 1.0 ; Y = 1.0 ;
               'Expected Display' = '(PI/4)' ; 'X Display' = 1.0 ; 'Y Display' = 1.0 }

            @{ Expected = ${PI Halves} ; X = 0.0 ; Y = 1.0 ;
               'Expected Display' = '(PI/2)' ; 'X Display' = 0.0 ; 'Y Display' = 1.0 }

            @{ Expected = ${Two PI Thirds} ; X = -1.0 ; Y = ${Sqrt 3} ;
               'Expected Display' = '(2 * PI/3)' ; 'X Display' = -1.0 ; 'Y Display' = 'SQRT(3)' }

            @{ Expected = $PI ; X = -1.0 ; Y = 0.0 ;
               'Expected Display' = 'PI' ; 'X Display' = -1.0 ; 'Y Display' = 0.0 }

            @{ Expected = ${Neg. 5 PI Sixths} ; X = ${Neg. Sqrt 3} ; Y = -1.0 ;
               'Expected Display' = '-(5 * PI/6)' ; 'X Display' = '-SQRT(3)' ; 'Y Display' = -1.0 }

            @{ Expected = ${Neg. PI Halves} ; X = 0.0 ; Y = -1.0 ;
               'Expected Display' = '-(PI/2)' ; 'X Display' = 0.0 ; 'Y Display' = -1.0 }

            @{ Expected = ${Neg. PI Thirds} ; X = 1.0 ; Y = ${Neg. Sqrt 3} ;
               'Expected Display' = '-(PI/3)' ; 'X Display' = 1.0 ; 'Y Display' = '-SQRT(3)' }
        ) {
            param($Expected, $X, $Y, ${Expected Display}, ${X Display}, ${Y Display})

            $ans = Get-ArcTangent -X $X -Y $Y
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -BeLessThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}