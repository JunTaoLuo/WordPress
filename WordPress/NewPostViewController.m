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

- (void) post:(id)sender
{
//    NSURL * xmlrpc = [NSURL URLWithString:[[posts objectAtIndex:0] valueForKey:@"xmlrpc"]];
    
    NSURL * xmlrpc = [NSURL URLWithString: @"https://wordpress.com/xmlrpc.php"];
    
    AFXMLRPCClient *api = [AFXMLRPCClient clientWithXMLRPCEndpoint:xmlrpc];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    [postParams setValue:postText.text forKey:@"description"];
    [postParams setValue:postTitle.text forKey:@"title"];
    NSArray *parameters = [NSArray arrayWithObjects: [NSNumber numberWithInt:blogNum], @"whitehawkworks", @"5percent", postParams, nil];
    
    //NSArray *parameters = [self.blog getXMLRPCArgsWithExtra:[self XMLRPCDictionary]];
    
    NSMutableURLRequest *request = [api requestWithMethod:@"metaWeblog.newPost"
                                                         parameters:parameters];

    AFHTTPRequestOperation *operation = [api HTTPRequestOperationWithRequest:request
                                                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                   NSLog(@"upload success");
                                                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUploadFailed" object:self];
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

@end
