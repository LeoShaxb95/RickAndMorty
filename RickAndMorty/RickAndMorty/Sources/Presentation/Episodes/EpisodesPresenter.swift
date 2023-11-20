//
//  EpisodesPresenter.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 18.11.23.
//

import UIKit

protocol EpisodesPresenterProtocol {
    func moveToCharacterDetailsScreen()
}

struct EpisodesOutput {
    var onMoveToCharacterDetails: (() -> Void)!
}

final class EpisodesPresenter {
    private let output: EpisodesOutput

    // MARK: - Init
    
    init(output: EpisodesOutput) {
        self.output = output
    }
    
}

extension EpisodesPresenter: EpisodesPresenterProtocol {
    func moveToCharacterDetailsScreen() {
        output.onMoveToCharacterDetails()
    }
}


