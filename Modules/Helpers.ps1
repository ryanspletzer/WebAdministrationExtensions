function New-AspNetRegIisProcess {
    <#
    .SYNOPSIS
        Creates a new aspnet_regiis.exe process with specified arguments.

    .DESCRIPTION
        Creates a new aspnet_regiis.exe process with specified arguments.

    .PARAMETER Arguments
        String representing the arguments to pass to aspnet_regiis.exe.

    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        System.Diagnostics.Process object.

    .EXAMPLE
        $arguments = "-pc 'MyContainer' -size 1024"
        New-AspNetRegIisProcess -Arguments $arguments

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding()]
    [OutputType([System.Diagnostics.Process])]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Arguments
    )
    process {
        Write-Debug -Message "[$((Get-Date).ToString())]: In New-AspNetRegIisProcess"
        $processStartInfo = New-Object -TypeName System.Diagnostics.ProcessStartInfo
        if ((Get-WmiObject Win32_OperatingSystem -ComputerName $Env:COMPUTERNAME).OSArchitecture -eq '32-bit') {
            Write-Debug -Message "[$((Get-Date).ToString())]: Getting processFilePath from Private Data"
            Write-Debug -Message "[$((Get-Date).ToString())]: $($MyInvocation.MyCommand.Module.PrivateData['processFilePath'])"
            $processStartInfo.FileName = $MyInvocation.MyCommand.Module.PrivateData['processFilePath']
        } else {
            Write-Debug -Message "[$((Get-Date).ToString())]: Getting process64FilePath from Private Data"
            Write-Debug -Message "[$((Get-Date).ToString())]: $($MyInvocation.MyCommand.Module.PrivateData['process64FilePath'])"
            $processStartInfo.FileName = $MyInvocation.MyCommand.Module.PrivateData['process64FilePath']
        }        
        $processStartInfo.RedirectStandardError = $true
        $processStartInfo.RedirectStandardOutput = $true
        $processStartInfo.UseShellExecute = $false
        $processStartInfo.Arguments = $Arguments
        $process = New-Object -TypeName System.Diagnostics.Process
        $process.StartInfo = $processStartInfo
        Write-Debug -Message "[$((Get-Date).ToString())]: Returning from New-AspNetRegIisProcess"
        return $process
    }
}


function Out-AspNetRegIisProcessResult {
    <#
    .SYNOPSIS
        Outputs information for a specified aspnet_regiis exit code.

    .DESCRIPTION
        Outputs information for a specified aspnet_regiis exit code.

    .PARAMETER ExitCode
        Exit code from the aspnet_regiis process.

    .PARAMETER StandardOutputMessage
        StandardOutput string from the aspnet_regiis process.

    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        Description of objects that are output by the script

    .EXAMPLE
        Out-AspNetRegIisProcessResult -ExitCode 0

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Int32] 
        $ExitCode,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $StandardOutputMessage
    )
    process {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Out-AspNetRegIisProcessResult"
        switch ($ExitCode) {
            0 {
                Write-Verbose -Message ("aspnet_regiis process completed successfully. Output:`n" + 
                                        "$StandardOutputMessage")
            }
            1 {
                $ErrorRecord = New-Object System.Management.Automation.ErrorRecord(
                    (New-Object Exception("aspnet_regiis.exe encountered an error with exit code " + 
                                          "$($ExitCode):`n" +
                                          "$StandardOutputMessage")),
                    $MyInvocation.MyCommand.Module.PrivateData['aspnetRegIisErrorIdentifier'],
                    [System.Management.Automation.ErrorCategory]::NotSpecified,
                    $Process
                )
                $PSCmdlet.ThrowTerminatingError($ErrorRecord)
            }
            default {
                throw ("aspnet_regiis.exe encountered an error with unknown exit code $ExitCode.`n" + 
                       "$StandardOutputMessage")
            }
        }
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Out-AspNetRegIisProcessResult"
    }
}


function Invoke-AspNetRegIis {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Arguments
    )
    process {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Invoke-AspNetRegIis"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Executing aspnet_regiis $arguments"
        $process = New-AspNetRegIisProcess -Arguments $arguments
        Write-Debug -Message "[$((Get-Date).ToString())]: Starting process"
        $process.Start() | Out-Null
        Write-Debug -Message "[$((Get-Date).ToString())]: Waiting for exit (3 second timeout)"
        $process.WaitForExit(3000) | Out-Null
        Write-Debug -Message "[$((Get-Date).ToString())]: Outputting result"
        Out-AspNetRegIisProcessResult -ExitCode $process.ExitCode -StandardOutputMessage $($Process.StandardOutput.ReadToEnd())
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Invoke-AspNetRegIis"
    }
}


