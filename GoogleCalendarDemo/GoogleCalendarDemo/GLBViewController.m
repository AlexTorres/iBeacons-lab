//
//  GLBViewController.m
//  GoogleCalendarDemo
//
//  Created by Camila Gaitan Mosquera on 12/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBViewController.h"
#import "GLBCalendarVC.h"


@interface GLBViewController ()

@end

@implementation GLBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.profileTableView setDelegate:self];
    [self.profileTableView setDataSource:self];
    
    self.arrProfileInfo = [[NSMutableArray alloc] init];
    self.arrProfileInfoLabel = [[NSMutableArray alloc] init];
    
    self.googleOAuth = [[GoogleOAuth alloc] initWithFrame:self.view.frame];
    [self.googleOAuth setGoogleDelegate:self];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate-UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrProfileInfo count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        [[cell textLabel] setFont:[UIFont fontWithName:@"Trebuchet MS" size:15.0]];
        [[cell textLabel] setShadowOffset:CGSizeMake(1.0, 1.0)];
        [[cell textLabel] setShadowColor:[UIColor whiteColor]];
        
        [[cell detailTextLabel] setFont:[UIFont fontWithName:@"Trebuchet MS" size:13.0]];
        [[cell detailTextLabel] setTextColor:[UIColor grayColor]];
    }
    
    [[cell textLabel] setText:[self.arrProfileInfo objectAtIndex:[indexPath row]]];
    [[cell detailTextLabel] setText:[self.arrProfileInfoLabel objectAtIndex:[indexPath row]]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

#pragma mark - GoogleOAuthDelegate

-(void)authorizationWasSuccessful{
    [self.googleOAuth callAPI:@"https://www.googleapis.com/oauth2/v1/userinfo"
           withHttpMethod:httpMethod_GET
       postParameterNames:nil postParameterValues:nil];
}

-(void)accessTokenWasRevoked{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Your access was revoked!"
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    [self.arrProfileInfo removeAllObjects];
    [self.arrProfileInfoLabel removeAllObjects];
    
    [self.profileTableView reloadData];
}

-(void)errorOccuredWithShortDescription:(NSString *)errorShortDescription andErrorDetails:(NSString *)errorDetails{
    NSLog(@"%@", errorShortDescription);
    NSLog(@"%@", errorDetails);
}


-(void)errorInResponseWithBody:(NSString *)errorMessage{
    NSLog(@"%@", errorMessage);
}

-(void)responseFromServiceWasReceived:(NSString *)responseJSONAsString andResponseJSONAsData:(NSData *)responseJSONAsData{
    if ([responseJSONAsString rangeOfString:@"family_name"].location != NSNotFound) {
        NSError *error;

        self.user = [[GLBUser alloc] initWithString:responseJSONAsString error:&error];
        if (error) {
            NSLog(@"An error occured while converting JSON data to dictionary.");
            return;
        }
        else{
            if (self.arrProfileInfoLabel != nil) {
                self.arrProfileInfoLabel = nil;
                self.arrProfileInfo = nil;
                self.arrProfileInfo = [[NSMutableArray alloc] init];
            }
            
            self.arrProfileInfoLabel = [[NSMutableArray alloc] initWithArray:[[self.user toDictionary] allKeys] copyItems:YES];
            for (int i=0; i<[self.arrProfileInfoLabel count]; i++) {
                [self.arrProfileInfo addObject:[[self.user toDictionary]  objectForKey:[self.arrProfileInfoLabel objectAtIndex:i]]];
            }
            
            [self.profileTableView reloadData];
        }
    }
}

#pragma mark - Actions

- (IBAction)showProfile:(id)sender {
    [self.googleOAuth authorizeUserWithClienID:@"235444343229-k7bj8s0riteabglnos2gdunfie6h4nkc.apps.googleusercontent.com"
                           andClientSecret:@"19iLAaf_9CUzRU9TS7pnmszX"
                             andParentView:self.view
                                 andScopes:[NSArray arrayWithObjects:@"https://www.googleapis.com/auth/userinfo.profile", @"https://www.googleapis.com/auth/calendar",@"https://www.googleapis.com/auth/calendar.readonly",nil]
     ];
}

- (IBAction)revokeAccess:(id)sender {
    [self.googleOAuth revokeAccessToken];
}

- (IBAction)calendarEvents:(id)sender {
    [self performSegueWithIdentifier:@"gotoCalendar" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GLBCalendarVC *calendarVC = segue.destinationViewController;
    [calendarVC setUser:self.user];
    [calendarVC setGoogleOAuth:self.googleOAuth];
    [calendarVC setTitle:@"Events"];
}

@end
