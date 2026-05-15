# Solution: missing WSL git identity for patch application

Related problem:
[docs/problems/2026-05-15-wsl-git-identity-missing.md](../problems/2026-05-15-wsl-git-identity-missing.md)

## What failed

`git am` could not create commits in the WSL kernel clone because git had no
committer name or email configured there.

## What worked

Set repository-local git identity in the WSL clone before replaying the
patch stack.

## Why it worked

`git am` needs a valid committer identity to create the patch commits, and a
repository-local config keeps that requirement isolated to the build tree.

## All commands run

```text
git config user.name "gitwithakshay"
git config user.email "contact.theakshay@gmail.com"
```
