//
//  Albums.swift
//  Travel Pal
//
//  Created by Carli Casteel on 4/28/18.
//  Copyright © 2018 Carli Casteel. All rights reserved.
//

import Foundation
import Firebase

class Albums {
    var albumArray: [Album] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("albums").addSnapshotListener { (querySnapshot, error) in
            self.albumArray = []
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            // there are querySnapshot!.documents.count documents
            for document in querySnapshot!.documents {
                let album = Album(dictionary: document.data())
                album.documentID = document.documentID
                self.albumArray.append(album)
            }
            completed()
        }
    }
    
    func deleteData(album: Album, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("albums").document(album.documentID).delete()
            { error in
                if let error = error {
                    print("ERROR: deleting review documentID \(album.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    completed(true)
                }
        }
    }
    
}
