//
//  LaunchScreenPresenter.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 28.11.23.
//

import Foundation

import UIKit

protocol LaunchScreenPresenterProtocol {
    func moveToHomeScreen()
}

struct LaunchScreenOutput {
    var onMoveToHome: (() -> Void)!
}

final class LaunchScreenPresenter {
    private let output: LaunchScreenOutput

    // MARK: - Init
    
    init(output: LaunchScreenOutput) {
        self.output = output
    }
}

extension LaunchScreenPresenter: LaunchScreenPresenterProtocol {
    func moveToHomeScreen() {
        output.onMoveToHome()
    }
    
}

