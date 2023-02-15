# ql [![checks](https://github.com/pmeinhardt/ql/actions/workflows/checks.yml/badge.svg)](https://github.com/pmeinhardt/ql/actions/workflows/checks.yml)

Preview files from the command-line using macOS Quick Look.

Open a file in Quick Look from the command-line:

```shell
ql <path/to/file>
```

Yes, there is `qlmanage`. But you’d always have `[DEBUG]` staring at you.

## Building

In order to build the command, just run:

```shell
make
```

This requires `swiftc` to be installed.

You can then copy the resulting binary anywhere you like or add the `bin/` directory to your `PATH`.

## References

- https://developer.apple.com/documentation/quicklook
- https://developer.apple.com/documentation/quicklookui
