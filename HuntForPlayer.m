//
//  HuntForPlayer.m
//  Detonate
//
//  Created by Anthony Gabriele on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HuntForPlayer.h"

@implementation HuntForPlayer
-(id)initWithBadGuy:(GameObject *)badGuy follow:(GameObject *)_followMe{
    if((self = [super initWithBadGuy:badGuy])){
        followMe = _followMe;
    }
    return self;
}
-(void)hasReachedTileAndIsMovingTo:(CGPoint)wantedTilePoint listOfBlocks:(NSArray *)blockList{
    for(int i = 0; i < kBoardWidthInTiles; i++){
        for(int e = 0; e < kBoardHeightInTiles; e++){
            blockMap[i][e] = NO;
        }
    }
    MovingObject *movingBadGuy = (MovingObject *)self.badGuy;
    for(GameObject *block in blockList){
        CGPoint blockTilePosition = [MovingObject tilePosition:block.position];
        blockMap[(int)blockTilePosition.x][(int)blockTilePosition.y] = YES;
    }
    CGPoint ownTilePosition = [MovingObject tilePosition:movingBadGuy.position];
    CGPoint followThisTilePosition = [MovingObject tilePosition:followMe.position];
    self.badGuy.direction = [self bestDirectionFrom:ownTilePosition to:followThisTilePosition];
    
}
-(GameDirection)bestDirectionFrom:(CGPoint)startPosition to:(CGPoint)goalPosition{
    bool traversedTiles[kBoardWidthInTiles][kBoardHeightInTiles];
    for(int i = 0; i < kBoardWidthInTiles; i++){
        for(int e = 0; e < kBoardHeightInTiles; e++){
            traversedTiles[i][e] = NO;
        }
    }
    return [self bestDirectionFrom:startPosition to:goalPosition traversed:traversedTiles];
}
-(GameDirection)bestDirectionFrom:(CGPoint)startPosition to:(CGPoint)goalPosition traversed:(bool[kBoardWidthInTiles][kBoardHeightInTiles])originalTraversedTiles{
    bool traversedTiles[kBoardWidthInTiles][kBoardHeightInTiles];
    for(int i = 0; i < kBoardWidthInTiles; i++){
        for(int e = 0; e < kBoardHeightInTiles; e++){
            traversedTiles[i][e] = originalTraversedTiles[i][e];
        }
    }
    traversedTiles[(int)startPosition.x][(int)startPosition.y] = YES;
    
    GameDirection directionsToCheck[4];
    [self directionPreferenceOrderFromStart:startPosition goal:goalPosition array:directionsToCheck];
    for(int i = 0; i < 4; i++){
        GameDirection currentDirection = directionsToCheck[i];
        CGPoint positionToCheck = [self offsetTilePointFromStartPoint:startPosition direction:currentDirection];
        if(CGPointEqualToPoint(positionToCheck, goalPosition) || (
           !blockMap[(int)positionToCheck.x][(int)positionToCheck.y] && 
           !traversedTiles[(int)positionToCheck.x][(int)positionToCheck.y] && 
           [self bestDirectionFrom:positionToCheck to:goalPosition traversed:traversedTiles] != -1)){
            return currentDirection;
        }
        //revert the traversed tiles to their original state
        for(int i = 0; i < kBoardWidthInTiles; i++){
            for(int e = 0; e < kBoardHeightInTiles; e++){
                traversedTiles[i][e] = originalTraversedTiles[i][e];
            }
        }
    }
    return -1;
}
-(void)directionPreferenceOrderFromStart:(CGPoint)startTilePoint goal:(CGPoint)goalTilePoint array:(GameDirection[4])returnArray{
    float xOffset = goalTilePoint.x - startTilePoint.x;
    float yOffset = goalTilePoint.y - startTilePoint.y;
    //if the distance is greater from the x position
    if(abs(xOffset) > abs(yOffset)){
        //and it's on the right
        if(xOffset > 0){
            //the first preference should be right and the last preference should be left
            returnArray[0] = kRight;
            returnArray[3] = kLeft;
            if(yOffset > 0){
                returnArray[1] = kDown;
                returnArray[2] = kUp;
            }else{
                returnArray[1] = kUp;
                returnArray[2] = kDown;
            }
        }else{
            returnArray[0] = kLeft;
            returnArray[3] = kRight;
            if(yOffset > 0){
                returnArray[1] = kDown;
                returnArray[2] = kUp;
            }else{
                returnArray[1] = kUp;
                returnArray[2] = kDown;
            }
        }
    }else{
        if(yOffset > 0){
            returnArray[0] = kDown;
            returnArray[3] = kUp;
            if(xOffset > 0){
                returnArray[1] = kRight;
                returnArray[2] = kLeft;
            }else{
                returnArray[1] = kLeft;
                returnArray[2] = kRight;
            }
        }else{
            returnArray[0] = kUp;
            returnArray[3] = kDown;
            if(xOffset > 0){
                returnArray[1] = kRight;
                returnArray[2] = kLeft;
            }else{
                returnArray[1] = kLeft;
                returnArray[2] = kRight;
            }
        }
    }
}
-(CGPoint)offsetTilePointFromStartPoint:(CGPoint)startPoint direction:(GameDirection)direction{
    switch (direction) {
        case kRight:
            return ccp(startPoint.x + 1, startPoint.y);
        case kDown:
            return ccp(startPoint.x, startPoint.y + 1);
        case kLeft:
            return ccp(startPoint.x - 1, startPoint.y);
        case kUp:
            return ccp(startPoint.x, startPoint.y - 1);
    }
}

@end
