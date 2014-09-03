//
//  SiftView.m
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import "SiftView.h"
#import "SiftCardView.h"
#import "UIImageView+AFNetworking.h"

NSString * const SiftViewStateChangeNotification = @"SiftViewStateChangeNotification";

@implementation SiftView{

}

-(id)initWithFrame:(CGRect)frame data:(NSArray*)data{
    _siftViewFrame = frame;
    _siftViewFrame.size.height = _siftViewFrame.size.height/2;
    self = [super initWithFrame:_siftViewFrame];
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    _allowsVerticalPanning = NO;
    _shiftSecondaryCards = NO;
    _cardsAreHidden = NO;
    _siftViewCards = [[NSMutableArray alloc] init];
    _siftViewData = [data mutableCopy];
    
    [self initSiftView];
    [self reloadData];
    
    return self;
}
-(id)initWithFrame:(CGRect)frame cards:(NSArray*)cards{
    frame.size.height = frame.size.height/2;
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = NO;
    
    [self initSiftView];
    
    for(SiftCardView *card in cards){
        card.tag = [cards indexOfObject:card];
        [self addSubview:card];
    }
    return self;
}

-(void)initSiftView{
    _viewWidth = _siftViewFrame.size.width;
    _viewHeight = _siftViewFrame.size.height;
    _cardWidth = 300;
    _cardHeight = (IS_IPHONE_5) ? 300 : 280;
    _currentlyShiftingCards = NO;
    _cardDisplayCount = 3;
    _swipeActionThreshold = 120;
    
    _rightActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightActionButton.frame = CGRectMake(_viewWidth, _cardHeight/2-30, 80, 60);
    _rightActionButton.backgroundColor = [GREEN colorWithAlphaComponent:0.95];
    _rightActionButton.layer.cornerRadius = 5.f;
    _rightActionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
    [self addSubview:_rightActionButton];
    
    _leftActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftActionButton.frame = CGRectMake(-80, _cardHeight/2-30, 80, 60);
    _leftActionButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.95];
    _leftActionButton.layer.cornerRadius = 5.f;
    _leftActionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self addSubview:_leftActionButton];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipingCard:)];
    _panGesture.delegate = self;
}

-(void)swipingCard:(UIPanGestureRecognizer*)recognizer{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            [_currentSiftCard stopVideo];
            _cardCenter = _currentSiftCard.center;
            _originalCardCenter = _currentSiftCard.center;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint touchChange = [recognizer translationInView:_currentSiftCard];
            CGFloat cardCenterY = (_allowsVerticalPanning) ? _cardCenter.y + touchChange.y : _cardCenter.y;
            CGFloat cardCenterX = _cardCenter.x + touchChange.x;
            int offset = (cardCenterX > _viewWidth/2) ? cardCenterX - _viewWidth/2 : -1 * (_viewWidth/2 - cardCenterX);
            _currentSiftCard.center = CGPointMake(cardCenterX, cardCenterY);
            _currentSiftCard.transform = CGAffineTransformMakeRotation(offset/(_viewWidth*4));
            
            [_delegate siftView:self didSwipe:offset];
            
            if(fabs(offset) > _swipeActionThreshold/2){
                if(cardCenterX > _viewWidth/2){
                    [self showActionButton:SwipeDirectionRight];
                    [self shiftCards:SwipeDirectionRight];
                } else{
                    [self shiftCards:SwipeDirectionLeft];
                    [self showActionButton:SwipeDirectionLeft];
                }
            }
            else{
                [self hideActionButtons];
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
            [self hideActionButtons];
            [self animate:_currentSiftCard inDirection:cardDirection];
        }
        default:
            break;
    }
}

-(void)swipe:(SiftCardView*)card inDirection:(SwipeDirection)direction{
    _siftViewState = (direction == SwipeDirectionRight) ? SiftViewStateBeganSiftRight : SiftViewStateBeganSiftLeft;
    [self animate:card inDirection:direction];
}

- (void)swipeLeft{
    [self swipe:_currentSiftCard inDirection:SwipeDirectionLeft];
}

- (void)swipeRight{
    [self swipe:_currentSiftCard inDirection:SwipeDirectionRight];
}

-(void)swipedCard:(SwipeDirection)direction{
    switch (direction) {
        case SwipeDirectionLeft:{
            _siftViewState = SiftViewStateCompletedSiftLeft;
            [_delegate didSwipeCard:_currentSiftCard inDirection:direction];
            break;
        }
        case SwipeDirectionRight:{
            _siftViewState = SiftViewStateCompletedSiftRight;
            [_delegate didSwipeCard:_currentSiftCard inDirection:direction];
            break;
        }
        case SwipeDirectionCenter:{
            break;
        }
            
        default:
            break;
    }
}

-(void)tappedCard:(UITapGestureRecognizer*)recognizer{
    SiftCardView *card = (SiftCardView*)[recognizer view];
    [_delegate siftView:self didSelectCard:card];
}

