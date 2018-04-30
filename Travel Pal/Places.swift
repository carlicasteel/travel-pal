//
//  Places.swift
//  Travel Pal
//
//  Created by Carli Casteel on 4/28/18.
//  Copyright © 2018 Carli Casteel. All rights reserved.
//

import Foundation
import Firebase

class Places {
    var placesArray: [Place] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(album: Album, completed: @escaping () -> ()) {
        db.collection("albums").document(album.documentID).collection("places").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            // there are querySnapshot!.documents.count documents
            self.placesArray = []
            for document in querySnapshot!.documents {
                let place = Place(dictionary: document.data())
                place.documentID = document.documentID
                self.placesArray.append(place)
            }
            completed()
        }
    }
    
    func deleteData(album: Album, place: Place, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("albums").document(album.documentID).collection("places").document(place.documentID).delete()
            { error in
                if let error = error {
                    print("ERROR: deleting review documentID \(place.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    completed(true)
                }
        }
    }
    
}
