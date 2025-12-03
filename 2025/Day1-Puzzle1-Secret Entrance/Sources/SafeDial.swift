import Foundation

/// The SafeDial class represents the circular dial with numbers 0-99
class SafeDial {
    private(set) var currentPosition: Int
    private(set) var timesLandedOnZero: Int = 0
    private(set) var totalClicksThroughZero: Int = 0

    // The dial has 100 positions (0-99)
    private let dialSize = 100

    init(startingPosition: Int = 50) {
        self.currentPosition = startingPosition
    }

    // MARK: - Part 1: Count times landing on 0

    /// Rotate the dial according to the instruction
    /// - Parameter rotation: The rotation instruction to apply
    func rotate(_ rotation: Rotation) {
        switch rotation.direction {
        case .left:
            // Subtract distance for left rotation
            currentPosition = (currentPosition - rotation.distance) % dialSize
            // Handle negative numbers: Swift's modulo can return negative values
            if currentPosition < 0 {
                currentPosition += dialSize
            }

        case .right:
            // Add distance for right rotation
            currentPosition = (currentPosition + rotation.distance) % dialSize
        }

        // Check if we landed on 0
        if currentPosition == 0 {
            timesLandedOnZero += 1
        }
    }

    /// Process a list of rotation instructions (Part 1)
    /// - Parameter rotations: Array of rotation instructions
    /// - Returns: The number of times the dial landed on 0
    func processRotations(_ rotations: [Rotation]) -> Int {
        timesLandedOnZero = 0

        for rotation in rotations {
            rotate(rotation)
        }

        return timesLandedOnZero
    }

    // MARK: - Part 2: Count every click through 0

    /// Rotate the dial according to the instruction (Part 2 version)
    /// Counts every click through position 0 during the rotation
    /// - Parameter rotation: The rotation instruction to apply
    func rotatePart2(_ rotation: Rotation) {
        let distance = rotation.distance

        // Count how many times we pass through 0 during this rotation
        let clicksThrough = countClicksThroughZero(
            from: currentPosition,
            distance: distance,
            direction: rotation.direction
        )

        totalClicksThroughZero += clicksThrough

        // Update current position
        switch rotation.direction {
        case .left:
            currentPosition = (currentPosition - distance) % dialSize
            if currentPosition < 0 {
                currentPosition += dialSize
            }
        case .right:
            currentPosition = (currentPosition + distance) % dialSize
        }
    }

    /// Count how many times we pass through 0 during a rotation
    /// - Parameters:
    ///   - start: Starting position
    ///   - distance: Number of clicks to rotate
    ///   - direction: Direction of rotation (left or right)
    /// - Returns: Number of times we pass through or land on 0
    private func countClicksThroughZero(from start: Int, distance: Int, direction: Rotation.Direction) -> Int {
        // Every complete rotation (100 clicks) passes through 0 once
        let completeRotations = distance / dialSize
        var count = completeRotations

        // Check if partial rotation crosses 0
        let remaining = distance % dialSize

        switch direction {
        case .right:
            // Rotating right: check if we cross from 99 to 0
            // This happens if start + remaining >= 100
            if start + remaining >= dialSize {
                count += 1
            }
        case .left:
            // Rotating left: check if we cross from 0 to 99
            // This happens if start <= remaining (we go to 0 or negative and wrap)
            // But only if we're not already starting at 0
            if start > 0 && start <= remaining {
                count += 1
            }
        }

        return count
    }

    /// Process a list of rotation instructions (Part 2)
    /// - Parameter rotations: Array of rotation instructions
    /// - Returns: The total number of times the dial passed through 0
    func processRotationsPart2(_ rotations: [Rotation]) -> Int {
        totalClicksThroughZero = 0

        for rotation in rotations {
            rotatePart2(rotation)
        }

        return totalClicksThroughZero
    }
}
