//
// This source file is part of the Stanford Biodesign for Digital Health open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// Converts the output of `xccov view --archive --json` into an lcov tracefile.
///
/// The tracefile has one `DA` entry per executable line. Paths are written as `xccov` reports them.
/// Files without executable lines are omitted, and the output is sorted so that it is reproducible.
public func lcov(fromArchiveJSON data: Data) throws -> String {
    let archive: [String: [SourceLine]]
    do {
        archive = try JSONDecoder().decode([String: [SourceLine]].self, from: data)
    } catch is DecodingError {
        throw ConversionError.unexpectedFormat
    }
    return try archive.keys.sorted().reduce(into: "") { output, path in
        let lines = archive[path, default: []]
            .filter(\.isExecutable)
            .sorted { $0.line < $1.line }
        guard !lines.isEmpty else {
            return
        }
        var coveredLines = 0
        output += "SF:\(path)\n"
        for line in lines {
            guard let executionCount = line.executionCount else {
                throw ConversionError.missingExecutionCount(path: path, line: line.line)
            }
            coveredLines += executionCount > 0 ? 1 : 0
            output += "DA:\(line.line),\(executionCount)\n"
        }
        output += "LF:\(lines.count)\nLH:\(coveredLines)\nend_of_record\n"
    }
}


/// One line of a source file, as reported by `xccov view --archive --json`.
private struct SourceLine: Decodable {
    let line: Int
    let isExecutable: Bool
    let executionCount: Int?
}
