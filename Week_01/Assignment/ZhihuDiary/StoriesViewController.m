//
//  StoriesViewController.m
//  ZhihuDiary
//
//  Created by Jonathan Lin on 2015/6/20.
//  Copyright © 2015年 LittleLin. All rights reserved.
//

#import "StoriesViewController.h"
#import "StoryCell.h"
#import "StoryViewController.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface StoriesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *storiesTableView;
@property (strong, nonatomic) NSArray *stories;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;


@end

@implementation StoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // for refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.storiesTableView insertSubview:self.refreshControl atIndex:0];
    
    // for table view
    self.storiesTableView.dataSource = self;
    self.storiesTableView.delegate = self;
    
    // for network error view
    [self toggleNetworkErrorView:NO];
    
    // load latest stories
    [self loadLatestStories];
}

- (void)onRefresh {
    [self loadLatestStories];
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

- (void) loadLatestStories {
    NSString *apiUrlString = @"http://news-at.zhihu.com/api/4/news/latest";
    NSURL *apiURL = [NSURL URLWithString:apiUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL: apiURL];
    
    [SVProgressHUD showWithStatus:@"資料更新中..." maskType:SVProgressHUDMaskTypeBlack];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:               ^(NSURLResponse * __nullable response, NSData * __nullable data, NSError * __nullable error) {
        
        if ([data length] >0 && error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.stories = dict[@"stories"];
            [self.storiesTableView reloadData];
            
            [self toggleNetworkErrorView:NO];
        } else if ([data length] == 0 && error == nil) {
            [self toggleNetworkErrorView:YES];
        } else if (error != nil) {
            [self toggleNetworkErrorView:YES];
        }
        
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyStoryCell" forIndexPath:indexPath];
    NSDictionary *story = self.stories[indexPath.row];
    NSString *title = story[@"title"];
    cell.titleLabel.text = title;
    
    NSString *coverImageUrl = story[@"images"][0];
    [cell.coverImage setImageWithURL:[NSURL URLWithString:coverImageUrl]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    StoryCell *cell = sender;
    NSIndexPath *indexPath = [self.storiesTableView indexPathForCell: cell];
    
    NSDictionary *story = self.stories[indexPath.row];    
    StoryViewController *destinationVC = segue.destinationViewController;
    destinationVC.story = story;
}

@end
