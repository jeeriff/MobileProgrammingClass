//
//  Compute.m
//  Calculator
//
//  Justin Dowell jed13d
//  Matthew Harrison msh13d
//

#import "Compute.h"

@implementation Compute
@synthesize programStack;
@synthesize operatorStack;
@synthesize fullOperand;

NSMutableArray *programStack = nil;
NSMutableArray *operatorStack = nil;

/*  initialize the stacks for use
 * */
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
    compares precedence of the operators sent in
    op1 > op2 return true
    op1 <= op2  return false
 * */
+ (bool)thisOp:(NSString *)op1 thatOp:(NSString *)op2
{
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

/*  two stack pushes due to time and simplicity
 * */
- (void)pushOperand:(NSMutableString *)operand  {
    [programStack addObject:[operand mutableCopy]];
}

- (void)pushOperator:(NSMutableString *)operator  {
    [operatorStack addObject:[operator mutableCopy]];
}

/* performOperation
 -----------------------
    performs a single operation
        divide by zero error returns message as result for error checking
        precedence is taken care of outside of this method
 * */
- (NSMutableString *)performOperation:(NSString *)operation  {
    NSMutableString *op1 = [NSMutableString alloc];
    double op1Double;
    NSMutableString *op2 = [NSMutableString alloc];
    double op2Double;
    NSMutableString *result;
    double resultDouble;
    
    op2 = [self popOperand];
    op2Double = [op2 doubleValue];
    op1 = [self popOperand];
    op1Double = [op1 doubleValue];
    
    if([operation isEqualToString:@"+"]) {      // Addition calculation
        resultDouble = op1Double + op2Double;
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
    else if([operation isEqualToString:@"-"]) { // Subtraction calculation
        resultDouble = op1Double - op2Double;
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
    else if([operation isEqualToString:@"*"]) { // Multiplicaton calculation
        resultDouble = op1Double * op2Double;
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
    else if([operation isEqualToString:@"/"]) { // Division calculation
        if([op2 isEqualToString:@"0"]) {
            NSMutableString *divZero = [NSMutableString stringWithFormat:@"Divide by Zero"];
            return divZero;
        }
        resultDouble = op1Double / op2Double;
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
    else {                                      // Exponent calculation
        resultDouble = pow(op1Double, op2Double);
        result = [NSMutableString stringWithFormat:@"%g", resultDouble];
        return result;
    }
}

/*  two stack pops due to time and simplicity
 * */
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

/*  two isStackEmpty due to time and simplicity
 * */
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

/*  clearStack clears boths stacks
 * */
- (void)clearStack
{
    [self.programStack removeAllObjects];
    [self.operatorStack removeAllObjects];
}

@end
