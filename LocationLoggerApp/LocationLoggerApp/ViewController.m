//
//  ViewController.m
//  LocationLoggerApp
//
//  Created by Matthew Harrison on 6/21/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import <sqlite3.h>

@interface ViewController ()

@end

TableViewController *tableController = nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    tableController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self getDbFilePath]]) //if the file does not exist
    {
        [self createTable:[self getDbFilePath]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) getDbFilePath
{
    NSString *docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:@"locations.db"];
}

-(int) createTable:(NSString *) filePath
{
    sqlite3 *db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char * query ="CREATE TABLE IF NOT EXISTS locations ( id INTEGER PRIMARY KEY AUTOINCREMENT, latitude  TEXT, longitude TEXT )";
        char * errMsg;
        rc = sqlite3_exec(db, query, NULL, NULL, &errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s", rc, errMsg);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
}

-(NSArray *) getRecords:(NSString*) filePath where:(NSString *)whereStmt
{
    NSMutableArray * locations =[[NSMutableArray alloc] init];
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
        NSString  * query = @"SELECT * from locations";
        if(whereStmt)
        {
            query = [query stringByAppendingFormat:@" WHERE %@",whereStmt];
        }
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString * Latitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString * Longitude = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                
                NSDictionary *location =[NSDictionary dictionaryWithObjectsAndKeys:Latitude, @"latitude",
                                        Longitude, @"longitude", nil];
                
                [locations addObject:location];
                NSLog(@"Latitude: %@, Longitude: %@", Latitude, Longitude);
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return locations;
}


-(IBAction) showDBRecords:(id)sender
{
    NSArray * locations = [self getRecords:[self getDbFilePath] where:nil];
    [tableController setLocations:locations];
    [self.navigationController pushViewController:tableController animated:YES];
}

-(IBAction) deleteDBRecords:(id)sender
{

}

@end
