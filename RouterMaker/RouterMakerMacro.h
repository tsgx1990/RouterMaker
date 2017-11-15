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

#define __RouterMakerPathMapBlockSuffix             $
#define __RouterMakerPathMapBlock(_path)            _RouterMakerContact_2(_path, __RouterMakerPathMapBlockSuffix)

//#define RouterMaker_DynamicMap                      _router_maker_dynamic_map_
//#define RouterMaker_DynamicMap_Key(_key)            _RouterMakerContact_2(RouterMaker_DynamicMap, _key)
//
//#define RouterMaker_DynamicImp                      _router_maker_dynamic_imp_
//#define RouterMaker_DynamicImpCls                   _RouterMakerContact_2(RouterMaker_DynamicImp, _$$$_)
//#define RouterMaker_DynamicImpIns                   _RouterMakerContact_2(RouterMaker_DynamicImp, _$_$_)
//
//#define RouterMaker_DynamicImpCls_Path(_path)       _RouterMakerContact_2(RouterMaker_DynamicImpCls, _path)
//#define RouterMaker_DynamicImpIns_Path(_path)       _RouterMakerContact_2(RouterMaker_DynamicImpIns, _path)
//
//#define RouterMaker_DynamicImpCls_BlockPath(_path)     \
//    _RouterMakerContact_2(RouterMaker_DynamicImpCls, __RouterMakerPathMapBlock(_path))
//#define RouterMaker_DynamicImpIns_BlockPath(_path)     \
//    _RouterMakerContact_2(RouterMaker_DynamicImpIns, __RouterMakerPathMapBlock(_path))
//
//#define RouterMaker_DynamicImpProperty(_key)      \
//    property (nonatomic, class, readonly) void( *_key )(id, SEL);   \


#define _RouterMakerPath(_prefix, _path, _seperator, _class)    \
@property (nonatomic, strong, readonly) RouterMaker *_path; \
@property (nonatomic, class, readonly) RouterMaker *_path; \
@property (nonatomic, copy, readonly) RouterMaker *(^ __RouterMakerPathMapBlock(_path) )(id params) ;  \
@property (nonatomic, class, readonly) RouterMaker *(^ __RouterMakerPathMapBlock(_path) )(id params) ;  \
@property (nonatomic, strong, readonly) _class *_RouterMakerContact_4(_prefix, _path, _seperator, _class) UNAVAILABLE_ATTRIBUTE;    \
//@RouterMaker_DynamicImpProperty( RouterMaker_DynamicImpCls_Path(_path) )    \
//@RouterMaker_DynamicImpProperty( RouterMaker_DynamicImpIns_Path(_path) ) \
//@RouterMaker_DynamicImpProperty( RouterMaker_DynamicImpCls_BlockPath(_path) )    \
//@RouterMaker_DynamicImpProperty( RouterMaker_DynamicImpIns_BlockPath(_path) )    \


#define __RouterMakerPathMapPrefix              __RouterMakerPath__
#define __RouterMakerPathMapSeperator           $_$_$


#define RouterMakerPathMapPrefix                _RouterMakerToString(__RouterMakerPathMapPrefix)
#define RouterMakerPathMapSeperator             _RouterMakerToString(__RouterMakerPathMapSeperator)
#define RouterMakerPathMapBlockSuffix           _RouterMakerToString(__RouterMakerPathMapBlockSuffix)

#define RouterMaker_Path_O(_path, _class)         \
    _RouterMakerPath(__RouterMakerPathMapPrefix, _path, __RouterMakerPathMapSeperator, _class)


//
#pragma mark - - for open strategy (url host)

#define _RouterMakerHost(_prefix, _host, _seperator, _class) \
@property (nonatomic, class, readonly) RouterMaker *_host;      \
@property (nonatomic, copy, readonly) void (^_host)(id params);  \
@property (nonatomic, strong, readonly) _class *_RouterMakerContact_4(_prefix, _host, _seperator, _class) UNAVAILABLE_ATTRIBUTE;    \
//@RouterMaker_DynamicImpProperty( RouterMaker_DynamicImpCls_Path(_host) )     \
//@RouterMaker_DynamicImpProperty( RouterMaker_DynamicImpIns_Path(_host) )     \


#define __RouterMakerHostMapPrefix               __RouterMakerHost__
#define __RouterMakerHostMapSeperator            $_$

#define RouterMakerHostMapPrefix                 _RouterMakerToString(__RouterMakerHostMapPrefix)
#define RouterMakerHostMapSeperator              _RouterMakerToString(__RouterMakerHostMapSeperator)

#define RouterMaker_Host_O(_host, _class)          \
    _RouterMakerHost(__RouterMakerHostMapPrefix, _host, __RouterMakerHostMapSeperator, _class)


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


#define RouterMaker_HostProto               _host_proto_
#define RouterMaker_PathProto               _path_proto_
#define RouterMaker_ProtoSeperator          ___0_0___

#define RouterMaker_HostProto_Str           _RouterMakerToString(RouterMaker_HostProto)
#define RouterMaker_PathProto_Str           _RouterMakerToString(RouterMaker_PathProto)
#define RouterMaker_ProtoSeperator_Str      _RouterMakerToString(RouterMaker_ProtoSeperator)


// 此处的 +load 方法是为了使 _class 类完成类加载，这样才能根据 NSClassFromString() 得到类对象
#define _RouterMaker_Add_Interface_Proto_(_proto_name, _class)     \
@interface RouterMaker ( _proto_name ) <_proto_name>     \
@end    \
\
@implementation RouterMaker ( _proto_name )     \
+ (void)load {      \
    [_class class];     \
}        \
@end    \


#define _RouterMaker_Config_Host_(_host, _class, _proto_name)    \
\
@protocol _proto_name <NSObject>     \
@optional   \
RouterMaker_Host_O(_host, _class) \
@end    \
\
_RouterMaker_Add_Interface_Proto_(_proto_name, _class)


#define _RouterMaker_Config_Path_(_path, _class, _proto_name)   \
\
@protocol _proto_name <NSObject>     \
@optional   \
RouterMaker_Path_O(_path, _class)   \
@end    \
\
_RouterMaker_Add_Interface_Proto_(_proto_name, _class)


#define _RouterMaker_Contact_Proto(_proto, _key, _value)    \
_RouterMakerContact_4   \
(    \
    _RouterMakerContact_2(_proto, __COUNTER__),  \
    _RouterMakerContact_2(_, __LINE__),  \
    _RouterMakerContact_2(RouterMaker_ProtoSeperator, _key),     \
    _RouterMakerContact_2(RouterMaker_ProtoSeperator, _value) \
)


#define RouterMaker_ConfigHost_O(_host, _class)  \
    _RouterMaker_Config_Host_(_host, _class, _RouterMaker_Contact_Proto(RouterMaker_HostProto, _host, _class))

#define RouterMaker_ConfigPath_O(_path, _class)  \
    _RouterMaker_Config_Path_(_path, _class, _RouterMaker_Contact_Proto(RouterMaker_PathProto, _path, _class))



#endif /* RouterMakerMacro_h */
