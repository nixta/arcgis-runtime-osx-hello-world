//
//  ViewController.swift
//  1 Hello World
//
//  Created by Nicholas Furness on 2/5/15.
//  Copyright (c) 2015 Nicholas Furness. All rights reserved.
//

import Cocoa
import ArcGIS

extension AGSMapView {
    convenience init(parentView: NSView) {
        self.init()
        
        // Add the AGSMapView to the parent view
        self.translatesAutoresizingMaskIntoConstraints = false // This is important!!
        parentView.addSubview(self)
        
        // Set its constraints
        let views = ["map": self]
        
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[map]|", options: nil, metrics: nil, views: views))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[map]|", options: nil, metrics: nil, views: views))
    }
}

class ViewController: NSViewController {

    var mapView:AGSMapView!
    let cctvCalloutDelegate = AGSCalloutTemplate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapView = AGSMapView(parentView: self.view)
        
        // Add a basemap layer
        let basemapUrl = "http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"
        let basemap = AGSTiledMapServiceLayer(URL: NSURL(string: basemapUrl))
        
        self.mapView.addMapLayer(basemap, withName: "Basemap")

        let centerPoint = AGSPoint(x: -77.0455, y:38.9067, spatialReference: AGSSpatialReference.wgs84SpatialReference())
        self.mapView.zoomToScale(61315, withCenterPoint: centerPoint, animated: true)

        // Add a feature layer
        let layerURL = "http://maps2.dcgis.dc.gov/dcgis/rest/services/DCGIS_DATA/Transportation_WebMercator/MapServer/11"
        let fLayer = AGSFeatureLayer(URL: NSURL(string: layerURL), mode: AGSFeatureLayerMode.OnDemand)
        
        let symbol = AGSSimpleMarkerSymbol(color: NSColor.orangeColor().colorWithAlphaComponent(0.75))
        symbol.style = AGSSimpleMarkerSymbolStyle.Circle
        symbol.outline = nil
        fLayer.renderer = AGSSimpleRenderer(symbol: symbol)
        
        fLayer.outFields = ["NAME", "ADDRESS"]
        self.cctvCalloutDelegate.titleTemplate = "${NAME}"
        self.cctvCalloutDelegate.detailTemplate = "${ADDRESS}"
        fLayer.calloutDelegate = self.cctvCalloutDelegate
        
        self.mapView.addMapLayer(fLayer, withName: "CCTV Cameras")
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

