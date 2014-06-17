//
//  DustView.h
//  DnM
//

#import "ParticleView.h"

@interface DustView : ParticleView


-(void)highlight:(BOOL)wantsHighlighting;
@property(nonatomic) double radius;
@end
