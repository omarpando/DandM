//
//  DustView.m
//  DnM
//


#import "DustView.h"
#import <QuartzCore/QuartzCore.h>



@implementation DustView


@synthesize radius = _radius;

-(void)updateRendering
{
    [self setNeedsDisplay];
}

-(void)setRadius:(double)radius
{
    _radius = radius;
   
    [self updateRendering];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.baseColor = [UIColor colorWithRed:1. green:0. blue:0. alpha:1.];
        self.disabledColor = [UIColor colorWithRed:0.5 green:0.5 blue:1. alpha:0.6];
        self.backgroundColor = [UIColor colorWithRed:1. green:0. blue:0. alpha:0.];
        self.label = [[UILabel alloc] initWithFrame: self.bounds ];
        self.label.textColor = [UIColor whiteColor];
        self.radius = self.bounds.size.width / 2;
        self.layer.cornerRadius = 19.0f;
    }

    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.baseColor.CGColor);
    //CGContextAddEllipseInRect(context, self.bounds);
    //Inicio
    CGPoint p;
	p.x = self.bounds.origin.x + self.bounds.size.width/2;
	p.y = self.bounds.origin.y + self.bounds.size.height/2;

    
    
    
    CGContextAddArc(context, p.x, p.y,self.radius, 0, 2*M_PI, YES);
    
    //Final
    
    self.label.backgroundColor = self.backgroundColor;
    [self addSubview:self.label];
    CGContextFillPath(context);
    
}



-(void)highlight:(BOOL)wantsHighlighting
{
   
    
    /*if(wantsHighlighting)
    {
        self.layer.borderColor = [[UIColor blackColor]CGColor ];
        self.layer.borderWidth = 2.0f;
    }
    else{
        self.layer.borderColor =self.baseColor.CGColor;
        self.layer.borderWidth = 0.0f;
    }
     */
   
    [self updateRendering];
}



@end
