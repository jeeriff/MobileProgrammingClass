//
//  Compute.h
//  Calculator
//
//  Created by Matthew Harrison on 5/24/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Compute : NSObject
 
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableString *fullOperand;

+ (int)getOpWeight:(NSString *)op;
+ (bool)thisOp:(NSString *)op1 thatOp:(NSString *)op2;
-(void)pushOperand:(NSMutableString *)operand;
-(double)performOperation:(NSString *)operation;
-(double)popOperand;
-(BOOL)isStackEmpty;
-(void)clearStack;

@end
