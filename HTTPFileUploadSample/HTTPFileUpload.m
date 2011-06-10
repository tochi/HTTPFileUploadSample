//
//  HTTPFileUpload.m
//  HTTPFileUploadSample
//
//  Created by tochi on 11/06/10.
//  Copyright 2011 aguuu,Inc. All rights reserved.
//

#import "HTTPFileUpload.h"

#define KEY_POST_NAME            @"postName"
#define KEY_POST_STRING          @"postString"
#define KEY_POST_IMAGE           @"postImage"
#define KEY_POST_IMAGE_FILE_NAME @"postImageFileName"

#define BOUNDARY                 @"----iOSAppsFormBoundaryByHTTPFileUpload"


@implementation HTTPFileUpload

- (id)init {
  self = [super init];
  if (self) {
    postStrings = [[NSMutableArray alloc] initWithCapacity:0];
    postImages = [[NSMutableArray alloc] initWithCapacity:0];
  }
  return self;
}

- (void)dealloc
{
  [postStrings release], postStrings = nil;
  [postImages release], postImages = nil;
  
  [super dealloc];
}

- (void)setPostString:(NSString *)stringValue
         withPostName:(NSString *)postName
{
  NSDictionary *stringDictionary;
  stringDictionary = [NSDictionary dictionaryWithObjectsAndKeys:stringValue, KEY_POST_STRING,
                                                                postName, KEY_POST_NAME, nil];
  [postStrings addObject:stringDictionary];
}

- (void)setPostImage:(UIImage *)image
        withPostName:(NSString *)postName
            fileName:(NSString *)fileName
{
  NSDictionary *imageDictionary;
  imageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:image, KEY_POST_IMAGE,
                                                               postName, KEY_POST_NAME,
                                                               fileName, KEY_POST_IMAGE_FILE_NAME, nil];
  [postImages addObject:imageDictionary];
}

- (NSString *)postWithUri:(NSString *)uri
{
	NSMutableData *postData = [[[NSMutableData alloc] init] autorelease];
  
  // Create string data.
  for (NSDictionary *stringDictionary in postStrings) {
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",
                                                     [stringDictionary objectForKey:KEY_POST_NAME]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"%@\r\n",
                                                     [stringDictionary objectForKey:KEY_POST_STRING]] dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  // Create image data.
  NSRegularExpression *regExp;
  NSTextCheckingResult *match;
  NSError *error = nil;
  regExp = [NSRegularExpression regularExpressionWithPattern:@"(jpg|jpeg)$"
                                                     options:NSRegularExpressionCaseInsensitive
                                                       error:&error];
  NSData *imageData;
  NSString *contentType;
  for (NSDictionary *imageDictionary in postImages) {
    match = [regExp firstMatchInString:[imageDictionary objectForKey:KEY_POST_IMAGE_FILE_NAME]
                               options:0
                                 range:NSMakeRange(0, [[imageDictionary objectForKey:KEY_POST_IMAGE_FILE_NAME] length])];
    if (match != nil) {
      imageData = UIImageJPEGRepresentation([imageDictionary objectForKey:KEY_POST_IMAGE], 1.0f);
      contentType = @"image/jpeg";
    } else {
      imageData = UIImagePNGRepresentation([imageDictionary objectForKey:KEY_POST_IMAGE]);
      contentType = @"image/png";
    }
    
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                                                     [imageDictionary objectForKey:KEY_POST_NAME],
                                                     [imageDictionary objectForKey:KEY_POST_IMAGE_FILE_NAME]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n", contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:imageData];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];

  // Post data.
  NSMutableURLRequest *request;
  request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:uri] 
                                          cachePolicy:NSURLRequestReloadIgnoringCacheData
                                      timeoutInterval:30] autorelease];
	[request setHTTPMethod:@"POST"];
	[request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY] forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];

	NSURLResponse *response;
  error = nil;
	NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  NSString *result = [[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding] autorelease];
  
  return result;
}
@end
