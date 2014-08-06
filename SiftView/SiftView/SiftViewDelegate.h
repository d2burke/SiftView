//
//  SiftViewDelegate.h
//  SiftView
//
//  Created by Daniel.Burke on 7/12/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    SiftViewStateBeganSiftLeft,
    SiftViewStateBeganSiftRight,
    SiftViewStateCompletedSiftLeft,
    SiftViewStateCompletedSiftRight,
    SiftViewStateCancelled
} SiftViewState;

typedef enum{
    SwipeDirectionLeft,
    SwipeDirectionRight,
    SwipeDirectionCenter
} SwipeDirection;

typedef enum{
    SiftCardScaleSecond = 1,
    SiftCardScaleThird = 2,
    SiftCardScaleFourth = 3
} SiftCardScale;

typedef enum{
    SiftCardsHidden,
    SiftCardsVisible
} SiftCardsVisibility;

@class SiftView;

@protocol SiftViewDelegate <NSObject>

@required

- (SiftCardView *)siftView:(SiftView*)siftView cardAtIndex:(int)cardIndex;

- (void)didSwipeCard:(SiftCardView*)card inDirection:(SwipeDirection)direction;
- (void)didUpdateNumberOfCards:(int)cards;
- (void)didSiftAllCards;
- (void)siftView:(SiftView*)siftView didSwipe:(CGFloat)offset;
- (void)siftView:(SiftView*)siftView didSelectCard:(SiftCardView*)card;

@end
