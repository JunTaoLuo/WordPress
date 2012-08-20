//
//  AppDelegate.m
//  WordPress
//
//  Created by Jun Tao Luo on 2012-08-20.
//  Copyright (c) 2012 Jun Tao Luo. All rights reserved.
//

#import "AppDelegate.h"
#import "AFXMLRPCClient.h"
#import "SFHFKeychainUtils.h"

@implementation AppDelegate

static AppDelegate *wordPressApp = NULL;

@synthesize isWPcomAuthenticated;

+ (AppDelegate *)sharedWordPressApp {
    if (!wordPressApp) {
        wordPressApp = [[AppDelegate alloc] init];
    }
    
    return wordPressApp;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Public Methods

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
	WPLog(@"Showing alert with title: %@", message);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Need Help?", @"'Need help?' button label, links off to the WP for iOS FAQ.")
                                          otherButtonTitles:NSLocalizedString(@"OK", @"OK button label."), nil];
    [alert show];
    [alert release];
}

- (void)registerForPushNotifications {
    if (isWPcomAuthenticated) {
        [[UIApplication sharedApplication]
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)];
    }
}

- (void)unregisterApnsToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"apnsDeviceToken"];
    if( nil == token ) return; //no apns token available
    
    NSString *authURL = kNotificationAuthURL;
    NSError *error = nil;
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"wpcom_username_preference"] != nil) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"wpcom_username_preference"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"wpcom_password_preference"] != nil) {
            // Migrate password to keychain
            [SFHFKeychainUtils storeUsername:username
                                 andPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"wpcom_password_preference"]
                              forServiceName:@"WordPress.com"
                              updateExisting:YES error:&error];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"wpcom_password_preference"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        NSString *password = [SFHFKeychainUtils getPasswordForUsername:username
                                                        andServiceName:@"WordPress.com"
                                                                 error:&error];
        if (password != nil) {
#ifdef DEBUG
            NSNumber *sandbox = [NSNumber numberWithBool:YES];
#else
            NSNumber *sandbox = [NSNumber numberWithBool:NO];
#endif
            AFXMLRPCClient *api = [[AFXMLRPCClient alloc] initWithXMLRPCEndpoint:[NSURL URLWithString:authURL]];
            [api callMethod:@"wpcom.mobile_push_unregister_token"
                 parameters:[NSArray arrayWithObjects:username, password, token, [[UIDevice currentDevice] uniqueIdentifier], @"apple", sandbox, nil]
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        WPFLog(@"Unregistered token %@", token);
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        WPFLog(@"Couldn't unregister token: %@", [error localizedDescription]);
                    }];
            [api release];
        }
	}
}


@end
