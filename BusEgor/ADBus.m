//
//  ADBus.m
//  BusEgor
//
//  Created by Александр Дудырев on 05.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import "ADBus.h"


@interface ADBus () 

@end

@implementation ADBus

+ (ADBus*) initWithDictionary:(NSDictionary*) dictionary {
    
    ADBus* bus = [[ADBus alloc] init];
    
    bus.kodPe = [[dictionary objectForKey:@"kodPe"] integerValue];
    bus.routeID = [dictionary objectForKey:@"routeId"];
    bus.coordinatesE = [[dictionary objectForKey:@"e"] doubleValue];
    bus.coordinatesN = [[dictionary objectForKey:@"n"] doubleValue];
    bus.gosNom = [dictionary objectForKey:@"gosNom"];

    
#pragma mark - MKAnnotation
    
    bus.coordinate = CLLocationCoordinate2DMake(bus.coordinatesN, bus.coordinatesE);
    bus.title = bus.gosNom;
    bus.subtitle = bus.routeID;
    
    return bus;
}

- (BOOL) busContainString:(NSString*) string {
    
    if ([self.gosNom containsString:string] || [self.routeID containsString:string]) {
        return YES;
    }
    return NO;
}

- (void) changeValueFromDictionaty:(NSDictionary*) dictionary {
    
    self.kodPe = [[dictionary objectForKey:@"kodPe"] integerValue];
    self.routeID = [dictionary objectForKey:@"routeId"];
    self.coordinatesE = [[dictionary objectForKey:@"e"] doubleValue];
    self.coordinatesN = [[dictionary objectForKey:@"n"] doubleValue];
    
    self.coordinate = CLLocationCoordinate2DMake(self.coordinatesN, self.coordinatesE);
    self.subtitle = self.routeID;
}


@end
