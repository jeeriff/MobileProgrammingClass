//
//  ViewController.h
//  ImageSharingApp
//
//  Created by Matthew Harrison on 6/2/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic,strong) IBOutlet UIImageView *imageView;

-(IBAction)saveImage:(id)sender;

@end

