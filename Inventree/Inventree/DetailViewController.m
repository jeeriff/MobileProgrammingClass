//
//  DetailViewController.m
//  Inventree
//
//  Created by Matthew Harrison on 7/6/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

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
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    perish = NO;
    currentIndex = 0;
    currExp = [[NSMutableString alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [_branchCategory setString:[self.detailItem description]];
    
    if(!self.listItems) {
        listItems = [[NSMutableArray alloc] init];
    }
    [self.listItems setArray:[self getLeaves:[self getDbFilePath] : NO]];
    self.inventoryList.dataSource = self;
    self.inventoryList.delegate = self;
    //[inventoryList reloadAllComponents];
    self.userInterfaceSwitcher.selectedSegmentIndex = 1;
    [currentThreshold setHidden:FALSE];
    [currentThresholdLabel setHidden:FALSE];
    [currentQuantity setHidden:FALSE];
    [currentQuantityLabel setHidden:FALSE];
    self.perishSwitcher.selectedSegmentIndex = 0;
    [expDateDisplay setHidden:TRUE];
    [expDateDisplayLabel setHidden:FALSE];
    [_perishSwitcher setHidden:FALSE];
    if([listItems count] > 0) {
        NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[0]]];
        _leafName.text = listItems[0];
        currentQuantity.text = currentRow[1];
        currentThreshold.text = currentRow[2];
        if(perish == TRUE) {
            [expDateDisplay setHidden:FALSE];
            expDateDisplay.text = currentRow[0];
            currExp = currentRow[0];
        }
        else {
            [expDateDisplay setHidden:TRUE];
        }
    }
    else {
        _leafName.text = @"Create a leaf now!";
        expDateDisplay.text = @"Create a leaf";
        currentQuantity.text = @"";
        currentThreshold.text = @"";
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)listSwitch:(id)sender {
    switch (self.listSwitcher.selectedSegmentIndex)
    {
        case 0:
            [inventoryList selectedRowInComponent:0];
            [self.listItems setArray:[self getLeaves:[self getDbFilePath] : NO]];
            self.inventoryList.dataSource = self;
            self.inventoryList.delegate = self;
            [inventoryList reloadAllComponents];
            if([listItems count] > 0) {
                NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] : listItems[0]]];
                _leafName.text = listItems[0];
                expDateDisplay.text = currentRow[0];
                currentQuantity.text = currentRow[1];
                currentThreshold.text = currentRow[2];
            }
            else if([listItems count] == 0) {
                _leafName.text = @"Create a new leaf!";
                expDateDisplay.text = @"Create a leaf";
                currentQuantity.text = @"";
                currentThreshold.text = @"";
            }

            break;
        case 1:
            [inventoryList selectedRowInComponent:0];
            [self.listItems setArray:[self getLeaves:[self getDbFilePath] : YES]];
            self.inventoryList.dataSource = self;
            self.inventoryList.delegate = self;
            [inventoryList reloadAllComponents];
            if([listItems count] > 0) {
                NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] : listItems[0]]];
                _leafName.text = listItems[0];
                expDateDisplay.text = currentRow[0];
                currentQuantity.text = currentRow[1];
                currentThreshold.text = currentRow[2];
            }
            else if([listItems count] == 0) {
                _leafName.text = @"Shopping list is empty";
                expDateDisplay.text = @"";
                currentQuantity.text = @"";
                currentThreshold.text = @"";
            }
            break;
        default:
            break;
    }
}

