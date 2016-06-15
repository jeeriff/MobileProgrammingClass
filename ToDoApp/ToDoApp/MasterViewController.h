//
//  MasterViewController.h
//  SplitViewTakeTwo
//
//  Created by Matthew Harrison on 6/14/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DetailViewController.h"
#import "ToDoInstance.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSMutableArray *ToDoItems;
}

@property (strong, nonatomic) DetailViewController *detailViewController;


@end



