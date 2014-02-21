//
//  CEMotionEnhancements.m
//  Maze
//
//  Created by Colin Eberhardt on 18/02/2014.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "CEMotionEnhancements.h"
#import "CESwizzleUtils.h"
#import "CMMotionManager+Enhancements.h"
#import "NSDictionary+Helpers.h"
#import "CMAccelerometerData+Enhancements.h"

@implementation CEMotionEnhancements {
  NSMutableArray *_motionManagers;
}

- (void)receiveSimulatorData:(NSDictionary *)jsonData {
  CMAcceleration acc;
  acc.x = [[jsonData objectForKey:@"x"] doubleValue];
  acc.y = [[jsonData objectForKey:@"y"] doubleValue];
  acc.z = [[jsonData objectForKey:@"z"] doubleValue];
  
  CMAccelerometerData *data = [[CMAccelerometerData alloc] init];
  [data dummySetAcceleration:acc];
  
  for (CMMotionManager *motionManager in _motionManagers) {
    [motionManager simx_accelerometerUpdate:data];
  }
}

- (void)enable {
  [CESwizzleUtils swizzleClass:[CMMotionManager class]
                        method:@"startAccelerometerUpdatesToQueue:withHandler:"];
  
  [CESwizzleUtils swizzleClass:[CMAccelerometerData class]
                        method:@"acceleration"];
}

- (void)addMotionManager:(CMMotionManager *)manager {
  [_motionManagers addObject:manager];
}

+ (CEMotionEnhancements *)instance {
  static CEMotionEnhancements *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [CEMotionEnhancements new];
  });
  return instance;
}

@end
