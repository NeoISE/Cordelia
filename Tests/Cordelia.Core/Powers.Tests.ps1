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

[Double]$E        = 2.7182818284590452353602874713527
[Double]${E^2}    = 7.389056098930650227230427460575
[Double]${E^(-4)} = 0.01831563888873418029371802127324

[Double]${Sqrt 2} = 1.4142135623730950488016887242097


Describe "Get-NaturalExponentiation" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = $E ; Argument = 1.0 ;
               'Expected Display' = 'E' ; 'Argument Display' = 1.0 }

            @{ Expected = 1.0 ; Argument = 0.0 ;
               'Expected Display' = 1.0 ; 'Argument Display' = 0.0 }

            @{ Expected = ${E^(-4)} ; Argument = -4.0 ;
               'Expected Display' = 'E^(-4)' ; 'Argument Display' = -4.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-NaturalExponentiation $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-GeneralExponentiation" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Base Display>' raised to the Power of '<Power Display>'" -TestCases @(
            @{ Expected = 1.0 ; Base = 0.0 ; Power = 0.0 ;
               'Expected Display' = 1.0 ; 'Base Display' = 0.0 ; 'Power Display' = 0.0 }

            @{ Expected = ${E^2} ; Base = $E ; Power = 2.0 ;
               'Expected Display' = 'E^2' ; 'Base Display' = 'E' ; 'Power Display' = 2.0 }

            @{ Expected = 2.0 ; Base = ${Sqrt 2} ; Power = 2.0 ;
               'Expected Display' = 2.0 ; 'Base Display' = 'SQRT(2)' ; 'Power Display' = 2.0 }

            @{ Expected = 1.0e9 ; Base = 10.0 ; Power = 9.0 ;
               'Expected Display' = '1.0e9' ; 'Base Display' = 10.0 ; 'Power Display' = 9.0 }
            @{ Expected = 0.125 ; Base = 0.5 ; Power = 3.0 ;
               'Expected Display' = 0.125 ; 'Base Display' = 0.5 ; 'Power Display' = 3.0 }
        ) {
            param($Expected, $Base, $Power, ${Expected Display}, ${Base Display}, ${Power Display})

            $ans = Get-GeneralExponentiation $Base $Power
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-NaturalLogarithm" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 1.0 ; Argument = $E ;
               'Expected Display' = 1.0 ; 'Argument Display' = 'E' }

            @{ Expected = 0.0 ; Argument = 1.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 1.0 }

            @{ Expected = -4.0 ; Argument = ${E^(-4)} ;
               'Expected Display' = -4.0 ; 'Argument Display' = '(E^(-4))' }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-NaturalLogarithm $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-GeneralLogarithm" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>' with '<Base Display>' as the base of the logarithm" -TestCases @(
            @{ Expected = 0.0 ; Base = 0.0 ; Argument = 1.0 ;
               'Expected Display' = 0.0 ; 'Base Display' = 0.0 ; 'Argument Display' = 1.0 }

            @{ Expected = 2.0 ; Base = $E ; Argument = ${E^2} ;
               'Expected Display' = 2.0 ; 'Base Display' = 'E' ; 'Argument Display' = 'E^2' }

            @{ Expected = 2.0 ; Base = ${Sqrt 2} ; Argument = 2.0 ;
               'Expected Display' = 2.0 ; 'Base Display' = 'SQRT(2)' ; 'Argument Display' = 2.0 }

            @{ Expected = 9.0 ; Base = 10.0 ; Argument = 1.0e9 ;
               'Expected Display' = 9.0 ; 'Base Display' = 10.0 ; 'Argument Display' = 1.0e9 }
            @{ Expected = 3.0 ; Base = 0.5 ; Argument = 0.125 ;
               'Expected Display' = 3.0 ; 'Base Display' = 0.5 ; 'Argument Display' = 0.125 }
        ) {
            param($Expected, $Base, $Argument, ${Expected Display}, ${Base Display}, ${Argument Display})

            $ans = Get-GeneralLogarithm $Argument $Base
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-SquareRoot" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = 1.0 ; Argument = 1.0 ;
               'Expected Display' = 1.0 ; 'Argument Display' = 1.0 }

            @{ Expected = $E ; Argument = ${E^2} ;
               'Expected Display' = 'E' ; 'Argument Display' = 'E^2' }

            @{ Expected = ${Sqrt 2} ; Argument = 2.0 ;
               'Expected Display' = 'SQRT(2)' ; 'Argument Display' = 2.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-SquareRoot $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-CubeRoot" {
    Context "Arguments are given as Parameters" {
        [Double]${E^3}    = 20.085536923187667740928529654582
        [Double]${Sqrt 3} = 1.7320508075688772935274463415059

        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = 1.0 ; Argument = 1.0 ;
               'Expected Display' = 1.0 ; 'Argument Display' = 1.0 }

            @{ Expected = $E ; Argument = ${E^3} ;
               'Expected Display' = 'E' ; 'Argument Display' = 'E^3' }

            @{ Expected = ${Sqrt 3} ; Argument = 3.0 ;
               'Expected Display' = 'SQRT(3)' ; 'Argument Display' = 3.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-CubeRoot $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}