-(IBAction)perishSwitch:(id)sender {
    switch (self.perishSwitcher.selectedSegmentIndex)
    {
        case 0:
            [expDateDisplay setHidden:TRUE];
            perish = NO;
            break;
        case 1:
            [expDateDisplay setHidden:FALSE];
            expDateDisplay.text = currExp;
            perish = YES;
            break;
        default:
            break;
    }
}

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
            [_perishSwitcher setHidden:TRUE];
            break;
        case 1:
            [currentThreshold setHidden:FALSE];
            [currentThresholdLabel setHidden:FALSE];
            [currentQuantity setHidden:FALSE];
            [currentQuantityLabel setHidden:FALSE];
            self.perishSwitcher.selectedSegmentIndex = 1;
            [expDateDisplay setHidden:FALSE];
            [expDateDisplayLabel setHidden:FALSE];
            [_perishSwitcher setHidden:FALSE];
            break;
        default:
            break;
    }
}

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
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Add", @"Add action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"Add action");
                                   [newLeafName setString:alertController.textFields[0].text];
                                   [newThreshold setString:alertController.textFields[1].text];
                                   [newExpDate setString:alertController.textFields[2].text];
                                   NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                                   f.numberStyle = NSNumberFormatterDecimalStyle;
                                   
                                   NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                                   if ([newThreshold rangeOfCharacterFromSet:notDigits].location == NSNotFound)
                                   {
                                       NSNumber *threshNum = [f numberFromString:newThreshold];
                                       if(threshNum > 0) {
                                           [self insertLeaf:[self getDbFilePath] : newLeafName : threshNum : newExpDate];
                                           [listItems insertObject:newLeafName atIndex:0];
                                           //[self.listItems addObject:newLeafName];
                                           [inventoryList reloadAllComponents];
                                           NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[0]]];
                                           _leafName.text = listItems[0];
                                           expDateDisplay.text = currentRow[0];
                                           currentQuantity.text = currentRow[1];
                                           currentThreshold.text = currentRow[2];
                                           currentIndex = 0;
                                           self.perishSwitcher.selectedSegmentIndex = 0;
                                           [expDateDisplay setHidden:TRUE];
                                           self.listSwitcher.selectedSegmentIndex = 0;
                                           updateThreshold.text = @"";
                                           increaseCurrent.text = @"";
                                           reduceCurrent.text = @"";
                                       }
                                       else if(threshNum < 0) {
                                           [self insertValidation];
                                       }
                                   }
                                   else {
                                       [self insertValidation];
                                   }
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)deleteLeaf:(id)sender
{
    if([listItems count] > 0) {
    [self deleteCurrentLeaf:[self getDbFilePath]];
    [self.listItems setArray:[self getLeaves:[self getDbFilePath] : NO]];
    [inventoryList reloadAllComponents];
    if([listItems count] > 0) {
        NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[currentIndex]]];
        _leafName.text = listItems[currentIndex];
        expDateDisplay.text = currentRow[0];
        currentQuantity.text = currentRow[1];
        currentThreshold.text = currentRow[2];
    }
    }
    if([listItems count] == 0) {
        _leafName.text = @"Create a leaf now!";
        expDateDisplay.text = @"Create a leaf";
        currentQuantity.text = @"";
        currentThreshold.text = @"";
        [currExp setString:@""];
    }
}

-(IBAction)increaseCurrent:(id)sender
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([increaseCurrent.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        [self checkUpdate:[self getDbFilePath] :listItems[currentIndex]];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *changeQuantity = [f numberFromString:increaseCurrent.text];
        if(changeQuantity > 0) {
            [self updateQuantity:[self getDbFilePath] :listItems[currentIndex] :1 :changeQuantity];
            [self checkShopStatusIncrease:[self getDbFilePath] :listItems[currentIndex]];
            [self checkUpdate:[self getDbFilePath] :listItems[currentIndex]];
        }
        else if(changeQuantity < 0) {
            [self dataValidation];
        }
    }
    else {
        [self dataValidation];
    }
    updateThreshold.text = @"";
    increaseCurrent.text = @"";
    reduceCurrent.text = @"";
}

-(IBAction)reduceCurrent:(id)sender
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([reduceCurrent.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        [self checkUpdate:[self getDbFilePath] :listItems[currentIndex]];
        NSArray *temp = [[NSArray alloc] initWithArray:[self getCurrent:[self getDbFilePath] :listItems[currentIndex]]];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *changeQuantity = [f numberFromString:reduceCurrent.text];
        if(changeQuantity > 0) {
            NSNumber *currQuantity = [f numberFromString:temp[0]];
            if(changeQuantity > currQuantity)
                changeQuantity = currQuantity;
            [self updateQuantity:[self getDbFilePath] :listItems[currentIndex] :0 :changeQuantity];
            [self checkShopStatusDecrease:[self getDbFilePath] :listItems[currentIndex]];
            [self checkUpdate:[self getDbFilePath] :listItems[currentIndex]];
        }
        else if(changeQuantity < 0) {
            [self dataValidation];
        }
    }
    else {
        [self dataValidation];
    }
    updateThreshold.text = @"";
    increaseCurrent.text = @"";
    reduceCurrent.text = @"";
}

