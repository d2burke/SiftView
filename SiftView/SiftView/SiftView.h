//
//  SiftView.h
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiftCardView.h"
#import "SiftViewDelegate.h"

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
} SiftCardScale;

@interface SiftView : UIView

<
UIGestureRecognizerDelegate
>

@property (strong, nonatomic) id <SiftViewDelegate> delegate;
@property (nonatomic) SwipeDirection swipeDirection;
@property (nonatomic) SiftViewState siftViewState;
@property (nonatomic) CGFloat viewWidth;
@property (nonatomic) CGFloat viewHeight;
@property (nonatomic) CGFloat cardWidth;
@property (nonatomic) CGFloat cardHeight;
@property (nonatomic) CGPoint cardCenter;
@property (nonatomic) CGPoint originalCardCenter;
@property (nonatomic) int cardDisplayCount;
@property (strong, nonatomic) NSMutableArray *siftViewData;
@property (strong, nonatomic) NSMutableArray *siftViewCards;

@property (strong, nonatomic) UIImage *placeholder;
@property (strong, nonatomic) UIButton *leftActionButton;
@property (strong, nonatomic) UIButton *rightActionButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) SiftCardView *lastSiftCard;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

-(id)initWithFrame:(CGRect)frame data:(NSArray*)data;
-(id)initWithFrame:(CGRect)frame cards:(NSArray*)cards;
-(void)swipeLeft:(SiftCardView*)card;
-(void)swipeRight:(SiftCardView*)card;
-(void)undoLastSift;
-(void)reloadData;

@end
