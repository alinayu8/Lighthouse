//
//  LocationMapViewController.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/28/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class LocationMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        mapView.fitAll()
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func setupMap() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entries")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var array: [[Double]] = []
            for data in result as! [NSManagedObject] {
                let annotation = MKPointAnnotation()
                let lat = data.value(forKey: "latitude") as! Double
                let long = data.value(forKey: "longitude") as! Double
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                if !(array.contains{ $0 == [lat, long]}) {
                    mapView.addAnnotation(annotation)
                    array.append([lat, long])
                }
            }
        } catch {
            print("Failed")
        }
    }

}

extension MKMapView {
    /// when we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
    func fitAll() {
        var zoomRect            = MKMapRectNull;
        for annotation in annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect       = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.01, 0.01);
            zoomRect            = MKMapRectUnion(zoomRect, pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(100, 100, 100, 100), animated: true)
    }
    
    /// we call this function and give it the annotations we want added to the map. we display the annotations if necessary
    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
        var zoomRect:MKMapRect  = MKMapRectNull
        
        for annotation in annotations {
            let aPoint          = MKMapPointForCoordinate(annotation.coordinate)
            let rect            = MKMapRectMake(aPoint.x, aPoint.y, 0.1, 0.1)
            
            if MKMapRectIsNull(zoomRect) {
                zoomRect = rect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect)
            }
        }
        if(show) {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
}
