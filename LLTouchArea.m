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
    _pinchBlock = nil;
    _rotationBlock = nil;
    _panBlock = nil;
    
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

- (LLTouchAreaGesture)areaGestureFromGestureRecognizer:(id)gestureRecognizer
{
    LLTouchAreaGesture areaGesture = 0;
    
    Class gestureClass = [gestureRecognizer class];
    
    if (gestureClass == [UITapGestureRecognizer class])
    {
        areaGesture = LLTouchAreaGestureTap;
    }
    else if (gestureClass == [UILongPressGestureRecognizer class])
    {
        areaGesture = LLTouchAreaGestureLongTap;
    }
    else if (gestureClass == [UISwipeGestureRecognizer class])
    {
        switch ([gestureRecognizer direction])
        {
            case UISwipeGestureRecognizerDirectionLeft:
                areaGesture = LLTouchAreaGestureSwipeLeft;
                break;
                
            case UISwipeGestureRecognizerDirectionRight:
                areaGesture = LLTouchAreaGestureSwipeRight;
                break;
                
            case UISwipeGestureRecognizerDirectionUp:
                areaGesture = LLTouchAreaGestureSwipeUp;
                break;
                
            case UISwipeGestureRecognizerDirectionDown:
                areaGesture = LLTouchAreaGestureSwipeDown;
                break;
        }
    }
    else if (gestureClass == [UIPinchGestureRecognizer class])
    {
        areaGesture = LLTouchAreaGesturePinch;
    }
    else if (gestureClass == [UIRotationGestureRecognizer class])
    {
        areaGesture = LLTouchAreaGestureRotation;
    }
    else if (gestureClass == [UIPanGestureRecognizer class])
    {
        areaGesture = LLTouchAreaGesturePan;
    }
    
    return areaGesture;
}

- (SEL)gestureRecognizerActionSELForAreaGesture:(LLTouchAreaGesture)areaGesture
{
    SEL action = nil;
    
    switch (areaGesture)
    {
        case LLTouchAreaGestureTap:
        case LLTouchAreaGestureDoubleTap:
            action = @selector(handleTap:);
            break;
            
        case LLTouchAreaGestureLongTap:
            action = @selector(handleLongTap:);
            break;
            
        case LLTouchAreaGestureSwipeLeft:
        case LLTouchAreaGestureSwipeRight:
        case LLTouchAreaGestureSwipeUp:
        case LLTouchAreaGestureSwipeDown:
            action = @selector(handleSwipe:);
            break;
            
        case LLTouchAreaGesturePinch:
            action = @selector(handlePinch:);
            break;
            
        case LLTouchAreaGestureRotation:
            action = @selector(handleRotation:);
            break;
            
        case LLTouchAreaGesturePan:
            action = @selector(handlePan:);
            break;
    }
    
    return action;
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
            
        case LLTouchAreaGesturePinch:
            class = [UIPinchGestureRecognizer class];
            break;
            
        case LLTouchAreaGestureRotation:
            class = [UIRotationGestureRecognizer class];
            break;
            
        case LLTouchAreaGesturePan:
            class = [UIPanGestureRecognizer class];
            break;
    }
    
    return class;
}

