# Solution: extra blank lines in solution documents

Related problem:
[docs/problems/2026-05-15-solution-md012-blanks.md](../problems/2026-05-15-solution-md012-blanks.md)

## What failed

Two solution documents ended with an extra blank line after a fenced code
block, which triggered `MD012`.

## What worked

Removed the extra blank line at the end of each affected file.

## Why it worked

`markdownlint` treats repeated blank lines as a formatting error, so
normalizing the file ending resolved the check immediately.

## All commands run

```text
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1
```
