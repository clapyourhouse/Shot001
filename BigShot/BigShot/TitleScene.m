//
//  TitleScene.m
//  BigShot
//
//  Created by KitamuraShogo on 13/04/18.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"
#import <Parse/Parse.h>

@implementation TitleScene

static TitleScene* instanceOfTitleScene;
//インスタンスを返すメソッド
+(TitleScene*) sharedTitleScene{
    NSAssert(instanceOfTitleScene != nil,@"GameScene instance not yet initialized!");
    return instanceOfTitleScene;
}
//シーンを作るクラスメソッド
+(id)titleScence{
    return [[[self alloc]init]autorelease];
}

//初期化メソッド
-(id)init{
    if ((self = [super initWithColor:ccc4(0, 0, 0, 230)])) {
        instanceOfTitleScene = self;
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"BigShot" fontName:@"Marker Felt" fontSize:60];
        titleLabel.position = CGPointMake(winSize.width/2, winSize.height - winSize.height/4);
        [self addChild:titleLabel];
        
        _welcomeLabel = [CCLabelTTF labelWithString:@"Welcome!!" fontName:@"Marker Felt" fontSize:46];
        _welcomeLabel.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:_welcomeLabel];
        
        _startItem = [CCMenuItemImage itemFromNormalImage:@"start.png" selectedImage:@"start.png" target:self selector:@selector(startGame:)];
        
        _tutorial = [CCMenuItemImage itemFromNormalImage:@"HelpBtn.png" selectedImage:@"HelpBtn.png" target:self selector:@selector(tutorial:)];
        //スタート
        CCMenu *menu = [CCMenu menuWithItems:_startItem, nil];
        menu.position = CGPointMake(winSize.width/2, winSize.height/3);
        [self addChild:menu];
    
        //チュートリアル
        CCMenu *tutorial = [CCMenu menuWithItems:_tutorial, nil];
        tutorial.position = CGPointMake(winSize.width/2, winSize.height/5);
        [self addChild:tutorial];

        
        [self loadScore];
    }
    return self;
}

#pragma mark --
#pragma mark メニューからのアクション
-(void)startGame:(CCMenuItem *)menuItem{
    CCLOG(@"startGame");
    self.visible = NO;//visible NOでstartGameされたら下のレイアーを見せている。
    [[GameScene sharedGameScene]gameStart];
    
}

-(void)tutorial:(CCMenuItem *)menuItem{
    
    //LLVM GCC 4.2を4.1に変更。
    //introductionのdelegateをweakからnonatomic,assign変更
  	
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //------チュートリアルは完璧です。------//
    //パネル1の作成
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc]initWithimage:[UIImage imageNamed:@"STOP10_icon.png"] description:@"10秒以内にタップします。"];
    //パネル２の作成
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"f0060760_0455831.jpg"] description:@"数字の大きい方をタップしてください。"];
    //パネル３の作成
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tumblr_lzb8m2MKas1qbktxyo1_500.jpg"] description:@"Let's Enjoy!!!!!"];
    
    //紹介ビューの作成。
    MYIntroductionView *introductionView = [[MYIntroductionView alloc]initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height) headerText:@"遊び方" panels:@[panel, panel2,panel3] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundImage:[UIImage imageNamed:@"0315今度。.jpg"]];
    
    //デリゲートの指定。
    introductionView.delegate = self;
    //紹介ビューの表示。
    [introductionView showInView:[CCDirector sharedDirector].openGLView];
    
}

//2回目以降ベストスコアを呼び出し。(予定)
-(void)loadScore{
    PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
    //        [query whereKey:@"playerGame" equalTo:@"shogo"];
    PFObject *gameScore = [query getObjectWithId:@"VSkvJ8tsST"];
    int scoreLoad = [[gameScore objectForKey:@"score"] intValue];
    //  [query orderByAscending:@"score"];
    
    NSLog(@"%d",scoreLoad);
    [_welcomeLabel setString:[NSString stringWithFormat:@"BestScore : %d",scoreLoad]];


}
#pragma mark --
#pragma mark 表示を変える
-(void)changeScoreWithScore:(int)score{
    
       [_welcomeLabel setString:[NSString stringWithFormat:@"Score : %d",score]];
}
@end
