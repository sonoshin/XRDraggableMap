//
//  PinView.h
//  DraggableMap
//
//  Created by Xinrui Gao on 21/11/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PinViewDelegate <NSObject>

- (void)touchAtBlankArea;

@end

@interface PinView : UIView

@property (nonatomic) id <PinViewDelegate> delegate;
@property (nonatomic) CGPoint centerPoint;

- (void)setUpPinView;

@end
