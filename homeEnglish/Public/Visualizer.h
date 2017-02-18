// Fig. 14.16: Visualizer.h
// View that displays a visualization of a recording in progress.
#import <UIKit/UIKit.h>

// begin Visualizer interface definition
@interface Visualizer : UIView
{
   NSMutableArray *powers; // past power levels in the recording
   float minPower; // the lowest recorded power level
} // end instance variable declaration

- (void)setPower:(float)p; // set the powerLevel
- (void)clear; // clear all the past power levels
@end // end interface Visualizer