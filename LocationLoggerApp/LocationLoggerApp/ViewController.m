//
//  ViewController.m
//  LocationLoggerApp
//
//  Created by Justin Dowell and Matthew Harrison.
//  Project built using demo code provided by Gokila Dorai
//  Github repository:
//  https://github.com/jeeriff/MobileProgrammingClass

#import "ViewController.h"
#import "TableViewController.h"
#import <sqlite3.h>

@interface ViewController () <CLLocationManagerDelegate>

@end

TableViewController *tableController = nil;

@implementation ViewController

@synthesize latString;
@synthesize longString;
@synthesize altString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[self mapView] setShowsUserLocation:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    [[self locationManager] setDelegate:self];
    
    // we have to setup the location maanager with permission in later iOS versions
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startUpdatingLocation];
    
    tableController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self getDbFilePath]]) //if the file does not exist
    {
        [self createTable:[self getDbFilePath]];
    }
    //Initial insert with a slight delay so the user can allow location services to work
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(insert:)
                                   userInfo:nil
                                    repeats:NO];
    //A delay for the rest of the initial 300 seconds
    [NSTimer scheduledTimerWithTimeInterval:295.0
                                     target:self
                                   selector:@selector(insert:)
                                   userInfo:nil
                                    repeats:NO];
    //The full 300 second interval that will repeat as long as the app is active
    [NSTimer scheduledTimerWithTimeInterval:300.0
                                     target:self
                                   selector:@selector(insert:)
                                   userInfo:nil
                                    repeats:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int) insert:(NSString *)filePath
{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO locations (latitude, longitude, altitude) VALUES (\"%@\", \"%@\", \"%@\")", latString, longString, altString];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] , NULL, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s", rc, errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}


-(NSString *) getDbFilePath
{
    NSString *docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:@"locations.db"];
}

-(void) showMessage:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController
                                         alertControllerWithTitle:title
                                         message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(int) createTable:(NSString *) filePath
{
    sqlite3 *db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char * query ="CREATE TABLE IF NOT EXISTS locations ( id INTEGER PRIMARY KEY AUTOINCREMENT, latitude  TEXT, longitude TEXT, altitude TEXT )";
        char * errMsg;
        rc = sqlite3_exec(db, query, NULL, NULL, &errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s", rc, errMsg);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
}

-(NSArray *) getRecords:(NSString*) filePath where:(NSString *)whereStmt
{
    NSMutableArray * locations =[[NSMutableArray alloc] init];
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from locations";
        if(whereStmt)
        {
            query = [query stringByAppendingFormat:@" WHERE %@",whereStmt];
        }
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString * Latitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString * Longitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                NSString * Altitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                
                NSDictionary *location =[NSDictionary dictionaryWithObjectsAndKeys:Latitude, @"latitude",
                                        Longitude, @"longitude", Altitude, @"altitude", nil];
                
                [locations addObject:location];
                NSLog(@"Latitude: %@, Longitude: %@, Altitude: %@", Latitude, Longitude, Altitude);
                
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return locations;
}

-(int) deleteRecords:(NSString *) filePath
{
    sqlite3 *db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM locations"];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], NULL, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete records  rc:%d, msg=%s", rc, errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}

-(IBAction) showDBRecords:(id)sender
{
    NSArray * locations = [self getRecords:[self getDbFilePath] where:nil];
    [tableController setLocations:locations];
    [self.navigationController pushViewController:tableController animated:YES];
}

-(IBAction) deleteDBRecords:(id)sender
{
    int rc = [self deleteRecords:[self getDbFilePath]];
    if(rc != SQLITE_OK)
    {
        [self showMessage:@"ERROR" withMessage:@"Failed to delete records"];
    }
    else
        [self showMessage:@"SUCCESS" withMessage:@"Location log has been reset"];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = locations.lastObject;
    latString = [NSString stringWithFormat:@"%.3f", location.coordinate.latitude];
    longString = [NSString stringWithFormat:@"%.3f", location.coordinate.longitude];
    altString = [NSString stringWithFormat:@"%.2f feet", location.altitude*3.28084];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2*1609.344, 2*1609.344);
    [[self mapView] setRegion:viewRegion animated:YES];
}
@end
