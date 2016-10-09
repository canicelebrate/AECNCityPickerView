AECNCityPickerView
============
 
An easy to use and customizable view component that presents a `UIPickerView` to pick cities with a toolbar, Done button, animation, design options, datasource.
Works with iOS 6 and even better in iOS 7 and later iOS version, because it let's you change the background color of the PickerView.


<br />

![AECNCityPickerView](https://github.com/canicelebrate/AECNCityPickerView/blob/master/AECNCityPickerView.png?raw=true)


<br />
## Installation

### From CocoaPods

* Add `pod 'AECNCityPickerView', '~> 0.0.1'` to your Podfile.
* Install by running `pod install`
* Include AECNCityPickerView by adding `#import <AECNCityPickerView.h>`

### Manually

_**Important note if your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `MMPickerView.m` in Target Settings > Build Phases > Compile Sources._

* Drag the `AECNCityPickerView/AECNCityPickerView` folder into your project.
* Make sure you have the **CoreGraphics** framework in your project.
* Include AECNCityPickerView by adding `#import "AECNCityPickerView.h"` 

## Usage

(see sample Xcode project in `/Demo`)

AECNCityPickerView is created as a singleton (i.e. it doesn't need to be explicitly allocated and instantiated; you directly call `[AECNCityPickerView method]`).

### Showing the PickerView

You can show the PickerView:

```objective-c
+(void)showPickerViewInView: (UIView *)view
                withDatasource: (id<AECNCityPickerViewDataSource>)dataSource
                withOptions: (NSDictionary *)options
                 completion: (void(^)(AECNLeafRegion *region))completion;

```


### Customizing AECNCityPickerView
Both show methods use a `NSDictionary` to set the options of the `AECNCityPickerView`. If you want a native looking PickerView, just `withOptions: nil`. In case of customization, use any of the different properties to customize the PickerView. All of the properties are optional, which means that if you only want to change one thing, like for eg the text color you can do like this, `withOptions: @{MMtextColor: [UIColor redColor]}`

**Options**

     
- `AECNCityPickerView_backgroundColor` - `UIColor` 
- `AECNCityPickerView_textColor` - `UIColor` 
- `AECNCityPickerView_toolbarBackgroundColor` - `UIColor` 
- `AECNCityPickerView_toolbarBtnTintColor` - `UIColor` 
- `AECNCityPickerView_font` - `UIFont` 
- `AECNCityPickerView_ValueY` - `NSInteger` 
- `AECNCityPickerView_selectedObject` - `id` 
- `AECNCityPickerView_toolbarBackgroundImage` - `UIImage`
- `AECNCityPickerView_textAlignment` - `NSNumber`

```objective-c
  /*
  Options:
  AECNCityPickerView_backgroundColor - UIColor - The background color of the PickerView (>=iOS 7)
  AECNCityPickerView_textColor - UIColor - The text color of the PickerView
  AECNCityPickerView_toolbarBackgroundColor - UIColor - The background color of the toolbar
  AECNCityPickerView_toolbarBtnTintColor - UIColor - The background color (<= iOS 6) or text color (>=iOS 7) of the Done button
  AECNCityPickerView_font - UIFont - The font of the PickerView labels
  AECNCityPickerView_ValueY - NSInteger - The Y value from the top of every label in the PickerView, useful when changing font/font-size.
  AECNCityPickerView_selectedObject - id - The selected object presented in the PickerView, an object from the array, for eg. [yourArray objectAtIndex:0];
  AECNCityPickerView_toolbarBackgroundImage - UIImage - The background image of the toolbar (320 x 44 for non retina, 640 x 88 for retina)
  AECNCityPickerView_textAlignment - NSNumber - The text alignment of the labels in the PickerView, @0 for Left, @1 for Center, @2 for Right
 */
```

#### Example - Show with an array of strings and with custom colors and custom font.
```objective-c
  
  UIFont *customFont  = [UIFont fontWithName:@"Palatino-Bold" size:19.0];
  NSDictionary *options = @{AECNCityPickerView_backgroundColor: [UIColor blackColor],
                                  AECNCityPickerView_textColor: [UIColor whiteColor],
                               AECNCityPickerView_toolbarColor: [UIColor darkGrayColor],
                                AECNCityPickerView_toolbarBtnTintColor: [UIColor whiteColor],
                                       AECNCityPickerView_font: customFont,
                                     AECNCityPickerView_ValueY: @5};

  
  [AECNCityPickerView showPickerViewInView:self.view
                         withDataSource:self
                         withOptions:options
                          completion:^(AECNLeafRegion *region) {
                            //region is the return value which you can use as you wish
                            //deal with selected region
                          }];
```



## Credits

AECNCityPickerView is brought to you by [**William Wang**](http://blog.csdn.net/missautumn). If you have feature suggestions or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/canicelebrate/AECNCityPickerView/issues/new). If you're using AECNCityPickerView in your project, attribution would be nice.


