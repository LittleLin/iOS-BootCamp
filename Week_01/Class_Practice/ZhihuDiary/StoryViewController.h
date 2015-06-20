//
//  ViewController.h
//  ZhihuDiary
//
//  Created by Jonathan Lin on 2015/6/19.
//  Copyright © 2015年 LittleLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryViewController : UIViewController

@property (strong, nonatomic) NSDictionary *story;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pageImage;

@end

