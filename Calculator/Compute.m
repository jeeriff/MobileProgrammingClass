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
@synthesize operatorStack;
@synthesize fullOperand;

NSMutableArray *programStack = nil;
NSMutableArray *operatorStack = nil;

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
    [self.programStack addObject:operand];
    for(NSMutableString *item in programStack)  {
        NSLog(@"Array item: %@", item);
    }
}

- (void)pushOperator:(NSMutableString *)operator  {
    [self.operatorStack addObject:operator];
    for(NSMutableString *item in programStack)  {
        NSLog(@"Array item: %@", item);
    }
}

- (NSMutableString *)performOperation:(NSString *)operation  {
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

- (NSMutableString *)popOperand
{
    NSMutableString *last = [self.programStack lastObject];
    [self.programStack removeLastObject];
    return last;
}

- (NSMutableString *)popOperator
{
    NSMutableString *last = [self.operatorStack lastObject];
    [self.operatorStack removeLastObject];
    return last;
}

- (BOOL)isStackEmpty
{
    if([self.programStack count] == 0)
        return true;
    else
        return false;
}

- (BOOL)isOpStackEmpty
{
    if([self.operatorStack count] == 0)
        return true;
    else
        return false;
}

- (void)clearStack
{
    [self.programStack removeAllObjects];
    [self.operatorStack removeAllObjects];
}

@end
