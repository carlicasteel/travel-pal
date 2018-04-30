//
//  Place.swift
//  Travel Pal
//
//  Created by Carli Casteel on 4/28/18.
//  Copyright © 2018 Carli Casteel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import Firebase

class Place: NSObject, MKAnnotation  {
    var name: String
    var address: String
    var notes: String
    var coordinate: CLLocationCoordinate2D
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "notes": notes, "latitude": latitude, "longitude": longitude]
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return address
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, notes: String, documentID: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.notes = notes
        self.documentID = documentID
    }
    
    override convenience init() {
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), notes: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let notes = dictionary["notes"] as! String? ?? ""
        
        self.init(name: name, address: address, coordinate: coordinate, notes: notes, documentID: "")
    }
    
    func saveData(album: Album, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave = self.dictionary
        // if we HAVE saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("albums").document(album.documentID).collection("places").document(self.documentID)
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
            ref = db.collection("albums").document(album.documentID).collection("places").addDocument(data: dataToSave) { error in
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
