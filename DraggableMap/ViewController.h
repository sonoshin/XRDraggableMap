//
//  ViewController.h
//  DraggableMap
//
//  Created by Xinrui Gao on 21/11/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapObject.h"

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property CGPoint movedPoint;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
