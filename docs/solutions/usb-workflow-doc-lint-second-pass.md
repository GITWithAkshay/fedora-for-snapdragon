# Solution: finish the USB workflow doc cleanup with a small targeted pass

Related problem: [2026-05-16-usb-workflow-doc-lint-second-pass](../problems/2026-05-16-usb-workflow-doc-lint-second-pass.md)

## Alternatives considered

1. Manually wrap the remaining long lines and remove extra blank lines.
   This keeps the docs readable and respects the current lint policy.
2. Disable `MD013` and `MD012` for the affected docs.
   This is fast, but it weakens the documentation standard for avoidable
   formatting issues.
3. Add the new USB workflow docs to `.markdownlintignore`.
   That would hide future formatting regressions in exactly the files that
   are changing the fastest right now.
4. Move the USB workflow docs out of the README.
   This would reduce line pressure, but it would also make the boot-media
   workflow harder to discover.

## What failed

After the first wrap pass, a few README and USB staging docs still had
line-length and blank-line violations.

## What worked

Applied a second, smaller formatting pass that only touched the remaining
offending lines and extra blank lines.

## Why it worked

The docs stay lint-clean without relaxing policy, and the USB workflow
remains prominent in the main project guide.

## Commands run

```powershell
npm run lint:md
```
