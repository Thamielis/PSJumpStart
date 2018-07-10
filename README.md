# PSJumpStart
PowerShell Jumpstart module
[TOC]

## Introduction

The PowerShell PSJumpStart module uses the built-in features in PowerShell to create an environment for the Power Administrator. It is a set of files to jump start PowerShell script creation as well as some ready to use functions.

## Features and content

PSJumpstart uses `$PSDefaultParameterValues` to set local default parameters by using `dfp` files. These are read in a preset order so you may have different defaults for different scenarios.

The package contains one main `psm1` file and a preloaded empty customizable `psm1` file for local usage. One of the core functions in the `PSJumpStart.psm1` file is the `Msg`-function for showing/logging information. A leaf script may call this function but result in different outputs depending on settings or argument use. 

A set of template files is provided to jump start script creation. The templates comes in two main flavors, PSJumpStart and Basic. The basic templates does not load the module and may act as stand alone scripts while the PSJumpStart templates is using the included module. The templates are  `Get-Help` enabled. 

A template `CMD` file is also provided for calling PowerShell scripts with `StdOut` and `StdErr` capturing.  The primary intended use is launching PS-scripts from Task Scheduler as unhandled errors cannot be traced otherwise. It is a generic template and may be used to launch any PowerShell script.

Some fully featured test/sample scripts are included for reference.

One sample `ps1xml` file is included for enhancing the `HashTable` variable.

## Why?

Because we are system administrators that just want to get going with PowerShell using basic supporting functions for common use.

Because we want a jump start for writing a script with `Get-Help` support.

Because we want to be able to copy a script from one environment to another without the need to change them making code signing easier (or less of a hassle).

Because we want to choose how output (messages, verbose and errors) are handled for each site and/or environment without rewriting the scripts. Log to windows eventlog, a log file or only to `StdOut`?

Because we want to be able to set default parameters depending on user, domain or script but be able to override these default parameters by using script arguments. 

Because we want to choose the depth of the PowerShell rabbit hole. Entry level to deep-sea diving.

## Practical usage

Have a look in the `PSJumpStart.dfp`file (in the module folder) using a text editor. Those are the least significant default settings. Use them to set your preferred configuration.

To debug your script as well as get `Write-Verbose`printouts from ALL used modules and functions;

1. Create a `dfp`file with the same name as your script
2. Put `*:Verbose=$true`in it.
3. Run the script to load `Verbose` mode in current session.

### The templates

In the `Templates`folder (living in the module folder) is a set of templates. Copy these to your preferred working space.

## Down the rabbit hole

Let's have a quick look at some of the main features in the package. 

### `$PSDefaultParameterValues`

The use of `pfd` files separates default parameters from the PowerShell scripts. The `dfp` files are loaded in a preset order where the first encountered setting is used. So user preference will override the default settings for the `psm1` module file. The preset order is defined in the `Get-SettingFiles` function. The `Get-GlobalDefaultsFromDfpFiles` populates the PowerShell variable from file content.

 As the `$PSDefaultParameterValues` may be set for all functions it is possible for `Write-Verbose` to present output from functions in `psm1` modules without typing `-Verbose:$VerbosePrefererence` in ALL function calls or the use of `Get-CallerPreference` command (which by the way is included for reference):

[The story behind the `Get-CallerPreference`function](https://blogs.technet.microsoft.com/heyscriptingguy/2014/04/26/weekend-scripter-access-powershell-preference-variables/)

[The code source](https://gallery.technet.microsoft.com/scriptcenter/Inherit-Preference-82343b9d)

More information on the use of `$PSDefaultParameterValus`:
[The Microsoft Docs Tale](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_parameters_default_values?view=powershell-6)

[Some practical usage samplings](https://www.red-gate.com/simple-talk/sysadmin/powershell/powershell-time-saver-automatic-defaults)


### The `Msg` function

The unified way of writing output information from calling scripts. Do not call this function from any `psm1` functions as it does not support nested environments (yet). Use `Write-Verbose` to debug `psm1` functions instead. 

### The `$CallerInvocation` story

To ensure correct environment the `$CallerInvocation` is used as input parameter by some functions in the `psm1`file. The input should be `$MyInvocation`of the root caller script.

[Some words on the PowerShell module environment](https://www.red-gate.com/simple-talk/dotnet/.net-tools/further-down-the-rabbit-hole-powershell-modules-and-encapsulation/)

### Notes

[A nice article on the practical use of CustomObjects in PowerShell](https://social.technet.microsoft.com/wiki/contents/articles/7804.powershell-creating-custom-objects.aspx)

[The inspiration for enhancing the `Hashtable` object type by using a `ps1xml` file](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_types.ps1xml?view=powershell-6)

## Stolen with pride

Some of the functions included has been found “out-there”. The author name and/or a link to the source is provided to give credit where credit is due.

There are some references in the `Get-Help`notes section for some of the basic functions to dive deeper into the rabbit hole.

## Contribute

Please feel free to suggest improvements or contribute with basic functions. As the end line from the movie `The Matrix` puts it:

"A world where anything is possible. Where we go from there is a choice I leave to you."

Keep up the good work.
