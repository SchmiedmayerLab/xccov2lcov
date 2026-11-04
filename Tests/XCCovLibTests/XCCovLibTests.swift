//
// This source file is part of the Stanford Biodesign for Digital Health open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import Testing
import XCCovLib


@Suite("XCCovLibTests")
struct XCCovLibTests {
    private func convert(_ json: String) throws -> String {
        try lcov(fromArchiveJSON: Data(json.utf8))
    }
    
    
    @Test
    func emitsOneEntryPerExecutableLine() throws {
        let output = try convert("""
            {
              "/repo/Sources/File.swift": [
                { "line": 1, "isExecutable": false },
                { "line": 2, "isExecutable": true, "executionCount": 3 },
                { "line": 3, "isExecutable": true, "executionCount": 0 },
                { "line": 4, "isExecutable": true, "executionCount": 3,
                  "subranges": [{ "column": 9, "length": 4, "executionCount": 0 }] }
              ]
            }
            """)
        #expect(output == """
            SF:/repo/Sources/File.swift
            DA:2,3
            DA:3,0
            DA:4,3
            LF:3
            LH:2
            end_of_record
            
            """)
    }
    
    
    @Test
    func sortsFilesAndLines() throws {
        let output = try convert("""
            {
              "/repo/B.swift": [
                { "line": 9, "isExecutable": true, "executionCount": 1 },
                { "line": 2, "isExecutable": true, "executionCount": 1 }
              ],
              "/repo/A.swift": [{ "line": 1, "isExecutable": true, "executionCount": 0 }]
            }
            """)
        #expect(output == """
            SF:/repo/A.swift
            DA:1,0
            LF:1
            LH:0
            end_of_record
            SF:/repo/B.swift
            DA:2,1
            DA:9,1
            LF:2
            LH:2
            end_of_record
            
            """)
    }
    
    
    @Test
    func omitsFilesWithoutExecutableLines() throws {
        let output = try convert("""
            { "/repo/Empty.swift": [{ "line": 1, "isExecutable": false }], "/repo/None.swift": [] }
            """)
        #expect(output.isEmpty)
    }
    
    
    @Test
    func rejectsTheFunctionLevelReport() {
        #expect(throws: ConversionError.unexpectedFormat) {
            try convert(#"{ "coveredLines": 1, "executableLines": 2, "lineCoverage": 0.5, "targets": [] }"#)
        }
    }
    
    
    @Test
    func rejectsInputThatIsNotJSON() {
        #expect(throws: (any Error).self) {
            try convert("")
        }
    }
    
    
    @Test
    func rejectsExecutableLinesWithoutACount() {
        #expect(throws: ConversionError.missingExecutionCount(path: "/repo/File.swift", line: 7)) {
            try convert(#"{ "/repo/File.swift": [{ "line": 7, "isExecutable": true }] }"#)
        }
    }
}
