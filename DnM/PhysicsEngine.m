//
//  PhysicsEngine.m
//  DnM
//


#import "PhysicsEngine.h"
#import "ParticleSystem.h"

@implementation PhysicsEngine

@synthesize targetMins, targetMaxes, targetThresholds;



//magnet = (alpha = 1.0)
//dust = (alpha = 0.20, beta=0.30)
//attraction = 1*0.20 + 0 * 0.30 + 0*0 = 0.20

-(double)attractionBetweenSource:(ParticleModel *)source andTarget:(ParticleModel *)target{
    __block double attraction = 0.0;
    if (source.enabled && target.enabled) {
        [source.strengthByAttribute enumerateKeysAndObjectsUsingBlock:^(NSString * attributeName, NSNumber *sourceStrengthNum, BOOL *stop) {
            //NSNumber *targetStrengthNum = [target.strengthByAttribute valueForKey:attributeName];
            
            double targetStrength = [self normalizedStrengthForTarget:target  forAttributeName:attributeName];
            
            
            attraction += sourceStrengthNum.doubleValue * targetStrength;
        }];
       attraction *= source.scaleFactor;
    }
    return attraction;
}


-(double)normalizedStrengthForTarget:(ParticleModel *)target forAttributeName:(NSString *) attributeName
{
    NSNumber *targetStrengthNum = [target.strengthByAttribute valueForKey:attributeName];
    double targetStrength = targetStrengthNum.doubleValue;
    
    double normalizedStrength = 1.0;
    if(self.targetThresholds)
    {
        double span  = [self.targetMaxes strengthForAttribute:attributeName] - [self.targetMins strengthForAttribute: attributeName];
        if(span != 0)
        {
            double threshold = [self.targetThresholds strengthForAttribute:attributeName];
            normalizedStrength = (targetStrength - threshold) / span;
        }
    }
    return normalizedStrength;
}


+(void)testAttractions{
   
   /* ParticleModel *d1 = [ParticleModel particleModelWithName:@"d1" attribute:@"gravity" strength:1.0];
    [d1 addStrenght:1.0 forAttribute:@"electric"];
    
    ParticleModel *m1 = [ParticleModel particleModelWithName:@"m1" attribute:@"gravity" strength:3.0];
    ParticleModel *m2 = [ParticleModel particleModelWithName:@"m2" attribute:@"electric" strength:4.0];
    
    ParticleSystem *particleSystem = [[ParticleSystem alloc] init];
    
    [particleSystem.dustParticles addObject:d1];
    [particleSystem.magnetParticles addObject:m1];
    [particleSystem.magnetParticles addObject:m2];
 
    PhysicsEngine *physicsEngine = [[ PhysicsEngine alloc] init];
    
    [PhysicsEngine asser: [physicsEngine attractionBetweenSource:m1 andTarget:d1] equa]
    */
    
}


@end
