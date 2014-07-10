//
//  SiftView.m
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import "SiftView.h"
#import "SiftCardView.h"

NSString * const SiftViewStateChangeNotification = @"SiftViewStateChangeNotification";

@implementation SiftView

-(id)initWithFrame:(CGRect)frame data:(NSArray*)data{
    self = [super initWithFrame:frame];
    return self;
}
-(id)initWithFrame:(CGRect)frame cards:(NSArray*)cards{
    self = [super initWithFrame:frame];
    return self;
}


-(void)swipeLeft:(SiftCardView*)card{
    _siftViewState = SiftViewStateBeganSiftLeft;
    [self animate:card inDirection:SwipeDirectionLeft];
}

-(void)swipedLeft{
    _siftViewState = SiftViewStateCompletedSiftLeft;
    [_delegate didSwipeLeft];
}

-(void)animate:(SiftCardView*)card inDirection:(SwipeDirection)direction{
    CGRect cardFrame = card.frame;
    switch(direction){
        case SwipeDirectionLeft:{
            cardFrame.origin.x = -(_viewWidth + cardFrame.size.width);
            break;
        }
        case SwipeDirectionRight:{
            cardFrame.origin.x = _viewWidth;
            break;
        }
        default:
            break;
    }
    
    //Shuffle cards forward
    
    [UIView animateWithDuration:0.34 animations:^{
        card.frame = cardFrame;
    } completion:^(BOOL finished) {
        _lastSiftCard = card;
        
        switch (direction) {
            case SwipeDirectionLeft:{
                [self swipedLeft];
                break;
            }
            case SwipeDirectionRight:{
                [self swipedRight];
                break;
            }
            default:
            break;
        }
    }];
}

-(void)swipeRight:(SiftCardView*)card{
    _siftViewState = SiftViewStateBeganSiftRight;
    [self animate:card inDirection:SwipeDirectionRight];
}

-(void)swipedRight{
    _siftViewState = SiftViewStateCompletedSiftRight;
    [_delegate didSwipeRight];
}

-(void)shuffleCardsForward{
    for(SiftCardView *card in _siftViewCards){
        int cardIndex = [_siftViewCards indexOfObject:card];
        if(cardIndex > 2) break;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat scale = 1 - (cardIndex * 0.01);
            CGFloat cardAlpha = 1 - (cardIndex * 0.2);
            card.alpha = cardAlpha;
            card.transform = CGAffineTransformMakeScale(scale, scale);
        } completion:^(BOOL finished) {
            //
        }];
    }
}

-(void)undoLastSift{
    //animate _lastSiftCard back into view
    //add the object to the array
}

-(void)reachedEndOfData{
    //Send reference to the top SiftCardView
    [[NSNotificationCenter defaultCenter] postNotificationName:SiftViewStateChangeNotification
                                                        object:self
                                                      userInfo:nil];
}

-(void)reloadData{
    //Remove old cards
    //Loop over sift cards and add them in order
    //Animate them into place
}

@end
