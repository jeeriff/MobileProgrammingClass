//
//  ViewController.h
//  LocationLoggerApp
//
//  Created by Matthew Harrison on 6/21/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)showDBRecords:(id)sender;
- (IBAction)deleteDBRecords:(id)sender;

@end

