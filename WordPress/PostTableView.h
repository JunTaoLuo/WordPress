//
//  PostTableView.h
//  WordPress
//
//  Created by Jun Tao Luo on 2012-09-11.
//  Copyright (c) 2012 Jun Tao Luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"

@interface PostTableView : UITableViewController
{
    NSArray * posts;
}

-(void) setPosts: (NSArray *) userPosts;
-(void) refresh;

@property (nonatomic, retain) NSArray *posts;

@end
