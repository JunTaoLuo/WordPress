//
//  NewPostViewController.h
//  WordPress
//
//  Created by Jun Tao Luo on 2012-09-11.
//  Copyright (c) 2012 Jun Tao Luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFXMLRPCClient.h"

@interface NewPostViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UITextField * postTitle;
    IBOutlet UITextView * postText;
    NSArray * posts;
    int blogNum;
    NSString * xmlrpc;
    NSString * username;
    NSString * password;
}

@property (nonatomic, retain) NSArray *posts;

-(void) setPosts: (NSArray *) userPosts;
-(void) setBlogNum: (int) blogNumber;
-(void) setXMLRPC: (NSString *) xmlrpcTarget;
-(void) setUsername: (NSString *) blogUsername andPassword: (NSString *) blogPassword;
-(IBAction)post:(id)sender;

@end
