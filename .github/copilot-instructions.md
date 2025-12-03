# GitHub Copilot / Assistant Instructions — ArtificialConsciousness

Purpose: Help AI agents be immediately productive in this repository by describing the architecture, developer workflows, conventions, and specific examples for common changes.

---

## Big picture

- Multi-project Visual Studio (classic .sln) solution: `ArtificialConsciousness.sln` contains the main components:
  - AC.DAL: Entity Framework 6 model and repository layer (`AC.DAL/EF`, `AC.DAL/Repositories`).
  - AC.BLL: Business Logic Layer. Services inherit `BaseService` and return `BlResult<T>`.
  - AC.BLL.Models: BLL model DTOs used between UI and BLL.
  - AC.Common: Cross-cutting concerns — AutoMapper profiles, DI bootstrap, and service registration.
  - AC.Desktop.Main / AC.Desktop.Controls: WPF Desktop UI (MahApps) and ViewModels.
  - ACConsoleApp: Console playground for DB/examples.
  - AC.Agnets: Agent logic that consumes BLL interfaces.
  - AC.Database: SQL Server database project with table creation scripts.

## Where responsibilities lie

- UI (WPF): `AC.Desktop.Main` — registers local view models in `App.ConfigureLocalServiceDependencies` and resolves them from a global Unity container. `App.xaml.cs` initializes DI via `Bootstrap`.
- BLL Services: `AC.BLL/Implementations/*` — orchestrates repositories, mapping, and transactions. See `BaseService` for transaction and child service patterns (`EnsureTransaction`, `SaveChangesAsync`).
- Data layer: `AC.DAL/EF` (EDMX) and `AC.DAL/Repositories` — repositories extend `BaseRepository` and depend on `DatabaseTransaction` for transaction behavior.
- DB: `AC.Database/` contains a SQL project with schema scripts. Use Visual Studio or SQL Server tools to publish.

## Key patterns & conventions (copyable examples)

- DI & Bootstrapping

  - Use Unity. Global DI is configured in `AC.Common/Bootstrap.cs`.
  - WPF application sets up DI in `AC.Desktop.Main/App.xaml.cs`. Example registration: `container.RegisterType<INodeService, NodeService>();` is in `AC.Common/Services/*DependencyCollection.cs` files.
  - AutoMapper mappings are added in `AC.Common/AutoMapper/Bootstrap.cs` and defined per entity in `AC.Common/AutoMapper/*Profile`.

- Repositories & EF

  - EF context: `AC.DAL/EF/ACDatabaseEntities` with connection string name `ACDatabaseEntities` (`AC.DAL/App.config`).
  - `BaseRepository<TEntity,TDbContext>`: inherits `DatabaseTransaction<TDbContext>` and provides most common EF CRUD helpers; add custom queries in repository implementations (e.g., `NodeRepository`, `ConnectionRepository`).
  - Repositories often use `Include(...)` to eagerly load navigation properties (example: `GetByIdWithReferencAsync` in `NodeRepository`).

- Business Logic Layer (BLL)

  - Services inherit `BaseService` and use `BlResult<T>` for output; handle transactions with `EnsureTransaction()` and `SaveChangesAsync(commit)`. `SaveChangesAsync(false)` is used for multi-step Save operations with final commit later.
  - Child service semantics: `BaseService` uses `IsChild` and `IsCommitingChanges` to avoid double commits when composing multiple services.

- Mapping & Serialization

  - AutoMapper profiles are in `AC.Common/AutoMapper/*Profile`. Navigation properties are typically ignored in mapping (to avoid circular references). Follow already set patterns (e.g., `ForMember(a => a.ConnectionsFrom, opt => opt.Ignore())`).

- Exceptions & Result pattern
  - Standardized `BlResult` (and `BlResult<T>`) is used for all BLL method outputs. `ConstDictionary` contains localized error messages in `AC.BLL/Resources`.

## Developer workflows (build/run/debug)

- Prerequisites: Visual Studio 2017/2019 (or higher) with .NET Framework dev support, MSBuild, and NuGet; SQL Server local instance for DB.
- Build locally using Visual Studio or CLI (PowerShell):
  - Restore nuget packages: `nuget restore .\ArtificialConsciousness.sln`
  - Build: `msbuild .\ArtificialConsciousness.sln /p:Configuration=Debug`
