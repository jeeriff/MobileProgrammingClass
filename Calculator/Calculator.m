//
//  ViewController.m
//  Calculator
//
//  Justin Dowell jed13d
//  Matthew Harrison msh13d
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
@synthesize scientificOper;
@synthesize fullOperand;
@synthesize operationUserHasPressed;

Compute *comp = nil;

/* initialize Compute object as nil ^, then use class method to initialize to avoid compile issue
 * */
+ (Compute *)compObj  {
    if(comp == nil)  {
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
    if(operandInProgress == FALSE || scientificOper == TRUE)// to obtain the number entered by the user
        [self.fullOperand setString:@""];
    self.operandInProgress = TRUE;
    scientificOper = FALSE;
    
    NSString *numberEntered = sender.currentTitle;          // store value of button into string
    
    if([numberEntered isEqualToString:@"e"]) {              // 'e'
        [self.fullOperand setString:@"2.71828"];
        scientificOper = TRUE;
    }
    
    else if([numberEntered isEqualToString:@"%"]) {         // '%'
        double percentDouble = [display.text doubleValue] / 100.0;
        self.fullOperand = [NSMutableString stringWithFormat:@"%g", percentDouble];
        scientificOper = TRUE;
    }
    
    else if([numberEntered isEqualToString:@"Ln"]) {         // 'Ln'
        double natLogged = log([display.text doubleValue]);
        self.fullOperand = [NSMutableString stringWithFormat:@"%g", natLogged];
        scientificOper = TRUE;
    }
    
    else  {
        [self.fullOperand appendString:numberEntered];       // build number 'token'
        scientificOper = FALSE;
    }
    
    display.text = self.fullOperand;
}

/*  operationPressed
   -------------------
    if building an operand, then
        if operatorStack is not empty, then
            if operator on stack strictly has more precedence (not equal precedence), then
                while loop calculates everything prior to operator pressed
        regardless, everything that passes through gets pushed on the appropriate stack
        and last operand dealt with (result or otherwise) is displayed
 * */
- (IBAction)operationPressed:(UIButton *)sender
{
    // check there's an operand built before operator COMMENT
    if(self.operandInProgress == TRUE) {
        self.operationUserHasPressed = [sender.currentTitle mutableCopy];

        if([[Calculator compObj] isStackEmpty] == false)  {        // if stack is not empty
            if([Compute thisOp:[Calculator compObj].operatorStack.lastObject thatOp:self.operationUserHasPressed])  {                       // stack strictly has precedence
                while([Calculator compObj].isOpStackEmpty == 0)  { // while there are operators on the stack
                    [[Calculator compObj] pushOperand:self.fullOperand];
                    self.fullOperand = [[Calculator compObj] performOperation:[[Calculator compObj] popOperator]];
                    if([self.fullOperand isEqual:@"Divide by Zero"])
                        [self divByZero];
                }
            }
        }
        
        [[Calculator compObj] pushOperand:self.fullOperand];
        [[Calculator compObj] pushOperator:self.operationUserHasPressed];
        display.text = self.fullOperand;
        [self.fullOperand setString:@""];
    }
    
    else  {     // no operand, do nothing
    }
    
    self.operandInProgress = FALSE;
}

/* equalToSignPressed
  --------------------
    uses the loop from operatorPressed to calculate everything on the stack
    doesn't clear the full operand, nor flag for progress so the result may be used in further calculations
 * */
- (IBAction)equalToSignPressed:(UIButton *)sender
{
    if(self.operandInProgress == TRUE) {
        while([Calculator compObj].isOpStackEmpty == 0)  {      // while there are operators on the stack
            [[Calculator compObj] pushOperand:self.fullOperand];
            self.fullOperand = [[Calculator compObj] performOperation:[[Calculator compObj] popOperator]];
            if([self.fullOperand isEqual:@"Divide by Zero"])
                [self divByZero];
        }
        display.text = self.fullOperand;
    }
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

-(void)divByZero {
    // confirmation alert message
    UIAlertController *clearAlert = [UIAlertController alertControllerWithTitle:@"Divide by zero error" message:@"You can't divide by zero!" preferredStyle:UIAlertControllerStyleAlert];
    // if confirm
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
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
    [clearAlert addAction:yes];
    [self presentViewController:clearAlert animated:YES completion:nil];    
}

@end
