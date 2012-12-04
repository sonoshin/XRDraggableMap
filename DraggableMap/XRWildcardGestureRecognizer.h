//
//  XRWildcardGestureRecognizer.h
//  DraggableMap
//
//  Created by Xinrui Gao on 03/12/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);

@interface XRWildcardGestureRecognizer : UIGestureRecognizer
{
  TouchesEventBlock touchesBeganCallback;
  TouchesEventBlock touchesMovedCallback;
  TouchesEventBlock touchesEndedCallback;
  TouchesEventBlock touchesCancelledCallback;
}

@property(copy) TouchesEventBlock touchesBeganCallback, touchesMovedCallback, touchesEndedCallback, touchesCancelledCallback;

@end
