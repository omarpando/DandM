//
//  ParticleView.h
//  DnM
//

#import <UIKit/UIKit.h>
#import "ParticleModel.h"


@interface ParticleView : UIView

//Model

@property(nonatomic, retain) ParticleModel *particle;

//View

@property(nonatomic, retain) UIColor *baseColor;
@property(nonatomic, retain) UIColor *disabledColor;
@property(nonatomic, assign) BOOL    enabled;
@property(nonatomic, readonly) UIColor *effectiveColor;
@property(nonatomic, retain)   UILabel *label;


-(void)updateRendering;
-(void)setLabelText:(NSString *)text;

@end
