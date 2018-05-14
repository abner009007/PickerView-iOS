//
//  PickerView.m
//  PickerView
//
//  Created by  on 16/8/18.
//  Copyright © 2016年 abner. All rights reserved.
//

#import "PickerView.h"

#define SHeight					[[UIScreen mainScreen] bounds].size.height
#define SWidth					[[UIScreen mainScreen] bounds].size.width



@interface PickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger selectedLeftTableViewRow;
    NSInteger selectedRightTableViewRow;
}
@property(nonatomic,strong)UIPickerView * pickerView;
@property(nonatomic,strong)UIView * backgrouendViewBlack;
@property(nonatomic,strong)CityListModel * cityListModel;

@end


@implementation PickerView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.cityListModel = [self getCityListModel];
        [self getPickerViewUI];
    }
    return self;
}
-(void)getPickerViewUI
{
    self.backgrouendViewBlack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SWidth, SHeight)];
    self.backgrouendViewBlack.backgroundColor = [UIColor blackColor];
    self.backgrouendViewBlack.alpha = 0.5;
    [self addSubview:self.backgrouendViewBlack];
    
    UIView * backgrouend = [[UIView alloc]initWithFrame:CGRectMake(0, SHeight-256, SWidth, 256)];
    backgrouend.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgrouend];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, SWidth-80, 20)];
    title.textColor = [UIColor blueColor];
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"请选择城市";
    [backgrouend addSubview:title];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 5, 40, 30);
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.tag = 101;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgrouend addSubview:cancelButton];
    
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(SWidth-40, 5, 40, 30);
    confirmButton.backgroundColor = [UIColor clearColor];
    confirmButton.tag = 102;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgrouend addSubview:confirmButton];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SWidth, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [backgrouend addSubview:lineView];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SWidth, 216)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [backgrouend addSubview:self.pickerView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point=[[touches anyObject]locationInView:self];
    CALayer *layer=[self.backgrouendViewBlack.layer hitTest:point];
    if (layer==self.backgrouendViewBlack.layer) 
    {
        [self removeFromSuperview];
    }
}
-(void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 101:
        {
            [self removeFromSuperview];
        }
            break;
        case 102:
        {
            ProvinceModel * provinceModel = self.cityListModel.provincesList[selectedLeftTableViewRow];
            CityModel * cityModel = provinceModel.Citys[selectedRightTableViewRow];
            
            if (self.enter_block) {
                self.enter_block(provinceModel.Name, cityModel.Name);
                [self removeFromSuperview];
            }
        }
            break;
        default:
            break;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
    {
        selectedLeftTableViewRow = row;
        selectedRightTableViewRow = 0;
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
    }
    else
    {
        selectedRightTableViewRow = row;
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    ProvinceModel * provinceModel = self.cityListModel.provincesList[selectedLeftTableViewRow];
    return component==0 ? self.cityListModel.provincesList.count : provinceModel.Citys.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 0 == component ? SWidth*0.5-50 : SWidth*0.5+50;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat width = 0 == component ? SWidth*0.5-50 : SWidth*0.5+50;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (component == 0)
    {
        titleLabel.text = self.cityListModel.provincesList[row].Name;
    }
    else
    {
        ProvinceModel * provinceModel = self.cityListModel.provincesList[selectedLeftTableViewRow];
        CityModel * cityModel = provinceModel.Citys[row];
        titleLabel.text = cityModel.Name;
    }
    return titleLabel;  
}


-(CityListModel *)getCityListModel
{
    CityListModel * model = [[CityListModel alloc]init];
    NSString * filePath =[[NSBundle mainBundle] pathForResource:@"allprovinces" ofType:@"json"];
    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSData * data = [[NSData alloc] initWithContentsOfURL:url];
    NSDictionary * dicrtionsry = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    
    NSArray * provincesList = [dicrtionsry objectForKey:@"provincesList"];
    NSMutableArray * mutableArray_provinces = [[NSMutableArray alloc]init];
    
    for (NSDictionary * dicrtionsry_provinces in provincesList)
    {
        ProvinceModel * provinceModel = [[ProvinceModel alloc]init];
        provinceModel.Id = [dicrtionsry_provinces objectForKey:@"Id"];
        provinceModel.Name = [dicrtionsry_provinces objectForKey:@"Name"];
        
        NSArray * CitysList = [dicrtionsry_provinces objectForKey:@"Citys"];
        NSMutableArray * mutableArray_Citys = [[NSMutableArray alloc]init];
        for (NSDictionary * dicrtionsry_Citys in CitysList)
        {
            CityModel * model_city = [[CityModel alloc]init];
            model_city.Id = [dicrtionsry_Citys objectForKey:@"Id"];
            model_city.Name = [dicrtionsry_Citys objectForKey:@"Name"];
            model_city.ProvinceId = [dicrtionsry_Citys objectForKey:@"ProvinceId"];
            [mutableArray_Citys addObject:model_city];
        }
        provinceModel.Citys = mutableArray_Citys;
        [mutableArray_provinces addObject:provinceModel];
    }
    model.provincesList = mutableArray_provinces;
    
    return model;
}
@end
