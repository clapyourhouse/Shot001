//
//  Gun.h
//  BigShot
//
//  Created by KitamuraShogo on 13/04/16.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Gun : CCSprite {
    
}
+(Gun*)sharedGun;
+(id)gun;
-(id)initWithGunImage;
- (void)changeGunWithFlipX:(BOOL)flipBool;

@end
