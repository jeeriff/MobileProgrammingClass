//
//  ViewController.m
//  Calculator
//
//  Created by Matthew Harrison on 5/24/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "math.h"
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
    if(operandInProgress == FALSE)                          // to obtain the number entered by the user
        [fullOperand setString:@""];
    operandInProgress = TRUE;
    
    NSString *numberEntered = sender.currentTitle;          // store value of button into string
    
    if([numberEntered isEqualToString:@"e"]) {              // 'e'
        [fullOperand setString:@"2.71828"];
        operandInProgress = FALSE;
    }
    
    else if([numberEntered isEqualToString:@"%"]) {         // '%'
        double percentDouble = [display.text doubleValue] / 100.0;
        fullOperand = [NSMutableString stringWithFormat:@"%g", percentDouble];
        operandInProgress = FALSE;
    }
    
    else if([numberEntered isEqualToString:@"Ln"]) {         // 'Ln'
        double natLogged = log([display.text doubleValue]);
        fullOperand = [NSMutableString stringWithFormat:@"%g", natLogged];
        operandInProgress = FALSE;
    }
    
    else  {
        [fullOperand appendString:numberEntered];           // build number 'token'
    }
    
    display.text = self.fullOperand;
}


- (IBAction)operationPressed:(UIButton *)sender
{
    NSLog(@"--> Inside operationPressed");
    //Obtain the operation entered by the user
    if(operandInProgress == TRUE) {
        [operationUserHasPressed setString:sender.currentTitle];
        
        if(compObj.isStackEmpty == 1)  {                    // if stack is empty
            NSLog(@"--> fullOperand is: %@", self.fullOperand);
            [compObj pushOperand:self.fullOperand];
            [compObj pushOperand:self.operationUserHasPressed];
        }

        else  {                                             // stack is not empty
            
        }
        
        [compObj pushOperand:self.fullOperand ];
        [self.fullOperand setString:@""];
    }
    else  {
        // NSLog(@"Operand not in progress");   // this works
    }
    
    self.operandInProgress = FALSE;
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
    // confirmation alert message
    UIAlertController *clearAlert = [UIAlertController alertControllerWithTitle:@"Clear Pressed" message:@"Are you sure you want to clear the display?" preferredStyle:UIAlertControllerStyleAlert];
    // if confirm
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            if(compObj.isStackEmpty != 0) {         // empty stack if not empty
                [compObj clearStack];
                [self.fullOperand setString:@""];
            }
            operandInProgress = FALSE;              // no longer building operand
            defaultClearValue = @"0";               // reset display to default '0'
            display.text = defaultClearValue;
            [clearAlert dismissViewControllerAnimated:YES completion:nil];
        }];
    // if cancel, just dismiss the alert
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            [clearAlert dismissViewControllerAnimated:YES completion:nil];
        }];
    [clearAlert addAction:yes];
    [clearAlert addAction:no];
    [self presentViewController:clearAlert animated:YES completion:nil];
}

@end
