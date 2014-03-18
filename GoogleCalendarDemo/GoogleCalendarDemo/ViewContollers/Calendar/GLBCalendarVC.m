		//
//  GLBCalendarVC.m
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 13/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBCalendarVC.h"
#import "GLBCalendarListItem.h"
#import "GLBAddEventVC.h"

#define kAddEventSegue @"gotoAddEvent"

@interface GLBCalendarVC ()

@end

@implementation GLBCalendarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.googleOAuth setGoogleDelegate:self];
    [self.googleOAuth callAPI:@"https://www.googleapis.com/calendar/v3/users/me/calendarList"
               withHttpMethod:httpMethod_GET
           postParameterNames:nil
          postParameterValues:nil];



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ClassMethods
- (void)callCalendarEvents
{
    
    //"https://www.googleapis.com/calendar/v3/calendars/jalexandert@gmail.com/events"
 
    GLBCalendarListItem * calendarListItem = self.calendarList.items[0];
    NSString *path = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/calendars/%@/events",calendarListItem.calendarID];
    NSLog(@"%@",calendarListItem.calendarID);
    [self.googleOAuth setGoogleDelegate:self];
    [self.googleOAuth callAPI:path
               withHttpMethod:httpMethod_GET
           postParameterNames:nil
          postParameterValues:nil];
    
    

}

#pragma mark - UITableViewDelegate-UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.calendarList.items count];
    
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
    
   [[cell textLabel] setText:[[self.calendarList.items objectAtIndex:[indexPath row]] calendarID]];
   [[cell detailTextLabel] setText:[[self.calendarList.items objectAtIndex:[indexPath row]] summary]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCalendarListItem = self.calendarList.items[[indexPath row]];
    [self performSegueWithIdentifier:kAddEventSegue sender:self];
}

#pragma mark - GoogleApiDelegateMethods
-(void)authorizationWasSuccessful{

}

-(void)accessTokenWasRevoked {
}

-(void)errorOccuredWithShortDescription:(NSString *)errorShortDescription andErrorDetails:(NSString *)errorDetails{
    NSLog(@"%@", errorShortDescription);
    NSLog(@"%@", errorDetails);
}


-(void)errorInResponseWithBody:(NSString *)errorMessage{
    NSLog(@"%@", errorMessage);
}
-(void)responseFromServiceWasReceived:(NSString *)responseJSONAsString andResponseJSONAsData:(NSData *)responseJSONAsData{
     NSError *error;
    if ([responseJSONAsString rangeOfString:@"calendarList"].location != NSNotFound)
    {
        self.calendarList = [[GLBCalendarList alloc] initWithString:responseJSONAsString error:&error];
        if (error) {
            NSLog(@"An error occured while converting JSON data to dictionary. %@",[error localizedDescription]);
            return;
        }
        
        [self.calendarsTable reloadData];
       // [self callCalendarEvents];

    }
    else {
    // TODO the event list
    }

    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    GLBAddEventVC *addEventVC = segue.destinationViewController;
    [addEventVC setUser:self.user];
    [addEventVC setGoogleOAuth:self.googleOAuth];
    [addEventVC setTitle:@"Add Event"];
    [addEventVC setSelectedCalendarListItem:self.selectedCalendarListItem];
}


@end
