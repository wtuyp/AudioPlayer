//
//  AudioCell.h
//  AudioPlayerDemo
//
//  Created by Lin Zhang on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioButton.h"

@interface AudioCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) AudioButton *audioButton;

- (void)configurePlayerButton;

@end
