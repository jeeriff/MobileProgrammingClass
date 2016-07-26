//
//  MasterViewController.m
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //Hide the table view gridlines
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; //Set Back button color to white on detail view
    self.navigationItem.leftBarButtonItem = self.editButtonItem; //Set the left navigation button button to be Edit
    self.navigationItem.leftBarButtonItem.tintColor = Rgb2UIColor(255, 255, 255); //Set Edit button color to white
    self.title = @"Add or select a branch!"; //Set table view title
    [[UINavigationBar appearance] setBarTintColor:Rgb2UIColor(0, 102, 0)]; //Set navigation bar color to green

    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.shadowColor = [UIColor blackColor]; //Format the navigation bar title to have a faint shadow
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0f],
                                                            NSShadowAttributeName: shadow
                                                            }];
    
    //Add button calls alert which adds new branch via an embedded method
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton; //Set right navigation bar button to be Add
    self.navigationItem.rightBarButtonItem.tintColor = Rgb2UIColor(255, 255, 255);  //Set Add buton color to white
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //Set background of table view to be image of tree trunk
    UIView *patternView = [[UIView alloc] initWithFrame:self.tableView.frame];
    patternView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImageFiles/Untitled.png"]];
    
    //If they don't exist, create the database tables
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self getDbFilePath]])
    {
        [self createTable:[self getDbFilePath]];
    }
    //If the objects array has not been initialized, initialize it
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects setArray:[self getBranches:[self getDbFilePath]]]; //Load the objects array with all branch names in the Branches table
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}
- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{ //Set the cell background to be an image of a tree branch
    cell.backgroundView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImageFiles/branch2.png"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Display an alert to the user that allows them to create a new branch (but prevents the creation of a duplicate)
- (void)insertNewObject:(id)sender {

    NSMutableString *newItem = [[NSMutableString alloc] init];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Enter new branch name!"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert]; //The alert itself
    
    //Set the color of the alert to green
    UIView * firstView = alertController.view.subviews.firstObject;
    UIView * nextView = firstView.subviews.firstObject;
    nextView.backgroundColor = [UIColor greenColor];
    
    //Adds a text field to the alert where the user can name the new branch
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
                                   if([self checkBranches:[self getDbFilePath] : newItem] == NO){ //If the entered branch is not a duplicate, add it
                                       [self.objects insertObject:newItem atIndex:0];
                                       [self insert:[self getDbFilePath] : alertController.textFields[0].text];
                                       NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                       [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                   }
                                   else {
                                       [self insertValidation]; //If the entered branch already exists, show an alert and prevent the add
                                   }
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
    //Set the font and color of text in table view cells
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = Rgb2UIColor(0, 214, 71);
    cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0f];

    NSMutableString *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteInventoryBranch:[self getDbFilePath] :self.objects[indexPath.row]]; //Delete all leaves in Inventory table associated with the branch
        [self deleteBranchesBranch:[self getDbFilePath] :self.objects[indexPath.row]]; //Delete branch from Branch table
        [self.objects removeObjectAtIndex:indexPath.row]; //Remove branch from objects array, removing it from the table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

//Called when the user attempts to add a duplicate branch
-(void) insertValidation
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Please enter a unique name for your new branch"
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

//Returns all of the branch names stored in the Branches table
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

//Deletes all leaves in the Inventory table that are associated with the selected branch
-(BOOL) deleteInventoryBranch:(NSString *) filePath : (NSString *) branch
{
    BOOL success = NO;
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt = NULL;
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
            if(sqlite3_step(stmt) == SQLITE_DONE)
                success = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//Delete the selected branch from the Branches table
-(BOOL) deleteBranchesBranch:(NSString *) filePath : (NSString *) branch
{
    BOOL success = NO;
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE, NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        //NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString *query = @"DELETE FROM Branches";
        query = [query stringByAppendingFormat:@" WHERE branchName = \"%@\"", branch];
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            if(sqlite3_step(stmt) == SQLITE_DONE)
                success = YES;
            sqlite3_finalize(stmt);
        }
        else
        {
            //NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return success;
}

//Returns YES if the selected branch already exist in the Branches table; returns NO if it does not yet exist
-(BOOL) checkBranches:(NSString*) filePath : (NSString *) newBranch
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
        NSString  * query = @"SELECT * from Branches";
        query = [query stringByAppendingFormat:@" WHERE branchName = \"%@\"", newBranch];
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