# Solution: markdownlint regressed after adding build troubleshooting docs

Related problem:
[docs/problems/2026-05-15-markdownlint-regression-after-build.md](../problems/2026-05-15-markdownlint-regression-after-build.md)

## What failed

After the kernel-build investigation, `npm run lint:md` started failing on
two kinds of content:

- long exact-error captures in problem and solution files
- long machine-appended entries in `docs/steps.md`

This was the second appearance of the same Markdown validation class, so a
durable fix was required instead of another round of local reflow.

## Alternatives evaluated

1. Manually wrap every long line in every existing and future log entry.
   Trade-off: Lint would pass today, but the process is fragile and likely
   to regress during the next debugging session.
2. Relax `MD013` globally in the repository lint configuration.
   Trade-off: Easy, but it would weaken useful line-length pressure for
   normal prose throughout the whole repo.
3. Rework the step logger to hard-wrap `Action` and `Result` text.
   Trade-off: Better long term, but it still would not solve exact error
   captures and long shell commands that should stay verbatim.
4. Add targeted `MD013` exemptions only where content is inherently
   machine-shaped, and keep normal prose wrapped.
   Trade-off: Slightly more verbose in those files, but it preserves strict
   linting for ordinary documentation while protecting exact captures.

## What worked

Applied targeted `MD013` exemptions to:

- `docs/steps.md` for the machine-appended step log
- exact-error blocks in the new problem files
- exact command blocks in the affected solution files

I also cleaned the remaining prose overflows and removed extra blank lines
at file ends so `MD012` passed again.

## Why it worked

The repeated failures came from content that benefits from staying exact:
verbatim errors, full commands, and generated operational log entries.
Targeted exemptions kept that fidelity without weakening Markdown lint for
the rest of the repository.

## All commands run

<!-- markdownlint-disable MD013 -->
```text
npm run lint:md
wsl bash -lc 'cd "/mnt/c/Users/GITWi/OneDrive/Documents/New project" && source .venv-fedora/bin/activate && bash scripts/validate.sh'
```
<!-- markdownlint-enable MD013 -->
