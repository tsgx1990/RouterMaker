//
//  RouterMakerConfig.h
//  RouterMakerDemo
//
//  Created by guanglong on 2017/7/28.
//  Copyright © 2017年 bjhl. All rights reserved.
//

#import "RouterMaker.h"

#import "Push.h"
#import "Present.h"
#import "Home.h"

//#import "ViewC1.h"
//#import "ViewC2.h"
//#import "ViewC3.h"


RouterMaker_CustomScheme(tsgx)

RouterMaker_ConfigHost(push, Push)
RouterMaker_ConfigHost(present, Present)
RouterMaker_ConfigHost(home, Home)


//RouterMaker_ConfigPath(vc1, ViewC1)
//RouterMaker_ConfigPath(vc2, ViewC2)
//RouterMaker_ConfigPath(vc3, ViewC3)


//@protocol __host_proto__211_45_ <NSObject>
//
//@optional
//- (id)name123;
//
//@end
//
//
//@interface RouterMaker ( __host_proto__2_45_1 ) <__host_proto__211_45_>
//
//
//@end
//
//
//@implementation RouterMaker ( __host_proto__2_45_1 )
//
////- (id)name123
////{
////    return @"fuck";
////}
//
//@end


@interface RouterMakerConfig : RouterMaker

//@property (nonatomic, readonly) void(*ptr)(id, SEL);

@end


