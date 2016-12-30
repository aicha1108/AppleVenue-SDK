//
//  ViewController.m
//  AppleVenueiOS
//
//  Created by Hadassah on 12/14/16.
//  Copyright © 2016 Aiza Simbra. All rights reserved.
//

#import "ViewController.h"
@import MapKit;


#define METERS_PER_MILE 1609.344

@interface ViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadMap];
    [self drawRoute];
}

#pragma mark - Map
- (void)loadMap{
   
    self.mapView.pitchEnabled = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 44.854865;//39.281516;
    zoomLocation.longitude= -93.242233;//-76.580806;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500, 500);
    [self.mapView setRegion:viewRegion animated:YES];
    
    MKMapCamera *newCamera = [[self.mapView camera] copy];
    [newCamera setPitch:45];
    [newCamera setHeading:0];
    [newCamera setAltitude:300];
    [self.mapView setCamera:newCamera animated:YES];
    
    MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
    marker.coordinate = CLLocationCoordinate2DMake(44.854865, -93.242233);
    marker.title = @"MOA";
    marker.subtitle = @"Mall of America";
    [self.mapView addAnnotation:marker];
    
}

- (void)drawRoute{
    
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]
                                                             pathForResource:@"path" ofType:@"plist"]];
    
    NSUInteger pointsCount = pointsArray.count;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for (NSInteger index = 0; index < pointsCount; index++) {
        CGPoint p = CGPointFromString(pointsArray[index]);
        
        CLLocationDegrees lat = p.x;
        CLLocationDegrees lng = p.y;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
        pointsToUse[index] = coordinate;
        
    }
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    [self.mapView addOverlay:polyLine];
    
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString *identifier = @"location";
    MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"moa.png"];
    } else {
        annotationView.annotation = annotation;
    }
        
    return annotationView;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView
           rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 1.5;
    
    return renderer;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
