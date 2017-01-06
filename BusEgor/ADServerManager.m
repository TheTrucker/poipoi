//
//  ADServerManager.m
//  BusEgor
//
//  Created by Александр Дудырев on 05.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import "ADServerManager.h"

NSString* bodyString = @"http://map.gortransperm.ru/json/";


@interface ADServerManager ()

@property (strong, nonatomic) NSMutableArray* tempArray;

@end

static NSString* requestString = @"get-moving-autos/";

@implementation ADServerManager

+ (ADServerManager*) sharedManager {
    
    static ADServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ADServerManager alloc] init];
        manager.arrayForGETRequest = [NSMutableArray array];
        manager.tempArray = [NSMutableArray array];
        manager.resultArray = [NSArray array];
    });
 
    return manager;
    
}

- (void) getAllBusWithBlock:(void (^)(NSArray* successArray)) success {

    [self.tempArray removeAllObjects];

    double btime = CFAbsoluteTimeGetCurrent();
    
    NSString* appendingString = [bodyString stringByAppendingString:requestString];
    NSString* parameters = nil;
    
    for (int i = 0; i < countRouteID; i++) {
        
        NSString* GETString = [NSString stringWithFormat:@"%@-%@-", appendingString, routeIDArray[i]];
        
        [[AFHTTPSessionManager manager] GET:GETString
                                 parameters:parameters
                                   progress:nil
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                                        NSArray* array = [responseObject objectForKey:@"autos"];
                                        NSMutableArray* mArrayWithBus = [NSMutableArray array];
                                        
                                        for (NSDictionary* dict in array) {
                                            ADBus* bus = [ADBus initWithDictionary:dict];
                                            [mArrayWithBus addObject:bus];
                                        }
                                        ADTempArray* tArray = [[ADTempArray alloc] initWithArray:mArrayWithBus];
                                        tArray.nameArray = routeIDArray[i];
                                        [self.tempArray addObject:tArray];
                                        
                                        if ([self.tempArray count] == countRouteID) {
                                            
                                            NSLog(@"%.3f", CFAbsoluteTimeGetCurrent() - btime);
                                            
                                            self.resultArray =
                                            [self.tempArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2){
                                                return [[obj1 nameArray] compare:[obj2 nameArray]];
                                            }];
                                            
                                            if (success) {
                                                success(self.resultArray);
                                            }
                                            return;
                                        }
                                    }
                                    failure:nil];
    }
}

- (void) getBusForCurrentsBusWithBlock:(void(^)(NSArray* successArray)) success {
    
    NSString* appendingString = [bodyString stringByAppendingString:requestString];
    NSString* parameters = nil;
    
    NSArray* array = [NSArray arrayWithArray:self.arrayForGETRequest];
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[obj1 routeID] compare:[obj2 routeID]];
    }];
    
    NSMutableArray* mArray = [NSMutableArray array];
    for (ADBus* bus1 in array) {
        if (![mArray count]) {
            [mArray addObject:bus1.routeID];
            continue;
        }
        NSString* stringBus2 = [mArray lastObject];
        if ([bus1.routeID isEqualToString:stringBus2]) {
            continue;
        } else {
            [mArray addObject:bus1.routeID];
        }
    }
    
    __block int count = 0;
    
    for (NSString* string in mArray) {
        
        NSString* GETString = [NSString stringWithFormat:@"%@-%@-", appendingString, string];
        
        [[AFHTTPSessionManager manager] GET:GETString
                                 parameters:parameters
                                   progress:nil
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                        NSArray* responseArray = [responseObject objectForKey:@"autos"];
                                        for (NSDictionary* dict in responseArray) {
                                            for (ADBus* bus in self.arrayForGETRequest) {
                                                NSString* responseGosNom = [dict objectForKey:@"gosNom"];
                                                if ([bus.gosNom isEqualToString:responseGosNom]) {
                                                    [bus changeValueFromDictionaty:dict];
                                                }
                                            }
                                        }
                                        count++;
                                        if (count == [mArray count]) {
                                            if (success) {
                                                NSArray* successArray = [NSArray arrayWithArray:self.arrayForGETRequest];
                                                success(successArray);
                                            }
                                        }
        }
                                    failure:nil];
    }
    
}

- (void) getBusWithRouteID:(NSString* )routeID withBlock:(void (^) (ADTempArray* successArray)) success {
    
    NSString* appendingString = [bodyString stringByAppendingString:requestString];
    appendingString = [NSString stringWithFormat:@"%@-%@-", appendingString, routeID];

    NSString* parameters = nil;
    
    [[AFHTTPSessionManager manager] GET:appendingString
                             parameters:parameters
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    
                                    NSArray* array = [responseObject objectForKey:@"autos"];
                                    NSMutableArray* mArrayWithBus = [NSMutableArray array];
                                    
                                    for (NSDictionary* dict in array) {
                                        ADBus* bus = [ADBus initWithDictionary:dict];
                                        [mArrayWithBus addObject:bus];
                                    }
                                    if (success) {
                                        ADTempArray* tempArray = [[ADTempArray alloc] initWithArray:mArrayWithBus];
                                        tempArray.nameArray = routeID;
                                        success(tempArray);
                                        return;
                                    }
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                }];
}


- (void) getTen {
    
    NSString* appendingString = [bodyString stringByAppendingString:requestString];
    
    NSString* parameters = nil;
    
    [[AFHTTPSessionManager manager] GET:appendingString
                             parameters:parameters
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    
                                    NSLog(@"%@", responseObject);
                                    
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                }];
    
    
    
    
    
}



@end
