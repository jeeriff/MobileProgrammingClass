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

NSMutableArray *programStack = nil;

/* thisOp thatOp
 --------------------
    op1 >= op2 return(YES)
    op1 < op2  return(NO)
 * */
+ (bool)thisOp:(NSString *)op1 thatOp:(NSString *)op2
{
    //integer_t opW1, opW2;
    if([self getOpWeight:op1] < [self getOpWeight:op2])  {
        return false;
    }
    else  {
        return true;
    }
}

/*  getOpWeight
 --------------------
    used in operator precedence processing
    since only programmers will be using it, not error checking
    if '+' or '-' then 1 (low)
    else '*' or '/' then 2 (high)
 * */
+ (integer_t)getOpWeight:(NSString *)op
{
    if([op isEqualToString:@"+"] || [op isEqualToString:@"-"])  {
        return 1;
    }
    else if([op isEqualToString:@"*"] || [op isEqualToString:@"/"])  {
        return 2;
    }
    else
        return 3;
}

- (void)pushOperand:(NSMutableString *)operand  {
    [programStack addObject:operand];
    for(NSMutableString *item in programStack)  {
        NSLog(@"Array item: %@", item);
    }
}

- (double)performOperation:(NSString *)operation  {
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
