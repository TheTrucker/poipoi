//
//  ADServerManager.h
//  BusEgor
//
//  Created by Александр Дудырев on 05.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ADBus.h"
#import "ADTempArray.h"



#define countRouteID 61

static NSString* routeIDArray[countRouteID] = { @"01",@"03",@"04",@"05",@"06",@"07",
    @"08",@"10",@"12",@"13",@"14",@"15",
    @"16",@"17",@"18",@"19",@"20",@"21",
    @"22",@"24",@"25",@"26",@"27",@"32",
    @"33",@"34",@"35",@"36",@"37",@"38",
    @"39",@"40",@"41",@"42",@"43",@"44",
    @"47",@"48",@"49",@"52",@"53",@"54",
    @"56",@"58",@"59",@"60",@"61",@"62",
    @"63",@"64",@"65",@"66",@"67",@"68",
    @"71",@"73",@"74",@"75",@"77",@"78",@"80"};

@interface ADServerManager : NSObject

@property (strong, nonatomic) NSArray* resultArray;
@property (strong, nonatomic) NSMutableArray* arrayForGETRequest;

+ (ADServerManager*) sharedManager;

- (void) getAllBusWithBlock:(void (^)(NSArray* successArray)) success;
- (void) getBusWithRouteID:(NSString* )routeID withBlock:(void (^) (ADTempArray* successArray)) success;
- (void) getBusForCurrentsBusWithBlock:(void(^)(NSArray* successArray)) success;

- (void) getTen;

@end
