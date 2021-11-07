//
//  MutableMatrix.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - MutableMatrix

public class MutableMatrix {

    // MARK: - Properties

    public var elementsArray: [[Double]]

    // MARK: - Initializers

    /// Default initalizer
    /// - Parameter array: target elements array
    public init(_ array: [[Double]]) {
        elementsArray = array
    }

    // MARK: - Static

    public static func createOneMatrix(ofSize size: Int) -> MutableMatrix {
        var result: [[Double]] = .init(repeating: .init(repeating: 0, count: size), count: size)
        for i in 0..<size { result[i][i] = 1 }
        return .init(result)
    }

    public static func * (lhs: MutableMatrix, rhs: MutableMatrix) -> MutableMatrix {
        var result: [[Double]] = .init(repeating: .init(repeating: 0, count: rhs.elementsArray[0].count), count: lhs.elementsArray.count)
            for i in 0..<lhs.elementsArray.count {
                for j in 0..<rhs.elementsArray[0].count {
                    var sum = 0.0
                    for m in 0..<rhs.elementsArray.count {
                        sum += lhs.elementsArray[i][m] * rhs.elementsArray[m][j]
                    }
                    result[i][j] = sum
                }
            }
        return MutableMatrix(result)
    }

    public static func * (lhs: MutableMatrix, rhs: Vector) -> Vector {
        var result: Vector = .init(repeating: 0, count: lhs.elementsArray.count)
            for i in 0..<lhs.elementsArray.count {
                    var sum = 0.0
                    for m in 0..<rhs.count {
                        sum += lhs.elementsArray[i][m] * rhs[m]
                    }
                    result[i] = sum
            }
        return result
    }

    public static func - (lhs: MutableMatrix, rhs: MutableMatrix) throws -> MutableMatrix {
        guard lhs.elementsArray.count == rhs.elementsArray.count else { throw VectorError.sizesNotEqual }
        let count = lhs.elementsArray.count
        let result: MutableMatrix = .init(.init(repeating: .init(repeating: .zero, count: count), count: count))
        for i in 0..<count {
            for j in 0..<count {
                result.elementsArray[i][j] = lhs.elementsArray[i][j] - rhs.elementsArray[i][j]
            }
        }
        return result
    }
}

// MARK: - MatrixOperations

extension MutableMatrix: MatrixOperations {

    public var isSquare: Bool {
        elementsArray.count == elementsArray[0].count
    }

    public func sum(toRowIndex index: Int, rowWithIndex rowToSumIndex: Int) {
        var count = -1
        elementsArray[index] = elementsArray[index].map {
            count += 1
            return $0 + elementsArray[rowToSumIndex][count]
        }
    }

    public func substruct(fromRowIndex index: Int, rowWithIndex rowToSubIndex: Int) {
        var count = -1
        elementsArray[index] = elementsArray[index].map {
            count += 1
            return $0 - elementsArray[rowToSubIndex][count]
        }
    }

    public func multiply(rowWithIndex index: Int, to multiplayer: Double) {
        elementsArray[index] = line(withIndex: index, multiplyedBy: multiplayer)
    }

    public func line(withIndex index: Int, multiplyedBy multiplayer: Double) -> [Double] {
        elementsArray[index].map { $0 * multiplayer }
    }

    public func line(withIndex index: Int) -> [Double] {
        elementsArray[index]
    }

    public func element(atLine lineIndex: Int, withIndex elementIndex: Int) -> Double {
        elementsArray[lineIndex][elementIndex]
    }

    public func substruct(fromRowIndex index: Int, line: [Double]) {
        var count = -1
        elementsArray[index] = elementsArray[index].map {
            count += 1
            return $0 - line[count]
        }
    }

    public func element(_ element: ElementPosition) -> Double {
        elementsArray[element.lineIndex][element.elementIndex]
    }
}

// MARK: - CustomStringConvertible

extension MutableMatrix: CustomStringConvertible {

    public var description: String {
        var description = "{\n"
        elementsArray.forEach {
            description =  description + "\($0)" + "\n"
        }
        return description + "}"
    }
}

// MARK: - Equatable

extension MutableMatrix: Equatable {

    public static func == (lhs: MutableMatrix, rhs: MutableMatrix) -> Bool {
        lhs.elementsArray == rhs.elementsArray
    }
}