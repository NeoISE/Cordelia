#Requires -Version 3
Set-StrictMode -Version Latest

Describe "Get-Maximum" {
    Context "Arguments are given as Parameters" {
        It "Should return 4 when given 1 and 4 as arguments" {
            Get-Maximum 1 4 | Should -Be 4
        }

        It "Should return 3 when given 3 and -1 as arguments" {
            Get-Maximum 3 -1 | Should -Be 3
        }

        It "Should not return 2 when given 2 and 10 as arguments" {
            Get-Maximum 2 10 | Should -Not -Be 2
        }

        It "Should return 6 when given an array containing 0,3,4,6 (not in numeric ordering)" {
            Get-Maximum 3,0,6,4 | Should -Be 6
        }
    }

    Context "Arguments are given through the Pipeline" {
        It "Should return 24 when given inputs: 7 6 24 20" {
            7,6,24,20 | Get-Maximum | Should -Be 24
        }

        It "Should not return -50 when given inputs: -40 -50 0 100" {
            -40,-50,0,100 | Get-Maximum | Should -Not -Be -50
        }
    }
}

Describe "Get-Minimum" {
    Context "Arguments are given as Parameters" {
        It "Should return 1 when given 1 and 4 as arguments" {
            Get-Minimum 1 4 | Should -Be 1
        }

        It "Should return -1 when given 3 and -1 as arguments" {
            Get-Minimum 3 -1 | Should -Be -1
        }

        It "Should not return 10 when given 2 and 10 as arguments" {
            Get-Minimum 2 10 | Should -Not -Be 10
        }

        It "Should return 0 when given an array containing 0,3,4,6 (not in numeric ordering)" {
            Get-Minimum 3,0,6,4 | Should -Be 0
        }
    }

    Context "Arguments are given through the Pipeline" {
        It "Should return 6 when given inputs: 7 6 24 20" {
            7,6,24,20 | Get-Minimum | Should -Be 6
        }

        It "Should not return 0 when given inputs: -40 -50 0 100" {
            -40,-50,0,100 | Get-Minimum | Should -Not -Be 0
        }
    }
}
