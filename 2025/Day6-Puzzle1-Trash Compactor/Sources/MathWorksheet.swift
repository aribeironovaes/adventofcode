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

    /// Parse worksheet from input string
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
}
