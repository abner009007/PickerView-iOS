//
//  CityListModel.h
//  PickerView
//
//  Created by 云中科技 on 2018/5/11.
//  Copyright © 2018年 abner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProvinceModel;
@class CityModel;

@interface CityListModel : NSObject


@property (nonatomic, copy) NSArray <ProvinceModel*> *provincesList;

@end


@interface ProvinceModel : NSObject


@property (nonatomic, copy) NSArray <CityModel*> *Citys;
@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * Name;

@end


@interface CityModel : NSObject

@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * Name;
@property (nonatomic, copy) NSString * ProvinceId;


@end
