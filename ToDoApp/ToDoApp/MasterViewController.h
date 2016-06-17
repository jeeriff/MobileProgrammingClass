//
//  MasterViewController.h
//
//
//  Created by Matthew Harrison and Justin Dowell.
//
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



