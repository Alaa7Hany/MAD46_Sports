
import Foundation
import CoreData
import UIKit
class CoreDataManager
{
    static let shared = CoreDataManager()
    private init(){}
    
    var contex : NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }
    
    
    func saveLeague(id:Int16 ,name : String , logo :Data?)
    {
        let league = League(context: contex)
        league.leagueId = id
        league.leagueName = name
        league.leagueLogo = logo
        do {
           try contex.save()
            print("Saved successfully")
        }catch {
            print("failed to save ", error.localizedDescription)
        }
        
    }
    func fetchLeague() -> [League]
    {
        let request : NSFetchRequest<League> = League.fetchRequest()
        do {
       let data =  try contex.fetch(request)
            return data
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteLeague (league : League)
    {
        contex.delete(league)
        do {
            try contex.save()
            print( "Deleted successfully")
        }catch{
            print(error.localizedDescription)
        }
      
    }

}
