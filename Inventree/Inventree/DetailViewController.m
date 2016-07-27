//
//  DetailViewController.m
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

#import "DetailViewController.h"
#import <sqlite3.h>


@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize inventoryList;
@synthesize listItems;

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.detailItem description]; //Set title to name of branch
    //Format font and color of buttons and labels
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leaves.png"]]; //Set background to be image of leaves
    leafNameLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:24.0f];
    [increaseCurrentButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    increaseCurrentButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    [reduceCurrentButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    reduceCurrentButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    [updateThresholdButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    updateThresholdButton.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    
    currentQuantity.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    currentQuantityLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    currentThreshold.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    currentThresholdLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    expDateDisplay.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    expDateDisplayLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0f];
    
    currentIndex = 0; //Used to manually index into listItems, 0 by default
    [self configureView];
    //Initialized listItems array if it hasn't been
    if(!self.listItems) {
        listItems = [[NSMutableArray alloc] init];
    }
    [self.listItems setArray:[self getLeaves:[self getDbFilePath] : NO]]; //Load listItems with all leaves on current branch via a database query
    self.inventoryList.dataSource = self; //Set picker view data source
    self.inventoryList.delegate = self;   //Set picker view delegate
    self.userInterfaceSwitcher.selectedSegmentIndex = 1; //Default the hideable UI elements (via UISwitcher) to be shown
    if([listItems count] > 0) { //If there is at least one leaf in the database associated with the current branch, populate the screen with the first leaf's data
        NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[0]]];
        leafNameLabel.text = listItems[0];
        expDateDisplay.text = currentRow[0];
        currentQuantity.text = currentRow[1];
        currentThreshold.text = currentRow[2];
    }
    else { //If not leaves are on the current branch, default the elements on the screen to prompt the creation of a leaf
        leafNameLabel.text = @"Create a leaf now!";
        expDateDisplay.text = @"";
        currentQuantity.text = @"";
        currentThreshold.text = @"";
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Switch between showing all leaves on the current branch (set to 0) and only those on the shopping list (set to 1)
-(IBAction)listSwitch:(id)sender {
    switch (self.listSwitcher.selectedSegmentIndex)
    {
        case 0:
            reduceCurrent.hidden = NO;
            reduceCurrentButton.hidden = NO;
            updateThreshold.hidden = NO;
            updateThresholdButton.hidden = NO;
            [self.inventoryList selectRow:0 inComponent:0 animated:NO]; //Default the picker view to show the first element
            [inventoryList selectedRowInComponent:0];
            [self.listItems setArray:[self getLeaves:[self getDbFilePath] : NO]]; //The final parameter is NO to get ALL leaves on the current branch
            self.inventoryList.dataSource = self;
            self.inventoryList.delegate = self;
            [inventoryList reloadAllComponents];
            if([listItems count] > 0) { //If there's at least one leaf on the current branch, populate the screen with its data
                currentIndex = 0;
                NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] : listItems[0]]];
                leafNameLabel.text = listItems[0];
                expDateDisplay.text = currentRow[0];
                currentQuantity.text = currentRow[1];
                currentThreshold.text = currentRow[2];
            }
            else if([listItems count] == 0) {
                leafNameLabel.text = @"Create a leaf now!";
                expDateDisplay.text = @"";
                currentQuantity.text = @"";
                currentThreshold.text = @"";
            }

            break;
        case 1:
            reduceCurrent.hidden = YES;
            reduceCurrentButton.hidden = YES;
            updateThreshold.hidden = YES;
            updateThresholdButton.hidden = YES;
            [self.inventoryList selectRow:0 inComponent:0 animated:NO]; //Default the picker view to show the first element
            [inventoryList selectedRowInComponent:0];
            [self.listItems setArray:[self getLeaves:[self getDbFilePath] : YES]];
            self.inventoryList.dataSource = self;
            self.inventoryList.delegate = self;
            [inventoryList reloadAllComponents];
            if([listItems count] > 0) { //If there's at least one leaf on the current branch, populate the screen with its data
                currentIndex = 0;
                [listItems setArray:[self getLeaves:[self getDbFilePath] :YES]]; //The final parameter is YES to get the leaves on the shopping list
                NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] : listItems[0]]];
                leafNameLabel.text = listItems[0];
                expDateDisplay.text = currentRow[0];
                currentQuantity.text = currentRow[1];
                currentThreshold.text = currentRow[2];
            }
            else if([listItems count] == 0) {
                leafNameLabel.text = @"Shopping list is empty";
                expDateDisplay.text = @"";
                currentQuantity.text = @"";
                currentThreshold.text = @"";
            }
            break;
        default:
            break;
    }
}

