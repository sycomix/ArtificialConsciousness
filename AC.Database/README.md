AC.Database — SQL Server Database Project

This folder contains a SQL Server Database Project (`.sqlproj`) with scripts to create tables and security objects used by the app. The project is intentionally _not included in the main solution_ to avoid Visual Studio showing an "Unsupported project type" when SSDT (SQL Server Data Tools) isn't installed.

Why it's excluded from the solution

- The SQL project requires SSDT to load and build in Visual Studio. Some contributors might not have SSDT installed.
- Build runners and developers that don't need to edit or build DB scripts can safely ignore the project.

How to work with the DB project

1. Install SSDT (SQL Server Data Tools) for your Visual Studio version (2017/2019/2022). See the DEVELOPER-SETUP.md for instructions.
2. To open and work with `AC.Database` in Visual Studio, add the project back to the solution:
   - Open `ArtificialConsciousness.sln` in Visual Studio.
   - Right-click the solution -> Add -> Existing Project... -> choose `AC.Database/AC.Database.sqlproj`.
3. To build and deploy the SQL project (e.g., from a local dev machine) you need SSDT installed and the appropriate publish profile.

How to deploy scripts without SSDT

- If you don't need the `.sqlproj` features (preferring direct SQL scripts), the folder contains SQL files in structured directories by schema. You can apply these scripts using `sqlcmd` or another SQL client directly to your SQL Server environment.

Using the included `deploy-sql.ps1` script

- The repository includes a helper `deploy-sql.ps1` that runs all `.sql` files via `sqlcmd`. Usage:
   - Run in PowerShell:
      - `./deploy-sql.ps1 -Server '.' -Database 'ACDatabase'` (Windows integrated auth)
      - `./deploy-sql.ps1 -Server 'localhost' -Database 'ACDatabase' -User 'sa' -Password 'Password1!'` (SQL auth)
   - `sqlcmd` must be installed and available in PATH.

CI considerations

- By default, the repository's CI skips building `AC.Database`. If you'd like CI to build or validate `AC.Database`, use a self-hosted runner or an image that has SSDT installed.

Re-adding the project to the solution is optional and intended for DB maintainers. For most contributors, it's safe to leave the project unloaded/unadded.
