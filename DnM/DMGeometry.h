//
//  DMGeometry.h
//  DnM
//
//  Created by Omar Alvarez on 7/12/13.
//  Copyright (c) 2013 Omar Alvarez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMGeometry : NSObject

typedef struct {
    CGPoint center;
    double radius;
}DMCircle;



DMCircle CircleMake(CGPoint center, double r);


BOOL checkCollisionBetweenCircles(DMCircle a, DMCircle b);
double distance(CGPoint a, CGPoint b);

@end
