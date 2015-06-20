//
//  ViewController.m
//  ZhihuDiary
//
//  Created by Jonathan Lin on 2015/6/19.
//  Copyright © 2015年 LittleLin. All rights reserved.
//

#import "StoryViewController.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>

@interface StoryViewController ()

@property (weak, nonatomic) IBOutlet UIView *networkErrorView;

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // for network error view
    [self toggleNetworkErrorView:NO];
    
    NSString *apiUrlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@", self.story[@"id"]];
    NSURL *apiURL = [NSURL URLWithString:apiUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL: apiURL];
    
    [SVProgressHUD showWithStatus:@"資料更新中..." maskType:SVProgressHUDMaskTypeBlack];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:               ^(NSURLResponse * __nullable response, NSData * __nullable data, NSError * __nullable error) {
        
        if ([data length] >0 && error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.titleLabel.text = dict[@"title"];
            self.bodyLabel.text = dict[@"body"];
            NSString *pageImageUrl = dict[@"image"];
            [self.pageImage setImageWithURL:[NSURL URLWithString:pageImageUrl]];
            
            [self toggleNetworkErrorView:NO];
        } else if ([data length] == 0 && error == nil) {
            [self toggleNetworkErrorView:YES];
        } else if (error != nil) {
            [self toggleNetworkErrorView:YES];
        }
                
        [SVProgressHUD dismiss];
    }];
}

- (void)toggleNetworkErrorView: (BOOL) display {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    CGRect currentFrame = self.networkErrorView.frame;
    if (display) {
        currentFrame.size = CGSizeMake(screenWidth, 30);
        self.networkErrorView.hidden = NO;
    } else {
        currentFrame.size = CGSizeMake(screenWidth, 0);
        self.networkErrorView.hidden = YES;
    }
    
    self.networkErrorView.frame = currentFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
