//
//  DetailViewController.h
//  ToDoApp
//
//  Created by Matthew Harrison on 6/10/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

