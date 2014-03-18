//
//  GLBProfileVC.h
//  GoogleCalendarDemo
//
//  Created by Camila Gaitan Mosquera on 17/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLBProfileVC : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (nonatomic, strong) NSMutableArray *arrProfileInfo;
@property (nonatomic, strong) NSMutableArray *arrProfileInfoLabel;



@end
