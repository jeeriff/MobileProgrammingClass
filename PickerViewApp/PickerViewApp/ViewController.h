//
//  ViewController.h
//  PickerViewApp
//
//  Created by Matthew Harrison on 6/2/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

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

