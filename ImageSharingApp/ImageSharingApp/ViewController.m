//
//  ViewController.m
//  ImageSharingApp
//
//  Created by Matthew Harrison on 6/2/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveImage:(id)sender {
    
    UIImage *shareImage = self.imageView.image;
    
    NSArray *activityItems = @[@"", shareImage];
    
    //Sharing part
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    //Exclude an activity. Example: I want to exclude Twitter and Weibo.
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                         UIActivityTypePrint,
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeMail,
                                         UIActivityTypeMessage,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypeAirDrop];
    
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

@end
