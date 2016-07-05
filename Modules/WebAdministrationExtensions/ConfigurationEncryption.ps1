function Protect-IISConfigurationSection {
    <#
    .SYNOPSIS
        Encrypts the configuration section of a specified website's / web app's web.config.

    .DESCRIPTION
        Encrypts the configuration section of a specified website's / web app's web.config.

    .PARAMETER Section
        The section of the config to encrypt.
        
    .PARAMETER Provider
        The provider used to encrypt. (This is a key that should be set up ahead of time.)

    .PARAMETER VirtualPath
        Encrypts at this virtual path. Virtual path must begin with a forward slash. If it is '/', then it refers
        to the root of the site. If it is not specified, the root web.config will be encrypted.

    .PARAMETER SiteNameOrId
        The site of the virtual path specified in VirtualPath parameter. If not specified, the default web site
        will be used.

    .PARAMETER SubPath
        Location of the sub path in the site to a web.config.

    .PARAMETER MachineConfigEncryption
        Encrypts the machine.config instead of web.config.
    
    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        Description of objects that are output by the script

    .EXAMPLE
        Example of how to run the script

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding(DefaultParameterSetName="None")]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Section,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("prov")]
        [String]
        $Provider,

        [Parameter(Mandatory=$false,
                   ParameterSetName="SiteSpecified")]
        [ValidateNotNullOrEmpty()]
        [Alias("app")]
        [String]
        $VirtualPath,

        [Parameter(Mandatory=$true,
                   ParameterSetName="SiteSpecified")]
        [ValidateNotNullOrEmpty()]
        [Alias("site")]
        [String]
        $SiteNameOrId,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("location")]
        [String]
        $SubPath,

        [Parameter(Mandatory=$false)]
        [Alias("pkm")]
        [Switch]
        $MachineConfigEncryption
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Protect-IISConfigurationSection"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -pe command args"
        $arguments = "-pe `"$Section`""
        if (-not [String]::IsNullOrWhiteSpace($Provider)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Provider specified"
            $arguments += " -prov `"$Provider`""
        }
        if (-not [String]::IsNullOrWhiteSpace($VirtualPath)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: VirtualPath specified"
            $arguments += " -app `"$VirtualPath`""
        }
        if (-not [String]::IsNullOrWhiteSpace($SiteNameOrId)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: SiteNameOrId specified"
            $arguments += " -site `"$SiteNameOrId`""
        }
        if (-not [String]::IsNullOrWhiteSpace($SubPath)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: SubPath specified"
            $arguments += " -location `"$SubPath`""
        }
        if ($MachineConfigEncryption.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: MachineConfigEncryption specified"
            $arguments += " -pkm `"$MachineConfigEncryption`""
        }
    }
    process {
        Invoke-AspNetRegIis -Arguments $arguments
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Protect-IISConfigurationSection"
    }
}


