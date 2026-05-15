# Problem: pre-commit rejected the stored patch mailbox formatting

## Exact error

```text
fix end of files.........................................................Failed
- hook id: end-of-file-fixer
- exit code: 1
- files were modified by this hook

Fixing patches/galaxy-book4-edge-v5.mbox

trim trailing whitespace.................................................Failed
- hook id: trailing-whitespace
- exit code: 1
- files were modified by this hook

Fixing patches/galaxy-book4-edge-v5.mbox
```

## Reproduction steps

1. Stage the repository changes with `git add -A`.
2. Run `git commit -m "feat: add Book4 Edge kernel build flow v0.1.2"`.
3. Observe the pre-commit hook rewrite
   `patches/galaxy-book4-edge-v5.mbox` and stop the commit.

## Environment

- OS: Windows on ARM with local Git hooks
- Hook runner: `pre-commit`
- Affected file: `patches/galaxy-book4-edge-v5.mbox`

## First hypothesis

The mailbox was saved exactly as downloaded, and the repository hook policy
requires normalized file endings and no trailing whitespace before commit.
