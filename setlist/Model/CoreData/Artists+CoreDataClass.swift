//
//  Artists+CoreDataClass.swift
//  Setlist
//
//  Created by Benoit Deguine on 14/09/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import Foundation
import CoreData

public class Artists: NSManagedObject {
    
}

class ArtistsService{
    
    enum Sort {
        case Date
        case Alphabetique
        case CountView
    }
    var context: NSManagedObjectContext
    let entity = "Artists"
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    func create(artist:Artist)->Bool {
        let artistCoreData = Artists(entity: NSEntityDescription.entity(forEntityName: entity, in: context)!, insertInto: context)
        artistCoreData.name = artist.name
        artistCoreData.mbid = artist.mbid
        artistCoreData.dateAdd = Date() as NSDate?
        
        context.insert(artistCoreData)
        
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print(error)
            return false
        }
    }
    
    func getById(id: NSManagedObjectID) -> Artists? {
        return context.object(with: id) as? Artists
    }
    
    func update(updatedArtist: Artists){
        if let artists = getById(id: updatedArtist.objectID){
            artists.name = updatedArtist.name
        }
    }
    
    func delete(id: NSManagedObjectID){
        if let artistToDelete = getById(id: id){
            context.delete(artistToDelete)
        }
    }
    
    func saveChanges(){
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getAll(order:Sort = .Alphabetique, ascending:Bool = false) -> [Artists]{
        
        let sortDescriptor:NSSortDescriptor
        
        switch order {
        case .Date:
            sortDescriptor = NSSortDescriptor(key: "dateAdd", ascending: ascending)
            break
        case .CountView:
            sortDescriptor = NSSortDescriptor(key: "countView", ascending: ascending)
            break
        case .Alphabetique:
            sortDescriptor = NSSortDescriptor(key: "name", ascending: ascending)
            break
        default:
            sortDescriptor = NSSortDescriptor(key: "name", ascending: ascending)
        }
        
        let sortDescriptors = [sortDescriptor]
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.sortDescriptors = sortDescriptors
        
        
        do {
            let results = try context.fetch(fetchRequest)
            return results as! [Artists]
        } catch let err as NSError {
            print(err.debugDescription)
            
            return []
        }
    }

}
