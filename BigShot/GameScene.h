//
//  GameScene.h
//  BigShot
//
//  Created by KitamuraShogo on 13/04/16.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
@class Target;

enum{
    kTagZIndexTitleScene = 100,
};

@interface GameScene : CCLayer{
    Target *_targetLeft;
    Target *_targetRight;
    //スコア関係。
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_scoreLabel;
    int _highScore;
    int _nowScore;
    
    //ゲームサイクル関係
    CCLabelTTF *_timerLabel;
    double _timer;
    
    BOOL _touchEnable;
}
+(id)scene;
+(GameScene*) sharedGameScene;
-(void)setTarget;
-(void)touchRightOrNot:(BOOL)boolean;

//スコア関係。
-(void)setScore;
-(void)updataScore:(int)score;
-(void)setHighScore:(int)score;

//ゲームサイクル関係。
-(void)gameStart;
-(void)updataTimer;
-(void)gameOver;

@end
