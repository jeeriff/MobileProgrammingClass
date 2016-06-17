//
//  DetailViewController.m
//  ToDoApp
//
//  Created by Justin Dowell and Matthew Harrison.
//  Github repository:
//  https://github.com/jeeriff/MobileProgrammingClass

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize itemDateLabel;
@synthesize itemLocaleLabel;
@synthesize itemDescrLabel;

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
        itemDateLabel.text = [self.detailItem ToDoDate];
        itemLocaleLabel.text = [self.detailItem ToDoLocale];
        itemDescrLabel.text = [self.detailItem ToDoDescript];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    self.title = [self.detailItem ToDoName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










@end