-(void)animate:(SiftCardView*)card inDirection:(SwipeDirection)direction{
    
    CGRect cardFrame = card.frame;
    CGPoint  cardCenter;
    switch(direction){
        case SwipeDirectionLeft:{
            cardCenter = CGPointMake(-(_viewWidth + cardFrame.size.width), card.frame.origin.y + card.frame.size.height/2);
            break;
        }
        case SwipeDirectionRight:{
            cardCenter = CGPointMake(_viewWidth + cardFrame.size.width, card.frame.origin.y + card.frame.size.height/2);
            break;
        }
        case SwipeDirectionCenter:{
            cardCenter = _originalCardCenter;
            break;
        }
        default:
            break;
    }

    [UIView animateWithDuration:0.34 animations:^{
        card.center = cardCenter;
        card.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        [self swipedCard:direction];

        if(direction != SwipeDirectionCenter){
            
            _lastSiftCard = _currentSiftCard;
            [_currentSiftCard removeFromSuperview];
            [_siftViewData removeObjectAtIndex:0];
            [_siftViewCards removeObjectAtIndex:0];
            _currentSiftCard = nil;
            
            if([_siftViewData count]){
                [self shuffleCardsForward];
            }
            else{
                [_delegate didSiftAllCards];
                [_delegate didUpdateNumberOfCards:[_siftViewData count]];
            }
        }
    }];
}

