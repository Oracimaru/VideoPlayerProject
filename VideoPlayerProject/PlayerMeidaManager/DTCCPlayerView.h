//
//  DTCCPlayerView.h
//  
//
//  Created by zhanghaibin on 12/23/15.
//  Copyright © 2015 zhanghaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTCCPlayerView : UIView

// 播放列表
@property (nonatomic, copy) void (^onEvent)(id event);
@property (nonatomic, assign) BOOL  shouldPause;/**< 是否暂停 */

@property (nonatomic, copy) void (^playerStatic) (id playState);

;/**<    */
// 暂停播放
- (void)pausePlay;
// 停止播放
- (void)stopPlay;
- (void)doForceScreenRotate;
// 开始播放
- (void)startPlayURL:(NSURL*)ccid isStartNow:(BOOL)isStart ;
@end
