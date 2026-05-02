//
//  SportsPresenter.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 29/04/2026.
//

import Foundation

protocol SportsPresenterProtocol {
    func viewDidLoad()
    func getSportsCount() -> Int
    func getSport(at index: Int) -> Sport
    func didSelectSport(at index: Int)
}

class SportsPresenter: SportsPresenterProtocol {
    
    private weak var view: SportsViewProtocol?
    
    private var sportsList: [Sport] = []
    
    init(view: SportsViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        sportsList = [
            Sport(sportName: "Football", sportThumb: "football"),
            Sport(sportName: "Basketball", sportThumb: "basketball"),
            Sport(sportName: "Tennis", sportThumb: "tennis"),
            Sport(sportName: "Cricket", sportThumb: "cricket")
        ]
        
        view?.displaySports()
    }
    
    func getSportsCount() -> Int {
        return sportsList.count
    }
    
    func getSport(at index: Int) -> Sport {
        return sportsList[index]
    }
    
    func didSelectSport(at index: Int) {
        guard index < sportsList.count else { return }
        guard let name = sportsList[index].sportName else { return }

        view?.navigateToLeagues(for: name.lowercased())
    }
}
