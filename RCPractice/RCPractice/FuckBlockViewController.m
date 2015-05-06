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
    
//    As a local variable:
//    returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
    void (^blockName)(int i) = ^(int j){
        NSLog(@"%d", j);
    };
    blockName(5);

    
//    As an argument to a method call:
//    [someObject someMethodThatTakesABlock:^returnType (parameters) {...}];
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
