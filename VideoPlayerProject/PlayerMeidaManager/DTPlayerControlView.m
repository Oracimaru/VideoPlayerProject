//
//  DTPlayerControlView.m
//  
//
//  Created by zhanghaibin on 3/18/16.
//  Copyright © 2016 zhanghaibin. All rights reserved.
//

#import "DTPlayerControlView.h"

#import <MediaPlayer/MediaPlayer.h>
#import "UIViewAdditions.h"
#import "NSObject+Additions.h"
#import "UIGlobal.h"
typedef NS_ENUM(NSInteger, GestureType){
    GestureTypeOfNone = 0,
    GestureTypeOfVolume,
    //GestureTypeOfBrightness,
    GestureTypeOfProgress,
};

@interface DTPlayerControlView () {
    UIButton            *playButton;        // 开始播放的按钮
    
    UIButton            *pauseButton;       // 暂停按钮
    UILabel             *timeLabel;         // 播放时间
    UISlider            *playerSlider;      // 滑动条
    UIButton            *speedButton;       // 倍速按钮
    UIButton           *speedControl;      //倍速事件
    
    UIView              *bottomView;        // 下边的按钮
    
    float               _fastSpeed;              // 快进倍速
    
    UIView              *_progressView;        // 快进的时候的view;
    UILabel             *_progressLabel;       // 快进的label
    UIImageView         *_progressImageView; // 快进的image
    
    BOOL                isAnimation;
    BOOL                isTitleHidden;
    BOOL                _shouldResonse;            // layoutsubview要不要调用
    BOOL                hasPan;
    
    UIView              *titleView;
    UIButton            *backButton;
    UILabel             *titleLabel;        // 播放的视频的名字
    UIButton            *correctButton;     // 纠错
    UIActivityIndicatorView * activityView;
    
    UIImageView         *_tipsImageView;
    
}

@property (nonatomic, assign)   NSTimeInterval totalVideoTime;

// 手势相关
@property (nonatomic,assign)    GestureType gestureType;
@property (nonatomic,assign)    CGPoint originalLocation;


@end

@implementation DTPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInitView];
    }
    return self;
}

