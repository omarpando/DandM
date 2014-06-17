//
//  ParticleSystem.h
//  DnM
//

#import <Foundation/Foundation.h>
#import "ParticleModel.h"

@interface ParticleSystem : NSObject



@property(nonatomic, retain) ParticleModel *dustMin;
@property(nonatomic, retain) ParticleModel *dustMax;

@property(nonatomic, retain) ParticleModel *dustThreshold;

@property(nonatomic, retain) NSMutableArray *magnetParticles;
@property(nonatomic, retain) NSMutableArray *dustParticles;
@property(nonatomic, retain) NSSet *knownAttributes;

@property(nonatomic, readonly)NSArray *attributes;

-(id)initWithTestData;

-(id)initWithLocalDB;


-(id)initWithRicherData;

@end
