//
//  ParticleModel.h
//  DnM
//


#import <Foundation/Foundation.h>

@interface ParticleModel : NSObject

@property(nonatomic, retain)           NSString *name;
@property(nonatomic, retain)  NSMutableDictionary *strengthByAttribute;
@property(nonatomic, readonly)         NSArray *attributes;
@property(nonatomic, assign) double scaleFactor;
@property(nonatomic, assign)           BOOL enabled;


-(ParticleModel *)initWithName:(NSString *)inName strengthByAttribute:(NSMutableDictionary *)inStrengthByAttribute;
-(void)addStrenght:(double)strength forAttribute:(NSString *)attr;


-(double)strengthForAttribute:(NSString *)attributeName;




+(ParticleModel *)particleModelWithName:(NSString *) inName strengthByAttribute: (NSMutableDictionary *) inStrengthByAttribute;
+(ParticleModel *)particleModelWithName:(NSString *)inName  attribute:(NSString *)attr strength:(double) stre;
@end
