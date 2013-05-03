//
//  InAppPurchaseUnityBridge.m
//  Unity-iPhone
//
//  Created by Raneiro Montalbo on 3/12/13.
//
//

#import "PurchasingManager.h"


const char* kUnityPurchasingListener = "InAppPurchaseListener";
const char* kUnityPurchasingCallbackMethod = "OnInAppPurchaseResponse";

void _purchaseProductWithId() {
    NSString *itemId = [[NSUserDefaults standardUserDefaults] stringForKey:@"ios_product_id"];
    [[PurchasingManager sharedInstance] purchaseItemId:itemId withResultHandler:^(NSString* productId, BOOL result, NSString* errorMessage) {
        NSString *response = [NSString stringWithFormat:@"%@|%d|%@", productId, [[NSNumber numberWithBool:result] integerValue], errorMessage];
        const char * responseC = [response UTF8String];
        UnitySendMessage(kUnityPurchasingListener, kUnityPurchasingCallbackMethod, responseC);
    }];
}
