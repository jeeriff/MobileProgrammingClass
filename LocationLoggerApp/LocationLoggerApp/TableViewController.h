//
//  TableViewController.h
//  LocationLoggerApp
//
//  Created by Matthew Harrison on 6/21/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController {
    NSArray *locations;
}

-(void) setLocations:(NSArray *) locations_;

@end
