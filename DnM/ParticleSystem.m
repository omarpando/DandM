//
//  ParticleSystem.m
//  DnM
//


#import "ParticleSystem.h"

@interface ParticleSystem()

-(ParticleModel *)initializeThresholdParticle;



@end

@implementation ParticleSystem


-(ParticleModel *)initializeThresholdParticle
{
    
    NSArray * systemAttributes = self.attributes;
    NSMutableDictionary __block *strengthByAttrForDustThreshold = [NSMutableDictionary dictionary];
    [systemAttributes enumerateObjectsUsingBlock:^(NSString *attributeName, NSUInteger attributeIdx, BOOL *stop) {
        double minValue = [[self minValueForAttribute:attributeName] doubleValue];
        //double maxValue = [[self maxValueForAttribute:attributeName] doubleValue];
        //double threshold = (maxValue - minValue) / 2.0;
        double threshold = minValue ;
        
        [strengthByAttrForDustThreshold setObject:[NSNumber numberWithDouble:threshold] forKey:attributeName];
    }];
    
    return [[ParticleModel alloc] initWithName:@"dustThreshold"strengthByAttribute:strengthByAttrForDustThreshold ];
}


@synthesize magnetParticles = _magnetParticles , dustParticles = _dustParticles, knownAttributes, dustMin, dustMax, dustThreshold = _dustThreshold;


-(NSMutableArray *) p_testMagnetModel
{
    NSMutableArray *result = [NSMutableArray array];
    
    [result addObject:[ParticleModel  particleModelWithName:@"m1a" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"alpha", nil]]];
    
    [result addObject:[ParticleModel  particleModelWithName:@"m2b" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"beta", nil]]];
    
    [result addObject:[ParticleModel  particleModelWithName:@"m3g" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"gamma", nil]]];
    
    return result;
}

-(id)initWithTestData{
    self = [super init];
    if (self){
        
        //Magnet
        ParticleModel *m1 = [ParticleModel  particleModelWithName:@"alpha" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"alpha", nil]];
        
        ParticleModel *m2 = [ParticleModel  particleModelWithName:@"beta" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"beta", nil]];
        
        ParticleModel *m3 = [ParticleModel  particleModelWithName:@"gamma" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"gamma", nil]];
        
        
        [self.magnetParticles addObject:m1];
        [self.magnetParticles addObject:m2];
        [self.magnetParticles addObject:m3];
        
        
        //Dust
        
        ParticleModel *d1 = [ParticleModel particleModelWithName:@"d1" attribute:@"alpha" strength:0.20];
        [d1 addStrenght:0.30 forAttribute:@"beta"];
        [d1 addStrenght:0.0 forAttribute:@"gamma"];
        
        
        
        ParticleModel *d2 = [ParticleModel particleModelWithName:@"d2" attribute:@"alpha" strength:0.50];
        [d2 addStrenght:0.70 forAttribute:@"beta"];
        [d2 addStrenght:0.0 forAttribute:@"gamma"];
        
        ParticleModel *d3 = [ParticleModel particleModelWithName:@"d3" attribute:@"alpha" strength:1.0];
        [d3 addStrenght:0.0 forAttribute:@"beta"];
        [d3 addStrenght:0.0 forAttribute:@"gamma"];
        
        
        ParticleModel *d4 = [ParticleModel particleModelWithName:@"d4" attribute:@"alpha" strength:0.0];
        [d4 addStrenght:1.0 forAttribute:@"beta"];
        [d4 addStrenght:0.0 forAttribute:@"gamma"];
        
        
        
        [self.dustParticles addObject:d1];
        [self.dustParticles addObject:d2];
        [self.dustParticles addObject:d3];
        [self.dustParticles addObject:d4];
                
    }
    return self;
}



