//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Junhong Wang on 7/15/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {
    
    var imageGalleries = [ImageGallery]()
    var recentlyDeletedImageGalleries = [ImageGallery]()
    
    var recentlyEdittedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return imageGalleries.count
        case 1:
            return recentlyDeletedImageGalleries.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageGalleryTableViewCell", for: indexPath)
        
        if let cell = cell as? ImageGalleryTableViewCell {
            
            cell.textField.delegate = self
            
            switch indexPath.section {
            case 0:
                cell.textField.text = imageGalleries[indexPath.row].name
                cell.addGestureRecognizer(createDoubleTapGestureRecognizerForImageGalleryTableViewCell())
            case 1:
                cell.textField.text = recentlyDeletedImageGalleries[indexPath.row].name
            default:
                break
            }
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "ImageGalleryCollectionViewController", sender: indexPath)
        case 1:
            showAlert(with: "You cannot edit a recently deleted image gallery without undeleting it first")
        default:
            break
        }
        
    }
    
    private func showAlert(with title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                tableView.performBatchUpdates({
                    recentlyDeletedImageGalleries.append(imageGalleries[indexPath.row])
                    imageGalleries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [IndexPath(row: recentlyDeletedImageGalleries.count - 1, section: 1)], with: .fade)
                }, completion: nil)
                
            case 1:
                recentlyDeletedImageGalleries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return createViewForHeader(with: "My Galleries")
        case 1:
            return createViewForHeader(with: "Recently Deleted")
        default:
            break
        }
        
        return nil
    }
    
    private func createViewForHeader(with text: String) -> UIView {
        let label = UILabel(frame: .zero)
        label.text = text
        label.textAlignment = .center
        label.backgroundColor = .groupTableViewBackground
        return label
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 1:
            let action = UIContextualAction(style: .destructive, title: "Undelete") { (action, view, completionHandler) in
                
                completionHandler(true)
                
                tableView.performBatchUpdates({
                    let gallery = self.recentlyDeletedImageGalleries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.imageGalleries.append(gallery)
                    tableView.insertRows(at: [IndexPath(row: self.imageGalleries.count - 1, section: 0)], with: .fade)
                    
                }, completion: nil)
                
            }
            
            return UISwipeActionsConfiguration(actions: [action])
            
            
        default:
            break
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination.contents as? ImageGalleryCollectionViewController, let indexPath = sender as? IndexPath {
            var items = [ImageGalleryItem]()
            switch indexPath.section {
            case 0:
                items = imageGalleries[indexPath.row].items
                destination.title = imageGalleries[indexPath.row].name
            default:
                break
            }
            
            destination.imageGalleryTableViewController = self
            destination.galleryIndexPath = indexPath
            destination.items = items
            
        }
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        tableView.performBatchUpdates({
            let uniqueStr = "Untitled".madeUnique(withRespectTo: imageGalleries.map { $0.name })
            imageGalleries.append(ImageGallery(name: uniqueStr, items: [ImageGalleryItem]()))
            tableView.insertRows(at: [IndexPath(row: imageGalleries.count - 1, section: 0)], with: .automatic)
        }, completion: nil)
        
    }
    
    
    
}

extension ImageGalleryTableViewController: UITextFieldDelegate {
    
    private func createDoubleTapGestureRecognizerForImageGalleryTableViewCell() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(editTextField(tap:)))
        tap.numberOfTapsRequired = 2
        return tap
    }
    
    @objc private func editTextField(tap: UITapGestureRecognizer) {
        if let cell = tap.view as? ImageGalleryTableViewCell {
            cell.textField.isEnabled = true
            cell.textField.becomeFirstResponder()
            
            recentlyEdittedIndexPath = tableView.indexPath(for: cell)
            
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isEnabled = false
        
        switch recentlyEdittedIndexPath?.section {
        case 0:
            imageGalleries[recentlyEdittedIndexPath!.row].name = textField.text ?? ""
        default:
            break
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
