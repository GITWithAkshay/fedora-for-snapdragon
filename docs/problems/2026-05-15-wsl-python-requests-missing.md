# Problem: WSL helper script assumed python requests was installed

## Exact error

```text
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ModuleNotFoundError: No module named 'requests'
```

## Reproduction steps

1. Run a Python helper in Fedora WSL that starts with `import requests`.
2. Execute it in the default project environment.

## Environment

- OS: FedoraLinux-43 on WSL2
- Python: 3.14.2
- Context: temporary patch-inspection helper

## First hypothesis

The helper script assumed the third-party `requests` module was available,
but it is not installed in the default WSL Python environment.
