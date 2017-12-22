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


Describe "Get-Maximum" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given between '<Argument A Display>' and '<Argument B Display>'" -TestCases @(
            @{ Expected = 4.0 ; 'Argument A' = 1.0 ; 'Argument B' = 4.0 ;
               'Expected Display' = 4.0 ; 'Argument A Display' = 1.0 ; 'Argument B Display' = 4.0 }

            @{ Expected = 3.0 ; 'Argument A' = 3.0 ; 'Argument B' = -1.0 ;
               'Expected Display' = 3.0 ; 'Argument A Display' = 3.0 ; 'Argument B Display' = -1.0 }
        ) {
            param($Expected, ${Argument A}, ${Argument B}, ${Expected Display}, ${Argument A Display}, ${Argument B Display})

            $ans = Get-Maximum ${Argument A} ${Argument B}
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }

        It "Should return '<Expected Display>' when given array: '<Array Argument Display>'" -TestCases @(
            @{ Expected = 6.0 ; 'Array Argument' = @(3.0, -5.0, 6.0, 4.0) ;
               'Expected Display' = 6.0 ; 'Array Argument Display' = '(3.0, -5.0, 6.0, 4.0)' }
        ) {
            param($Expected, ${Array Argument}, ${Expected Display}, ${Array Argument Display})

            $ans = Get-Maximum ${Array Argument}
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    Context "Arguments are given through the Pipeline" {
        It -Pending "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 24.0 ; Argument = @(7.0, 6.0, 24.0, 20.0) ;
               'Expected Display' = 24.0 ; 'Argument Display' = '(7.0, 6.0, 24.0, 20.0)' }

            @{ Expected = 100.0 ; Argument = @(-40.0, -50.0, 0.0, 100.0) ;
               'Expected Display' = 100.0 ; 'Argument Display' = '(-40.0, -50.0, 0.0, 100.0)' }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = $Argument | Get-Maximum
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }
}

Describe "Get-Minimum" {
    Context "Arguments are given as Parameters" {
        It "Should return '<Expected Display>' when given between '<Argument A Display>' and '<Argument B Display>'" -TestCases @(
            @{ Expected = 1.0 ; 'Argument A' = 1.0 ; 'Argument B' = 4.0 ;
               'Expected Display' = 1.0 ; 'Argument A Display' = 1.0 ; 'Argument B Display' = 4.0 }

            @{ Expected = -1.0 ; 'Argument A' = 3.0 ; 'Argument B' = -1.0 ;
               'Expected Display' = -1.0 ; 'Argument A Display' = 3.0 ; 'Argument B Display' = -1.0 }
        ) {
            param($Expected, ${Argument A}, ${Argument B}, ${Expected Display}, ${Argument A Display}, ${Argument B Display})

            $ans = Get-Minimum ${Argument A} ${Argument B}
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }

        It "Should return '<Expected Display>' when given array: '<Array Argument Display>'" -TestCases @(
            @{ Expected = -5.0 ; 'Array Argument' = @(3.0, -5.0, 6.0, 4.0) ;
               'Expected Display' = -5.0 ; 'Array Argument Display' = '(3.0, -5.0, 6.0, 4.0)' }
        ) {
            param($Expected, ${Array Argument}, ${Expected Display}, ${Array Argument Display})

            $ans = Get-Minimum ${Array Argument}
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    Context "Arguments are given through the Pipeline" {
        It -Pending "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 6.0 ; Argument = @(7.0, 6.0, 24.0, 20.0) ;
               'Expected Display' = 6.0 ; 'Argument Display' = '(7.0, 6.0, 24.0, 20.0)' }

            @{ Expected = -50.0 ; Argument = @(-40.0, -50.0, 0.0, 100.0) ;
               'Expected Display' = -50.0 ; 'Argument Display' = '(-40.0, -50.0, 0.0, 100.0)' }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = $Argument | Get-Minimum
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }
}
