//
//  DHTimeCounterController.h
//  DHTimeCounterDemo
//
//  Created by Eric Holmes on 2015-12-20.
//  Copyright © 2015 DanHolmes. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Type of the timer ring
 */
typedef NS_ENUM(NSUInteger, DHCounterVisualType) {
    /**
     *  The ring looks like a clock
     */
    DHCounterTypeElements = 0,
    /**
     *  All the elements are equal
     */
    DHCounterTypeEqualElements,
    /**
     *  The ring is a solid line
     */
    DHCounterTypeSolid,
    /**
     *  The number of the different types
     */
    DHCounterTypeNumberOfTypes
};
/**
 *  The unit of time the cumulative timer will use
 */
typedef NS_ENUM(NSUInteger, DHCounterTimeUnit) {
    /**
     *  <#Description#>
     */
    DHCounterTimeUnitSeconds,
    /**
     *  <#Description#>
     */
    DHCounterTimeUnitMinutes,
    /**
     *  <#Description#>
     */
    DHCounterTimeUnitHours,
    /**
     *  <#Description#>
     */
    DHCounterTimeUnitDays,
    /**
     *  <#Description#>
     */
    DHCounterTimeUnitWeeks,
    /**
     *  <#Description#>
     */
    DHCounterTimeUnitMonths,
    /**
     *  <#Description#>
     */
    DHCounterTimeUnitYears
};

/**
 *  A simple subclass of UIControl to set seconds or minutes
 */

@interface DHTimeCounter : UIControl

/**
 *  The value of the control
 */
@property (nonatomic, assign) NSInteger timeValue;
/**
 *  The unit of time (ex. minutes) that this counter is based on
 */
@property (nonatomic, assign) DHCounterTimeUnit timeUnit;

/**
 *  The maximal allowed value
 */
@property (nonatomic, assign) NSInteger maxValue;

/**
 *  The color of the control
 */
@property (nonatomic, strong) UIColor *color;

/**
 *  The color of the control during interaction
 */
@property (nonatomic, strong) UIColor *highlightColor;

/**
 *  The label for the title show below the value
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  The ring width
 */
@property (nonatomic, assign) CGFloat ringWidth;

/**
 *  The timer type
 */
@property (nonatomic, assign) DHCounterVisualType type;


@property (nonatomic, strong) NSDate        *startDate;

/**
 *  Create a timer control with a type
 *
 *  @param type The type the conrol should have
 *
 *  @return An initialized timer control
 */
+ (instancetype)counterWithType:(DHCounterVisualType)type;

/**
 *  The setter for the value
 *
 *  @param newTimeValue The new value
 */
- (void)setTimeValue:(NSInteger)newTimeValue;


- (void) startCounter;
- (void) endCounter;

@end
