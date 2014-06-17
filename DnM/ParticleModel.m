//
//  ParticleModel.m
//  DnM
//


#import "ParticleModel.h"

@implementation ParticleModel

@synthesize name , strengthByAttribute, attributes , enabled, scaleFactor;



-(ParticleModel *)initWithName:(NSString *)inName strengthByAttribute: (NSMutableDictionary *) inStrengthByAttribute
{
    self = [super init];
    if(self)
    {
        self.name = inName;
        self.strengthByAttribute = inStrengthByAttribute;
        self.enabled = YES;
        self.scaleFactor = 1.0;
        
    }
    
    return self;
}



-(void)addStrenght:(double)strength forAttribute:(NSString *)attr{
    if(!strengthByAttribute){
        strengthByAttribute = [[NSMutableDictionary alloc] init];
    }
    [strengthByAttribute setObject:[NSNumber numberWithDouble:strength] forKey:attr];    
}


+(ParticleModel *)particleModelWithName:(NSString *) inName strengthByAttribute: (NSMutableDictionary *)inStrengthByAttribute
{
    return [[ParticleModel alloc] initWithName:inName strengthByAttribute:inStrengthByAttribute];
}

+(ParticleModel *)particleModelWithName:(NSString *)inName  attribute:(NSString *)attr strength:(double) stre{
    NSMutableDictionary *sByAttr = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithDouble:stre] forKey:attr];
    return [[ParticleModel alloc] initWithName:inName strengthByAttribute:sByAttr];
}



-(double)strengthForAttribute:(NSString *)attributeName
{
    return [[self.strengthByAttribute objectForKey:attributeName] doubleValue];
}


-(NSArray *) attributes
{
    return [self.strengthByAttribute allKeys];
}

@end
