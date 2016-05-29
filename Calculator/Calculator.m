//
//  ViewController.m
//  Calculator
//
//  Created by Matthew Harrison on 5/24/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "math.h"
#import "Calculator.h"
#import "Compute.h"

@interface Calculator ()

@end

@implementation Calculator
@synthesize display;
@synthesize defaultClearValue;
@synthesize operandInProgress;
@synthesize fullOperand;
@synthesize operationUserHasPressed;

Compute *comp = nil;

/* initialize Compute object as nil ^, then use class method to initialize to avoid compile issue
 * */
+ (Compute *)compObj  {
    if( comp == nil)  {
        comp = [[Compute alloc] init];
    }
    return comp;
}

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
    // check there's an operand built before operator
    if(operandInProgress == TRUE) {
        [operationUserHasPressed setString:sender.currentTitle];
        
        if([Calculator compObj].isStackEmpty == 0)  {                    // if stack is not empty
            /*  check precedence with operator on top of stack,
                    if stack is higher, compute stack, push the solution, the new operand, then the operator
             */
            if([Compute thisOp:[Calculator compObj].programStack.lastObject thatOp:self.operationUserHasPressed])  {
                NSLog(@"Inside operationPressed ... stack operation has precedence, TODO compute");
            }
            else  {
                NSLog(@"Inside operationPressed ... operation pressed has precedence");
            }
        }
        [[Calculator compObj] pushOperand:self.fullOperand];
        [[Calculator compObj] pushOperand:self.operationUserHasPressed];
        
        [[Calculator compObj] pushOperand:self.fullOperand ];
        [self.fullOperand setString:@""];
    }
    else  {     // no operand, do nothing
        
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
            if([Calculator compObj].isStackEmpty != 0) {         // empty stack if not empty
                [[Calculator compObj] clearStack];
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
