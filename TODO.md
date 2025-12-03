TODO — Improvements & Updates (prioritized)

Purpose: A concise list of recommended improvements and updates to help developers and AI agents be productive while contributing to this codebase.

Note: I focused on discoverable, actionable items only (no speculative refactors). Where appropriate, I included sample steps and file references.

---

High Priority (low-effort, high-value)

1. Fix `async void` in repositories ✅ (IMPLEMENTED)

   - Issue: `BaseRepository.Delete(int id)` is implemented as `async void`. This makes errors harder to handle and breaks call-site error propagation.
   - Files: `AC.DAL/Repositories/Implementations/BaseRepository.cs`
   - Fix: Implemented. `IBaseRepository.Delete` updated to `Task DeleteAsync(int id)`, `BaseRepository` implemented `DeleteAsync` and services updated to await the new method.
   - Files changed: `AC.DAL/Repositories/Interfaces/IBaseRepository.cs`, `AC.DAL/Repositories/Implementations/BaseRepository.cs`,
     `AC.BLL/Implementations/Node/NodeService.cs`, `AC.BLL/Implementations/Graph/GraphService.cs`,
     `AC.BLL/Implementations/Connection/ConnectionService.cs`, `AC.BLL/Implementations/Connection/ConnectionTypeService.cs`,
     `AC.BLL/Implementations/Attribuet/AttribuetDescriptionService.cs`
   - Next: Add unit tests and CI to prevent regressions (recommended next step).
   - Status: Basic unit test project `AC.Tests` added with `NodeService` tests; CI workflow `/.github/workflows/ci.yml` added that builds the solution and attempts to run tests.
   - Note: The test project uses MSTest + Moq; developer needs to run a `nuget restore` and `msbuild` locally to run the tests on Windows.
   - Risk: Low. Requires updating usage and tests.

2. Correct typos & English clarity

   - Issue: Many identifiers and comments use "Attribuet(s)" or misspellings (Ex: "childe"). This confuses contributors and code-search.
   - Files to check: `AC.BLL/Implementations/Attribuet/*`, `AC.BLL.Models/Attribuets/*`, `AC.DAL/Repositories/Implementations/Attribuets/`, `AC.Database/attributes/`, `AC.Common/AutoMapper/AttribuetProfile/*`.
   - Recommendation: Keep the current names as-is to avoid breaking changes — but add a migration plan and aliasing where needed. For future refactor, document a renaming plan for `Attribuet -> Attribute` that includes:
     - Update BLL Models to add a new `Attribute*` DTO names alongside `Attribuet*` (optional)
     - Update AutoMapper profiles
     - Create a migration/PR that updates each project simultaneously (DAL, BLL, Models, UI, DB scripts)
   - Risk: Medium. This is a breaking rename and needs coordination.

3. Improve & expand repository `README.md`

   - Issue: Root `README.md` is short; it does not include run/build/test steps or DB setup.
   - Files: `README.md` (root), `AC.DAL/App.config` (connection string)
   - Recommendation: Add steps for
     - Building (`nuget restore`, `msbuild`),
     - Running `AC.Desktop.Main`,
     - Setting up DB (use `AC.Database` SQL project or `ACConsoleApp` sample),
     - Where to find sample data.

4. Add `.editorconfig` & code style rules
   - Issue: No repository-level code style enforcement (mismatches or typos in style and comments happen).
   - Files: Root of repo
   - Recommendation: Add `.editorconfig`, prefer tabs/spaces and define rules that match existing code. Add recommended Roslyn analyzer (StyleCop) for new PRs.

Medium Priority (moderate effort, good safety)

5. Add Unit & Integration Tests

   - Issue: No test projects exist. Services rely on DB and don't have automated tests.
   - Suggested approach:
     - Add `AC.Tests` project (xUnit/NUnit/MSTest) and a small sample test for `NodeService`.
     - Use mocking for `IDatabaseTransaction` (`Moq`), and `INodeRepository` for unit tests.
     - For integration tests: configure a local DB or containerized SQL Server instance, and run the SQL from `AC.Database` as part of CI.
   - Files: Create `AC.Tests/` and add `Test/Service/NodeServiceTests.cs`.
   - Example stub:
     - Test should assert the behavior of `SaveAsync`, `GetByIdAsync`, `DeleteAsync` (ensuring `CantDeleteNodeWithConnections` behavior).

6. Add GitHub Actions workflow ✅ (IMPLEMENTED)

   - Issue: No CI pipeline exists.
   - Recommendation: Add `.github/workflows/ci.yml` with steps to:
     - Restore nuget packages
     - Build with `msbuild` or `dotnet msbuild` (choose consistent tooling for Net Framework)
     - Run `AC.Tests`

- Example YAML (partial): CI workflow created at `.github/workflows/ci.yml`.
  - Use windows-latest runner.
  - `nuget restore`, `msbuild` build.
  - If adding tests, run them.

7. Logging & Error handling improvements

   - Issue: Throwing `throw ex;` (explicit re-throw) may blow up stack traces. There is minimal logging.
   - Files: Look for `catch (Exception ex) { throw ex; }` and `BlResult.Fail(ex)` uses.
   - Recommendation: use `throw;` to preserve stack traces and add structured logging (Serilog or Microsoft.Extensions.Logging) consolidated in `AC.Common`.