- (void)setupGestures
{
    UITapGestureRecognizer *tapGesture = nil;
    UITapGestureRecognizer *doubleTapGesture = nil;
    UITapGestureRecognizer *tripleTapGesture = nil;
    UITapGestureRecognizer *twoFingersTapGesture = nil;
    UITapGestureRecognizer *twoFingersDoubleTapGesture = nil;
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
        [tripleTapGesture setNumberOfTapsRequired:3];
        
        [self addGestureRecognizer:tripleTapGesture];
        
        [tripleTapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureDoubleTap) == LLTouchAreaGestureDoubleTap)
    {
        doubleTapGesture = [[UITapGestureRecognizer alloc] init];
        [doubleTapGesture setNumberOfTapsRequired:2];
        
        if (tripleTapGesture != nil)
        {
            [doubleTapGesture requireGestureRecognizerToFail:tripleTapGesture];
        }
        
        [self addGestureRecognizer:doubleTapGesture];
        
        [doubleTapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureTap) == LLTouchAreaGestureTap)
    {
        tapGesture = [[UITapGestureRecognizer alloc] init];
        
        if (doubleTapGesture != nil)
        {
            [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
        }
        
        [self addGestureRecognizer:tapGesture];
        
        [tapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureTwoFingersDoubleTap) == LLTouchAreaGestureTwoFingersDoubleTap)
    {
        twoFingersDoubleTapGesture = [[UITapGestureRecognizer alloc] init];
        [twoFingersDoubleTapGesture setNumberOfTouchesRequired:2];
        [twoFingersDoubleTapGesture setNumberOfTapsRequired:2];
        
        [self addGestureRecognizer:twoFingersDoubleTapGesture];
        
        [twoFingersDoubleTapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureTwoFingersTap) == LLTouchAreaGestureTwoFingersTap)
    {
        twoFingersTapGesture = [[UITapGestureRecognizer alloc] init];
        [twoFingersTapGesture setNumberOfTouchesRequired:2];
        
        if (twoFingersDoubleTapGesture != nil)
        {
            [twoFingersTapGesture requireGestureRecognizerToFail:twoFingersDoubleTapGesture];
        }
        
        [self addGestureRecognizer:twoFingersTapGesture];
        
        [twoFingersTapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureLongTap) == LLTouchAreaGestureLongTap)
    {
        longTapGesture = [[UILongPressGestureRecognizer alloc] init];
        
        [self addGestureRecognizer:longTapGesture];
        
        [longTapGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureSwipeLeft) == LLTouchAreaGestureSwipeLeft)
    {
        leftSwipeGesture = [[UISwipeGestureRecognizer alloc] init];
        
        [leftSwipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        [self addGestureRecognizer:leftSwipeGesture];
        
        [leftSwipeGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureSwipeRight) == LLTouchAreaGestureSwipeRight)
    {
        rightSwipeGesture = [[UISwipeGestureRecognizer alloc] init];
        
        [rightSwipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [self addGestureRecognizer:rightSwipeGesture];
        
        [rightSwipeGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureSwipeUp) == LLTouchAreaGestureSwipeUp)
    {
        upSwipeGesture = [[UISwipeGestureRecognizer alloc] init];
        
        [upSwipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
        
        [self addGestureRecognizer:upSwipeGesture];
        
        [upSwipeGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureSwipeDown) == LLTouchAreaGestureSwipeDown)
    {
        downSwipeGesture = [[UISwipeGestureRecognizer alloc] init];
        
        [downSwipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
        
        [self addGestureRecognizer:downSwipeGesture];
        
        [downSwipeGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGestureRotation) == LLTouchAreaGestureRotation)
    {
        rotationGesture = [[UIRotationGestureRecognizer alloc] init];
        
        [self addGestureRecognizer:rotationGesture];
        
        [rotationGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGesturePinch) == LLTouchAreaGesturePinch)
    {
        pinchGesture = [[UIPinchGestureRecognizer alloc] init];
        
        [self addGestureRecognizer:pinchGesture];
        
        [pinchGesture release];
    }
    
    if ((_supportedGestures & LLTouchAreaGesturePan) == LLTouchAreaGesturePan)
    {
        panGesture = [[UIPinchGestureRecognizer alloc] init];
        
        [self addGestureRecognizer:panGesture];
        
        [panGesture release];
    }
}


#pragma mark - Public methods

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    [gestureRecognizer setDelegate:self];
    
    LLTouchAreaGesture areaGesture = [self areaGestureFromGestureRecognizer:gestureRecognizer];
    SEL action = [self gestureRecognizerActionSELForAreaGesture:areaGesture];
    
    [gestureRecognizer addTarget:self action:action];
    
    [_gestures addObject:gestureRecognizer];
    [super addGestureRecognizer:gestureRecognizer];
}

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
