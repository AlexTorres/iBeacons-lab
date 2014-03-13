//
//  GoogleOAuthDelegate.h
//  GoogleCalendarDemo
//
//  Created by Camila Gaitan Mosquera on 12/03/14.
//  Copyright (c) 2014 Camila Gaitan Mosquera. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoogleOAuthDelegate <NSObject>

//Successful authorization, meaning after having obtained a valid access token
-(void)authorizationWasSuccessful;

//The user revokes all the granted permissions
-(void)accessTokenWasRevoked;


//Response to an API call is received
-(void)responseFromServiceWasReceived:(NSString *)responseJSONAsString andResponseJSONAsData:(NSData *)responseJSONAsData;

//General errors occurs
-(void)errorOccuredWithShortDescription:(NSString *)errorShortDescription andErrorDetails:(NSString *)errorDetails;

//Rrror in the HTTP response
-(void)errorInResponseWithBody:(NSString *)errorMessage;

@end
