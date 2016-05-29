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
@synthesize operatorStack;

NSMutableArray *programStack = nil;

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
    [self.programStack addObject:operand];
    for(NSMutableString *item in self.programStack)  {
        NSLog(@"Array item: %@", item);
    }
}

- (void)pushOperator:(NSMutableString *)operator {
    [self.operatorStack addObject:operator];
    for(NSMutableString *item in self.operatorStack)
        NSLog(@"Array item: %@", item);
}

- (NSMutableString *)performOperation:(NSString *)operation  {
    NSMutableString *op1 = [NSMutableString alloc];
    double op1Double;
    NSMutableString *op2 = [NSMutableString alloc];
    double op2Double;
    NSMutableString *result;
    double resultDouble;
    
    op1 = [self popOperand];
    op1Double = [op1 doubleValue];
    op2 = [self popOperand];
    op2Double = [op2 doubleValue];
    
    if([operation isEqualToString:@"+"]) { //Addition calculation
        resultDouble = op1Double + op2Double;
        result = [NSMutableString stringWithFormat:@"%@", result];
        return result;
    }
    else if([operation isEqualToString:@"-"]) { //Subtraction calculation
        resultDouble = op1Double - op2Double;
        result = [NSMutableString stringWithFormat:@"%@", result];
        return result;
    }
    else if([operation isEqualToString:@"*"]) { //Multiplicaton calculation
        resultDouble = op1Double * op2Double;
        result = [NSMutableString stringWithFormat:@"%@", result];
        return result;
    }
    else if([operation isEqualToString:@"/"]) { //Division calculation
        resultDouble = op1Double / op2Double;
        result = [NSMutableString stringWithFormat:@"%@", result];
        return result;
    }
    else { //Exponent calculation
        resultDouble = pow(op1Double, op2Double);
        result = [NSMutableString stringWithFormat:@"%@", result];
        return result;
    }
}

- (NSMutableString *)popOperand
{
    NSMutableString * last = [self.programStack lastObject];
    [self.programStack removeLastObject];
    return last;
}

-(NSMutableString *)popOperator {
    
    NSMutableString * last = [self.operatorStack lastObject];
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

-(BOOL)isOpStackEmpty {
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
