//
//  Compute.m
//  Calculator
//
//  Created by Matthew Harrison on 5/24/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "Compute.h"
#import "Calculator.h"

@implementation Compute

- (void)pushOperand:(double)operand
{
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

@end
