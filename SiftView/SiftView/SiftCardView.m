//
//  SiftCardView.m
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import "SiftCardView.h"

@implementation SiftCardView

/*!
 @description Create an instance of the Sift Card View seeded with the necessary
    data for the card
 
 @param cardInfo A dictionary of cardData
 @param frame A CGRect for the size and position 
            of the card
 @return Returns an instance of the object
 */
-(id)initWithFrame:(CGRect)frame withInfo:(NSDictionary*)cardInfo{
    _cardInfo = [cardInfo mutableCopy];
    _videoURL = [_cardInfo objectForKey:@"videoURL"];
    self = [super initWithFrame:frame];
    _viewWidth = frame.size.width;
    _viewHeight = frame.size.height;
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight*0.80)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_imageView];
        
        _gradientView = [[GradientView alloc] initWithFrame:_imageView.frame];
        [self addSubview:_gradientView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _imageView.frame.size.height-60, _viewWidth-20, 40)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:22.f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _imageView.frame.size.height-30, _viewWidth-20, 30)];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.f];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        _subtitleLabel.numberOfLines = 0;
        [self addSubview:_subtitleLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _viewWidth-40, 30)];
        _detailLabel.font = [UIFont boldSystemFontOfSize:22.f];
        _detailLabel.textColor = ORANGE;
        [self addSubview:_detailLabel];
        
        _subDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _imageView.frame.size.height-30, _viewWidth-20, 30)];
        _subDetailLabel.font = [UIFont systemFontOfSize:14.f];
        _subDetailLabel.textColor = ORANGE;
        _subDetailLabel.numberOfLines = 0;
        [self addSubview:_subDetailLabel];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, _viewHeight*0.77, _viewWidth/2, _viewWidth*0.25);
        _leftButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:24.f];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftButton setTitle:@"*" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(_viewWidth/2, _viewHeight*0.77, _viewWidth/2, _viewWidth*0.25);
        _rightButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:28.f];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_rightButton setTitle:@":" forState:UIControlStateNormal];
        [_rightButton setTitleColor:GREEN forState:UIControlStateNormal];
        [self addSubview:_rightButton];
        
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:_tapGesture];
        
        if([_videoURL length] > 0){
            CGFloat playButtonWidth = _viewWidth/4;
            _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _playButton.frame = CGRectMake((_viewWidth/2) - playButtonWidth/2, (_imageView.frame.size.height/2) - playButtonWidth/2, playButtonWidth, playButtonWidth);
            _playButton.layer.cornerRadius = playButtonWidth/2;
            _playButton.layer.borderWidth = 8.f;
            _playButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
            _playButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:54.f];
            _playButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            [_playButton setTitle:@"6" forState:UIControlStateNormal];
            [_playButton setTitle:@"w" forState:UIControlStateSelected];
            [_playButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
            [_playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_playButton];
            
            _videoLoader = [[WhiteArcLoader alloc] initWithFrame:_playButton.frame];
            [self addSubview:_videoLoader];
        }
        
    }
    return self;
}

- (void)layoutSubviews{
    
    //Vertically adjust subtitleLabel
    [_subDetailLabel sizeToFit];
    CGRect subDetailFrame = _subDetailLabel.frame;
    subDetailFrame.origin.y = (_imageView.frame.size.height - subDetailFrame.size.height) - 10;
    _subDetailLabel.frame = subDetailFrame;
    
    //Vertically adjust subtitleLabel
    [_subtitleLabel sizeToFit];
    CGRect subtitleFrame = _subtitleLabel.frame;
    subtitleFrame.origin.y = (subDetailFrame.origin.y - subtitleFrame.size.height);
    _subtitleLabel.frame = subtitleFrame;
    
    //Vertically adjust titleLabel
    [_titleLabel sizeToFit];
    CGRect titleFrame = _titleLabel.frame;
    titleFrame.origin.y = (subtitleFrame.origin.y - titleFrame.size.height);
    _titleLabel.frame = titleFrame;
    
    CGRect detailFrame = _detailLabel.frame;
    detailFrame.origin.y = titleFrame.origin.y - _detailLabel.frame.size.height;
    _detailLabel.frame = detailFrame;
    

}

/*!
 @description Initializes the video player for this card, if
                it does not already exist.  If the player is
                currently playing, call the stopVideo method
 */
-(void)playVideo{
    _playButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if(!_player){
        NSLog(@"Show Video Loader");
        _playButton.selected = YES;
        NSURL *url = [NSURL URLWithString:_videoURL];
        _player = [[MPMoviePlayerController alloc] initWithContentURL:url];
        _player.shouldAutoplay = YES;
        [_player prepareToPlay];
        _player.movieSourceType = MPMovieSourceTypeFile;
        _player.view.backgroundColor = [UIColor clearColor];
        _player.backgroundView.backgroundColor = [UIColor clearColor];
        _player.view.frame = _imageView.frame;
        _player.scalingMode = MPMovieScalingModeAspectFill;
        [self insertSubview:_player.view belowSubview:_playButton];
        
        [_videoLoader startRotation];        
    }
    else{
        
        if(_player.playbackState == MPMoviePlaybackStatePlaying){
            [self stopVideo];
            return;
        }
        
        _playButton.selected = YES;
        [_videoLoader startRotation];
        _player.view.hidden = NO;
        _player.view.userInteractionEnabled = YES;
        NSURL *url = [NSURL URLWithString:_videoURL];
        _player.contentURL = url;
        [_player play];
    }
}

///@description Stops the video
-(void)stopVideo{
    _playButton.selected = NO;
    _player.view.hidden = YES;
    _player.currentPlaybackTime = 0;
    _player.view.userInteractionEnabled = NO;
    [_player stop];
    _player = nil;
    [_videoLoader stopRotation];
}

- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification {
    
    switch (_player.loadState) {
        case MPMovieLoadStatePlayable:
            NSLog(@"Ready to play");
            break;
        case MPMovieLoadStatePlaythroughOK:
            NSLog(@"Ready to play all the way through");
            break;
        case MPMovieLoadStateStalled:
            NSLog(@"Stalled...");
            break;
        case MPMovieLoadStateUnknown:
            NSLog(@"Got Prollems");
            break;
            
        default:
            break;
    }
}

/*!
 @description Stop the video loader rotation if the 
                player is currently playing
 */
-(void)MPMoviePlayerPlaybackStateDidChange:(id)sender{
    switch (_player.playbackState) {
        case MPMoviePlaybackStateStopped :
            NSLog(@"Stopped");
            break;
            
        case MPMoviePlaybackStatePlaying :{
            NSLog(@"Playing...");
            [_videoLoader stopRotation];
        }
            break;
            
        case MPMoviePlaybackStateInterrupted :
            NSLog(@"Loading");
            break;
            
        case MPMoviePlaybackStatePaused :
            NSLog(@"Paused");
            break;
        case MPMoviePlaybackStateSeekingBackward:
        case MPMoviePlaybackStateSeekingForward:
        default:
            break;
    }
}


/*!
 @description Call the stopVideo method to reset the UI
                if the video has reached its end
 */
-(void)MPMoviePlayerPlaybackDidFinish:(NSNotification*)notification{
    NSLog(@"Video Finished");
    [self stopVideo];
}

@end
