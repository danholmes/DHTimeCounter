//
//  DHTimeCounterController.m
//  DHTimeCounterDemo
//
//  Created by Eric Holmes on 2015-12-20.
//  Copyright © 2015 DanHolmes. All rights reserved.
//

#import "DHTimeCounter.h"

const CGFloat kDHInsetX = 10.0f;
const CGFloat kDHInsetY = kDHInsetX;
//const CGFloat kDDHLabelWidth = 40;
//const CGFloat kDDHLabelHeight = kDDHLabelWidth;
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@interface DHTimeCounter ()
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@property (nonatomic, assign) CGFloat       currentValue;
@property (nonatomic, assign) CGFloat       radius;
@property (nonatomic, assign) CGFloat       endAngle;
@property (nonatomic, assign) CGFloat       fontSize;
@property (nonatomic, assign) CGPoint       counterCenter;
@property (nonatomic, assign) CGPoint       startPoint;
@property (nonatomic, assign) CGRect        counterElementRect;
@property (nonatomic, assign) CGRect        staticLableRect;
@property (nonatomic, strong) UILabel       *timeLabel;
@property (nonatomic, strong) CAShapeLayer  *majorShapeLayer;
@property (nonatomic, strong) CAShapeLayer  *minorShapeLayer;
@property (nonatomic, strong) NSTimer       *updateCounter;
@end

#pragma mark -
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@implementation DHTimeCounter
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#pragma mark -
// ------------------------------------------------------------------------------------------------
+ (instancetype) counterWithType: (DHCounterVisualType)type
// ------------------------------------------------------------------------------------------------
{
    DHTimeCounter *control = [[DHTimeCounter alloc] initWithFrame:CGRectZero];
    control.type = type;
    return control;
}
// ------------------------------------------------------------------------------------------------
- (instancetype) initWithFrame: (CGRect)frame
// ------------------------------------------------------------------------------------------------
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _maxValue  = 60.0f;
        _ringWidth = 4;

        _timeLabel                    = [[UILabel alloc] init];
        _timeLabel.layer.cornerRadius = 6.0f;
        _timeLabel.clipsToBounds      = YES;
        
        _titleLabel                           = [[UILabel alloc] init];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment             = NSTextAlignmentCenter;
        
        _minorShapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_minorShapeLayer];
        
        _majorShapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_majorShapeLayer];
        
        [self addSubview:_titleLabel];
        [self addSubview:_timeLabel];
        
    }
    return self;
}


// ------------------------------------------------------------------------------------------------
- (void) startCounter
// ------------------------------------------------------------------------------------------------
{
    if (!self.updateCounter)
    {
        NSTimeInterval updateInterval;
        switch (_timeUnit)
        {
            case DHCounterTimeUnitSeconds: {
                updateInterval = 0.1f;
                break;
            }
            case DHCounterTimeUnitMinutes: {
                updateInterval = 1.0f;
                break;
            }
            case DHCounterTimeUnitHours: {
                updateInterval = 1.0f;
                break;
            }
            case DHCounterTimeUnitDays: {
                updateInterval = 1.0f;
                break;
            }
            case DHCounterTimeUnitWeeks: {
                updateInterval = 1.0f;
                break;
            }
            case DHCounterTimeUnitMonths: {
                updateInterval = 1.0f;
                break;
            }
            case DHCounterTimeUnitYears: {
                updateInterval = 1.0f;
                break;
            }
        }
        
        self.updateCounter = [NSTimer scheduledTimerWithTimeInterval:updateInterval
                                                            target:self
                                                          selector:@selector(updateCounter:)
                                                          userInfo:nil
                                                           repeats:YES];
    }
}

// ------------------------------------------------------------------------------------------------
- (void) endCounter
// ------------------------------------------------------------------------------------------------
{
    [self.updateCounter invalidate];
    self.updateCounter = nil;
}

