

import Foundation
protocol NetworkService{
    func getLeagues(sportName : String,completion: @escaping ([LeagueModel]) -> Void)
}
