# AzKoans

These Koans were inspired by a long line of projects that used unit test frameworks to learn languages and techniques.  I think the first were the Ruby Koans.  These borrow from the PowerShell Koans by vexx32.

The focus of these Koans is to learn about Azure infrastructure.  Each Koan will deploy a corresponding resource group (e.g. `114-AboutAdvisor.Tests.ps1` will create `jpvant-114-b451`) and deploy something up to Azure in the corresponding Bicep file (e.g. 114.bicep).  Then the Koan will make assertions using the Pester testing framework and you need to fill in the blanks to keep moving forward.

## Study Material

These Koans prepare the learner for the AZ-305 exam on Azure Infrastructure.  They don't cover everything but they're still more fun than, uh, other approaches.

Microsoft has a certification for [Azure architecture](https://learn.microsoft.com/en-us/certifications/azure-solutions-architect/) and a [learning path](https://learn.microsoft.com/en-us/training/paths/microsoft-azure-architect-design-prerequisites/).

PluralSight also has paths for [AZ-303](https://app.pluralsight.com/paths/certificate/microsoft-azure-architect-technologies-az-303) and [AZ-304](https://app.pluralsight.com/paths/certificate/microsoft-azure-architect-design-az-304) that covers the same material.

Microsoft has a [study guide](https://learn.microsoft.com/en-us/certifications/resources/study-guides/AZ-305) with the current requirements.

## Setup

First, edit the `config.json` so that it has your personal details.  You'll need a subscription and either some credits or a credit card.  Microsoft has one month free at the moment as well as student credits and credits for developers with Visual Studio subscriptions.

Run the `Meditate-OnAzure.ps1` script.  That _should_ install all the dependencies.  If not, uh, you're a smart cookie and I trust you to figure it out.

The first test should fail.  Just replace the `$____` parameter with the correct answer and re-run the meditaiton script.

If you get stuck, you can try setting a breakpoint on that line and attaching a debugger.  My favorite way to do this (also the only way I know) is to click that line in VS Code then press F5 when the focus is on the meditate script.  The PowerShell extension should do the rest.

## Creation and Destruction

Each koan will create new infrastructure in Azure.  All of the koans will run more quickly on repeated tries if the infra is already deployed but that _can_ cost money.  If you'd like to spend more time (and less money) you can edit the section at the bottom of each koan to destroy the resource group and all its resources once you've finished all the questions.
