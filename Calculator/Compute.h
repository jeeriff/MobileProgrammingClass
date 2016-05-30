//
//  Compute.h
//  Calculator
//
//  Justin Dowell jed13d
//  Matthew Harrison msh13d
//

#import <Foundation/Foundation.h>

@interface Compute : NSObject
 
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableArray *operatorStack;
@property (nonatomic, strong) NSMutableString *fullOperand;

-(id)init;
+(int)getOpWeight:(NSString *)op;
+(bool)thisOp:(NSString *)op1 thatOp:(NSString *)op2;
-(void)pushOperand:(NSMutableString *)operand;
-(void)pushOperator:(NSMutableString *)operator;
-(NSMutableString *)performOperation:(NSString *)operation;
-(NSMutableString *)popOperand;
-(NSMutableString *)popOperator;
-(BOOL)isStackEmpty;
-(BOOL)isOpStackEmpty;
-(void)clearStack;

@end
