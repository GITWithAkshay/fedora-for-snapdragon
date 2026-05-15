# Problem: WSL git identity was not configured for patch application

## Exact error

```text
Committer identity unknown

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: empty ident name (for <CGC@WIN-6P9IN22RECQ.localdomain>) not allowed
```

## Reproduction steps

1. Change into `~/book4edge-build/linux-mainline` in Fedora WSL.
2. Create branch `galaxy-book4-edge-v5`.
3. Run `git am /tmp/galaxy-book4-edge-v5.mbox`.

## Environment

- OS: FedoraLinux-43 on WSL2
- Architecture: aarch64
- Source tree: `~/book4edge-build/linux-mainline`
- Operation: `git am`

## First hypothesis

The Fedora WSL environment does not have a configured git committer name
and email, so `git am` cannot create the patch commits locally.