- (void)customInitView {
    self.clipsToBounds = YES;
    
    _tipsImageView = ({
        UIImageView *tImage = [[UIImageView alloc] init];
        tImage.userInteractionEnabled = YES;
        tImage.image = [UIImage imageNamed:@"study_notonline.jpg"];
        tImage.hidden = YES;
        [self addSubview:tImage];
        tImage;
    });
    
    // titleview
    titleView = ({
        UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.width, 60)];
        tView.backgroundColor = [UIColor clearColor];
        [self addSubview:tView];
        tView;
    });
    
    titleLabel = ({
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 100, 40)];
        tLabel.textAlignment = NSTextAlignmentCenter;
        tLabel.textColor = [UIColor whiteColor];
        tLabel.font = [UIFont systemFontOfSize:14];
        [titleView addSubview:tLabel];
        tLabel;
    });
    
    backButton = ({
        UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bButton setImage:[UIImage imageNamed:@"video_back"] forState:UIControlStateNormal];
        bButton.frame = CGRectMake(0, 20, 60, 60);//40,40
        [bButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 20)];
        [bButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        bButton.hidden = YES;
        [titleView addSubview:bButton];
        bButton;
    });
    
    correctButton = ({
        UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cButton setTitle:@"纠错" forState:UIControlStateNormal];
        cButton.titleLabel.font = [UIFont systemFontOfSize:14];
        cButton.frame = CGRectMake(20, 20, 40, 40);
        [cButton addTarget:self action:@selector(correctButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        //[titleView addSubview:cButton];
        cButton;
    });
 
    playButton = ({
        UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(0, 0, 30, 30);
        [pButton setImage:[UIImage imageNamed:@"video_bigPlayButton"] forState:UIControlStateNormal];
        [pButton setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
        [pButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pButton];
        pButton;
    });
    activityView = ({
        UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator setBackgroundColor:[UIColor clearColor]];
        [indicator setFrame:CGRectMake(self.width/2, self.height/2, 20, 20)];
        [self addSubview:indicator];
        indicator;
    });
    bottomView = ({
        UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
        [self addSubview:bView];
        bView.hidden = YES;

        bView;
    });
    
    pauseButton = ({
        UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(0, 0, 40, 40);
        [pButton setImage:[UIImage imageNamed:@"video_PlayButton"] forState:UIControlStateNormal];
        [pButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 5)];
        [pButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:pButton];
        pButton;
    });
    
    timeLabel = ({
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(pauseButton.right, 0, 100, 12)];
        tLabel.centerY = bottomView.height/2;
        tLabel.backgroundColor = [UIColor clearColor];
        tLabel.font = [UIFont systemFontOfSize:10];
        tLabel.textColor = RGB(170, 170, 170);
        tLabel.textAlignment = NSTextAlignmentCenter;
        tLabel.text = @"00:00:00/00:00:00";
        [bottomView addSubview:tLabel];
        tLabel;
    });
    playerSlider = ({
        UISlider *pslider = [[UISlider alloc] init];
        pslider.centerY = bottomView.height/2;
        pslider.enabled = NO;
        [pslider setThumbImage:[UIImage imageNamed:@"videoplay_slider"] forState:UIControlStateNormal];
        [pslider setThumbImage:[UIImage imageNamed:@"videoplay_sliderdrag"] forState:UIControlStateHighlighted];
        [pslider addTarget:self action:@selector(durationSliderMoving:) forControlEvents:UIControlEventValueChanged];
        [pslider addTarget:self action:@selector(durationSliderDone:) forControlEvents:UIControlEventTouchUpOutside];
        [pslider addTarget:self action:@selector(durationSliderDone:) forControlEvents:UIControlEventTouchUpInside];
        [pslider addTarget:self action:@selector(durationSliderDone:) forControlEvents:UIControlEventTouchCancel];
        [bottomView addSubview:pslider];
        pslider;
    });
    speedButton = ({
        UIButton *sButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sButton.frame = CGRectMake(0, 0, 25, 18);//25,18
        sButton.centerY = bottomView.height/2;
        [sButton setTitle:@"x1.0" forState:UIControlStateNormal];
        sButton.titleLabel.font = [UIFont systemFontOfSize:8];
        [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sButton.layer setCornerRadius:4];
        [sButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [sButton.layer setBorderWidth:0.5f];
        
        [bottomView addSubview:sButton];

        sButton;
    });
    speedControl = ({
        UIButton *control = [UIButton buttonWithType:UIButtonTypeCustom];
        control.frame = CGRectMake(0, 0, 40, 40);
        control.centerY = bottomView.height/2;
        [control addTarget:self action:@selector(fastButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:control];
        control;
    });

    _fullScreenButton = ({
        UIButton *fButton = [UIButton buttonWithType:UIButtonTypeCustom];
        fButton.frame = CGRectMake(0, 0, 40, 40);
        [fButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 5)];
        [fButton setImage:[UIImage imageNamed:@"video_fullScreen"] forState:UIControlStateNormal];
        [fButton addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:fButton];
        fButton;
    });
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
    [tapGesture addTarget:self action:@selector(hiddenTitleInfo)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
    [panGesture addTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
    
    isAnimation = NO;
    isTitleHidden = NO;
    _fastSpeed = 1;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    bottomView.width = self.width;
    bottomView.top = isTitleHidden?self.height:self.height-bottomView.height;
    _fullScreenButton.right = bottomView.right;
    speedButton.right = _fullScreenButton.left;
    speedControl.right= _fullScreenButton.left;
    playerSlider.left = timeLabel.right + 5;
    playerSlider.width = speedButton.left - playerSlider.left;
    activityView.center =self.center;
    playButton.center = CGPointMake(self.width/2, self.height/2);
    titleView.width = self.width;
    titleLabel.frame = CGRectMake(0, 20, titleView.width, 40);
    correctButton.right = titleView.width - 10;
    _tipsImageView.frame = self.bounds;
}

- (UIButton *)controlButton:(NSString *)title image:(UIImage *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.layer setCornerRadius:5];
    [button.layer setBorderWidth:1];
    [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    return button;
}

-(void)showHUD:(BOOL)showHUB{
    if (showHUB) {
        [activityView startAnimating];
    }else{
        [activityView stopAnimating];
    }
}


- (void)setTitle:(NSString *)title {
    if ([_title isEqualToString:title]) {
        return;
    }
    _title = title;
    titleLabel.text = title;
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    if (_isFullScreen == isFullScreen) {
        return;
    }
    _isFullScreen     = isFullScreen;
    backButton.hidden = !_isFullScreen;
    correctButton.hidden = _isFullScreen;

}

- (void)setHasVideo:(BOOL)hasVideo {
    _hasVideo = hasVideo;
    _tipsImageView.hidden = _hasVideo;
}
#pragma mark - Action

// 播放暂停
- (void)playButtonPressed {
    if (self.playerEvent) {
        self.playerEvent(nil, PlayEvent_PlayAndPause);
    } 
}
- (void)correctButtonPressed{
    if (self.playerEvent) {
        self.playerEvent(nil, PlayEvent_Correct);
    }
}
// 全屏播放
- (void)fullScreen {
    if (self.playerEvent) {
        self.playerEvent(nil, PlayEvent_FullScreen);
    }
}

// 倍速播放
- (void)fastButtonPressed {
    BOOL hasChange = NO;
    if (!hasChange && _fastSpeed == 1) {
        _fastSpeed = 1.25;
        hasChange = YES;
    }
    if (!hasChange && _fastSpeed == 1.25) {
        _fastSpeed = 1.5;
        hasChange = YES;
    }
    
    if (!hasChange && _fastSpeed == 1.5) {
        _fastSpeed = 1;
        hasChange = YES;
    }
    [speedButton setTitle:[NSString stringWithFormat:@"%0.1fx", _fastSpeed] forState:UIControlStateNormal];
    if (self.playerEvent) {
        self.playerEvent(@(_fastSpeed), PlayEvent_Speed);
    }
}

- (void)backButtonPressed {
    if (self.playerEvent) {
        self.playerEvent(nil, PlayEvent_Back);
    }
}

- (void)durationSliderMoving:(UISlider *)slider {
    if (self.playerEvent) {
        self.playerEvent(@(slider.value), PlayEvent_SliderDrag);
    }
}

- (void)durationSliderDone:(UISlider *)slider {
    if (self.playerEvent) {
        self.playerEvent(@(slider.value), PlayEvent_SliderDragDone);
    }
}

#pragma mark - Custom Method
/**
 *  隐藏显示上下部分按钮
 */
- (void)hiddenTitleInfo {
    if (isAnimation) {
        return;
    }
    isAnimation = YES;
    if (isTitleHidden) {
        // 显示
        [UIView animateWithDuration:0.3 animations:^{
            bottomView.top = self.height - bottomView.height;
            
            if  (_isFullScreen)
                titleView.top = -20;
            else
                titleView.top = -20;
        } completion:^(BOOL finished) {
            isAnimation = NO;
            [self performSelector:@selector(hiddenTitleInfo) withObject:nil afterDelay:5];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            bottomView.top = self.height;
            titleView.bottom = 0;
        } completion:^(BOOL finished) {
            isAnimation = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenTitleInfo) object:nil];
        }];
    }
    isTitleHidden = !isTitleHidden;
}