//Allows the user to show/hide part of the UI
-(IBAction)userInterfaceSwitch:(id)sender
{
    switch (self.userInterfaceSwitcher.selectedSegmentIndex)
    {
        case 0:
            [currentThreshold setHidden:TRUE];
            [currentThresholdLabel setHidden:TRUE];
            [currentQuantity setHidden:TRUE];
            [currentQuantityLabel setHidden:TRUE];
            [expDateDisplay setHidden:TRUE];
            [expDateDisplayLabel setHidden:TRUE];
            break;
        case 1:
            [currentThreshold setHidden:FALSE];
            [currentThresholdLabel setHidden:FALSE];
            [currentQuantity setHidden:FALSE];
            [currentQuantityLabel setHidden:FALSE];
            [expDateDisplay setHidden:FALSE];
            [expDateDisplayLabel setHidden:FALSE];
            break;
        default:
            break;
    }
}

//Add a new leaf to the current branch
-(IBAction)newLeaf:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Create a new leaf!"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Enter leaf name", @"BoxOne");
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Enter purchase threshold", @"BoxTwo");
     }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Enter expiration date (i.e. 01/01/2017)", @"BoxThree");
     }];
    
    NSMutableString *newLeafName = [[NSMutableString alloc] init];
    NSMutableString *newThreshold = [[NSMutableString alloc] init];
    NSMutableString *newExpDate = [[NSMutableString alloc] init];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       //NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Add", @"Add action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   if([self checkLeaves:[self getDbFilePath] : alertController.textFields[0].text] == NO) { //Check if the leaf already exists on the current branch
                                       //NSLog(@"Add action");
                                       [newLeafName setString:alertController.textFields[0].text];
                                       [newThreshold setString:alertController.textFields[1].text];
                                       [newExpDate setString:alertController.textFields[2].text];
                                       NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                                       f.numberStyle = NSNumberFormatterDecimalStyle;
                                       
                                       NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                                       if ([newThreshold rangeOfCharacterFromSet:notDigits].location == NSNotFound) //Check if the entered threshold is an integer
                                       {
                                           NSNumber *threshNum = [f numberFromString:newThreshold];
                                           if(threshNum > 0) { //Check if the entered threshold is positive
                                               [self insertLeaf:[self getDbFilePath] : newLeafName : threshNum : newExpDate];
                                               [listItems insertObject:newLeafName atIndex:0];
                                               [inventoryList reloadAllComponents];
                                               [inventoryList selectRow:0 inComponent:0 animated:NO];
                                               NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[0]]];
                                               leafNameLabel.text = listItems[0];
                                               expDateDisplay.text = currentRow[0];
                                               currentQuantity.text = currentRow[1];
                                               currentThreshold.text = currentRow[2];
                                               currentIndex = 0;
                                               self.listSwitcher.selectedSegmentIndex = 0;
                                               updateThreshold.text = @"";
                                               increaseCurrent.text = @"";
                                               reduceCurrent.text = @"";
                                           }
                                           else if(threshNum < 0) { //If entered threshold is negative
                                               [self insertValidation];
                                           }
                                       }
                                       else { //If entered threshold is not an integer
                                           [self insertValidation];
                                       }
                                   }
                                   else { //If entered leaf is already on the current branch
                                       [self leafNameValidaton];
                                   }
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//Delete a leaf from the current branch
-(IBAction)deleteLeaf:(id)sender
{
    if([listItems count] > 0) { //If there is a leaf to delete, the delete can proceed
        [self deleteCurrentLeaf:[self getDbFilePath]];
        if(self.listSwitcher.selectedSegmentIndex == 0) //If the delete took place when showing all items
            [self.listItems setArray:[self getLeaves:[self getDbFilePath] : NO]];
        else //If the delete took place while looking at the shopping list
            [self.listItems setArray:[self getLeaves:[self getDbFilePath] : YES]];
        [inventoryList reloadAllComponents];
        if([listItems count] > 0) { //If there are still leaves remaining, decrement currentIndex
            if(currentIndex > 0)
                --currentIndex;
            NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[currentIndex]]];
            leafNameLabel.text = listItems[currentIndex]; //Load the next leaves data to the screen
            expDateDisplay.text = currentRow[0];
            currentQuantity.text = currentRow[1];
            currentThreshold.text = currentRow[2];
        }
    }
    if([listItems count] == 0) { //If there are no leaves left after the delete, display the default text to the screen
        leafNameLabel.text = @"Create a leaf now!";
        expDateDisplay.text = @"";
        currentQuantity.text = @"";
        currentThreshold.text = @"";
    }
}

