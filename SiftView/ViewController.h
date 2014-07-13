//
//  ViewController.h
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiftView.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *cardData;

@property (strong, nonatomic) IBOutlet SiftView *siftView;

@end

