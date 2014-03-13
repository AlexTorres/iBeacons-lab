//
//  GLBViewController.m
//  GoogleCalendarDemo
//
//  Created by Camila Gaitan Mosquera on 12/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBViewController.h"

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
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseJSONAsData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&error];
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
            
            self.arrProfileInfoLabel = [[NSMutableArray alloc] initWithArray:[dictionary allKeys] copyItems:YES];
            for (int i=0; i<[self.arrProfileInfoLabel count]; i++) {
                [self.arrProfileInfo addObject:[dictionary objectForKey:[self.arrProfileInfoLabel objectAtIndex:i]]];
            }
            
            [self.profileTableView reloadData];
        }
    }
}

#pragma mark - Actions

- (IBAction)showProfile:(id)sender {
    [self.googleOAuth authorizeUserWithClienID:@"855181453471.apps.googleusercontent.com"
                           andClientSecret:@"ooyZUrGgdp7rGM37SSRtReJ4"
                             andParentView:self.view
                                 andScopes:[NSArray arrayWithObjects:@"https://www.googleapis.com/auth/userinfo.profile", nil]
     ];
}

- (IBAction)revokeAccess:(id)sender {
    [self.googleOAuth revokeAccessToken];
}

@end
