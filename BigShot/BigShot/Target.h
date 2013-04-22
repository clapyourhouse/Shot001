//
//  Target.h
//  BigShot
//
//  Created by KitamuraShogo on 13/04/17.
//
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface Target : CCSprite{
    int _targetNum;
    CCLabelTTF *_targetNumLabel;
}

+(id)target;
-(id)initWithTargetImage;
-(void)setTargetNum:(int)num;
-(int)getTargetNum;
////正解かどうか判断。
//-(void)targetActionWithCollect:(BOOL)boolean;
@end
