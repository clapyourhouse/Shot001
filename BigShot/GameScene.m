//
//  GameScene.m
//  BigShot
//
//  Created by KitamuraShogo on 13/04/16.
//
//

#import "GameScene.h"
#import "cocos2d.h"
#import "Gun.h"
#import "Target.h" 
#import "TitleScene.h"
#import "SimpleAudioEngine.h"
#import <Parse/Parse.h>

@implementation GameScene

static GameScene* instanceOfGameScene;
//インスタンスを返すクラスメソッド
+(GameScene*)sharedGameScene{
    NSAssert(instanceOfGameScene != nil,@"GameScene instance not yet initialized!");
    return instanceOfGameScene;
    
}
// シーンを作るクラスメソッド
+(id)scene{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [GameScene node];
    [scene addChild:layer];
    return scene;
 
}

//初期化メソッド
-(id)init{
    if ((self = [super init])) {
        instanceOfGameScene = self;
        //タップは最初は不可
        _touchEnable = NO;
        //画面のサイズを取得する。
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        
        //音声のリロード
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"ban.mp3"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"chi.mp3"];
        

        NSString *text;
        NSString *path = @"/Users/KitamuraShogo/Desktop/BigShot/BigShot/shogo.txt";
        NSError *error;
        text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        
        NSLog(@"Text:%@",text);
        
        /////////////
        ///タイトルを作る
        ////////////
        TitleScene *titleScene = [TitleScene titleScence];
        [self addChild:titleScene z:kTagZIndexTitleScene];
        
        
        //背景//UIViewのようなもの。
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"stage.png"];
        //cocos2dはアンカーポイントが左上ではなく中心にある。
        backgroundImage.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:backgroundImage];
        
        ////////////
        //Gun
        ////////////
        Gun *gun = [Gun gun];
        [self addChild:gun];
        
        
        ////////////
        //Target
        ////////////
        //左のターゲットを作る。
        _targetLeft = [Target target];
        _targetLeft.position = CGPointMake(winSize.width/4, winSize.height/2+winSize.height/12);
        [_targetLeft setTargetNum:2];//値の設定。
        [self addChild:_targetLeft];
        //右のターゲットを作る。
        _targetRight = [Target target];
        _targetRight.position = CGPointMake(winSize.width/4+winSize.width/2, winSize.height/2+winSize.height/12);
        [_targetRight setTargetNum:5];
        [self addChild:_targetRight];
        
        
        ///////////////
        //scoreをセットする
        //////////////
        int fontSize = 18;
        _highScoreLabel = [CCLabelTTF labelWithString:@"High Score : 000" fontName:@"Marker Felt" fontSize:fontSize];
        _highScoreLabel.position = CGPointMake(0, winSize.height/4);
        _highScoreLabel.anchorPoint = CGPointMake(0, 1);
        [self addChild:_highScoreLabel];
        
        CCLabelTTF *spaceLabel = [CCLabelTTF labelWithString:@"high " fontName:@"Marker Felt" fontSize:fontSize];
        _scoreLabel = [CCLabelTTF labelWithString:@"Score : 000" fontName:@"Marker Felt" fontSize:fontSize];
        _scoreLabel.position = CGPointMake(spaceLabel.contentSize.width, winSize.height/4-_highScoreLabel.contentSize.height);
        _scoreLabel.anchorPoint = CGPointMake(0, 1);
        [self addChild:_scoreLabel];
        
        //変数の初期化
        _nowScore = 0;
        _highScore = 0;
        [self setScore];
        
        ///////////////
        //ゲームサイクル
        //////////////
        _timerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.01f",10.0f] fontName:@"Marker Felt" fontSize:64];
        _timerLabel.position = CGPointMake(winSize.width/2, winSize.height - winSize.height/6);
        [self addChild:_timerLabel];

        /////////////
        //scoreをParseで読み込み
        /////////////
        ///仮、score読み込み。 今は、特定のIdからscoreを指定してTitleにBestScoreとして表示しているだけ。
        //読み込み。
        PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
        [query whereKey:@"score" equalTo:[NSNumber numberWithInteger:_nowScore]];
        
        NSArray* scoreArray = [query findObjects];
        query.limit = 1;
        query.skip = 1;
        [query orderByAscending:@"score"];
        NSLog(@"%@",scoreArray);

//
//        //読み込み。
//        PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
//        [query whereKey:@"playerGame" equalTo:@"shogo"];
//        PFObject *gameScore = [query getObjectWithId:@"VSkvJ8tsST"];
//        int score = [[gameScore objectForKey:@"score"] intValue];
//        NSLog(@"%d",score);
//        [query whereKey:@"score" equalTo:[NSNumber numberWithInteger:_nowScore]];
////        //受信した際の表示、反映が不明。
//        query.limit = 1;
//         NSArray* scoreArray = [query findObjects];
//         NSLog(@"%@",scoreArray);

    }

    return self;
}

//タッチを感知する//
-(void)onEnter{
    //タッチを感知してSelfに通知。優先順位は0
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}
-(void)onExit{
    //タッチを感知するのをやめる
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    [super onExit];
}

