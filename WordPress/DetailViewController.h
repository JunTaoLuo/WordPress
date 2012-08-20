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

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    NSArray *usersBlogs;
}

@property (strong, nonatomic) id detailItem;
@property (nonatomic, retain) NSArray *usersBlogs;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogLabel;
@end
