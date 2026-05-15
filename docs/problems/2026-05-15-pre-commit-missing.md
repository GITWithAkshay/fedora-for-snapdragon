# Problem: pre-commit missing on local machine

## Exact error

<!-- markdownlint-disable MD013 -->
```text
pre-commit:
Line |
   2 |  pre-commit --version
     |  ~~~~~~~~~~
     | The term 'pre-commit' is not recognized as a name of a cmdlet,
       function, script file, or executable program.
Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
```
<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Open PowerShell in the repository root.
2. Run `pre-commit --version`.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Python: 3.13.12
- Node: v24.14.1
- npm: 11.11.0
- WSL default distro: FedoraLinux-43

## First hypothesis

The machine has Python installed but does not have the `pre-commit`
package installed globally or inside a project-local virtual environment,
so the command is unavailable on `PATH`.
