//
//  PurchasingManager.m
//  Unity-iPhone
//
//  Created by Raneiro Montalbo on 3/12/13.
//
//

#import "PurchasingManager.h"

@implementation PurchasingManager

@synthesize requestHandlers;

+(PurchasingManager*)sharedInstance {
    static PurchasingManager* instance;
    if(instance == nil) {
        instance = [[PurchasingManager alloc] init];
    }
    return instance;
}

-(PurchasingManager*)init {
    if(self = [super init]) {
        requestHandlers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc {
    [requestHandlers release];
    [super dealloc];
}

-(void)purchaseItemId:(NSString *)productId withResultHandler:(PurchaseResponseBlock)handler {
    // save handler for later
    [requestHandlers setObject:handler forKey:productId];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSSet* productIdSet = [NSSet setWithObject:productId];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdSet];
    [request setDelegate:self];
    [request start];
}

#pragma mark PrivateMethods

-(void)showAlertWithMessage:(NSString*)message {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Purchase", @"PurchasingManager AlertView Title")
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:NSLocalizedString(@"OK", @"Ok Button")
                                         otherButtonTitles:nil];
    [view show];
    [view release];
}

#pragma mark SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"%s",__FUNCTION__);
    
    if (response == nil) {
        NSLog(@"Product Response is nil");
        return;
    }
    
    for (NSString *identifier in response.invalidProductIdentifiers) {
        NSString *errorMessage = [NSString stringWithFormat:@"Invalid product identifier: %@", identifier];
        NSLog(@"%@", errorMessage);
        
        // invoke callback function and send back error message
        PurchaseResponseBlock handler = [requestHandlers objectForKey:identifier];
        if(handler != nil) handler(identifier, false, errorMessage);
        [requestHandlers removeObjectForKey:identifier];
        
		[self showAlertWithMessage:NSLocalizedString(@"StoreView_AlertMessage_InvalidProductId",nil)];
    }
	
    for (SKProduct *product in response.products ) {
        NSLog(@"Valid product identifier: %@", product.productIdentifier);
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
	
}

#pragma mark SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"%s",__FUNCTION__);
    
    BOOL purchasing = YES;
    for (SKPaymentTransaction *transaction in transactions) {
        NSString* productId = transaction.payment.productIdentifier;
        switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchasing: {
				NSLog(@"Payment Transaction Purchasing");
				break;
			}
			case SKPaymentTransactionStatePurchased: {
				NSLog(@"Payment Transaction END Purchased: %@", transaction.transactionIdentifier);
				purchasing = NO;
                
                // invoke callback function and send back success message
                PurchaseResponseBlock handler = [requestHandlers objectForKey:productId];
                if(handler != nil) handler(productId, YES, nil);
                [requestHandlers removeObjectForKey:productId];
                
				[self showAlertWithMessage:NSLocalizedString(@"StoreView_AlertMessage_FinishedPurchasing",nil)];
				[queue finishTransaction:transaction];
				break;
			}
			case SKPaymentTransactionStateFailed: {
				NSLog(@"Payment Transaction END Failed: %@ %@", transaction.transactionIdentifier, transaction.error);
				purchasing = NO;
                
                // invoke callback function and send back error message
                PurchaseResponseBlock handler = [requestHandlers objectForKey:productId];
                if(handler != nil) handler(productId, NO, transaction.error.localizedDescription);
                [requestHandlers removeObjectForKey:productId];
                
				[self showAlertWithMessage:NSLocalizedString(@"StoreView_AlertMessage_FailedPurchasing",nil)];
				[queue finishTransaction:transaction];
				break;
			}
			case SKPaymentTransactionStateRestored: {
				NSLog(@"Payment Transaction END Restored: %@", transaction.transactionIdentifier);
				purchasing = NO;
                
                // invoke callback function and send back success message
                PurchaseResponseBlock handler = [requestHandlers objectForKey:productId];
                if(handler != nil) handler(productId, YES, nil);
                [requestHandlers removeObjectForKey:productId];
                
                [self showAlertWithMessage:NSLocalizedString(@"StoreView_AlertMessage_FinishedPurchasing",nil)];
				[queue finishTransaction:transaction];
				break;
			}
        }
    }
    
    if (purchasing == NO) {
        NSLog(@"Purchasing = NO");
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    }
}

@end
