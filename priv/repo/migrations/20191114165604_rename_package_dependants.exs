defmodule Hexpm.RepoBase.Migrations.RenamePackageDependants do
  use Ecto.Migration

  def up() do
    execute("DROP MATERIALIZED VIEW IF EXISTS package_dependants")

    execute("""
      CREATE MATERIALIZED VIEW package_dependents (
        name,
        repo,
        package_id,
        dependent_id) AS
        SELECT DISTINCT
          p3.name AS name,
          r4.name AS repo,
          p3.id AS package_id,
          p0.id AS dependent_id
          FROM "packages" AS p0
          INNER JOIN "releases" AS r1 ON r1."package_id" = p0."id"
          INNER JOIN "requirements" AS r2 ON r2."release_id" = r1."id"
          INNER JOIN "packages" AS p3 ON p3."id" = r2."dependency_id"
          INNER JOIN "repositories" AS r4 ON r4."id" = p3."repository_id"
    """)

    execute("CREATE INDEX ON package_dependents (package_id)")
    execute("CREATE INDEX ON package_dependents (name)")
    execute("CREATE INDEX ON package_dependents (name, repo)")
    execute("CREATE UNIQUE INDEX ON package_dependents (name, repo, dependent_id)")
  end

  def down() do
    execute("DROP MATERIALIZED VIEW IF EXISTS package_dependents")

    execute("""
      CREATE MATERIALIZED VIEW package_dependants (
        name,
        repo,
        package_id,
        dependant_id) AS
        SELECT DISTINCT
          p3.name AS name,
          r4.name AS repo,
          p3.id AS package_id,
          p0.id AS dependant_id
          FROM "packages" AS p0
          INNER JOIN "releases" AS r1 ON r1."package_id" = p0."id"
          INNER JOIN "requirements" AS r2 ON r2."release_id" = r1."id"
          INNER JOIN "packages" AS p3 ON p3."id" = r2."dependency_id"
          INNER JOIN "repositories" AS r4 ON r4."id" = p3."repository_id"
    """)

    execute("CREATE INDEX ON package_dependants (package_id)")
    execute("CREATE INDEX ON package_dependants (name)")
    execute("CREATE INDEX ON package_dependants (name, repo)")
    execute("CREATE UNIQUE INDEX ON package_dependants (name, repo, dependant_id)")
  end
end
