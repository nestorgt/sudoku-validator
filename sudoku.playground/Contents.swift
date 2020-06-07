import UIKit

/// Digits 1-9 each appearing once and only once in each
    // row
    // column
    // 3x3

enum SudokuError: Error, Equatable {
    case invalid(size: Int)
    case invalid(size: Int, details: String)
    case missing(numbers: Set<Int>)
    case missing(numbers: Set<Int>, key: String)
}

/// Throws the first error ecountered in the validation of a Sudoku 9x9.
/// It loops only once through the sudoku to store key pairs like:
///   ["line0"] = [1,2,3,4,5,6,7,8,9]
///   ["colunn0"] = [1,2,3,4,5,6,7,8,9]
///   ["sudoku00"] = [1,2,3,4,5,6,7,8,9]
///   - where `line & column keys = 1...9` and `sudoku keys = "\(0..2)\(0..2)"`
/// Then it validates each array with `validate(numbers:)`.
func validate9x9(sudoku: [[Int]]) throws {
    var dict = [String: [Int]]()
    enum ValueType: String {
        case line, column, sudoku
    }
    func update(_ valueType: ValueType, key: String, appending value: Int) {
        let key = "\(valueType.rawValue)\(key)"
        if var updatedLine = dict[key] {
            updatedLine.append(value)
            dict[key] = updatedLine
        } else {
            dict[key] = [value]
        }
    }
    
    guard sudoku.count == 9
        else { throw SudokuError.invalid(size: sudoku.count, details: "External array") }
    for (lineIndex, array) in sudoku.enumerated() {
        for (columnIndex, number) in array.enumerated() {
            update(.line, key: "\(lineIndex)", appending: number)
            update(.column, key: "\(columnIndex)", appending: number)
            update(.sudoku, key: "\(lineIndex / 3)\(columnIndex / 3)", appending: number)
        }
    }
    // Sorting by keys to return the same error across different executions
    for key in dict.keys.sorted() {
        try validate(numbers: dict[key]!, description: "\(key)")
    }
}

/// Throws an error ecountered in the validation of a Sudoku 3x3.
func validate3x3(sudoku: [[Int]]) throws {
    try validate(numbers: sudoku.flatMap { $0 })
}

/// Validate an array of number that should have 9 different numbers from 0...9.
func validate(numbers: [Int], description: String? = nil) throws {
    guard numbers.count == 9 else {
        throw description != nil ?
            SudokuError.invalid(size: numbers.count, details: description!) :
            SudokuError.invalid(size: numbers.count)
    }
    let allNumbers: Set<Int> = [1,2,3,4,5,6,7,8,9]
    let missingNumbers = allNumbers.subtracting(numbers)
    guard missingNumbers.count == 0 else {
        throw description != nil ?
            SudokuError.missing(numbers: missingNumbers, key: description!) :
            SudokuError.missing(numbers: missingNumbers)
    }
}

// MARK: - Sample data

struct Sample {
    
    struct Numbers {
        static let valid = [1,2,3,4,5,6,7,8,9]
        static let empty = [Int]()
        static let invalidSizeSeven = [1,2,4,6,7,8,9]
        static let missingNumberFive = [1,2,3,4,55,6,7,8,9]
        static let missingNumberOneAndNine = [2,2,3,4,5,6,7,8,8]
    }
    
    struct ThreeDimension {
        static let valid = [[1,2,3], [4,5,6], [7,8,9]]
        static let empty = [[Int]]()
        static let invalidSizeEight = [[1,2,3], [4,5,6], [7,8]]
        static let missingNumberOne = [[2,2,3], [4,5,6], [7,8,9]]
        static let missingThreeAndFive = [[1,2,2], [4,4,6], [7,8,9]]
    }
    
