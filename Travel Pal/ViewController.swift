//
//  ViewController.swift
//  Travel Pal
//
//  Created by Carli Casteel on 4/27/18.
//  Copyright © 2018 Carli Casteel. All rights reserved.
//

import UIKit

//var albums: Albums!

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addAlbumBarButton: UIBarButtonItem!
    @IBOutlet weak var editAlbumBarButton: UIBarButtonItem!
    
    var albums: Albums!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albums = Albums()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: (self.collectionView.frame.size.height)/3)
        
        let albumImage = UIImage(named: "earth")!
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        albums.loadData {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAlbum" {
            let destination = segue.destination as! AlbumPlacesViewController
            let selectedItem = collectionView.indexPathsForSelectedItems?.first
            destination.album = albums.albumArray[selectedItem!.row]
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        editAlbumBarButton.title = "Done"
        
    }
}

// EXTENSIONS
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.cellLabel.text = albums.albumArray[indexPath.item].albumTitle
//        cell.cellImageView.image = albums.albumArray[indexPath.item].albumImage
        cell.cellImageView.image = #imageLiteral(resourceName: "earth")
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
        
    }
    
// Delete Items
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addAlbumBarButton.isEnabled = !editing
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? CollectionViewCell {
                    cell.isEditing = editing
                }
            }
        }
    }
}

extension ViewController: CollectionViewCellDelegate {
    func  delete(cell: CollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
        // 1. delete the photo from our data source
            albums.deleteData(album: albums.albumArray[indexPath.row]) { (done) in
//                print(indexPath.row)
//                print(self.albums.albumArray)
//                self.albums.albumArray.remove(at: indexPath.row)
//
//                //2. delete the photo cell at that index path from the collection view
//                self.collectionView?.deleteItems(at: [indexPath])
                self.albums.loadData {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
