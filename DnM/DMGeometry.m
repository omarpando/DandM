//
//  DMGeometry.m
//  DnM
//
//  Created by Omar Alvarez on 7/12/13.
//  Copyright (c) 2013 Omar Alvarez. All rights reserved.
//

#import "DMGeometry.h"

@implementation DMGeometry


DMCircle CircleMake(CGPoint c, double r){
    DMCircle circle;
    circle.center = c;
    circle.radius = r;
    return circle;
    
}


double distance(CGPoint a, CGPoint b)
{
    return sqrt( pow(a.x - b.x, 2.0) + pow(a.y - b.y, 2) );
}


#define spaceBetweenCircles 0.0
BOOL checkCollisionBetweenCircles(DMCircle a, DMCircle b)
{
    double minDistance = a.radius + b.radius + spaceBetweenCircles;
    double currentDistance = distance(a.center, b.center);
    return currentDistance < minDistance;
}

@end