    struct NineDimension {
        static  let valid = [[1,2,3,4,5,6,7,8,9],
                             [4,5,6,7,8,9,1,2,3],
                             [7,8,9,1,2,3,4,5,6],
                             [2,3,4,5,6,7,8,9,1],
                             [5,6,7,8,9,1,2,3,4],
                             [8,9,1,2,3,4,5,6,7],
                             [3,4,5,6,7,8,9,1,2],
                             [6,7,8,9,1,2,3,4,5],
                             [9,1,2,3,4,5,6,7,8]]
        static let empty = [[Int]]()
        static let invalidSizeExternal = [[1,2,3,4,5,6,7,8,9], [1,2,3,4,5,6,7,8,9], [1,2,3,4,5,6,7,8,9]]
        static let invalidSizeInternal = [[1,2], [4,4], [7,8], [1,2], [4,4], [7,8], [1,2], [4,4], [7,8]]
        static let missingNumberInColumn = [[2,2,3,4,5,6,7,8,9],
                                            [4,5,6,7,8,9,1,2,3],
                                            [7,8,9,1,2,3,4,5,6],
                                            [2,3,4,5,6,7,8,9,1],
                                            [5,6,7,8,9,1,2,3,4],
                                            [8,9,1,2,3,4,5,6,7],
                                            [3,4,5,6,7,8,9,1,2],
                                            [6,7,8,9,1,2,3,4,5],
                                            [9,1,2,3,4,5,6,7,8]]
        static let missingNumbersInLine = [[1,1,1,1,1,1,1,1,1],
                                           [2,2,2,2,2,2,2,2,2],
                                           [3,3,3,3,3,3,3,3,3],
                                           [4,4,4,4,4,4,4,4,4],
                                           [5,5,5,5,5,5,5,5,5],
                                           [6,6,6,6,6,6,6,6,6],
                                           [7,7,7,7,7,7,7,7,7],
                                           [8,8,8,8,8,8,8,8,8],
                                           [9,9,9,9,9,9,9,9,9]]
        static  let invalidInternalSudoku = [[1,2,3,4,5,6,7,8,9],
                                             [4,5,6,7,8,9,1,2,3],
                                             [2,3,4,5,6,7,8,9,1],
                                             [7,8,9,1,2,3,4,5,6],
                                             [5,6,7,8,9,1,2,3,4],
                                             [8,9,1,2,3,4,5,6,7],
                                             [3,4,5,6,7,8,9,1,2],
                                             [6,7,8,9,1,2,3,4,5],
                                             [9,1,2,3,4,5,6,7,8]]
    }
}

// MARK: Tests validate(numbers:)

func testNumbers(sut: [Int]) {
    print("\nChecking: \(sut)")
    do {
        try validate(numbers: sut)
        print("-> Success!")
    } catch let error {
        print("-> Error: \(error)")
    }
}

testNumbers(sut: Sample.Numbers.valid)
testNumbers(sut: Sample.Numbers.empty)
testNumbers(sut: Sample.Numbers.invalidSizeSeven)
testNumbers(sut: Sample.Numbers.missingNumberFive)

// MARK: Tests validate3x3(numbers:)

func testSudoku3x3(sut: [[Int]]) {
    print("\nChecking: \(sut)")
    do {
        try validate3x3(sudoku: sut)
        print("-> Success!")
    } catch let error {
        print("-> Error: \(error)")
    }
}

testSudoku3x3(sut: Sample.ThreeDimension.valid)
testSudoku3x3(sut: Sample.ThreeDimension.empty)
testSudoku3x3(sut: Sample.ThreeDimension.missingNumberOne)
testSudoku3x3(sut: Sample.ThreeDimension.missingThreeAndFive)

// MARK: Tests validate9x9(sudoku:)

func testSudoku9x9(sut: [[Int]]) {
    print("\nChecking: \(sut)")
    do {
        try validate9x9(sudoku: sut)
        print("-> Success!")
    } catch let error {
        print("-> Error: \(error)")
    }
}

testSudoku9x9(sut: Sample.NineDimension.valid)
testSudoku9x9(sut: Sample.NineDimension.empty)
testSudoku9x9(sut: Sample.NineDimension.invalidSizeExternal)
testSudoku9x9(sut: Sample.NineDimension.invalidSizeInternal)
testSudoku9x9(sut: Sample.NineDimension.missingNumberInColumn)
testSudoku9x9(sut: Sample.NineDimension.missingNumbersInLine)
testSudoku9x9(sut: Sample.NineDimension.invalidInternalSudoku)
