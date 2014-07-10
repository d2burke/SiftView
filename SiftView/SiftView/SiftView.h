//
//  SiftView.h
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiftCardView.h"

extern NSString * const SiftViewStateChangeNotification;

typedef enum{
    SiftViewStateBeganSiftLeft,
    SiftViewStateBeganSiftRight,
    SiftViewStateCompletedSiftLeft,
    SiftViewStateCompletedSiftRight,
    SiftViewStateCancelled
} SiftViewState;

typedef enum{
    SwipeDirectionLeft,
    SwipeDirectionRight
} SwipeDirection;

typedef enum{
    SiftCardScaleSecond = 1,
    SiftCardScaleThird = 2,
    SiftCardScaleFourth = 3
} SiftcardScale;

@protocol SiftViewDelegate <NSObject>

-(void)didSwipeLeft;
-(void)didSwipeRight;
-(void)didSiftAllCards;

@end

@interface SiftView : UIView

@property (strong, nonatomic) id <SiftViewDelegate> delegate;
@property (nonatomic) SwipeDirection swipeDirection;
@property (nonatomic) SiftViewState siftViewState;
@property (nonatomic) CGFloat viewWidth;
@property (nonatomic) CGFloat viewHeight;

@property (strong, nonatomic) NSMutableArray *siftViewData;
@property (strong, nonatomic) NSMutableArray *siftViewCards;
@property (strong, nonatomic) SiftCardView *lastSiftCard;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

-(id)initWithFrame:(CGRect)frame data:(NSArray*)data;
-(id)initWithFrame:(CGRect)frame cards:(NSArray*)cards;
-(void)swipeLeft;
-(void)swipeRight;
-(void)undoLastSift;
-(void)reloadData;

@end
