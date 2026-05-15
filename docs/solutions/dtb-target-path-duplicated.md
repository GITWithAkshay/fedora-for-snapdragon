# Solution: repeated DTB target resolution failures in the out-of-tree build

Related problem:
[docs/problems/2026-05-15-dtb-target-path-duplicated.md](../problems/2026-05-15-dtb-target-path-duplicated.md)

## What failed

The build script tried two single-target forms for the Samsung DTBs:

- `arch/arm64/boot/dts/qcom/<file>.dtb`
- `<file>.dtb`

Both failed under the top-level `make O=...` invocation.

## Alternatives evaluated

1. Keep guessing the exact single-target path syntax.
   Trade-off: Fast if guessed correctly, but we already hit the same error
   twice and it is fragile.
2. Use `qcom/<file>.dtb` as a third single-target variant.
   Trade-off: Plausible, but still another path-form guess.
3. Invoke a lower-level device-tree makefile directly.
   Trade-off: More coupled to kernel internals and easier to break across
   versions.
4. Build the generic `dtbs` target, then copy only the required Samsung
   DTBs out of the results.
   Trade-off: More compile work, but it is the most robust and version-safe
   approach.
5. Use `dtbs_install` after a full DTB build.
   Trade-off: Useful for packaging, but still depends on the same full DTB
   compile step first.

## What worked

Switched the build script to invoke `make ... dtbs` and then copy only:

- `x1e80100-samsung-galaxy-book4-edge-14.dtb`
- `x1e84100-samsung-galaxy-book4-edge-16.dtb`

from the output tree into `build-output/`.

## Why it worked

The generic `dtbs` target is the canonical top-level interface for device
tree compilation, especially with an out-of-tree `O=` build. It avoids
target-path ambiguity while still letting the repository keep only the
specific Samsung artifacts it cares about.

## All commands run

<!-- markdownlint-disable MD013 -->
```text
wsl bash -lc 'cd "$HOME/book4edge-build/linux-mainline" && make help | rg -n "dtb|dtbs" | head -n 40'
wsl bash -lc 'cd "$HOME/book4edge-build/linux-mainline" && rg -n "single targets|dtbs_install|%.dtb|dtb-\$(CONFIG_ARCH_QCOM)" Makefile arch/arm64/boot/dts/qcom/Makefile scripts | head -n 80'
```
<!-- markdownlint-enable MD013 -->
