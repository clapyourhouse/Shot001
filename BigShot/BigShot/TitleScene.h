//
//  TitleScene.h
//  BigShot
//
//  Created by KitamuraShogo on 13/04/18.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MYIntroductionView.h"

@interface TitleScene : CCLayerColor<MYIntroductionDelegate> {
    CCMenuItemImage *_startItem;
    CCMenuItemLabel *_tutorial;
    
    CCLabelTTF *_welcomeLabel;
    
    NSMutableArray *shogoArray;
}
+(id)titleScence;
+(TitleScene*) sharedTitleScene;
//メニューからのアクション
-(void)startGame:(CCMenuItem*)menuItem;
//ゲームが終わったときに呼ばれる。
-(void)changeScoreWithScore:(int)score;

@end
