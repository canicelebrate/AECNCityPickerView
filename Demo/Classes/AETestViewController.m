//
//  AETestViewController.m
//  AECNCityPickerView
//
//  Created by William Wang on 10/09/16.
//  Copyright (c) 2016 AmberEase Co.,Ltd. All rights reserved.
//


#import "AETestViewController.h"

@interface AETestViewController ()<AECNCityPickerViewDataSource>

@property (nonatomic, strong) NSArray *data;

@property (nonatomic,assign) NSInteger selectedProvinceIndex;
@property (nonatomic,assign) NSInteger selectedCityIndex;
@property (nonatomic,assign) NSInteger selectedCountyIndex;

@end

@implementation AETestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    self.selectedProvinceIndex = 0;
    self.selectedCityIndex = 0;
    self.selectedCountyIndex = 0;
  
}


-(void)loadData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    self.data = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
}

- (IBAction)showPickerViewButtonPressed:(id)sender {

  /*
   Options:
   
   AECNCityPickerView_backgroundColor - UIColor
   AECNCityPickerView_textColor - UIColor
   AECNCityPickerView_toolbarColor - UIColor
   AECNCityPickerView_toolbarBtnTintColor - UIColor
   AECNCityPickerView_font - UIFont
   AECNCityPickerView_valueY - NSInteger
   AECNCityPickerView_toolbarBackgroundImage  - UIImage
   AECNCityPickerView_textAlignment - NSNumber (@0 - Left, @1 - Center, @2 - Right)
   
   */
 
  
  
  
  //PickerView with customized look and datasource
   [AECNCityPickerView showPickerViewInView:self.view
                          withDataSource:self
                          withOptions:@{AECNCityPickerView_backgroundColor: [UIColor whiteColor],
                                        AECNCityPickerView_textColor: [UIColor blackColor],
                                        AECNCityPickerView_toolbarColor: [UIColor whiteColor],
                                        AECNCityPickerView_toolbarBtnTintColor: [UIColor orangeColor],
                                        AECNCityPickerView_font: [UIFont systemFontOfSize:18],
                                        AECNCityPickerView_valueY: @3,
                                        AECNCityPickerView_textAlignment:@1}
                           completion:^(AECNLeafRegion *selectedRegion) {
                               self.selectedProvinceIndex = selectedRegion.provinceIndex;
                               self.selectedCityIndex = selectedRegion.cityIndex;
                               self.selectedCountyIndex = selectedRegion.countyIndex;
   
                             _label.text = [NSString stringWithFormat:@"%@-%@-%@",selectedRegion.province,selectedRegion.city,selectedRegion.county ];
   }];
  
  
  
  /*
  //PickerView with customized look and datasource
   
  [AECNCityPickerView showPickerViewInView:self.view
                         withDataSource:self
                         withOptions:@{AECNCityPickerView_backgroundColor: [UIColor blackColor],
                                       AECNCityPickerView_textColor: [UIColor whiteColor],
                                       AECNCityPickerView_toolbarColor: [UIColor blackColor],
                                       AECNCityPickerView_toolbarBtnTintColor: [UIColor whiteColor],
                                       AECNCityPickerView_font: [UIFont systemFontOfSize:18],
                                       AECNCityPickerView_valueY: @3
                          completion:^(AECNLeafRegion *regiion) {
                                //todo:Handle selected region data

                          }];
  */


  
  
}

#pragma mark - AECNCityPickerViewDataSource
-(NSInteger)AECNCityPickerViewNumberOfProvinces:(AECNCityPickerView*)pickerView{
    return self.data.count;
}

-(NSInteger)AECNCityPickerView:(AECNCityPickerView *)pickerView numberOfCitiesInProvince:(NSInteger)provinceIndex{
    NSDictionary* province = [self.data objectAtIndex:provinceIndex];
    NSInteger result = [[province objectForKey:@"cities"] count];
    NSLog(@"city number is:%ld for province index:%ld",result,provinceIndex);
    return result;
}


-(NSInteger)AECNCityPickerView:(AECNCityPickerView*)pickerView numberOfCountriesInCity:(NSInteger)cityIndex andInProvince:(NSInteger)provinceIndex{
    NSDictionary* province = [self.data objectAtIndex:provinceIndex];
    NSArray* cities = [province objectForKey:@"cities"];
    NSDictionary* city = cities[cityIndex];
    NSArray* counties = [city objectForKey:@"counties"];
    return counties.count;
}

-(NSInteger)AECNCityPickerViewSelectedProvinceIndex:(AECNCityPickerView*)pickerView{
    return self.selectedProvinceIndex;
}


-(NSInteger)AECNCityPickerViewSelectedCityIndex:(AECNCityPickerView*)pickerView{
    return self.selectedCityIndex;
}

-(NSInteger)AECNCityPickerViewSelectedCountryIndex:(AECNCityPickerView*)pickerView{
    return self.selectedCountyIndex;
}


- (NSString *)AECNCityPickerView: (AECNCityPickerView *)pickerView titleForProvinceAtRow:(NSInteger)row{
    NSDictionary* province = [self.data objectAtIndex:row];
    return [province objectForKey:@"areaName"];
}


- (NSString *)AECNCityPickerView: (AECNCityPickerView *)pickerView titleForCityAtRow:(NSInteger)row inProvince:(NSInteger)provinceIndex{
    NSDictionary* province = [self.data objectAtIndex:provinceIndex];
    NSArray* cities = [province objectForKey:@"cities"];
    NSDictionary* city = cities[row];
    return [city objectForKey:@"areaName"];
}


- (NSString *)AECNCityPickerView: (AECNCityPickerView *)pickerView titleForCountryAtRow:(NSInteger)row inCity:(NSInteger)cityIndex andInProvince:(NSInteger)provinceIndex{
    NSDictionary* province = [self.data objectAtIndex:provinceIndex];
    NSArray* cities = [province objectForKey:@"cities"];
    NSDictionary* city = cities[cityIndex];
    NSArray* counties = [city objectForKey:@"counties"];
    NSDictionary* country = counties[row];
    return [country objectForKey:@"areaName"];
}




@end
