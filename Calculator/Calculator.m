//
//  ViewController.m
//  Calculator
//
//  Created by Matthew Harrison on 5/24/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "Calculator.h"

@interface Calculator ()

@end

@implementation Calculator
@synthesize display;
@synthesize defaultClearValue;
@synthesize operandInProgress;
@synthesize fullOperand;
@synthesize operationUserHasPressed;

Compute *compObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fullOperand = [[NSMutableString alloc] initWithString:@""];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)digitPressed:(UIButton *)sender
{
    //To obtain the number entered by the user
    if(operandInProgress == FALSE)
        [fullOperand setString:@""];
    operandInProgress = TRUE;
    NSString *numberEntered = sender.currentTitle;
    [fullOperand appendString:numberEntered];
    //[compObj pushOperand:[numberEntered doubleValue]];
    display.text = self.fullOperand;
    //This section deals with the e button (we treat it as a digit being pressed)//*********

    if([numberEntered isEqualToString:@"e"]) {
        NSString *eString = @"2.71828";
        display.text = eString;
        [compObj pushOperand:[eString doubleValue]];
    }
}


- (IBAction)operationPressed:(UIButton *)sender
{
    //Obtain the operation entered by the user
    if(operandInProgress == TRUE) {
    self.operationUserHasPressed = sender.currentTitle;
        
    //This section deals with the % operator//*********
        if([self.operationUserHasPressed isEqualToString:@"%"]) {
            double percentDouble = [display.text doubleValue] / 100.0;
            NSString *percentString = [NSString stringWithFormat:@"%g", percentDouble];
            display.text = percentString;
            [compObj pushOperand:[percentString doubleValue]];
        }
        
        [compObj pushOperand:[self.fullOperand doubleValue]];
        [self.fullOperand setString:@""];
    }
    if(![self.operationUserHasPressed isEqualToString:@"%"])
        operandInProgress = FALSE;
}

- (IBAction)equalToSignPressed:(UIButton *)sender
{
    //To obtain the result of the computation
    //double result = 0;
    //[self.comp pushOperand:[ ??? ]];
    //result = [self.comp performOperation:self.operationUserHasPressed];
    //Insert your code here.
}

- (IBAction)clearPressed:(UIButton *) sender
{
    UIAlertController *clearAlert = [UIAlertController alertControllerWithTitle:@"Clear Pressed" message:@"Are you sure you want to clear the display?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            if(compObj.isStackEmpty != 0) {
                [compObj clearStack];
                [self.fullOperand setString:@""];
            }
            operandInProgress = FALSE;
            defaultClearValue = @"0";
            display.text = defaultClearValue;
            [clearAlert dismissViewControllerAnimated:YES completion:nil];
        }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            [clearAlert dismissViewControllerAnimated:YES completion:nil];
        }];
    [clearAlert addAction:yes];
    [clearAlert addAction:no];
    [self presentViewController:clearAlert animated:YES completion:nil];
}

@end
