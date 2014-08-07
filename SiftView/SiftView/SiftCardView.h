//
//  SiftCardView.h
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientView.h"

@interface SiftCardView : UIView

@property (nonatomic) CGFloat viewWidth;
@property (nonatomic) CGFloat viewHeight;
@property (nonatomic) CGFloat imageURL;
@property (copy, nonatomic) NSMutableDictionary *cardInfo;

@property (copy, nonatomic) UILabel *titleLabel;
@property (copy, nonatomic) UILabel *subtitleLabel;
@property (copy, nonatomic) UILabel *detailLabel;
@property (copy, nonatomic) UIButton *leftButton;
@property (copy, nonatomic) UIButton *rightButton;
@property (copy, nonatomic) GradientView *gradientView;
@property (copy, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) UIImageView *leftActionImageView;
@property (copy, nonatomic) UIImageView *rightActionImageView;
@property (copy, nonatomic) UITapGestureRecognizer *tapGesture;

@end
