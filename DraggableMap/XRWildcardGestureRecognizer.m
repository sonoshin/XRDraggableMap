//
//  XRWildcardGestureRecognizer.m
//  DraggableMap
//
//  Created by Xinrui Gao on 03/12/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import "XRWildcardGestureRecognizer.h"

@implementation XRWildcardGestureRecognizer
@synthesize touchesBeganCallback, touchesMovedCallback, touchesEndedCallback, touchesCancelledCallback;

-(id) init{
  if (self = [super init])
  {
    self.cancelsTouchesInView = NO;
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//   NSLog(@"Touch began");
  if (touchesBeganCallback) {
    touchesBeganCallback(touches, event);
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//   NSLog(@"Touch cancelled");
  if (touchesCancelledCallback) {
    touchesCancelledCallback(touches, event);
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//   NSLog(@"Touch ended");
  if (touchesEndedCallback) {
    touchesEndedCallback(touches, event);
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//   NSLog(@"Touch moved");
  if (touchesMovedCallback) {
    touchesMovedCallback(touches, event);
  }
}

- (void)reset
{
}

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event
{
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
  return NO;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
  return NO;
}

@end
