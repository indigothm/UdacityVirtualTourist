//
//  ImageViewController.swift
//  VirtualTourist
//
//  Created by Ilia Tikhomirov on 30/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit
import MapKit

class ImageViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flowL: UICollectionViewFlowLayout!
    
    var pin: MKAnnotation!
    
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
        
        let space: CGFloat = (view.frame.size.width / 64.0)
        let dimension = (view.frame.size.width  / 3.2)
        
        flowL.minimumInteritemSpacing = space
        flowL.minimumLineSpacing = space
        flowL.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        flowL.itemSize = CGSizeMake(dimension, dimension)
        
        let lat = pin.coordinate.longitude as Double
        let long = pin.coordinate.latitude as Double
        
        FlickrAPIHelper.sharedInstance.getPhotos([long, long + 10, lat, lat+10], completionHandler: { output in
            
                print ("TEST OUTPUT TO BE SAVED IN HERE")
                print (output)
            
                //TODO: Create an array of Photo objects and populate collection view with them
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath:indexPath)
        
        cell.backgroundColor = UIColor.blueColor()
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
    cell!.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell!.backgroundColor = UIColor.blueColor()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
