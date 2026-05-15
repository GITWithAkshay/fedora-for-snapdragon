# Problem: shellcheck SC1091 in setup-wsl-fedora.sh

## Exact error

```text
In scripts/setup-wsl-fedora.sh line 31:
source "$VENV_PATH/bin/activate"
       ^-----------------------^ SC1091 (info): Not following:
       ./bin/activate was not specified as input (see shellcheck -x).
```

## Reproduction steps

1. Run:

   ```text
   wsl bash -lc '
     cd "/mnt/c/Users/GITWi/OneDrive/Documents/New project" &&
     bash scripts/setup-wsl-fedora.sh
   '
   ```

2. Let the package installation and Python setup complete.
3. Observe `shellcheck` fail during `bash scripts/validate.sh`.

## Environment

- OS: FedoraLinux-43 on WSL2
- Architecture: aarch64
- Validation command:
  `shellcheck scripts/*.sh`

## First hypothesis

ShellCheck cannot statically follow the virtual environment activation
script because it is created dynamically at runtime and is not part of the
checked input set.
