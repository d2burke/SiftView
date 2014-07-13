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

@implementation SiftView{
    
}

-(id)initWithFrame:(CGRect)frame data:(NSArray*)data{
    self = [super initWithFrame:frame];
    _siftViewData = [[[data reverseObjectEnumerator] allObjects] mutableCopy];
    _viewWidth = frame.size.width;
    _viewHeight = frame.size.height;
    _cardWidth = 300;
    _cardHeight = _cardWidth;
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCard:)];
    _panGesture.delegate = self;
    [self addGestureRecognizer:_panGesture];
    
    for(NSDictionary *cardData in _siftViewData){
        SiftCardView *card = [[SiftCardView alloc] initWithFrame:CGRectMake(_viewWidth/2 - _cardWidth/2, 84, _cardWidth, _cardHeight)];
        card.tag = [_siftViewData count] - ([data indexOfObject:cardData] + 1);
        card.titleLabel.text = [cardData objectForKey:@"title"];
        card.subtitleLabel.text = [cardData objectForKey:@"subtitle"];
        card.imageView.image = [UIImage imageNamed:[cardData objectForKey:@"imageName"]];
        [self addSubview:card];
        
        CGRect shiftFrame = card.frame;
        switch (card.tag) {
            case 0:{
                NSLog(@"Last, %@", card.titleLabel.text);
                break;
            }
            case 1:{
                NSLog(@"Second to last");
                card.transform = CGAffineTransformMakeScale(0.9, 0.9);
                shiftFrame.origin.y += 5;
                card.frame = shiftFrame;
                card.alpha = 0.8;
                break;
            }
            case 2:{
                NSLog(@"Third to last");
                card.transform = CGAffineTransformMakeScale(0.8, 0.8);
                shiftFrame.origin.y += 10;
                card.frame = shiftFrame;
                card.alpha = 0.8;
                break;
            }
            default:{
                NSLog(@"Card Index: %i", card.tag);
                break;
            }
        }
    }
    
    return self;
}
-(id)initWithFrame:(CGRect)frame cards:(NSArray*)cards{
    self = [super initWithFrame:frame];
    for(SiftCardView *card in cards){
        card.tag = [cards indexOfObject:card];
        [self addSubview:card];
    }
    return self;
}

-(void)swipeCard:(UIPanGestureRecognizer*)recognizer{
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            break;
        }
        case UIGestureRecognizerStateChanged:{
            break;
        }
        default:
            break;
    }
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
    for(SiftCardView *card in self.subviews){
        [card removeFromSuperview];
    }
    
    //Loop over sift cards and add them in order
    for(NSDictionary *cardData in _siftViewData){
        SiftCardView *card = [[SiftCardView alloc] initWithFrame:CGRectMake(_viewWidth/2 - _cardWidth/2, 84, _cardWidth, _cardHeight)];
        card.tag = [_siftViewData indexOfObject:cardData];
        card.titleLabel.text = [cardData objectForKey:@"title"];
        card.subtitleLabel.text = [cardData objectForKey:@"subtitle"];
        card.imageView.image = [UIImage imageNamed:[cardData objectForKey:@"imageName"]];
        [self addSubview:card];
        NSLog(@"Added card: %@", cardData);
    }
    //Animate them into place
    
}

@end
