//
//  main.m
//  Gatekeeper-Bypass Loader
//
//  Created by Jovi on 3/23/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RunScript.h"

int main(int argc, const char * argv[]) {
    NSString *appPath = [[[NSBundle mainBundle] bundlePath]stringByAppendingString:@"/Contents/MacOS/Gatekeeper-Bypass.app/Contents/MacOS/Gatekeeper-Bypass"];
    [RunScript RunTool:appPath];
    return 0;
}
