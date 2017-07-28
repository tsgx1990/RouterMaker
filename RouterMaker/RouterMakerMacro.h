//
//  RouterMakerMacro.h
//  WebJsonDemo
//
//  Created by guanglong on 2017/7/26.
//  Copyright © 2017年 bjhl. All rights reserved.
//

#ifndef RouterMakerMacro_h
#define RouterMakerMacro_h

#define _RouterMakerContact_4_(_0, _1, _2, _3)          _0##_1##_2##_3
#define _RouterMakerContact_4(_0, _1, _2, _3)           _RouterMakerContact_4_(_0, _1, _2, _3)

#define _RouterMakerContact_2_(_0, _1)                  _0##_1
#define _RouterMakerContact_2(_0, _1)                   _RouterMakerContact_2_(_0, _1)

#define _RouterMakerToString_(_0)                       @#_0
#define _RouterMakerToString(_0)                        _RouterMakerToString_(_0)


//
#pragma mark - - for path component (url path)

#define __RouterMakerPathMapBlockSuffix              $
#define __RouterMakerPathMapBlock(_path)             _RouterMakerContact_2(_path, __RouterMakerPathMapBlockSuffix)

#define _RouterMakerPath(_prefix, _path, _seperator, _class)    \
@property (nonatomic, strong, readonly) RouterMaker *_path; \
@property (nonatomic, class, readonly) RouterMaker *_path; \
@property (nonatomic, copy, readonly) RouterMaker *(^ __RouterMakerPathMapBlock(_path) )(id params) ;  \
@property (nonatomic, class, readonly) RouterMaker *(^ __RouterMakerPathMapBlock(_path) )(id params) ;  \
@property (nonatomic, strong, readonly) _class *_RouterMakerContact_4(_prefix, _path, _seperator, _class) UNAVAILABLE_ATTRIBUTE;

#define __RouterMakerPathMapPrefix              __RouterMakerPath__
#define __RouterMakerPathMapSeperator           $_$_$

#define RouterMakerPathMapPrefix                _RouterMakerToString(__RouterMakerPathMapPrefix)
#define RouterMakerPathMapSeperator             _RouterMakerToString(__RouterMakerPathMapSeperator)
#define RouterMakerPathMapBlockSuffix           _RouterMakerToString(__RouterMakerPathMapBlockSuffix)

#define RouterMaker_Path_O(_path, _class)         _RouterMakerPath(__RouterMakerPathMapPrefix, _path, __RouterMakerPathMapSeperator, _class)


//
#pragma mark - - for open strategy (url host)

#define _RouterMakerHost(_prefix, _host, _seperator, _class) \
@property (nonatomic, class, readonly) RouterMaker *_host;      \
@property (nonatomic, copy, readonly) void (^_host)(id params);  \
@property (nonatomic, strong, readonly) _class *_RouterMakerContact_4(_prefix, _host, _seperator, _class) UNAVAILABLE_ATTRIBUTE;

#define __RouterMakerHostMapPrefix               __RouterMakerHost__
#define __RouterMakerHostMapSeperator            $_$

#define RouterMakerHostMapPrefix                 _RouterMakerToString(__RouterMakerHostMapPrefix)
#define RouterMakerHostMapSeperator              _RouterMakerToString(__RouterMakerHostMapSeperator)

#define RouterMaker_Host_O(_host, _class)          _RouterMakerHost(__RouterMakerHostMapPrefix, _host, __RouterMakerHostMapSeperator, _class)


//
#pragma mark - - host and path protocol

#define RouterMaker_HostProtocol            RouterMakerHostProtocol
#define RouterMaker_PathProtocol            RouterMakerPathProtocol

#define RouterMaker_HostProtocol_Str        _RouterMakerToString(RouterMaker_HostProtocol)
#define RouterMaker_PathProtocol_Str        _RouterMakerToString(RouterMaker_PathProtocol)


//
#pragma mark - - custom scheme

#define _RouterMaker_Contact_3_cut_(_0, _1, _2)   _##_0##_##_1##_##_2##_
#define _RouterMaker_Contact_3_cut(_0, _1, _2)    _RouterMaker_Contact_3_cut_(_0, _1, _2)

#define _RouterMaker_CustomScheme_(_custom_scheme, _counter) \
\
@interface NSObject (_RouterMaker_Contact_3_cut(_custom_scheme, _counter, __LINE__))  \
@end \
\
@implementation NSObject (_RouterMaker_Contact_3_cut(_custom_scheme, _counter, __LINE__))    \
+ (void)load    \
{   \
    [RouterMaker resetScheme:@#_custom_scheme];  \
}   \
@end

// default scheme
#define RouterMaker_DefaultScheme                       @"lgl"
#define RouterMaker_CustomScheme_O(_custom_scheme)      _RouterMaker_CustomScheme_(_custom_scheme, __COUNTER__)


//
#pragma mark - - custom hosts and paths

#define RouterMaker_CustomHostsAndPaths_O(_custom_hosts, _custom_paths)    \
\
@protocol RouterMaker_HostProtocol <NSObject>   \
@optional   \
_custom_hosts    \
@end    \
\
\
@protocol RouterMaker_PathProtocol <NSObject>   \
@optional   \
_custom_paths    \
@end    \
\
@interface RouterMaker (_) <RouterMaker_HostProtocol, RouterMaker_PathProtocol>     \
@end    \
\
@implementation RouterMaker (_)     \
@end    \


#endif /* RouterMakerMacro_h */
