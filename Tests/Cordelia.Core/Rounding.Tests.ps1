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


Describe "Get-Floor" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 1.0 ; Argument = 1.23456 ;
               'Expected Display' = 1.0 ; 'Argument Display' = 1.23456 }

            @{ Expected = -2.0 ; Argument = -1.23456 ;
               'Expected Display' = -2.0 ; 'Argument Display' = -1.23456 }

            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-Floor $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-Ceiling" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 2.0 ; Argument = 1.23456 ;
               'Expected Display' = 1.0 ; 'Argument Display' = 1.23456 }

            @{ Expected = -1.0 ; Argument = -1.23456 ;
               'Expected Display' = -2.0 ; 'Argument Display' = -1.23456 }

            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-Ceiling $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-Truncated" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 1.0 ; Argument = 1.23456 ;
               'Expected Display' = 1.0 ; 'Argument Display' = 1.23456 }

            @{ Expected = -1.0 ; Argument = -1.23456 ;
               'Expected Display' = -2.0 ; 'Argument Display' = -1.23456 }

            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-Truncated $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-Rounded" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 1.0 ; Argument = 1.23456 ;
               'Expected Display' = 1.0 ; 'Argument Display' = 1.23456 }

            @{ Expected = -1.0 ; Argument = -1.23456 ;
               'Expected Display' = -2.0 ; 'Argument Display' = -1.23456 }

            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-Rounded $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }

        It "Should return '<Expected Display>' when rounding '<Number Display>' to '<Digits Display>' decimal places" -TestCases @(
            @{ Expected = 1.2346 ; Number = 1.23456 ; Digits = 4 ;
               'Expected Display' = 1.2346 ; 'Number Display' = 1.23456 ; 'Digits Display' = 4 }

            @{ Expected = 1.23 ; Number = 1.23456 ; Digits = 3 ;
               'Expected Display' = 1.23 ; 'Number Display' = 1.23456 ; 'Digits Display' = 3 }

            @{ Expected = 1.23456 ; Number = 1.23456 ; Digits = 6 ;
               'Expected Display' = 1.23456 ; 'Number Display' = 1.23456 ; 'Digits Display' = 6 }

            @{ Expected = -1.2 ; Number = -1.23456 ; Digits = 1 ;
               'Expected Display' = -1.2 ; 'Number Display' = -1.23456 ; 'Digits Display' = 1 }
        ) {
            param($Expected, $Number, $Digits, ${Expected Display}, ${Number Display}, ${Digits Display})

            $ans = Get-Rounded $Number $Digits
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }

        It "Should return '<Expected Display>' when rounding '<Number Display>' to '<Digits Display>' decimal places under '<Midpoint Method Display>'" -TestCases @(
            @{ Expected = 1.3 ; Number = 1.25 ; Digits = 1 ; 'Midpoint Method' = [System.MidpointRounding]::AwayFromZero ;
               'Expected Display' = 1.3 ; 'Number Display' = 1.25 ; 'Digits Display' = 1 ; 'Midpoint Method Display' = 'AwayFromZero' }

            @{ Expected = 1.2 ; Number = 1.25 ; Digits = 1 ; 'Midpoint Method' = [System.MidpointRounding]::ToEven ;
               'Expected Display' = 1.2 ; 'Number Display' = 1.25 ; 'Digits Display' = 1 ; 'Midpoint Method Display' = 'ToEven' }
        ) {
            param($Expected, $Number, $Digits, ${Midpoint Method}, ${Expected Display}, ${Number Display}, ${Digits Display}, ${Midpoint Method Display})

            $ans = Get-Rounded $Number $Digits -Mode ${Midpoint Method}
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}
