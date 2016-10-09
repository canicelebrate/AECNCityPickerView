//
//  AECNCityPickerView.m
//  AECNCityPickerView
//
//  Created by William Wang on 10/08/16.
//  Copyright (c) 2016 AmberEase Co.,Ltd. All rights reserved.
//

#import "AECNCityPickerView.h"

NSString * const AECNCityPickerView_backgroundColor = @"backgroundColor";
NSString * const AECNCityPickerView_textColor = @"textColor";
NSString * const AECNCityPickerView_toolbarColor = @"toolbarColor";
NSString * const AECNCityPickerView_toolbarBtnTintColor = @"buttonColor";
NSString * const AECNCityPickerView_toolbarBtnImg = @"buttonImg";
NSString * const AECNCityPickerView_font = @"font";
NSString * const AECNCityPickerView_valueY = @"yValueFromTop";
NSString * const AECNCityPickerView_toolbarBackgroundImage = @"toolbarBackgroundImage";
NSString * const AECNCityPickerView_textAlignment = @"textAlignment";
NSString * const AECNCityPickerView_showsSelectionIndicator = @"showsSelectionIndicator";



@implementation AECNLeafRegion


@end

@interface AECNCityPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *pickerViewLabel;
@property (nonatomic, strong) UIView *pickerViewLabelView;
@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIView *pickerViewContainerView;
@property (nonatomic, strong) UIView *pickerTopBarView;
@property (nonatomic, strong) UIImageView *pickerTopBarImageView;
@property (nonatomic, strong) UIToolbar *pickerViewToolBar;
@property (nonatomic, strong) UIBarButtonItem *pickerViewBarButtonItem;
@property (nonatomic, strong) UIButton *pickerDoneButton;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *pickerViewArray;
@property (nonatomic, strong) UIColor *pickerViewTextColor;
@property (nonatomic, strong) UIFont *pickerViewFont;
@property (nonatomic, assign) CGFloat yValueFromTop;
@property (nonatomic, assign) NSInteger pickerViewTextAlignment;
@property (nonatomic, assign) BOOL pickerViewShowsSelectionIndicator;
@property (nonatomic,copy) void (^onDismissCompletion)(AECNLeafRegion*);
@property (copy) NSString *(^objectToStringConverter)(id object);


@property (nonatomic,assign) NSInteger selectedProvinceIndex;
@property (nonatomic,assign) NSInteger selectedCityIndex;
@property (nonatomic,assign) NSInteger selectedCountyIndex;

@property (nonatomic,weak) id<AECNCityPickerViewDataSource> dataSource;
@end


@implementation AECNCityPickerView

#pragma mark - Singleton

+ (AECNCityPickerView*)sharedView {
    static dispatch_once_t once;
    static AECNCityPickerView *sharedView;
    dispatch_once(&once, ^ { sharedView = [[self alloc] init]; });
    return sharedView;
}

#pragma mark - Show Methods

+(void)showPickerViewInView:(UIView *)view
                withDataSource: (id<AECNCityPickerViewDataSource>)dataSource
                withOptions:(NSDictionary *)options
                 completion:(void (^)(AECNLeafRegion*))completion {

    //[AECNCityPickerView assertProvinces:provinces];
    NSAssert(dataSource, @"dataSource must be provided.");
    
    [self sharedView].dataSource = dataSource;

    [self sharedView].onDismissCompletion = completion;
    [[self sharedView] initializePickerViewInView:view
                                      withOptions:options];
    [[self sharedView] setPickerHidden:NO needCallback:NO];
    [view addSubview:[self sharedView]];
    
}

#pragma mark - Dismiss Methods


-(void)dismiss{
    [self setPickerHidden:YES needCallback:NO];
}

-(void)dismissWithSelection{
    [self setPickerHidden:YES needCallback:YES];
}

+(void)removePickerView{
    [[self sharedView] removeFromSuperview];
}

#pragma mark - Show/hide PickerView methods

