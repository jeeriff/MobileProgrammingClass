//
//  MasterViewController.m
//  Inventree
//
//  Created by Matthew Harrison on 7/6/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <sqlite3.h>

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

#define Rgb2UIColor(r, g, b) [UIColor colorWithRed:((r)/255.0) green:((g) / 255.0) blue:((b)/255.0) alpha:1.0]

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = Rgb2UIColor(255, 255, 255);
    self.title = @"Add or select a branch!";
    //[self.title.font setFont:[UIFont fontWithName:@"your font name here" size:fontsizehere]];
    [[UINavigationBar appearance] setBarTintColor:Rgb2UIColor(0, 102, 0)];
    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : Rgb2UIColor(102, 51, 0)}];

    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.shadowColor = [UIColor blackColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0f],
                                                            NSShadowAttributeName: shadow
                                                            }];
    
    
    
    
    
    
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.rightBarButtonItem.tintColor = Rgb2UIColor(255, 255, 255);
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    UIView *patternView = [[UIView alloc] initWithFrame:self.tableView.frame];
    //patternView.backgroundColor = [UIColor brownColor];
    patternView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //self.tableView.backgroundView = patternView;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Untitled.png"]];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self getDbFilePath]]) //if the file does not exist
    {
        [self createTable:[self getDbFilePath]];
    }
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    [self.objects setArray:[self getBranches:[self getDbFilePath]]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}
- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"branch2.png"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    
    NSMutableString *newItem = [[NSMutableString alloc] init];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Enter new branch name!"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIView * firstView = alertController.view.subviews.firstObject;
    UIView * nextView = firstView.subviews.firstObject;
    nextView.backgroundColor = [UIColor greenColor];
    
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"New branch name", @"NewBranch");
     }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       //NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   //NSLog(@"OK action");
                                   [newItem setString:alertController.textFields[0].text];
                                   [self.objects insertObject:newItem atIndex:0];
                                   [self insert:[self getDbFilePath] : alertController.textFields[0].text];
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                   [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableString *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = Rgb2UIColor(0, 214, 71);
    cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0f];

    NSMutableString *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteBranch:[self getDbFilePath] :self.objects[indexPath.row]];
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

//Dataabase Methods*****

-(NSString *) getDbFilePath
{
    NSString *docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:@"inventory.db"];
}

-(int) createTable:(NSString *) filePath
{
    sqlite3 *db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        char * query ="CREATE TABLE IF NOT EXISTS Inventory ( id INTEGER PRIMARY KEY AUTOINCREMENT, branch TEXT, leaf TEXT, expDate TEXT DEFAULT 'Not perishable', current REAL DEFAULT '0', threshold REAL DEFAULT '1', shopList INTEGER DEFAULT '1' )";
        char * errMsg;
        rc = sqlite3_exec(db, query, NULL, NULL, &errMsg);
        
        if(SQLITE_OK != rc)
        {
            //NSLog(@"Failed to create table rc:%d, msg=%s", rc, errMsg);
        }
        
        query ="CREATE TABLE IF NOT EXISTS Branches ( id INTEGER PRIMARY KEY AUTOINCREMENT, branchName TEXT )";
        rc = sqlite3_exec(db, query, NULL, NULL, &errMsg);
        
        if(SQLITE_OK != rc)
        {
            //NSLog(@"Failed to create table rc:%d, msg=%s", rc, errMsg);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
}

-(int) insert:(NSString *)filePath : (NSString *) newBranch
{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO Branches (branchName) VALUES (\"%@\")", newBranch];
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

-(NSArray *) getBranches:(NSString*) filePath
{
    NSMutableArray * totalBranches =[[NSMutableArray alloc] init];
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
        NSString  * query = @"SELECT DISTINCT * from Branches";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString * nextBranch = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                [totalBranches addObject:nextBranch];
                
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return totalBranches;
}

-(BOOL) deleteBranch:(NSString *) filePath : (NSArray *) branch
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
        query = [query stringByAppendingFormat:@" WHERE branch = \"%@\"", branch];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement 1 with rc:%d",rc);
        }
        NSString *query2 = @"DELETE FROM Branches";
        query2 = [query2 stringByAppendingFormat:@" WHERE branchName = \"%@\"", branch];
        rc =sqlite3_prepare_v2(db, [query2 UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_DONE)
                success = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement 2 with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

@end