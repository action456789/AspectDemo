//
//  ViewController.m
//  AspectsDemo
//
//  Created by KeSen on 15/11/5.
//  Copyright © 2015年 KeSen. All rights reserved.
//

#import "ViewController.h"
#import "Aspects.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(buttonClieckEvent:) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    [self.view addSubview:btn];
}

- (void)test {
    NSLog(@"test is invoked");
}

- (void)buttonClieckEvent:(UIButton *)sender{
    
    UIViewController *testController = [[UIImagePickerController alloc] init];
    testController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:testController animated:YES completion:NULL];
    
    /** We are interested in being notified when the controller is being dismissed.
    *  block 中的第一个参数是添加钩子的对象本身，其他参数被添加钩子函数的参数（也可省略）
    **/
    [testController aspect_hookSelector:@selector(viewWillDisappear:)
                            withOptions:AspectPositionAfter
                             usingBlock:^(id<AspectInfo> info, BOOL animated) {
        
                                 UIViewController *controller = [info instance];
        
                                 if (controller.isBeingDismissed || controller.isMovingFromParentViewController) {

                                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息" message:@"viewWillDisappear is called!" preferredStyle:UIAlertControllerStyleAlert];
                                
                                     [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
                                
                                     [self presentViewController:alert animated:YES completion:nil];
         }
    }                             error:NULL];
    
    // Hooking dealloc is delicate, only AspectPositionBefore will work here.
    [testController aspect_hookSelector:NSSelectorFromString(@"dealloc")
                            withOptions:AspectPositionBefore
                             usingBlock:^(id<AspectInfo> info) {
                                 
                                 NSLog(@"Controller is about to be deallocated: %@", [info instance]);
    }
                                  error:NULL];
}

@end
