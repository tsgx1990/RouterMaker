//
//  RouterMaker.h
//  WebJsonDemo
//
//  Created by guanglong on 2017/7/24.
//  Copyright © 2017年 bjhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterMakerContext.h"
#import "RouterMakerMacro.h"

@interface RouterMaker : NSObject

@property (nonatomic, copy, readonly) NSString *string;

@property (nonatomic, copy, readonly) NSString *(^toString)(NSString *urlQuery);

@property (nonatomic, copy, readonly) void(^show)(NSString *urlQuery, void(^how)(RouterMakerContext *context));


/**
 可带参数 urlQuery，也可以什么都不传
 */
@property (nonatomic, copy, readonly) void(^open)(/* NSString *urlQuery */);

/**
 对于从后台获取的 routerUrl 及其参数，可以将其解析成 RouterMakerContext 对象，然后调用此方法进行跳转

 @param context RouterMakerContext对象
 */
- (void)showContext:(RouterMakerContext *)context;


/**
 默认的 scheme 为 RouterMaker_DefaultScheme，重置后，返回之前的 scheme；
 如果传 nil，scheme将不会被重置，但会返回当前的 scheme；
 如果想全局修改，请在使用 RouterMaker 之前调用该方法

 @param scheme 重置后的scheme
 @return 重置之前的scheme
 */
+ (NSString *)resetScheme:(NSString *)scheme;

@end


