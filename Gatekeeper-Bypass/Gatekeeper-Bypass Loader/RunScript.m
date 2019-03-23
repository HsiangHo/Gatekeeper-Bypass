//
//  RunScript.m
//  Random
//
//  Created by blizzard on 13-5-24.
//  Copyright (c) 2013年 blizzard. All rights reserved.
//

#import "RunScript.h"

@implementation RunScript

+ (BOOL) runProcess:(NSString*)scriptPath
      withArguments:(NSArray *)arguments
             output:(NSString **)output
   errorDescription:(NSString **)errorDescription
    asAdministrator:(BOOL)runAsAdmin {
    
    NSString * asAdmin = @"";
    NSString * allArgs = [arguments componentsJoinedByString:@" "];
    NSString * fullScript = [NSString stringWithFormat:@"%@ %@", scriptPath, allArgs];
    if(runAsAdmin)
    {
        asAdmin = @"with administrator privileges";
    }
    
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" %@", fullScript, asAdmin];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    // Check errorInfo
    if (! eventResult)
    {
        // Describe common errors
        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
        {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        
        // Set error message from provided message
        if (*errorDescription == nil)
        {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
        return NO;
    }
    else
    {
        // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        
        return YES;
    }
}
+ (OSStatus) RunTool:(NSString*) ToolPath
{
    OSStatus myStatus;
    AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
    AuthorizationRef myAuthorizationRef;
    const char* myToolPath = [ToolPath UTF8String];
    
    myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, myFlags, &myAuthorizationRef);
    if (myStatus != errAuthorizationSuccess)
        return myStatus;
    
    AuthorizationItem myItems = {kAuthorizationRightExecute, 0, NULL, 0};
    AuthorizationRights myRights = {1, &myItems};
    myFlags = kAuthorizationFlagDefaults |
    kAuthorizationFlagInteractionAllowed |
    kAuthorizationFlagPreAuthorize |
    kAuthorizationFlagExtendRights;
    
    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights, NULL, myFlags, NULL );
    if (myStatus != errAuthorizationSuccess)
        return myStatus;
    
    //FILE *myCommunicationsPipe = NULL;
    
    myFlags = kAuthorizationFlagDefaults;
    myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, myToolPath, myFlags, nil, nil);
    return  myStatus;
}

+ (void) Test
{
    NSDictionary *error = [NSDictionary new];
    NSString *script =  @"do shell script \"/usr/bin/id -un\" with administrator privileges";
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    if ([appleScript executeAndReturnError:&error]) {
        NSLog(@"success!");
    } else {
        NSLog(@"failure!");
    }
}

+ (void) Test2
{
    NSString * output = nil;
    NSString * processErrorDescription = nil;
    BOOL success = [RunScript runProcess:@"/usr/bin/id"
                           withArguments:[NSArray arrayWithObjects:@"-un", nil]
                                  output:&output
                        errorDescription:&processErrorDescription
                         asAdministrator:NO];
    
    
    if (!success) // Process failed to run
    {
        // ...look at errorDescription
        NSLog(@"failure:%@!", processErrorDescription);
    }
    else
    {
        // ...process output
        NSLog(@"success:%@!", output);
    }
    
}

+ (void) Test3
{
    NSString * output = nil;
    NSString * processErrorDescription = nil;
    BOOL success = [RunScript runProcess:@"/usr/bin/id"
                           withArguments:[NSArray arrayWithObjects:@"-un", nil]
                                  output:&output
                        errorDescription:&processErrorDescription
                         asAdministrator:YES];
    
    
    if (!success) // Process failed to run
    {
        // ...look at errorDescription
        NSLog(@"failure:%@!", processErrorDescription);
    }
    else
    {
        // ...process output
        NSLog(@"success:%@!", output);
    }
    
}
@end
