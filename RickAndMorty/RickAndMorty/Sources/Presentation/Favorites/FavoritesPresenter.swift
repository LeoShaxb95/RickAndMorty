//
//  FavoritesPresenter.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 20.11.23.
//

import UIKit

protocol FavoritesPresenterProtocol {
    func moveToCharacterDetailsScreen(_ model: Custom)
}

struct FavoritesOutput {
    var onMoveToCharacterDetails: ((Custom) -> Void)!
}

final class FavoritesPresenter {
    private let output: FavoritesOutput

    // MARK: - Init
    
    init(output: FavoritesOutput) {
        self.output = output
    }
    
}

extension FavoritesPresenter: FavoritesPresenterProtocol {
    func moveToCharacterDetailsScreen(_ model: Custom) {
        output.onMoveToCharacterDetails(model)
    }
}


