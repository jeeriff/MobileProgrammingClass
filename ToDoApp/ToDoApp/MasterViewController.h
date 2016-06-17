//
//  MasterViewController.h
//  ToDoApp
//
//  Created by Justin Dowell and Matthew Harrison.
//  Github repository:
//  https://github.com/jeeriff/MobileProgrammingClass

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



