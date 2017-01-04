//
//  UIGlobal.h
//  appgame
//
//  Created by ZHB on 13-12-21.
//  Copyright (c) 2013年 ZHB. All rights reserved.
//

#ifndef kaoyan_UIGlobal_h
#define kaoyan_UIGlobal_h

//定义应用屏幕大小
#define DT_APP_FRAME  [UIScreen mainScreen].bounds

//iphone设备
#define isIphone ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)

//小屏手机
#define isIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//ipad设备
#define isIpad ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

//获取系统版本
#define DT_IOS_VERSION ([[UIDevice currentDevice].systemVersion floatValue])

//定义网络状态检测
#define NO_NET_WORK [Reachability reachabilityWithHostName:@"www.baidu.com"].currentReachabilityStatus == NotReachable

#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

//当前屏幕高度
#define DT_SCREEN_MAIN_HEIGHT [[UIScreen mainScreen] bounds].size.height

//当前屏幕宽度
#define DT_SCREEN_MAIN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define DT_SCREEN_MAIN_COMPAREWIDTH    [[UIScreen mainScreen] bounds].size.width/375

//顶部nav导航+状态条
#define DT_SCREEN_NAV_HEIGHT 64

//底部工具条
#define DT_SCREEN_TOOL_HEIGHT 49
#define DT_SCREEN_NavTabHeight 113//64+49

//可视区域-不包括工具条
#define DT_SCREEN_SHOW_HEIGHT (DT_SCREEN_MAIN_HEIGHT-DT_SCREEN_NAV_HEIGHT)

//可视区域包括工具条
#define DT_SCREEN_SHOW_T_HEIGHT (DT_SCREEN_SHOW_HEIGHT-DT_SCREEN_TOOL_HEIGHT)

// 画一像素的线
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)



#endif
