//
//  XRMapView.m
//  DraggableMap
//
//  Created by Xinrui Gao on 03/12/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import "XRMapView.h"

@implementation XRMapView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//  NSLog(@"touch began");
////  UITouch *touch = [touches anyObject];
////  CGPoint touchPoint = [touch locationInView:self];
////  if (CGRectContainsPoint(self.frame, touchPoint)) {
////    [self animateFirstTouchAtPoint:touchPoint];
////  }else{
////    [self.delegate touchAtBlankArea];
////  }
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"touch moved");
////	UITouch *touch = [touches anyObject];
////  if ([touch view] == _pin) {
////		CGPoint location = [touch locationInView:self];
////		_pin.center = location;
////		return;
////	}
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"touch ended");
////	UITouch *touch = [touches anyObject];
////  if ([touch view] == _pin) {
////    _pin.center = self.center;
////    _pin.transform = CGAffineTransformIdentity;
////		return;
////	}
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//  NSLog(@"touch cancelled");
////	_pin.center = self.center;
////	_pin.transform = CGAffineTransformIdentity;
//}


@end
