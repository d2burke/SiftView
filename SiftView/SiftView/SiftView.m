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
    _siftViewCards = [[NSMutableArray alloc] init];
    _siftViewData = [[[data reverseObjectEnumerator] allObjects] mutableCopy];
    _viewWidth = frame.size.width;
    _viewHeight = frame.size.height;
    _cardWidth = 300;
    _cardHeight = _cardWidth;
    _currentlyShiftingCards = NO;
    _swipeActionThreshold = 120;
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCard:)];
    _panGesture.delegate = self;
    [self addGestureRecognizer:_panGesture];
    [self reloadData];
    
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
            _cardCenter = _currentSiftCard.center;
            _originalCardCenter = _currentSiftCard.center;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint touchChange = [recognizer translationInView:_currentSiftCard];
            CGFloat cardCenterY = _cardCenter.y + touchChange.y;
            CGFloat cardCenterX = _cardCenter.x + touchChange.x;
            int offset = (cardCenterX > _viewWidth/2) ? cardCenterX - _viewWidth/2 : -1 * (_viewWidth/2 - cardCenterX);
            _currentSiftCard.center = CGPointMake(cardCenterX, cardCenterY);
            _currentSiftCard.transform = CGAffineTransformMakeRotation(offset/(_viewWidth*2));
            if(fabs(offset) > _swipeActionThreshold/2){
                if(cardCenterX > _viewWidth/2){
                    [self shiftCards:SwipeDirectionRight];
                } else{
                    [self shiftCards:SwipeDirectionLeft];
                }
            }
            else{
                [self shiftCards:SwipeDirectionCenter];
            }
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGPoint touchChange = [recognizer translationInView:_currentSiftCard];
            CGFloat cardCenterX = _cardCenter.x + touchChange.x;
            int offset = (cardCenterX > _viewWidth/2) ? cardCenterX - _viewWidth/2 : -1 * (_viewWidth/2 - cardCenterX);
            SwipeDirection cardDirection;
            if(fabs(offset) > _swipeActionThreshold){
                cardDirection = (cardCenterX > _viewWidth/2) ? SwipeDirectionRight : SwipeDirectionLeft;
            }
            else{
                cardDirection = SwipeDirectionCenter;
            }
            [self shiftCards:SwipeDirectionCenter];
            [self animate:_currentSiftCard inDirection:cardDirection];
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
    [self reloadData];
}

-(void)animate:(SiftCardView*)card inDirection:(SwipeDirection)direction{
    CGRect cardFrame = card.frame;
    CGPoint  cardCenter;
    switch(direction){
        case SwipeDirectionLeft:{
            cardCenter = CGPointMake(-(_viewWidth + cardFrame.size.width), _originalCardCenter.y);
            break;
        }
        case SwipeDirectionRight:{
            cardCenter = CGPointMake(_viewWidth + cardFrame.size.width, _originalCardCenter.y);
            break;
        }
        case SwipeDirectionCenter:{
            cardCenter = _originalCardCenter;
            break;
        }
        default:
            break;
    }
    
    //Shuffle cards forward
    
    [UIView animateWithDuration:0.34 animations:^{
        card.center = cardCenter;
        card.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        _lastSiftCard = card;
//        _currentSiftCard = [_siftViewCards objectAtIndex:[_siftViewCards indexOfObject:card]-1];
        
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
    [self reloadData];
}

-(void)shiftCards:(SwipeDirection)direction{
    if(_currentlyShiftingCards == YES) return;
    _currentlyShiftingCards = YES;
    
    NSArray *cards = [[self.subviews reverseObjectEnumerator] allObjects];
    for(SiftCardView *card in cards){
        if([_siftViewCards indexOfObject:card] > 0 && [_siftViewCards indexOfObject:card] < 3){
            CGPoint cardCenter = card.center;
            
            if(direction == SwipeDirectionCenter){
                cardCenter.x = _originalCardCenter.x;
            }
            else{
                cardCenter.x = (direction == SwipeDirectionRight) ?
                _originalCardCenter.x + (3-[_siftViewCards indexOfObject:card])*10 :
                _originalCardCenter.x - (3-[_siftViewCards indexOfObject:card])*10;
                NSLog(@"Card Index: %i", (int)[_siftViewCards indexOfObject:card]);
            }
            
            [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                card.center = cardCenter;
            } completion:^(BOOL finished) {
                if([_siftViewCards indexOfObject:card] == 2){
                    _currentlyShiftingCards = NO;
                }
            }];
        }
    }
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
    
    for(NSDictionary *cardData in _siftViewData){
        SiftCardView *card = [[SiftCardView alloc] initWithFrame:CGRectMake(_viewWidth/2 - _cardWidth/2, 84, _cardWidth, _cardHeight)];
        card.tag = [_siftViewData count] - ([_siftViewData indexOfObject:cardData] + 1);
        card.titleLabel.text = [cardData objectForKey:@"title"];
        card.subtitleLabel.text = [cardData objectForKey:@"subtitle"];
        card.imageView.image = [UIImage imageNamed:[cardData objectForKey:@"imageName"]];
        [self addSubview:card];
        [_siftViewCards insertObject:card atIndex:0];
        
        CGRect shiftFrame = card.frame;
        switch (card.tag) {
            case 0:{
                NSLog(@"Last");
                _currentSiftCard = card;
                break;
            }
            case 1:{
                NSLog(@"Second to last");
                shiftFrame.origin.y += 5;
                card.frame = shiftFrame;
                card.titleLabel.alpha = 0.6;
                card.subtitleLabel.alpha = 0.6;
                card.imageView.alpha = 0.6;
                card.transform = CGAffineTransformMakeScale(0.99, 0.99);
                break;
            }
            case 2:{
                NSLog(@"Third to last");
                shiftFrame.origin.y += 10;
                card.frame = shiftFrame;
                card.titleLabel.alpha = 0.3;
                card.subtitleLabel.alpha = 0.3;
                card.imageView.alpha = 0.3;
                card.transform = CGAffineTransformMakeScale(0.98, 0.98);
                break;
            }
            default:{
                card.alpha = 0;
                card.transform = CGAffineTransformMakeScale(0.98, 0.98);
                NSLog(@"Card Index: %i", card.tag);
                break;
            }
        }
    }
    //Animate them into place
    
}

@end
