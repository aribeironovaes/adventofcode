import Foundation

/// Represents a rotation instruction for the safe dial
struct Rotation {
    let direction: Direction
    let distance: Int

    enum Direction {
        case left
        case right
    }

    /// Parse a rotation string like "L68" or "R48"
    init?(from string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }

        let firstChar = trimmed.first!
        let distanceString = String(trimmed.dropFirst())

        guard let distance = Int(distanceString) else { return nil }

        switch firstChar {
        case "L":
            self.direction = .left
            self.distance = distance
        case "R":
            self.direction = .right
            self.distance = distance
        default:
            return nil
        }
    }
}
