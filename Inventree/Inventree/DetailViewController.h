//
//  DetailViewController.h
//  Inventree
//
//  Created by Matthew Harrison on 7/6/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UIPickerView *listTypesPicker;
    
}

@property (retain, nonatomic) UIPickerView *listTypesPicker;
@property (strong, nonatomic) NSArray *listTypes;
@property (weak, nonatomic) NSMutableString *branchCategory;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