// ------------------------------------------------------------------------------------------------
- (void) updateCounter:(NSTimer*)counter
// ------------------------------------------------------------------------------------------------
{
    NSTimeInterval timeInterval = -1 * [self.startDate timeIntervalSinceNow];
    float fractionTimeUnits     = timeInterval / ([self secondsInTimeUnit:self.timeUnit]);
    fractionTimeUnits           = fractionTimeUnits - floorf(fractionTimeUnits);
    self.timeValue              = fractionTimeUnits * _maxValue;
}
// ------------------------------------------------------------------------------------------------
- (float) secondsInTimeUnit: (DHCounterTimeUnit) aTimeUnit
// ------------------------------------------------------------------------------------------------
{
    float seconds = 1.0;
    switch (aTimeUnit) {
        case DHCounterTimeUnitSeconds: {
            seconds = 60.0f;
            break;
        }
        case DHCounterTimeUnitMinutes: {
            seconds = 60.0f * 60.0f;
            break;
        }
        case DHCounterTimeUnitHours: {
            seconds = 60.0f * 60.0f * 24.0f;
            break;
        }
        case DHCounterTimeUnitDays: {
            seconds = 60.0f * 60.0f * 24.0f * 365.0f;
            break;
        }
        case DHCounterTimeUnitWeeks: {
            seconds = 60.0f * 60.0f * 24.0f * 7.0f;
            break;
        }
        case DHCounterTimeUnitMonths: {
            seconds = 60.0f * 60.0f * 24.0f * 30.0f;
            break;
        }
        case DHCounterTimeUnitYears: {
            seconds = 60.0f * 60.0f * 24.0f * 365.0f;
            break;
        }
    }
    return seconds;
}
// ------------------------------------------------------------------------------------------------
- (void) setTimeUnit: (DHCounterTimeUnit) aTimeUnit
// ------------------------------------------------------------------------------------------------
{
    _timeUnit = aTimeUnit;
    switch (aTimeUnit) {
        case DHCounterTimeUnitSeconds: {
            _maxValue = 60;
            break;
        }
        case DHCounterTimeUnitMinutes: {
            _maxValue = 60;
            break;
        }
        case DHCounterTimeUnitHours: {
            _maxValue = 24;
            break;
        }
        case DHCounterTimeUnitDays: {
            _maxValue = 30;
            break;
        }
        case DHCounterTimeUnitWeeks: {
            _maxValue = 52;
            break;
        }
        case DHCounterTimeUnitMonths: {
            _maxValue = 12;
            break;
        }
        case DHCounterTimeUnitYears: {
            _maxValue = 100;
            break;
        }
    }
}

