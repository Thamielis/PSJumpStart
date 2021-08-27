#
# Module manifest for module 'PSJumpStart'
#
# Generated by: Jack Olsson
#
# Generated on: 2018-07-04
#
# 1.0.2
# -----
# Correction for Verbose argument override by Get-GlobalDefaultsFromDfpFiles
# "Template" for self-signing PowerShell scripts. 
#
# 1.0.3
# -----
# Correction of file logging in MSG-function
# Improved PSJumpStart templates
# Write-Verbose included in the dfp file processing.
# Improved ScriptSigner.ps1 
# 
# 1.0.4
# -----
# Improved description.
# Improved AppendValue method for Hastable type add-on in ps1xml 
#
# 1.0.5
# -----
# Small bug correction in the Get-GlobalDefaultsFromDfpFiles
# New function Send-MailMessageUsingHtmlTemplate
# EPS template implementation planned but not in play yet
# Improved documentation ReadMe.md
# 
# 1.1.0
# -----
# Code structure change and naming cleanup. Separate ps1-files for each function.
#
# Renamed functions:
# ExportDataTableToFile -> Out-DataTableToFile
# QuerySQL -> Invoke-SqlQuery
# 
# Correction and cleanup in the ps1xml file for the HashTable extension methods.
# Improved Send-MailMessageUsingHtmlTemplate function.
#
# 1.1.1
# ------
# Msg-function will now support both Eventlog-writing AND File-log writing. If non is used it will 
# send output to Std-out and Std-Err to be captured by calling entity.
#
# 1.1.2
#-------
# Improved documentation. Support for array argument input when running PS-files from generic CMD-file.
# Small changesd in test-code.
#
# 1.2.0
#-------
#Added support for JSON setting files along with the DFP-files. 
#
# 1.2.1
#-------
#New function for handling credentials - Get-AccessCredential
#
@{

# Script module or binary module file associated with this manifest.
RootModule = '.\PSJumpStart.psm1'

# Version number of this module.
ModuleVersion = '1.2.1'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'd21b1c94-e492-42ac-abd7-e5bedf2a23dc'

# Author of this module
Author = 'Jack Olsson'

# Company or vendor of this module
CompanyName = 'jGO Solutions AB'

# Copyright statement for this module
Copyright = '(c)2018-2021 jGO Solutions AB'

# Description of the functionality provided by this module
Description = 'The PowerShell PSJumpStart module uses the built-in features in PowerShell to create an environment for the Power Administrator. It is a set of files to jump start PowerShell script creation as well as some ready to use functions. The goal is to provide some simple start-up functions. Please visit the project site for documentation'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @("PSJumpStart.ps1xml")

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = 'PSJumpStart.ps1xml'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = '*'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = '*'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @("Jumpstart","Admin","Administration","Tools","Templates","SendMail")

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/jaols/PSJumpStart'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
