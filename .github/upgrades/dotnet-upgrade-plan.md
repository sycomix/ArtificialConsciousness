# .NET 8.0 Upgrade Plan

## Execution Steps

Execute steps below sequentially one by one in the order they are listed.

1. Validate that an .NET 8.0 SDK required for this upgrade is installed on the machine and if not, help to get it installed.
2. Ensure that the SDK version specified in global.json files is compatible with the .NET 8.0 upgrade.
3. Upgrade AC.DAL\AC.DAL.csproj
4. Upgrade AC.BLL.Models\AC.BLL.Models.csproj
5. Upgrade AC.BLL\AC.BLL.csproj
6. Upgrade AC.Common\AC.Common.csproj
7. Upgrade AC.Desktop.Controls\AC.Desktop.Controls.csproj
8. Upgrade ArtificialConsciousness\AC.Environment.csproj
9. Upgrade AC.Tests\AC.Tests.csproj
10. Upgrade AC.Desktop.Main\AC.Desktop.Main.csproj
11. Upgrade ArtificialConsciousnessAgnets\AC.Agnets.csproj
12. Upgrade ACConsoleApp\AC.ConsoleApp.csproj

## Settings

This section contains settings and data used by execution steps.

### Excluded projects

Table below contains projects that do belong to the dependency graph for selected projects and should not be included in the upgrade.

| Project name                                   | Description                 |
|:-----------------------------------------------|:---------------------------:|
|                                               |                             |

### Aggregate NuGet packages modifications across all projects

NuGet packages used across all selected projects or their dependencies that need version update in projects that reference them.

| Package Name                        | Current Version | New Version | Description                                   |
|:------------------------------------|:---------------:|:-----------:|:----------------------------------------------|
| ControlzEx                          |   3.0.2.4       |  6.0.0      | NuGet package is incompatible                  |
| EntityFramework                     |   6.2.0         |  6.5.1      | NuGet package upgrade is recommended           |
| MahApps.Metro                       |   1.6.5         |  2.4.11     | NuGet package is incompatible                  |
| MahApps.Metro.Resources             |   0.6.1.0       |  0.6.1      | NuGet package is deprecated                    |
| System.Runtime.CompilerServices.Unsafe |   4.5.2         |  6.1.2      | NuGet package upgrade is recommended           |
| System.ValueTuple                   |   4.5.0         |             | Package functionality included with new framework reference |

### Project upgrade details
This section contains details about each project upgrade and modifications that need to be done in the project.

#### AC.DAL\AC.DAL.csproj modifications

Project properties changes:
  - Target framework should be changed from .NETFramework,Version=v4.6.1 to net8.0

NuGet packages changes:
  - EntityFramework should be updated from 6.2.0 to 6.5.1 (NuGet package upgrade is recommended)

Feature upgrades:

Other changes:

#### AC.BLL.Models\AC.BLL.Models.csproj modifications

Project properties changes:
  - Target framework should be changed from .NETFramework,Version=v4.6.1 to net8.0

NuGet packages changes:

Feature upgrades:

Other changes:

#### AC.BLL\AC.BLL.csproj modifications

Project properties changes:
  - Target framework should be changed from .NETFramework,Version=v4.6.1 to net8.0

NuGet packages changes:
  - System.ValueTuple should be removed (Package functionality included with new framework reference)

Feature upgrades:

Other changes:

#### AC.Common\AC.Common.csproj modifications

Project properties changes:
  - Target framework should be changed from .NETFramework,Version=v4.6.1 to net8.0

NuGet packages changes:
  - EntityFramework should be updated from 6.2.0 to 6.5.1 (NuGet package upgrade is recommended)
  - System.Runtime.CompilerServices.Unsafe should be updated from 4.5.2 to 6.1.2 (NuGet package upgrade is recommended)
  - System.ValueTuple should be removed (Package functionality included with new framework reference)

Feature upgrades:

Other changes:

#### AC.Desktop.Controls\AC.Desktop.Controls.csproj modifications

Project properties changes:
  - Target framework should be changed from .NETFramework,Version=v4.6.1 to net8.0-windows

NuGet packages changes:
  - ControlzEx should be updated from 3.0.2.4 to 6.0.0 (NuGet package is incompatible)
  - MahApps.Metro should be updated from 1.6.5 to 2.4.11 (NuGet package is incompatible)

Feature upgrades:

Other changes:

#### ArtificialConsciousness\AC.Environment.csproj modifications

Project properties changes:
  - Target framework should be changed from .NETFramework,Version=v4.6.1 to net8.0

NuGet packages changes:

Feature upgrades:

Other changes:

#### AC.Tests\AC.Tests.csproj modifications

Project properties changes:
  - Target framework should be changed from net461 to net8.0

NuGet packages changes:

Feature upgrades:

Other changes:

#### AC.Desktop.Main\AC.Desktop.Main.csproj modifications

Project properties changes:
  - Target framework should be changed from .NETFramework,Version=v4.6.1 to net8.0-windows

NuGet packages changes:
  - ControlzEx should be updated from 3.0.2.4 to 6.0.0 (NuGet package is incompatible)
  - EntityFramework should be updated from 6.2.0 to 6.5.1 (NuGet package upgrade is recommended)
  - MahApps.Metro.Resources should be updated from 0.6.1.0 to 0.6.1 (NuGet package is deprecated)
  - System.Runtime.CompilerServices.Unsafe should be updated from 4.5.2 to 6.1.2 (NuGet package upgrade is recommended)
  - System.ValueTuple should be removed (Package functionality included with new framework reference)

Feature upgrades:

Other changes:

#### ArtificialConsciousnessAgnets\AC.Agnets.csproj modifications

Project properties changes:
  - Target framework should be changed from .NETFramework,Version=v4.6.1 to net8.0

NuGet packages changes:

Feature upgrades:

Other changes:

#### ACConsoleApp\AC.ConsoleApp.csproj modifications

Project properties changes:
  - Target framework should be changed from .NETFramework,Version=v4.6.1 to net8.0

NuGet packages changes:
  - EntityFramework should be updated from 6.2.0 to 6.5.1 (NuGet package upgrade is recommended)

Feature upgrades:

Other changes: