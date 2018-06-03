// Copyright (c) 2017 Lightricks. All rights reserved.
// Created by Reuven Siman Tov. Tampered by Nimrod Gruber :).

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
//  [self.view.layer addSublayer:self.sunLayer];
  [self.view addSubview:self.sunView];
  [self.view.layer addSublayer:self.sunView.layer];
  self.sunView.layer.backgroundColor = [UIColor purpleColor].CGColor;
  self.sunView.layer.frame = CGRectMake(0, 0, 70, 70);
  self.sunView.layer.cornerRadius = self.sunView.layer.frame.size.width / 2;
}

- (void)setupEarthLayer {
  self.earthView = [[UIView alloc] init];
  self.earthLayer = [[CALayer alloc] init];

//  [self.sunLayer addSublayer:self.earthLayer];
  [self.view addSubview:self.earthView];
  [self.sunView.layer addSublayer:self.earthView.layer];
  self.earthView.layer.backgroundColor = [UIColor blueColor].CGColor;
  self.earthView.layer.frame = CGRectMake(0, 0, 30, 30);
  self.earthView.layer.cornerRadius = self.earthView.layer.frame.size.width / 2;
}

- (void)setupMoonLayer {
  self.moonLayer = [[CALayer alloc] init];
  [self.earthView.layer addSublayer:self.moonLayer];
  self.moonLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
  self.moonLayer.frame = CGRectMake(0, 0, 10, 10);
  self.moonLayer.cornerRadius = self.moonLayer.frame.size.width / 2;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  // 1) Planetary rotations.

  self.sunView.layer.position = self.view.center;

  [self createEarthAnimationWithStartingPoint:0];
  [self createMoonAnimationWithStartingPoint:0];

  // 2) Gestures control.

  [self setupTapGesture];

  // 3) Emitter things.

//  [self sunEmitterSetup];
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

- (void)handleTap:(UITapGestureRecognizer *)sender {
  // Tap earth.

  self.stopPlanetMovement = !self.stopPlanetMovement;
  CALayer *earthPosition = self.earthView.layer.presentationLayer;
  CALayer *moonPosition = self.moonLayer.presentationLayer;

  if (self.stopPlanetMovement) {
    self.earthView.layer.position = earthPosition.position;
    [self.earthView.layer removeAllAnimations];
    self.earthView.layer.transform = earthPosition.presentationLayer.transform;

    self.moonLayer.frame = moonPosition.frame;
    [self.moonLayer removeAllAnimations];
    self.moonLayer.transform = moonPosition.presentationLayer.transform;
  } else {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  for (UIView *view in [self.view subviews])
  {
    if ([view.layer.presentationLayer hitTest:touchLocation])
    {
      // This button was hit whilst moving - do something with it here
      self.sunView.layer.backgroundColor = [UIColor redColor].CGColor;
      break;
    }
  }
}

#pragma mark -
#pragma mark Animations
#pragma mark -

- (void)createEarthAnimationWithStartingPoint:(CGFloat)start {
  CGPoint center = CGPointMake(self.sunView.layer.bounds.size.width / 2,
                               self.sunView.layer.bounds.size.height / 2);
  self.earthOrbit = [UIBezierPath bezierPathWithArcCenter:center radius:130 startAngle:start
                                                 endAngle:2 * M_PI clockwise:YES];
  CAKeyframeAnimation* earthOrbitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  earthOrbitAnimation.path = self.earthOrbit.CGPath;
  earthOrbitAnimation.repeatCount = HUGE_VALF;
  earthOrbitAnimation.duration = 8.0;
  earthOrbitAnimation.rotationMode = kCAAnimationRotateAutoReverse;
  [self.earthView.layer addAnimation:earthOrbitAnimation forKey:@"pathGuide"];
}

- (void)createMoonAnimationWithStartingPoint:(CGFloat)start {
  CGPoint center = CGPointMake(self.earthView.layer.bounds.size.width / 2,
                       self.earthView.layer.bounds.size.height / 2);
  self.moonOrbit = [UIBezierPath bezierPathWithArcCenter:center radius:50 startAngle:0
                                                endAngle:2 * M_PI clockwise:NO];
  CAKeyframeAnimation* moonOrbitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  moonOrbitAnimation.path = self.moonOrbit.CGPath;
  moonOrbitAnimation.repeatCount = HUGE_VALF;
  moonOrbitAnimation.duration = 4.0;
  [self.moonLayer addAnimation:moonOrbitAnimation forKey:@"pathGuide"];
}

- (void)sunEmitterSetup {

  CAEmitterLayer *emitterLayer = [CAEmitterLayer layer]; // 1
  emitterLayer.emitterPosition =
      CGPointMake(self.sunView.frame.origin.x, self.sunView.frame.origin.y); // 2
  //  emitterLayer.emitterZPosition = 10; // 3
  emitterLayer.emitterSize =
      CGSizeMake(self.sunView.frame.size.width, self.sunView.frame.size.height); // 4
  emitterLayer.emitterShape = kCAEmitterLayerLine; //kCAEmitterLayerSphere; // 5
  CAEmitterCell *emitterCell = [CAEmitterCell emitterCell]; // 6
  emitterCell.scale = 0.1; // 7
  emitterCell.scaleRange = M_PI * 2.0; // 8
    emitterCell.emissionRange = (CGFloat)M_PI_2 * 2; // 9
  emitterCell.lifetime = 5.0; // 10
  emitterCell.birthRate = 10; // 11
  emitterCell.velocity = 200; // 12
  emitterCell.velocityRange = 50; // 13
  emitterCell.yAcceleration = 250; // 14
  emitterCell.contents = (id)[[UIImage imageNamed:@"yellow dot.jpg"] CGImage]; // 15
  emitterLayer.emitterCells = @[emitterCell]; // 16
  emitterLayer.beginTime = CACurrentMediaTime();
  [self.sunView.layer addSublayer:emitterLayer]; // 17
}

@end
