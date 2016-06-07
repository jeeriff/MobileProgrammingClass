//
//  ViewController.h
//  PickerViewApp
//
//  By: Matthew Harrison (msh13d) and Justin Dowell (jed13d)
//  Project built using demo code provided by Gokila Dorai
//  Github repository:
//  https://github.com/jeeriff/MobileProgrammingClass

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    IBOutlet UIPickerView *singlePicker;
    IBOutlet UITextField *medication1;
    IBOutlet UITextField *medication2;
    IBOutlet UITextField *medication3;
    
    NSArray *pickerData;
}

@property (nonatomic, retain) UIPickerView *singlePicker;
@property (nonatomic, retain) NSArray *pickerData;
@property (nonatomic, retain) NSArray *medPrescription;


@end

