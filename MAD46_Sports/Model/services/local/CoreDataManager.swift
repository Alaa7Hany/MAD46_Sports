
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
    func isFavorite(id: Int16) -> League? {
            let request: NSFetchRequest<League> = League.fetchRequest()
            request.predicate = NSPredicate(format: "leagueId == %d", id)
            
            do {
                let data = try contex.fetch(request)
                return data.first
            } catch {
                print("Failed to fetch favorite: ", error.localizedDescription)
                return nil
            }
        }
        
 
        func toggleFavorite(id: Int16, name: String, logo: Data?) -> Bool {
            if let existingLeague = isFavorite(id: id) {
               
                deleteLeague(league: existingLeague)
                return false
            } else {
                saveLeague(id: id, name: name, logo: logo)
                return true
            }
        }
    

}
