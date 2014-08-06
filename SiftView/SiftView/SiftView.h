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

@interface SiftView : UIView

<
UIGestureRecognizerDelegate
>

@property (strong, nonatomic) id <SiftViewDelegate> delegate;
@property (nonatomic) SwipeDirection swipeDirection;
@property (nonatomic) SiftViewState siftViewState;
@property (nonatomic) CGRect siftViewFrame;
@property (nonatomic) CGFloat viewWidth;
@property (nonatomic) CGFloat viewHeight;
@property (nonatomic) CGFloat cardWidth;
@property (nonatomic) CGFloat cardHeight;
@property (nonatomic) CGPoint cardCenter;
@property (nonatomic) CGPoint originalCardCenter;
@property (nonatomic) CGFloat swipeActionThreshold;
@property (nonatomic) int cardDisplayCount;
@property (nonatomic) BOOL currentlyShiftingCards;
@property (nonatomic) BOOL allowsVerticalPanning;
@property (nonatomic) BOOL shiftSecondaryCards;
@property (strong, nonatomic) NSMutableArray *siftViewData;
@property (strong, nonatomic) NSMutableArray *displaySetData;
@property (strong, nonatomic) NSMutableArray *siftViewCards;
@property (strong, nonatomic) NSMutableArray *displaySetCards;

@property (strong, nonatomic) UIView *cardContainer;
@property (strong, nonatomic) UIImage *placeholder;
@property (strong, nonatomic) UIButton *leftActionButton;
@property (strong, nonatomic) UIButton *rightActionButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) SiftCardView *lastSiftCard;
@property (strong, nonatomic) SiftCardView *currentSiftCard;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

-(id)initWithFrame:(CGRect)frame data:(NSArray*)data;
-(id)initWithFrame:(CGRect)frame cards:(NSArray*)cards;
- (void)swipe:(SiftCardView*)card inDirection:(SwipeDirection)direction;
- (void)undoLastSift;
- (void)reloadData;
- (void)setCards:(SiftCardsVisibility)visibility;


@end
