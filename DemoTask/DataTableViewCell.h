//
//  DataTableViewCell.h
//  DemoTask
//
//  Created by admin on 21/02/19.
//  Copyright © 2019 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabl;
@property (weak, nonatomic) IBOutlet UILabel *fromLabl;
@property (weak, nonatomic) IBOutlet UILabel *toLabl;

@end

NS_ASSUME_NONNULL_END
