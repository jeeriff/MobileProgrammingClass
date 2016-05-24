//
//  ViewController.h
//  Calculator
//
//  Created by Matthew Harrison on 5/24/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Calculator : UIViewController

@property (nonatomic, strong) Compute *comp;
@property (nonatomic, weak) NSString *operationUserHasPressed;
@property (strong, nonatomic) IBOutlet UITextView *display;

@end