-(id)initWithLocalDB
{
    self = [super init];
    if(self)
    {
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"serving size" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"serving size", nil]]];
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"calories" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"calories", nil]]];
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"total fat" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"total fat", nil]]];
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"saturated fat" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"saturated fat", nil]]];
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"carbs" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"carbs", nil]]];
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"fiber" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"fiber", nil]]];
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"sugar" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"sugar", nil]]];
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"protein" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"protein", nil]]];
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"trans fat" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"trans fat", nil]]];
        
        [self.magnetParticles addObject:[ParticleModel  particleModelWithName:@"hfcs" strengthByAttribute:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.00], @"hfcs", nil]]];
        
        
        
        NSStringEncoding encoding;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"db2" ofType:@"js"];
        NSError* error;
        NSString* jSONString = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:&error];
        
        NSArray *cereals = [NSJSONSerialization JSONObjectWithData:[jSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        
        for (NSDictionary *cereal in cereals) {
            NSMutableDictionary *strengthByAttributeForDust = [NSMutableDictionary dictionary];
            
            
            NSString *name = [cereal objectForKey:@"name"];
            
            
            
            NSString *servingSize = [cereal objectForKey:@"serving size"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[servingSize doubleValue]] forKey:@"serving size"];
            
                        
            
            NSString *calories = [cereal objectForKey:@"calories"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[calories doubleValue]] forKey:@"calories"];
            
            NSString *totalFat = [cereal objectForKey:@"total fat"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[totalFat doubleValue]] forKey:@"total fat"];
            
            NSString *saturatedFat = [cereal objectForKey:@"saturated fat"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[saturatedFat doubleValue]] forKey:@"saturated fat"];
            
            NSString *carbs = [cereal objectForKey:@"carbs"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[carbs doubleValue]] forKey:@"carbs"];
            
            NSString *fiber = [cereal objectForKey:@"fiber"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[fiber doubleValue]] forKey:@"fiber"];
            
            NSString *sugar = [cereal objectForKey:@"sugar"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[sugar doubleValue]] forKey:@"sugar"];
            
            NSString *protein = [cereal objectForKey:@"protein"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[protein doubleValue]] forKey:@"protein"];
            
            NSString *transFat = [cereal objectForKey:@"trans fat"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[transFat doubleValue]] forKey:@"trans fat"];
            
            NSString *hfcs = [cereal objectForKey:@"hfcs"];
            [strengthByAttributeForDust setObject:[NSNumber numberWithDouble:[hfcs doubleValue]] forKey:@"hfcs"];
            
            [self.dustParticles addObject:[ParticleModel particleModelWithName:name strengthByAttribute:strengthByAttributeForDust]];
            

        }
    }
    return self;
}





-(ParticleModel *)dustMin
{
    NSArray * systemAttributes = self.attributes;
    NSMutableDictionary __block *strengthByAttrForDustMin = [NSMutableDictionary dictionary];
    
    [systemAttributes enumerateObjectsUsingBlock:^(NSString *attributeName, NSUInteger attributeIdx, BOOL *stop) {
        [strengthByAttrForDustMin setObject:[self minValueForAttribute:attributeName] forKey:attributeName];
    }];
    return [[ParticleModel alloc] initWithName:@"dustMin"strengthByAttribute:strengthByAttrForDustMin ];
}

-(ParticleModel *)dustMax
{
    NSArray * systemAttributes = self.attributes;
    NSMutableDictionary __block *strengthByAttrForDustMax = [NSMutableDictionary dictionary];
    
    [systemAttributes enumerateObjectsUsingBlock:^(NSString *attributeName, NSUInteger attributeIdx, BOOL *stop) {
        [strengthByAttrForDustMax setObject:[self maxValueForAttribute:attributeName] forKey:attributeName];
    }];
    return [[ParticleModel alloc] initWithName:@"dustMax"strengthByAttribute:strengthByAttrForDustMax ];
}


-(ParticleModel *)dustThreshold
{
    if(!_dustThreshold)
    {
        _dustThreshold = [self initializeThresholdParticle];
    }
    return _dustThreshold;
}

-(void)setDustThreshold:(ParticleModel *)dustThreshold
{
    _dustThreshold = dustThreshold;
}
-(NSNumber *)minValueForAttribute:(NSString *) attributeName
{
    double minValue = [[[[self.dustParticles objectAtIndex:0] strengthByAttribute] objectForKey:attributeName] doubleValue];
    for(int i = 1; i < self.dustParticles.count; i++)
    {
        double value = [[[[self.dustParticles objectAtIndex:i] strengthByAttribute] objectForKey:attributeName] doubleValue];
        if(minValue > value)
        {
            minValue = value;
        }
    }
    return [NSNumber numberWithDouble:minValue];

}

-(NSNumber *)maxValueForAttribute:(NSString *) attributeName
{
    double maxValue = [[[[self.dustParticles objectAtIndex:0] strengthByAttribute] objectForKey:attributeName] doubleValue];
    for(int i = 1; i < self.dustParticles.count; i++)
    {
        double value = [[[[self.dustParticles objectAtIndex:i] strengthByAttribute] objectForKey:attributeName] doubleValue];
        if(maxValue < value)
        {
            maxValue = value;
        }
    }
    return [NSNumber numberWithDouble:maxValue];
    
}



-(id)initWithRicherData
{
    self = [super init];
    if (self){
        
    }
    return self;
}


-(NSMutableArray *) magnetParticles
{
    if (!_magnetParticles) {
        _magnetParticles = [NSMutableArray array];
    }
    return _magnetParticles;
}

-(NSMutableArray *) dustParticles
{
    if (!_dustParticles) {
        _dustParticles = [NSMutableArray array];
    }
    return _dustParticles;
}

-(NSArray *)attributes
{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    
    [self.magnetParticles enumerateObjectsUsingBlock:^(ParticleModel * magnet, NSUInteger idxMagnet, BOOL *stop) {
        NSArray * attr = [magnet.strengthByAttribute allKeys];
        [set addObjectsFromArray:attr];
    }];
    
    return [set allObjects];
}

@end
