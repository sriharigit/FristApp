//
//  ViewController.h
//  DemoTask
//  
//  Created by admin on 21/02/19.
//  Copyright © 2019 Google. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHNetworkBase.h"
#import "BHNetworkAPI.h"
#import "BHURLHeader.h"
#import "SecondViewController.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwrdTF;
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;

@end

