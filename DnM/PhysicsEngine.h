//
//  PhysicsEngine.h
//  DnM
//


#import <Foundation/Foundation.h>
#import "ParticleModel.h"


@interface PhysicsEngine : NSObject

@property(nonatomic, retain)ParticleModel *targetMins;
@property(nonatomic, retain)ParticleModel *targetMaxes;
@property(nonatomic, retain)ParticleModel *targetThresholds;


-(double)attractionBetweenSource:(ParticleModel *)source andTarget:(ParticleModel *)target;



+(void)testAttractions;


@end
