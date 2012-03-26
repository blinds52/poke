﻿ipmo poke -force

$VerbosePreference = "Continue"

function Assert-True {
    param(
        [parameter(position=0, mandatory=$true)]
        [validatenotnull()]
        [scriptblock]$Script,

        [parameter(position=1)]
        [validatenotnullorempty()]
        [string]$Name = "Assert-True"
    )    
    $eap = $ErrorActionPreference
    Write-Host -NoNewline "Assert-True [$Name] "
    try {
        $erroractionpreference = "stop"
        if ((& $script) -eq $true) {
            write-host -ForegroundColor Green "[PASS]"
            return
        }
        $reason = "Assert failed."
    }
    catch {
        $reason = "Error: $_"
    }
    finally {
        $ErrorActionPreference = $eap
    }
    write-host -ForegroundColor Red "[FAIL] " -NoNewline
    write-host $reason
}

#
# begin tests
#

assert-true {
    $proxy = peek -typename "System.Text.StringBuilder";
    ($proxy | gm | measure).count -eq 15
} -name "type proxy"

assert-true {
    $sb = new-object System.Text.StringBuilder
    $proxy = peek $sb
    ($proxy | gm | measure).count -eq 38
} -name "instance proxy"

assert-true {
    $sb = new-object System.Text.StringBuilder
    $proxy = peek $sb
    $proxy.length -eq 0
} -name "instance property"

assert-true {
    $sb = new-object System.Text.StringBuilder
    $proxy = peek $sb
    $proxy.append([system.int16]42) > $null
    $proxy.length -eq 2
} -name "instance method"

assert-true {
    $proxy = peek system.string
    $s = $proxy.format("hello, {0}", [object[]]@("world"))
    $s -eq "hello, world."
} -name "static method"

$VerbosePreference = "SilentlyContinue"