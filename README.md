<!--

This source file is part of the Stanford Biodesign Digital Health Group open-source organization

SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

# xccov2lcov

A utility to convert data from Xcode 11's code coverage facility into the `lcov` file format.

Based on [trax-retail/xccov2lcov](https://github.com/trax-retail/xccov2lcov) written by David Whetstone @ [Trax Retail](https://traxretail.com/).


## Usage: CLI

```
USAGE: xccov2lcov [<input-filename>] [--trim-path <trim-path>] [--targets <targets> ...] [--mode <mode>]

ARGUMENTS:
  <input-filename>        Input filename (output of `xccov view --report --json file.xcresult`). Omit to read input from STDIN.

OPTIONS:
  --trim-path <trim-path> Path to trim from start of paths in input file
  --targets <targets>     Targets to include in output (default: all targets)
  --mode <mode>           mode (default: simple)
  -h, --help              Show help information.
```

Given a `Schema.xcresult` file, you can obtain a `lcov` file as follows:

```
xcrun xccov view --report --json Schema.xcresult | xccov2lcov > info.lcov
```

The resulting `info.lcov` file can be uploaded to e.g. Codecov. 


## Usage: GitHub Action

You can also use this tool as a GitHub Action:

```yml
jobs:
  build_and_test:
    name: Build and Test using xcodebuild
    steps:
      - uses: actions/checkout@v4
      - uses: maxim-lobanov/setup-xcode@v1
      - name: build and test
        run: |
            xcrun xcodebuild test \
              -scheme "${{ inputs.scheme }}" \
              -configuration "${{ inputs.buildConfig }}" \
              -destination ".derivedData" \
              -enableCodeCoverage YES \
              -resultBundlePath "${{ inputs.scheme }}.xcresult"
      - uses: SchmiedmayerLab/xccov2lcov@v1
        with:
          xcresult: ${{ inputs.scheme }}.xcresult
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v5
        with:
          fail_ci_if_error: true
          token: ${{ secrets.token }}
```


## Our Research

For more information, visit the [Schmiedmayer Lab GitHub organization](https://github.com/SchmiedmayerLab).

![Stanford and Stanford Medicine logos](https://raw.githubusercontent.com/SchmiedmayerLab/.github/main/assets/stanford-footer-light.png#gh-light-mode-only)
![Stanford and Stanford Medicine logos](https://raw.githubusercontent.com/SchmiedmayerLab/.github/main/assets/stanford-footer-dark.png#gh-dark-mode-only)
