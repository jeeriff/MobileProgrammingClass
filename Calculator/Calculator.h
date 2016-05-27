//
//  ViewController.h
//  Calculator
//
//  Created by Matthew Harrison and on 5/24/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Compute.h"

@interface Calculator : UIViewController

@property (nonatomic, strong) Compute *comp;
@property (nonatomic, weak) NSMutableString *operationUserHasPressed;
@property (strong, nonatomic) IBOutlet UILabel *display;
@property (nonatomic, weak) NSString *defaultClearValue;
@property (nonatomic, assign) BOOL operandInProgress;
@property (nonatomic, strong) NSMutableString *fullOperand;

-(IBAction)digitPressed:(UIButton *)sender;
-(IBAction)operationPressed:(UIButton *)sender;
-(IBAction)equalToSignPressed:(UIButton *)sender;
-(IBAction)clearPressed:(UIButton *)sender;


@end

