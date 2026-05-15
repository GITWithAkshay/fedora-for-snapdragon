# Solution: repeated markdownlint failures

Related problems:

- [docs/problems/2026-05-15-markdownlint-failures.md](../problems/2026-05-15-markdownlint-failures.md)
- [docs/problems/2026-05-15-markdownlint-second-failure.md](../problems/2026-05-15-markdownlint-second-failure.md)

## What failed

Markdown validation failed twice because the repository mixed two kinds of
content:

- normal prose that should wrap cleanly
- verbatim error transcripts that naturally exceed the line-length rule

## Alternatives evaluated

1. Wrap every long line manually, including exact error transcripts.
   Trade-off: Distorts the original error text and makes incident reports
   less exact.
2. Disable `MD013` globally.
   Trade-off: Removes a useful readability rule from the whole repository.
3. Ignore `docs/problems/` entirely in markdownlint.
   Trade-off: Throws away formatting checks where they still add value.
4. Keep prose wrapped and add targeted `MD013` exceptions only around exact
   error blocks.
   Trade-off: Slightly more markup, but it preserves both readability and
   exact error capture.
5. Move raw error output into sidecar `.txt` files and link to them.
   Trade-off: More files and more indirection for every problem report.

## What worked

Wrapped normal prose and command descriptions, fixed the step log spacing,
and added narrow `<!-- markdownlint-disable MD013 -->` guards around exact
error blocks in problem files.

## Why it worked

The repository keeps strict Markdown rules for human-written content while
making a deliberate exception for verbatim machine output that must stay
unchanged.

## All commands run

```text
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1
npm view markdownlint-cli version
```
