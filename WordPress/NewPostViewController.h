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
}

@property (nonatomic, retain) NSArray *posts;

-(void) setPosts: (NSArray *) userPosts;
-(void) setBlogNum: (int) blogNumber;
-(IBAction)post:(id)sender;

@end
