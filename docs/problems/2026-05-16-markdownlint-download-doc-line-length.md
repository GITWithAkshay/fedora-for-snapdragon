# Problem: markdownlint failed on the new download workflow docs

## Exact error

```text
docs/problems/2026-05-16-aria2-path-not-refreshed.md:10:81
error MD013/line-length Line length [Expected: 80; Actual: 111]
docs/problems/2026-05-16-aria2-path-not-refreshed.md:11:81
error MD013/line-length Line length [Expected: 80; Actual: 112]
docs/problems/2026-05-16-bits-transfer-mui-cache.md:8:81
error MD013/line-length Line length [Expected: 80; Actual: 81]
docs/problems/2026-05-16-bits-transfer-mui-cache.md:14:81
error MD013/line-length Line length [Expected: 80; Actual: 81]
docs/problems/2026-05-16-bits-transfer-mui-cache.md:16:81
error MD013/line-length Line length [Expected: 80; Actual: 151]
docs/problems/2026-05-16-fedora-iso-download-connection-reset.md:8:81
error MD013/line-length Line length [Expected: 80; Actual: 81]
docs/problems/2026-05-16-fedora-iso-download-connection-reset.md:10:81
error MD013/line-length Line length [Expected: 80; Actual: 152]
docs/solutions/aria2-path-not-refreshed.md:26:81
error MD013/line-length Line length [Expected: 80; Actual: 118]
docs/solutions/aria2-path-not-refreshed.md:28:81
error MD013/line-length Line length [Expected: 80; Actual: 93]
docs/solutions/aria2-path-not-refreshed.md:29:81
error MD013/line-length Line length [Expected: 80; Actual: 159]
docs/solutions/bits-transfer-mui-cache.md:25:81
error MD013/line-length Line length [Expected: 80; Actual: 229]
docs/solutions/bits-transfer-mui-cache.md:26:81
error MD013/line-length Line length [Expected: 80; Actual: 452]
docs/solutions/fedora-iso-download-connection-reset.md:25:81
error MD013/line-length Line length [Expected: 80; Actual: 118]
docs/solutions/fedora-iso-download-connection-reset.md:26:81
error MD013/line-length Line length [Expected: 80; Actual: 452]
docs/solutions/fedora-iso-download-connection-reset.md:27:81
error MD013/line-length Line length [Expected: 80; Actual: 91]
```

## Reproduction steps

1. Add the new download workflow problem and solution documentation files.
2. Run `npm run lint:md` from the repository root.
3. Observe `markdownlint` fail on multiple `MD013/line-length` violations.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Linter: `markdownlint-cli`

## First hypothesis

The new docs were written in a readable narrative style, but the command
blocks and copied error text still need line wrapping or fenced-block
formatting that fits the repository lint rules.
