// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by Reuven Siman Tov. Tampered by Nimrod Gruber :).

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (strong, nonatomic, nullable) CALayer *sunLayer;
@property (strong, nonatomic, nullable) CALayer *earthLayer;
@property (strong, nonatomic, nullable) CALayer *moonLayer;

@property (strong, nonatomic, nullable) UIBezierPath *sunOrbit;
@property (strong, nonatomic, nullable) UIBezierPath *earthOrbit;
@property (strong, nonatomic, nullable) UIBezierPath *moonOrbit;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor blackColor];
  [self setupSunLayer];
  [self setupEarthLayer];
  [self setupMoonLayer];
}

- (void)setupSunLayer {
  self.sunLayer = [[CALayer alloc] init];
  [self.view.layer addSublayer:self.sunLayer];
  self.sunLayer.backgroundColor = [UIColor purpleColor].CGColor;
  self.sunLayer.frame = CGRectMake(0, 0, 70, 70);
  self.sunLayer.cornerRadius = self.sunLayer.frame.size.width;// / 2;
}

- (void)setupEarthLayer {
  self.earthLayer = [[CALayer alloc] init];
  [self.sunLayer addSublayer:self.earthLayer];
  self.earthLayer.backgroundColor = [UIColor blueColor].CGColor;
  self.earthLayer.frame = CGRectMake(0, 0, 30, 30);
  self.earthLayer.cornerRadius = self.earthLayer.frame.size.width / 3;
}

- (void)setupMoonLayer {
  self.moonLayer = [[CALayer alloc] init];
  [self.earthLayer addSublayer:self.moonLayer];
  self.moonLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
  self.moonLayer.frame = CGRectMake(0, 0, 10, 10);
  self.moonLayer.cornerRadius = self.moonLayer.frame.size.width / 6;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  self.sunLayer.position = self.view.center;

  CGPoint center = CGPointMake(self.sunLayer.bounds.size.width / 2,
                               self.sunLayer.bounds.size.height / 2);
  self.earthOrbit = [UIBezierPath bezierPathWithArcCenter:center radius:150 startAngle:0
                                                 endAngle:2 * M_PI clockwise:YES];
  CAKeyframeAnimation* earthOrbitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  earthOrbitAnimation.path = self.earthOrbit.CGPath;
  earthOrbitAnimation.repeatCount = HUGE_VALF;
  earthOrbitAnimation.duration = 8.0;
  [self.earthLayer addAnimation:earthOrbitAnimation forKey:@"pathGuide"];

  center = CGPointMake(self.earthLayer.bounds.size.width / 2,
                       self.earthLayer.bounds.size.height / 2);
  self.moonOrbit = [UIBezierPath bezierPathWithArcCenter:center radius:50 startAngle:0
                                                 endAngle:2 * M_PI clockwise:YES];
  CAKeyframeAnimation* moonOrbitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  moonOrbitAnimation.path = self.moonOrbit.CGPath;
  moonOrbitAnimation.repeatCount = HUGE_VALF;
  moonOrbitAnimation.duration = 4.0;
  [self.moonLayer addAnimation:moonOrbitAnimation forKey:@"pathGuide"];

  CAEmitterLayer *emitterLayer = [CAEmitterLayer layer]; // 1
  emitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.origin.y); // 2
  emitterLayer.emitterZPosition = 10; // 3
  emitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0); // 4
  emitterLayer.emitterShape = kCAEmitterLayerSphere; // 5
  CAEmitterCell *emitterCell = [CAEmitterCell emitterCell]; // 6
  emitterCell.scale = 0.1; // 7
  emitterCell.scaleRange = 0.2; // 8
  emitterCell.emissionRange = (CGFloat)M_PI_2; // 9
  emitterCell.lifetime = 5.0; // 10
  emitterCell.birthRate = 10; // 11
  emitterCell.velocity = 200; // 12
  emitterCell.velocityRange = 50; // 13
  emitterCell.yAcceleration = 250; // 14
  emitterCell.contents = self.sunLayer;//(id)[[UIImage imageNamed:@"WaterDrop.png"] CGImage]; // 15
  emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell]; // 16
  [self.view.layer addSublayer:emitterLayer]; // 17
}

@end
