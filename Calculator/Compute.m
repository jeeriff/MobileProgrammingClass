//
//  Compute.m
//  Calculator
//
//  Created by Matthew Harrison on 5/24/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "Compute.h"

@implementation Compute
@synthesize programStack;
@synthesize fullOperand;

//NSMutableArray *programStack = nil;


- (void)pushOperand:(double)operand
{
    //This section is supposed to push 'full operands' onto 'programStack'//*********
    //It doesn't currently work//**********
    NSString *opString = [NSString stringWithFormat:@"%g", operand];
    [self.fullOperand appendString:opString];
    //NSMutableString *intermediate = nil;
    //[self.fullOperand appendString:[operand NSString]];
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    //Perform Addition.
   // if ([operation isEqualToString:@"+"])
    //{
      //  operand1 = [self popOperand];
        //operand2 = [self popOperand];
        //result = operand1 + operand2;
    //}
    //Insert your code here.
    
    return 0;
}

- (double)popOperand
{
    return 0;
}

- (BOOL)isStackEmpty
{
    if([programStack count] == 0)
        return true;
    else
        return false;
}

- (void)clearStack
{
    [programStack removeAllObjects];
}

@end
