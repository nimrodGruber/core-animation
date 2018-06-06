// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by Nimrod Gruber.

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (strong, nonatomic) UIView *sunView;
@property (strong, nonatomic) UIView *earthView;
@property (strong, nonatomic) UIView *moonView;

@property (strong, nonatomic)UIImageView *sunImage;

//@property (strong, nonatomic, nullable) CALayer *sunLayer;
//@property (strong, nonatomic, nullable) CALayer *earthLayer;
//@property (strong, nonatomic, nullable) CALayer *moonLayer;

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

  [self setupSun];
  [self setupEarth];
  [self setupMoon];
}

- (void)setupSun {
  self.sunView = [[UIView alloc] init];
//  self.sunLayer = [[CALayer alloc] init];

  [self.view addSubview:self.sunView];
//  self.sunView.backgroundColor = [UIColor redColor];
  self.sunView.frame =
      CGRectMake(self.view.center.x-70, self.view.center.y-70, 140, 140); // this ruins sun position. idky.
      //CGRectMake(0, 0, 140, 140);

//  self.sunView.layer.position = CGPointMake(self.view.center.x, self.view.center.y);

//  [self.view.layer addSublayer:self.sunView.layer];
  self.sunView.layer.cornerRadius = self.sunView.layer.frame.size.width / 2;

  CGImageRef imageRef =[UIImage imageNamed:@"sun.png"].CGImage;
  self.sunView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"sun.png"].CGImage);
  self.sunView.layer.contentsGravity = kCAGravityCenter;
//  [CATransaction flush];
//  self.sunImage = [[UIImageView alloc] init];

//  self.sunImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
//  self.sunImage.image = [UIImage imageNamed:@"sun.png"];
//  [self.sunView addSubview:self.sunImage];

//    [self.view addSubview:sunImage];
//  sunImage.frame = self.sunView.layer.frame;
//  self.sunImage.frame = //self.sunView.frame;
//      CGRectMake(self.view.center.x-70, self.view.center.y-70, 140, 140);
//      CGRectMake(0, 0, 140, 140);
//  [self.sunImage convertPoint:CGPointZero toView:self.sunView];

}

- (void)setupEarth {
  self.earthView = [[UIView alloc] init];
//  self.earthLayer = [[CALayer alloc] init];

  [self.view addSubview:self.earthView];
  [self.sunView.layer addSublayer:self.earthView.layer];
  self.earthView.layer.frame =
//      CGRectMake(self.sunView.center.x, self.sunView.center.y, 60, 60);
      CGRectMake(0, 0, 60, 60);

//  self.earthView.layer.position = CGPointMake(self.sunView.center.x, self.sunView.center.y);

  self.earthView.layer.cornerRadius = self.earthView.layer.frame.size.width / 2;

  UIImageView *earthImage = [[UIImageView alloc] init];
  earthImage.image = [UIImage imageNamed:@"earth.png"];
  [self.earthView addSubview:earthImage];
  earthImage.frame = self.earthView.layer.frame;
}

