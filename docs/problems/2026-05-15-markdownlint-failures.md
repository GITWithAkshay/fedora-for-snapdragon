# Problem: markdownlint validation failures during environment bootstrap

## Exact error

<!-- markdownlint-disable MD013 -->
```text
docs\problems\2026-05-15-pre-commit-missing.md:10:81 MD013/line-length Line length [Expected: 80; Actual: 115]
docs\problems\2026-05-15-pre-commit-missing.md:11:81 MD013/line-length Line length [Expected: 80; Actual: 105]
docs\problems\2026-05-15-pre-commit-missing.md:30:81 MD013/line-length Line length [Expected: 80; Actual: 182]
docs\steps.md:3 MD022/blanks-around-headings Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "## 2026-05-15T21:27:00+05:30"]
docs\steps.md:4 MD032/blanks-around-lists Lists should be surrounded by blank lines [Context: "- Step name: Documentation sca..."]
docs\steps.md:5:81 MD013/line-length Line length [Expected: 80; Actual: 126]
docs\steps.md:8 MD022/blanks-around-headings Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "## 2026-05-15T21:29:00+05:30"]
docs\steps.md:9 MD032/blanks-around-lists Lists should be surrounded by blank lines [Context: "- Step name: Cross-platform gi..."]
docs\steps.md:10:81 MD013/line-length Line length [Expected: 80; Actual: 129]
docs\steps.md:13 MD022/blanks-around-headings Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "## 2026-05-15T21:32:00+05:30"]
docs\steps.md:14 MD032/blanks-around-lists Lists should be surrounded by blank lines [Context: "- Step name: Logged missing pr..."]
docs\steps.md:15:81 MD013/line-length Line length [Expected: 80; Actual: 134]
docs\steps.md:18 MD022/blanks-around-headings Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Below] [Context: "## 2026-05-15T21:36:00+05:30"]
docs\steps.md:19 MD032/blanks-around-lists Lists should be surrounded by blank lines [Context: "- Step name: Environment scaff..."]
docs\steps.md:20:81 MD013/line-length Line length [Expected: 80; Actual: 158]
docs\steps.md:21:81 MD013/line-length Line length [Expected: 80; Actual: 93]
README.md:3:81 MD013/line-length Line length [Expected: 80; Actual: 196]
README.md:5:81 MD013/line-length Line length [Expected: 80; Actual: 189]
README.md:11:81 MD013/line-length Line length [Expected: 80; Actual: 105]
README.md:38:81 MD013/line-length Line length [Expected: 80; Actual: 202]
README.md:53:81 MD013/line-length Line length [Expected: 80; Actual: 96]
README.md:64:81 MD013/line-length Line length [Expected: 80; Actual: 120]
README.md:75:81 MD013/line-length Line length [Expected: 80; Actual: 170]
README.md:83:81 MD013/line-length Line length [Expected: 80; Actual: 114]
README.md:140:81 MD013/line-length Line length [Expected: 80; Actual: 169]
README.md:169:26 MD034/no-bare-urls Bare URL used [Context: "https://docs.kernel.org/arch/a..."]
README.md:170:51 MD034/no-bare-urls Bare URL used [Context: "https://www.phoronix.com/news/..."]
README.md:171:70 MD034/no-bare-urls Bare URL used [Context: "https://www.spinics.net/lists/..."]
```
<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Run `powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1`.
2. Let the script install Python and npm dependencies.
3. Observe markdownlint output at the end of the run.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Python: 3.13.12
- Node: v24.14.1
- npm: 11.11.0
- Repository version: v0.1.0 bootstrap state

## First hypothesis

The repository was created quickly with long Markdown lines and a compact
step-log format that does not satisfy `markdownlint` defaults. The setup
script also needs clearer fail-fast behavior so validation errors cannot be
mistaken for success.
