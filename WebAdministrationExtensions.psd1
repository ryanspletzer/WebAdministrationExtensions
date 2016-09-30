@{
    # Script module or binary module file associated with this manifest.
    # RootModule = ''

    # Version number of this module.
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = 'bd4390dc-a8ad-4bce-8d69-f53ccf8e4163'

    # Author of this module
    Author = 'Ryan Spletzer'

    # Company or vendor of this module
    CompanyName = 'The Dow Chemical Company'

    # Copyright statement for this module
    Copyright = '(c) 2016. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Provides a set of cmdlets that wrap the RSA key management / config encryption functions of aspnet_regiis'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '4.0'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = ''

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = @(
        'Modules/Helpers.ps1',
        'Modules/KeyManagement.ps1',
        'Modules/ConfigurationEncryption.ps1'
    )

    # Functions to export from this module
    FunctionsToExport = @(
        'New-KeyContainer',
        'Remove-KeyContainer'
        'Grant-KeyContainerPermission',
        'Revoke-KeyContainerPermission',
        'Export-RSAPublicPrivateKeyPair',
        'Import-RSAPublicPrivateKeyPair',
        'Protect-IISConfigurationSection',
        'Unprotect-IISConfigurationSection',
        'Show-ProtectedIISConfigurationSection',
        'Protect-LocalConfigurationSection',
        'Unprotect-LocalConfigurationSection'
        'Show-ProtectedLocalConfigurationSection'
    )

    # Cmdlets to export from this module
    CmdletsToExport = ''

    # Variables to export from this module
    VariablesToExport = ''

    # Aliases to export from this module
    AliasesToExport = ''

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        processFilePath             = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe"
        process64FilePath           = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe"
        machineConfigFilePath       = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\config\machine.config"
        machineConfig64FilePath     = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\config\machine.config"
        aspnetRegIisErrorIdentifier = 'AspNetRegIisError'
    }

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}
