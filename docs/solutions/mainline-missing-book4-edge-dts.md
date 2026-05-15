# Solution: mainline Linux checkout missing a Galaxy Book4 Edge DTS

Related problem:
[docs/problems/2026-05-15-mainline-missing-book4-edge-dts.md](../problems/2026-05-15-mainline-missing-book4-edge-dts.md)

## What failed

Current upstream `master` did not contain any Book4 Edge DTS file or
Makefile entry.

## What worked

Switched from assuming the board DTS was already upstream to carrying a
rebased Book4 Edge patch file in the repository and applying it onto a clean
mainline clone.

## Why it worked

The board support was still living in patch form, so the build needed an
explicit source overlay instead of a plain upstream checkout.

## All commands run

<!-- markdownlint-disable MD013 -->
```text
find arch/arm64/boot/dts/qcom -maxdepth 1 -name "*galaxy-book4-edge*" -o -name "*book4-edge*" | sort
rg -n "galaxy-book4-edge|book4-edge" arch/arm64/boot/dts/qcom arch/arm64/boot/dts/qcom/Makefile
```
<!-- markdownlint-enable MD013 -->
