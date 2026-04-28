
import Foundation
import CoreData


extension League {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<League> {
        return NSFetchRequest<League>(entityName: "League")
    }

    @NSManaged public var leagueId: Int16
    @NSManaged public var leagueName: String?
    @NSManaged public var leagueLogo: Data?

}

extension League : Identifiable {

}
