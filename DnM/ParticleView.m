//
//  ParticleView.m
//  DnM
//


#import "ParticleView.h"

@implementation ParticleView

@synthesize baseColor = _baseColor;
@synthesize disabledColor = _disabledColor;
@synthesize enabled = _enabled;
@synthesize effectiveColor = _effectiveColor;
@synthesize label = _label;





- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)updateRendering{
    [self setNeedsDisplay];
    
}
-(void)setLabelText:(NSString *)text{
    self.label.text = text;
}



-(void) setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    self.particle.enabled = _enabled;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  
}

*/
@end
