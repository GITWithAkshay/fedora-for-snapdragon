# Solution: stale git index.lock in the linux source tree

Related problem:
[docs/problems/2026-05-15-linux-source-index-lock.md](../problems/2026-05-15-linux-source-index-lock.md)

## What failed

`git checkout -B` and `git am` were blocked by a leftover
`.git/index.lock`.

## What worked

Confirmed there was no active git process touching the repository and then
removed only the stale lock file.

## Why it worked

Git lock files are only valid while another git process is actively using
them. Once the stale lock was gone, normal branch and patch operations could
resume.

## All commands run

```text
ps -ef | rg "git( |$)|git am|git checkout" || true
ls -l .git/index.lock
rm -f .git/index.lock
```
