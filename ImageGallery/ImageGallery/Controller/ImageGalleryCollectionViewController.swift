//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Junhong Wang on 7/14/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var galleryIndexPath: IndexPath?
    var items = [ImageGalleryItem]()
    
    var cellWidth: CGFloat = 300
    
    lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(changeCellWidth(sender:)))
        return pinch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if galleryIndexPath == nil { return }
        
        
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        
        collectionView?.addGestureRecognizer(pinchGestureRecognizer)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGalleryCollectionViewCell", for: indexPath)
        if let cell = cell as? ImageGalleryCollectionViewCell, let url = URL(string: items[indexPath.item].url) {
            cell.fetchImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = cellWidth*CGFloat(items[indexPath.item].aspectRatio)
        return CGSize(width: cellWidth, height: height)
    }
    
    @objc private func changeCellWidth(sender: UIPinchGestureRecognizer) {
        cellWidth *= sender.scale
        sender.scale = 1.0
        (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.invalidateLayout()
    }
    
    var imageGalleryTableViewController: ImageGalleryTableViewController?
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let imageGalleryTableViewController = imageGalleryTableViewController {
            switch galleryIndexPath?.section {
            case 0:
                imageGalleryTableViewController.imageGalleries[galleryIndexPath!.row].items = items
            case 1:
                imageGalleryTableViewController.recentlyDeletedImageGalleries[galleryIndexPath!.row].items = items
            default:
                break
            }
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "ImageGalleryDetailViewController", sender: cell)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImageGalleryDetailViewController, let cell = sender as? ImageGalleryCollectionViewCell {
            destination.image = cell.imageView.image
        }
    }
    
}

extension ImageGalleryCollectionViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    // MARK: UICollectionViewDragDelegate methods
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let url = URL(string: items[indexPath.item].url) {
            let nsurl = url as NSURL
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: nsurl))
            dragItem.localObject = nsurl
            return [dragItem]
        }
        else {
            return []
        }
    
    }
    
    // UICollectionViewDropDelegate methods
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return isSelf ? session.canLoadObjects(ofClass: NSURL.self) : session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        for item in coordinator.items {
            
            if let sourceIndexPath = item.sourceIndexPath {
                if let nsurl = item.dragItem.localObject as? NSURL {
                    let aspectRatio = Double(item.previewSize.height / item.previewSize.width)
                    collectionView.performBatchUpdates({
                        items.remove(at: sourceIndexPath.item)
                        items.insert(ImageGalleryItem(url: (nsurl as URL).absoluteString, aspectRatio: aspectRatio), at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }, completion: nil)
                    
                    // animate drop happening
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    
                }
                
                
            }
            else {
                
                let dropPlaceholder = UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "ImageGalleryDropPlaceholderCollectionViewCell")
                
                let placeHolderContext = coordinator.drop(item.dragItem, to: dropPlaceholder)
        
                
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let nsurl = provider as? NSURL {
                            placeHolderContext.commitInsertion(dataSourceUpdates: { (insertionIndexPath) in
                                let aspectRatio = Double(item.previewSize.height / item.previewSize.width)
                                self.items.insert(ImageGalleryItem(url: (nsurl as URL).imageURL.absoluteString, aspectRatio: aspectRatio), at: insertionIndexPath.item)
                                
                            })
                        }
                        else {
                            placeHolderContext.deletePlaceholder()
                        }
                        
                    }
                }
                
                
            }
            
            
            
        }
        
        
    }
    
    
    
}









