# Problem: make duplicated the DTB target path in the out-of-tree build

## Exact error

<!-- markdownlint-disable MD013 -->

```text
make[3]: *** No rule to make target 'arch/arm64/boot/dts/arch/arm64/boot/dts/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb'.  Stop.
make[2]: *** [/home/CGC/book4edge-build/linux-mainline/Makefile:1592: arch/arm64/boot/dts/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb] Error 2
make[3]: *** No rule to make target 'arch/arm64/boot/dts/arch/arm64/boot/dts/qcom/x1e84100-samsung-galaxy-book4-edge-16.dtb'.  Stop.
make[2]: *** [/home/CGC/book4edge-build/linux-mainline/Makefile:1592: arch/arm64/boot/dts/qcom/x1e84100-samsung-galaxy-book4-edge-16.dtb] Error 2
```

<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Run `bash scripts/build-book4edge-wsl.sh`.
2. Let the build reach the `make` command for `Image.gz` and the two DTBs.
3. Observe `make` duplicate the `arch/arm64/boot/dts` prefix in the DTB
   targets.

## Environment

- OS: FedoraLinux-43 on WSL2
- Build script: `scripts/build-book4edge-wsl.sh`
- Output tree: `~/book4edge-build/out-book4edge`

## First hypothesis

The DTB targets were passed in a form that is correct for locating the
artifact after build but not for invoking the target from the kernel top
level with `O=`, so `make` prefixed the architecture DTS path twice.
