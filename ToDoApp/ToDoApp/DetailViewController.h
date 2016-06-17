//
//  DetailViewController.h
//  ToDoApp
//
//  Created by Justin Dowell and Matthew Harrison.
//  Github repository:
//  https://github.com/jeeriff/MobileProgrammingClass

#import <UIKit/UIKit.h>
#import "ToDoInstance.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *itemDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *itemLocaleLabel;
@property (weak, nonatomic) IBOutlet UITextView *itemDescrLabel;

@end
