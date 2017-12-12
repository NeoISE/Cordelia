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

Describe "Get-AreaHyperbolicCosine" {
    Context "Arguments are given as Parameters" {
        [Double]${cosh^-1(5)}  = 2.292431669561177687800787311348
        [Double]${cosh^-1(15)} = 3.4000844141133395007001872142449

        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 0.0 ; Argument = 1.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 1.0 }

            @{ Expected = ${cosh^-1(5)} ; Argument = 5.0 ;
               'Expected Display' = 'Ln(5 + SQRT(5^2 - 1))' ; 'Argument Display' = 5.0 }

            @{ Expected = ${cosh^-1(15)} ; Argument = 15.0 ;
               'Expected Display' = 'Ln(15 + SQRT(15^2 - 1))' ; 'Argument Display' = 15.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-AreaHyperbolicCosine $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-AreaHyperbolicSine" {
    Context "Arguments are given as Parameters" {
        [Double]${sinh^-1(5)}  = 2.3124383412727526202535623413644
        [Double]${sinh^-1(15)} = 3.4023066454805944933423983257817

        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = ${sinh^-1(5)} ; Argument = 5.0 ;
               'Expected Display' = 'Ln(5 + SQRT(1 + 5^2))' ; 'Argument Display' = 5.0 }

            @{ Expected = ${sinh^-1(15)} ; Argument = 15.0 ;
               'Expected Display' = 'Ln(15 + SQRT(1 + 15^2))' ; 'Argument Display' = 15.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-AreaHyperbolicSine $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-AreaHyperbolicTangent" {
    Context "Arguments are given as Parameters" {
        [Double]${tanh^-1(0.5)}  = 0.54930614433405484569762261846126
        [Double]${tanh^-1(0.15)} = 0.15114043593646680527860910696853

        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = ${tanh^-1(0.5)} ; Argument = 0.5 ;
               'Expected Display' = '( Ln( (1 + 0.5) / (1 - 0.5) ) / 2 )' ; 'Argument Display' = 0.5 }

            @{ Expected = ${tanh^-1(0.15)} ; Argument = 0.15 ;
               'Expected Display' = '( Ln( (1 + 0.15) / (1 - 0.15) ) / 2 )' ; 'Argument Display' = 0.15 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-AreaHyperbolicTangent $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-HyperbolicCosine" {
    Context "Arguments are given as Parameters" {
        [Double]${cosh(1)}  = 1.5430806348152437784779056207571
        [Double]${cosh(15)} = 1634508.68623620827081117843594

        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 1.0 ; Argument = 0.0 ;
               'Expected Display' = 1.0 ; 'Argument Display' = 0.0 }

            @{ Expected = ${cosh(1)} ; Argument = 1.0 ;
               'Expected Display' = '((e + e^(-1)) / 2)' ; 'Argument Display' = 1.0 }

            @{ Expected = ${cosh(15)} ; Argument = 15.0 ;
               'Expected Display' = '((e^15 + e^(-15)) / 2)' ; 'Argument Display' = 15.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-HyperbolicCosine $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-HyperbolicSine" {
    Context "Arguments are given as Parameters" {
        [Double]${sinh(1)}  = 1.1752011936438014568823818505956
        [Double]${sinh(15)} = 1634508.6862359023684906766101517

        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = ${sinh(1)} ; Argument = 1.0 ;
               'Expected Display' = '((e - e^(-1)) / 2)' ; 'Argument Display' = 1.0 }

            @{ Expected = ${sinh(15)} ; Argument = 15.0 ;
               'Expected Display' = '((e^15 - e^(-15)) / 2)' ; 'Argument Display' = 15.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-HyperbolicSine $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-HyperbolicTangent" {
    Context "Arguments are given as Parameters" {
        [Double]${tanh(1)}  = 0.76159415595576488811945828260479
        [Double]${tanh(15)} = 0.99999999999981284754062321402092

        It "Should return '<Expected Display>' when given '<Argument Display>'" -TestCases @(
            @{ Expected = 0.0 ; Argument = 0.0 ;
               'Expected Display' = 0.0 ; 'Argument Display' = 0.0 }

            @{ Expected = ${tanh(1)} ; Argument = 1.0 ;
               'Expected Display' = '((e - e^(-1)) / (e + e^(-1)))' ; 'Argument Display' = 1.0 }

            @{ Expected = ${tanh(15)} ; Argument = 15.0 ;
               'Expected Display' = '((e^15 - e^(-15)) / (e^15 + e^(-15)))' ; 'Argument Display' = 15.0 }
        ) {
            param($Expected, $Argument, ${Expected Display}, ${Argument Display})

            $ans = Get-HyperbolicTangent $Argument
            $ans | Should -BeOfType System.Double

            $Tolerance = $PRECISION * [Math]::Abs( $Expected )
            [Math]::Abs( $Expected - $ans ) | Should -Not -BeGreaterThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}
