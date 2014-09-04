//
//  LocationController.m
//  Here
//
//  Created by Noah Portes Chaikin on 9/4/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "LocationController.h"

NSString * const LocationControllerDidUpdateLocationNotification = @"LocationControllerDidUpdateLocationNotification";

static LocationController *sharedController;

@interface LocationController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationController

+ (LocationController *)sharedController {
    if (!sharedController) {
        sharedController = [[self alloc] init];
    }
    return sharedController;
}

+ (CLLocationManager *)sharedManager {
    return [[self sharedController] locationManager];
}

- (id)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationControllerDidUpdateLocationNotification
                                                        object:nil];
}

@end
