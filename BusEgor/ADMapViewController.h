//
//  ADMapViewController.h
//  BusEgor
//
//  Created by Александр Дудырев on 05.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class ADBus;

@interface ADMapViewController : UIViewController



@property (strong, nonatomic) NSArray* arrayWithOneRouteID;
@property (strong, nonatomic) ADBus* bus;
@property (strong, nonatomic) NSString* routeID;

@property (weak, nonatomic) IBOutlet MKMapView* mapView;
- (IBAction)zoom:(UIButton *)sender;



@end
