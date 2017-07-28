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

#import "ViewC1.h"
#import "ViewC2.h"
#import "ViewC3.h"


RouterMaker_CustomScheme(tsgx)

RouterMaker_CustomHostsAndPaths
(
    RouterMaker_Host(push,              Push)
    RouterMaker_Host(present,           Present)
    RouterMaker_Host(home,              Home)
 
,
 
    RouterMaker_Path(vc1,               ViewC1)
    RouterMaker_Path(vc2,               ViewC2)
    RouterMaker_Path(vc3,               ViewC3)
 
)


@interface RouterMakerConfig : RouterMaker

@end


