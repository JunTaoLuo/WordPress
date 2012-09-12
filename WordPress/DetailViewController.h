//
//  DetailViewController.h
//  WordPress
//
//  Created by Jun Tao Luo on 2012-08-20.
//  Copyright (c) 2012 Jun Tao Luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AFXMLRPCClient.h"
#import "NSString+XMLExtensions.h"
#import "PostTableView.h"
#import "NewPostViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    NSString * blogUsername;
    NSString * blogPassword;
    
    NSArray *usersBlogs;
    NSArray *userPosts;
    
    int blogNum;
    NSNumber * blogID;
    bool loginSuccessful;
    
    // bad naming, this is actually a controller
    PostTableView * postTableViewController;
    
    IBOutlet UIView * postTableView;
    IBOutlet UIButton * viewPosts;
    IBOutlet UIButton * newPost;
}

-(void) loginWithUsername: (NSString *) username andPassword: (NSString *) password;
-(void) onSuccessfulLogin;
-(void) displayPosts;

//@property (strong, nonatomic) id detailItem;
@property (nonatomic, retain) NSArray *usersBlogs;
@property (nonatomic, retain) NSArray *usersPosts;

@property (weak, nonatomic) IBOutlet UILabel *blogLabel;
@end
