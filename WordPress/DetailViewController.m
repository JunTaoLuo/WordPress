//
//  DetailViewController.m
//  WordPress
//
//  Created by Jun Tao Luo on 2012-08-20.
//  Copyright (c) 2012 Jun Tao Luo. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize usersBlogs;
@synthesize usersPosts;
@synthesize blogXMLRPC;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    [self configureView];

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void) loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    blogUsername = username;
    blogPassword = password;
    
    [self configureView];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    //NSURL * xmlrpc = [NSURL URLWithString:@"http://workplaceone.ca/forum/xmlrpc.php"];
    NSURL * xmlrpc = [NSURL URLWithString:@"https://wordpress.com/xmlrpc.php"];
    
    AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:xmlrpc];
    [api callMethod:@"wp.getUsersBlogs"
         parameters:[NSArray arrayWithObjects:blogUsername, blogPassword, nil]
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                usersBlogs = responseObject;
                //hasCompletedGetUsersBlogs = YES;
                
                NSString * textToDisplay = @"Login succeeded";
                
                if(usersBlogs.count > 0) {
//                    // TODO: Store blog list in Core Data
//                    [[NSUserDefaults standardUserDefaults] setObject:usersBlogs forKey:@"WPcomUsersBlogs"];
                    [usersBlogs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSString *title = [obj valueForKey:@"blogName"];
                        title = [title stringByDecodingXMLCharacters];
                        [obj setValue:title forKey:@"blogName"];
                    }];
                    textToDisplay = [textToDisplay stringByAppendingString:@". Blog name: "];
                    textToDisplay = [textToDisplay stringByAppendingString:[[usersBlogs objectAtIndex:0] valueForKey:@"blogName"]];
                }
                //[self.tableView reloadData];
                self.blogLabel.text = textToDisplay;
                blogNum = [[[usersBlogs objectAtIndex:0] valueForKey:@"blogid"] intValue];
                self.blogXMLRPC = (NSString*)[[usersBlogs objectAtIndex:0] valueForKey:@"xmlrpc"];
                [newPost setEnabled:YES];
                [newPost setAlpha:1.0];
                [self onSuccessfulLogin];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                WPFLog(@"Failed getting user blogs: %@", [error localizedDescription]);
                //hasCompletedGetUsersBlogs = YES;
                //[self.tableView reloadData];
                self.blogLabel.text = @"Login failed";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry, can't log in", @"")
                                                                    message:[error localizedDescription]
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                [alertView show];
            }];
}

-(void) onSuccessfulLogin
{
    NSURL * xmlrpc = [NSURL URLWithString:[[usersBlogs objectAtIndex:0] valueForKey:@"xmlrpc"]];
    AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:xmlrpc];
    NSArray *parameters = [NSArray arrayWithObjects: [NSNumber numberWithInt:blogNum], blogUsername, blogPassword, [NSNumber numberWithInt:40], nil];
    AFXMLRPCRequest *request = [api XMLRPCRequestWithMethod:@"metaWeblog.getRecentPosts" parameters:parameters];
    AFXMLRPCRequestOperation *operation = [api XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

        usersPosts = (NSArray *)responseObject;
        [viewPosts setEnabled:YES];
        [viewPosts setAlpha:1.0];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WPFLog(@"Failed getting user posts: %@", [error localizedDescription]);
        //hasCompletedGetUsersBlogs = YES;
        //[self.tableView reloadData];
        self.blogLabel.text = @"Login failed";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry, can't get posts", @"")
                                                            message:[error localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                  otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [alertView show];
    }];
    [api enqueueXMLRPCRequestOperation:operation];
}

-(void) displayPosts
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPosts"]) {
        //        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setPosts:usersPosts];
        [[segue destinationViewController] refresh];
        //        NSDate *object = [_objects objectAtIndex:indexPath.row];
        //        [[segue destinationViewController] setDetailItem:object];
    }
    else if ([[segue identifier] isEqualToString:@"newPost"])
    {
        [[segue destinationViewController] setPosts:usersPosts];
        [[segue destinationViewController] setBlogNum:blogNum];
        [[segue destinationViewController] setXMLRPC:self.blogXMLRPC];
        [[segue destinationViewController] setUsername:blogUsername andPassword:blogPassword];
    }
}

@end
