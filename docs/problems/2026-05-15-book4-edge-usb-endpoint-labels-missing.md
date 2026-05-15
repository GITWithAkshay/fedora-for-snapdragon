# Problem: rebased Book4 Edge DTS referenced missing USB endpoint labels

## Exact error

<!-- markdownlint-disable MD013 -->

```text
Error: /home/CGC/book4edge-build/linux-mainline/arch/arm64/boot/dts/qcom/x1-samsung-galaxy-book4-edge.dtsi:1426.1-16 Label or path usb_1_ss0_dwc3 not found
Error: /home/CGC/book4edge-build/linux-mainline/arch/arm64/boot/dts/qcom/x1-samsung-galaxy-book4-edge.dtsi:1457.1-16 Label or path usb_1_ss1_dwc3 not found
FATAL ERROR: Syntax error parsing input tree
make[4]: *** [/home/CGC/book4edge-build/linux-mainline/scripts/Makefile.dtbs:140: arch/arm64/boot/dts/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb] Error 1
```

<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Apply the rebased Book4 Edge v6 patch to current mainline.
2. Run `bash scripts/build-book4edge-wsl.sh`.
3. Let the build reach DTB compilation.

## Environment

- OS: FedoraLinux-43 on WSL2
- Source tree: `~/book4edge-build/linux-mainline`
- Build script: `scripts/build-book4edge-wsl.sh`
- Patched branch: `galaxy-book4-edge-v5`

## First hypothesis

The rebased Book4 Edge patch expects USB endpoint labels from a slightly
different upstream base, so at least two endpoint references need to be
adjusted to the label names used by current `hamoa`-based X1 laptop DTS
files.
