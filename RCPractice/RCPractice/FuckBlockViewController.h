//
//  FuckBlockViewController.h
//  RCPractice
//
//  Created by John on 15/5/6.
//  Copyright (c) 2015年 WorkMac. All rights reserved.
//

#import <UIKit/UIKit.h>

//As a typedef:
//typedef returnType (^TypeName)(parameterTypes);
//TypeName blockName = ^returnType(parameters) {...};

typedef int (^testBlock)(int i, int j);

@interface FuckBlockViewController : UIViewController

//As a property:
//@property (nonatomic, copy) returnType (^blockName)(parameterTypes);
@property (nonatomic, copy) int(^blockName)(int);

@property (nonatomic, strong) testBlock test;
@end
