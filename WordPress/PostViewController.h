//
//  PostViewController.h
//  WordPress
//
//  Created by Jun Tao Luo on 2012-09-11.
//  Copyright (c) 2012 Jun Tao Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController
{
    IBOutlet UITextView * postContent;
    
    NSString * postText;
    NSString * postTitle;
}

-(void) setText:(NSString*)text andTitle:(NSString*)title;

@end
