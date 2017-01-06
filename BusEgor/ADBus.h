//
//  ADBus.h
//  BusEgor
//
//  Created by Александр Дудырев on 05.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface ADBus : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString* routeID;
@property (assign, nonatomic) NSInteger kodPe;
@property (assign, nonatomic) double coordinatesN;
@property (assign, nonatomic) double coordinatesE;
@property (strong, nonatomic) NSString* gosNom;

+ (ADBus*) initWithDictionary:(NSDictionary*) dictionary;
- (BOOL) busContainString:(NSString*) string;
- (void) changeValueFromDictionaty:(NSDictionary*) dictionary;


#pragma mark - MKAnnotation

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


@end
