//
//  NewPostViewController.m
//  WordPress
//
//  Created by Jun Tao Luo on 2012-09-11.
//  Copyright (c) 2012 Jun Tao Luo. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController ()

@end

@implementation NewPostViewController

@synthesize posts;

-(void) setPosts:(NSArray *)userPosts
{
    posts = userPosts;
}

-(void) setBlogNum:(int)blogNumber
{
    blogNum = blogNumber;
}

-(void) setXMLRPC:(NSString *)xmlrpcTarget
{
    xmlrpc = xmlrpcTarget;
}

-(void) setUsername:(NSString *)blogUsername andPassword:(NSString *)blogPassword
{
    username = blogUsername;
    password = blogPassword;
}

- (void) post:(id)sender
{
//    NSURL * xmlrpc = [NSURL URLWithString:[[posts objectAtIndex:0] valueForKey:@"xmlrpc"]];
    AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:[NSURL URLWithString:xmlrpc]];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    
    [postParams setValue:postTitle.text forKey:@"title"];
    [postParams setValue:postText.text forKey:@"description"];
//    [postParams setValueIfNotNil:self.date_created_gmt forKey:@"date_created_gmt"];
//    [postParams setValueIfNotNil:self.password forKey:@"wp_password"];
//    [postParams setValueIfNotNil:self.permaLink forKey:@"permalink"];
//    [postParams setValueIfNotNil:self.mt_excerpt forKey:@"mt_excerpt"];
//    [postParams setValueIfNotNil:self.wp_slug forKey:@"wp_slug"];
//    [postParams setValueIfNotNil:self.post_thumbnail forKey:@"wp_featured_image"];
//    [postParams setObject:self.mt_text_more forKey:@"mt_text_more"];
//    [postParams setValueIfNotNil:self.postFormat forKey:@"wp_post_format"];
//    [postParams setValueIfNotNil:self.tags forKey:@"mt_keywords"];
    [postParams setObject:@"publish" forKey:@"post_status"];
    
    NSArray *parameters = [NSArray arrayWithObjects: [NSNumber numberWithInt:blogNum], username, password, postParams, nil];
    
    //NSArray *parameters = [self.blog getXMLRPCArgsWithExtra:[self XMLRPCDictionary]];
    
    NSMutableURLRequest *request = [api requestWithMethod:@"metaWeblog.newPost"
                                                         parameters:parameters];

    AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:request
                                                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                   NSLog(@"upload success");
                                                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry, new post failed", @"")
                                                                                                                                       message:[error localizedDescription]
                                                                                                                                      delegate:self
                                                                                                                             cancelButtonTitle:NSLocalizedString(@"Need Help?", @"")
                                                                                                                             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                                                                                   [alertView show];

                                                                               }];
    [api enqueueHTTPRequestOperation:operation];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    postTitle.delegate = self;
    postText.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    barButtonItem.title = NSLocalizedString(@"New Post", @"New Post");
}


@end
