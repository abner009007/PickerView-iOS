//
//  PickerView.h
//  PickerView
//
//  Created by abner on 16/8/18.
//  Copyright © 2016年 abner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityListModel.h"

@interface PickerView : UIView



@property(nonatomic,copy)void(^cancel_block)();


@property(nonatomic,copy)void(^enter_block)(NSString *province,NSString *city);






@end
