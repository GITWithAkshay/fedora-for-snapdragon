# Solution: missing temporary patch mailbox path

Related problem:
[docs/problems/2026-05-15-patch-mailbox-missing.md](../problems/2026-05-15-patch-mailbox-missing.md)

## What failed

The original mailbox was stored in `/tmp`, so later `git am` runs could not
find it.

## What worked

Persisted the mailbox under `patches/galaxy-book4-edge-v5.mbox` inside the
repository.

## Why it worked

Keeping the mailbox in the repo makes it available across shell sessions and
documents the exact patch input used during the build investigation.

## All commands run

<!-- markdownlint-disable MD013 -->
```text
curl -L --silent --show-error "https://lore.kernel.org/all/p3mhtj2rp6y2ezuwpd2gu7dwx5cbckfu4s4pazcudi4j2wogtr@4yecb2bkeyms/t.mbox.gz" | gzip -dc > patches/galaxy-book4-edge-v5.mbox
```
<!-- markdownlint-enable MD013 -->
