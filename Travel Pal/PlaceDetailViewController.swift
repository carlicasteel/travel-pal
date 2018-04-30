//
//  PlaceDetailViewController.swift
//  Travel Pal
//
//  Created by Carli Casteel on 4/28/18.
//  Copyright © 2018 Carli Casteel. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textView: UITextView!
    
    var place: Place!
    var album: Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if place == nil {
            place = Place()
            
        }
        placeNameLabel.text = place.name
        addressLabel.text = place.address
        textView.text = place.notes
        
        
        let regionDistance: CLLocationDistance = 750 // in meters
        let region = MKCoordinateRegionMakeWithDistance(place.coordinate, regionDistance, regionDistance)
        mapView.setRegion(region, animated: true)
        updateMap()
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(place)
        mapView.setCenter(place.coordinate, animated: true)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        place.notes = textView.text!
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        place.notes = textView.text!
        place.saveData(album: album) { (success) in
            self.leaveViewController()
        }
    }
}
