//
//  MatrixLinearizer.swift
//  SLESolver
//
//  Created by Дмитрий Савинов on 16.09.2021.
//

import Foundation

// MARK: - MatrixLinearizer

public protocol MatrixLinearizer {

    var detMultiplyer: Double { get }
    var linesSwapCount: Int { get }

    func liniarize(_ matrix: MutableMatrix) throws -> MutableMatrix
}
