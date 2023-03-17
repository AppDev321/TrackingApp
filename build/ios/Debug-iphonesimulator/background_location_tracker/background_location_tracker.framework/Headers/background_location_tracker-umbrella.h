#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BackgroundLocationTrackerPlugin.h"

FOUNDATION_EXPORT double background_location_trackerVersionNumber;
FOUNDATION_EXPORT const unsigned char background_location_trackerVersionString[];

