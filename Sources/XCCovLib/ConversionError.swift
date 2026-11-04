//
// This source file is part of the Stanford Biodesign for Digital Health open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

/// An error thrown when the input cannot be converted to lcov.
public enum ConversionError: Error, Equatable, CustomStringConvertible {
    /// The input is not the output of `xccov view --archive --json`.
    case unexpectedFormat
    /// An executable line has no execution count.
    case missingExecutionCount(path: String, line: Int)
    
    public var description: String {
        switch self {
        case .unexpectedFormat:
            "Input is not the output of `xccov view --archive --json`."
        case let .missingExecutionCount(path, line):
            "Executable line \(line) of \(path) has no execution count."
        }
    }
}
