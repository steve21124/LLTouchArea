/*
 Copyright (c) 2011 Liberati Luca http://www.liberatiluca.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

typedef void(^LLTouchAreaGestureTapHandler)(UITapGestureRecognizer *tapGesture);
typedef void(^LLTouchAreaGestureLongTapHandler)(UILongPressGestureRecognizer *longTapGesture);
typedef void(^LLTouchAreaGestureSwipeHandler)(UISwipeGestureRecognizer *swipeGesture);
typedef void(^LLTouchAreaGesturePinchHandler)(UIPinchGestureRecognizer *pinchGesture);
typedef void(^LLTouchAreaGestureRotationHandler)(UIRotationGestureRecognizer *rotationGesture);
typedef void(^LLTouchAreaGesturePanHandler)(UIPanGestureRecognizer *panGesture);

enum
{
    LLTouchAreaGestureTap = 1 << 0,
    LLTouchAreaGestureDoubleTap = 1 << 1,
    LLTouchAreaGestureTripleTap = 1 << 2,
    LLTouchAreaGestureLongTap = 1 << 3,
    LLTouchAreaGestureSwipeLeft = 1 << 4,
    LLTouchAreaGestureSwipeRight = 1 << 5,
    LLTouchAreaGestureSwipeUp = 1 << 6,
    LLTouchAreaGestureSwipeDown = 1 << 7,
    LLTouchAreaGesturePinch = 1 << 8,
    LLTouchAreaGestureRotation = 1 << 9,
    LLTouchAreaGesturePan = 1 << 10
};
typedef NSUInteger LLTouchAreaGesture;


/** LLTouchArea is a view that saves the dev from the boring UIGestureRecognizer object creation and configuration.
 By setting the bitmask supportedGestures and the blocks to be called when a gesture is recognized, the view will auto-configure and auto-assign gestures.
 
 Example (in another view class):
 
 LLTouchArea *touchArea = [[LLTouchArea alloc] initWithFrame:self.bounds];
 [self addSubview:touchArea];
 
 touchArea.supportedGestures = LLTouchAreaGestureTap | LLTouchAreaGesturePinch;
 
 [touchArea setTapHandler:^(UITapGestureRecognizer *tapGesture) {
    NSLog(@"received tap gesture with number of taps: %i", tapGesture.numberOfTapsRequired);
 }];
 
 [touchArea setPinchHandler:^(UIPinchGestureRecognizer *pinchGesture) {
    NSLog(@"received pinch gesture");
 }];
 
 That's all!
 */
@interface LLTouchArea : UIView <UIGestureRecognizerDelegate>

/** Bitmask for supported gestures.
 When you change this property, all previous gesture recognizers will be removed.
 */
@property (nonatomic, assign) LLTouchAreaGesture supportedGestures;


/** Returns an array with UIGestureRecognizer objects for the specified LLTouchAreaGesture */
- (NSArray *)gesturesForTouchAreaGesture:(LLTouchAreaGesture)areaGesture;

/** Set a block to be called when the gesture action is fired. */
- (void)setTapHandler:(LLTouchAreaGestureTapHandler)tap;

/** Set a block to be called when the gesture action is fired. */
- (void)setLongTapHandler:(LLTouchAreaGestureLongTapHandler)longTap;

/** Set a block to be called when the gesture action is fired. */
- (void)setSwipeHandler:(LLTouchAreaGestureSwipeHandler)swipe;

/** Set a block to be called when the gesture action is fired. */
- (void)setPinchHandler:(LLTouchAreaGesturePinchHandler)pinch;

/** Set a block to be called when the gesture action is fired. */
- (void)setRotationHandler:(LLTouchAreaGestureRotationHandler)rotation;

/** Set a block to be called when the gesture action is fired. */
- (void)setPanHandler:(LLTouchAreaGesturePanHandler)pan;

@end
