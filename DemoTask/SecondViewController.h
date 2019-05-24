//
//  SecondViewController.h
//  DemoTask
//
//  Created by admin on 21/02/19.
//  Copyright © 2019 Google. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHNetworkBase.h"
#import "BHNetworkAPI.h"
#import "BHURLHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tablV;
@property (nonatomic,retain) NSString* tokenStr;

@end

NS_ASSUME_NONNULL_END
