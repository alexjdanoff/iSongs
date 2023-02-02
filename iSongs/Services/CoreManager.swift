//
//  CoreManager.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 31.01.2023.
//

import Foundation
import CoreData

final class CoreManager {
    
    static let shared = CoreManager()
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "iSongs")
        
        container.loadPersistentStores(completionHandler: { (storeDescrip, err) in
            if let error = err {
                fatalError(error.localizedDescription)
            }
        })
        
        return container
    }()
    
    func save(_ track: Track) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CoreTrack", in: context)!
        let core = CoreTrack(entity: entity, insertInto: context)
        
        core.setValue(track.id, forKey: "id")
        core.setValue(track.artist, forKey: "artist")
        core.setValue(track.title, forKey: "title")
        core.setValue(track.image , forKey: "image")
        core.setValue(track.durationInMilliseconds , forKey: "duration")
        
        saveContext()
    }
    
    func delete(_ track: Track) {
        
        let fetchRequest = NSFetchRequest<CoreTrack>(entityName: "CoreTrack")
        let predicate = NSPredicate(format: "id==%@", String(track.id!))
        
        fetchRequest.predicate = predicate
        
        var trackResult = [CoreTrack]()
        
        do {
            trackResult = try context.fetch(fetchRequest)
            
            guard let core = trackResult.first else { return }
            context.delete(core)
            
        } catch {
            print("Couldn't Fetch Fact: \(error.localizedDescription)")
        }
        
        saveContext()
    }
    
    func load() -> [Track] {
        
        let fetchRequest = NSFetchRequest<CoreTrack>(entityName: "CoreTrack")
        
        var tracks = [Track]()
        
        do {
            
            let coreTracks = try context.fetch(fetchRequest)
            for core in coreTracks {
                tracks.append(Track(from: core))
            }
            
        } catch {
            print("Couldn't Fetch Fact: \(error.localizedDescription)")
        }
        
        return tracks.reversed()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
