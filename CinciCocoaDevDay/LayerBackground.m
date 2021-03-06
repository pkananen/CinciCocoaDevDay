//
//  LayerBackground.m
//  CinciCocoaDevDay
//
//  Created by David Miller on 6/25/11.
//  Copyright 2011 NHXHN, LLC. All rights reserved.
//

#import "LayerBackground.h"


@implementation LayerBackground

-(id) init
{
	if ((self = [super init]))
	{
		// The screensize never changes during gameplay, so we can cache it in a member variable.
		screenSize = [[CCDirector sharedDirector] winSize];
		
		// Get the game's texture atlas texture by adding it. Since it's added already it will simply return 
		// the CCTexture2D associated with the texture atlas.
		CCTexture2D* gameArtTexture = [[CCTextureCache sharedTextureCache] addImage:@"game-art.png"];
		
		// Create the background spritebatch
		spriteBatch = [CCSpriteBatchNode batchNodeWithTexture:gameArtTexture];
		[self addChild:spriteBatch];
        
        //number of background stripes
		numStripes = 5;
		
		// Add the 3 different stripes and position them on the screen
		for (int i = 0; i < numStripes; i++)
		{
			NSString* frameName = [NSString stringWithFormat:@"BG_%i.png", i + 1];
            //NSLog(@"Frame: %@", frameName);
			CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:frameName];
			sprite.anchorPoint = CGPointMake(0, 0.5f);
			sprite.position = CGPointMake(0, screenSize.height / 2);
			[spriteBatch addChild:sprite z:i tag:i];
		}
        
        // Add 3 more stripes, flip them and position them next to their neighbor stripe
		for (int i = 0; i < numStripes; i++)
		{
			NSString* frameName = [NSString stringWithFormat:@"BG_%i.png", i + 1];
			CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:frameName];
			
			// Position the new sprite one screen width to the right
			sprite.anchorPoint = CGPointMake(0, 0.5f);
			sprite.position = CGPointMake(screenSize.width - 1, screenSize.height / 2);
            
			// Flip the sprite so that it aligns perfectly with its neighbor
			sprite.flipX = YES;
			
			// Add the sprite using the same tag offset by numStripes
			[spriteBatch addChild:sprite z:i tag:i + numStripes];
		}
		
		// Initialize the array that contains the scroll factors for individual stripes.
		speedFactors = [[CCArray alloc] initWithCapacity:numStripes];
		[speedFactors addObject:[NSNumber numberWithFloat:0.0f]];
		[speedFactors addObject:[NSNumber numberWithFloat:0.1f]];
		[speedFactors addObject:[NSNumber numberWithFloat:0.1f]];
        [speedFactors addObject:[NSNumber numberWithFloat:0.2f]];
        [speedFactors addObject:[NSNumber numberWithFloat:0.3f]];
		NSAssert([speedFactors count] == numStripes, @"speedFactors count does not match numStripes!");
        
		scrollSpeed = 1.0f;
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) dealloc
{
	[speedFactors release];
	[super dealloc];
}

-(void) update:(ccTime)delta
{
	CCSprite* sprite;
	CCARRAY_FOREACH([spriteBatch children], sprite)
	{
		//CCLOG(@"tag: %i", sprite.tag);
		NSNumber* factor = [speedFactors objectAtIndex:sprite.zOrder];
		
		CGPoint pos = sprite.position;
		pos.x -= scrollSpeed * [factor floatValue];
		
		// Reposition stripes when they're out of bounds
		if (pos.x < -screenSize.width)
		{
			pos.x += (screenSize.width * 2) - 2;
		}
		
		sprite.position = pos;
	}
}

@end
