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

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *apiUrlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@", self.story[@"id"]];
    NSURL *apiURL = [NSURL URLWithString:apiUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL: apiURL];
    
    [SVProgressHUD showWithStatus:@"資料更新中..." maskType:SVProgressHUDMaskTypeBlack];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:               ^(NSURLResponse * __nullable response, NSData * __nullable data, NSError * __nullable connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        self.titleLabel.text = dict[@"title"];
        self.bodyLabel.text = dict[@"body"];
        NSString *pageImageUrl = dict[@"image"];
        [self.pageImage setImageWithURL:[NSURL URLWithString:pageImageUrl]];
        [SVProgressHUD dismiss];
    }];

    
    self.titleLabel.text = self.story[@"title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
