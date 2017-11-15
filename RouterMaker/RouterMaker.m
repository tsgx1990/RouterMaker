//
//  RouterMaker.m
//  WebJsonDemo
//
//  Created by guanglong on 2017/7/24.
//  Copyright © 2017年 bjhl. All rights reserved.
//

#import "RouterMaker.h"
#import <objc/runtime.h>

static NSString *currentRouterScheme = RouterMaker_DefaultScheme;

static NSDictionary *_routerHostClassMap = nil;
static NSDictionary *_routerPathClassMap = nil;

static void _getRouterKeyClassMap()
{
    unsigned int count = 0;
    Protocol * __unsafe_unretained * protoList = class_copyProtocolList([RouterMaker class], &count);
    
    NSMutableSet *mProtoNames = nil;
    if (count > 0) {
        mProtoNames = [NSMutableSet setWithCapacity:6];
        for (int i=0; i<count; i++) {
            Protocol *proto = protoList[i];
            NSLog(@"proto: %@", NSStringFromProtocol(proto));
            [mProtoNames addObject:proto];
        }
    }
    free(protoList);
    
    if (!mProtoNames.count) {
        return;
    }
    
    NSMutableDictionary *mHostMap = nil;
    NSMutableDictionary *mPathMap = nil;
    
    for (Protocol *proto in mProtoNames) {
        
        NSString *protoName = NSStringFromProtocol(proto);
        
        if ([protoName hasPrefix:RouterMaker_HostProto_Str]) {
            
            NSArray *arr = [protoName componentsSeparatedByString:RouterMaker_ProtoSeperator_Str];
            if (!mHostMap) {
                mHostMap = [NSMutableDictionary dictionaryWithCapacity:3];
            }
            [mHostMap setValue:NSClassFromString(arr.lastObject) forKey:arr[arr.count-2]];
            
        }
        if ([protoName hasPrefix:RouterMaker_PathProto_Str]) {
            
            NSArray *arr = [protoName componentsSeparatedByString:RouterMaker_ProtoSeperator_Str];
            if (!mPathMap) {
                mPathMap = [NSMutableDictionary dictionaryWithCapacity:3];
            }
            [mPathMap setValue:NSClassFromString(arr.lastObject) forKey:arr[arr.count-2]];
        }
    }
    
    _routerHostClassMap = mHostMap.copy;
    _routerPathClassMap = mPathMap.copy;
}

#pragma mark - - get url path and host map
static NSDictionary *routerHostClassMap()
{
    if (!_routerHostClassMap) {
        _getRouterKeyClassMap();
    }
    return _routerHostClassMap;
}

static NSDictionary *routerPathClassMap()
{
    if (!_routerPathClassMap) {
        _getRouterKeyClassMap();
    }
    return _routerPathClassMap;
}

#pragma mark - -
@interface RouterMakerPath ()

@property (nonatomic) Class vcClass;

@end

@implementation RouterMakerPath

- (void)setPath:(NSString *)path
{
    _path = path;
    _vcClass = routerPathClassMap()[_path];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<path: %@> <params: %@> <vcClass: %@>", self.path, self.params, self.vcClass];
}

@end

#pragma mark - -
@interface RouterMakerContext ()

@end

@implementation RouterMakerContext

- (NSString *)description
{
    return [NSString stringWithFormat:@"<scheme: %@> \n<host: %@> \n<params: %@> \n<routerPaths: %@>", self.scheme, self.host, self.params, self.routerPaths];
}

@end

@interface RouterMaker()

@property (nonatomic, copy) NSString *urlSchemeStr;
@property (nonatomic, copy) NSString *urlHostStr;
@property (nonatomic, strong) NSMutableArray<RouterMakerPath*> *routerMakerPaths;

- (void)_showUsingStrategyWithParams:(id)params;

@end

static NSString *trimmedStringOfSel(SEL sel)
{
    NSString *selStr = NSStringFromSelector(sel);
    NSString *trimStr = [selStr substringToIndex:selStr.length - RouterMakerPathMapBlockSuffix.length];
    return trimStr;
}

// 
static RouterMaker *cls_routerHostKeyGetter(Class self, SEL _cmd)
{
    RouterMaker *maker = [self new];
    maker.urlHostStr = NSStringFromSelector(_cmd);
    return maker;
}

static void ( ^ins_routerHostKeyGetter(RouterMaker *self, SEL _cmd) ) (id)
{
    self.urlHostStr = NSStringFromSelector(_cmd);
    id blk = ^(id params) {
        [self _showUsingStrategyWithParams:params];
    };
    return blk;
}

//
static RouterMaker *cls_routerPathKeyGetter(Class self, SEL _cmd)
{
    RouterMaker *maker = [self new];
    RouterMakerPath *path = [RouterMakerPath new];
    path.path = NSStringFromSelector(_cmd);
    [maker.routerMakerPaths addObject:path];
    return maker;
}

