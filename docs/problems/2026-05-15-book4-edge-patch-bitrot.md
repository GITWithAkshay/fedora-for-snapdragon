# Problem: Galaxy Book4 Edge patch series did not apply cleanly to current mainline

## Exact error

<!-- markdownlint-disable MD013 -->

```text
Applying: dt-bindings: crypto: Add X1E80100 Crypto Engine
Patch failed at 0002 dt-bindings: crypto: Add X1E80100 Crypto Engine
error: patch failed: Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml:19
error: Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort".
hint: Disable this message with "git config set advice.mergeConflict false"
```

<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Clone current mainline Linux into `~/book4edge-build/linux-mainline`.
2. Create branch `galaxy-book4-edge-v5`.
3. Start `git am` against `patches/galaxy-book4-edge-v5.mbox`.
4. Skip the empty `0/6` cover letter.

## Environment

- OS: FedoraLinux-43 on WSL2
- Architecture: aarch64
- Source tree: `~/book4edge-build/linux-mainline`
- Base commit: `70eda6866`
- Mailbox: `patches/galaxy-book4-edge-v5.mbox`

## First hypothesis

The v5 Galaxy Book4 Edge patch series was posted against an older upstream
state, and at least the first binding patch has drifted enough that it no
longer applies directly to current mainline.