//Add to the current quantity of the currently selected leaf
-(IBAction)increaseCurrent:(id)sender
{
    if([listItems count] > 0) { //If there is a leaf to modify, the increase can proceed
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([increaseCurrent.text rangeOfCharacterFromSet:notDigits].location == NSNotFound) //Check if the entered number is an integer
        {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *changeQuantity = [f numberFromString:increaseCurrent.text];
            if(changeQuantity > 0) { //Check if the entered number if positive
                [self updateQuantity:[self getDbFilePath] :listItems[currentIndex] :1 :changeQuantity];
                if([self checkShopStatusIncrease:[self getDbFilePath] :listItems[currentIndex]] == TRUE && [listItems count] > 0 && self.listSwitcher.selectedSegmentIndex == 1 && currentIndex < [listItems count] - 1) //Check if the increase gets the item off the shopping list while user is on the shopping list view
                    ++currentIndex;
                else if([self checkShopStatusIncrease:[self getDbFilePath] :listItems[currentIndex]] == TRUE && [listItems count] > 0 && self.listSwitcher.selectedSegmentIndex == 1) //Check if the increase gets the item off the shopping list while user is on the shopping list view
                    --currentIndex;
                NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[currentIndex]]];
                currentQuantity.text = currentRow[1];
                currentThreshold.text = currentRow[2];
                if(self.listSwitcher.selectedSegmentIndex == 0)
                    [listItems setArray:[self getLeaves:[self getDbFilePath] :NO]];
                else
                    [listItems setArray:[self getLeaves:[self getDbFilePath] :YES]];
                [inventoryList reloadAllComponents];
            }
            else if(changeQuantity < 0) { //If the enter number is negative
                [self dataValidation];
            }
        }
        else { //If the entered number is not an integer
            [self dataValidation];
        }
    }
    updateThreshold.text = @"";
    increaseCurrent.text = @"";
    reduceCurrent.text = @"";
}

//Reduce the current quantity of the currently selected leaf
-(IBAction)reduceCurrent:(id)sender
{
    if([listItems count] > 0) { //If there is a leaf to modify, the reduction can proceed
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([reduceCurrent.text rangeOfCharacterFromSet:notDigits].location == NSNotFound) //Check if the entered number is an integer
        {
            NSArray *temp = [[NSArray alloc] initWithArray:[self getCurrent:[self getDbFilePath] :listItems[currentIndex]]];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *changeQuantity = [f numberFromString:reduceCurrent.text];
            if(changeQuantity > 0) { //Check if the entered number is positive
                NSNumber *currQuantity = [f numberFromString:temp[0]];
                if(changeQuantity > currQuantity) //Check if the entered number is greater than the current quantity total
                    changeQuantity = currQuantity;
                [self updateQuantity:[self getDbFilePath] :listItems[currentIndex] :0 :changeQuantity];
                [self checkShopStatusDecrease:[self getDbFilePath] :listItems[currentIndex]];
                NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[currentIndex]]];
                currentQuantity.text = currentRow[1];
                currentThreshold.text = currentRow[2];
            }
            else if(changeQuantity < 0) { //If the entered number is negative
                [self dataValidation];
            }
        }
        else { //if the entered number is not an integer
            [self dataValidation];
        }
    }
    updateThreshold.text = @"";
    increaseCurrent.text = @"";
    reduceCurrent.text = @"";
}

//Allow the user to modify the purchase threshold of the current leaf
-(IBAction)updateThreshold:(id)sender
{
    if([listItems count] > 0) { //If there is a leaf to modify, the update can proceed
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([updateThreshold.text rangeOfCharacterFromSet:notDigits].location == NSNotFound) //Check if entered number is an integer
        {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *changeThreshold = [f numberFromString:updateThreshold.text];
            if(changeThreshold > 0) { //Check if entered number is positive
                [self updateThreshold:[self getDbFilePath] :listItems[currentIndex] : changeThreshold];
                [self checkShopStatusIncrease:[self getDbFilePath] :listItems[currentIndex]];
                [self checkShopStatusDecrease:[self getDbFilePath] :listItems[currentIndex]];
                NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[currentIndex]]];
                currentQuantity.text = currentRow[1];
                currentThreshold.text = currentRow[2];
            }
            else if(changeThreshold < 0) { //If entered number is negative
                [self dataValidation];
            }
        }
        else { //If entered number is not an integer
            [self dataValidation];
        }
    }
    updateThreshold.text = @"";
    increaseCurrent.text = @"";
    reduceCurrent.text = @"";
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
    if([listItems count] == 0) //If there are no leaves on the current branch, allow there to be one empty element in the picker
        return 1;
    return [listItems count];
}

