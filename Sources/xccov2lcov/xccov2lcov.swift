//
// This source file is part of the Stanford Biodesign for Digital Health open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import XCCovLib


@main
enum XCCov2LCOV {
    private static let usage = """
        USAGE: xccov2lcov [<input-filename>]
        
        ARGUMENTS:
          <input-filename>  Output of `xcrun xccov view --archive --json file.xcresult`. Omit to read from STDIN.
        
        """
    
    static func main() {
        let arguments = CommandLine.arguments.dropFirst()
        guard arguments.count <= 1, arguments.first?.hasPrefix("-") != true else {
            exit(with: usage)
        }
        do {
            let input = try arguments.first.map { try Data(contentsOf: URL(fileURLWithPath: $0)) }
                ?? FileHandle.standardInput.readDataToEndOfFile()
            FileHandle.standardOutput.write(Data(try lcov(fromArchiveJSON: input).utf8))
        } catch {
            exit(with: "error: \(error)\n")
        }
    }
    
    private static func exit(with message: String) -> Never {
        FileHandle.standardError.write(Data(message.utf8))
        Foundation.exit(1)
    }
}