function Unprotect-IISConfigurationSection {
    <#
    .SYNOPSIS
        Decrypts the configuration section of a specified website's / web app's web.config.

    .DESCRIPTION
        Decrypts the configuration section of a specified website's / web app's web.config.

    .PARAMETER Section
        The section of the config to Decrypt.

    .PARAMETER VirtualPath
        Decrypts at this virtual path. Virtual path must begin with a forward slash. If it is '/', then it refers
        to the root of the site. If it is not specified, the root web.config will be decrypted.

    .PARAMETER SiteNameOrId
        The site of the virtual path specified in VirtualPath parameter. If not specified, the default web site
        will be used.

    .PARAMETER SubPath
        Location of the sub path in the site to a web.config.

    .PARAMETER MachineConfigEncryption
        Decrypts the machine.config instead of web.config.
    
    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        Description of objects that are output by the script

    .EXAMPLE
        Example of how to run the script

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding(DefaultParameterSetName="None")]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Section,

        [Parameter(Mandatory=$false,
                   ParameterSetName="SiteSpecified")]
        [ValidateNotNullOrEmpty()]
        [Alias("app")]
        [String]
        $VirtualPath,

        [Parameter(Mandatory=$true,
                   ParameterSetName="SiteSpecified")]
        [ValidateNotNullOrEmpty()]
        [Alias("site")]
        [String]
        $SiteNameOrId,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("location")]
        [String]
        $SubPath,

        [Parameter(Mandatory=$false)]
        [Alias("pkm")]
        [Switch]
        $MachineConfigEncryption
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Unprotect-IISConfigurationSection"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -pd command args"
        $arguments = "-pd `"$Section`""
        if (-not [String]::IsNullOrWhiteSpace($VirtualPath)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: VirtualPath specified"
            $arguments += " -app `"$VirtualPath`""
        }
        if (-not [String]::IsNullOrWhiteSpace($SiteNameOrId)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: SiteNameOrId specified"
            $arguments += " -site `"$SiteNameOrId`""
        }
        if (-not [String]::IsNullOrWhiteSpace($SubPath)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: SubPath specified"
            $arguments += " -location `"$SubPath`""
        }
        if ($MachineConfigEncryption.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: MachineConfigEncryption specified"
            $arguments += " -pkm `"$MachineConfigEncryption`""
        }
    }
    process {
        Invoke-AspNetRegIis -Arguments $arguments
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Unprotect-IISConfigurationSection"
    }
}


function Show-ProtectedIISConfigurationSection {
    <#
    .SYNOPSIS
        Shows the configuration of an encrypted website's / web app's web.config.

    .DESCRIPTION
        Shows the configuration of an encrypted website's / web app's web.config.

        Note the config must already be encrypted prior to running this command. If it is not encrypted already,
        running this command will encrypt it, as it first tries to decrypt the config file, then re-encrypts it
        after displaying its contents.

    .PARAMETER Section
        The section of the config to Decrypt.

    .PARAMETER VirtualPath
        Decrypts / re-encrypts at this virtual path. Virtual path must begin with a forward slash. If it is '/', 
        then it refers to the root of the site. If it is not specified, the root web.config will be decrypted / 
        re-encrypted.

    .PARAMETER SiteNameOrId
        The site of the virtual path specified in VirtualPath parameter. If not specified, the default web site
        will be used.

    .PARAMETER SubPath
        Location of the sub path in the site to a web.config.

    .PARAMETER MachineConfigEncryption
        re the machine.config instead of web.config.
    
    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        Description of objects that are output by the script

    .EXAMPLE
        Example of how to run the script

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the script does, if this is needed

    #>
    [CmdletBinding(DefaultParameterSetName="None")]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Section,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("prov")]
        [String]
        $Provider,

        [Parameter(Mandatory=$false,
                   ParameterSetName="SiteSpecified")]
        [ValidateNotNullOrEmpty()]
        [Alias("app")]
        [String]
        $VirtualPath,

        [Parameter(Mandatory=$true,
                   ParameterSetName="SiteSpecified")]
        [ValidateNotNullOrEmpty()]
        [Alias("site")]
        [String]
        $SiteNameOrId,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("location")]
        [String]
        $SubPath,

        [Parameter(Mandatory=$false)]
        [Alias("pkm")]
        [Switch]
        $MachineConfigEncryption
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Show-ProtectedIISConfigurationSection"
        Write-Verbose -Message ("[$((Get-Date).ToString())]: Constructing Splats for " + 
                                "Unprotect/Protect-IISConfigurationSection")
        $unprotectLiveConfigurationSplat = @{}
        $protectLiveConfigurationSplat = @{}
        $unprotectLiveConfigurationSplat.Add('Section', $Section)
        $protectLiveConfigurationSplat.Add('Section', $Section)
        if (-not [String]::IsNullOrWhiteSpace($Provider)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Provider specified"
            $protectLiveConfigurationSplat.Add('Provider', $Provider)
        }
        if (-not [String]::IsNullOrWhiteSpace($VirtualPath)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: VirtualPath specified"
            $unprotectLiveConfigurationSplat.Add('VirtualPath', $VirtualPath)
            $protectLiveConfigurationSplat.Add('VirtualPath', $VirtualPath)
        }
        if (-not [String]::IsNullOrWhiteSpace($SiteNameOrId)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: SiteNameOrId specified"
            $unprotectLiveConfigurationSplat.Add('SiteNameOrId', $SiteNameOrId)
            $protectLiveConfigurationSplat.Add('SiteNameOrId', $SiteNameOrId)
        }
        if (-not [String]::IsNullOrWhiteSpace($SubPath)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: SubPath specified"
            $unprotectLiveConfigurationSplat.Add('SubPath', $SubPath)
            $protectLiveConfigurationSplat.Add('SubPath', $SubPath)
        }
        if ($MachineConfigEncryption.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: MachineConfigEncryption specified"
            $unprotectLiveConfigurationSplat.Add('MachineConfigEncryption', $MachineConfigEncryption.IsPresent)
            $protectLiveConfigurationSplat.Add('MachineConfigEncryption', $MachineConfigEncryption.IsPresent)
        } else {
            Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing PSPath to web.config"
            $psPath = "IIS:\Sites\"
            if (-not [String]::IsNullOrWhiteSpace($SiteNameOrId)) {
                $result = $null
                $siteName = $SiteNameOrId
                if ([Int32]::TryParse($SiteNameOrId, [ref]$result)) {
                    $siteName = (Get-WebSite | Where Id -eq $result ).Name
                }
                $psPath += $siteName
                $psPath += $VirtualPath.Replace("/","\")
            } else {
                $psPath += "Default Web Site"
                if (-not [String]::IsNullOrWhiteSpace($VirtualPath)) {
                    $psPath += $VirtualPath.Replace("/", "\")
                }
            }
            if (-not [String]::IsNullOrWhiteSpace($SubPath)) {
                $psPath += $SubPath.Replace("/", "\")
            }
            Write-Debug -Message "[$((Get-Date).ToString())]: PSPath: $psPath"
        }
    }
    process {
        Write-Verbose -Message "[$((Get-Date).ToString())]: Decrypting config"
        Unprotect-IISConfigurationSection @unprotectLiveConfigurationSplat

        if ($MachineConfigEncryption.IsPresent) {
            $machineConfigFilePath = $MyInvocation.MyCommand.Module.PrivateData["machineConfig64FilePath"]
            if ((Get-WmiObject Win32_OperatingSystem -ComputerName $Env:COMPUTERNAME).OSArchitecture -eq '32-bit') {
                $machineConfigFilePath = $MyInvocation.MyCommand.Module.PrivateData["machineConfigFilePath"]
            }
            Write-Verbose -Message "[$((Get-Date).ToString())]: Writing lines from machine.config to host"
            ForEach ($line in (Get-Content -Path $machineConfigFilePath)) {
                Write-Host -Object $line
            }
        } else {
            Write-Verbose -Message "[$((Get-Date).ToString())]: Writing lines from web.config to host"
            ForEach ($line in (Get-Content -Path (Get-WebConfigFile -PSPath $psPath).FullName)) {
                Write-Host -Object $line
            }
        }

        Write-Verbose -Message "[$((Get-Date).ToString())]: Re-encrypting config"
        Protect-IISConfigurationSection @protectLiveConfigurationSplat
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Show-ProtectedIISConfigurationSection"
    }
}


function Protect-LocalConfigurationSection {
    <#
    .SYNOPSIS
        Encrypts the configuration section of a web.config in the specified physical directory.

    .DESCRIPTION
        Encrypts the configuration section of a web.config in the specified physical directory.

    .PARAMETER Section
        The section of the config to encrypt.

    .Parameter WebApplicationPhysicalDirectory
        The physical directory path to the application's parent folder.
        
    .PARAMETER Provider
        The provider used to encrypt. (This is a key that should be set up ahead of time.)

    .PARAMETER NonstandardConfigFileName
        Allows you to specify a nonstandard config file name besides web.config (i.e. app.config or a
        web.dev.config transform).

        Because aspnet_regiis needs the file to be named web.config, the target configuration for 
        decryption will be temporarily renamed to web.config, and renamed back to the original file 
        name (i.e. app.config, web.dev.config etc) once the encryption is complete.

        Also, the cmdlet will first check if a web.config exists in the current directory, and if it does it will 
        temporarily rename it to web.temp.config (preserving case-senstivity of the filename as it was) and rename
        it back once the encryption is complete.
    
    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        Description of objects that are output by the script

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
        $Section,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $WebApplicationPhysicalDirectory,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("prov")]
        [String]
        $Provider,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $NonstandardConfigFileName
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Protect-LocalConfigurationSection"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -pef command args"
        Write-Debug -Message "[$((Get-Date).ToString())]: Resolving WebApplicationPhysicalDirectory path"
        $WebApplicationPhysicalDirectory = Resolve-Path -Path ($WebApplicationPhysicalDirectory.Trim("\"))
        $arguments = "-pef `"$Section`" `"$WebApplicationPhysicalDirectory`""
        if (-not [String]::IsNullOrWhiteSpace($Provider)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Provider specified"
            $arguments += " -prov `"$Provider`""
        }
        
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing full paths to possible config files"
        $fullPossibleWebConfigPath = $WebApplicationPhysicalDirectory + "\web.config"
        $fullPossibleWebTempConfigPath = $WebApplicationPhysicalDirectory + "\web.temp.config"
        $fullNonstandardConfigPath = [String]::Empty
        if (-not [String]::IsNullOrWhiteSpace($NonstandardConfigFileName)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: NonstandardConfigFileName specified"
            $fullNonstandardConfigPath = ($WebApplicationPhysicalDirectory + "\$NonstandardConfigFileName")
        }
    }
    process {
        if (-not [String]::IsNullOrWhiteSpace($NonstandardConfigFileName)) {
            if (Test-Path $fullPossibleWebConfigPath) {
                Write-Verbose -Message "[$((Get-Date).ToString())]: Web.config is present, renaming to web.temp.config"
                Rename-WebConfigToTempWebConfig -WebConfigFilePath $fullPossibleWebConfigPath
            }
            Write-Verbose -Message "[$((Get-Date).ToString())]: Renaming $fullNonstandardConfigPath to web.config"
            $leafNonstandardConfigFileName = Rename-NonstandardConfigToWebConfig -NonstandardConfigFilePath $fullNonstandardConfigPath
        }

        Invoke-AspNetRegIis -Arguments $arguments
    }
    end {
        if (-not [String]::IsNullOrWhiteSpace($NonstandardConfigFileName)) {
            Write-Verbose -Message "[$((Get-Date).ToString())]: Renaming $fullPossibleWebConfigPath to $leafNonstandardConfigFileName"
            Rename-WebConfigToNonstandardConfig -WebConfigFilePath $fullPossibleWebConfigPath -OriginalNonstandardConfigFileName $leafNonstandardConfigFileName

            if (Test-Path $fullPossibleWebTempConfigPath) {
                Write-Verbose -Message "[$((Get-Date).ToString())]: Web.temp.config is present, renaming to web.config"
                Rename-WebTempConfigToWebConfig -WebTempConfigFilePath $fullPossibleWebTempConfigPath
            }
        }
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Protect-LocalConfigurationSection"
    }
}


function Unprotect-LocalConfigurationSection {
    <#
    .SYNOPSIS
        Decrypts the configuration section of a web.config in the specified physical directory.

    .DESCRIPTION
        Decrypts the configuration section of a web.config in the specified physical directory.

    .PARAMETER Section
        The section of the config to Decrypt.

    .Parameter WebApplicationPhysicalDirectory
        The physical directory path to the application's parent folder.

    .PARAMETER NonstandardConfigFileName
        Allows you to specify a nonstandard config file name besides web.config (i.e. app.config or a
        web.dev.config transform).

        Because aspnet_regiis needs the file to be named web.config, the target configuration for 
        decryption will be temporarily renamed to web.config, and renamed back to the original file 
        name (i.e. app.config, web.dev.config etc) once the decryption is complete.

        Also, the cmdlet will first check if a web.config exists in the current directory, and if it does it will 
        temporarily rename it to web.temp.config (preserving case-senstivity of the filename as it was) and rename
        it back once the decryption is complete.
    
    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        Description of objects that are output by the script

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
        $Section,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $WebApplicationPhysicalDirectory,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $NonstandardConfigFileName
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Unprotect-LocalConfigurationSection"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -pdf command args"
        Write-Debug -Message "[$((Get-Date).ToString())]: Resolving WebApplicationPhysicalDirectory path"
        $WebApplicationPhysicalDirectory = Resolve-Path -Path ($WebApplicationPhysicalDirectory.Trim("\"))
        $arguments = "-pdf `"$Section`" `"$WebApplicationPhysicalDirectory`""

        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing full paths to possible config files"
        $fullPossibleWebConfigPath = $WebApplicationPhysicalDirectory + "\web.config"
        $fullPossibleWebTempConfigPath = $WebApplicationPhysicalDirectory + "\web.temp.config"
        $fullNonstandardConfigPath = [String]::Empty
        if (-not [String]::IsNullOrWhiteSpace($NonstandardConfigFileName)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: NonstandardConfigFileName specified"
            $fullNonstandardConfigPath = ($WebApplicationPhysicalDirectory + "\$NonstandardConfigFileName")
        }
    }
    process {
        if (-not [String]::IsNullOrWhiteSpace($NonstandardConfigFileName)) {
            if (Test-Path $fullPossibleWebConfigPath) {
                Write-Verbose -Message "[$((Get-Date).ToString())]: Web.config is present, renaming to web.temp.config"
                Rename-WebConfigToTempWebConfig -WebConfigFilePath $fullPossibleWebConfigPath
            }
            Write-Verbose -Message "[$((Get-Date).ToString())]: Renaming $fullNonstandardConfigPath to web.config"
            $leafNonstandardConfigFileName = Rename-NonstandardConfigToWebConfig -NonstandardConfigFilePath $fullNonstandardConfigPath
        }

        Invoke-AspNetRegIis -Arguments $arguments
    }
    end {
        if (-not [String]::IsNullOrWhiteSpace($NonstandardConfigFileName)) {
            Write-Verbose -Message "[$((Get-Date).ToString())]: Renaming $fullPossibleWebConfigPath to $leafNonstandardConfigFileName"
            Rename-WebConfigToNonstandardConfig -WebConfigFilePath $fullPossibleWebConfigPath -OriginalNonstandardConfigFileName $leafNonstandardConfigFileName

            if (Test-Path $fullPossibleWebTempConfigPath) {
                Write-Verbose -Message "[$((Get-Date).ToString())]: Web.temp.config is present, renaming to web.config"
                Rename-WebTempConfigToWebConfig -WebTempConfigFilePath $fullPossibleWebTempConfigPath
            }
        }
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Unprotect-LocalConfigurationSection"
    }
}


