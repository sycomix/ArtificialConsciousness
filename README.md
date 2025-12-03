See `DEVELOPER-SETUP.md` for more developer setup instructions and troubleshooting (SSDT, CI behavior, DB project handling).

# ArtificialConsciousness

A desktop program which tries to mimic human knowledge representation and creates a semantic network.

Basic developer instructions:

- Restore NuGet packages:
  - `nuget restore .\ArtificialConsciousness.sln`
- Build (PowerShell):
  - `msbuild .\ArtificialConsciousness.sln /p:Configuration=Debug`
- Run the desktop app from Visual Studio or run:
  - `& .\AC.Desktop.Main\bin\Debug\AC.Desktop.Main.exe`
- Run the console app (quick DB manipulations):
  - `& .\ACConsoleApp\bin\Debug\AC.ConsoleApp.exe`

Database:

- Default EF connection string name: `ACDatabaseEntities` in `AC.DAL/App.config`.
- The `AC.Database` SQL project contains schema and table creation scripts. Use Visual Studio database tools to deploy to a local SQL Server (default connection uses data source `.` and `ACDatabase`).
  - Note: `AC.Database` is intentionally excluded from the main solution by default to avoid an "Unsupported project type" message in Visual Studio if SQL Server Data Tools (SSDT) isn't installed. See `DEVELOPER-SETUP.md` to learn how to re-add it if you need it.

Tips if Visual Studio reports "Unsupported" or cannot open `AC.Database`:

- This project is a SQL Server Database Project (`.sqlproj`) and requires SQL Server Data Tools (SSDT) / the SQL Database Projects extension for your Visual Studio version.
- To enable the DB project in Visual Studio:
  1. Open Visual Studio Installer and modify your installation to add the "Data storage and processing" workload and install SQL Server Data Tools. (For VS 2019/2022, search for "SQL Server Data Tools" in the installer.)
  2. Alternatively, download SSDT from Microsoft: https://docs.microsoft.com/sql/ssdt/download-sql-server-data-tools-ssdt
  3. Restart Visual Studio and reopen the solution.
- If you do not need to edit or open the DB project, you can unload it from Solution Explorer (right-click -> Unload Project) or temporarily delete or exclude it from the solution file. For CI builds that do not rely on the database project, use the repository's CI which already skips `AC.Database` by default.

Copyright © 2019 Polymindware.
