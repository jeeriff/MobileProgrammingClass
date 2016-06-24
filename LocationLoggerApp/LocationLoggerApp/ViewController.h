//
//  ViewController.h
//  LocationLoggerApp
//
//  Created by Justin Dowell and Matthew Harrison.
//  Project built using demo code provided by Gokila Dorai
//  Github repository:
//  https://github.com/jeeriff/MobileProgrammingClass

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *latString;
@property (strong, nonatomic) NSString *longString;
@property (strong, nonatomic) NSString *altString;

- (IBAction)showDBRecords:(id)sender;
- (IBAction)deleteDBRecords:(id)sender;

@end