-(void)shiftCards:(SwipeDirection)direction{
    
    if(!_shiftSecondaryCards){
        return;
    }
    
    if(_currentlyShiftingCards == YES) return;
    _currentlyShiftingCards = YES;
    
    NSArray *cards = [[_siftViewCards reverseObjectEnumerator] allObjects];
    for(SiftCardView *card in cards){
        if([_siftViewCards indexOfObject:card] > 0 && [_siftViewCards indexOfObject:card] < _cardDisplayCount){
            CGPoint cardCenter = card.center;
            if(direction == SwipeDirectionCenter){
                cardCenter.x = _originalCardCenter.x;
            }
            else{
                cardCenter.x = (direction == SwipeDirectionRight) ?
                _originalCardCenter.x + (_cardDisplayCount-[_siftViewCards indexOfObject:card])*10 :
                _originalCardCenter.x - (_cardDisplayCount-[_siftViewCards indexOfObject:card])*10;
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
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
    _currentSiftCard = [_siftViewCards objectAtIndex:0];

    if([_siftViewData count] > 2){
        SiftCardView *dummyCard = [[SiftCardView alloc] initWithFrame:CGRectMake(_viewWidth/2 - _cardWidth/2, self.frame.origin.y + 15, _cardWidth, _cardHeight)];
        dummyCard.transform = CGAffineTransformMakeScale(0.97, 0.97);
        [self.superview insertSubview:dummyCard belowSubview:[_siftViewCards lastObject]];
        [_siftViewCards addObject:dummyCard];
    }

    for(SiftCardView *card in _siftViewCards){
        int cardIndex = (int)[_siftViewCards indexOfObject:card];
        CGFloat cardAlpha = 1 - (cardIndex * 0.33);
        CGFloat cardScale = 1 - (cardIndex * 0.01);
        CGPoint cardCenter = CGPointMake(card.center.x, card.center.y - 5);

        [UIView animateWithDuration:0.2 animations:^{
            card.center = cardCenter;
            card.alpha = cardAlpha;
            card.titleLabel.alpha = cardAlpha;
            card.subtitleLabel.alpha = cardAlpha;
            card.imageView.alpha = cardAlpha;
            card.transform = CGAffineTransformMakeScale(cardScale, cardScale);
        } completion:^(BOOL finished) {
            //Reload data after last of cards has been
            //animated into place
            if(cardIndex == [_siftViewCards count]-1){
                [self reloadData];
            }
        }];
        
    }
}

-(void)undoLastSift{
    if(!_lastSiftCard || _lastSiftCard == _currentSiftCard || _cardsAreHidden){
        return;
    }
    
    if(_currentSiftCard != nil){
        [self.superview insertSubview:_lastSiftCard aboveSubview:_currentSiftCard];
    }
    else{
        [self.superview addSubview:_lastSiftCard];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _lastSiftCard.center = _currentSiftCard.center;
    } completion:^(BOOL finished) {
        [_siftViewCards insertObject:_lastSiftCard atIndex:0];
        NSDictionary *cardData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  _lastSiftCard.cardInfo, @"cardInfo",
                                  _lastSiftCard.title, @"title",
                                  _lastSiftCard.subtitle, @"subtitle",
                                  _lastSiftCard.detail, @"detail",
                                  _lastSiftCard.imageURL, @"imageURL",
                                  nil];
        [_siftViewData insertObject:cardData atIndex:0];
        _currentSiftCard = _lastSiftCard;
        _lastSiftCard = nil;
        [_delegate siftView:self didUndoSiftForCard:_currentSiftCard];
        [self reloadData];
    }];
}

-(void)reachedEndOfData{
    //Send reference to the top SiftCardView
    [[NSNotificationCenter defaultCenter] postNotificationName:SiftViewStateChangeNotification
                                                        object:self
                                                      userInfo:nil];
}

/*!
 @description Animate Show/Hide views in on either side of
 the view based on Card pan and depending
 on the direction the card is panned
 
 @param direction
 */
-(void)reloadData{
    
    //Remove old cards
    NSArray *cards = [_siftViewCards mutableCopy];
    for(SiftCardView *card in cards){
        if([card isKindOfClass:[SiftCardView class]]){
            [_siftViewCards removeObject:card];
            [card removeFromSuperview];
        }
    }
    
    int rangeLimit = (_cardDisplayCount > [_siftViewData count]) ? [_siftViewData count] : _cardDisplayCount;
    _displaySetData = [[[[_siftViewData subarrayWithRange:NSMakeRange(0, rangeLimit)] reverseObjectEnumerator] allObjects] mutableCopy];
    for(NSDictionary *cardData in _displaySetData){
        SiftCardView *card = [[SiftCardView alloc] initWithFrame:CGRectMake(_viewWidth/2 - _cardWidth/2, self.frame.origin.y, _cardWidth, _cardHeight) withInfo:cardData];
        card.tag = [_displaySetData count] - ([_displaySetData indexOfObject:cardData] + 1);
        card.cardInfo = [cardData objectForKey:@"cardInfo"];
        card.title = [cardData objectForKey:@"title"];
        card.titleLabel.text = [cardData objectForKey:@"title"];
        card.subtitle = [cardData objectForKey:@"subtitle"];
        card.subtitleLabel.text = [cardData objectForKey:@"subtitle"];
        card.detail = [cardData objectForKey:@"detail"];
        card.detailLabel.text = [cardData objectForKey:@"detail"];
        card.subDetail = [cardData objectForKey:@"subDetail"];
        card.subDetailLabel.text = [cardData objectForKey:@"subDetail"];
        card.imageName = ([cardData objectForKey:@"imageName"]) ? [cardData objectForKey:@"imageName"] : @"placeholder";
        card.imageView.image = [UIImage imageNamed:card.imageName];
        [card.leftButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
        [card.rightButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
        [card.tapGesture addTarget:self action:@selector(tappedCard:)];
        if([cardData objectForKey:@"imageURL"]){
            card.imageURL = [cardData objectForKey:@"imageURL"];
            NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", card.imageURL]];
            [card.imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
        
        [card addGestureRecognizer:_panGesture];
        [self.superview insertSubview:card belowSubview:self];
        [_siftViewCards insertObject:card atIndex:0];
        
        CGRect shiftFrame = card.frame;
        shiftFrame.origin.y = self.frame.origin.y + (5 * card.tag);
        card.frame = shiftFrame;
        
        CGFloat cardAlpha = 1 - (card.tag * 0.33);
        card.titleLabel.alpha = cardAlpha;
        card.subtitleLabel.alpha = cardAlpha;
        card.imageView.alpha = cardAlpha;
        
        CGFloat cardScale = 1 - (card.tag * 0.01);
        card.transform = CGAffineTransformMakeScale(cardScale, cardScale);
        if(card.tag == 0){
            _currentSiftCard = card;
        }

        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-((card.tag+1) * 10));
        horizontalMotionEffect.maximumRelativeValue = @(((card.tag+1) * 10));
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect];
        [card addMotionEffect:group];
        
    }
    [_delegate didUpdateNumberOfCards:[_siftViewData count]];
}

/*!
 @description Animate Show/Hide views in on either side of
                the view based on Card pan and depending
                on the direction the card is panned
 
 @param direction
 */
-(void)showActionButton:(SwipeDirection)direction{
    CGRect  rightButtonFrame = _rightActionButton.frame,
    leftButtonFrame = _leftActionButton.frame;
    
    if(direction == SwipeDirectionRight){
        rightButtonFrame.origin.x = _viewWidth - 60;
        leftButtonFrame.origin.x = -80;
    }
    else{
        rightButtonFrame.origin.x = _viewWidth;
        leftButtonFrame.origin.x = -20;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _rightActionButton.frame = rightButtonFrame;
        _leftActionButton.frame = leftButtonFrame;
    } completion:^(BOOL finished) {
        //
    }];
}

/*!
 @description Show/hide Sift view cards
 
 @param visibility The state of the Sift view cards' visibility
 */
- (void)setSiftCards:(SiftCardsVisibility)visibility{
    for(SiftCardView *card in _siftViewCards){
        card.hidden = visibility;
    }
    _cardsAreHidden = visibility;
}


/*!
 @description Animate Show/Hide views out on either
                side of the view based on Card pan
 */
-(void)hideActionButtons{
    CGRect  rightButtonFrame = _rightActionButton.frame,
    leftButtonFrame = _leftActionButton.frame;
    rightButtonFrame.origin.x = _viewWidth;
    leftButtonFrame.origin.x = -80;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _rightActionButton.frame = rightButtonFrame;
        _leftActionButton.frame = leftButtonFrame;
    } completion:^(BOOL finished) {
        //
    }];
}

@end