//Delegate Method
//the delegate method gives us a way to retrieve the selected item from the picker view.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([listItems count] == 0) //If there are no leaves on the current branch, the single empty picker element will be blank
        return nil;
    return [listItems objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    if([listItems count] > 0) {
    currentIndex = (int)row;
    NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[row]]];
        leafNameLabel.text = listItems[row];
        expDateDisplay.text = currentRow[0];
        currentQuantity.text = currentRow[1];
        currentThreshold.text = currentRow[2];
        currentIndex = (int)row;
    }
}

//Modifies the display style of the picker
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor brownColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:22.0f];
    if([listItems count] > 0)
        label.text = [NSString stringWithFormat:@"  %@", listItems[row]];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//Used when checking input in Add to Leaf, Subtract from Leaf, and Update Threshold buttons
-(void)dataValidation
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Please enter a positive integer"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   //NSLog(@"OK action");
                                   increaseCurrent.text = @"";
                                   reduceCurrent.text = @"";
                                   updateThreshold.text = @"";
                               }];
    
    [alertController addAction:okAction];
    alertController.preferredAction = okAction;
    [self presentViewController:alertController animated:YES completion:nil];
}

//Used when checking Threshold input in Add Leaf button
-(void) insertValidation
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Please enter a positive integer for the purchase threshold"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   //NSLog(@"OK action");
                                   increaseCurrent.text = @"";
                                   reduceCurrent.text = @"";
                                   updateThreshold.text = @"";
                               }];
    
    [alertController addAction:okAction];
    alertController.preferredAction = okAction;
    [self presentViewController:alertController animated:YES completion:nil];
}

//Used when checking for duplicate leaf names in Add Leaf button
-(void) leafNameValidaton
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Please enter a unique name for your new leaf"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   //NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
    alertController.preferredAction = okAction;
    [self presentViewController:alertController animated:YES completion:nil];
}

//DATABASE METHODS*********************************
-(NSString *) getDbFilePath
{
    NSString *docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:@"inventory.db"];
}

//Insert a new leaf into the currently selected branch
-(int) insertLeaf:(NSString *)filePath : (NSString *) newLeaf : (NSNumber *) newThreshold : (NSString *) newExpDate
{
    sqlite3* db = NULL;
    int rc=0;
    NSString *query;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        if([newExpDate isEqualToString:@""]) { //If the user doesn't enter an expiration date, the default value of 'Not perishable' is used
            query  = [NSString stringWithFormat:@"INSERT INTO Inventory (branch, leaf, threshold) VALUES (\"%@\", \"%@\", \"%@\")", [self.detailItem description], newLeaf, newThreshold];
        }
        else {
            query  = [NSString stringWithFormat:@"INSERT INTO Inventory (branch, leaf, threshold, expDate) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", [self.detailItem description], newLeaf, newThreshold, newExpDate];
        }
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] , NULL, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            //NSLog(@"Failed to insert record  rc:%d, msg=%s", rc, errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}

//Populate the picker view with all the leaves on the currently selected branch
-(NSArray *) getLeaves:(NSString*) filePath : (BOOL) shopping
{
    NSMutableArray * totalLeaves =[[NSMutableArray alloc] init];
    NSString *query = @"SELECT * from Inventory";
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        if(shopping == NO) { //Get ALL the leaves on the current branch
            query = [query stringByAppendingFormat:@" WHERE branch = \"%@\"",[self.detailItem description]];
        }
        else if (shopping == YES){ //Get only the leaves on the shopping list
            query = [query stringByAppendingFormat:@" WHERE branch = \"%@\" AND shopList = '1'",[self.detailItem description]];
        }
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString * nextLeaf = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                [totalLeaves addObject:nextLeaf];
                //NSLog(nextLeaf);
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return totalLeaves;
}

//Retrieve the expiration date for a leaf to display on the screen
-(NSArray *) getRowData:(NSString*) filePath : (NSString *) leafName
{
    NSMutableArray * rowData =[[NSMutableArray alloc] init];
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = @"SELECT expDate, current, threshold from Inventory";
        query = [query stringByAppendingFormat:@" WHERE leaf = \"%@\" AND branch = \"%@\"",leafName, [self.detailItem description]];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                NSString * expColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
                [rowData addObject:expColumn];
                NSString * currColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                [rowData addObject:currColumn];
                NSString * threshColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                [rowData addObject:threshColumn];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return rowData;
}