- (void)setupMoon {
  self.moonView= [[UIView alloc] init];
//  self.moonLayer = [[CALayer alloc] init];

  [self.earthView addSubview:self.moonView];
  [self.earthView.layer addSublayer:self.moonView.layer];
  self.moonView.layer.frame =
//      CGRectMake(self.earthView.center.x, self.earthView.center.y, 20, 20);
      CGRectMake(0, 0, 20, 20);

//  self.moonView.layer.position = CGPointMake(self.earthView.center.x, self.earthView.center.y);

  self.moonView.layer.cornerRadius = self.moonView.layer.frame.size.width / 2;

  UIImageView *moonImage = [[UIImageView alloc] init];
  moonImage.image = [UIImage imageNamed:@"moon.png"];
  [self.moonView addSubview:moonImage];
  moonImage.frame = self.moonView.layer.frame;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  // 1) Planetary rotations.

//  self.sunView.layer.position = self.view.center;

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
  CGPoint touchPoint = [sender locationInView:self.view];
  
  NSLog(@"TouchPoint:%@", NSStringFromCGPoint(touchPoint));
  NSLog(@"Moon Frame:%@", NSStringFromCGRect(self.moonView.frame));
  NSLog(@"Moon Layer:%@", NSStringFromCGRect(self.moonView.layer.frame));
  NSLog(@"Earth Frame:%@", NSStringFromCGRect(self.earthView.frame));
  NSLog(@"Earth Layer:%@", NSStringFromCGRect(self.earthView.layer.frame));
  NSLog(@"Sun Frame:%@", NSStringFromCGRect(self.sunView.frame));
  NSLog(@"Sun Layer:%@", NSStringFromCGRect(self.sunView.layer.frame));
  NSLog(@"Sun Image Frame:%@", NSStringFromCGRect(self.sunImage.frame));
  NSLog(@"***********");

//  if ([self.earthView.layer containsPoint:CGPointZero]) {
//    [self pauseResumeConstellation];
//  }
//
//  if ([self.sunView.layer containsPoint:touchPoint]) {
//    [self resetConstellation];
//  }

//  if ([self.earthView.layer hitTest:[sender locationInView:self.earthView]]) {
//    [self pauseResumeConstellation];
//  }
//
//  if ([self.sunView.layer hitTest:[sender locationInView:self.sunView]]) {
//    [self resetConstellation];
//  }

  if (CGRectContainsPoint(self.earthView.frame, touchPoint)){
    [self pauseResumeConstellation];
  }

  if (CGRectContainsPoint(self.sunView.frame, touchPoint)){
    [self resetConstellation];
  }

  // Tap earth.
//  self.stopPlanetMovement = !self.stopPlanetMovement;
//  CALayer *sunPosition = self.sunView.layer.presentationLayer;
//  CALayer *earthPosition = self.earthView.layer.presentationLayer;
//  CALayer *moonPosition = self.moonLayer.presentationLayer;
//
//  if (self.stopPlanetMovement) {
//    self.sunView.layer.position = sunPosition.position;
//    [self.sunView.layer removeAllAnimations];
//    self.sunView.layer.transform = earthPosition.presentationLayer.transform;
//
//    self.earthView.layer.position = earthPosition.position;
//    [self.earthView.layer removeAllAnimations];
//    self.earthView.layer.transform = earthPosition.presentationLayer.transform;
//
//    self.moonLayer.frame = moonPosition.frame;
//    [self.moonView.layer removeAllAnimations];
//    self.moonLayer.transform = moonPosition.presentationLayer.transform;
////    [self.view layoutIfNeeded];
//  } else {
//    [self createSunAnimationWithStartingPoint:[sunPosition.presentationLayer position].x];
//    [self createEarthAnimationWithStartingPoint:[earthPosition.presentationLayer position].x];
//    [self createMoonAnimationWithStartingPoint:[moonPosition.presentationLayer position].x];
//  }

  // Tap sun.
//  CABasicAnimation* selectionAnimation = [CABasicAnimation
//                                          animationWithKeyPath:@"backgroundColor"];
//  selectionAnimation.toValue = self.stopPlanetMovement ? (id)[UIColor redColor].CGColor :
//      (id)[UIColor yellowColor].CGColor;
//  [self.sunView.layer addAnimation:selectionAnimation forKey:@"selectionAnimation"];
//
//  self.sunView.layer.backgroundColor = self.stopPlanetMovement ? [UIColor redColor].CGColor :
//      [UIColor yellowColor].CGColor;
//
//  CATransition* transition = [CATransition animation];
//  transition.startProgress = 0;
//  transition.endProgress = 1.0;
//  transition.type = kCATransitionFade;
//  transition.subtype = kCATransitionFade;
//  transition.duration = 1.0;
//
//  [self.sunView.layer addAnimation:transition forKey:@"transition"];
}

