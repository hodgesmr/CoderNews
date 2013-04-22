//
//  AboutViewController.h
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AboutViewController : BaseViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *coderNewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *forkButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
- (IBAction)followTap:(id)sender;
- (IBAction)forkTap:(id)sender;
- (IBAction)contactTap:(id)sender;

@end
