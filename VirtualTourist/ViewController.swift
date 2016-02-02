//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Ilia Tikhomirov on 30/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    var sharedContext: NSManagedObjectContext {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.managedObjectContext
    }

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteView: UIView!
    
    @IBOutlet weak var mapHight: NSLayoutConstraint!
    
    var pins = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        //Long Press guesture recognizer
        let uilgr = UILongPressGestureRecognizer(target: self, action: "addAnnotation:")
        uilgr.minimumPressDuration = 0.5
        uilgr.delegate = self
        mapView.addGestureRecognizer(uilgr)
        deleteView.hidden = true

        
        //TODO: Write a method that will populate map with pins based on fetch output
        pins = fetchAllPins()
        
        print("Number of pins stored")
        print(pins.count)
        
        for pin in pins {
            print(pin.valueForKey("latitude"))
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = pin.valueForKey("latitude") as! Double
            annotation.coordinate.longitude = pin.valueForKey("longitude") as! Double
            mapView.addAnnotation(annotation)
 
        }
        
    }
    
    @IBAction func editDidTouch(sender: AnyObject) {
        
        if deleteView.hidden == true {
        UIView.animateWithDuration(2.0, animations: {
            self.deleteView.hidden = false
            self.mapHight.constant = 45
            
        })
        } else {
            UIView.animateWithDuration(2.0, animations: {
                self.deleteView.hidden = true
                self.mapHight.constant = 0
                                
            })
        }
        
    }
    
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer) {
        
         if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            //Getting location from the map
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            //Creating a generic pin
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            //Add new annotation
            mapView.addAnnotation(annotation)
            
            let entityDescription =
            NSEntityDescription.entityForName("Location",
                inManagedObjectContext: sharedContext)
            
            let pin = Location(entity: entityDescription!,
                insertIntoManagedObjectContext: sharedContext)
            
            pin.latitude = newCoordinates.latitude as Double
            pin.longitude = newCoordinates.longitude as Double
            pin.createdAt = NSDate()
            
            do {
                
                try sharedContext.save()
                
            } catch {
                
                //Error Handling
                
               print("Saving Error")
            }
            
            
         }
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        print(__FUNCTION__)
        
        var i = -1;
        for view in views {
            i++;
            if view.annotation is MKUserLocation {
                continue;
            }
            
            // Check if current annotation is inside visible map rect, else go to next one
            let point:MKMapPoint  =  MKMapPointForCoordinate(view.annotation!.coordinate);
            if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
                continue;
            }
            
            let endFrame:CGRect = view.frame;
            
            // Move annotation out of view
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - self.view.frame.size.height, view.frame.size.width, view.frame.size.height);
            
            // Animate drop
            let delay = 0.03 * Double(i)
            UIView.animateWithDuration(0.5, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations:{() in
                view.frame = endFrame
                // Animate squash
                }, completion:{(Bool) in
                    UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
                        view.transform = CGAffineTransformMakeScale(1.0, 0.6)
                        
                        }, completion: {(Bool) in
                            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
                                view.transform = CGAffineTransformIdentity
                                }, completion: nil)
                    })
                    
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView
        view: MKAnnotationView) {
            
            if deleteView.hidden == true {
                print("Pressed")
                performSegueWithIdentifier("images", sender: self)
            } else {
                mapView.removeAnnotation(view.annotation! as MKAnnotation )
                print("Deleted")
            }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "OK"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    

    func fetchAllPins() -> [Location] {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Location")
        
        // Execute the Fetch Request
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Location]
        } catch let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Location]()
        }
        
        
    }

}

