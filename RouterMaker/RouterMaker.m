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

#pragma mark - - get url path and host map
static NSDictionary *routerHostClassMap()
{
    static NSDictionary *routerHostClassMap = nil;
    if (routerHostClassMap) {
        return routerHostClassMap;
    }
    
    unsigned int count = 0;
    Protocol *proto = NSProtocolFromString(RouterMaker_HostProtocol_Str);
    objc_property_t *propertyList = protocol_copyPropertyList(proto, &count);
    
    if (count > 0) {
        
        NSMutableDictionary *hostClassMap = [NSMutableDictionary dictionaryWithCapacity:3];
        for(int i=0;i<count;i++) {
            objc_property_t property = propertyList[i];
            const char* propertyName = property_getName(property);
            NSString *proName = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
            
            if ([proName hasPrefix:RouterMakerHostMapPrefix]) {
                NSString *mapStr = [proName substringFromIndex:RouterMakerHostMapPrefix.length];
                NSArray *mapArr = [mapStr componentsSeparatedByString:RouterMakerHostMapSeperator];
                [hostClassMap setValue:NSClassFromString(mapArr[1]) forKey:mapArr[0]];
            }
        }
        routerHostClassMap = [hostClassMap copy];
    }
    free(propertyList);
    return routerHostClassMap;
}

static NSDictionary *routerPathClassMap()
{
    static NSDictionary *routerPathClassMap = nil;
    if (routerPathClassMap) {
        return routerPathClassMap;
    }
    
    unsigned int count = 0;
    Protocol *proto = NSProtocolFromString(RouterMaker_PathProtocol_Str);
    objc_property_t *propertyList =  protocol_copyPropertyList(proto, &count);
    
    if (count > 0) {
        
        NSMutableDictionary *pathClassMap = [NSMutableDictionary dictionaryWithCapacity:3];
        for(int i=0;i<count;i++) {
            objc_property_t property = propertyList[i];
            const char* propertyName = property_getName(property);
            NSString *proName = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
            
            if ([proName hasPrefix:RouterMakerPathMapPrefix]) {
                NSString *mapStr = [proName substringFromIndex:RouterMakerPathMapPrefix.length];
                NSArray *mapArr = [mapStr componentsSeparatedByString:RouterMakerPathMapSeperator];
                [pathClassMap setValue:NSClassFromString(mapArr[1]) forKey:mapArr[0]];
            }
        }
        routerPathClassMap = [pathClassMap copy];
    }
    free(propertyList);
    return routerPathClassMap;
}

static NSString *validQueryOrNil(NSString *query)
{
//    return [query isKindOfClass:[NSString class]] ? query : nil;
    return query;
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
    return [NSString stringWithFormat:@"<path: %@> <query: %@> <vcClass: %@>", self.path, self.query, self.vcClass];
}

@end

#pragma mark - -
@interface RouterMakerContext ()

@end

@implementation RouterMakerContext

- (NSString *)description
{
    return [NSString stringWithFormat:@"<scheme: %@> \n<host: %@> \n<query: %@> \n<routerPaths: %@>", self.scheme, self.host, self.query, self.routerPaths];
}

@end

@interface RouterMaker()

@property (nonatomic, copy) NSString *urlSchemeStr;
@property (nonatomic, copy) NSString *urlHostStr;
@property (nonatomic, strong) NSMutableArray<RouterMakerPath*> *routerMakerPaths;

- (void)_showUsingStrategyWithQuery:(NSString *)query;

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

static void ( ^ins_routerHostKeyGetter(RouterMaker *self, SEL _cmd) ) (NSString *)
{
    self.urlHostStr = NSStringFromSelector(_cmd);
    id blk = ^(NSString *query) {
        [self _showUsingStrategyWithQuery:query];
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

static RouterMaker *( ^$_cls_routerPathKeyBlockGetter(Class self, SEL _cmd) ) (NSString *)
{
    id blk = ^(NSString *query) {
        
        RouterMaker *maker = [self new];
        RouterMakerPath *path = [RouterMakerPath new];
        path.path = trimmedStringOfSel(_cmd);
        path.query = validQueryOrNil(query);
        [maker.routerMakerPaths addObject:path];
        return maker;
    };
    return blk;
}

static RouterMaker *( ^$_ins_routerPathKeyBlockGetter(RouterMaker *self, SEL _cmd) ) (NSString *)
{
    id blk = ^(NSString *query) {
        
        RouterMakerPath *path = [RouterMakerPath new];
        path.path = trimmedStringOfSel(_cmd);
        path.query = validQueryOrNil(query);
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
- (void (^)(NSString *, void (^)(RouterMakerContext *)))show
{
    id showBlock = ^(NSString *query, void(^how)()) {
        if (how) {
            RouterMakerContext *context = [self _routerMakerContextWithQuery:query];
            how(context);
        }
        else {
            [self _showUsingStrategyWithQuery:query];
        }
    };
    return showBlock;
}

- (void (^)(NSString *))open
{
    id openBlock = ^(NSString *query) {
        [self _showUsingStrategyWithQuery:query];
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

- (RouterMakerContext *)_routerMakerContextWithQuery:(NSString *)query
{
    RouterMakerContext *context = [RouterMakerContext new];
    context.scheme = self.urlSchemeStr;
    context.host = self.urlHostStr;
    context.routerPaths = self.routerMakerPaths;
    context.query = validQueryOrNil(query);
    return context;
}

- (void)_showUsingStrategyWithQuery:(NSString *)query
{
    RouterMakerContext *context = [self _routerMakerContextWithQuery:query];
    [self showContext:context];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
