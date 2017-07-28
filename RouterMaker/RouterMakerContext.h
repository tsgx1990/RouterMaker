//
//  RouterMakerContext.h
//  WebJsonDemo
//
//  Created by guanglong on 2017/7/26.
//  Copyright © 2017年 bjhl. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - -
@interface RouterMakerPath : NSObject

@property (nonatomic, readonly) Class vcClass;

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *query;

@end

#pragma mark - -
@interface RouterMakerContext : NSObject

@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *query;
@property (nonatomic, strong) NSArray<RouterMakerPath*> *routerPaths;

@end

#pragma mark - -
@protocol RouterMakerShowStrategyProtocol <NSObject>

@required
- (void)showRouterMakerContext:(RouterMakerContext *)context;

@end

