# Problem: inline WSL build command resolved the output path to empty

## Exact error

```text
mkdir: cannot create directory ‘’: No such file or directory
```

## Reproduction steps

1. Run a multi-line `wsl bash -lc` command that sets `SRC` and `OUT`.
2. Attempt `mkdir -p "$OUT"` inside that command.

## Environment

- OS: FedoraLinux-43 on WSL2
- Context: inline kernel build bootstrap command
- Intended output tree: `~/book4edge-build/out-book4edge`

## First hypothesis

The nested quoting in the long inline `wsl bash -lc` command caused the
build-path variable assignment to fail, so the output directory variable
expanded to an empty string.
