//
//  MasterViewController.h
//  Inventree
//
//  Mobile Programming (iOS)
//  Final Project
/*
 Team:
 Matthew Harrison       msh13d
 Garrett Pierzynski     gep13
 Hannah McLaughlin      hmm14e
 Justin Dowell          jed13d
 */

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DetailViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