-(IBAction)updateThreshold:(id)sender
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([updateThreshold.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        [self checkUpdate:[self getDbFilePath] :listItems[currentIndex]];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *changeThreshold = [f numberFromString:updateThreshold.text];
        if(changeThreshold > 0) {
            [self updateThreshold:[self getDbFilePath] :listItems[currentIndex] : changeThreshold];
            [self checkShopStatusIncrease:[self getDbFilePath] :listItems[currentIndex]];
            [self checkShopStatusDecrease:[self getDbFilePath] :listItems[currentIndex]];
            [self checkUpdate:[self getDbFilePath] :listItems[currentIndex]];
        }
        else if(changeThreshold < 0) {
            [self dataValidation];
        }
    }
    else {
        [self dataValidation];
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
    if([listItems count] == 0)
        return 1;
    return [listItems count];
}

//Delegate Method
//the delegate method gives us a way to retrieve the selected item from the picker view.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([listItems count] == 0)
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
        _leafName.text = listItems[row];
        expDateDisplay.text = currentRow[0];
        currentQuantity.text = currentRow[1];
        currentThreshold.text = currentRow[2];
        currentIndex = (int)row;
    }
}

-(void)dataValidation
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Please enter a positive number"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   increaseCurrent.text = @"";
                                   reduceCurrent.text = @"";
                                   updateThreshold.text = @"";
                               }];
    
    [alertController addAction:okAction];
    alertController.preferredAction = okAction;
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) insertValidation
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Please enter a positive number for the purchase threshold"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   increaseCurrent.text = @"";
                                   reduceCurrent.text = @"";
                                   updateThreshold.text = @"";
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

//insert a new leaf into the currently selected branch
-(int) insertLeaf:(NSString *)filePath : (NSString *) newLeaf : (NSNumber *) newThreshold : (NSString *) newExpDate
{
    sqlite3* db = NULL;
    int rc=0;
    NSString *query;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        if([newExpDate isEqualToString:@""]) {
            query  = [NSString stringWithFormat:@"INSERT INTO Inventory (branch, leaf, threshold) VALUES (\"%@\", \"%@\", \"%@\")", [self.detailItem description], newLeaf, newThreshold];
        }
        else {
            query  = [NSString stringWithFormat:@"INSERT INTO Inventory (branch, leaf, threshold, expDate) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", [self.detailItem description], newLeaf, newThreshold, newExpDate];
        }
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] , NULL, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s", rc, errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}

//populate the picker view with all the leaves on the currently selected branch
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
        NSLog(@"Failed to open db connection");
    }
    else
    {
        if(shopping == NO) {
            query = [query stringByAppendingFormat:@" WHERE branch = \"%@\"",[self.detailItem description]];
        }
        else if (shopping == YES){
            query = [query stringByAppendingFormat:@" WHERE branch = \"%@\" AND shopList = '1'",[self.detailItem description]];
        }
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString * nextLeaf = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                [totalLeaves addObject:nextLeaf];
                NSLog(nextLeaf);
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return totalLeaves;
}

//retrieve the expiration date for a leaf to display on the screen
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
        NSLog(@"Failed to open db connection");
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
                currExp = [[NSMutableString alloc] initWithString:expColumn];
                NSString * currColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                [rowData addObject:currColumn];
                NSString * threshColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                [rowData addObject:threshColumn];
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
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = @"UPDATE Inventory SET shopList = '0'";
        query = [query stringByAppendingFormat:@" WHERE branch = \"%@\" AND leaf = \"%@\" AND current >= threshold",[self.detailItem description], leafName];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_DONE)
                success = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

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
        NSLog(@"Failed to open db connection");
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
            NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//delete leaf currently selected by the picker view
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
        NSLog(@"Failed to open db connection");
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
            NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//Used to update the 'current' attribute in the database; set addSub = 0 for reduction, addSub = 1 for increase
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
        NSLog(@"Failed to open db connection");
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
            NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//used the update the threshold attribute
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
        NSLog(@"Failed to open db connection");
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
            NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}


//This function is used purely for testing purposes and will be removed before we turn in the project******
-(NSArray *) checkUpdate:(NSString *) filePath : (NSString *) leafName{
    NSMutableArray * rowData =[[NSMutableArray alloc] init];
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
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
}

//returns the current attribute to check if a reduction will dip below 0 (in IBAction reduceQuantity)
-(NSArray *) getCurrent:(NSString *) filePath : (NSString *) leafName{
    NSMutableArray * rowData =[[NSMutableArray alloc] init];
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
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
                NSLog(@"Current Check:");
                NSLog(currColumn);
                [rowData addObject:currColumn];
                // NSString * threshColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                // NSLog(threshColumn);
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

@end