- Run desktop app: set `AC.Desktop.Main` as startup and run via Visual Studio, or run the generated exe:
  - Example: `& .\AC.Desktop.Main\bin\Debug\AC.Desktop.Main.exe`
- Run console app for quick DB interactions: `& .\ACConsoleApp\bin\Debug\AC.ConsoleApp.exe`
- Database: Use Visual Studio SQL Server Database Project (`AC.Database/`) to deploy/publish schema to local SQL Server instance; the default connection string is in `AC.DAL/App.config` and points to `ACDatabase`, data source `.`.
  - Note: The `AC.Database` SQL project is currently *excluded* from the default solution to avoid unsupported project types for developers without SSDT. The project files remain in `AC.Database/`. To use it, re-add `AC.Database\AC.Database.sqlproj` to the solution and install SSDT.

## Common tasks and where to change things

- Add a new DB entity/table:

  1. Add SQL script under `AC.Database` (table and constraints).
  2. Update `AC.DAL/EF` model: open `.edmx` and refresh or use DDL to generate; code is generated into `AC.DAL/EF`.
  3. Add repository interface in `AC.DAL/Repositories/Interfaces/*` and implementation in `AC.DAL/Repositories/Implementations/*` (extend `BaseRepository`).
  4. Add BLL model in `AC.BLL.Models/*` and mapping profile under `AC.Common/AutoMapper/*Profile`.
  5. Add BLL interface and implementation in `AC.BLL/Interfaces` and `AC.BLL/Implementations` and register service in `AC.Common/Services/*DependencyCollection.cs`.
  6. Update UI services/viewmodels as needed.

- Add a new View + ViewModel (WPF):
  - Create a view under `AC.Desktop.Main/Views` and a ViewModel under `AC.Desktop.Main/ViewModels`.
  - Register the ViewModel in `App.ConfigureLocalServiceDependencies`.
  - Use DI `Container.Resolve<NewViewModel>()` to create ViewModel and set it in `ShellViewModel` or a related container.

## Patterns agents should be careful with

- Avoid altering generated artifacts (`AC.DAL/EF/*.tt`, `.edmx`, `.Designer.cs` files) in place — instead change the model and regenerate.
- Use `EnsureTransaction()` and `SaveChangesAsync()` as shown in BLL services; commits are typically done in the top-level service only, children call `SaveChangesAsync(false)`.
- `BaseRepository.Delete` uses `async void` — if modifying the deletion pattern, avoid `async void` (convert to `Task`) to preserve async semantics.
- Many names use the misspelling "Attribuet(s)" — **do not** rename arbitrarily; keep consistent naming across BLL/Models/DB when adding functionality.

## Helpful code references & search keys

- Entry points & bootstrapping: `AC.Desktop.Main/App.xaml.cs`, `AC.Common/Bootstrap.cs`
- AutoMapper: `AC.Common/AutoMapper/Bootstrap.cs`, `AC.Common/AutoMapper/*Profile` (e.g., `AutoMapperNodeProfile.cs`)
- Database context & EF: `AC.DAL/EF/ACModel.edmx`, `AC.DAL/EF/ACModel.Context.cs`
- Repositories examples: `AC.DAL/Repositories/Implementations/Nodes/NodeRepository.cs` and `BaseRepository.cs`
- BLL examples: `AC.BLL/Implementations/Node/NodeService.cs`, `BaseService.cs`, `BlResult.cs`.
- SQL / schema files: `AC.Database/*/Tables/*.sql` (e.g., `AC.Database/node/Tables/Node.sql`)
- Sample console DB usage: `ACConsoleApp/Program.cs` (quick DB manipulations and sample queries)

## Quick TODOs for future automation or tests (optional suggestions)

- Add a test project `AC.Tests` for service-level unit tests using in-memory DB or mocking `IDatabaseTransaction`.
  - Note: `AC.Tests` project was added with a sample `NodeService` test (MSTest + Moq). Update/expand tests as needed.
- Add pre-commit hooks or CI builds using `msbuild`/`nuget restore` and optionally run an integration job that deploys `AC.Database` to a test DB.

---

If anything’s missing or some conventions are unclear, tell me which areas you want expanded (e.g., sample PR flows, specific behavior expectations for `IsChild` services, or more code references for agents to use). Cheers!
