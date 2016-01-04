//
//  DHDemoViewController.m
//  DHTimeCounterDemo
//
//  Created by Eric Holmes on 2015-12-27.
//  Copyright © 2015 DanHolmes. All rights reserved.
//

#import "DHDemoViewController.h"
#import "DHTimeCounter.h"

@interface DHDemoViewController ()

@property (nonatomic, strong) DHTimeCounter *timeCounter1;
@property (nonatomic, strong) DHTimeCounter *timeCounter2;
@property (nonatomic, strong) DHTimeCounter *timeCounter3;
@end

@implementation DHDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor colorWithRed:0.142 green:0.149 blue:0.204 alpha:1.000];
    
    _timeCounter1 = [[DHTimeCounter alloc] init];
    _timeCounter1.translatesAutoresizingMaskIntoConstraints = NO;
    _timeCounter1.color           = [UIColor greenColor];
    _timeCounter1.highlightColor  = [UIColor yellowColor];
    _timeCounter1.timeUnit        = DHCounterTimeUnitHours;
    _timeCounter1.startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-40000];
    _timeCounter1.titleLabel.text = @"hrs";
    [contentView addSubview:_timeCounter1];
    
    _timeCounter2 = [DHTimeCounter counterWithType:DHCounterTypeEqualElements];
    _timeCounter2.translatesAutoresizingMaskIntoConstraints = NO;
    _timeCounter2.color                  = [UIColor orangeColor];
    _timeCounter2.highlightColor         = [UIColor redColor];
    _timeCounter2.timeUnit               = DHCounterTimeUnitMinutes;
    _timeCounter2.startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-40000];
    _timeCounter2.titleLabel.text        = @"min";
    _timeCounter2.userInteractionEnabled = NO;
    [contentView addSubview:_timeCounter2];
    
    _timeCounter3 = [DHTimeCounter counterWithType:DHCounterTypeSolid];
    _timeCounter3.translatesAutoresizingMaskIntoConstraints = NO;
    _timeCounter3.color                  = [UIColor orangeColor];
    _timeCounter3.highlightColor         = [UIColor redColor];
    _timeCounter3.timeUnit               = DHCounterTimeUnitSeconds;
    _timeCounter3.startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-40000];
    _timeCounter3.titleLabel.text        = @"sec";
    _timeCounter3.userInteractionEnabled = NO;
    [contentView addSubview:_timeCounter3];
    
   
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"random"
            forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(random:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:button];
    
    self.view = contentView;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeCounter1
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeCounter1
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_timeCounter1
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeCounter2
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_timeCounter2
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timeCounter3
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_timeCounter3
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_timeCounter1, _timeCounter2, _timeCounter3, button);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_timeCounter1(200)]-20-[button(40)]-30-[_timeCounter2(100)]"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_timeCounter2]-[_timeCounter3(60)]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    [self.timeCounter1 startCounter];
    [self.timeCounter2 startCounter];
    [self.timeCounter3 startCounter];
  
    // Do any additional setup after loading the view.
}
- (void)random:(UIButton*)sender {
    NSUInteger randomInteger = arc4random_uniform(60);
    
    self.timeCounter1.timeValue = randomInteger;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
