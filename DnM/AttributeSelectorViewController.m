//
//  AttributeSelectorViewController.m
//  DnM
//
//  Created by Omar Alvarez on 7/24/13.
//  Copyright (c) 2013 Omar Alvarez. All rights reserved.
//

#import "AttributeSelectorViewController.h"

@interface AttributeSelectorViewController ()

@end

@implementation AttributeSelectorViewController


@synthesize attributesPicker, delegate, defaultSelection;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.attributesPicker.delegate = self;
    // Do any additional setup after loading the view from its nib.
    [self.attributesPicker selectRow:self.defaultSelection inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UIPickerViewDelegate


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.delegate pickerView:pickerView numberOfRowsInComponent:component];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [self.delegate pickerView:pickerView didSelectRow:row inComponent:component];
    
}




-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
       return [self.delegate pickerView:pickerView titleForRow:row forComponent:component];
    
}
@end
