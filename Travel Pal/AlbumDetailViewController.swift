//
//  AlbumDetailViewController.swift
//  Travel Pal
//
//  Created by Carli Casteel on 4/28/18.
//  Copyright © 2018 Carli Casteel. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var albumNameField: UITextField!
    
    var album = Album()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        album.albumTitle = albumNameField.text!
        album.albumImage = UIImage()
        
        album.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn’t saved.")
            }
        }
    }
}
