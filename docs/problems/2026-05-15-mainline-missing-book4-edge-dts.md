# Problem: mainline Linux checkout did not contain a Galaxy Book4 Edge DTS

## Exact error

<!-- markdownlint-disable MD013 -->

```text
Command: find arch/arm64/boot/dts/qcom -maxdepth 1 -name "*galaxy-book4-edge*" -o -name "*book4-edge*" | sort
Result: no matching files

Command: rg -n "galaxy-book4-edge|book4-edge" arch/arm64/boot/dts/qcom arch/arm64/boot/dts/qcom/Makefile
Result: no matches
```

<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Clone mainline Linux from `https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git`.
2. Change into `sources/linux-mainline`.
3. Search `arch/arm64/boot/dts/qcom` for `galaxy-book4-edge` or
   `book4-edge`.

## Environment

- OS: FedoraLinux-43 on WSL2
- Architecture: aarch64
- Source tree: `sources/linux-mainline`
- Commit: `70eda6866`

## First hypothesis

The Galaxy Book4 Edge DTS support is either not merged into the current
mainline branch yet, has a different board filename, or exists only in a
pending patch series or integration branch such as `linux-next`.
