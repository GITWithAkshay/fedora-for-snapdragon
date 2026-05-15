# Solution: empty patch cover letter stopped git am

Related problem:
[docs/problems/2026-05-15-patch-cover-letter-empty.md](../problems/2026-05-15-patch-cover-letter-empty.md)

## What failed

The first message in the mailbox was a `0/6` cover letter with no patch
body, so `git am` stopped immediately.

## What worked

Skipped the empty cover-letter message before moving on to the actual patch
messages.

## Why it worked

Mailing-list cover letters are metadata, not code changes, so skipping them
is the expected way to continue applying the real patch series.

## All commands run

```text
git am /mnt/c/Users/GITWi/OneDrive/Documents/New project/patches/galaxy-book4-edge-v5.mbox
git am --skip
```