static RouterMaker *ins_routerPathKeyGetter(RouterMaker *self, SEL _cmd)
{
    RouterMakerPath *path = [RouterMakerPath new];
    path.path = NSStringFromSelector(_cmd);
    [self.routerMakerPaths addObject:path];
    return self;
}

static RouterMaker *( ^$_cls_routerPathKeyBlockGetter(Class self, SEL _cmd) ) (id)
{
    id blk = ^(id params) {
        
        RouterMaker *maker = [self new];
        RouterMakerPath *path = [RouterMakerPath new];
        path.path = trimmedStringOfSel(_cmd);
        path.params = params;
        [maker.routerMakerPaths addObject:path];
        return maker;
    };
    return blk;
}

static RouterMaker *( ^$_ins_routerPathKeyBlockGetter(RouterMaker *self, SEL _cmd) ) (id)
{
    id blk = ^(id params) {
        
        RouterMakerPath *path = [RouterMakerPath new];
        path.path = trimmedStringOfSel(_cmd);
        path.params = params;
        [self.routerMakerPaths addObject:path];
        return self;
    };
    return blk;
}

#pragma mark - -
@implementation RouterMaker

- (instancetype)init
{
    if (self = [super init]) {
        self.urlSchemeStr = currentRouterScheme;
        self.routerMakerPaths = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selStr = NSStringFromSelector(sel);
    if (routerPathClassMap()[selStr]) {
        return class_addMethod(self, sel, (IMP)ins_routerPathKeyGetter, "@@:");
    }
    
    if (routerHostClassMap()[selStr]) {
        return class_addMethod(self, sel, (IMP)ins_routerHostKeyGetter, "@@:");
    }
    
    if (routerPathClassMap()[trimmedStringOfSel(sel)]) {
        return class_addMethod(self, sel, (IMP)$_ins_routerPathKeyBlockGetter, "@@:");
    }
    
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (routerHostClassMap()[NSStringFromSelector(sel)]) {
//        此处 objc_getMetaClass(class_getName(self)) 等价于 object_getClass(self)
        return class_addMethod(object_getClass(self), sel, (IMP)cls_routerHostKeyGetter, "@#:");
    }
    
    if (routerPathClassMap()[NSStringFromSelector(sel)]) {
        return class_addMethod(object_getClass(self), sel, (IMP)cls_routerPathKeyGetter, "@#:");
    }
    
    if (routerPathClassMap()[trimmedStringOfSel(sel)]) {
        return class_addMethod(object_getClass(self), sel, (IMP)$_cls_routerPathKeyBlockGetter, "@#:");
    }
    
    return [super resolveClassMethod:sel];
}

#pragma mark - - toString
- (NSString *)string
{
    NSString *hostComponent = self.urlHostStr.length ? [self.urlHostStr stringByAppendingString:@"/"]: @"";
    
    NSMutableArray *mUrlPaths = [NSMutableArray arrayWithCapacity:2];
    for (RouterMakerPath *path in self.routerMakerPaths) {
        [mUrlPaths addObject:path.path];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@%@", self.urlSchemeStr, hostComponent, [mUrlPaths componentsJoinedByString:@"/"]];
    return urlStr;
}

- (NSString *(^)(NSString *))toString
{
    id toStrBlock = ^(NSString *query){
        return query.length ? [NSString stringWithFormat:@"%@?%@", self.string, query] : self.string;
    };
    return toStrBlock;
}

#pragma mark - - show style
- (void (^)(id, void (^)(RouterMakerContext *)))show
{
    id showBlock = ^(id params, void(^how)()) {
        if (how) {
            RouterMakerContext *context = [self _routerMakerContextWithParams:params];
            how(context);
        }
        else {
            [self _showUsingStrategyWithParams:params];
        }
    };
    return showBlock;
}

- (void (^)(id))open
{
    id openBlock = ^(id params) {
        [self _showUsingStrategyWithParams:params];
    };
    return openBlock;
}

- (void)showContext:(RouterMakerContext *)context
{
    if (!context.host.length) {
        NSLog(@"nil host for context:\n%@\n", context);
        return;
    }
    
    Class strategyClass = routerHostClassMap()[context.host];
    if (!strategyClass) {
        NSLog(@"no corresponding strategyClass for context:\n%@\n", context);
        return;
    }
    
    id<RouterMakerShowStrategyProtocol> strategy = [strategyClass new];
    [strategy showRouterMakerContext:context];
}

+ (NSString *)resetScheme:(NSString *)scheme
{
    if (!scheme.length) {
        return currentRouterScheme;
    }
    NSString *prevScheme = currentRouterScheme;
    currentRouterScheme = scheme;
    return prevScheme;
}

- (RouterMakerContext *)_routerMakerContextWithParams:(id)params
{
    RouterMakerContext *context = [RouterMakerContext new];
    context.scheme = self.urlSchemeStr;
    context.host = self.urlHostStr;
    context.routerPaths = self.routerMakerPaths;
    context.params = params;
    return context;
}

- (void)_showUsingStrategyWithParams:(id)params
{
    RouterMakerContext *context = [self _routerMakerContextWithParams:params];
    [self showContext:context];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end

