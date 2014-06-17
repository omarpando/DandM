//
//  AttributeSelectorViewController.h
//  DnM
//
//  Created by Omar Alvarez on 7/24/13.
//  Copyright (c) 2013 Omar Alvarez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributeSelectorViewController : UIViewController<UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *attributesPicker;@property(weak,nonatomic)id<UIPickerViewDelegate, UIPickerViewDataSource>delegate;

@property int defaultSelection;


@end
