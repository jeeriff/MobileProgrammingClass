//
//  ViewController.m
//  PickerViewApp
//
//  Created by Matthew Harrison on 6/2/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize singlePicker;
@synthesize pickerData;
@synthesize medPrescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //an array of objects to be used for picker view
    NSArray *array = [[NSArray alloc] initWithObjects:@"Coughing",
                      @"Headache",
                      @"Sneezing",
                      @"Drowsiness",
                      @"Sore Throat",
                      @"Broken Funny Bone",
                      @"Sprained Funny Bone",
                      @"Receding Hair Line",
                      @"Retreating Hair Line",
                      @"Sudden Bout of Sanity", nil];
    self.pickerData = array;
    
    // Connect data
    self.singlePicker.dataSource = self;
    self.singlePicker.delegate = self;
    
    //an array of objects to contain medication
    NSArray *prescription = [[NSArray alloc] initWithObjects:@"Ibuprofen - 800 milligrams",
                             @"Flavored Throat Losange - 1 count",
                             @"Nyquil - 1 tablespoon",
                             @"Time - 15 minutes",
                             @"Look at an internet message board - 20 comments",
                             @"Hair treatment solution of your choice - 4 weeks",
                             @"Hot, homemade soup - 1 bowl",
                             @"Say the alphabet in a thick, Irish brogue - 26 letters",
                             @"Coffee - 1 cup",
                             @"Listen to heavy metal - 2 songs",
                             @"Wear a hat - until no longer self-conscious",
                             @"Stop looking at the mirror so much - every day",
                             @"Give your hair a good pep-talk - 500 words", nil];
    
    self.medPrescription = prescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [pickerData count];
}

//Delegate Method
//the delegate method gives us a way to retrieve the selected item from the picker view.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.

    
    if(row == 0) { //Coughing selected
        medication1.text = [medPrescription objectAtIndex: 0];
        medication2.text = [medPrescription objectAtIndex: 1];
        medication3.text = [medPrescription objectAtIndex: 2];
    }
    else if(row == 1) { //Headache selected
        medication1.text = [medPrescription objectAtIndex: 0];
        medication2.text = [medPrescription objectAtIndex: 2];
        medication3.text = [medPrescription objectAtIndex: 3];
    }
    else if(row == 2) { //Sneezing selected
        medication1.text = [medPrescription objectAtIndex: 1];
        medication2.text = [medPrescription objectAtIndex: 2];
        medication3.text = [medPrescription objectAtIndex: 6];
    }
    else if(row == 3) { //Drowsiness selected
        medication1.text = [medPrescription objectAtIndex: 6];
        medication2.text = [medPrescription objectAtIndex: 8];
        medication3.text = [medPrescription objectAtIndex: 9];
    }
    else if(row == 4) { //Sore Throat selected
        medication1.text = [medPrescription objectAtIndex: 1];
        medication2.text = [medPrescription objectAtIndex: 2];
        medication3.text = [medPrescription objectAtIndex: 6];
    }
    else if(row == 5) { //Broken Funny Bone selected
        medication1.text = [medPrescription objectAtIndex: 3];
        medication2.text = [medPrescription objectAtIndex: 4];
        medication3.text = [medPrescription objectAtIndex: 7];
    }
    else if(row == 6) { //Sprained Funny Bone selected
        medication1.text = [medPrescription objectAtIndex: 3];
        medication2.text = [medPrescription objectAtIndex: 4];
        medication3.text = [medPrescription objectAtIndex: 9];
    }
    else if(row == 7) { //Receding Hair Line selected
        medication1.text = [medPrescription objectAtIndex: 5];
        medication2.text = [medPrescription objectAtIndex: 10];
        medication3.text = [medPrescription objectAtIndex: 11];
    }
    else if(row == 8) { //Retreating Hair Line selected
        medication1.text = [medPrescription objectAtIndex: 10];
        medication2.text = [medPrescription objectAtIndex: 11];
        medication3.text = [medPrescription objectAtIndex: 12];
    }
    else if(row == 9) { //Sudden Bout of Sanity selected
        medication1.text = [medPrescription objectAtIndex: 3];
        medication2.text = [medPrescription objectAtIndex: 4];
        medication3.text = [medPrescription objectAtIndex: 8];
    }
}

@end
