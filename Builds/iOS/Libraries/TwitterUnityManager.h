//
//  TwitterUnityManager.h
//  Unity-iPhone
//
//  Created by Ranier Montalbo on 1/22/13.
//
//

#import <Foundation/Foundation.h>

#define UNITY_TWTRLISTENER_GAMEOBJECT_NAME          "TwitterListener"
#define UNITY_TWTRLISTENER_ONREQUEST_STARTED        "OnTwitterRequestStarted"
#define UNITY_TWTRLISTENER_ONREQUESTRESULT          "OnTwitterRequestResult"
#define UNITY_TWTRLISTENER_ONREQUESTERROR           "OnTwitterRequestError"

typedef enum {
    TweetSuccess,
    TweetCancelled,
    TweetNoAccount,
}TwitterStatus;

@interface TwitterUnityManager : NSObject

+(TwitterUnityManager*)sharedManager;

-(void) tweetComposeWithViewController:(UIViewController *) viewController text:(NSString *) text image:(UIImage *) image url:(NSURL *) url completion:(void (^)(TwitterStatus)) completion;

-(void)getRequest:(NSString*)url params:(NSDictionary*)params;

-(void)postRequest:(NSString*)url params:(NSDictionary*)params;

-(void)deleteRequest:(NSString*)url params:(NSDictionary*)params;

@end
