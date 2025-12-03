AC.Database.Scripts — SQL script viewer project

This project is a scripts-only .NET project that includes the SQL files from `AC.Database` as content so they appear in Visual Studio's Solution Explorer without requiring SSDT.

- Purpose: allow developers who do not have SSDT to see SQL scripts in the solution.
- The project doesn't attempt to build or deploy any DB objects. It's for readability only.
- If you want to modify the DB with SSDT, re-add `AC.Database/AC.Database.sqlproj` to the solution or use full SSDT support.

Add to solution: It's added by default and is safe for devs without SSDT.
