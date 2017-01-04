//
//  ViewController.m
//  VideoPlayerProject
//
//  Created by emuch on 2017/1/3.
//  Copyright © 2017年 100TAL. All rights reserved.
//


#import "ViewController.h"
#import "DTCCPlayerView.h"
#import "UIGlobal.h"
#import "UIViewAdditions.h"

@interface ViewController (){
    UIButton * localButton;
    UIButton * streamButton;
    DTCCPlayerView *videoPlayView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view, typically from a nib.
     videoPlayView = [[DTCCPlayerView alloc]initWithFrame:CGRectMake(0, 0, DT_SCREEN_MAIN_WIDTH, DT_SCREEN_MAIN_WIDTH*14/25.0)];
    [self.view addSubview:videoPlayView];
    [self initUI];
}
- (void)initUI
{
    localButton = ({
        UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(0, 0, 80, 30);
        [pButton setTitle:@"本地视频" forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:15];
        pButton.tag = 100;
        [pButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pButton];
        pButton;
    });
    streamButton = ({
        UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(0, 0, 80, 30);
        [pButton setTitle:@"在线视频" forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:15];
        pButton.tag = 200;
        [pButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pButton];
        pButton;
    });

}
- (void)playButtonPressed:(UIButton*)sender
{
    if (sender.tag == 100) {
        NSString * path=[[NSBundle mainBundle]pathForResource:@"Movie" ofType:@"m4v"];
        [videoPlayView startPlayURL:[NSURL fileURLWithPath:path] isStartNow:YES];


    }
    else{
        NSString * url=@"http://7xawdc.com2.z0.glb.qiniucdn.com/o_19p6vdmi9148s16fs1ptehbm1vd59.mp4";
        [videoPlayView startPlayURL:[NSURL URLWithString:url] isStartNow:YES];

    }
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    localButton.centerY = streamButton.centerY =self.view.centerY;
    localButton.left = 50;
    streamButton.right = DT_SCREEN_MAIN_WIDTH - 50;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
