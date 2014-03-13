//
//  GLBViewController.h
//  GoogleCalendarDemo
//
//  Created by Camila Gaitan Mosquera on 12/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleOAuthLibrary/GoogleOAuth.h"


@interface GLBViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,GoogleOAuthDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revokeButton;
@property (nonatomic, strong) NSMutableArray *arrProfileInfo;
@property (nonatomic, strong) NSMutableArray *arrProfileInfoLabel;
@property (nonatomic, strong) GoogleOAuth *googleOAuth;

- (IBAction)showProfile:(id)sender;
- (IBAction)revokeAccess:(id)sender;

@end
