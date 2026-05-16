# Problem: aria2c was installed but not yet visible in the current shell PATH

## Exact error

```text
aria2c:
Line |
   2 |  aria2c --dir=downloads --out=Fedora-Workstation-Live-44-1.7.aarch64.i …
   |  ~~~~~~
   | The term 'aria2c' is not recognized as a name of a cmdlet, function,
   | script file, or executable program.
   | Check the spelling of the name, or if a path was included, verify that
   | the path is correct and try again.
```

## Reproduction steps

1. Install `aria2` with `winget`.
2. Stay in the same PowerShell session.
3. Run `aria2c` by name.
4. Observe PowerShell fail to resolve the new executable from PATH.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Package source: `winget`

## First hypothesis

The `winget` install updated the user PATH for future shells, but the
current PowerShell session has not reloaded that PATH yet.
