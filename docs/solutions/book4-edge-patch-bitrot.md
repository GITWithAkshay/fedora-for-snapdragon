# Solution: older Book4 Edge patch series drifted against current mainline

Related problem:
[docs/problems/2026-05-15-book4-edge-patch-bitrot.md](../problems/2026-05-15-book4-edge-patch-bitrot.md)

## What failed

The older v5 patch series no longer applied cleanly to current mainline, and
its first non-empty patch already drifted in the inline crypto engine
binding.

## What worked

Abandoned the older mailbox as the primary source and switched to the newer
rebased v6 DTS patch extracted from the public patch page.

## Why it worked

The v6 DTS patch was already rebased onto the modern `hamoa` layout, which
made it a much better fit for current upstream than manually fighting the
older v5 series through binding drift.

## All commands run

```text
git am /mnt/c/Users/GITWi/OneDrive/Documents/New project/patches/galaxy-book4-edge-v5.mbox
git am --show-current-patch=diff
```
