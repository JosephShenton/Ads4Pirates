/*

	This is a tweak designed to inject an ad into the SpringBoard.
	The purpose of this is for developers to still earn money off
	people who have pirated copies of their application.

	Created by: Joseph Shenton - JJS Digital Pty Ltd

	Copyright 30/04/2020

*/

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/* Display ad once variable */

static dispatch_once_t onceToken = 0;

/* Try again vaiables */

static int maxTries = 5; // maximum number of times to try loading the ad
static int tries = 0; // counts up to max tries for each retry of loading the ad
static BOOL loaded = false; // changes to try if the ad has been loaded
static BOOL tryAgain = false; // changes to true if it needs to try loading the ad again

/* Google Admob Setup variables */

static GADInterstitial *googleInterestial; // Interestial Ad Style

static NSString *GoogleAppID = @"ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"; // Admob App ID
static NSString *GoogleInterestialID = @"ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"; // Admob Ad Interestial ID

// Check if the add is ready to be displayed.
void checkIfReady() {

	// Select current view controller to display ad. 
	/*
		This part may not work, I am writing this code without testing it as I cannot currently jailbreak my iPhone
		due to me not having my port adapter.
	*/
    UIViewController * controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    
	// If the ad has not been loaded, try again.
    if (!loaded) {
        if (googleInterestial.isReady) {
            NSLog(@"Found Ad");
			// Ad was found so we will display the ad
            [googleInterestial presentFromRootViewController:controller];
            loaded = true;
			tryAgain = false;
        } else {
            NSLog(@"Trying again");
			// Ad was not found so we will set the try again variable
            tryAgain = true;
            tries = tries + 1;
        }
        
        if (tryAgain && tries < maxTries) {
			// Wait 3 seconds and try again
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                checkIfReady();
            });
        } else {
            
        }
    }
}

%hook SpringBoard


// Attempt to display ad after respring
-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    
	/* Initialise Google Admob */

    [%c(GADMobileAds) configureWithApplicationID:GoogleAppID];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_once (&onceToken, ^{
            googleInterestial = [[%c(GADInterstitial) alloc] initWithAdUnitID:GoogleInterestialID];
            GADRequest *request = [%c(GADRequest) request];
            request.testDevices = @[ @"7f6ff7a2ae59c108c476cbb050ef9a58" ];
            [googleInterestial loadRequest:request];
        });
    });
    
	// Select current view controller to display ad. 
	/*
		This part may not work, I am writing this code without testing it as I cannot currently jailbreak my iPhone
		due to me not having my port adapter.
	*/
    UIViewController * controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
	
    if (!loaded) {
        if (googleInterestial.isReady) {
            NSLog(@"Found Ad");
            [googleInterestial presentFromRootViewController:controller];
            loaded = true;
			tryAgain = false;
        } else {
            NSLog(@"Ad wasn't ready");
            checkIfReady();
        }
    }
}

%end