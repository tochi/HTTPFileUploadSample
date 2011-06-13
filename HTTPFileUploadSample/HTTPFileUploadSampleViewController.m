//
//  HTTPFileUploadSampleViewController.m
//  HTTPFileUploadSample
//
//  Created by tochi on 11/06/10.
//  Copyright 2011 aguuu Inc. All rights reserved.
//

#import "HTTPFileUploadSampleViewController.h"

@implementation HTTPFileUploadSampleViewController

- (void)dealloc
{
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)postButtonClicked:(id)sender
{
  // Get image data.
  UIImage *image1 = [UIImage imageNamed:@"Icon.png"];
  UIImage *image2 = [UIImage imageNamed:@"Icon.jpg"];
  
  // File upload.
  HTTPFileUpload *httpFileUpload = [[[HTTPFileUpload alloc] init] autorelease];
  httpFileUpload.delegate = self;
  [httpFileUpload setPostString:@"1234" withPostName:@"password"];
  [httpFileUpload setPostImage:image1 withPostName:@"data1" fileName:@"Icon.png"];
  [httpFileUpload setPostImage:image2 withPostName:@"data2" fileName:@"Icon.jpeg"];
  #pragma mark TODO: Change sample uri.
  [httpFileUpload postWithUri:@"http://photopost.jp/posts/create.json"];
  
}

- (void)httpFileUpload:(NSURLConnection *)connection
      didFailWithError:(NSError *)error
{
  NSLog(@"%@", error);
}

- (void)httpFileUploadDidFinishLoading:(NSURLConnection *)connection
                                result:(NSString *)result
{
  NSLog(@"%@", result);
}
@end
