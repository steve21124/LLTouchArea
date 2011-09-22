/*
 Copyright (c) 2011 Liberati Luca http://www.liberatiluca.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "LLTouchArea.h"


@interface LLTouchArea ()
@property (nonatomic, retain) NSMutableArray *gestures;
@property (nonatomic, copy) LLTouchAreaGestureTapHandler tapBlock;
@property (nonatomic, copy) LLTouchAreaGestureLongTapHandler longTapBlock;
@property (nonatomic, copy) LLTouchAreaGestureSwipeHandler swipeBlock;
@property (nonatomic, copy) LLTouchAreaGesturePinchHandler pinchBlock;
@property (nonatomic, copy) LLTouchAreaGestureRotationHandler rotationBlock;
@property (nonatomic, copy) LLTouchAreaGesturePanHandler panBlock;

- (void)setupGestures;
@end


@implementation LLTouchArea

// private
@synthesize gestures = _gestures;
@synthesize tapBlock = _tapBlock;
@synthesize longTapBlock = _longTapBlock;
@synthesize swipeBlock = _swipeBlock;
@synthesize pinchBlock = _pinchBlock;
@synthesize rotationBlock = _rotationBlock;
@synthesize panBlock = _panBlock;
// public
@synthesize supportedGestures = _supportedGestures;


#pragma mark - Class lifecycle

- (void)dealloc
{
    [_gestures release];
    
    _tapBlock = nil;
    _longTapBlock = nil;
    _swipeBlock = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    
    self.userInteractionEnabled = YES;
    
    _gestures = [[NSMutableArray alloc] init];
    
    [self addObserver:self forKeyPath:@"supportedGestures" options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"supportedGestures"])
    {
        [_gestures enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [self removeGestureRecognizer:obj];
        }];
        
        [_gestures removeAllObjects];
        
        [self setupGestures];
    }
}


#pragma mark - Private methods

- (void)setupGestures
{
    UITapGestureRecognizer *tapGesture = nil;
    UITapGestureRecognizer *doubleTapGesture = nil;
    UITapGestureRecognizer *tripleTapGesture = nil;
    UILongPressGestureRecognizer *longTapGesture = nil;
    UISwipeGestureRecognizer *leftSwipeGesture = nil;
    UISwipeGestureRecognizer *rightSwipeGesture = nil;
    UISwipeGestureRecognizer *upSwipeGesture = nil;
    UISwipeGestureRecognizer *downSwipeGesture = nil;
    UIPinchGestureRecognizer *pinchGesture = nil;
    UIRotationGestureRecognizer *rotationGesture = nil;
    UIPanGestureRecognizer *panGesture = nil;
    
    
    if ((_supportedGestures & LLTouchAreaGestureTripleTap) == LLTouchAreaGestureTripleTap)
    {
        tripleTapGesture = [[UITapGestureRecognizer alloc] init];
        
        [tripleTapGesture setDelegate:self];
        [tripleTapGesture setNumberOfTapsRequired:3];
        [tripleTapGesture addTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tripleTapGesture];
        [_gestures addObject:tripleTapGesture];
        [tripleTapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureDoubleTap) == LLTouchAreaGestureDoubleTap)
    {
        doubleTapGesture = [[UITapGestureRecognizer alloc] init];
        
        if (tripleTapGesture != nil)
        {
            [doubleTapGesture requireGestureRecognizerToFail:tripleTapGesture];
        }
        
        [doubleTapGesture setDelegate:self];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [doubleTapGesture addTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:doubleTapGesture];
        [_gestures addObject:doubleTapGesture];
        [doubleTapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureTap) == LLTouchAreaGestureTap)
    {
        tapGesture = [[UITapGestureRecognizer alloc] init];
        
        if (doubleTapGesture != nil)
        {
            [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
        }
        
        [tapGesture setDelegate:self];
        [tapGesture addTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
        [_gestures addObject:tapGesture];
        [tapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureLongTap) == LLTouchAreaGestureLongTap)
    {
        longTapGesture = [[UILongPressGestureRecognizer alloc] init];
        
        [longTapGesture setDelegate:self];
        [longTapGesture addTarget:self action:@selector(handleLongTap:)];
        [self addGestureRecognizer:longTapGesture];
        [_gestures addObject:longTapGesture];
        [longTapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureSwipeLeft) == LLTouchAreaGestureSwipeLeft)
    {
        leftSwipeGesture = [[UISwipeGestureRecognizer alloc] init];
        
        [leftSwipeGesture setDelegate:self];
        [leftSwipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        [leftSwipeGesture addTarget:self action:@selector(handleSwipe:)];
        [self addGestureRecognizer:leftSwipeGesture];
        [_gestures addObject:leftSwipeGesture];
        [leftSwipeGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureSwipeRight) == LLTouchAreaGestureSwipeRight)
    {
        rightSwipeGesture = [[UISwipeGestureRecognizer alloc] init];
        
        [rightSwipeGesture setDelegate:self];
        [rightSwipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        [rightSwipeGesture addTarget:self action:@selector(handleSwipe:)];
        [self addGestureRecognizer:rightSwipeGesture];
        [_gestures addObject:rightSwipeGesture];
        [rightSwipeGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureSwipeUp) == LLTouchAreaGestureSwipeUp)
    {
        upSwipeGesture = [[UISwipeGestureRecognizer alloc] init];
        
        [upSwipeGesture setDelegate:self];
        [upSwipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
        [upSwipeGesture addTarget:self action:@selector(handleSwipe:)];
        [self addGestureRecognizer:upSwipeGesture];
        [_gestures addObject:upSwipeGesture];
        [upSwipeGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureSwipeDown) == LLTouchAreaGestureSwipeDown)
    {
        downSwipeGesture = [[UISwipeGestureRecognizer alloc] init];
        
        [downSwipeGesture setDelegate:self];
        [downSwipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
        [downSwipeGesture addTarget:self action:@selector(handleSwipe:)];
        [self addGestureRecognizer:downSwipeGesture];
        [_gestures addObject:downSwipeGesture];
        [downSwipeGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureRotation) == LLTouchAreaGestureRotation)
    {
        rotationGesture = [[UIRotationGestureRecognizer alloc] init];
        
        [rotationGesture setDelegate:self];
        [rotationGesture addTarget:self action:@selector(handleRotation:)];
        [self addGestureRecognizer:rotationGesture];
        [_gestures addObject:rotationGesture];
        [rotationGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGesturePinch) == LLTouchAreaGesturePinch)
    {
        pinchGesture = [[UIPinchGestureRecognizer alloc] init];
        
        [pinchGesture setDelegate:self];
        [pinchGesture addTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinchGesture];
        [_gestures addObject:pinchGesture];
        [pinchGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGesturePan) == LLTouchAreaGesturePan)
    {
        panGesture = [[UIPinchGestureRecognizer alloc] init];
        
        [panGesture setDelegate:self];
        [panGesture addTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
        [_gestures addObject:panGesture];
        [panGesture release];
    }
}

- (Class)gestureRecognizerClassForAreaGesture:(LLTouchAreaGesture)areaGesture
{
    Class class = nil;
    
    switch (areaGesture)
    {
        case LLTouchAreaGestureTap:
        case LLTouchAreaGestureDoubleTap:
            class = [UITapGestureRecognizer class];
            break;
        
        case LLTouchAreaGestureLongTap:
            class = [UILongPressGestureRecognizer class];
            break;
            
        case LLTouchAreaGestureSwipeLeft:
        case LLTouchAreaGestureSwipeRight:
        case LLTouchAreaGestureSwipeUp:
        case LLTouchAreaGestureSwipeDown:
            class = [UISwipeGestureRecognizer class];
            break;
    }
    
    return class;
}


#pragma mark - Public methods

- (NSArray *)gesturesForTouchAreaGesture:(LLTouchAreaGesture)areaGesture
{
    NSMutableArray *gestures = [NSMutableArray array];
    Class gestureClass = [self gestureRecognizerClassForAreaGesture:areaGesture];
    
    [self.gestures enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isMemberOfClass:gestureClass])
        {
            [gestures addObject:obj];
        }
    }];
    
    return gestures;
}

- (void)setTapHandler:(LLTouchAreaGestureTapHandler)tap
{
    self.tapBlock = tap;
}

- (void)setLongTapHandler:(LLTouchAreaGestureLongTapHandler)longTap
{
    self.longTapBlock = longTap;
}

- (void)setSwipeHandler:(LLTouchAreaGestureSwipeHandler)swipe
{
    self.swipeBlock = swipe;
}

- (void)setPinchHandler:(LLTouchAreaGesturePinchHandler)pinch
{
    self.pinchBlock = pinch;
}

- (void)setRotationHandler:(LLTouchAreaGestureRotationHandler)rotation
{
    self.rotationBlock = rotation;
}

- (void)setPanHandler:(LLTouchAreaGesturePanHandler)pan
{
    self.panBlock = pan;
}


#pragma mark - Touch Handling

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    Class gestureClass = [gestureRecognizer class];
    Class otherGestureClass = [otherGestureRecognizer class];
    
    if (gestureClass != [UITapGestureRecognizer class] &&
        gestureClass != [UILongPressGestureRecognizer class] &&
        otherGestureClass != [UITapGestureRecognizer class] &&
        otherGestureRecognizer != [UILongPressGestureRecognizer class])
    {
        return YES;
    }
    
    return NO;
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    if (self.tapBlock)
    {
        self.tapBlock(tapGesture);
    }
}

- (void)handleLongTap:(UILongPressGestureRecognizer *)longTapGesture
{
    if (self.longTapBlock)
    {
        self.longTapBlock(longTapGesture);
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
    if (self.swipeBlock)
    {
        self.swipeBlock(swipeGesture);
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture
{
    if (self.pinchBlock)
    {
        self.pinchBlock(pinchGesture);
    }
}

- (void)handleRotation:(UIRotationGestureRecognizer *)rotationGesture
{
    if (self.rotationBlock)
    {
        self.rotationBlock(rotationGesture);
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture
{
    if (self.panBlock)
    {
        self.panBlock(panGesture);
    }
}

@end