//タッチを感知した時のdelegate//
//タッチが始まった。
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return _touchEnable;
}
//タッチが動いている。
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
//タッチが終わっている。
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    //タッチの最後に離した場所を取得。
    CGPoint touchEndPoint = [touch locationInView:[touch view]];
    //gunの唯一のインスタンスを取得。
    Gun *gun = [Gun sharedGun];
    if (touchEndPoint.x < winSize.width/2) {
        //画面より左なら
        CCLOG(@"左");
        [gun changeGunWithFlipX:NO];
        [self touchRightOrNot:NO];
    }else{
        //画面より右なら
        CCLOG(@"右");
        [gun changeGunWithFlipX:YES];
        [self touchRightOrNot:YES];

        
    }
}


-(void)setTarget{
    [self unschedule:@selector(setTarget)];
    
    int leftNum = floor(CCRANDOM_0_1() *8+1);
    int rightNum = floor(CCRANDOM_0_1() *8+1);
    while (rightNum == leftNum) {
        rightNum = floor(CCRANDOM_0_1() *8+1);
    }
    if (CCRANDOM_0_1()<0.3) {
        leftNum *= -1;
        rightNum *= -1;
    }
    
    [_targetLeft setTargetNum:leftNum];
    [_targetRight setTargetNum:rightNum];
}
-(void)touchRightOrNot:(BOOL)boolean{
    //booleanがYesのときは右、booleanがNoのときは左。
    int leftNum = [_targetLeft getTargetNum];
    int rightNum = [_targetRight getTargetNum];
    if ((boolean && rightNum>leftNum) || (!boolean && rightNum<leftNum)) {
        //ここに正解した時の処理を書く。
        _nowScore++;
        //ターゲットの初期化
        [self setTarget];
        
        [[SimpleAudioEngine sharedEngine]playEffect:@"ban.mp3"];
        
        //パーティクルで正解時に演出。(予定)
        //
        //        CGSize winSize = [[CCDirector sharedDirector]winSize];
        //        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        //        emitterLayer.emitterPosition = CGPointMake(winSize.width / 2, winSize.height / 2);
        //        emitterLayer.renderMode = kCAEmitterLayerAdditive;
        //       // [emitterLayer addSublayer:[[CCDirector sharedDirector] openGLView].layer];
        ////        [emitterLayer addSublayer:[[Target target]initWithTargetImage]];
        //        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        //        UIImage *image = [UIImage imageNamed:@"particle1.png"];
        //        emitterCell.contents = (__bridge id)(image.CGImage);
        //        emitterCell.emissionLongitude = M_PI * 2;
        //        emitterCell.emissionRange = M_PI * 2;
        //        emitterCell.birthRate = 800;
        //        emitterCell.lifetimeRange = 1.2;
        //        emitterCell.velocity = 240;
        //        emitterCell.color = [UIColor colorWithRed:0.89
        //                                            green:0.56
        //                                             blue:0.36
        //                                            alpha:0.5].CGColor;
        //        
        //        emitterLayer.emitterCells = @[emitterCell];
        //        


    }else{
        CCLOG(@"間違いですよ。");
        _nowScore -= 2;
        [[SimpleAudioEngine sharedEngine]playEffect:@"chi.mp3"];
        
    }
    //スコアの更新。
    [self updataScore:_nowScore];
}

//起動時にスコアを表示する。//ここでParseロード？
-(void)setScore{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _highScore = [defaults integerForKey:@"HighScore"];
    [_highScoreLabel setString:[NSString stringWithFormat:@"High Score : %d",_highScore]];
    
    
    
    
    
}
//ゲーム中スコアを更新するごとに呼び出される。
-(void)updataScore:(int)score{
    if (_highScore<score) {
        //今のスコアを上回ったとき
        _highScore = score;
        [_highScoreLabel setString:[NSString stringWithFormat:@"High Score : %d", _highScore]];
    }
    [_scoreLabel setString:[NSString stringWithFormat:@"Score : %d", _nowScore]];
}
//ゲームが終わったときにハイスコアを保存する。
-(void)setHighScore:(int)score{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_highScore forKey:@"HighScore"];
    [defaults synchronize];
    //後で、gameセンターの実装を行うようです。
}

//ゲームサイクル
-(void)gameStart{
    //タップを可能にする
    _touchEnable = YES;
    //ターゲットの初期化
    [self setTarget];
    //スコアの初期化
    _nowScore = 0;
    //タイマーの初期化
    _timer = 10.0;
    //sタイマーを0.1秒間隔で回す
    [self schedule:@selector(updataTimer) interval:0.1];
}

-(void)updataTimer{
    _timer -= 0.1;
    if (_timer<=0.0) {
        //タップを不可にする
        _touchEnable = NO;
        
        [_timerLabel setString:[NSString stringWithFormat:@"0.0"]];//-0.0と表示されてしまうため0のときは特別に。
        [self unschedule:@selector(updataTimer)];
        //gameOverの呼び出し。
        [self gameOver];
        return;
    }
    [_timerLabel setString:[NSString stringWithFormat:@"%.01f",_timer]];
}
-(void)gameOver{
    //ハイスコアの更新
    [self setHighScore:_nowScore];
    //TitleSceneにスコアを表示させる。
    [[TitleScene sharedTitleScene] changeScoreWithScore:_nowScore];
    //TitleSceneを表示する。
    [TitleScene sharedTitleScene].visible = YES;
    //Parseにセーブ。
    PFObject *gameScore = [PFObject objectWithClassName:@"GameScore"];
    [gameScore setObject:@"playerName" forKey:@"shogo"];
    [gameScore setObject:[NSNumber numberWithInteger:_nowScore]forKey:@"score"];
    [gameScore save];
    
}
@end
