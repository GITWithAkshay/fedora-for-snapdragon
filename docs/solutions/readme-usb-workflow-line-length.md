# Solution: wrap the new README USB workflow lines instead of relaxing lint rules

Related problem: [2026-05-16-readme-usb-workflow-line-length](../problems/2026-05-16-readme-usb-workflow-line-length.md)

## Alternatives considered

1. Wrap the long README lines manually.
   This preserves the current lint rules and keeps the docs readable.
2. Disable `MD013` for the README.
   This is quick, but it weakens the standards for the main project guide.
3. Relax `MD013` globally in the Markdown lint config.
   That would reduce friction, but it would lower consistency across the
   entire repository for a tiny formatting issue.
4. Move the long command examples out of the README entirely.
   That would shrink the file, but it would also make the USB workflow less
   discoverable for the next person using the repo.

## What failed

The new USB staging documentation introduced three lines longer than the
repository Markdown lint limit.

## What worked

Wrapped the long prose lines and kept the command examples readable with
PowerShell continuations where needed.

## Why it worked

The README stays lint-clean without changing repository policy, and the USB
workflow remains easy to discover from the main project guide.

## Commands run

```powershell
npm run lint:md
```
