# Solution: keep the new download docs lint-clean by wrapping long text and commands

Related problem: [2026-05-16-markdownlint-download-doc-line-length](../problems/2026-05-16-markdownlint-download-doc-line-length.md)

## What failed

The newly added problem and solution files for the download workflow
introduced multiple `MD013/line-length` failures.

## Alternatives considered

1. Wrap long prose and split long commands with PowerShell continuations.
   This keeps the docs readable and preserves the existing repo lint rules.
2. Add file-level `markdownlint` disables for `MD013`.
   This is fast, but it weakens the documentation standards for avoidable
   formatting issues.
3. Add the new docs to `.markdownlintignore`.
   That would silence the problem, but it would also hide future formatting
   regressions in files that should stay reviewable.
4. Relax `MD013` globally in the lint configuration.
   That would reduce friction, but it would lower consistency across the
   whole repository for a very small set of files.

## What worked

Wrapped the copied error text and split the long PowerShell examples across
multiple lines inside fenced code blocks.

## Why it worked

This keeps the docs compliant without changing repository-wide lint
behavior, and the resulting command examples are still easy to copy and
understand.

## Commands run

```powershell
npm run lint:md
```
