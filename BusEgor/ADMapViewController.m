//
//  ADMapViewController.m
//  BusEgor
//
//  Created by Александр Дудырев on 05.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import "ADMapViewController.h"
#import "ADServerManager.h"

@interface ADMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) NSArray* arrayWithCurrentsBus;
@property (strong, nonatomic) NSTimer* timer;

@end

double permX = 58.013889;
double permY = 56.248889;
double permDelta = 5000.f;

@implementation ADMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void) viewWillAppear:(BOOL)animated {
    
    NSMutableArray* array = [[ADServerManager sharedManager] arrayForGETRequest];
    self.arrayWithCurrentsBus = [NSArray arrayWithArray:array];
    
    [self.mapView addAnnotations:self.arrayWithCurrentsBus];
    
    [self setRectForMap];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        NSLog(@"map timer");
        [[ADServerManager sharedManager] getBusForCurrentsBusWithBlock:^(NSArray *successArray) {
            
            [self.mapView removeAnnotations:self.arrayWithCurrentsBus];
            self.arrayWithCurrentsBus = successArray;
            [self.mapView addAnnotations:self.arrayWithCurrentsBus];

        }];
    }];
}

- (void) viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void) dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - PrivateMethod

- (void) setRectForMap {
    
    if (![self.arrayWithCurrentsBus count]) {
        return;
    }
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (ADBus<MKAnnotation>* bus in self.arrayWithCurrentsBus) {
        
        MKMapPoint center = MKMapPointForCoordinate(bus.coordinate);
        MKMapRect mapRect = MKMapRectMake(center.x - permDelta, center.y - permDelta, permDelta * 2, permDelta * 2);
        zoomRect = MKMapRectUnion(zoomRect, mapRect);
    }
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

#pragma mark - Action

- (IBAction)zoom:(UIButton *)sender {
    
    [self setRectForMap];
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString* identifier = @"bus";
    
    MKAnnotationView* aView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!aView) {
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        aView.draggable = NO;
        aView.canShowCallout = YES;
        aView.image = [UIImage imageNamed:@"front-bus"];
        aView.annotation = annotation;
    } else {
        aView.annotation = annotation;
    }

    return aView;
}



@end
