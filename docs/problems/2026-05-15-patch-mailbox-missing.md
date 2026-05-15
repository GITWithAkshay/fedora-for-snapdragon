# Problem: temporary patch mailbox path was not available for git am

## Exact error

<!-- markdownlint-disable MD013 -->

```text
fatal: could not open '/tmp/galaxy-book4-edge-v5.mbox' for reading: No such file or directory
```

<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Download the Galaxy Book4 Edge mailbox into `/tmp` in one shell session.
2. Start a later shell session.
3. Run `git am /tmp/galaxy-book4-edge-v5.mbox`.

## Environment

- OS: FedoraLinux-43 on WSL2
- Architecture: aarch64
- Source tree: `~/book4edge-build/linux-mainline`
- Temporary file path: `/tmp/galaxy-book4-edge-v5.mbox`

## First hypothesis

The mailbox was created in a previous shell context and was no longer
present, so `git am` could not find the patch input file.
