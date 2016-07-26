//
//  DetailViewController.h
//  Inventree
//
//  Mobile Programming (iOS)
//  Final Project
/*
 Team:
 Matthew Harrison       msh13d
 Garrett Pierzynski     gep13
 Hannah McLaughlin      hmm14e
 Justin Dowell          jed13d
 */

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
    int currentIndex;
}

-(IBAction)increaseCurrent:(id)sender; //Add to Leaf button
-(IBAction)reduceCurrent:(id)sender;   //Subtract from Leaf button
-(IBAction)updateThreshold:(id)sender; //Update Threshold button
@property (weak, nonatomic) IBOutlet UISegmentedControl *listSwitcher; //Switch between All and Shopping List
-(IBAction)listSwitch:(id)sender;      //Switch between ALL and Shopping List
-(IBAction)newLeaf:(id)sender;      //Add Leaf button
-(IBAction)deleteLeaf:(id)sender;   //Delete Leaf button
@property (weak, nonatomic) IBOutlet UISegmentedControl *userInterfaceSwitcher; //Turn on/off part of UI
-(IBAction)userInterfaceSwitch:(id)sender; //Turn on/off part of UI


@property (retain, nonatomic) UIPickerView *inventoryList; //Displays leaves
@property (retain, nonatomic) NSMutableArray *listItems;   //Stores leaves to populate inventoryList

@property (strong, nonatomic) id detailItem; //Used to access branch name for display and queries

@end