function Show-ProtectedLocalConfigurationSection {
    <#
    .SYNOPSIS
        Shows the configuration of an encrypted web.config in the specified physical directory.

    .DESCRIPTION
        Shows the configuration of an encrypted web.config in the specified physical directory.

        Note the config must already be encrypted prior to running this command. If it is not encrypted already,
        running this command will encrypt it, as it first tries to decrypt the config file, then re-encrypts it
        after displaying its contents.

    .PARAMETER Section
        The section of the config to decrypt to show and re-encrypt.

    .Parameter WebApplicationPhysicalDirectory
        The physical directory path to the application's parent folder.
        
    .PARAMETER Provider
        The provider used to decrypt and re-encrypt. (This is a key that should be set up ahead of time.)

    .PARAMETER NonstandardConfigFileName
        Allows you to specify a nonstandard config file name besides web.config (i.e. app.config or a
        web.dev.config transform).

        Because aspnet_regiis needs the file to be named web.config, the target configuration for 
        decryption will be temporarily renamed to web.config, and renamed back to the original file 
        name (i.e. app.config, web.dev.config etc) once the decryption / encryption is complete.

        Also, the cmdlet will first check if a web.config exists in the current directory, and if it does it will 
        temporarily rename it to web.temp.config (preserving case-senstivity of the filename as it was) and rename
        it back once the decryption / encryption is complete.
    
    .INPUTS
        Description of objects that can be piped to the script

    .OUTPUTS
        Description of objects that are output by the script

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
        $Section,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $WebApplicationPhysicalDirectory,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("prov")]
        [String]
        $Provider,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $NonstandardConfigFileName
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Show-ProtectedLocalConfigurationSection"
        Write-Verbose -Message ("[$((Get-Date).ToString())]: Constructing Splats for " + 
                                "Unprotect/Protect-LocalConfigurationSection")
        Write-Debug -Message "[$((Get-Date).ToString())]: Resolving WebApplicationPhysicalDirectory path"
        $WebApplicationPhysicalDirectory = Resolve-Path -Path ($WebApplicationPhysicalDirectory.Trim("\"))
        $unprotectFileConfigurationSplat = @{}
        $protectFileConfigurationSplat = @{}
        $unprotectFileConfigurationSplat.Add('Section', $Section)
        $protectFileConfigurationSplat.Add('Section', $Section)
        $unprotectFileConfigurationSplat.Add('WebApplicationPhysicalDirectory',$WebApplicationPhysicalDirectory)
        $protectFileConfigurationSplat.Add('WebApplicationPhysicalDirectory',$WebApplicationPhysicalDirectory)
        if (-not [String]::IsNullOrWhiteSpace($Provider)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Provider specified"
            $protectFileConfigurationSplat.Add('Provider', $Provider)
        }
        Write-Verbose -Message ("[$((Get-Date).ToString())]: Constructing filePathToShow")
        $filePathToShow = $WebApplicationPhysicalDirectory + "\web.config"
        if (-not [String]::IsNullOrWhiteSpace($NonstandardConfigFileName)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: NonstandardConfigFileName specified"
            $unprotectFileConfigurationSplat.Add('NonstandardConfigFileName',$NonstandardConfigFileName)
            $protectFileConfigurationSplat.Add('NonstandardConfigFileName',$NonstandardConfigFileName)
            $filePathToShow = $WebApplicationPhysicalDirectory + "\$NonstandardConfigFileName"
        }
    }
    process {
        Write-Verbose -Message "[$((Get-Date).ToString())]: Decrypting $filePathToShow"
        Unprotect-LocalConfigurationSection @unprotectFileConfigurationSplat

        Write-Verbose -Message "[$((Get-Date).ToString())]: Writing lines from $filePathToShow to host"
        ForEach ($line in (Get-Content -Path $filePathToShow)) {
            Write-Host -Object $line
        }

        Write-Verbose -Message "[$((Get-Date).ToString())]: Encrypting $filePathToShow"
        Protect-LocalConfigurationSection @protectFileConfigurationSplat
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Show-ProtectedLocalConfigurationSection"
    }
}
