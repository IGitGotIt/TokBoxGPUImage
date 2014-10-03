//
//  ViewController.m
//  TokBoxGPUImage
//
//  Created by Jaideep Shah on 9/4/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import  <OpenTok/OpenTok.h>
#import "TokBoxGPUImagePublisher.h"
#import "ColorRenderer.h"


static NSString* const kApiKey = @"100";
// Replace with your generated session ID
static NSString* const kSessionId = @"2_MX4xMDB-MTI3LjAuMC4xfjE0MTIzNzEwOTc0ODV-bXZYM0YwSUUwOTRHWjV2T2pjRGdINnJUfn4";
// Replace with your generated token
static NSString* const kToken = @"T1==cGFydG5lcl9pZD0xMDAmc2RrX3ZlcnNpb249dGJwaHAtdjAuOTEuMjAxMS0wNy0wNSZzaWc9ZWJjZGQ5ZGJkM2VjM2RhY2Q2NDdkMWNiNzVhZWUwNzdiNWU2ZWE1MTpzZXNzaW9uX2lkPTJfTVg0eE1EQi1NVEkzTGpBdU1DNHhmakUwTVRJek56RXdPVGMwT0RWLWJYWllNMFl3U1VVd09UUkhXalYyVDJwalJHZElObkpVZm40JmNyZWF0ZV90aW1lPTE0MTIzNzExODYmcm9sZT1tb2RlcmF0b3Imbm9uY2U9MTQxMjM3MTE4Ni4yMTM3MjExNDk4OTYxOCZleHBpcmVfdGltZT0xNDE0OTYzMTg2";

static double widgetHeight = 240;
static double widgetWidth = 320;
static double widgetGLViewHeight = 50;

@interface ViewController () <OTSessionDelegate, OTPublisherKitDelegate, OTSubscriberKitDelegate> {

    OTSession* _session;
    TokBoxGPUImagePublisher * _publisher;
    OTSubscriber* _subscriber;
    ColorRenderer * _colorRenderer;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpColorRenderer];
    
    _session = [[OTSession alloc] initWithApiKey:kApiKey
                                       sessionId:kSessionId
                                        delegate:self];
    OTError *error;
    [_session connectWithToken:kToken error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString *)string
{
    // show alertview on main UI
	dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
                                                        message:string
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show];
    });
}
# pragma mark - OTSession delegate callbacks

- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    _publisher = [[TokBoxGPUImagePublisher alloc] initWithDelegate:self name:[[UIDevice currentDevice] name]];
    
    OTError *error;
    [_session publish:_publisher error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    
    [_publisher.view setFrame:CGRectMake(0, 0, widgetWidth, widgetHeight)];
    [self.view addSubview:_publisher.view];
}

-(void) session:(OTSession *)session didFailWithError:(OTError *)error
{
    [self showAlert:error.description];
}
- (void)publisher:(OTPublisherKit *)publisher streamCreated:(OTStream *)stream
{
    //_subscriber = [[TokBoxGPUImageSubscriber alloc] initWithStream:stream delegate:self];
    _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];

    OTError *error;
    [_session subscribe:_subscriber error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }

}

-(void) setUpColorRenderer
{
    _colorRenderer = [[ColorRenderer alloc] initWithFrame:CGRectMake(0, widgetHeight, widgetWidth, widgetGLViewHeight)];
    [self.view addSubview:_colorRenderer];
}



//- (void)session:(OTSession*)mySession streamCreated:(OTStream *)stream
//{
//    NSLog(@"session streamCreated (%@)", stream.streamId);
//    _subscriber = [[TokBoxGPUImageSubscriber alloc] initWithStream:stream delegate:self];
//    OTError *error;
//    [_session subscribe:_subscriber error:&error];
//    if (error)
//    {
//        [self showAlert:[error localizedDescription]];
//    }
//}

# pragma mark - OTSubscriber delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*) subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)", subscriber.stream.connection.connectionId);
    [_subscriber.view setFrame:CGRectMake(0, widgetHeight+widgetGLViewHeight, widgetWidth,
                                          widgetHeight)];
    [self.view addSubview:_subscriber.view];
}


@end