-(void)setPickerHidden: (BOOL)hidden
              needCallback:(BOOL)needCallback; {
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         if (hidden) {
                             [_pickerViewContainerView setAlpha:0.0];
                             [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
                         } else {
                             [_pickerViewContainerView setAlpha:1.0];
                             [_pickerContainerView setTransform:CGAffineTransformIdentity];
                         }
                     } completion:^(BOOL completed) {
                         if(completed && hidden){
                             [AECNCityPickerView removePickerView];
                             if(needCallback){
                                 self.onDismissCompletion([self selectedRegion]);
                                 self.onDismissCompletion = nil;
                             }
                         }
                     }];
    
}

#pragma mark - Initialize PickerView

-(void)initializePickerViewInView: (UIView *)view
                      withOptions: (NSDictionary *)options {
    
    
    NSNumber *textAlignment = [[NSNumber alloc] init];
    textAlignment = options[AECNCityPickerView_textAlignment];
    //Default value is NSTextAlignmentCenter
    _pickerViewTextAlignment = 1;
    
    if (textAlignment != nil) {
        _pickerViewTextAlignment = [options[AECNCityPickerView_textAlignment] integerValue];
    }
    
    BOOL showSelectionIndicator = [options[AECNCityPickerView_showsSelectionIndicator] boolValue];
    
    if (!showSelectionIndicator) {
        _pickerViewShowsSelectionIndicator = 1;
    }
    _pickerViewShowsSelectionIndicator = showSelectionIndicator;
    
    UIColor *pickerViewBackgroundColor = [[UIColor alloc] initWithCGColor:[options[AECNCityPickerView_backgroundColor] CGColor]];
    UIColor *pickerViewTextColor = [[UIColor alloc] initWithCGColor:[options[AECNCityPickerView_textColor] CGColor]];
    UIColor *toolbarBackgroundColor = [[UIColor alloc] initWithCGColor:[options[AECNCityPickerView_toolbarColor] CGColor]];
    UIColor *buttonTextColor = [[UIColor alloc] initWithCGColor:[options[AECNCityPickerView_toolbarBtnTintColor] CGColor]];
    UIFont *pickerViewFont = [[UIFont alloc] init];
    pickerViewFont = options[AECNCityPickerView_font];
    _yValueFromTop = [options[AECNCityPickerView_valueY] floatValue];
    
    [self setFrame: view.bounds];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIImage * toolbarImage = options[AECNCityPickerView_toolbarBackgroundImage];
    
    //Whole screen with PickerView and a dimmed background
    _pickerViewContainerView = [[UIView alloc] initWithFrame:view.bounds];
    [_pickerViewContainerView setBackgroundColor: [UIColor colorWithRed:0.412 green:0.412 blue:0.412 alpha:0.7]];
    [self addSubview:_pickerViewContainerView];
    
    UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDimmedBGTapped)];
    tapGest.numberOfTapsRequired = 1;
    [_pickerViewContainerView addGestureRecognizer:tapGest];
    
    
    //PickerView Container with top bar
    _pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _pickerViewContainerView.bounds.size.height - 260.0, _pickerViewContainerView.bounds.size.width, 260.0)];
    
    //Default Color Values (if colors == nil)
    
    //PickerViewBackgroundColor - White
    if (pickerViewBackgroundColor==nil) {
        pickerViewBackgroundColor = [UIColor whiteColor];
    }
    
    //PickerViewTextColor - Black
    if (pickerViewTextColor==nil) {
        pickerViewTextColor = [UIColor blackColor];
    }
    _pickerViewTextColor = pickerViewTextColor;
    
    //ToolbarBackgroundColor - Black
    if (toolbarBackgroundColor==nil) {
        toolbarBackgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:0.8];
    }
    
    //ButtonTextColor - Blue
    if (buttonTextColor==nil) {
        buttonTextColor = [UIColor colorWithRed:0.000 green:0.486 blue:0.976 alpha:1];
    }
    
    if (pickerViewFont==nil) {
        _pickerViewFont = [UIFont systemFontOfSize:22];
    }
    _pickerViewFont = pickerViewFont;
    
    /*
     //ToolbackBackgroundImage - Clear Color
     if (toolbarBackgroundImage!=nil) {
     //Top bar imageView
     _pickerTopBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.0)];
     //[_pickerContainerView addSubview:_pickerTopBarImageView];
     _pickerTopBarImageView.image = toolbarBackgroundImage;
     [_pickerViewToolBar setHidden:YES];
     
     }
     */
    
    _pickerContainerView.backgroundColor = pickerViewBackgroundColor;
    [_pickerViewContainerView addSubview:_pickerContainerView];
    
    
    //Content of pickerContainerView
    
    //Top bar view
    _pickerTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.0)];
    [_pickerContainerView addSubview:_pickerTopBarView];
    [_pickerTopBarView setBackgroundColor:[UIColor whiteColor]];
    
    
    _pickerViewToolBar = [[UIToolbar alloc] initWithFrame:_pickerTopBarView.frame];
    [_pickerContainerView addSubview:_pickerViewToolBar];
    
    CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    //NSLog(@"%f",iOSVersion);
    
    if (iOSVersion < 7.0) {
        _pickerViewToolBar.tintColor = toolbarBackgroundColor;
        //[_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];
    }else{
        [_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];
        
        //_pickerViewToolBar.tintColor = toolbarBackgroundColor;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        _pickerViewToolBar.barTintColor = toolbarBackgroundColor;
#endif
    }
    
    if (toolbarImage!=nil) {
        [_pickerViewToolBar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //_pickerViewBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissWithSelection)];
    UIImage* btnImg = options[AECNCityPickerView_toolbarBtnImg];
    if(btnImg == nil){
        NSBundle* bundle = [NSBundle bundleForClass:[self class]];
        btnImg = [UIImage imageNamed:@"confirm" inBundle:bundle compatibleWithTraitCollection:nil];
    }
    _pickerViewBarButtonItem = [[UIBarButtonItem alloc] initWithImage:btnImg style:UIBarButtonItemStylePlain target:self action:@selector(dismissWithSelection)];
    _pickerViewToolBar.items = @[flexibleSpace, _pickerViewBarButtonItem];
    [_pickerViewBarButtonItem setTintColor:buttonTextColor];
    
    
    //Add pickerView
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, _pickerViewContainerView.bounds.size.width, 216.0)];
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [_pickerView setShowsSelectionIndicator: _pickerViewShowsSelectionIndicator];//YES];
    [_pickerContainerView addSubview:_pickerView];
    
    //[self.pickerViewContainerView setAlpha:0.0];
    [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
    
    //Set selected row
    if(self.dataSource){
        NSInteger provinceIndex = [self.dataSource AECNCityPickerViewSelectedProvinceIndex:self];
        NSInteger cityIndex = [self.dataSource AECNCityPickerViewSelectedCityIndex:self];
        NSInteger countryIndex = [self.dataSource AECNCityPickerViewSelectedCountryIndex:self];
        [_pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [_pickerView selectRow:cityIndex inComponent:1 animated:YES];
        [_pickerView selectRow:countryIndex inComponent:2 animated:YES];
        self.selectedProvinceIndex = provinceIndex;
        self.selectedCityIndex = cityIndex;
        self.selectedCountyIndex = countryIndex;
    }
    else{
        NSLog(@"dataSource of AECNCityPickerView is missing!");
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = [_dataSource AECNCityPickerViewNumberOfProvinces:self];
            NSLog(@"province count is:%ld",result);
            break;
        case 1:
        {
            result = [_dataSource AECNCityPickerView:self numberOfCitiesInProvince:self.selectedProvinceIndex];
            NSLog(@"city count is:%ld",result);
        }
            break;
        case 2:
        {
            result =  [_dataSource AECNCityPickerView:self numberOfCountriesInCity:self.selectedCityIndex andInProvince:self.selectedProvinceIndex];
            NSLog(@"country count is:%ld",result);
        }
            break;
    }
    //NSLog(@"Unknown component[%ld] found",component);
    return result;
}

- (NSString *)pickerView: (UIPickerView *)pickerView
             titleForRow: (NSInteger)row
            forComponent: (NSInteger)component {
    NSString* result = nil;
    switch (component) {
        case 0:
            result = [self.dataSource AECNCityPickerView:self titleForProvinceAtRow:row];
            NSLog(@"province name is:%@",result);
            break;
        case 1:
            result =  [self.dataSource AECNCityPickerView:self titleForCityAtRow:row inProvince:self.selectedProvinceIndex];
            NSLog(@"city name is:%@",result);
        case 2:
            result = [self.dataSource AECNCityPickerView:self titleForCountryAtRow:row inCity:self.selectedCityIndex andInProvince:self.selectedProvinceIndex];
            NSLog(@"country name is:%@",result);
            break;
        default:
            break;
    }
    return result;
}

#pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.selectedProvinceIndex = row;
            self.selectedCityIndex = 0;
            self.selectedCountyIndex = 0;
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            break;
        case 1:
            self.selectedCityIndex = row;
            self.selectedCountyIndex = 0;
            [pickerView reloadComponent:2];
            break;
        case 2:
            self.selectedCountyIndex = row;
            break;
        default:
            break;
    }
}




- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UIView *customPickerView = view;
    
    UILabel *pickerViewLabel;
    
    CGFloat componentWidth = self.superview.bounds.size.width / 3.0f;
    CGFloat xOffset = component * componentWidth;
    
    if (customPickerView==nil) {
        
        CGRect frame = CGRectMake(xOffset, 0.0, componentWidth, 44.0);
        customPickerView = [[UIView alloc] initWithFrame: frame];

        
        if (_yValueFromTop == 0.0f) {
            _yValueFromTop = 3.0;
        }
        
        CGRect labelFrame = CGRectMake(0.0, _yValueFromTop, componentWidth, 35); // 35 or 44
        pickerViewLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [pickerViewLabel setTag:1];
        [pickerViewLabel setTextAlignment: _pickerViewTextAlignment];
        [pickerViewLabel setBackgroundColor:[UIColor clearColor]];
        [pickerViewLabel setTextColor:_pickerViewTextColor];
        [pickerViewLabel setFont:_pickerViewFont];
        [customPickerView addSubview:pickerViewLabel];
    } else{
        
        for (UIView *view in customPickerView.subviews) {
            if (view.tag == 1) {
                pickerViewLabel = (UILabel *)view;
                break;
            }
        }
    }
    
    NSString* strTitle = nil;
    switch (component) {
        case 0:
            strTitle = [self.dataSource AECNCityPickerView:self titleForProvinceAtRow:row];
            break;
        case 1:
            strTitle = [self.dataSource AECNCityPickerView:self titleForCityAtRow:row inProvince:self.selectedProvinceIndex];
            break;
        case 2:
            strTitle = [self.dataSource AECNCityPickerView:self titleForCountryAtRow:row inCity:self.selectedCityIndex andInProvince:self.selectedProvinceIndex];
            break;
        default:
            break;
    }

    [pickerViewLabel setText:strTitle];
    
    
    return customPickerView;
    
}

#pragma mark - Help Methods

- (AECNLeafRegion*)selectedRegion {
    AECNLeafRegion* region = [[AECNLeafRegion alloc] init];
    NSString* province = [self.dataSource AECNCityPickerView:self titleForProvinceAtRow:self.selectedProvinceIndex];
    NSString* city = [self.dataSource AECNCityPickerView:self titleForCityAtRow:self.selectedCityIndex inProvince:self.selectedProvinceIndex];
    NSString* country = [self.dataSource AECNCityPickerView:self titleForCountryAtRow:self.selectedCountyIndex inCity:self.selectedCityIndex andInProvince:self.selectedProvinceIndex];
    
    region.province = province;
    region.city = city;
    region.county = country;
    
    region.provinceIndex = self.selectedProvinceIndex;
    region.cityIndex = self.selectedCityIndex;
    region.countyIndex = self.selectedCountyIndex;
    
    return region;
}


#pragma mark - UI Events
-(void)onDimmedBGTapped{
    [self dismiss];
}


@end
