//
//  DetailViewController.h
//  SplitViewTakeTwo
//
//  Created by Matthew Harrison on 6/14/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoInstance.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *itemNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *itemDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *itemLocaleLabel;
@property (weak, nonatomic) IBOutlet UITextView *itemDescrLabel;

@end

