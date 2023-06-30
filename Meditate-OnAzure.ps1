# Set-PSRepository PSGallery -InstallationPolicy Trusted
# Update-Module Pester
# Install-Module Pester -Scope CurrentUser -MinimumVersion 5.0.2 -Force
# Install-Module PSKoans -Scope CurrentUser

# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
# az login
# az account list
# az account set --subscription b7445981-7fd4-4c5b-831c-41a5bc4900d0
# az bicep install
# az bicep upgrade


# https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows?view=azps-10.0.0&tabs=powershell&pivots=windows-psgallery
if (-not (Get-Module -Name Az -ListAvailable)) {
    Write-Warning "PowerShell module 'Az' not found.  Installing...`n"
    pause
    Install-Module -Name Az -Repository PSGallery -Force
    # Update-Module -Name Az -Force
}

if (-not (Test-Path "$env:USERPROFILE\.bicep")) {
    Write-Warning "Bicep CLI not found.  Installing...`n"
    pause

    # https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually
    # Create the install folder
    $installPath = "$env:USERPROFILE\.bicep"
    $installDir = New-Item -ItemType Directory -Path $installPath -Force
    $installDir.Attributes += 'Hidden'
    # Fetch the latest Bicep CLI binary
    (New-Object Net.WebClient).DownloadFile("https://github.com/Azure/bicep/releases/latest/download/bicep-win-x64.exe", "$installPath\bicep.exe")
    # Add bicep to your PATH
    $currentPath = (Get-Item -path "HKCU:\Environment" ).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
    if (-not $currentPath.Contains("%USERPROFILE%\.bicep")) { setx PATH ($currentPath + ";%USERPROFILE%\.bicep") }
    if (-not $env:path.Contains($installPath)) { $env:path += ";$installPath" }
    # Verify you can now access the 'bicep' command.
    bicep --help
    # Done!
}


$config = Get-Content "$PSScriptRoot\config.json" | ConvertFrom-Json -AsHashtable

if ((get-azcontext).subscription.id -ne $config.subscriptionId) {
    Write-Warning "Not connected to subscription '$($config.subscriptionId)'.  Authenticating...`n"
    pause

    Connect-AzAccount -Subscription $config.subscriptionId
}
# Get-AzContext -ListAvailable
# Set-AzContext

# if (-not ('KoanAttribute' -as [type])) {
    
#     Add-Type -TypeDefinition @'
# using System;

# public class KoanAttribute : Attribute
# {
#     public uint Position = UInt32.MaxValue;
#     public string Module = "_powershell";
# }
# '@
# }
$uniqueHash = (Get-FileHash -Path "$PSScriptRoot\config.json").Hash.Substring(0, 4).ToLower()
function Contemplate-AzResources {
    param($rg, $templateFile, $parameters)

    Write-Host "`nContemplating $rg" -ForegroundColor Green
    
    $existing = Get-AzResourceGroup -Name "*$rg"
    if ($null -eq $existing) {
        Write-Host "`n" -ForegroundColor Green
        New-AzResourceGroup -Location $config.location -Name $rg -Tag $config.tags -Verbose
        $existing = Get-AzResourceGroup -Name "*$rg"
    }
    
    if ($null -eq $existing.Tags["Thinking"]) {
        Write-Host "`n" -ForegroundColor Green
        New-AzResourceGroupDeployment -TemplateFile $templateFile -Name (get-date).Ticks -ResourceGroupName $rg -Verbose -TemplateParameterObject $parameters
        $existing | New-AzTag -Tag @{ Thinking = "Done" } -Verbose
    }
}

