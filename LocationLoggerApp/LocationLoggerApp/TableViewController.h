//
//  TableViewController.h
//  LocationLoggerApp
//
//  Created by Justin Dowell and Matthew Harrison.
//  Project built using demo code provided by Gokila Dorai
//  Github repository:
//  https://github.com/jeeriff/MobileProgrammingClass

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController {
    NSArray *locations;
}

-(void) setLocations:(NSArray *) locations_;

@end