- (void)pauseResumeConstellation {
  self.stopPlanetMovement = !self.stopPlanetMovement;
//  CALayer *sunPosition = self.sunView.layer.presentationLayer;
  CALayer *earthPosition = self.earthView.layer.presentationLayer;
  CALayer *moonPosition = self.moonView.layer.presentationLayer;//moonLayer.presentationLayer;

  if (self.stopPlanetMovement) {
//    self.sunView.layer.position = sunPosition.position;
//    [self.sunView.layer removeAllAnimations];
//    self.sunView.layer.transform = sunPosition.presentationLayer.transform;

    self.earthView.layer.position = earthPosition.frame.origin;//.position;
    [self.earthView.layer removeAllAnimations];
    self.earthView.layer.transform = earthPosition.presentationLayer.transform;

    self.moonView.layer.frame /*moonLayer.frame*/ = moonPosition.frame;
    [self.moonView.layer removeAllAnimations];
    self.moonView.layer.transform /*moonLayer.transform*/ = moonPosition.presentationLayer.transform;
  } else {
//    [self createSunAnimationWithStartingPoint:[sunPosition.presentationLayer position].x];
    [self createEarthAnimationWithStartingPoint:[earthPosition.presentationLayer position].x];
    [self createMoonAnimationWithStartingPoint:[moonPosition.presentationLayer position].x];
  }
}

- (void)resetConstellation {
//  CABasicAnimation* selectionAnimation = [CABasicAnimation
//                                          animationWithKeyPath:@"backgroundColor"];
//  selectionAnimation.toValue = self.stopPlanetMovement ? (id)[UIColor redColor].CGColor :
//  (id)[UIColor yellowColor].CGColor;
//  [self.sunView.layer addAnimation:selectionAnimation forKey:@"selectionAnimation"];
//
//  self.sunView.layer.backgroundColor = self.stopPlanetMovement ? [UIColor redColor].CGColor :
//  [UIColor yellowColor].CGColor;
//
//  CATransition* transition = [CATransition animation];
//  transition.startProgress = 0;
//  transition.endProgress = 1.0;
//  transition.type = kCATransitionFade;
//  transition.subtype = kCATransitionFade;
//  transition.duration = 1.0;
//
//  [self.sunView.layer addAnimation:transition forKey:@"transition"];
  [self.sunView.layer removeAllAnimations];
  [self.earthView.layer removeAllAnimations];
  [self.moonView.layer removeAllAnimations];
  self.earthView.layer.frame = CGRectZero;

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
  emitterCell.velocityRange = 500;
  emitterCell.yAcceleration = 0;
  emitterCell.contents = (id)[[UIImage imageNamed:@"sun.png"] CGImage];

//  CAEmitterCell *emitterCell2 = [CAEmitterCell emitterCell];
//  emitterCell2.scale = 0.0001;
//  emitterCell2.scaleRange = 0.01;
//  emitterCell2.emissionRange = (CGFloat)M_PI_2 * 6;
//  emitterCell2.lifetime = 5.0;
//  emitterCell2.birthRate = 300;
//  emitterCell2.velocity = 20;
//  emitterCell2.velocityRange = 500;
//  emitterCell2.yAcceleration = 0;
//  emitterCell2.contents = (id)[[UIImage imageNamed:@"gooDot.png"] CGImage];

  emitterLayer.emitterCells = @[emitterCell, /*emitterCell2*/];
  emitterLayer.beginTime = CACurrentMediaTime();
  [self.sunView.layer addSublayer:emitterLayer];
//  [self.sunView.layer insertSublayer:emitterLayer below:self.sunView.layer];
//  [self.sunView.layer insertSublayer:emitterLayer above:self.sunView.layer];
//  [self.view.layer insertSublayer:emitterLayer below:self.sunView.layer];
}

@end