8. Avoid N+1 in Repositories
   - Issue: `NodeRepository.AddAttribuets` will `FindAsync` for each attribute in a loop, which could lead to N+1. Optimize by fetching attributes in a single query using `.Where` and `Contains`.
   - Files: `AC.DAL/Repositories/Implementations/Nodes/NodeRepository.cs`
   - Example: `var attrs = await _dbContext.AttributeDescriptions.Where(a => attributesToAdd.Contains(a.Id)).ToListAsync();` and then add them.

Lower Priority & Long-term (may need larger changes)

9. Consider EF migration strategy and updates

   - Issue: Code uses EF 6, EDmx+Designer. If we plan modernization, either maintain EF6 or plan a migration to EF Core carefully.
   - Recommendation: If not migrating now, stay on EF 6.x and ensure packages are updated to the latest supported patch. If considering migration to EF Core:
     - Make a separate branch and test coverage before porting.
     - Consider data migration scripts for schema changes.

10. Strongly typed config for DB connection and environment

- Issue: `App.config` contains a local connection string but no environment overrides or secrets management.
- Recommendation: Document how to change connection strings for development and test. If moving to CI, choose environment variables or a secure secret storage.

11. Add a Project Contributing & PR Checklist

- Issue: No documented process for PRs nor `CONTRIBUTING.md`.
- Recommendation: Add `CONTRIBUTING.md` with guidelines on:
  - Branch naming
  - PR checklist: tests, built solution, run integration tests, code style, review
  - Breaking change process (where to document DB or API changes)

12. Make doc & resource strings consistent & correct

- Issue: `AC.BLL.Resources.ConstDictionary` strings contain typos and inconsistent punctuation.
- Recommendation: Review resource strings for grammar and clarity.
- Files: `AC.BLL/Resources/ConstDictionary.resx`, `ConstDictionary.Designer.cs`.

13. Replace magic strings & status codes

- Issue: Error-handling uses `BlResult.Fail` with strings sometimes and enum otherwise.
- Recommendation: Standardize usage of `BLErrorCodeTypeEnum` and the `ConstDictionary` messages. Prefer message + code or code-only across the code base.

14. Handle `IsChild` service patterns in documentation

- Issue: `BaseService` uses `IsChild` / `IsCommitingChanges` - complex transaction rules.
- Recommendation: Document service composition patterns and the lifecycle of transactions more explicitly, maybe in `AC.Common` docs.

15. Add a code owner / maintainers note

- Issue: No clear code owners or maintainers listed in repo.
- Recommendation: Add `CODEOWNERS` or a `MAINTAINERS.md` file describing who to tag in PRs for specific areas (DAL, BLL, UI).

Optional modernization (planning & engineering effort)

16. Modernize DI and configuration

- Recommendation: consider Microsoft.Extensions.DependencyInjection and `IOptions` for configuration. This is optional and would need scoped updates.

17. Performance & profiling

- Suggest adding a short performance profiling tool and an example for the UI to capture memory or CPU spikes when large graphs are loaded.

18. Inventory & docs for 3rd-party library versions

- There are `packages.config` files across solutions and older versions (e.g., EF 6.2.0). Please list versions and suggest an update matrix for planned upgrades.

Implementation guidance / PR steps

- For quick fixes (async void, typos, resource cleanup):

  1. Create a feature branch e.g., `fix/async-delete`.
  2. Update method signature and all callers.
  3. Add unit tests for deletion logic.
  4. Perform a build & run tests.
  5. Submit PR with change log.

- For larger changes (rename `Attribuet -> Attribute` or migrate EF):
  1. Propose an RFC (issue + design doc) describing transition steps and backwards compatibility.
  2. Break the rename into multiple PRs: rename BLL models, update AutoMapper mappings, update DAL & Db scripts, update UI, test.
  3. If changes break DB, add SQL migration scripts and test them in the `AC.Database` project.

Repository housekeeping & safety (recommendations)

- Add `.editorconfig` & `stylecop.json` or Roslyn analyzers.
- Add a `CODEOWNERS` and `CONTRIBUTING.md`.
- Add GitHub Actions CI to build, test, and (optional) publish a set of artifacts.
- Document how to set a development database and sample data — include SQL scripts or `ACConsoleApp` examples.
- Consider adding integration tests and a test SQL dataset in `AC.Database` for reproducible tests.

19. Document SQL project & SSDT requirements

- Issue: `AC.Database` is a SQL Server Database Project (`.sqlproj`). Developers without SSDT will see "Unsupported" when opening it.
- Recommendation:

  - Add local setup instructions (SSDT installation) in `DEVELOPER-SETUP.md` (done).
  - For devs who don't need to work on the DB project: unload `AC.Database` or remove it from the solution for local development.
  - Update CI to skip building `AC.Database` (implemented) or provide a specific runner with SSDT to CI if DB project builds are required.
  - Status: AC.Database removed from `ArtificialConsciousness.sln` to prevent unsupported messages when SSDT is missing. The project files still exist under `AC.Database/`.

  - New: `deploy-sql.ps1` was added to `AC.Database/` to allow applying the SQL scripts with `sqlcmd` for developers who don't use the `.sqlproj`.

---

If you want I can:

- Implement the high-priority changes (like `async void` -> `Task`) and add unit tests for the change.
- Create a GitHub Actions CI workflow template that builds `ArtificialConsciousness.sln` and runs tests.
- Add `CONTRIBUTING.md`, `.editorconfig`, and a PR template.

Which item do you want me to address first? (I recommend `async Delete` + a test and a CI pipeline to ensure the repo builds.)
