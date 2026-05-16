# Problem: USB workflow docs still failed markdownlint after the first wrap pass

## Exact error

```text
docs/problems/2026-05-16-usb-staging-onedrive-space-exhausted.md:17:81
error MD013/line-length Line length [Expected: 80; Actual: 94]
docs/problems/2026-05-16-usb-staging-onedrive-space-exhausted.md:39
error MD012/no-multiple-blanks Multiple consecutive blank lines
[Expected: 1; Actual: 2]
docs/solutions/usb-staging-onedrive-space-exhausted.md:41:81
error MD013/line-length Line length [Expected: 80; Actual: 88]
docs/solutions/usb-staging-onedrive-space-exhausted.md:44
error MD012/no-multiple-blanks Multiple consecutive blank lines
[Expected: 1; Actual: 2]
README.md:49:81 error MD013/line-length Line length [Expected: 80; Actual: 88]
README.md:144:81 error MD013/line-length Line length [Expected: 80; Actual: 88]
README.md:166:81 error MD013/line-length Line length [Expected: 80; Actual: 96]
README.md:176:81 error MD013/line-length Line length [Expected: 80; Actual: 83]
```

## Reproduction steps

1. Apply the first README and USB staging documentation wrap pass.
2. Run `npm run lint:md`.
3. Observe lingering line-length and blank-line violations in the README and
   the new staging problem and solution docs.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Linter: `markdownlint-cli`

## First hypothesis

The first pass fixed the biggest lines, but several newly added docs still
need tighter wrapping and blank-line cleanup. This should be solved with a
small targeted formatting pass instead of changing lint policy.
