# Problem: README line length failed after documenting the custom USB workflow

## Exact error

```text
README.md:49:81 error MD013/line-length Line length [Expected: 80; Actual: 88]
README.md:144:81 error MD013/line-length Line length [Expected: 80; Actual: 88]
README.md:165:81 error MD013/line-length Line length [Expected: 80; Actual: 96]
```

## Reproduction steps

1. Add the custom patched Fedora USB workflow sections to `README.md`.
2. Run `npm run lint:md`.
3. Observe `markdownlint` fail on three `MD013/line-length` violations.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Linter: `markdownlint-cli`

## First hypothesis

The new USB workflow prose is fine semantically, but a few lines need to be
wrapped to respect the repository Markdown lint policy.