/**
 *  手势的显示
 */
//显示滑动的时候的slider
- (void)showProgressView:(BOOL)isShow {
    if (isShow) {
        if (!_progressView) {
            
            _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 135, 38)];
            _progressView.userInteractionEnabled = NO;
            _progressView.backgroundColor = [UIColor clearColor];
            [_progressView.layer setCornerRadius:4];
            _progressView.clipsToBounds = YES;
            _progressView.center = CGPointMake(self.width/2, self.height/2);
            UIView *backView = ({
                UIView *bView = [[UIView alloc] initWithFrame:_progressView.bounds];
                bView.backgroundColor = [UIColor blackColor];
                bView.alpha = 0.4f;
                bView;
            });
            [_progressView addSubview:backView];
            
            UIImage *forwardImage = [UIImage imageNamed:@"video_forward"];
            _progressImageView = [[UIImageView alloc] initWithImage:forwardImage];
            _progressImageView.frame = CGRectMake(10, 0, forwardImage.size.width, forwardImage.size.height);
            _progressImageView.centerY = _progressView.height/2;
            _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_progressImageView.right + 5, 0, _progressView.frame.size.width, 12)];
            _progressLabel.centerY = _progressView.height/2;
            _progressLabel.textColor = RGB(170, 170, 170);
            _progressLabel.font = [UIFont systemFontOfSize:10];
            _progressLabel.textAlignment = NSTextAlignmentLeft;
            [_progressView addSubview:_progressLabel];
            [_progressView addSubview:_progressImageView];
            [self addSubview:_progressView];
        }
    } else {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
}
- (void)updateProgressView:(NSDictionary *)dic {
    if ([dic[@"isforward"] boolValue]) {
        _progressImageView.image = [UIImage imageNamed:@"video_forward"];
    } else {
        _progressImageView.image = [UIImage imageNamed:@"video_backward"];
    }
    _progressLabel.text = [NSString stringWithFormat:@"%@/%@", [NSObject formatSecondsToString:[[dic objectForKey:@"labeltext"] integerValue]], [NSObject formatSecondsToString:self.totalVideoTime]];
}
//声音增加
- (void)volumeAdd:(CGFloat)step{
    [MPMusicPlayerController applicationMusicPlayer].volume += step;;
}

