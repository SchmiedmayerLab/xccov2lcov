<!--

This source file is part of the Stanford Biodesign Digital Health Group open-source organization

SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

# xccov2lcov

A utility to convert Xcode code coverage data into the `lcov` file format, with one entry per executable line.

Originally based on [trax-retail/xccov2lcov](https://github.com/trax-retail/xccov2lcov) written by David Whetstone @ [Trax Retail](https://traxretail.com/).


## Usage: CLI

```
USAGE: xccov2lcov [<input-filename>]

ARGUMENTS:
  <input-filename>  Output of `xcrun xccov view --archive --json file.xcresult`. Omit to read from STDIN.
```

Given a `Schema.xcresult` file, you can obtain a `lcov` file as follows:

```
xcrun xccov view --archive --json Schema.xcresult | swift run xccov2lcov > info.lcov
```

The resulting `info.lcov` file can be uploaded to e.g. Codecov.
It uses the absolute paths reported by `xccov`, which Codecov maps to the files in your repository.

The tool reads `xccov view --archive` rather than `xccov view --report`, because the report only contains data per function, not per line.


## Usage: GitHub Action

You can also use this tool as a GitHub Action.
It runs on macOS, and builds the tool using the selected Xcode:

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
