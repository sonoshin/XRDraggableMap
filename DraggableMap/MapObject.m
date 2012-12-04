//
//  MapObject.m
//  DraggableMap
//
//  Created by Xinrui Gao on 21/11/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import "MapObject.h"

@implementation MapObject

@synthesize coordinate = coordinate_;
@synthesize title = title_;
@synthesize subtitle = subtitle_;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate addressDictionary:(NSDictionary *)addressDictionary {
	
	if ((self = [super initWithCoordinate:coordinate addressDictionary:addressDictionary])) {
		self.coordinate = coordinate;
	}
	return self;
}

@end
