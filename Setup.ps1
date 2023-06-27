Set-PSRepository PSGallery -InstallationPolicy Trusted
Update-Module Pester
# Install-Module Pester -Scope CurrentUser -MinimumVersion 5.0.2 -Force
# Install-Module PSKoans -Scope CurrentUser

# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
az login
az account list
az account set --subscription b7445981-7fd4-4c5b-831c-41a5bc4900d0
az bicep install
az bicep upgrade

if ('KoanAttribute' -as [type]) {
    return
}

Add-Type -TypeDefinition @'
    using System;

    public class KoanAttribute : Attribute
    {
        public uint Position = UInt32.MaxValue;
        public string Module = "_powershell";
    }
'@
