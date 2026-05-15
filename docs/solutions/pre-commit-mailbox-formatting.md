# Solution: pre-commit normalized the stored patch mailbox

Related problem:
[docs/problems/2026-05-15-pre-commit-mailbox-formatting.md](../problems/2026-05-15-pre-commit-mailbox-formatting.md)

## What failed

The first commit attempt stopped because `pre-commit` rewrote
`patches/galaxy-book4-edge-v5.mbox` to satisfy end-of-file and
trailing-whitespace rules.

## What worked

Accepted the hook normalization, staged the rewritten mailbox again, and
retried the commit.

## Why it worked

The hook made the mailbox conform to repository formatting policy, so the
second commit attempt could proceed with the exact same content plus clean
file endings.

## All commands run

```text
git commit -m "feat: add Book4 Edge kernel build flow v0.1.2"
git add -A
git commit -m "feat: add Book4 Edge kernel build flow v0.1.2"
```
