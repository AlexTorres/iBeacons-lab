		//
//  GLBCalendarVC.m
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 13/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBCalendarVC.h"
#import "GLBCalendarListItem.h"

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
 
    GLBCalendarListItem * calendarListItem = [self.calendarList.items objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/calendars/%@/events",calendarListItem.calendarID];
    NSLog(@"%@",calendarListItem.calendarID);
    [self.googleOAuth setGoogleDelegate:self];
    [self.googleOAuth callAPI:path
               withHttpMethod:httpMethod_GET
           postParameterNames:nil
          postParameterValues:nil];
    
    

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
            NSLog(@"An error occured while converting JSON data to dictionary.");
            return;
        }
        [self callCalendarEvents];

    }
    else {
    // TODO the event list
    }

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
