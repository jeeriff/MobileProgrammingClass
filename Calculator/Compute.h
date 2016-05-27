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

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
-(double)popOperand;
-(BOOL)isStackEmpty;
-(void)clearStack;

@end
