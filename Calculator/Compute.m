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


-(id)init  {
    self = [super init];
    if(self)  {
        programStack = [[NSMutableArray alloc] init];
        operatorStack = [[NSMutableArray alloc] init];
    }
    return self;
}

/* thisOp thatOp
 --------------------
    op1 > op2 return(YES)
    op1 <= op2  return(NO)
 * */
+ (bool)thisOp:(NSString *)op1 thatOp:(NSString *)op2
{
    //integer_t opW1, opW2;
    if([self getOpWeight:op1] > [self getOpWeight:op2])  {
        return true;
    }
    else  {
        return false;
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
    [programStack addObject:[operand mutableCopy]];
}

- (void)pushOperator:(NSMutableString *)operator  {
    [operatorStack addObject:[operator mutableCopy]];
}

- (NSMutableString *)performOperation:(NSString *)operation  { //Perform actual operations
    NSMutableString *op1 = [NSMutableString alloc];            //Precendence not addressed here
    double op1Double;
    NSMutableString *op2 = [NSMutableString alloc];
    double op2Double;
    NSMutableString *result;
    double resultDouble;
    
    op2 = [self popOperand];
    op2Double = [op2 doubleValue];
    op1 = [self popOperand];
    op1Double = [op1 doubleValue];
    
    if([operation isEqualToString:@"+"]) { //Addition calculation
        resultDouble = op1Double + op2Double;
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
    else if([operation isEqualToString:@"-"]) { //Subtraction calculation
        resultDouble = op1Double - op2Double;
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
    else if([operation isEqualToString:@"*"]) { //Multiplicaton calculation
        resultDouble = op1Double * op2Double;
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
    else if([operation isEqualToString:@"/"]) { //Division calculation
        resultDouble = op1Double / op2Double;
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
    else { //Exponent calculation
        resultDouble = pow(op1Double, op2Double);
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
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
