//
//  FavoritesPresenter.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 20.11.23.
//

import UIKit

protocol FavoritesPresenterProtocol {
    func moveToCharacterDetailsScreen()
}

struct FavoritesOutput {
    var onMoveToCharacterDetails: (() -> Void)!
}

final class FavoritesPresenter {
    private let output: FavoritesOutput

    // MARK: - Init
    
    init(output: FavoritesOutput) {
        self.output = output
    }
    
}

extension FavoritesPresenter: FavoritesPresenterProtocol {
    func moveToCharacterDetailsScreen() {
        output.onMoveToCharacterDetails()
    }
}


