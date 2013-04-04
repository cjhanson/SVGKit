#import "SVGKLayer.h"

@implementation SVGKLayer
{

}

@synthesize SVGImage = _SVGImage;

//self.backgroundColor = [UIColor clearColor];

/** Apple requires this to be implemented by CALayer subclasses */
+(id)layer
{
	SVGKLayer* layer = [[[SVGKLayer alloc] init] autorelease];
	return layer;
}

- (id)init
{
    self = [super init];
    if (self)
	{
#if TARGET_OS_IPHONE
    	self.borderColor = [UIColor blackColor].CGColor;
#else
        self.borderColor = [NSColor blackColor].CGColor;
#endif
		
		[self addObserver:self forKeyPath:@"showBorder" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}
-(void)setSVGImage:(SVGKImage *) newImage
{
	if( newImage == _SVGImage )
		return;
	
	/** 1: remove old */
	if( _SVGImage != nil )
	{
		[_SVGImage.CALayerTree removeFromSuperlayer];
		[_SVGImage release];
	}
	
	/** 2: update pointer */
	_SVGImage = newImage;
	
	/** 3: add new */
	if( _SVGImage != nil )
	{
		[_SVGImage retain];
		[self addSublayer:_SVGImage.CALayerTree];
	}
}

- (void)dealloc
{
	//FIXME: Apple crashes on this line, even though BY DEFINITION Apple should not be crashing: [self removeObserver:self forKeyPath:@"showBorder"];
	
	self.SVGImage = nil;
	
    [super dealloc];
}

/** Trigger a call to re-display (at higher or lower draw-resolution) (get Apple to call drawRect: again) */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if( [keyPath isEqualToString:@"showBorder"] )
	{
		if( self.showBorder )
		{
			self.borderWidth = 1.0f;
		}
		else
		{
			self.borderWidth = 0.0f;
		}
		
		[self setNeedsDisplay];
	}
}

@end
