// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by Reuven Nimrod Gruber.

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (strong, nonatomic) UIView *sunView;
@property (strong, nonatomic) UIView *earthView;
@property (strong, nonatomic) UIView *moonView;

@property (strong, nonatomic, nullable) CALayer *sunLayer;
@property (strong, nonatomic, nullable) CALayer *earthLayer;
@property (strong, nonatomic, nullable) CALayer *moonLayer;

@property (strong, nonatomic, nullable) UIBezierPath *sunOrbit;
@property (strong, nonatomic, nullable) UIBezierPath *earthOrbit;
@property (strong, nonatomic, nullable) UIBezierPath *moonOrbit;

@property (nonatomic) BOOL stopPlanetMovement;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor blackColor];
  self.stopPlanetMovement = NO;

  [self setupSunLayer];
  [self setupEarthLayer];
  [self setupMoonLayer];
}

- (void)setupSunLayer {
  self.sunView = [[UIView alloc] init];
  self.sunLayer = [[CALayer alloc] init];

  [self.view addSubview:self.sunView];
  [self.view.layer addSublayer:self.sunView.layer];
  self.sunView.layer.frame = CGRectMake(0, 0, 140, 140);
  self.sunView.layer.cornerRadius = self.sunView.layer.frame.size.width / 2;

  UIImageView *sunImage = [[UIImageView alloc] init];
  sunImage.image = [UIImage imageNamed:@"sun.png"];
  [self.sunView addSubview:sunImage];
  sunImage.frame = self.sunView.layer.frame;
}

- (void)setupEarthLayer {
  self.earthView = [[UIView alloc] init];
  self.earthLayer = [[CALayer alloc] init];

  [self.view addSubview:self.earthView];
  [self.sunView.layer addSublayer:self.earthView.layer];
//  self.earthView.layer.backgroundColor = [UIColor blueColor].CGColor;
  self.earthView.layer.frame = CGRectMake(0, 0, 60, 60);
  self.earthView.layer.cornerRadius = self.earthView.layer.frame.size.width / 2;

  UIImageView *earthImage = [[UIImageView alloc] init];
  earthImage.image = [UIImage imageNamed:@"earth.png"];
  [self.earthView addSubview:earthImage];
  earthImage.frame = self.earthView.layer.frame;
}

- (void)setupMoonLayer {
  self.moonView= [[UIView alloc] init];
  self.moonLayer = [[CALayer alloc] init];

  [self.earthView addSubview:self.moonView];
  [self.earthView.layer addSublayer:self.moonView.layer];
//  self.moonView.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
  self.moonView.layer.frame = CGRectMake(0, 0, 20, 20);
  self.moonView.layer.cornerRadius = self.moonView.layer.frame.size.width / 2;

  UIImageView *moonImage = [[UIImageView alloc] init];
  moonImage.image = [UIImage imageNamed:@"moon.png"];
  [self.moonView addSubview:moonImage];
  moonImage.frame = self.moonView.layer.frame;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  // 1) Planetary rotations.

  self.sunView.layer.position = self.view.center;

  [self createSunAnimationWithStartingPoint:0];
  [self createEarthAnimationWithStartingPoint:0];
  [self createMoonAnimationWithStartingPoint:0];

  // 2) Gestures control.

  [self setupTapGesture];

  // 3) Emitter things.

  [self sunEmitterSetup];
}

#pragma mark -
#pragma mark Gestures
#pragma mark -

- (void)setupTapGesture {
  UITapGestureRecognizer *tapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self // Works only on self.
                                              action:@selector(handleTap:)];
  [self.view addGestureRecognizer:tapRecognizer];
}

