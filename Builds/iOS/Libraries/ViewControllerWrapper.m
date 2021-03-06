//
//  ViewControllerWrapper.m
//  Unity-iPhone
//
//  Created by Mikhail Lomibao Basbas on 4/12/13.
//
//

#import "ViewControllerWrapper.h"

@interface ViewControllerWrapper ()

@end

@implementation ViewControllerWrapper

-(id) init {
    if(self = [super init]) {
         self.view = [[WrapperView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
}

#ifdef __IPHONE_6_0
-(BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}
-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}
#else
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#endif

@end


@implementation WrapperView
-(id) initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
    }
    return self;
}

@end