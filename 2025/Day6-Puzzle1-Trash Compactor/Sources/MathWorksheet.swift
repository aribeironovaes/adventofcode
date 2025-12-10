import Foundation

/// Represents a math problem with numbers and an operator
struct MathProblem {
    let numbers: [Int]
    let operation: Character  // '+' or '*'

    /// Calculate the result of this problem
    func solve() -> Int {
        guard !numbers.isEmpty else { return 0 }

        var result = numbers[0]
        for num in numbers.dropFirst() {
            if operation == "+" {
                result += num
            } else if operation == "*" {
                result *= num
            }
        }
        return result
    }
}

/// Parses and solves a cephalopod math worksheet
class MathWorksheet {
    private let problems: [MathProblem]

    init(problems: [MathProblem]) {
        self.problems = problems
    }

    /// Calculate the grand total (sum of all problem answers)
    func calculateGrandTotal() -> Int {
        return problems.map { $0.solve() }.reduce(0, +)
    }

    /// Parse worksheet from input string (Part 1)
    /// Numbers are arranged vertically in columns, operators at bottom
    static func parse(from input: String) -> MathWorksheet? {
        let lines = input.split(separator: "\n").map { String($0) }
        guard lines.count >= 2 else { return nil }

        // Last line contains operators
        let operatorLine = lines.last!

        // All lines except last contain numbers
        let numberLines = Array(lines.dropLast())

        // Split by whitespace to get tokens
        let numberTokens = numberLines.map { $0.split(separator: " ").compactMap { Int(String($0)) } }
        let operatorTokens = operatorLine.split(separator: " ").compactMap { str -> Character? in
            let ch = Character(String(str))
            return (ch == "+" || ch == "*") ? ch : nil
        }

        guard !operatorTokens.isEmpty else { return nil }

        var problems: [MathProblem] = []

        // For each column (based on operators), collect numbers
        for (col, op) in operatorTokens.enumerated() {
            var columnNumbers: [Int] = []

            for row in numberTokens {
                if col < row.count {
                    columnNumbers.append(row[col])
                }
            }

            if !columnNumbers.isEmpty {
                problems.append(MathProblem(numbers: columnNumbers, operation: op))
            }
        }

        return MathWorksheet(problems: problems)
    }

    /// Parse worksheet from input string (Part 2 - Cephalopod math)
    /// Read right-to-left, digits vertically form multi-digit numbers
    static func parseCephalopod(from input: String) -> MathWorksheet? {
        let lines = input.split(separator: "\n").map { String($0) }
        guard lines.count >= 2 else { return nil }

        // Last line contains operators
        let operatorLine = lines.last!

        // All lines except last contain number digits
        let numberLines = Array(lines.dropLast())

        // Find the maximum line length to determine column positions
        let maxLength = max(numberLines.map { $0.count }.max() ?? 0, operatorLine.count)

        var problems: [MathProblem] = []

        // Helper to get character at column
        func charAt(_ line: String, _ col: Int) -> Character {
            if col < line.count {
                return line[line.index(line.startIndex, offsetBy: col)]
            }
            return " "
        }

        // Read right-to-left to find operators
        var col = maxLength - 1
        while col >= 0 {
            let opChar = charAt(operatorLine, col)

            if opChar == "+" || opChar == "*" {
                // Found an operator - collect all number columns to the right (including this one)
                var problemNumbers: [Int] = []

                // Scan right from operator position to collect all number columns
                var scanCol = col
                while scanCol < maxLength {
                    // Check if this column has any digits (is not all spaces)
                    var digitString = ""
                    var hasDigits = false

                    for line in numberLines {
                        let char = charAt(line, scanCol)
                        if char.isNumber {
                            hasDigits = true
                            digitString.append(char)
                        } else if char != " " {
                            // Non-digit, non-space character
                            hasDigits = false
                            break
                        }
                    }

                    if hasDigits {
                        if let num = Int(digitString) {
                            problemNumbers.append(num)
                        }
                        scanCol += 1
                    } else {
                        // Empty column marks end of this problem
                        break
                    }
                }

                if !problemNumbers.isEmpty {
                    // Numbers were collected left-to-right, but we want rightmost first
                    problems.append(MathProblem(numbers: problemNumbers, operation: opChar))
                }

                // Move to the column before this operator
                col -= 1
            } else {
                col -= 1
            }
        }

        // Problems were collected right-to-left, reverse to get left-to-right order
        return MathWorksheet(problems: problems.reversed())
    }
}
