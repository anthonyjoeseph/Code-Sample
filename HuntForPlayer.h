//
//  HuntForPlayer.h
//  Detonate
//
//  Created by Anthony Gabriele on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EvilBehavior.h"
#import "Constants.h"

@interface HuntForPlayer : EvilBehavior{
    GameObject *followMe;
    bool blockMap[kBoardWidthInTiles][kBoardHeightInTiles];
}
-(id)initWithBadGuy:(GameObject *)badGuy follow:(GameObject *)_followMe;
-(GameDirection)bestDirectionFrom:(CGPoint)startPosition to:(CGPoint)goalPosition traversed:(bool[17][15])traversedTiles;
-(GameDirection)bestDirectionFrom:(CGPoint)startPosition to:(CGPoint)goalPosition;
-(void)directionPreferenceOrderFromStart:(CGPoint)startTilePoint goal:(CGPoint)goalTilePoint array:(GameDirection[4])returnArray;
-(CGPoint)offsetTilePointFromStartPoint:(CGPoint)startPoint direction:(GameDirection)direction;

@end
