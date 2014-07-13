//
//  SiftViewDelegate.h
//  SiftView
//
//  Created by Daniel.Burke on 7/12/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SiftViewDelegate <NSObject>

-(void)didSwipeLeft;
-(void)didSwipeRight;
-(void)didSiftAllCards;

@end
