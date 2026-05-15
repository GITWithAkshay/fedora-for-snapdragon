# Problem: git am stopped on an empty cover letter in the patch mailbox

## Exact error

```text
Patch is empty.
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To record the empty patch as an empty commit, run "git am --allow-empty".
hint: To restore the original branch and stop patching, run "git am --abort".
hint: Disable this message with "git config set advice.mergeConflict false"
```

## Reproduction steps

1. Download the full Galaxy Book4 Edge thread mailbox.
2. Run `git am` against the mailbox in the kernel source tree.
3. Observe `git am` stop on the initial cover letter message.

## Environment

- OS: FedoraLinux-43 on WSL2
- Architecture: aarch64
- Source tree: `~/book4edge-build/linux-mainline`
- Mailbox: `patches/galaxy-book4-edge-v5.mbox`

## First hypothesis

The mailbox begins with a `0/6` cover letter that contains no patch body,
so `git am` halts until the empty message is skipped.
