// Fig. 14.17: Visualizer.m
// VoiceRecorder
#import "Visualizer.h"

@implementation Visualizer

// initialize the Visualizer
- (id)initWithCoder:(NSCoder *)aDecoder
{
   // if the superclass initializes properly
   if (self = [super initWithCoder:aDecoder])
   {
      // initialize powers with an entry for every other pixel of width
      powers = [[NSMutableArray alloc] initWithCapacity:self.frame.size.width / 2];
       NSLog(@"powers.count:%d",powers.count);
   } // end if
   
   return self; // return this BarVisualizer
} // end method initWithCoder:

// sets the current power in the recording
- (void)setPower:(float)p
{
   [powers addObject:[NSNumber numberWithFloat:p]]; // add value to powers
   
   // while there are enough entries to fill the entire screen
   while (powers.count * 2 > self.frame.size.width)
      [powers removeObjectAtIndex:0]; // remove the oldest entry
   
   // if the new power is less than the smallest power recorded
   if (p < minPower)
      minPower = p; // update minPower with the new power
} // end method setPower:

// clears all the points from the visualizer
- (void)clear
{
   [powers removeAllObjects]; // remove all objects from powers
} // end method clear

// draws the visualizer
- (void)drawRect:(CGRect)rect
{
   // get the current graphics context
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGSize size = self.frame.size;
   
   // draw a line for each point in powers
   for (int i = 0; i < powers.count; i++)
   {
      // get next power level
      float newPower = [[powers objectAtIndex:i] floatValue];
      
      // calculate the height for this power level
      float height = (1 - newPower / minPower) * (size.height / 2);
      
      // move to a point above the middle of the screen
      CGContextMoveToPoint(context, i * 2, size.height / 2 - height);
      
      // add a line to a point below the middle of the screen
      CGContextAddLineToPoint(context, i * 2, size.height / 2 + height);
      
      // set the color for this line segment based on f
      CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
      CGContextStrokePath(context); // draw the line
   } // end for
} // end method drawRect:

// free Visualizer's memory
- (void)dealloc
{
   [powers release]; // release the powers NSMutableArray
   [super dealloc]; // call the superclass's dealloc method
} // end method dealloc
@end // end visualizer implementation