function New-KeyContainer {
    <#
    .SYNOPSIS
        Creates an RSA public/private key pair in the specified new container.

    .DESCRIPTION
        Creates an RSA public/private key pair in the specified new container.

    .PARAMETER Container
        Container for the RSA public/private key pair.

    .PARAMETER KeySize
        Specifies the key size in bytes. The default is 2048 bytes.
    
    .PARAMETER UserContainer
        Substitutes a user-specified container for the default machine key container.

    .PARAMETER Exportable
        Specifies that private keys must be able to be exported.

    .PARAMETER Provider
        Specifies the container provider to use.

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
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Container,

        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [Alias("size")]
        [Int]
        $KeySize,

        [Parameter(Mandatory=$false)]
        [Alias("pku")]
        [Switch]
        $UserContainer,

        [Parameter(Mandatory=$false)]
        [Alias("exp")]
        [Switch]
        $Exportable,

        [Parameter(Mandatory=$false)]
        [Alias("csp")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Provider
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In New-KeyContainer"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -pc command args"
        $arguments = "-pc `"$Container`""
        if ($KeySize -gt 0) {
            Write-Debug -Message "[$((Get-Date).ToString())]: KeySize specified"
            $arguments += " -size $KeySize"
        }
        if ($UserContainer.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: UserContainer specified"
            $arguments += " -pku"
        }
        if ($Exportable.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Exportable specified"
            $arguments += " -exp"
        }
        if (-not [String]::IsNullOrWhiteSpace($Provider)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Provider specified"
            $arguments += " -csp `"$Provider`""
        }
    }
    process {
        Invoke-AspNetRegIis -Arguments $arguments
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting New-KeyContainer"
    }
}


