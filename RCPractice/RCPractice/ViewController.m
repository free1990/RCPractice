//
//  ViewController.m
//  RCPractice
//
//  Created by John on 15/5/5.
//  Copyright (c) 2015年 WorkMac. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "RWDummySignInService.h"
#import "FuckBlockViewController.h"

@interface ViewController ()
{
    UITextField *_nameTF;
    UIButton *_submitBTN;
}

@property (strong, nonatomic) RWDummySignInService *signInService;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FuckBlockViewController *fuckBlock = [[FuckBlockViewController alloc] init];
    [self.view addSubview:fuckBlock.view];
    [self addChildViewController:fuckBlock];
    
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    _nameTF.backgroundColor = [UIColor redColor];
    [self.view addSubview:_nameTF];
    
    _submitBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBTN.frame = CGRectMake(100, 200, 100, 40);
    _submitBTN.backgroundColor = [UIColor blueColor];
    [_submitBTN setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:_submitBTN];
    
//    //next信号直接输出内容
//    [_nameTF.rac_textSignal subscribeNext:^(id x){
//        NSLog(@"%@", x);
//    }];
    
//    //设置信号的过滤(长度>3输出字符串) rec_textSigal -> filter(length>3) -> subscribeNext
//    [[_nameTF.rac_textSignal filter:^BOOL(id value){
//          NSString *text = value;
//          return text.length > 3;
//    }]
//     subscribeNext:^(id x){
//         NSLog(@"%@", x);
//     }];
    
//    //map把接受到得数据经过加工返回给singal next中的id  rec_textSigal -> map->filter(value>3) -> subscribeNext    [NSString - > NSNumber]
//    [[[_nameTF.rac_textSignal map:^id(NSString*text){
//           return @(text.length);
//       }]
//    filter:^BOOL(NSNumber*length){//filter之后的数据编程NSNumber
//      return[length integerValue] > 3;
//    }]
//    subscribeNext:^(id x){
//     NSLog(@"%@", x);
//    }];
    
    //更容易理解的代码
//    RACSignal *usernameSourceSignal = _nameTF.rac_textSignal;
//    
//    RACSignal *filteredUsername = [usernameSourceSignal
//                                  filter:^BOOL(id value){
//                                      NSString*text = value;
//                                      return text.length > 3;
//                                  }];
//    
//    [filteredUsername subscribeNext:^(id x){
//        NSLog(@"%@", x);
//    }];
    
    
    //原理rac_textSignal(NSString) ->map(Bool)-> map(UIColor) -> backgroundColor
    RACSignal *validUsernameSignal = [_nameTF.rac_textSignal
                                      map:^id(NSString *text){
                                          return @([self isValidUsername:text]);
                                      }];
    
    ///  RAC(self, objectProperty) = objectSignal;
    ///  RAC(self, stringProperty, @"foobar") = stringSignal;
    ///  RAC(self, integerProperty, @42) = integerSignal;
    
    RAC(_nameTF, backgroundColor) =
    [validUsernameSignal map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor greenColor]:[UIColor yellowColor];
    }];
    
    RAC(_nameTF, textColor) =
    [validUsernameSignal map:^id(NSNumber *passwordValid){
        return[passwordValid boolValue] ? [UIColor yellowColor]:[UIColor greenColor];
    }];
    
//    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal]
//                                                      reduce:^id(NSNumber*usernameValid){
//                                                            return @([usernameValid boolValue]);
//                                                      }];
//    
//    [[_submitBTN rac_signalForControlEvents:UIControlEventTouchUpInside]
//     subscribeNext:^(id x) {
//         NSLog(@"button clicked");
//     }];
    
    //两个信号（rac_signalForControlEvents -》 map -> RACSignal）
    [[[_submitBTN rac_signalForControlEvents:UIControlEventTouchUpInside]
      map:^id(id x){
          return[self signInSignal];
      }]
     subscribeNext:^(id x){
         NSLog(@"Sign in result: %@", x);
     }];
    
    
    //使用flattenMap优化
    [[[_submitBTN rac_signalForControlEvents:UIControlEventTouchUpInside]
      flattenMap:^id(id x){
          return [self signInSignal];
      }]
     subscribeNext:^(NSNumber*signedIn){
         //业务成功的逻辑
//         BOOL success =[signedIn boolValue];
//         self.signInFailureText.hidden = success;
//         if(success){
//             [self performSegueWithIdentifier:@"signInSuccess" sender:self];
//         }
     }];
    
    
    //最终
    [[[[_submitBTN rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x){//做的额外的操作
           _submitBTN.enabled =NO;
          _submitBTN.hidden =YES;
       }]
      flattenMap:^id(id x){
          return[self signInSignal];
      }]
     subscribeNext:^(NSNumber*signedIn){
         _submitBTN.enabled =YES;
         
        [self performSegueWithIdentifier:@"signInSuccess" sender:self];

     }];

}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id subscriber){
        [self.signInService
         signInWithUsername:_nameTF.text
         password:_nameTF.text
         complete:^(BOOL success){
             [subscriber sendNext:@(success)];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
