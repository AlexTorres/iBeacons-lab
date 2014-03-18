//
//  GLBAddEventVC.m
//  GoogleCalendarDemo
//
//  Created by John A Torres B on 17/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import "GLBAddEventVC.h"


@interface GLBAddEventVC ()

@end

@implementation GLBAddEventVC

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
    NSDate * date=[NSDate date];
    
    self.eventDatePicker.minimumDate = date;
    [self.googleOAuth setGoogleDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Actions

-(NSString *)getStringFromDate:(NSDate *)date{
    // Create a NSDateFormatter object to handle the date.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (!self.fullEventSwitch.on) {
        // If it's not a full-day event, then set the date format in a way that contains the time too.
        [formatter setDateFormat:@"EEE, MMM dd, yyyy, HH:mm"];
    }
    else{
        // Otherwise keep just the date.
        [formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    }
    
    // Return the formatted date as a string value.
    return [formatter stringFromDate:date];
}
- (IBAction)addEvent:(id)sender {
    // Create the URL string of API needed to quick-add the event into the Google calendar.
    // Note that we specify the id of the selected calendar.
    NSDate * selectedDate = [self.eventDatePicker date];
    NSString *apiURLString = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/calendars/%@/events/quickAdd",
                              self.selectedCalendarListItem.calendarID];
    
    // Build the event text string, composed by the event description and the date (and time) that should happen.
    // Break the selected date into its components.
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                                     fromDate:selectedDate];
    NSString * stringEventPost;
    if (self.fullEventSwitch.on) {
        // If a full-day event was selected (meaning without specific time), then add at the end of the string just the date.
        stringEventPost = [NSString stringWithFormat:@"%@ %d/%d/%d", self.descriptionTextView.text, [dateComponents month], [dateComponents day], [dateComponents year]];
    }
    else{
        // Otherwise, append both the date and the time that the event should happen.
        stringEventPost = [NSString stringWithFormat:@"%@ %d/%d/%d at %d.%d", self.descriptionTextView.text, [dateComponents month], [dateComponents day], [dateComponents year], [dateComponents hour], [dateComponents minute]];
    }
    
    // Show the activity indicator view.

    
    // Call the API and post the event on the selected Google calendar.
    // Visit https://developers.google.com/google-apps/calendar/v3/reference/events/quickAdd for more information about the quick-add event API call.
    [_googleOAuth callAPI:apiURLString
           withHttpMethod:httpMethod_POST
       postParameterNames:[NSArray arrayWithObjects:@"calendarId", @"text", nil]
      postParameterValues:[NSArray arrayWithObjects:self.selectedCalendarListItem.calendarID, stringEventPost, nil]];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
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

        //self.calendarList = [[GLBCalendarList alloc] initWithString:responseJSONAsString error:&error];
        if (error) {
            NSLog(@"An error occured while converting JSON data to dictionary. %@",[error localizedDescription]);
            return;
        }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New event"
                                                    message:@"New event added"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Great", nil];
    [alert show];
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
