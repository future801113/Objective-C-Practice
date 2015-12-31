//
//  Config.h
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/23.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#ifndef NeiooPlayground_Config_h
#define NeiooPlayground_Config_h

#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

#define kStatusBarHeight 20.f

#define kNavigationBarHeight 44.f

//#define NEIOO_APP_KEY @"vxkyRQq7sVeL9k2DUkGahre0tog0tU5L"
//#define NEIOO_APP_KEY @"Lqe301muvNmCjSiITbCJMXo40ED9Ioyy"
//#define NEIOO_APP_KEY @"IC8E3EbQtGkELQ63IposCdUn6kpqL7Ut"
#define NEIOO_APP_KEY @"IC8E3EbQtGkELQ63IposCdUn6kpqL7Ut"

#define NEIOO_SPACE_LIST_API @"http://cloud.lightspeedmbs.com/v2/objects/space/query.json"

#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

///Label Title
#define SEARCHING_TEXT      @"搜尋附近商場..."

#define RADAR_NAV_TEXT      @"搜尋"
#define ACTIVITY_NAV_TEXT   @"活動資訊"
#define PLACE_LIST_NAV_TEXT @"合作場域"

#define BLUETOOTH_TIP       @"請開啟藍牙體驗服務"

#define PLACE_LIST_CACHE    @"co.herxun.place_cache"
#endif
