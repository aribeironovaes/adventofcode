import Foundation

/// The SafeDial class represents the circular dial with numbers 0-99
class SafeDial {
    private(set) var currentPosition: Int
    private(set) var timesLandedOnZero: Int = 0

    // The dial has 100 positions (0-99)
    private let dialSize = 100

    init(startingPosition: Int = 50) {
        self.currentPosition = startingPosition
    }

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

    /// Process a list of rotation instructions
    /// - Parameter rotations: Array of rotation instructions
    /// - Returns: The number of times the dial landed on 0
    func processRotations(_ rotations: [Rotation]) -> Int {
        timesLandedOnZero = 0

        for rotation in rotations {
            rotate(rotation)
        }

        return timesLandedOnZero
    }
}