function Get-CaseSensitiveFileName {
    <#
    .SYNOPSIS
        Gets the case-senstive name of the file in question.

    .DESCRIPTION
        Gets the case-senstive name of the file in question.

    .PARAMETER FilePath
        The absolute or relative path to the file.

    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        System.Diagnostics.Process object.

    .EXAMPLE
        Example of how to run the script

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FilePath
    )
    process {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Get-CaseSensitiveFileName"
        $parent = Split-Path -Path $FilePath
        $leaf = Split-Path -Path $FilePath -Leaf

        $result = Get-ChildItem -Path $parent | where Name -Like $leaf
        Write-Debug -Message "[$((Get-Date).ToString())]: Returning from Get-CaseSensitiveFileName"
        return $result.Name
    }
}


function Rename-WebConfigToTempWebConfig {
    <#
    .SYNOPSIS
        Renames a web.config file to web.temp.config, preserving case-sensitivity of the original characters.

    .DESCRIPTION
        Renames a web.config file to web.temp.config, preserving case-sensitivity of the original characters.

    .PARAMETER WebConfigFilePath
        The absolute or relative path to the web.config file.

    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        System.Diagnostics.Process object.

    .EXAMPLE
        Example of how to run the script

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $WebConfigFilePath
    )
    process {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Rename-WebConfigToTempWebConfig"
        $originalWebConfigFileName = Get-CaseSensitiveFileName -FilePath $WebConfigFilePath
        $parentDirectory = Split-Path -Path $WebConfigFilePath
        $splat = @{
            Path    = $WebConfigFilePath
            NewName = ($parentDirectory +
                       "\$($originalWebConfigFileName.Split('.')[0])" +
                       ".temp." +
                       "$($originalWebConfigFileName.Split('.')[1])")
        }
        Rename-Item @splat
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Rename-WebConfigToTempWebConfig"
    }
}


function Rename-WebTempConfigToWebConfig {
    <#
    .SYNOPSIS
        Renames a web.temp.config file to web.config, preserving case-sensitivity of the original characters.

    .DESCRIPTION
        Renames a web.temp.config file to web.config, preserving case-sensitivity of the original characters.

    .PARAMETER WebTempConfigFilePath
        The absolute or relative path to the web.temp.config file.

    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        System.Diagnostics.Process object.

    .EXAMPLE
        Example of how to run the script

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $WebTempConfigFilePath
    )
    process {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Rename-WebTempConfigToWebConfig"
        $originalWebTempConfigFileName = Get-CaseSensitiveFileName -FilePath $WebTempConfigFilePath
        $parentDirectory = Split-Path -Path $WebTempConfigFilePath
        $splat = @{
            Path    = $WebTempConfigFilePath
            NewName = ($parentDirectory + "\$($originalWebTempConfigFileName.Replace(".temp.","."))")
        }
        Rename-Item @splat
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Rename-WebTempConfigToWebConfig"
    }
}


function Rename-NonstandardConfigToWebConfig {
    <#
    .SYNOPSIS
        Renames a non-standard *.config file to web.config.

    .DESCRIPTION
        Renames a non-standard *.config file to web.config.

    .PARAMETER NonstandardConfigFilePath
        The absolute or relative path to the non-standard config file.

    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        System.Diagnostics.Process object.

    .EXAMPLE
        Example of how to run the script

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $NonstandardConfigFilePath
    )
    process {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Rename-NonstandardConfigToWebConfig"
        $originalNonstandardConfigFileName = Get-CaseSensitiveFileName -FilePath $NonstandardConfigFilePath
        $parentDirectory = Split-Path -Path $NonstandardConfigFilePath
        Rename-Item -Path $NonstandardConfigFilePath -NewName ($parentDirectory + "\web.config")
        Write-Debug -Message "[$((Get-Date).ToString())]: Returning from Rename-NonstandardConfigToWebConfig"
        return $originalNonstandardConfigFileName
    }
}


function Rename-WebConfigToNonstandardConfig {
    <#
    .SYNOPSIS
        Renames a web.config file to a specified non-standard *.config file.

    .DESCRIPTION
        Renames a web.config file to a specified non-standard *.config file.

    .PARAMETER WebConfigFilePath
        The absolute or relative path to the web.config file.

    .PARAMETER OriginalNonstandardConfigFileName
       The name of the non-standard *.config file as it was originally. 

    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        System.Diagnostics.Process object.

    .EXAMPLE
        Example of how to run the script

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $WebConfigFilePath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $OriginalNonstandardConfigFileName
    )
    process {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Rename-WebConfigToNonStandardConfig"
        $parentDirectory = Split-Path -Path $WebConfigFilePath
        Rename-Item -Path $WebConfigFilePath -NewName ($parentDirectory + "\$OriginalNonstandardConfigFileName")
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Rename-WebConfigToNonStandardConfig"
    }
}
