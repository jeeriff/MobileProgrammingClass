//
//  ViewController.h
//  Calculator
//
//  Justin Dowell jed13d
//  Matthew Harrison msh13d
//

#import <UIKit/UIKit.h>
#import "Compute.h"

@interface Calculator : UIViewController

@property (nonatomic, strong) Compute *comp;
@property (nonatomic, strong) NSMutableString *operationUserHasPressed;
@property (strong, nonatomic) IBOutlet UILabel *display;
@property (nonatomic, weak) NSString *defaultClearValue;
@property (nonatomic, assign) BOOL operandInProgress;
@property (nonatomic, strong) NSMutableString *fullOperand;

-(IBAction)digitPressed:(UIButton *)sender;
-(IBAction)operationPressed:(UIButton *)sender;
-(IBAction)equalToSignPressed:(UIButton *)sender;
-(IBAction)clearPressed:(UIButton *)sender;
-(void)divByZero;


@end