// ------------------------------------------------------------------------------------------------
- (void) layoutSubviews
// ------------------------------------------------------------------------------------------------
{
    [super layoutSubviews];

    CGRect frame      = self.frame;
    _counterElementRect = CGRectInset(frame, kDHInsetX, kDHInsetY);
    _radius           = CGRectGetWidth(_counterElementRect) / 2;

    _staticLableRect             = CGRectInset(self.bounds,
                                               kDHInsetX + floorf(0.18*frame.size.width),
                                               kDHInsetY + floorf(0.18*frame.size.height));
    _staticLableRect.origin.y    -= floorf(0.1*frame.size.height);
    _timeLabel.frame = _staticLableRect;

    CGFloat height        = _staticLableRect.size.height;
    _titleLabel.frame     = CGRectMake(CGRectGetMinX(_staticLableRect),
                                       CGRectGetMaxY(_staticLableRect)-floorf(0.1*height),
                                       _staticLableRect.size.width,
                                       floorf(0.4f*height));
    _titleLabel.textColor = self.color;
    
    self.fontSize = ceilf(0.85f*height);
    
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light"
                                       size:floorf(self.fontSize/2.0f)];
}
// ------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect
// ------------------------------------------------------------------------------------------------
{
    NSString* expression = [NSString stringWithFormat: @"%ld", (long)round(self.timeValue)];
    
    //// TimerElement Drawing
    CGFloat startAngle = 3 * M_PI/2;
    self.endAngle      = self.timeValue * 2 * M_PI / self.maxValue - M_PI_2;
    self.counterCenter   = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));

    CGFloat dashLength = 2*self.radius*M_PI/(2*(self.maxValue-1));
    
    if (!self.color) {
        self.color = [UIColor greenColor];
    }
    if (!self.highlightColor) {
        self.highlightColor = [UIColor yellowColor];
    }
    
    UIColor *counterColor = self.highlighted ? self.highlightColor : self.color;
    [counterColor setFill];
    
    UIBezierPath* counterElementPath = UIBezierPath.bezierPath;
    [counterElementPath addArcWithCenter:self.counterCenter
                                radius:self.radius
                            startAngle:startAngle
                              endAngle:startAngle-0.01
                             clockwise:YES];
    
    self.majorShapeLayer.fillColor   = [[UIColor clearColor] CGColor];
    self.majorShapeLayer.strokeColor = [counterColor CGColor];
    self.majorShapeLayer.lineWidth   = self.ringWidth;
    self.majorShapeLayer.strokeEnd   = (float)self.timeValue/self.maxValue;
    if (self.type >= DHCounterTypeNumberOfTypes) {
        NSAssert1(false, @"The given type (%lu) is not supported", self.type);
    }
    
    if (self.type != DHCounterTypeSolid) {
        if (self.type == DHCounterTypeElements) {
            self.majorShapeLayer.lineDashPattern = @[@(dashLength), @(8.76*dashLength)];
        } else if (self.type == DHCounterTypeEqualElements) {
            self.majorShapeLayer.lineDashPattern = @[@(dashLength), @(0.955*dashLength)];
        }
        self.majorShapeLayer.lineDashPhase = 1;
    }
    self.majorShapeLayer.path = counterElementPath.CGPath;
    
    if (self.type == DHCounterTypeElements) {
        UIBezierPath *counterMinorElementPath = UIBezierPath.bezierPath;
        [counterMinorElementPath addArcWithCenter:self.counterCenter
                                         radius:self.radius
                                     startAngle:startAngle
                                       endAngle:startAngle-0.01
                                      clockwise:YES];
        self.minorShapeLayer.fillColor       = [[UIColor clearColor] CGColor];
        self.minorShapeLayer.strokeColor     = [[counterColor colorWithAlphaComponent:0.5f] CGColor];
        self.minorShapeLayer.lineWidth       = 1;
        self.minorShapeLayer.strokeEnd       = (float)self.timeValue/self.maxValue;
        self.minorShapeLayer.lineDashPattern = @[@(dashLength), @(0.955*dashLength)];
        self.minorShapeLayer.lineDashPhase   = 1;
        self.minorShapeLayer.path            = counterMinorElementPath.CGPath;
    }
    
    CGFloat handleRadius;
    if (self.userInteractionEnabled) {
        handleRadius = self.ringWidth;
    } else {
        handleRadius = ceilf(self.ringWidth/2);
    }
    
    UIBezierPath *handlePath = [UIBezierPath bezierPathWithArcCenter:[self handlePoint]
                                                              radius:handleRadius
                                                          startAngle:0
                                                            endAngle:2*M_PI
                                                           clockwise:YES];
    [handlePath fill];
    
    NSMutableParagraphStyle* labelStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    labelStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *labelFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light"
                                                                               size:self.fontSize],
                                          NSForegroundColorAttributeName: self.color,
                                          NSParagraphStyleAttributeName: labelStyle};
    
    self.timeLabel.attributedText = [[NSAttributedString alloc] initWithString:expression
                                                                    attributes:labelFontAttributes];
}

#pragma mark - helper methods
// ------------------------------------------------------------------------------------------------
- (CGPoint) handlePoint
// ------------------------------------------------------------------------------------------------
{
    CGFloat handleAngle = self.endAngle + M_PI_2;
    CGPoint handlePoint = CGPointZero;
    handlePoint.x       = self.counterCenter.x + (self.radius) * sinf(handleAngle);
    handlePoint.y       = self.counterCenter.y - (self.radius) * cosf(handleAngle);
    return handlePoint;
}

#pragma mark - Setters