// CALayer* layerThatWasTapped = [line.layer hitTest:[gestureRecognizer locationInView:line]];
- (void)handleTap:(UITapGestureRecognizer *)sender {
  // Tap earth.

  self.stopPlanetMovement = !self.stopPlanetMovement;
  CALayer *sunPosition = self.sunView.layer.presentationLayer;
  CALayer *earthPosition = self.earthView.layer.presentationLayer;
  CALayer *moonPosition = self.moonLayer.presentationLayer;

  if (self.stopPlanetMovement) {
    self.sunView.layer.position = sunPosition.position;
    [self.sunView.layer removeAllAnimations];
    self.sunView.layer.transform = earthPosition.presentationLayer.transform;

    self.earthView.layer.position = earthPosition.position;
    [self.earthView.layer removeAllAnimations];
    self.earthView.layer.transform = earthPosition.presentationLayer.transform;

    self.moonLayer.frame = moonPosition.frame;
    [self.moonView.layer removeAllAnimations];
    self.moonLayer.transform = moonPosition.presentationLayer.transform;
//    [self.view layoutIfNeeded];
  } else {
    [self createSunAnimationWithStartingPoint:[sunPosition.presentationLayer position].x];
    [self createEarthAnimationWithStartingPoint:[earthPosition.presentationLayer position].x];
    [self createMoonAnimationWithStartingPoint:[moonPosition.presentationLayer position].x];
  }

  // Tap sun.
  CABasicAnimation* selectionAnimation = [CABasicAnimation
                                          animationWithKeyPath:@"backgroundColor"];
  selectionAnimation.toValue = self.stopPlanetMovement ? (id)[UIColor redColor].CGColor :
      (id)[UIColor yellowColor].CGColor;
  [self.sunView.layer addAnimation:selectionAnimation forKey:@"selectionAnimation"];

  self.sunView.layer.backgroundColor = self.stopPlanetMovement ? [UIColor redColor].CGColor :
      [UIColor yellowColor].CGColor;

  CATransition* transition = [CATransition animation];
  transition.startProgress = 0;
  transition.endProgress = 1.0;
  transition.type = kCATransitionFade;
  transition.subtype = kCATransitionFade;
  transition.duration = 1.0;

  [self.sunView.layer addAnimation:transition forKey:@"transition"];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//  UITouch *touch = [touches anyObject];
//  CGPoint touchLocation = [touch locationInView:self.view];
//  for (UIView *view in [self.view subviews])
//  {
//    if ([view.layer.presentationLayer hitTest:touchLocation])
//    {
//      // This button was hit whilst moving - do something with it here
//      self.sunView.layer.backgroundColor = [UIColor grayColor].CGColor;
//      break;
//    }
//  }
//}

#pragma mark -
#pragma mark Animations
#pragma mark -

- (void)createSunAnimationWithStartingPoint:(CGFloat)start {
  CGPoint center = CGPointMake(self.view.center.x, self.view.center.y);
  self.sunOrbit = [UIBezierPath bezierPathWithArcCenter:center radius:1 startAngle:start
                                                 endAngle:2 * M_PI clockwise:YES];
  CAKeyframeAnimation* sunOrbitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  sunOrbitAnimation.path = self.sunOrbit.CGPath;
  sunOrbitAnimation.repeatCount = HUGE_VALF;
  sunOrbitAnimation.duration = 6;
  sunOrbitAnimation.rotationMode = kCAAnimationRotateAutoReverse;
  [self.sunView.layer addAnimation:sunOrbitAnimation forKey:@"path"];
}

- (void)createEarthAnimationWithStartingPoint:(CGFloat)start {
  CGPoint center = CGPointMake(self.sunView.layer.bounds.size.width / 2,
                               self.sunView.layer.bounds.size.height / 2);
  self.earthOrbit = [UIBezierPath bezierPathWithArcCenter:center radius:250 startAngle:start
                                                 endAngle:2 * M_PI clockwise:YES];
  CAKeyframeAnimation* earthOrbitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  earthOrbitAnimation.path = self.earthOrbit.CGPath;
  earthOrbitAnimation.repeatCount = HUGE_VALF;
  earthOrbitAnimation.duration = 8.0;
  earthOrbitAnimation.rotationMode = kCAAnimationRotateAutoReverse;
  [self.earthView.layer addAnimation:earthOrbitAnimation forKey:@"path"];
}

- (void)createMoonAnimationWithStartingPoint:(CGFloat)start {
  CGPoint center = CGPointMake(self.earthView.layer.bounds.size.width / 2,
                       self.earthView.layer.bounds.size.height / 2);
  self.moonOrbit = [UIBezierPath bezierPathWithArcCenter:center radius:80 startAngle:0
                                                endAngle:2 * M_PI clockwise:NO];
  CAKeyframeAnimation* moonOrbitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  moonOrbitAnimation.path = self.moonOrbit.CGPath;
  moonOrbitAnimation.repeatCount = HUGE_VALF;
  moonOrbitAnimation.duration = 1.0;
  moonOrbitAnimation.rotationMode = kCAAnimationRotateAutoReverse;
  [self.moonView.layer addAnimation:moonOrbitAnimation forKey:@"path"];
}

- (void)sunEmitterSetup {
  CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
  emitterLayer.emitterPosition =
      CGPointMake(self.sunView.bounds.origin.x + self.sunView.frame.size.width / 2,
                  self.sunView.bounds.origin.y + self.sunView.frame.size.height / 2);
  emitterLayer.emitterZPosition = 0;
  emitterLayer.emitterSize = CGSizeMake(2, 2);
  emitterLayer.emitterShape = kCAEmitterLayerSphere;
  CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
  emitterCell.scale = 0.0001;
  emitterCell.scaleRange = 0.015;
  emitterCell.emissionRange = (CGFloat)M_PI_2 * 6;
  emitterCell.lifetime = 5.0;
  emitterCell.birthRate = 900;
  emitterCell.velocity = 20;
  emitterCell.velocityRange = 50;
  emitterCell.yAcceleration = 0;
  emitterCell.contents = (id)[[UIImage imageNamed:@"sun.png"] CGImage];
  emitterLayer.emitterCells = @[emitterCell];
  emitterLayer.beginTime = CACurrentMediaTime();
  [self.sunView.layer addSublayer:emitterLayer];
}

@end
