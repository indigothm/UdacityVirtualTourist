//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Ilia Tikhomirov on 30/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        
        //Long Press guesture recognizer
        let uilgr = UILongPressGestureRecognizer(target: self, action: "addAnnotation:")
        uilgr.minimumPressDuration = 0.5
        uilgr.delegate = self
        mapView.addGestureRecognizer(uilgr)
        
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
            
            print(newCoordinates)
            print("LongPress")
            
         }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