//Check if Add to Leaf or Update Threshold caused the current attribute to become greater than the threshold
-(BOOL) checkShopStatusIncrease:(NSString *) filePath : (NSString *) leafName
{
    BOOL success;
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = @"UPDATE Inventory SET shopList = '0'";
        query = [query stringByAppendingFormat:@" WHERE branch = \"%@\" AND leaf = \"%@\" AND current >= threshold",[self.detailItem description], leafName];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_DONE && sqlite3_changes(db) > 0)
                success = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//Check if Subtract from Leaf or Update Threshold caused the threshold attribute to become greater than the current
-(BOOL) checkShopStatusDecrease:(NSString *) filePath : (NSString *) leafName
{
    BOOL success;
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = @"UPDATE Inventory SET shopList = '1'";
        query = [query stringByAppendingFormat:@" WHERE branch = \"%@\" AND leaf = \"%@\" AND current < threshold",[self.detailItem description], leafName];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_DONE)
                success = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//dDelete leaf currently selected by the picker view
-(BOOL) deleteCurrentLeaf:(NSString *) filePath
{
    BOOL success = NO;
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE, NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = @"DELETE FROM Inventory";
        query = [query stringByAppendingFormat:@" WHERE branch = \"%@\" AND leaf = \"%@\"",[self.detailItem description], listItems[currentIndex]];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_DONE)
                success = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//Used to update the current attribute in the database; set addSub = 0 for reduction, addSub = 1 for increase
-(BOOL) updateQuantity:(NSString *) filePath : (NSString *) leafName : (int) addSub : (NSNumber *) difference
{
    BOOL success = FALSE;
    NSString *query = @"UPDATE Inventory SET";
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        if(addSub == 0) { //reduce quantity
            query = [query stringByAppendingFormat:@" current = current - \"%@\" WHERE branch = \"%@\" AND leaf = \"%@\"",difference, [self.detailItem description], leafName];
        }
        else { //increase quantity
            query = [query stringByAppendingFormat:@" current = current + \"%@\" WHERE branch = \"%@\" AND leaf = \"%@\"",difference, [self.detailItem description], leafName];
        }
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_DONE)
                success = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//Used the update the threshold attribute
-(BOOL) updateThreshold:(NSString *) filePath : (NSString *) leafName : (NSNumber *) newThreshold
{
    BOOL success = FALSE;
    NSString *query = @"UPDATE Inventory SET";
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        query = [query stringByAppendingFormat:@" threshold = \"%@\" WHERE branch = \"%@\" AND leaf = \"%@\"",newThreshold, [self.detailItem description], leafName];

        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_DONE)
                success = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//Used to log the current, threshold, and shopList attributes to the screen.  Useful for testing, and could be used in the future
/*-(NSArray *) checkUpdate:(NSString *) filePath : (NSString *) leafName{
    NSMutableArray * rowData =[[NSMutableArray alloc] init];
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = @"SELECT current, threshold, shopList from Inventory";
        query = [query stringByAppendingFormat:@" WHERE leaf = \"%@\" AND branch = \"%@\"",leafName, [self.detailItem description]];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                NSString * currColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
                NSLog(@"Current:");
                NSLog(currColumn);
                NSString * threshColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSLog(@"Threshold:");
                NSLog(threshColumn);
                NSString * shopColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                NSLog(@"ShopList:");
                NSLog(shopColumn);
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return rowData;
}*/

//Returns the current attribute to check if a reduction will dip below 0 (in IBAction reduceQuantity)
-(NSArray *) getCurrent:(NSString *) filePath : (NSString *) leafName{
    NSMutableArray * rowData =[[NSMutableArray alloc] init];
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = @"SELECT current from Inventory";
        query = [query stringByAppendingFormat:@" WHERE leaf = \"%@\" AND branch = \"%@\"",leafName, [self.detailItem description]];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                NSString * currColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
                //NSLog(@"Current Check:");
                //NSLog(currColumn);
                [rowData addObject:currColumn];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return rowData;
}

//Used to determine if the user is attempting to add a duplicate leaf
-(BOOL) checkLeaves:(NSString*) filePath : (NSString *) newLeaf
{
    BOOL found = NO;
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from Inventory";
        query = [query stringByAppendingFormat:@" WHERE branch = \"%@\" AND leaf = \"%@\"", [self.detailItem description], newLeaf];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_ROW)
                found = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return found;
}

@end
