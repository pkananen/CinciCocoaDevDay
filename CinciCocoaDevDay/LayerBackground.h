//
//  LayerBackground.h
//  CinciCocoaDevDay
//
//  Created by David Miller on 6/25/11.
//  Copyright 2011 NHXHN, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LayerBackground : CCNode {
    
    CCSpriteBatchNode* spriteBatch;
    
	int numStripes;
    
	CCArray* speedFactors;
	float scrollSpeed;
    
	CGSize screenSize;
    
}

@end