function Remove-KeyContainer {
    <#
    .SYNOPSIS
        Deletes the specified key container.

    .DESCRIPTION
        Deletes the specified key container.

    .PARAMETER Container
        Container for the RSA public/private key pair.
        
    .PARAMETER UserContainer
        Substitutes a user-specified container for the default machine key container.
    
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
        $Container,

        [Parameter(Mandatory=$false)]
        [Alias("pku")]
        [Switch]
        $UserContainer
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Remove-KeyContainer"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -pz command args"
        $arguments = "-pz `"$Container`""
        if ($UserContainer.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: UserContainer specified"
            $arguments += " -pku"
        }
    }
    process {
        Invoke-AspNetRegIis -Arguments $arguments
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Remove-KeyContainer"
    }
}


function Grant-KeyContainerPermission {
    <#
    .SYNOPSIS
        Grants permission for the specified user or group account to access the specified key container.

    .DESCRIPTION
        Grants permission for the specified user or group account to access the specified key container.

    .PARAMETER Container
        Container for the RSA public/private key pair.

    .PARAMETER Account
        User or group account to grant access to the specified key container.
    
    .PARAMETER UserContainer
        Substitutes a user-specified container for the default machine key container.
    
    .PARAMETER Provider
        Specifies the container provider to use.

    .PARAMETER Full
        Specifies that full access should be added (by default, access is read-only).

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
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Container,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Account,

        [Parameter(Mandatory=$false)]
        [Alias("pku")]
        [Switch]
        $UserContainer,

        [Parameter(Mandatory=$false)]
        [Alias("csp")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Provider,

        [Parameter(Mandatory=$false)]
        [Switch]
        $Full
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Grant-KeyContainerPermission"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -pa command args"
        $arguments = "-pa `"$Container`" `"$Account`""
        if ($UserContainer.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: UserContainer specified"
            $arguments += " -pku"
        }
        if (-not [String]::IsNullOrWhiteSpace($Provider)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Provider specified"
            $arguments += " -csp `"$Provider`""
        }
        if ($Full.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Full specified"
            $arguments += " -full"
        }
    }
    process {
        Invoke-AspNetRegIis -Arguments $arguments
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Grant-KeyContainerPermission"
    }
}


function Revoke-KeyContainerPermission {
    <#
    .SYNOPSIS
        Removes permission for the specified user or group account to access the specified key container.

    .DESCRIPTION
        Removes permission for the specified user or group account to access the specified key container.

    .PARAMETER Container
        Container for the RSA public/private key pair.

    .PARAMETER Account
        User or group account to revoke access to the specified key container.
    
    .PARAMETER UserContainer
        Substitutes a user-specified container for the default machine key container.
    
    .PARAMETER Provider
        Specifies the container provider to use.

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
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Container,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Account,

        [Parameter(Mandatory=$false)]
        [Alias("pku")]
        [Switch]
        $UserContainer,

        [Parameter(Mandatory=$false)]
        [Alias("csp")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Provider
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Revoke-KeyContainerPermission"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -pr command args"
        $arguments = "-pr `"$Container`" `"$Account`""
        if ($UserContainer.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: UserContainer specified"
            $arguments += " -pku"
        }
        if (-not [String]::IsNullOrWhiteSpace($Provider)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Provider specified"
            $arguments += " -csp `"$Provider`""
        }
    }
    process {
        Invoke-AspNetRegIis -Arguments $arguments
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Revoke-KeyContainerPermission"
    }
}


function Export-RSAPublicPrivateKeyPair {
    <#
    .SYNOPSIS
        Export an RSA keypair to an Xml file.

    .DESCRIPTION
        Export an RSA keypair to the Xml file.

    .PARAMETER Container
        Container for the RSA public/private key pair.
        
    .PARAMETER UserContainer
        Substitutes a user-specified container for the default machine key container.

    .PARAMETER Provider
        Specifies the container provider to use.

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
        $Container,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $File,

        [Parameter(Mandatory=$false)]
        [Alias("pku")]
        [Switch]
        $UserContainer,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("csp")]
        [String]
        $Provider
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Export-RSAPublicPrivateKeyPair"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -px command args"
        Write-Debug -Message "[$((Get-Date).ToString())]: Resolving File path"
        $resolvedFilePath = Resolve-Path -Path $File
        $arguments = "-px `"$Container`" `"$resolvedFilePath`""
        if ($UserContainer.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: UserContainer specified"
            $arguments += " -pku"
        }
        if (-not [String]::IsNullOrWhiteSpace($Provider)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Provider specified"
            $arguments += " -csp `"$Provider`""
        }
    }
    process {
        Invoke-AspNetRegIis -Arguments $arguments
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Export-RSAPublicPrivateKeyPair"
    }
}


function Import-RSAPublicPrivateKeyPair {
    <#
    .SYNOPSIS
        Creates an RSA public/private key pair in the specified container.

    .DESCRIPTION
        Creates an RSA public/private key pair in the specified container.

    .PARAMETER Container
        Container for the RSA public/private key pair.

    .PARAMETER KeySize
        Specifies the key size in bytes. The default is 2048 bytes.
    
    .PARAMETER UserContainer
        Substitutes a user-specified container for the default machine key container.

    .PARAMETER Exportable
        Specifies that private keys must be able to be exported.

    .PARAMETER Provider
        Specifies the container provider to use.

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
    [OutputType()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Container,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $File,

        [Parameter(Mandatory=$false)]
        [Alias("pku")]
        [Switch]
        $UserContainer,

        [Parameter(Mandatory=$false)]
        [Alias("exp")]
        [Switch]
        $Exportable,

        [Parameter(Mandatory=$false)]
        [Alias("csp")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Provider
    )
    begin {
        Write-Debug -Message "[$((Get-Date).ToString())]: In Import-RSAPublicPrivateKeyPair"
        Write-Verbose -Message "[$((Get-Date).ToString())]: Constructing aspnet_regiis -pi command args"
        Write-Debug -Message "[$((Get-Date).ToString())]: Resolving File path"
        $resolvedFilePath = Resolve-Path -Path $File
        $arguments = "-pi `"$Container`" `"$resolvedFilePath`""
        if ($UserContainer.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: UserContainer specified"
            $arguments += " -pku"
        }
        if ($Exportable.IsPresent) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Exportable specified"
            $arguments += " -exp"
        }
        if (-not [String]::IsNullOrWhiteSpace($Provider)) {
            Write-Debug -Message "[$((Get-Date).ToString())]: Provider specified"
            $arguments += " -csp `"$Provider`""
        }
    }
    process {
        Invoke-AspNetRegIis -Arguments $arguments
        Write-Debug -Message "[$((Get-Date).ToString())]: Exiting Import-RSAPublicPrivateKeyPair"
    }
}
