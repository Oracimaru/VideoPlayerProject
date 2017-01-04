//
//  DTPlayerControlView.h
//
//  Created by zhanghaibin on 3/18/16.
//  Copyright © 2016 zhanghaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlayEvent) {
    PlayEvent_PreparePlay,            // 准备播放
    PlayEvent_StartPlay,              // 开始播放
    PlayEvent_PlayAndPause,           // 暂停播放
    PlayEvent_FullScreen,             // 全屏播放
    PlayEvent_PlayButton,             // 播放按钮
    PlayEvent_Speed,                  // 播放速度
    PlayEvent_SliderDrag,             // 拖动滚动条
    PlayEvent_SliderDragDone,         // 滚动条拖动完成
    PlayEvent_Timer,                  // 是否开启timer
    PlayEvent_PlayNext,               // 播放下一个
    PlayEvent_Back,                   // 返回
    PlayEvent_Correct,                // 纠错

//    PlayEvent_StartPlay             // 按钮样式
};

@interface DTPlayerControlView : UIView

@property (nonatomic, copy) void (^playerEvent)(id event , PlayEvent eventType);
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, strong) UIButton            *fullScreenButton;  // 全屏按钮
@property (nonatomic, assign) BOOL                 hasVideo;

- (void)updateSchedule:(NSTimeInterval)playbackTime totalTime:(NSTimeInterval)videoTime;
- (void)updatePlayButtonStatus:(int)statusType;
- (void)playerStartPlay:(NSTimeInterval)videoTime;
- (void)showHUD:(BOOL)showHUB;

@end
