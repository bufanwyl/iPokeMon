//
//  TrainerInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerCardViewController.h"

#import "GlobalRender.h"
#import "TrainerBadgeView.h"
#import "TrainerController.h"

#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
 kTrainerInfoSettingButtonTypeName   = 100,
 kTrainerInfoSettingButtonTypeAvatar 
}TrainerInfoSettingButtonType;


@interface TrainerCardViewController () {
 @private
  TrainerController * trainer_;
  UIView            * mainView_;
  UIImageView       * imageView_;
  UIView            * IDView_;
  UILabel           * IDLabel_;
  UILabel           * nameLabel_;
  UIView            * dataView_;
  UILabel           * moneyLabel_;
  UILabel           * moneyValue_;
  UILabel           * pokedexLabel_;
  UILabel           * pokedexValue_;
  TrainerBadgeView  * badgeView_;
  UILabel           * adventureStartedTimeLabel_;
  UILabel           * adventureStartedTimeValue_;
  
  UITapGestureRecognizer * twoFingersTwoTapsGestureRecognizer_;
  BOOL                     isSetttingButtonsHidden_;
  UIButton               * avatarSetttingButton_;
  UIButton               * nameSettingButton_;
  UIView                 * settingView_;
  UITextField            * nameSettingField_;
  UIView                 * transparentView_;
}

@property (nonatomic, retain) TrainerController * trainer;
@property (nonatomic, retain) UIView            * mainView;
@property (nonatomic, retain) UIImageView       * imageView;
@property (nonatomic, retain) UIView            * IDView;
@property (nonatomic, retain) UILabel           * IDLabel;
@property (nonatomic, retain) UILabel           * nameLabel;
@property (nonatomic, retain) UIView            * dataView;
@property (nonatomic, retain) UILabel           * moneyLabel;
@property (nonatomic, retain) UILabel           * moneyValue;
@property (nonatomic, retain) UILabel           * pokedexLabel;
@property (nonatomic, retain) UILabel           * pokedexValue;
@property (nonatomic, retain) TrainerBadgeView  * badgeView;
@property (nonatomic, retain) UILabel           * adventureStartedTimeLabel;
@property (nonatomic, retain) UILabel           * adventureStartedTimeValue;

@property (nonatomic, retain) UITapGestureRecognizer * twoFingersTwoTapsGestureRecognizer;
@property (nonatomic, assign) BOOL                     isSetttingButtonsHidden;
@property (nonatomic, retain) UIButton               * avatarSetttingButton;
@property (nonatomic, retain) UIButton               * nameSettingButton;
@property (nonatomic, retain) UIView                 * settingView;
@property (nonatomic, retain) UITextField            * nameSettingField;
@property (nonatomic, retain) UIView                 * transparentView;

- (void)tapViewAction:(UITapGestureRecognizer *)recognizer;
- (void)setSettingButtonsHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)showSettingView:(id)sender;
- (void)commitSetting;
- (void)cancelSettingViewAnimated:(BOOL)animated;

@end

@implementation TrainerCardViewController

@synthesize trainer      = trainer_;
@synthesize mainView     = mainView_;
@synthesize imageView    = imageView_;
@synthesize IDView       = IDView_;
@synthesize IDLabel      = IDLabel_;
@synthesize nameLabel    = nameLabel_;
@synthesize dataView     = dataView_;
@synthesize moneyLabel   = moneyLabel_;
@synthesize moneyValue   = moneyValue_;
@synthesize pokedexLabel = pokedexLabel_;
@synthesize pokedexValue = pokedexValue_;
@synthesize badgeView    = badgeView_;
@synthesize adventureStartedTimeLabel = adventureStartedTimeLabel_;
@synthesize adventureStartedTimeValue = adventureStartedTimeValue_;

@synthesize twoFingersTwoTapsGestureRecognizer = twoFingersTwoTapsGestureRecognizer_;
@synthesize isSetttingButtonsHidden            = isSetttingButtonsHidden_;
@synthesize avatarSetttingButton               = avatarSetttingButton_;
@synthesize nameSettingButton                  = nameSettingButton_;
@synthesize settingView                        = settingView_;
@synthesize nameSettingField                   = nameSettingField_;
@synthesize transparentView                    = transparentView_;

