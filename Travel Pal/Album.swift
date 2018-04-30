//
//  Album.swift
//  Travel Pal
//
//  Created by Carli Casteel on 4/28/18.
//  Copyright © 2018 Carli Casteel. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Album {
    var albumTitle: String
    var albumImage: UIImage!
    var places: [Place] = []
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["albumTitle": albumTitle]
    }
    
    init(albumTitle: String, albumImage: UIImage, documentID: String) {
        self.albumTitle = albumTitle
        self.albumImage = albumImage
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(albumTitle: "", albumImage: UIImage(), documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let albumTitle = dictionary["albumTitle"] as! String? ?? ""
        self.init(albumTitle: albumTitle, albumImage: UIImage(), documentID: "")
    }
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave = self.dictionary
        // if we HAVE saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("albums").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    self.documentID = ref.documentID
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // Let firestore create the new documentID
            ref = db.collection("albums").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
        }
    }
}
