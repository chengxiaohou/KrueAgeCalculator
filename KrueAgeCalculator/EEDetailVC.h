//
//  EEDetailVC.h
//  EERSSReader
//
//  Created by fengyi on 2019/4/1.
//  Copyright © 2019 橙晓侯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EEDetailVC : UIViewController

+ (void)showWithURL:(NSString *)url from:(UIViewController *)superVC;
+ (void)testFrom:(UIViewController *)superVC;
@end

NS_ASSUME_NONNULL_END
