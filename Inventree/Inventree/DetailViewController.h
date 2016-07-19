//
//  DetailViewController.h
//  Inventree
//
//  Created by Matthew Harrison on 7/6/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UIPickerView *inventoryList;
    BOOL perish;
    BOOL shop;
    NSMutableString *currExp;
    
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *listSwitcher;
-(IBAction)listSwitch:(id)sender;
-(IBAction)newLeaf:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *perishSwitcher;
-(IBAction)perishSwitch:(id)sender;

@property (retain, nonatomic) UIPickerView *inventoryList;
@property (retain, nonatomic) NSMutableArray *listItems;


@property (weak, nonatomic) NSMutableString *branchCategory;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *leafName;
@property (weak, nonatomic) IBOutlet UITextField *expDateDisplay;

@end

