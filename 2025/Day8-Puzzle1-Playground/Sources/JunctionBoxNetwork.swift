import Foundation

/// Represents a 3D point (junction box)
struct Point3D {
    let x: Int
    let y: Int
    let z: Int

    /// Calculate squared Euclidean distance to another point
    /// Using squared distance avoids expensive sqrt and maintains ordering
    func squaredDistanceTo(_ other: Point3D) -> Int {
        let dx = x - other.x
        let dy = y - other.y
        let dz = z - other.z
        return dx * dx + dy * dy + dz * dz
    }
}

/// Represents an edge (connection) between two junction boxes
struct Edge: Comparable {
    let from: Int
    let to: Int
    let squaredDistance: Int

    static func < (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.squaredDistance < rhs.squaredDistance
    }
}

/// Manages junction box connections and circuit calculations
class JunctionBoxNetwork {
    private let points: [Point3D]
    private let edges: [Edge]

    init?(from input: String) {
        let lines = input.split(separator: "\n").map { String($0) }
        guard !lines.isEmpty else { return nil }

        // Parse points
        var parsedPoints: [Point3D] = []
        for line in lines {
            let coords = line.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            guard coords.count == 3 else { continue }
            parsedPoints.append(Point3D(x: coords[0], y: coords[1], z: coords[2]))
        }

        guard !parsedPoints.isEmpty else { return nil }
        self.points = parsedPoints

        // Calculate all pairwise edges
        var allEdges: [Edge] = []
        for i in 0..<points.count {
            for j in (i+1)..<points.count {
                let dist = points[i].squaredDistanceTo(points[j])
                allEdges.append(Edge(from: i, to: j, squaredDistance: dist))
            }
        }

        // Sort edges by distance
        self.edges = allEdges.sorted()
    }

    /// Connect the shortest N edge pairs and calculate product of three largest circuits
    /// Note: Attempts N edges, some may be skipped if already connected
    func connectShortestEdges(_ n: Int) -> Int {
        let uf = UnionFind(size: points.count)

        // Try to connect the N shortest edges (some may be skipped)
        for i in 0..<min(n, edges.count) {
            uf.union(edges[i].from, edges[i].to)
        }

        // Get all component sizes
        let sizes = uf.getAllComponentSizes().sorted(by: >)

        // Multiply the three largest
        guard sizes.count >= 3 else {
            // Handle edge case where we have fewer than 3 components
            if sizes.count == 1 {
                return sizes[0] * sizes[0] * sizes[0]
            } else if sizes.count == 2 {
                return sizes[0] * sizes[1] * sizes[1]
            }
            return 0
        }

        return sizes[0] * sizes[1] * sizes[2]
    }

    /// Connect edges until all junction boxes form a single circuit
    /// Returns the product of X coordinates of the last two boxes connected
    func connectUntilSingleCircuit() -> Int {
        let uf = UnionFind(size: points.count)
        var numComponents = points.count

        // Keep connecting until we have a single component
        for edge in edges {
            if uf.union(edge.from, edge.to) {
                numComponents -= 1

                // Check if we've connected everything into one circuit
                if numComponents == 1 {
                    // This was the final connection
                    let x1 = points[edge.from].x
                    let x2 = points[edge.to].x
                    return x1 * x2
                }
            }
        }

        // Should not reach here if input is valid
        return 0
    }
}
