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

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
-(double)popOperand;

@end
