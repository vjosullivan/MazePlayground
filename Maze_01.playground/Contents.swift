//: Playground - noun: a place where people can play

import Foundation

class Cell {
    let row: Int
    let col: Int

    var north: Cell?
    var south: Cell?
    var east: Cell?
    var west: Cell?

    private(set) var links = [Cell]()

    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }


    /// Adds a link from this `Cell` to another `Cell` (unless they are already linked,
    /// in which case nothing happens).
    /// If the link is bidirectional, the other `Cell` is linkined back to this `Cell`.
    /// - Note: When the function calls the other cell for a link back, then `bidirectional`
    ///         is set to false to prevent an infinite loop of links.
    ///
    /// - Parameters:
    ///   - otherCell: The `Cell` to be linked.
    ///   - bidirectional: `true` (default) if a link back from the other `Cell` is
    ///                    required, otherwise `false`.
    ///
    public func link(_ otherCell: Cell, bidirectional: Bool = true) {
        if !links.contains { $0 == otherCell } {
            links.append(otherCell)
            if bidirectional {
                otherCell.link(self, bidirectional: false)
            }
        }
    }

    /// Unlinks any and all links from this `Cell` to the other `Cell`.
    /// If the link is bidirectional, the other `Cell` is unlinkined from this `Cell`, too.
    /// - Note: When the function calls the other cell to unlink it, then `bidirectional`
    ///         is set to false to prevent an infinite loop of unlinking.
    ///
    /// - Parameters:
    ///   - otherCell: The `Cell` to be unlinked.
    ///   - bidirectional: `true` (default) if the other `Cell` should also unlinking,
    ///                    otherwise `false`.
    ///
    func unlink(_ otherCell: Cell, bidirectional: Bool = true) {
        links.drop { $0 == otherCell }
        if bidirectional {
            otherCell.unlink(self, bidirectional: false)
        }
    }

    func isLinked(to otherCell: Cell?) -> Bool {
        guard let cell = otherCell else { return false }
        return links.contains(cell)
    }

    func neighbours() -> [Cell] {
        var list = [Cell]()
        if north != nil { list.append(north!) }
        if south != nil { list.append(south!) }
        if east  != nil { list.append(east!)  }
        if west  != nil { list.append(west!)  }
        return list
    }
}

extension Cell: Equatable {
    static func ==(lhs: Cell, rhs: Cell) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
}

extension Grid {
    func binaryTree() {
        var r = 0
        var c = 0
        for rowOfCells in cells {
            c = 0
            for cell in rowOfCells {
                var neighbours = [Cell]()
                if let north = cell.north { neighbours.append(north) }
                if let east  = cell.east  { neighbours.append(east)  }
                if neighbours.count > 0 { cell.link(randomNeighbour(from: neighbours)) }
                if (r == 4) && (c == 5){
                    print("row:", r, ", col:", c)
                }
                c += 1
            }
            r += 1
        }
    }

    func randomNeighbour(from neighbours: [Cell]) -> Cell {
        let index = Int(arc4random_uniform(UInt32(neighbours.count)))
        print (neighbours.count, "-", index)
        return neighbours[index]
    }
}

extension Grid: CustomStringConvertible {
    var description: String {
        var output = "+" + String(repeating: "---+", count: cols) + "\n"
        var r = 0
        var c = 0
        for rowOfCells in cells {
            c = 0
            var top    = "|"
            var bottom = "+"
            for cell in rowOfCells {
                let body = "   "
                let eastBoundary = cell.isLinked(to: cell.east) ? " " : "|"
                top += body + eastBoundary
                let southBoundary = cell.isLinked(to: cell.south) ? "   " : "---"
                bottom += southBoundary + "+"
                c += 1
            }
            r += 1
            output += top + "\n"
            output += bottom + "\n"
        }
        return output
    }
}

class Grid {

    // MARK: - Internal properties.

    let rows: Int
    let cols: Int

    private var cells = [[Cell]]()

    // MARK: - Public functions.

    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols

        print("A")
        prepareGrid()
        print("B")
        configureCells()
        print("C")
        binaryTree()
    }

    public func cell(row: Int, col: Int) -> Cell {
        return cells[row][col]
    }

    public func setCellAt(row: Int, col: Int, to newValue: Cell) {
        cells[row][col] = newValue
    }

    private func prepareGrid() {
        for row in 0..<rows {
            var columnContents = [Cell]()
            for col in 0..<cols {
                columnContents.append(Cell(row: row, col: col))
            }
            print(columnContents)
            cells.append(columnContents)
        }
    }

    private func configureCells() {
        let maxRow = rows - 1
        let maxCol = cols - 1
        print("BA", maxRow, maxCol)
        for rowOfCells in cells {
            print("BB")
            for cell in rowOfCells {
                print("BC1")
                let row = cell.row
                let col = cell.col
                print("BC2", row, col)
                cell.north = (row > 0)      ? cells[row - 1][col] : nil
                print("BC3")
                cell.south = (row < maxRow) ? cells[row + 1][col] : nil
                print("BC4", row, col)
                cell.east  = (col < maxCol) ? cells[row][col + 1] : nil
                print("BC5", row, col)
                cell.west  = (col > 0)      ? cells[row][col - 1] : nil
                print("BC6")
            }
        }
    }
}

var grid = Grid(rows: 4, cols: 8)
print(grid.description)


