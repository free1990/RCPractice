//
//  FuckBlockViewController.m
//  RCPractice
//
//  Created by John on 15/5/6.
//  Copyright (c) 2015年 WorkMac. All rights reserved.
//

#import "FuckBlockViewController.h"

@interface FuckBlockViewController ()

@end

@implementation FuckBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //在block中
    //声明block都是 返回值 （^名字） 参数；【typedef、@@property以及直接声明变量】
    //在作为函数的参数形参的时候由于传进去是block类型，不需要名字”(int (^)(int j))“+名字，
    //赋值的情况，普通赋值、还有作为函数实参，这个时候^在最前面，然后是（返回值(参数)）
    
//    As a local variable:
//    returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
    int (^blockName)(int i) = ^int(int j){
        return j*5;
    };
    blockName(5);

    
//    As an argument to a method call:
//    [someObject someMethodThatTakesABlock:^returnType (parameters) {...}];
    [self someMethodThatTakesABlock:blockName];
    //or
    [self someMethodThatTakesABlock:^int(int j) {
        return j*10;
    }];
    
}


//As a method parameter:
//- (void)someMethodThatTakesABlock:(returnType (^)(parameterTypes))blockName;
- (void)someMethodThatTakesABlock:(int (^)(int j))blockName
{
    int test = blockName(5);
    NSLog(@"--->   %d", test);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
