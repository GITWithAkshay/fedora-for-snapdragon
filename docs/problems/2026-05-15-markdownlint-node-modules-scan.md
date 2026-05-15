# Problem: markdownlint scanned node_modules during WSL validation

## Exact error

<!-- markdownlint-disable MD013 -->
```text
docs/problems/2026-05-15-shellcheck-sc1091-setup-wsl.md:8:81 error MD013/line-length Line length [Expected: 80; Actual: 125]
docs/problems/2026-05-15-shellcheck-sc1091-setup-wsl.md:13:81 error MD013/line-length Line length [Expected: 80; Actual: 115]
docs/problems/2026-05-15-step-log-missing-final-newline.md:18:81 error MD013/line-length Line length [Expected: 80; Actual: 115]
docs/steps.md:53:81 error MD013/line-length Line length [Expected: 80; Actual: 167]
docs/steps.md:59:81 error MD013/line-length Line length [Expected: 80; Actual: 159]
docs/steps.md:60:81 error MD013/line-length Line length [Expected: 80; Actual: 90]
node_modules/@types/debug/README.md:1 error MD022/blanks-around-headings Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "# Installation"]
node_modules/@types/katex/README.md:1 error MD022/blanks-around-headings Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "# Installation"]
node_modules/smol-toml/README.md:173:1 error MD033/no-inline-html Inline HTML [Element: details]
node_modules/strip-json-comments/readme.md:76:81 error MD013/line-length Line length [Expected: 80; Actual: 165]
```
<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Run:

   ```text
   wsl bash -lc '
     cd "/mnt/c/Users/GITWi/OneDrive/Documents/New project" &&
     bash scripts/setup-wsl-fedora.sh
   '
   ```

2. Allow `npm install`, `pre-commit`, and `bash scripts/validate.sh` to run.
3. Observe `markdownlint` report errors inside `node_modules`.

## Environment

- OS: FedoraLinux-43 on WSL2
- Validation command:
  `npx markdownlint "**/*.md"`
- npm dependencies installed locally in `node_modules/`

## First hypothesis

The current lint command only ignores the top-level `node_modules` path
name, not the nested Markdown files under `node_modules/**`, so Markdown
lint is validating third-party package docs.
