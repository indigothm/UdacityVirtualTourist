//
//  ImageViewController.swift
//  VirtualTourist
//
//  Created by Ilia Tikhomirov on 30/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import CoreData

class ImageViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var sharedContext: NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate
            as! AppDelegate).managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flowL: UICollectionViewFlowLayout!
    
    var pin: MKAnnotation!
    var photoArray: JSON!
    
    var setNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        mapView.addAnnotation(pin)
        
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pin.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)

        // Do any additional setup after loading the view.
                
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.allowsMultipleSelection = true
        
        // Step 2: invoke fetchedResultsController.performFetch(nil) here
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        // Step 9: set the fetchedResultsController.delegate = self
        fetchedResultsController.delegate = self
        
        let space: CGFloat = (view.frame.size.width / 64.0)
        let dimension = (view.frame.size.width  / 3.2)
        
        flowL.minimumInteritemSpacing = space
        flowL.minimumLineSpacing = space
        flowL.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        flowL.itemSize = CGSizeMake(dimension, dimension)
        
        let lat = pin.coordinate.longitude as Double
        let long = pin.coordinate.latitude as Double
        
        print("lat")
        print(lat)
        print("long")
        print(long)
        
        FlickrAPIHelper.sharedInstance.getPhotos([long, long + 10.0, lat, lat+10.0], completionHandler: { output in
            
                print ("TEST OUTPUT TO BE SAVED IN HERE")
                print (output)
            
                self.photoArray = output
                self.collectionView.reloadData()
            
                //TODO: Create an array of Photo objects and populate collection view with them
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var numberOfItems: Int = 21
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath:indexPath) as! ImageCollectionViewCell
        
        cell.activityIndicator.startAnimating()
        
        if let photo = photoArray {
            
            print("PHOTO")
            print(photo[indexPath.row])
        
        let farm:String = photo["photos"]["photo"][indexPath.row + setNumber]["farm"].stringValue
        let server:String = photo["photos"]["photo"][indexPath.row + setNumber]["server"].stringValue
        let photoID:String = photo["photos"]["photo"][indexPath.row + setNumber]["id"].stringValue
        let secret:String = photo["photos"]["photo"][indexPath.row + setNumber]["secret"].stringValue
        
        let imageString:String = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_n.jpg/"
            print("THE IMAGE")
            print(imageString)
            
        let params = [
            "url": imageString,
            "createdAt": NSDate(),
            ]
            
        let image = Photo(dictionary: params, context: self.sharedContext)
        // image.location = nil
           // fetchedResultsController.o
            
        ImageLoader.sharedLoader.imageForUrl(imageString, completionHandler:{(image: UIImage?, url: String) in
            if let imageD = image {
            cell.image.image = imageD
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.hidden = true
            }
        })
        
        }
        
        cell.backgroundColor = UIColor.grayColor()
        
        return cell
        
    }
    

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        
        cell.image.alpha = 0.5
        newCollectionButtonOutlet.title = "Remove Selected Pictures"
        
        cellsToDelele.append(indexPath)
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        
        cell.image.alpha = 1.0
        
        if cellsToDelele.isEmpty != true {
            for (index, value) in cellsToDelele.enumerate() {
                if value == indexPath {
                    cellsToDelele.removeAtIndex(index)
                    
                    if cellsToDelele.isEmpty {
                        newCollectionButtonOutlet.title = "New Collection"
                    }
                    
                }
            }
        }
        
        
        
    }
    
    var cellsToDelele = [NSIndexPath]()

    
    @IBAction func newCollectionDidTouch(sender: AnyObject) {
        
        if newCollectionButtonOutlet.title == "Remove Selected Pictures" {
        
            if cellsToDelele.isEmpty != true {
                
                numberOfItems = numberOfItems - cellsToDelele.count
                collectionView.deleteItemsAtIndexPaths(cellsToDelele)
                newCollectionButtonOutlet.title = "New Collection"
                cellsToDelele.removeAll()
                
            }
            
        } else {
        
        let lat = pin.coordinate.longitude as Double
        let long = pin.coordinate.latitude as Double
        numberOfItems = 21
        
        FlickrAPIHelper.sharedInstance.getPhotos([long, long + 10.0, lat, lat+10.0], completionHandler: { output in
            
            
            for cell in self.collectionView.visibleCells() as! [ImageCollectionViewCell] {
                
                cell.activityIndicator.hidden = false
                cell.activityIndicator.startAnimating()
                
                //let index = self.collectionView.indexPathForCell(cell)
                //let arrayInd = [index!]
                
                //self.collectionView.deleteItemsAtIndexPaths(arrayInd)
                //self.numberOfItems = self.numberOfItems - 1
                
                
            }
            
            self.setNumber = self.setNumber + 21
            self.photoArray = output
            self.collectionView.reloadData()

            
        })
            
        }

        
    }
    
    @IBOutlet weak var newCollectionButtonOutlet: UIBarButtonItem!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