$meditations = @(
    @'
The whole moon and the entire sky
Are reflected in one dewdrop on the grass.
'@
    @'
This is how your mind is.
Its light penetrates everywhere
And engulfs everything,
So why does it not know itself?
'@
    @'
Who is hearing?
Your physical being doesn't hear,
Nor does the void.
Then what does?
'@
    @'
Mountains are merely mountains.
'@
    @'
Hell is not punishment; it is training.
'@
    @'
Do not mistake any state for
Self-realisation, but continue
To ask yourself even more intensely,
What is it that hears?
'@
    @'
The most important thing is to find out what is the most important thing.
'@
    @'
If you want to be free,
Get to know your real self.
'@
    @'
Knowledge and ignorance are interdependent;
Delusion and enlightenment condition each other.
'@
    @'
Even if you speak of the wonder of it all,
How do you deal with each thing changing?
'@
    @'
A world of dew,
And within every dewdrop
A world of struggle.
'@
    @'
When you smash the citadel of doubt,
Then the Buddha is simply yourself.
'@
    @'
I see mountains once again as mountains,
And waters once again as waters.
'@
    @'
When the many are reduced to one,
To what is the one reduced?
'@
    @'
Everything the same,
Everything distinct.
'@
    @'
Make the mountains dance.
'@
    @'
No one is injured but by himself.
'@
    @'
Each branch of coral holds up the moon.
'@
    @'
Out of nowhere, the mind comes forth.
'@
    @'
A man sits atop a hundred-foot pole; how can he go further up?
'@
    @'
A pupil in such a great hurry learns slowly.
'@
    @'
The wind does not move,
The banner does not move;
Only your mind moves.
'@
    @'
Without speaking, without silence,
How can you express the truth?
'@
    @'
Sickness and medicine correspond to each other.
The whole world is medicine.
What is the self?
'@
    @'
Choosing to raise a goose in a bottle,
How will you get it out once it is grown?
'@
    @'
Nothing is exactly as it seems, nor is it otherwise.
'@
    @'
To a mind that is still, the whole universe surrenders.
'@
    @'
To create is to see what all can see but think what none have thought.
'@
    @'
If you understand, things are just as they are.
If you do not understand, things are just as they are.
'@
    @'
Maybe you are searching among the branches,
For what only appears in the roots.
'@
    @'
The giver should be thankful.
'@
    @'
As the light of a small candle will spread from one to another in succession,
So the light of the Buddha's compassion will pass from one mind to another endlessly.
'@
    @'
To doubt the walking of the mountains means
That one does not yet know one's own walking.
'@
    @'
Grasping nothing, discarding nothing.
In every place there's no hindrance, no conflict.
My supernatural power and marvelous activity:
Drawing water and chopping wood.
'@
    @'
There's doing nothing,
And then there's doing nothing.
One blade releases
The energies of the Earth,
The other rusts in a stump.
'@
    @'
The Path of Excess
Is the exact opposite
Of the Eightfold Path.
Right View, Right Speech, Right Action...
All simple matters of scale.
'@
    @'
The oceans may rage,
But underneath the waters
The Leviathans
Frisk and frolick together
In the Land of Tranquil Light.
'@
    @'
The coin lost in the river
Is found in the river.
'@
    @'
Without speaking, without silence,
How can you express the truth?
'@
    @'
If you perceive something as not beautiful,
you're not looking long enough.
'@
    @'
In order to write good code,
you must become the code.
'@
    @'
Mind is not the Buddha,
reason is not the Way.
'@
    @'
If you want to fly,
give up everything
that weighs you down.
'@
    @'
There are two rules in life:
1. Never give out all of
the information.
'@
    @'
You are the designer
of your own catastrophe.
'@
    @'
When you realise how perfect everything is,
you will tilt your head back and laugh at the sky.
'@
    @'
If you face a problem,
it is not the problem that will detour.
'@
    @'
You only lose what you cling to.
'@
    @'
Do not dwell in the past,
do not dream of the future,
concentrate the mind on the present moment.
'@
    @'
Never fear the unknown,
thus the unknown does not fear you.
'@
    @'
Possibilities are here, there, and everywhere.
Keep your mind open to even more.
'@
    @'
The most life gives us,
often comes from failure at first.
'@
    @'
When it gets tough,
keep believing that
everything will change for the better.
'@
    @'
A light shines for everyone
who can laugh in the darkness.
'@
)

$PassedCount = 0
$koans = Get-ChildItem -Path . -Include *.Tests.ps1 -Recurse
$koans | ForEach-Object {
    $koan = $_
    $num = $koan.Name.Substring(0, 3)

    $container = New-PesterContainer -Path $koan -Data @{
        num        = $num
        location   = $config.location;
        prefix     = $config.prefix;
        uniqueHash = $uniqueHash;
        tags       = $config.tags;
    }
    $results = Invoke-Pester -Container $container -Output None -PassThru

    if ($results.FailedCount -gt 0) {
        $fail = $results.Failed[0]
        $failText = $fail.ExpandedPath -replace '\.', ' '
        $errRecord = $fail.ErrorRecord[0]
        Write-Host "`nYour karma was damaged contemplating '$failText'" -ForegroundColor Red
        Write-Host $errRecord.TargetObject.Message -ForegroundColor Red
        Write-Host "  at $($errRecord.TargetObject.File):$($errRecord.TargetObject.Line)" -ForegroundColor Red
        Write-Host $errRecord.TargetObject.LineText -ForegroundColor Red
        Write-Host @"

$($meditations | Get-Random)

"@ -ForegroundColor Blue

        exit;
    }

    $PassedCount += $results.PassedCount
}



Write-Host "`nYou have completed all $PassedCount AzKoans`n" -ForegroundColor Green
Write-Host "`nPlease delete any Azure infrastructure you no longer need`n" -ForegroundColor Yellow
Write-Host @"

“Before one studies Zen, mountains are mountains and waters are waters;
after a first glimpse into the truth of Zen, mountains are no longer mountains and waters are no longer waters;
after enlightenment, mountains are once again mountains and waters once again waters.”
― Dōgen

"@ -ForegroundColor Blue
    