//
//  AECNCityPickerView.h
//  AECNCityPickerView
//
//  Created by William Wang on 10/08/16.
//  Copyright (c) 2016 AmberEase Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAECNCityPickerView_Cities_Key      @"cities"
#define kAECNCityPickerView_Counties_Key   @"counties"

@class AECNCityPickerView;

@interface AECNLeafRegion : NSObject
@property (nonatomic,strong) NSString* province;
@property (nonatomic,strong) NSString* city;
@property (nonatomic,strong) NSString* county;

@property (nonatomic,assign) NSInteger provinceIndex;
@property (nonatomic,assign) NSInteger cityIndex;
@property (nonatomic,assign) NSInteger countyIndex;
@end



extern NSString * const AECNCityPickerView_backgroundColor;
extern NSString * const AECNCityPickerView_textColor;
extern NSString * const AECNCityPickerView_toolbarColor;
extern NSString * const AECNCityPickerView_toolbarBtnTintColor;
extern NSString * const AECNCityPickerView_toolbarBtnImg;
extern NSString * const AECNCityPickerView_font;
extern NSString * const AECNCityPickerView_valueY;
extern NSString * const AECNCityPickerView_toolbarBackgroundImage;
extern NSString * const AECNCityPickerView_textAlignment;
extern NSString * const AECNCityPickerView_showsSelectionIndicator;

@protocol AECNCityPickerViewDataSource <NSObject>
@required
-(NSInteger)AECNCityPickerViewNumberOfProvinces:(AECNCityPickerView*)pickerView;
-(NSInteger)AECNCityPickerView:(AECNCityPickerView *)pickerView numberOfCitiesInProvince:(NSInteger)provinceIndex;
-(NSInteger)AECNCityPickerView:(AECNCityPickerView*)pickerView numberOfCountriesInCity:(NSInteger)cityIndex andInProvince:(NSInteger)provinceIndex;

-(NSInteger)AECNCityPickerViewSelectedProvinceIndex:(AECNCityPickerView*)pickerView;
-(NSInteger)AECNCityPickerViewSelectedCityIndex:(AECNCityPickerView*)pickerView;
-(NSInteger)AECNCityPickerViewSelectedCountryIndex:(AECNCityPickerView*)pickerView;


- (NSString *)AECNCityPickerView: (AECNCityPickerView *)pickerView titleForProvinceAtRow:(NSInteger)row;
- (NSString *)AECNCityPickerView: (AECNCityPickerView *)pickerView titleForCityAtRow:(NSInteger)row inProvince:(NSInteger)provinceIndex;
- (NSString *)AECNCityPickerView: (AECNCityPickerView *)pickerView titleForCountryAtRow:(NSInteger)row inCity:(NSInteger)cityIndex andInProvince:(NSInteger)provinceIndex;


@end

@interface AECNCityPickerView: UIView
/*
+(void)showPickerViewInView: (UIView *)view
                withStrings: (NSArray *)strings
                withOptions: (NSDictionary *)options
                 completion: (void(^)(id selectedString))completion;
//*/

+(void)showPickerViewInView: (UIView *)view
                withDataSource: (id<AECNCityPickerViewDataSource>)dataSource
                withOptions: (NSDictionary *)options
       completion: (void(^)(AECNLeafRegion* selectedObject))completion;

//+(void)dismissWithCompletion: (void(^)(AECNLeafRegion*))completion;

@end
