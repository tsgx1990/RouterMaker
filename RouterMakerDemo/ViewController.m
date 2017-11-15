//
//  ViewController.m
//  RouterMakerDemo
//
//  Created by guanglong on 2017/7/28.
//  Copyright © 2017年 bjhl. All rights reserved.
//

#import "ViewController.h"
#import "RouterMakerConfig.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSStringFromClass(self.class);
    
    RouterMaker.home.vc1.vc2$(@"ok=yes").open(nil);
    RouterMaker.vc2.vc1$(@"u=iii").push(nil);
    RouterMaker.vc3$(nil).vc1$(nil).vc2$(nil).home(nil);
    
    RouterMaker.present.vc1.push(@"a=hh&b=ll"); // push 方式将覆盖掉 present 方式，一般不要这么写
    
    RouterMaker.push.vc3$(@"name=yl&age=5").open(nil);
    RouterMaker.vc2$(@"page=10&type=3").present(nil);
    RouterMaker.vc3.push(@"si=9&sex=female");
    
//    RouterMaker.;
    

//    NSLog(@"%@", [RouterMaker new].name1);
    
    NSLog(@"%@", _RouterMakerToString(RouterMaker_ConfigHost(push, Push)));
    NSLog(@"%@", _RouterMakerToString(RouterMaker_ConfigPath(vc1, ViewC1)));
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    RouterMaker.vc3.home(@"si=9&sex=female");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
