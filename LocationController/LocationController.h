//
//  LocationController.h
//  Here
//
//  Created by Noah Portes Chaikin on 9/4/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * const LocationControllerDidUpdateLocationNotification;

@interface LocationController : NSObject

+ (CLLocationManager *)sharedManager;

@end
