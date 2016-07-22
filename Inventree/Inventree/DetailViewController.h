//
//  DetailViewController.h
//  Inventree
//
//  Created by Matthew Harrison on 7/6/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UILabel *leafNameLabel;
    IBOutlet UIButton *increaseCurrentButton;
    IBOutlet UIButton *reduceCurrentButton;
    IBOutlet UIButton *updateThresholdButton;
    IBOutlet UIButton *newLeafButton;
    IBOutlet UIButton *deleteLeafButton;
    IBOutlet UITextField *increaseCurrent;
    IBOutlet UITextField *reduceCurrent;
    IBOutlet UITextField *updateThreshold;
    IBOutlet UILabel *expDateDisplayLabel;
    IBOutlet UITextField *expDateDisplay;
    IBOutlet UILabel *currentQuantityLabel;
    IBOutlet UITextField *currentQuantity;
    IBOutlet UILabel *currentThresholdLabel;
    IBOutlet UITextField *currentThreshold;
    IBOutlet UIPickerView *inventoryList;
    BOOL perish;
    NSMutableString *currExp;
    int currentIndex;
    int currentShopIndex;
}

-(IBAction)increaseCurrent:(id)sender;
-(IBAction)reduceCurrent:(id)sender;
-(IBAction)updateThreshold:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *listSwitcher;
-(IBAction)listSwitch:(id)sender;
-(IBAction)newLeaf:(id)sender;
-(IBAction)deleteLeaf:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userInterfaceSwitcher;
-(IBAction)userInterfaceSwitch:(id)sender;


@property (retain, nonatomic) UIPickerView *inventoryList;
@property (retain, nonatomic) NSMutableArray *listItems;
@property (retain, nonatomic) NSMutableArray *shopItems;


@property (weak, nonatomic) NSMutableString *branchCategory;
@property (strong, nonatomic) id detailItem;

@end

