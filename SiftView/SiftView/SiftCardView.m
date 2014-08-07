//
//  SiftCardView.m
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import "SiftCardView.h"

@implementation SiftCardView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _viewWidth = frame.size.width;
    _viewHeight = frame.size.height;
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.f;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight*0.85)];
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
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _viewWidth-20, 30)];
        _detailLabel.font = [UIFont boldSystemFontOfSize:22.f];
        _detailLabel.text = @"$400";
        _detailLabel.textColor = ORANGE;
        [self addSubview:_detailLabel];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, _viewHeight*0.85, _viewWidth/2, _viewWidth*0.15);
        _leftButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:24.f];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftButton setTitle:@")" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(_viewWidth/2, _viewHeight*0.85, _viewWidth/2, _viewWidth*0.15);
        _rightButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:24.f];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_rightButton setTitle:@"R" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:_rightButton];
        
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:_tapGesture];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    //Vertically adjust subtitleLabel
    [_subtitleLabel sizeToFit];
    CGRect subtitleFrame = _subtitleLabel.frame;
    subtitleFrame.origin.y = (_imageView.frame.size.height - subtitleFrame.size.height) - 10;
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

@end
