//
//  SiftCardView.h
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GradientView.h"
#import "PlayButton.h"
#import "WhiteArcLoader.h"


@interface SiftCardView : UIView

@property (nonatomic) BOOL hasVideo;
@property (nonatomic) CGFloat viewWidth;
@property (nonatomic) CGFloat viewHeight;
@property (nonatomic) NSString *videoURL;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSString *subDetail;
@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSMutableDictionary *cardInfo;

@property (copy, nonatomic) UILabel *titleLabel;
@property (copy, nonatomic) UILabel *subtitleLabel;
@property (copy, nonatomic) UILabel *detailLabel;
@property (copy, nonatomic) UILabel *subDetailLabel;
@property (copy, nonatomic) UIButton *leftButton;
@property (copy, nonatomic) UIButton *rightButton;
@property (copy, nonatomic) GradientView *gradientView;
@property (copy, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) UIImageView *leftActionImageView;
@property (copy, nonatomic) UIImageView *rightActionImageView;
@property (copy, nonatomic) UITapGestureRecognizer *tapGesture;
@property (copy, nonatomic) UITapGestureRecognizer *swipeGesture;

@property (copy, nonatomic) UIButton *playButton;
@property (copy, nonatomic) PlayButton *videoPlayButton;
@property (copy, nonatomic) WhiteArcLoader *videoLoader;
@property (strong, nonatomic) MPMoviePlayerController *player;
@property (copy, nonatomic) UITapGestureRecognizer *tapToPlay;
@property (copy, nonatomic) UITapGestureRecognizer *tapToStop;

-(id)initWithFrame:(CGRect)frame withInfo:(NSDictionary*)cardInfo;
-(void)playVideo;
-(void)stopVideo;

@end
