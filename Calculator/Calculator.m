//
//  ViewController.m
//  Calculator
//
//  Created by Matthew Harrison on 5/24/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "Calculator.h"
#import "Compute.m"

@interface Calculator ()

@end

@implementation Calculator

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)digitPressed:(UIButton *)sender
{
    //To obtain the number entered by the user
    NSString *numberEntered = sender.currentTitle;
    
    //Insert your code here.
}


- (IBAction)operationPressed:(UIButton *)sender
{
    //Obtain the operation entered by the user
    self.operationUserHasPressed = sender.currentTitle;
    //Insert your code here.
}

- (IBAction)equalToSignPressed:(UIButton *)sender
{
    //To obtain the result of the computation
    double result = 0;
    //[self.comp pushOperand:[ ??? ]];
    //result = [self.comp performOperation:self.operationUserHasPressed];
    
    //Insert your code here.
}

@end
