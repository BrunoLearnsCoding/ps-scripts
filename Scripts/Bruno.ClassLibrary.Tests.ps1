Import-Module D:\Projects\ps-scripts\Scripts\Bruno.ClassLibrary.psm1
import-module Pester

Describe 'Get-Instance' {
        It "Should return Car" {
            $result = Get-Instance -Car
            $result.GetType() | Should -Be Bruno.ClassLibrary.Car
        }
}