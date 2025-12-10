import Foundation

/// Union-Find (Disjoint Set Union) data structure for tracking connected components
class UnionFind {
    private var parent: [Int]
    private var rank: [Int]
    private(set) var componentSizes: [Int]

    init(size: Int) {
        parent = Array(0..<size)
        rank = Array(repeating: 0, count: size)
        componentSizes = Array(repeating: 1, count: size)
    }

    /// Find the root of the component containing x (with path compression)
    func find(_ x: Int) -> Int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }

    /// Union two components (by rank)
    /// Returns true if they were in different components (connection made)
    @discardableResult
    func union(_ x: Int, _ y: Int) -> Bool {
        let rootX = find(x)
        let rootY = find(y)

        if rootX == rootY {
            return false // Already in same component
        }

        // Union by rank
        if rank[rootX] < rank[rootY] {
            parent[rootX] = rootY
            componentSizes[rootY] += componentSizes[rootX]
        } else if rank[rootX] > rank[rootY] {
            parent[rootY] = rootX
            componentSizes[rootX] += componentSizes[rootY]
        } else {
            parent[rootY] = rootX
            componentSizes[rootX] += componentSizes[rootY]
            rank[rootX] += 1
        }

        return true
    }

    /// Get all component sizes
    func getAllComponentSizes() -> [Int] {
        // First, ensure all paths are compressed
        for i in 0..<parent.count {
            _ = find(i)
        }

        // Now collect sizes of actual roots
        var sizes: [Int] = []
        for i in 0..<parent.count {
            if parent[i] == i {
                sizes.append(componentSizes[i])
            }
        }
        return sizes
    }
}
