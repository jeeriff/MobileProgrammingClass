//
//  DetailViewController.m
//  Inventree
//
//  Created by Matthew Harrison on 7/6/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize listTypesPicker;
@synthesize listTypes;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    NSArray *typeArray = [[NSArray alloc] initWithObjects:@"All items", @"Shopping list", nil];
    self.listTypes = typeArray;
    self.listTypesPicker.delegate = self;
    self.listTypesPicker.dataSource = self;
    [_branchCategory setString:[self.detailItem description]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Data Source Method
//The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // We are working with a picker view of a single column
    return 1;
}

//The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //return the number of array elements.
    if(pickerView == self.listTypesPicker)
        return [listTypes count];
    else
        return [listTypes count]; //This is purely a placeholder until the other picker view is implemented
}

//Delegate Method
//the delegate method gives us a way to retrieve the selected item from the picker view.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [listTypes objectAtIndex:row];
}

@end
