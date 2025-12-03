Developer Setup

This document covers how to set up a developer environment for the repo and how to handle the SQL Server Database project which may show as "Unsupported" in Visual Studio.

Overview

- Visual Studio plugins required: SQL Server Data Tools (SSDT) or the SQL Server Database Projects extension to open `AC.Database/AC.Database.sqlproj`.

Install SSDT (Windows, Visual Studio)

- For Visual Studio 2022 or 2019:
  - Open Visual Studio Installer -> Modify -> Individual components -> check "SQL Server Data Tools" or "Data storage and processing" workload.
  - Alternatively, you can download SSDT from Microsoft docs: https://docs.microsoft.com/sql/ssdt/download-sql-server-data-tools-ssdt
- For older Visual Studio versions (2015/2013/2012): Install the SSDT extension appropriate for that version.

If Visual Studio says "Unsupported" or has a missing project type:

- It means your Visual Studio installation lacks SSDT or the specific project type supported by the solution. NOTE: This repository intentionally excludes `AC.Database` from the solution by default to avoid the unsupported message on machines without SSDT.
- Options:
  1. Install SSDT as described above, then re-open the solution.
  2. If you don't need to work on the DB project, you can leave it excluded from the solution (recommended). If you had previously added it, unload it from Solution Explorer: Right-click -> Unload Project.
  3. Clear Visual Studio caches and reload the solution if Visual Studio still shows the migration errors (close VS, delete `.vs` folder in the solution root, delete `*.suo` if present, then reopen VS and the solution).
  4. If you want the database project available in the solution for work, re-add `AC.Database\AC.Database.sqlproj` via Right click -> Add -> Existing Project. Only do this if you have SSDT installed.

CI / Headless builds (GitHub Actions or build servers)

- The database project requires SSDT and will not build on runners without it. We have opted to skip building the `AC.Database` project by default in `/.github/workflows/ci.yml`.
- If you’d like CI to also validate the database project, you can either:
  - Use a runner that has SSDT installed, and ensure `nuget` and `msbuild` are available, or
  - Use a specialized pipeline that runs on a machine/VM with SSDT and Visual Studio installed.

Tips for msbuild and solution compatibility note

- Visual Studio may update the solution file to support older versions (non-functional updates). These updates are usually safe and intended to keep your solution usable in older Visual Studio versions.
- Keep backups or use a branch for such changes and make sure to commit non-functional solution changes consistently.

If you need help getting the DB project to build in CI or locally, tell me your preferred approach (install SSDT vs skip building the project) and I’ll add specific steps and a sample pipeline snippet.
