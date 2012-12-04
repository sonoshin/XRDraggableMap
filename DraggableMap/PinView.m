//
//  PinView.h
//  DraggableMap
//
//  Created by Xinrui Gao on 21/11/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PinView.h"

@interface PinView ()

@property (strong, nonatomic) UIImageView *pin;

@end

@implementation PinView

- (id)initWithCoder:(NSCoder *)coder {
	
	self = [super initWithCoder:coder];
	if (self) {

	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {

	}
	return self;
}

- (void)setUpPinView {
  _pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MapPin"]];
  _pin.contentMode = UIViewContentModeCenter;
//	_pin.center = _centerPoint;
  _pin.userInteractionEnabled = YES;
  CGAffineTransform transform = CGAffineTransformMakeScale(1.1f, 1.1f);
  _pin.transform = transform;
	[self addSubview:_pin];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self];
  if (CGRectContainsPoint(_pin.frame, touchPoint)) {
    [self animateFirstTouchAtPoint:touchPoint];
  }else{
    [self.delegate touchAtBlankArea];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
  if ([touch view] == _pin) {
		CGPoint location = [touch locationInView:self];
		_pin.center = location;
		return;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
  if ([touch view] == _pin) {
    _pin.center = _centerPoint;
    _pin.transform = CGAffineTransformIdentity;
		return;
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	_pin.center = _centerPoint;
	_pin.transform = CGAffineTransformIdentity;
}

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
  [UIView animateWithDuration:0.15 animations:^{
    CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    _pin.transform = transform;
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.15 animations:^{
      _pin.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    } completion:^(BOOL finished) {
      _pin.center = touchPoint;
    }];
  }];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	_pin.transform = CGAffineTransformIdentity;
	self.userInteractionEnabled = YES;
}

@end