// ------------------------------------------------------------------------------------------------
- (void)setTimeValue:(NSInteger)newTimeValue
// ------------------------------------------------------------------------------------------------
{
    if (newTimeValue > self.maxValue) {
        _timeValue = self.maxValue;
        
    } else if (newTimeValue < 0) {
        _timeValue = 0;
    }
    
    if (_timeValue != newTimeValue) {
        _timeValue = newTimeValue;
        [self setNeedsDisplay];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Touch events
// ------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
// ------------------------------------------------------------------------------------------------
{
    /*
    UITouch *touch = [[event touchesForView:self] anyObject];
    CGPoint position = [touch locationInView:self];
    
    CGPoint handlePoint = [self handlePoint];
    UIBezierPath *handlePath = [UIBezierPath bezierPathWithArcCenter:handlePoint
                                                              radius:20.0f
                                                          startAngle:0
                                                            endAngle:2*M_PI
                                                           clockwise:YES];
    if ([handlePath containsPoint:position]) {
        self.highlighted = YES;
    } else {
        self.highlighted = NO;
    }
    self.currentValue = self.timeValue;
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.8
          initialSpringVelocity:20.0f
                        options:kNilOptions
                     animations:^{
        self.timeLabel.center = CGPointMake(handlePoint.x, handlePoint.y - self.staticLableRect.size.height/2 - 20);
    }
                     completion:^(BOOL finished) {
        self.timeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        [self setNeedsDisplay];
    }];
    */
}
// ------------------------------------------------------------------------------------------------
- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
// ------------------------------------------------------------------------------------------------
{
    /*
    UITouch *touch = [[event touchesForView:self] anyObject];
    CGPoint position = [touch locationInView:self];
    
    CGFloat angleInDegrees = atanf((position.y - self.timerCenter.y)/(position.x - self.timerCenter.x))*180/M_PI + 90;
    if (position.x < self.timerCenter.x) {
        angleInDegrees += 180;
    }
    
    CGFloat selectedMinutesOrSeconds = angleInDegrees * self.maxValue / 360;
    
    self.timeValue = (NSInteger)selectedMinutesOrSeconds;
    
    CGPoint handlePoint = [self handlePoint];
    
    [UIView animateWithDuration:0.1
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:kNilOptions
                     animations:^{
        self.timeLabel.center = CGPointMake(handlePoint.x, handlePoint.y - self.staticLableRect.size.height/2 - 20);
    }
                     completion:^(BOOL finished) {
        [self setNeedsDisplay];
    }];
     */
}
// ------------------------------------------------------------------------------------------------
- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
// ------------------------------------------------------------------------------------------------
{
    /*
    self.highlighted = NO;
    
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.2f
                     animations:^{
        self.timeLabel.center = CGPointMake(CGRectGetMidX(self.staticLableRect),
                                            CGRectGetMidY(self.staticLableRect));
    }
                     completion:^(BOOL finished) {
        [self setNeedsDisplay];
    }];
    */
}

#pragma mark - Accessibility
// ------------------------------------------------------------------------------------------------
- (BOOL)isAccessibilityElement
// ------------------------------------------------------------------------------------------------
{
    return YES;
}
// ------------------------------------------------------------------------------------------------
- (NSString*)accessibilityValue
// ------------------------------------------------------------------------------------------------
{
    return [NSString stringWithFormat:@"%@ %@", self.timeLabel.text, self.titleLabel.text];
}
// ------------------------------------------------------------------------------------------------
- (UIAccessibilityTraits)accessibilityTraits
// ------------------------------------------------------------------------------------------------
{
    return UIAccessibilityTraitAdjustable;
}
// ------------------------------------------------------------------------------------------------
- (void)accessibilityIncrement
// ------------------------------------------------------------------------------------------------
{
    self.timeValue = self.timeValue + 1;
}
// ------------------------------------------------------------------------------------------------
- (void)accessibilityDecrement
// ------------------------------------------------------------------------------------------------
{
    self.timeValue = self.timeValue - 1;
}


@end
