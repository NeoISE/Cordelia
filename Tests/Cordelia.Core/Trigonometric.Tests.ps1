#Requires -Version 3
Set-StrictMode -Version Latest

# We cannot compare doubles directly
# So it is wise to compare the absolute difference of expected and actual instead
# Thus, 'equality' becomes 'less than' and 'not equals' becomes 'greater than'
[Double]$Tolerance = [Math]::Pow(10, -15)

[Double]$PI = [Math]::PI
[Double]${PI Halves} = 1.5707963267948966192313216916398
[Doulbe]${Negative PI Halves} = -1.5707963267948966192313216916398
[Double]${Two PI} = 6.283185307179586476925286766559

Describe "Get-ArcCosine" {
    Context "Arguments are given as Parameters" {
        It "Should return 'PI' when given -1 as an argument" {
            $ans = Get-ArcCosine -1
            [Math]::Abs( $ans - $PI ) | Should -BeLessThan $Tolerance
        }

        It "Should return '0' when given 1 as an argument" {
            $ans = Get-ArcCosine 1
            [Math]::Abs( $ans ) | Should -BeLessThan $Tolerance
        }

        It "Should return 'PI/2' when given 0 as an argument" {
            $ans = Get-ArcCosine 0
            [Math]::Abs( $ans - ${PI Halves} ) | Should -BeLessThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-ArcSine" {
    Context "Arguments are given as Parameters" {
        It "Should return 'PI/2' when given 1 as an argument" {
            $ans = Get-ArcSine 1
            [Math]::Abs( $ans - ${PI Halves}) | Should -BeLessThan $Tolerance
        }

        It "Should return '0' when given 0 as an argument" {
            $ans = Get-ArcSine 0
            [Math]::Abs( $ans ) | Should -BeLessThan $Tolerance
        }

        It "Should return '-(PI/2)' when given -1 as an argument" {
            $ans = Get-ArcSine -1
            [Math]::Abs( $ans - ${Negative PI Halves} ) | Should -BeLessThan $Tolerance
        }

        It "Should return '(PI/4)' when given '(SQRT(2) / 2)' as an argument" {
            ${PI Fourth} = 0.78539816339744830961566084581988
            ${Sqrt Two} = 1.4142135623730950488016887242097

            $ans = Get-ArcSine ( ${Sqrt Two} / 2.0 )
            [Math]::Abs( $ans - ${PI Fourth} ) | Should -BeLessThan $Tolerance
        }

        It "Should return '(PI/6)' when given '(1/2)' as an argument" {
            ${PI Sixth} = 0.52359877559829887307710723054658

            $ans = Get-ArcSine 0.5
            [Math]::Abs( $ans - ${PI Sixth} ) | Should -BeLessThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}

Describe "Get-ArcTangent" {
    Context "Arguments are given as Parameters; 'Ratio' ParameterSet" {
        It "Should return 0 when given 0 as an argument" {
            $ans = Get-ArcTangent 0
            [Math]::Abs( $ans ) | Should -BeLessThan $Tolerance
        }

        It "Should return '(PI/4)' when given 1 as an argument" {
            ${PI Fourth} = 0.78539816339744830961566084581988

            $ans = Get-ArcTangent 1
            [Math]::Abs( $ans - ${PI Fourth} ) | Should -BeLessThan $Tolerance
        }

        It "Should return '-(PI/3)' when given '-SQRT(3)' as an argument" {
            ${Negative Sqrt Three} = -1.7320508075688772935274463415059
            ${Negative PI Third} = -1.0471975511965977461542144610932

            $ans = Get-ArcTangent ${Negative PI Third}
            [Math]::Abs( $ans - ${Negative Sqrt Three} ) | Should -BeLessThan $Tolerance
        }
    }

    Context "Arguments are given as Parameters; 'Point' ParameterSet" {
        It "Should return 0 when given Cartesian Points: X = 0 and Y = 0" {
            $ans = Get-ArcTangent -X 0 -Y 0
            [Math]::Abs( $ans ) | Should -BeLessThan $Tolerance
        }

        It "Should return '(PI/4)' when given Cartesian Points: X = 1 and Y = 1" {
            ${PI Fourth} = 0.78539816339744830961566084581988

            $ans = Get-ArcTangent -X 1 -Y 1
            [Math]::Abs( $ans - ${PI Fourth} ) | Should -BeLessThan $Tolerance
        }

        It "Should return '(PI/2)' when given Cartesian Points: X = 0 and Y = 1" {
            $ans = Get-ArcTangent -X 0 -Y 1
            [Math]::Abs( $ans - ${PI Halves} ) | Should -BeLessThan $Tolerance
        }

        It "Should return '(2 * PI/3)' when given Cartesian Points: X = -1 and Y = SQRT(3)" {
            ${Two PI Thirds} = 2.0943951023931954923084289221863
            ${Sqrt Three} = 1.7320508075688772935274463415059

            $ans = Get-ArcTangent -X -1 -Y ${Sqrt Three}
            [Math]::Abs( $ans - ${Two PI Thirds} ) | Should -BeLessThan $Tolerance
        }

        It "Should return PI when given Cartesian Points: X = -1 and Y = 0" {
            $ans = Get-ArcTangent -X -1 -Y 0
            [Math]::Abs( $ans - $PI ) | Should -BeLessThan $Tolerance
        }

        It "Should return '(-5 * PI/6)' when given Cartesian Points: X = -SQRT(3) and Y = -1" {
            ${Negative Five PI Sixths} = -2.6179938779914943653855361527329
            ${Negative Sqrt Three} = -1.7320508075688772935274463415059

            $ans = Get-ArcTangent -X ${Negative Sqrt Three} -Y -1
            [Math]::Abs( $ans - ${Negative Five PI Sixths} ) | Should -BeLessThan $Tolerance
        }

        It "Should return '(-PI/2)' when given Cartesian Points: X = 0 and Y = -1" {
            $ans = Get-ArcTangent -X 0 -Y -1
            [Math]::Abs( $ans - ${Negative PI Halves} ) | Should -BeLessThan $Tolerance
        }

        It "Should return '(-PI/3)' when given Cartesian Points: X = 1 and Y = -SQRT(3)" {
            ${Negative PI Third} = -1.0471975511965977461542144610932
            ${Negative Sqrt Three} = -1.7320508075688772935274463415059

            $ans = Get-ArcTangent -X 1 -Y ${Negative Sqrt Three}
            [Math]::Abs( $ans - ${Negative PI Third} ) | Should -BeLessThan $Tolerance
        }
    }

    #Context "Arguments are given through the Pipeline" {
    #
    #}
}
