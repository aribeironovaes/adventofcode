import Foundation

/// The SafeDial class for method 0x434C49434B
/// Counts every time the dial passes through or lands on 0 during rotations
class SafeDial {
    private(set) var currentPosition: Int
    private(set) var totalClicksThroughZero: Int = 0

    // The dial has 100 positions (0-99)
    private let dialSize = 100

    init(startingPosition: Int = 50) {
        self.currentPosition = startingPosition
    }

    /// Rotate the dial according to the instruction
    /// Counts every click through position 0 during the rotation
    /// - Parameter rotation: The rotation instruction to apply
    func rotate(_ rotation: Rotation) {
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
            // This happens if start < remaining (we go negative and wrap)
            if start < remaining {
                count += 1
            }
        }

        return count
    }

    /// Process a list of rotation instructions
    /// - Parameter rotations: Array of rotation instructions
    /// - Returns: The total number of times the dial passed through 0
    func processRotations(_ rotations: [Rotation]) -> Int {
        totalClicksThroughZero = 0

        for rotation in rotations {
            rotate(rotation)
        }

        return totalClicksThroughZero
    }
}
