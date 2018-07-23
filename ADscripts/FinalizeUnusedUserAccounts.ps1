<#PSScriptInfo

.VERSION 1.0.0

.GUID b347c6d7-2af6-4cf3-ae62-89ceece60f7e

.AUTHOR Jack Olsson

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI https://github.com/jaols/PSJumpStart

.ICONURI 

.EXTERNALMODULEDEPENDENCIES ActiveDirectory

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

#Requires -Module PSJumpStart

<#
.SYNOPSIS
    Finalize removal of unused user accounts
.DESCRIPTION
    This script will search for users disabled by DisableUnusedUserAccounts and remove them after they have been disabled for the given period.    
.PARAMETER searchRootOU
	Root OU-path for search.
.PARAMETER ADserver
    Default AD server to use for operations
.PARAMETER monthsDisabled
	The number of months a user account has not been disabled.
.PARAMETER exceptionGroup
	Do NOT touch members of this group.
.PARAMETER writeReport
    Write formatted info to CSV-file. NO ACTION WILL TAKE PLACE.

.NOTES
    Author: Jack Olsson
    Date:   2018-07-20
    
    ChangeLog:	

#>
[CmdletBinding(SupportsShouldProcess = $True)]
param (   
   [string]$searchRootOU,
   [string]$ADserver,
   [int]$monthsDisabled,   
   [string]$exceptionGroup,
   [switch]$writeReport,
   [switch]$useEventLog
)
#region local functions 
function GetLocalDefaultsFromDfpFiles($CallerInvocation) {        
    #Load script default settings
    foreach($settingsFile in (Get-SettingsFiles $CallerInvocation ".dfp")) {
        Write-Verbose "GetLocalDefaultsFromDfpFiles: [$settingsFile]"
        if (Test-Path $settingsFile) {        
            $settings = Get-Content $settingsFile
            #Enumerate settingsfile rows
            foreach($row in $settings) {
                #Remarked lines are not processed
                if (($row -match "=") -and ($row.Trim().SubString(0,1) -ne "#")) {
                    $key = $row.Split('=')[0]                            
                    $var = Get-Variable $key -ErrorAction SilentlyContinue
                    if ($var -and !($var.Value))
                    {
                        try {                                            
                            $var.Value = Invoke-Expression $row.SubString($key.Length+1)
                            Write-Verbose "GetLocalDefaultsFromDfpFiles: $key = $($var.Value)" 
                        } Catch {
                            $ex = $PSItem
                            $ex.ErrorDetails = "Err adding $key from $settingsFile. " + $PSItem.Exception.Message
                            throw $ex
                        }
                    }                   
                }
            }
        }
    }
}

function KillUser($userObject) {
	Msg "Kill user: $($userObject.SamAccountName)"
	
	if ($pscmdlet.ShouldProcess("$($userObject.SamAccountName)", "Kill user")) {		
        
        if (Test-Path $($userObject.HomeDirectory)) {
		    #Remove home folder
            Write-Verbose "KillUser:Remove folder $($userObject.HomeDirectory)"
            Remove-Item -Path $($userObject.HomeDirectory) -Force
        }

        if (Test-Path $($userObject.ProfilePath)) {
            #Remove profile folder
            Write-Verbose "KillUser:Remove folder $($userObject.ProfilePath)"
            Remove-Item -Path $($userObject.ProfilePath) -Force
        }
        
        #Kill AD-object
        Write-Verbose "KillUser:Remove user $($userObject.distinguishedName)"
        Remove-ADUser -Identity $userObject

    }	 
}

function GetDateDisabled($inputString) {
    
    if ($inputstring -match "(Disabled \[)(.*)(\].*)") {
        $result = Get-Date($Matches[2])
    } else {
        $result = Get-Date
    }

    Write-Verbose "GetDateDisabled:$result <- $inputString"
    $result
}

function ReportData($userObject, $csvFile, $separator) {
	Write-Verbose "Export user $($userObject.SamAccountName) last logged on $logonTime"
	$row = ""
	ForEach($prop in $PropertiesToGet) {
		#Write-Host $prop
		if ($userObject.$prop) {
			if ($userObject.$prop.GetType().Name -eq "Int64") {
				$time = TimeFromInteger $($userObject.$prop)
				$row += $time.ToString() + $separator
			} else {
				$row += $($userObject.$prop).ToString() + $separator
			}
		} else {
			$row += $separator
		}
	}
	
	$row | Out-File -Append -FilePath $csvFile	
}
function TimeFromInteger {
	Param(
	 [parameter(mandatory=$true)]
	 $TimeStamp
    )

    [datetime]::FromFileTime($TimeStamp)
}

function TimeToInteger {
	Param(
	 [parameter(mandatory=$true)]
	 [DateTime]$TimeStamp
    )

    $TimeStamp.ToFileTime()
}
#endregion

#region Init
$CSVseparator = ";"
$PropertiesToGet = @("samAccountName","Comment","HomeDirectory","ProfilePath")
 
$reportFile = "$_scriptPath\$_scriptName - " + (Get-Date -Format 'yyyyMMdd HHmmss') + ".csv"

if (-not (Get-Module ActiveDirectory)) {
    Import-Module ActiveDirectory
}
if (-not (Get-Module PSJumpStart)) {
    Import-Module PSJumpStart
}

#Get Local variable default values from external DFP-files
GetLocalDefaultsFromDfpFiles($MyInvocation)

#Get global deafult settings when calling modules
$PSDefaultParameterValues = Get-GlobalDefaultsFromDfpFiles $MyInvocation -Verbose:$VerbosePreference

#endregion


Msg "Start Execution"
#Prevent disaster if dfp-file is missing
if ([string]::IsNullOrEmpty($monthsDisabled) -or $monthsDisabled -eq 0) {
    Msg "Please create a dfp file for standard values."
    $monthsDisabled = 200
}

[datetime]$unusedTime = (Get-Date).AddMonths(-$monthsDisabled)
Write-Verbose "Get users disabled since $unusedTime"

if (![string]::IsNullOrEmpty($exceptionGroup)) {
	$untouchables = Get-ADGroupMember -Identity $exceptionGroup -Recursive | Select -ExpandProperty samAccountName
}

$filter = {Enabled -eq $false -and comment -like "Disabled [*" -and comment -like "*due to last logon*"}

#Prepare report header
if ($writeReport) {
	Msg "Write report to $reportFile"
	$row=""
	ForEach($prop in $PropertiesToGet) {
		$row += $prop + ";"
	}
	$row | Out-File -FilePath $reportFile -Force	
}

Msg "User filter $filter"
if ([string]::IsNullOrEmpty($searchRootOU)) {
	#Get-ADUser -LDAPFilter $filter -Properties $PropertiesToGet | % {
	Get-ADUser -Filter $filter -Properties $PropertiesToGet | % {		
		if ($untouchables -notcontains $($_.SamAccountName)) {
            $disabledDate = GetDateDisabled $($_.Comment)
            if ($disabledDate -lt $unusedTime) {
			    if ($writeReport) {
			    	ReportData $_ $reportFile
			    } else {
			    	KillUser $_
			    }
            }
		}
	}
} else {
	Get-ADUser -Filter $filter -Properties $PropertiesToGet -SearchBase $searchRootOU | % {
		if ($untouchables -notcontains $($_.SamAccountName)) {
			if ($writeReport) {
				ReportData $_ $reportFile
			} else {
				$_.SamAccountName 
				$_.comment
				KillUser $_ 				
			}
		}
	}
}


Msg "End Execution"