- (void)dealloc
{
  [super dealloc];
  
  self.trainer = nil;
  [mainView_     release];
  [imageView_    release];
  [IDView_       release];
  [IDLabel_      release];
  [nameLabel_    release];
  [dataView_     release];
  [moneyLabel_   release];
  [moneyValue_   release];
  [pokedexLabel_ release];
  [pokedexValue_ release];
  [badgeView_    release];
  [adventureStartedTimeLabel_ release];
  [adventureStartedTimeValue_ release];
  
  [twoFingersTwoTapsGestureRecognizer_ release];
  self.avatarSetttingButton = nil;
  self.nameSettingButton    = nil;
  self.settingView          = nil;
  self.nameSettingField     = nil;
  self.transparentView      = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.trainer = [TrainerController sharedInstance];
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
  
  // Constants
  CGFloat const imageHeight       = 100.f;
  CGFloat const imageWidth        = 100.f;
  CGFloat const labelHeight       = 30.f;
  CGFloat const labelWidth        = 105.f;
  CGFloat const valueHeight       = 30.f;
  CGFloat const valueWidth        = 290.f - labelWidth;
  CGFloat const nameLabelWidth    = 290.f - imageWidth;
  CGFloat const nameLabelHeight   = imageHeight / 2 - labelHeight;
  
  CGRect  const mainViewFrame     = CGRectMake(0.f, kTopBarHeight, kViewWidth, kViewHeight - kTopBarHeight);
  CGRect  const IDViewFrame       = CGRectMake(imageWidth + 30.f, 30.f, 290.f - imageWidth, imageHeight - 50.f);
  CGRect  const dataViewFrame     = CGRectMake(15.f, imageHeight + 35.f, 290.f, 195.f);
  CGRect  const IDLabelFrame      = CGRectMake(0.f, 0.f, IDViewFrame.size.width, labelHeight);
  CGRect  const nameLabelFrame    = CGRectMake(0.f, labelHeight, nameLabelWidth, nameLabelHeight);
  CGRect  const badgeViewFrame    = CGRectMake(0.f, labelHeight * 2, 290.f, labelHeight);
  CGRect  const adventureStartedTimeLabelFrame =
    CGRectMake(0.f, dataViewFrame.size.height - labelHeight, 150.f, labelHeight);
  CGRect  const adventureStartedTimeValueFrame =
    CGRectMake(150.f, dataViewFrame.size.height - labelHeight, 140.f, valueHeight);
  
  
  // Main View
  mainView_ = [[UIView alloc] initWithFrame:mainViewFrame];
  [self.view addSubview:mainView_];
  
  ///Left Image View
  imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 20.f, imageWidth, imageHeight)];
  [imageView_ setUserInteractionEnabled:YES];
  [imageView_ setContentMode:UIViewContentModeCenter];
  [imageView_ setBackgroundColor:[UIColor clearColor]];
  [imageView_.layer setMasksToBounds:YES];
  [imageView_.layer setCornerRadius:5.f];
  [self.mainView addSubview:imageView_];
  
  
  ///Right ID View
  IDView_ = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  IDLabel_ = [[UILabel alloc] initWithFrame:IDLabelFrame];
  [IDLabel_ setBackgroundColor:[UIColor clearColor]];
  [IDLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [IDLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [IDLabel_.layer setShadowColor:[UIColor blackColor].CGColor];
  [IDLabel_.layer setShadowOpacity:1.f];
  [IDLabel_.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [IDLabel_.layer setShadowRadius:0.f];
  [IDView_ addSubview:IDLabel_];
  
  // Name
  nameLabel_ = [[UILabel alloc] initWithFrame:nameLabelFrame];
  [nameLabel_ setBackgroundColor:[UIColor clearColor]];
  [nameLabel_ setLineBreakMode:UILineBreakModeWordWrap];
  [nameLabel_ setTextColor:[GlobalRender textColorOrange]];
  [nameLabel_ setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [nameLabel_ setNumberOfLines:0];
  [nameLabel_.layer setShadowColor:[UIColor blackColor].CGColor];
  [nameLabel_.layer setShadowOpacity:1.f];
  [nameLabel_.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [nameLabel_.layer setShadowRadius:0.f];
  [IDView_ addSubview:nameLabel_];
  
  [self.mainView addSubview:IDView_];
  
  
  ///Data View in Center
  dataView_ = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Money
  moneyLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, labelWidth, labelHeight)];
  moneyValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0.f, valueWidth, valueHeight)];
  [moneyLabel_ setBackgroundColor:[UIColor clearColor]];
  [moneyValue_ setBackgroundColor:[UIColor clearColor]];
  [moneyLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [moneyValue_ setTextColor:[GlobalRender textColorNormal]];
  [moneyLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [moneyValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [moneyLabel_ setTextAlignment:UITextAlignmentRight];
  [moneyValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:moneyLabel_];
  [dataView_ addSubview:moneyValue_];
  
  // Pokedex
  pokedexLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.f, labelHeight, labelWidth, labelHeight)];
  pokedexValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight, valueWidth, valueHeight)];
  [pokedexLabel_ setBackgroundColor:[UIColor clearColor]];
  [pokedexValue_ setBackgroundColor:[UIColor clearColor]];
  [pokedexLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [pokedexValue_ setTextColor:[GlobalRender textColorNormal]];
  [pokedexLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [pokedexValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [pokedexLabel_ setTextAlignment:UITextAlignmentRight];
  [pokedexValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:pokedexLabel_];
  [dataView_ addSubview:pokedexValue_];
  
  // Badges
  badgeView_ = [[TrainerBadgeView alloc] initWithFrame:badgeViewFrame];
  [self.dataView addSubview:badgeView_];
  
  // Adventure Started
  adventureStartedTimeLabel_ = [[UILabel alloc] initWithFrame:adventureStartedTimeLabelFrame];
  adventureStartedTimeValue_ = [[UILabel alloc] initWithFrame:adventureStartedTimeValueFrame];
  [adventureStartedTimeLabel_ setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeValue_ setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [adventureStartedTimeValue_ setTextColor:[GlobalRender textColorNormal]];
  [adventureStartedTimeLabel_ setFont:[GlobalRender textFontBoldInSizeOf:13.f]];
  [adventureStartedTimeValue_ setFont:[GlobalRender textFontBoldInSizeOf:13.f]];
  [adventureStartedTimeLabel_ setTextAlignment:UITextAlignmentRight];
  [adventureStartedTimeValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:adventureStartedTimeLabel_];
  [dataView_ addSubview:adventureStartedTimeValue_];
  
  [self.mainView addSubview:dataView_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Basic Setting
  isSetttingButtonsHidden_ = YES;
  
  [self.imageView setImageWithURL:[self.trainer avatarURL]
                 placeholderImage:[UIImage imageNamed:@"UserAvatar.png"]];
  [self.IDLabel setText:[NSString stringWithFormat:@"ID: #%.8d", [self.trainer UID]]];
  [self.moneyLabel   setText:NSLocalizedString(@"PMSLabelMoney", nil)];
  [self.pokedexLabel setText:NSLocalizedString(@"PMSLabelPokedex", nil)];
  [self.badgeView updateBadges:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil]];
  [self.adventureStartedTimeLabel setText:NSLocalizedString(@"PMSLabelAdventureStarted", nil)];
  NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
  [self.adventureStartedTimeValue setText:[dateFormat stringFromDate:[self.trainer timeStarted]]];
  [dateFormat release];
  
  // Add Gesture
  // Two fingers with two taps to show setting buttons for Trainer Info View
  UITapGestureRecognizer * twoFingersTwoTapsGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
  self.twoFingersTwoTapsGestureRecognizer = twoFingersTwoTapsGestureRecognizer;
  [twoFingersTwoTapsGestureRecognizer release];
  [self.twoFingersTwoTapsGestureRecognizer setNumberOfTapsRequired:2];
  [self.twoFingersTwoTapsGestureRecognizer setNumberOfTouchesRequired:2];
  [self.view addGestureRecognizer:self.twoFingersTwoTapsGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Set new data
  [self.nameLabel setText:[self.trainer name]];
  [self.nameLabel sizeToFit];
  [self.moneyValue setText:[NSString stringWithFormat:@"$ %d", [self.trainer money]]];
  
  NSArray * tamedPokemonSeq = [[self.trainer pokedex] componentsSeparatedByString:@"1"];
  NSInteger pokedexValue = [tamedPokemonSeq count] >= 1 ? [tamedPokemonSeq count] - 1 : 0;
  [self.pokedexValue setText:[NSString stringWithFormat:@"%d", pokedexValue]];
  tamedPokemonSeq = nil;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.imageView    = nil;
  self.IDView       = nil;
  self.IDLabel      = nil;
  self.nameLabel    = nil;
  self.dataView     = nil;
  self.moneyLabel   = nil;
  self.moneyValue   = nil;
  self.pokedexLabel = nil;
  self.pokedexValue = nil;
  self.badgeView    = nil;
  self.adventureStartedTimeLabel = nil;
  self.adventureStartedTimeValue = nil;
  
  self.twoFingersTwoTapsGestureRecognizer = nil;
  self.avatarSetttingButton               = nil;
  self.nameSettingButton                  = nil;
  self.settingView                        = nil;
  self.transparentView                    = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Method

// Action for tap gesture recognizer
- (void)tapViewAction:(UITapGestureRecognizer *)recognizer {
  // Two fingers with two taps to show setting buttons for Trainer Info View
  if (recognizer.numberOfTouchesRequired == 2 && recognizer.numberOfTapsRequired == 2) {
    NSLog(@"Two Fingers Two Taps");
    [self setSettingButtonsHidden:!self.isSetttingButtonsHidden animated:YES];
  }
}

- (void)setSettingButtonsHidden:(BOOL)hidden animated:(BOOL)animated {
  self.isSetttingButtonsHidden = hidden;
  
  /*if (self.avatarSetttingButton == nil) {
    CGRect avatarSetttingButtonFrame = self.imageView.frame;
    avatarSetttingButtonFrame.origin.x = 0;
    avatarSetttingButtonFrame.origin.y = 0;
    UIButton * avatarSetttingButton = [[UIButton alloc] initWithFrame:avatarSetttingButtonFrame];
    self.avatarSetttingButton = avatarSetttingButton;
    [avatarSetttingButton release];
    [self.avatarSetttingButton setAlpha:0.f];
    [self.avatarSetttingButton setTag:kTrainerInfoSettingButtonTypeAvatar];
    [self.avatarSetttingButton addTarget:self action:@selector(showSettingView:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.avatarSetttingButton];
    
    UIImageView * setableMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconSettingModify"]];
    [self.avatarSetttingButton addSubview:setableMarkView];
    [setableMarkView release];
  }*/
  if (self.nameSettingButton == nil) {
    CGRect nameSettingButtonFrame = self.nameLabel.frame;
    nameSettingButtonFrame.origin.x = 0;
    nameSettingButtonFrame.origin.y = 0;
    UIButton * nameSettingButton = [[UIButton alloc] initWithFrame:nameSettingButtonFrame];
    self.nameSettingButton = nameSettingButton;
    [nameSettingButton release];
    [self.nameSettingButton setAlpha:0.f];
    [self.nameSettingButton setTag:kTrainerInfoSettingButtonTypeName];
    [self.nameSettingButton addTarget:self action:@selector(showSettingView:) forControlEvents:UIControlEventTouchUpInside];
    [self.nameLabel addSubview:self.nameSettingButton];
    [self.nameLabel setUserInteractionEnabled:YES];
    
    UIImageView * setableMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconSettingModify"]];
    [setableMarkView setFrame:CGRectMake(0.f, 0.f, 22.f, 22.f)];
    [self.nameSettingButton addSubview:setableMarkView];
    [setableMarkView release];
  }
  
  CGFloat alpha = hidden ? 0.f : 1.f;
  void (^animations)() = ^{
//    [self.avatarSetttingButton setAlpha:alpha];
    [self.nameSettingButton    setAlpha:alpha];
  };
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:animations
                                 completion:nil];
  else animations();
}

- (void)showSettingView:(id)sender {
  if (self.transparentView == nil) {
    UIView * transparentView = [[UIView alloc] initWithFrame:self.view.frame];
    self.transparentView = transparentView;
    [transparentView release];
    [self.transparentView setBackgroundColor:[UIColor blackColor]];
    [self.transparentView setAlpha:0.f];
    [self.mainView addSubview:self.transparentView];
  }
  if (self.settingView == nil) {
    CGFloat buttonSize        = 45.f;
    CGFloat settingViewHeight = 120.f;
    CGRect settingViewFrame = CGRectMake(0.f, -settingViewHeight, kViewWidth, settingViewHeight);
    CGRect settingViewBackgroundFrame = CGRectMake(0.f, 0.f, kViewWidth, settingViewHeight - buttonSize / 2);
    CGRect doneButtonFrame   = CGRectMake(80.f, settingViewHeight - buttonSize, buttonSize, buttonSize);
    CGRect cancelButtonFrame = CGRectMake(kViewWidth - 80.f - buttonSize, settingViewHeight - buttonSize, buttonSize, buttonSize);
    
    
    UIView * settingView = [[UIView alloc] initWithFrame:settingViewFrame];
    self.settingView = settingView;
    [settingView release];
    [self.mainView addSubview:self.settingView];
    
    UIView * settingViewBackground = [[UIView alloc] initWithFrame:settingViewBackgroundFrame];
    [settingViewBackground setBackgroundColor:[GlobalRender colorBlue]];
    [self.settingView addSubview:settingViewBackground];
    [settingViewBackground release];
    
    UIButton * doneButton = [[UIButton alloc] initWithFrame:doneButtonFrame];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"ButtonIconConfirm.png"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(commitSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:doneButton];
    [doneButton release];
    
    UIButton * cancelButton = [[UIButton alloc] initWithFrame:cancelButtonFrame];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"ButtonIconCancel.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelSettingViewAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:cancelButton];
    [cancelButton release];
  }
  
  switch (((UIButton *)sender).tag) {
    case kTrainerInfoSettingButtonTypeName: {
      NSLog(@"Commit Setting -> Name");
      if (self.nameSettingField == nil) {
        CGRect nameSettingFieldFrame = CGRectMake(10.f, 15.f, 300.f, 32.f);
        UITextField * nameSettingField = [[UITextField alloc] initWithFrame:nameSettingFieldFrame];
        self.nameSettingField = nameSettingField;
        [self.nameSettingField release];
        [self.nameSettingField setBackgroundColor:[UIColor whiteColor]];
        [self.nameSettingField setKeyboardType:UIKeyboardTypeDefault];
      }
      [self.settingView addSubview:self.nameSettingField];
      // Set |nameLabel_.text| as the default text for |nameSettingField_|,
      //   and show Keyboard
      self.nameSettingField.text = self.nameLabel.text;
      [self.nameSettingField becomeFirstResponder];
      break;
    }
      
    case kTrainerInfoSettingButtonTypeAvatar:
      NSLog(@"Commit Setting -> Avatar");
      break;
      
    default:
      break;
  }
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.transparentView setAlpha:.6f];
                     CGRect settingViewFrame = self.settingView.frame;
                     settingViewFrame.origin.y = 0.f;
                     [self.settingView setFrame:settingViewFrame];
                   }
                   completion:nil];
}

// Commit settings done by user
- (void)commitSetting {
  NSLog(@"|commitSetting| - InputText:%@", self.nameSettingField.text);
  // If user changed name, reset |trainer_.name| & |nameLabel_.text|
  if (! [self.nameSettingField.text isEqualToString:self.nameLabel.text]) {
    NSLog(@"|commitSetting| - User name changed, do sync work...");
    [self.trainer setName:self.nameSettingField.text];
    
    CGFloat const imageSize       = 100.f;
    CGFloat const labelHeight     = 30.f;
    CGFloat const nameLabelWidth  = 290.f - imageSize;
    CGFloat const nameLabelHeight = imageSize / 2 - labelHeight;
    CGRect  const nameLabelFrame  = CGRectMake(0.0f, labelHeight, nameLabelWidth, nameLabelHeight);
    [self.nameLabel setFrame:nameLabelFrame];
    [self.nameLabel setText:[self.trainer name]];
    [self.nameLabel sizeToFit];
  }
  [self cancelSettingViewAnimated:YES];
}

// Cancel |settingView_|
- (void)cancelSettingViewAnimated:(BOOL)animated {
  void (^animations)() = ^(){
    CGRect settingViewFrame = self.settingView.frame;
    settingViewFrame.origin.y = -settingViewFrame.size.height;
    [self.settingView setFrame:settingViewFrame];
    [self.transparentView setAlpha:0.f];
  };
  
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:animations
                                 completion:nil];
  else animations();
  [self.nameSettingField removeFromSuperview];
  [self.nameSettingField resignFirstResponder];
}

@end
