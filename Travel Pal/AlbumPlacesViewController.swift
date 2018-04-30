//
//  AlbumPlacesViewController.swift
//  Travel Pal
//
//  Created by Carli Casteel on 4/28/18.
//  Copyright © 2018 Carli Casteel. All rights reserved.
//

import UIKit
import GooglePlaces

class AlbumPlacesViewController: UIViewController {
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var places = Places()
    var album: Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if album == nil {
            album = Album()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        // reloadInputViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        places.loadData(album: album) {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PlaceDetailViewController
        let selectedIndex = tableView.indexPathForSelectedRow!
        destination.place = places.placesArray[selectedIndex.row]
        destination.album = self.album
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInTappedCellMode = presentedViewController is UINavigationController
        if isPresentingInTappedCellMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    @IBAction func lookupPlacePressed(_ sender: UIBarButtonItem) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    //    @IBAction func unwindFromPlaceDetail(segue: UIStoryboardSegue) {
    //        let source = segue.source as! PlaceDetailViewController
    //        if let selectedIndexPath = tableView.indexPathForSelectedRow {
    //            places.placesArray[selectedIndexPath.row] = source.place
    //            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
    //        } else {
    //            let newIndexPath = IndexPath(row: places.placesArray.count, section: 0)
    //            places.placesArray.append(source.place)
    //            tableView.insertRows(at: [newIndexPath], with: .bottom)
    //            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    //        }
    //    }
}

extension AlbumPlacesViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        let newPlace = Place(name: place.name, address: place.formattedAddress!, coordinate: place.coordinate, notes: "", documentID: "")
        dismiss(animated: true, completion: nil)
        
        newPlace.saveData(album: album) { (success) in
            if success {
                self.places.placesArray.append(newPlace)
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn’t saved.")
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension AlbumPlacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.placesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = places.placesArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            places.placesArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            places.deleteData(album: self.album, place: places.placesArray[indexPath.row]) { (done) in
                //                print(indexPath.row)
                //                print(self.albums.albumArray)
                //                self.albums.albumArray.remove(at: indexPath.row)
                //
                //                //2. delete the photo cell at that index path from the collection view
                //                self.collectionView?.deleteItems(at: [indexPath])
                self.places.loadData(album: self.album) {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
