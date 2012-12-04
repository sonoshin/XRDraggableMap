//
//  ViewController.m
//  DraggableMap
//
//  Created by Xinrui Gao on 21/11/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "XRWildcardGestureRecognizer.h"

#define METERS_PER_MILE       1609.344
#define kReceptionZoneOffset  50.0

@interface ViewController () <UIGestureRecognizerDelegate>
{
  BOOL shouldAccumulate;    //only accumulate once for one drag.
  BOOL isTouchOnAnnotation; //only count when the moved touch is on annotation view.
}

@property (strong, nonatomic) UIImageView *pinView;
@property (strong, nonatomic) MKAnnotationView *touchedView;
@property (nonatomic) CGPoint touchOffset;
@property (nonatomic) CGPoint touchPoint;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self addObserver:self forKeyPath:@"movedPoint" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
  _countLabel.text = @"0";
  shouldAccumulate = YES;
  isTouchOnAnnotation = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == self && [keyPath isEqualToString:@"movedPoint"]) {
    CGPoint newPoint = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
    [self updateAnnotationPositionTo:newPoint];
    if (newPoint.y >= self.view.frame.size.height - kReceptionZoneOffset) {
      if (shouldAccumulate && isTouchOnAnnotation) {
        _countLabel.text = [NSString stringWithFormat:@"%d", _countLabel.text.integerValue + 1];
        shouldAccumulate = NO;
        isTouchOnAnnotation = NO;
      }
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [self setMapView:nil];
  [self setPinView:nil];
  [self setCountLabel:nil];
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  CLLocationCoordinate2D zoomLocation;
  zoomLocation.latitude = 45.070444;
  zoomLocation.longitude = 7.645944;
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
  [_mapView setRegion:adjustedRegion animated:YES];
//  _mapView.showsUserLocation = YES;
  [_mapView addAnnotations:[self annotations]];
  
  XRWildcardGestureRecognizer * tapInterceptor = [[XRWildcardGestureRecognizer alloc] init];
  tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView:self.view.window];
    NSLog(@"Touch began at point: %f, %f", point.x, point.y);
    self.touchPoint = point;
  };
  tapInterceptor.touchesEndedCallback = ^(NSSet * touches, UIEvent * event) {
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView:self.view.window];
    NSLog(@"Touch ended at point: %f, %f", point.x, point.y);
    [self animateTouchEndOnView:_touchedView];
  };
  tapInterceptor.touchesMovedCallback = ^(NSSet * touches, UIEvent * event) {
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView:self.view.window];
    NSLog(@"Touch moved to point: %f, %f", point.x, point.y);
    self.touchPoint = point;
    self.movedPoint = point;
  };
  [_mapView addGestureRecognizer:tapInterceptor];

}

- (void)viewWillDisappear:(BOOL)animated
{
  [_mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO]; //may not be necessary for now
  _mapView.showsUserLocation = NO;
  [super viewWillDisappear:animated];
}

- (void)setOverlayPinView
{
  UIImage *pinImage = [UIImage imageNamed:@"MapPin"];
  _pinView = [[UIImageView alloc] initWithImage:pinImage];
  _touchOffset = [self.view convertPoint:self.touchPoint toView:_touchedView];
  _pinView.frame = CGRectMake(_touchPoint.x - _touchOffset.x, _touchPoint.y - _touchOffset.y, _pinView.frame.size.width, _pinView.frame.size.height);
  [self.view addSubview:_pinView];
}

- (void)removeOverlayPinView
{
  [_pinView removeFromSuperview];
}

- (NSMutableArray *)annotations
{
  NSMutableArray *annotations = @[].mutableCopy;
  for (int i = 0; i < 6 ; i ++) {
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 45.0704 + [self randomBetween:0.001 and:0.01];
    theCoordinate.longitude = 7.6459 + [self randomBetween:0.001 and:0.01];
    MapObject *annotation = [[MapObject alloc] initWithCoordinate:theCoordinate addressDictionary:nil];
    annotation.title = @"Pin";
    annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];

    [annotations addObject:annotation];
  }

  return annotations;
}

- (double)randomBetween:(double)smallNumber and:(double)bigNumber
{
  double diff = bigNumber - smallNumber;
  return (((double) rand() / RAND_MAX) * diff) + smallNumber;
}

#pragma mark - UIGestureRecognizer delegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  //For showing the annotation callout
  return YES;
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
  static NSString *AnnotationIdentifier = @"Annotation";
  if ([annotation isKindOfClass:[MapObject class]]) {
    MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (annotationView == nil) {
      annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
      [annotationView setEnabled:NO]; //here must disable annotation view in order to receive the long press event
      UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAnnotationView:)];
      longPress.minimumPressDuration = 1.0;
      longPress.delegate = self;//For showing the annotation callout
      [annotationView addGestureRecognizer:longPress];
      
//      UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnAnnotationView:)];
//      singleTap.delegate = self;
//      [annotationView addGestureRecognizer:singleTap];
      
    } else {
      annotationView.annotation = annotation;
    }
//    annotationView.draggable = YES;
    
    //For showing the annotation callout
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    annotationView.image = [UIImage imageNamed:@"MapPin"];
    
    // TODO: should set a tag for each annotation and let it be dragged and counted only once.
    
    return annotationView;
  }
  return nil;
}

- (void)longPressAnnotationView:(UILongPressGestureRecognizer*)longPressGestureRecognizer
{
  if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
    NSLog(@"Long press began on annotation view: %@", longPressGestureRecognizer.view);
    _touchedView = (MKAnnotationView *)longPressGestureRecognizer.view;
    [self animateFirstTouchOnView:_touchedView];
  }
}

//- (void)tapOnAnnotationView:(UITapGestureRecognizer*)tapGestureRecognizer
//{
//  //show callout when single tap
//  NSLog(@"Annotation view is tapped");
//  [_mapView selectAnnotation:[(MKAnnotationView*)[tapGestureRecognizer view] annotation] animated:YES];
//}

- (void)animateFirstTouchOnView:(UIView *)annotationView {
  [UIView animateWithDuration:0.15 animations:^{
    CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    annotationView.transform = transform;
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.15 animations:^{
      annotationView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
      annotationView.hidden = YES;
      [self setOverlayPinView];
      isTouchOnAnnotation = YES;
    }];
  }];
}

- (void)animateTouchEndOnView:(UIView *)annotationView {
  [self removeOverlayPinView];
  annotationView.hidden = NO;
  shouldAccumulate = YES;
  isTouchOnAnnotation = NO;
}

- (void)updateAnnotationPositionTo:(CGPoint)newPoint
{
  NSLog(@"Update annotation center position");
  _pinView.frame = CGRectMake(newPoint.x - _touchOffset.x, newPoint.y - _touchOffset.y, _pinView.frame.size.width, _pinView.frame.size.height);
}

@end
