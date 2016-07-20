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
    shop = NO;
    currentIndex = 0;
    currExp = [[NSMutableString alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [_branchCategory setString:[self.detailItem description]];
    
    if(!self.listItems) {
        listItems = [[NSMutableArray alloc] init];
    }
    [self.listItems setArray:[self getLeaves:[self getDbFilePath] : shop]];
    self.inventoryList.dataSource = self;
    self.inventoryList.delegate = self;
    //[inventoryList reloadAllComponents];
    if([listItems count] > 0) {
        NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[0]]];
        _leafName.text = listItems[0];
        if(perish == TRUE) {
            [_expDateDisplay setHidden:FALSE];
            _expDateDisplay.text = currentRow[0];
            currExp = currentRow[0];
        }
        else {
            [_expDateDisplay setHidden:TRUE];
        }
    }
    else {
        _leafName.text = @"Create a leaf now!";
        _expDateDisplay.text = @"Create a leaf";
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
            shop = NO;
            [self.listItems setArray:[self getLeaves:[self getDbFilePath] : shop]];
            [inventoryList reloadAllComponents];
            break;
        case 1:
            shop = YES;
            [self.listItems setArray:[self getLeaves:[self getDbFilePath] : shop]];
            [inventoryList reloadAllComponents];
            break;
        default:
            break; 
    }
}

-(IBAction)perishSwitch:(id)sender {
    switch (self.perishSwitcher.selectedSegmentIndex)
    {
        case 0:
            [_expDateDisplay setHidden:TRUE];
            perish = NO;
            break;
        case 1:
            [_expDateDisplay setHidden:FALSE];
            _expDateDisplay.text = currExp;
            perish = YES;
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
                                   NSNumber *threshNum = [f numberFromString:newThreshold];
                                   [self insertLeaf:[self getDbFilePath] : newLeafName : threshNum : newExpDate];
                                   [listItems insertObject:newLeafName atIndex:0];
                                   //[self.listItems addObject:newLeafName];
                                   [inventoryList reloadAllComponents];
                                   NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[0]]];
                                   _leafName.text = listItems[0];
                                   _expDateDisplay.text = currentRow[0];
                                   currentIndex = 0;
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
    return [listItems count];
}

//Delegate Method
//the delegate method gives us a way to retrieve the selected item from the picker view.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [listItems objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    currentIndex = (int)row;
    NSArray *currentRow = [[NSArray alloc] initWithArray:[self getRowData:[self getDbFilePath] :listItems[row]]];
    _leafName.text = listItems[row];
    _expDateDisplay.text = currentRow[0];
}


//DATABASE METHODS*********************************
-(NSString *) getDbFilePath
{
    NSString *docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:@"inventory.db"];
}

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
        if(shopping == FALSE) {
            query = [query stringByAppendingFormat:@" WHERE branch = \"%@\"",[self.detailItem description]];
        }
        else {
            query = [query stringByAppendingFormat:@" WHERE branch = \"%@\" AND shopList = \"YES\"",[self.detailItem description]];
        }
        //NSString  * query = [[NSString alloc] init];
        //query = [query stringByAppendingFormat:@"SELECT * from Inventory WHERE branch = %@", [self.detailItem description]];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString * nextLeaf = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                [totalLeaves addObject:nextLeaf];
                
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
        NSString *query = @"SELECT expDate from Inventory";
        query = [query stringByAppendingFormat:@" WHERE leaf = \"%@\" AND branch = \"%@\"",leafName, [self.detailItem description]];
        //NSString  * query = [[NSString alloc] init];
        //query = [query stringByAppendingFormat:@"SELECT * from Inventory WHERE branch = %@", [self.detailItem description]];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
           // NSString * leafColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            //[rowData addObject:leafColumn];
            NSString * expColumn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            [rowData addObject:expColumn];
                currExp = [[NSMutableString alloc] initWithString:expColumn];
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
