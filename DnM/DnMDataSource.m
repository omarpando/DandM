//
//  DnMDataSource.m
//  DnM
//
//  Created by Omar Alvarez on 7/19/13.
//  Copyright (c) 2013 Omar Alvarez. All rights reserved.
//

#import "DnMDataSource.h"

@implementation DnMDataSource


-(void)test
{
    NSStringEncoding encoding;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"js"];
    NSError* error;
    NSString* jSONString = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:&error];
    
    NSArray *cereals = [NSJSONSerialization JSONObjectWithData:[jSONString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    [cereals enumerateObjectsUsingBlock:^(NSDictionary *cereal, NSUInteger cerealIdx, BOOL *stop) {
        NSLog(@"cereal name: %@", [cereal objectForKey:@"name"]);
        NSString *carbs = [cereal objectForKey:@"carbs"];
        NSNumber *n = [NSNumber numberWithDouble:[carbs doubleValue]];
        
        NSLog(@"Carbs: %f", n.doubleValue);
        
    }];
        
          
}

@end