#pragma mark - Gesture
const int lenth = 5;
const int lenth_progress = 15;
const float VolumeStep = 0.02f;

- (void)panGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            _shouldResonse = NO;
            hasPan = NO;
            _originalLocation = CGPointZero;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentLocation = [panGestureRecognizer locationInView:self];
            CGFloat offset_x = currentLocation.x - _originalLocation.x;
            CGFloat offset_y = currentLocation.y - _originalLocation.y;
            if (CGPointEqualToPoint(_originalLocation,CGPointZero)) {
                _originalLocation = currentLocation;
                return;
            }
            
            if (_gestureType == GestureTypeOfNone) {
                if ((ABS(offset_x) <= ABS(offset_y))&&ABS(offset_y)>=lenth){
                    _gestureType = GestureTypeOfVolume;
                    _originalLocation = currentLocation;
                } else if ((ABS(offset_x) > ABS(offset_y))&&ABS(offset_x)>=lenth_progress) {
                    _gestureType = GestureTypeOfProgress;
                    _originalLocation = currentLocation;
                }
            }
            if (_gestureType == GestureTypeOfProgress) {
                if (hasPan) {
                    return;
                }
                [self showProgressView:YES];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (offset_x > 0) {
                    NSLog(@"横向向右");
                    if (self.playerEvent) {
                        self.playerEvent(@(NO), PlayEvent_Timer);
                    }
                    playerSlider.value += self.totalVideoTime > 0? 10/self.totalVideoTime:0;
                    dic[@"isforward"] = @(YES);
                }else{
                    NSLog(@"横向向左");
                    if (self.playerEvent) {
                        self.playerEvent(@(NO), PlayEvent_Timer);
                    }
                    playerSlider.value -= self.totalVideoTime > 0? 10/self.totalVideoTime:0;
                    dic[@"isforward"] = @(NO);
                }
                dic[@"labeltext"] = @(playerSlider.value*self.totalVideoTime);
                [self updateProgressView:dic];
                hasPan = YES;
            }else if (_gestureType == GestureTypeOfVolume){
                // 改变声音
                if (offset_y > 0){
                    [self volumeAdd:-VolumeStep];
                }else{
                    [self volumeAdd:VolumeStep];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (_gestureType == GestureTypeOfProgress){
                [self durationSliderDone:playerSlider];
            }
            _gestureType = GestureTypeOfNone;
            [self showProgressView:NO];
            hasPan = NO;
        }
            break;
        default:
            break;
    }
}

// 进度更新
- (void)updateSchedule:(NSTimeInterval)playbackTime totalTime:(NSTimeInterval)videoTime{
    playerSlider.value = videoTime > 0? playbackTime/videoTime:0;
    timeLabel.text = [NSString stringWithFormat:@"%@/%@",  [NSObject formatSecondsToString:playbackTime],  [NSObject formatSecondsToString:videoTime]];
    self.totalVideoTime = videoTime;
}

- (void)updatePlayButtonStatus:(int)statusType {
    bottomView.hidden = NO;
    if (statusType == 1) {
        // 视频播放中
        [pauseButton setImage:[UIImage imageNamed:@"video_PauseButton"] forState:UIControlStateNormal];
        playButton.hidden = YES;
    } else if (statusType == 2){
        // 视频暂停或者停止中
        [pauseButton setImage:[UIImage imageNamed:@"video_PlayButton"] forState:UIControlStateNormal];
        playButton.hidden = NO;
    }else{
        //缓冲
        playButton.hidden = YES;

    }
}

- (void)playerStartPlay:(NSTimeInterval)videoTime {
    playerSlider.enabled = YES;
}

@end
