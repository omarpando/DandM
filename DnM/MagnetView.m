//
//  MagnetView.m
//  DnM
//


#import "MagnetView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MagnetView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.baseColor = [UIColor colorWithRed:0.5 green:0.5 blue:1. alpha:1.];
        //self.disabledColor = [UIColor colorWithRed:0.5 green:0.5 blue:1. alpha:0.1];//When disabled, make translucent
        self.disabledColor = [UIColor orangeColor];
        self.backgroundColor = self.baseColor;       
        self.enabled = YES;       
        self.label = [[UILabel alloc] initWithFrame: self.bounds ];
        self.label.textColor = [UIColor whiteColor];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    if(self.enabled)
    {
        self.backgroundColor = self.baseColor;
    }else{
        self.backgroundColor = self.disabledColor;
    }
    self.label.backgroundColor = self.backgroundColor;
    
    [self addSubview:self.label];
   
}


@end
