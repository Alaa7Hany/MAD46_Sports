//
//  League+CoreDataProperties.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini11 on 06/05/2026.
//
//

import Foundation
import CoreData


extension League {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<League> {
        return NSFetchRequest<League>(entityName: "League")
    }

    @NSManaged public var leagueId: Int16
    @NSManaged public var leagueLogo: String?
    @NSManaged public var leagueName: String?
    @NSManaged public var sportName: String?

}

extension League : Identifiable {

}
