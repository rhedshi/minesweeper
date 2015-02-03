//
//  MineSweeperTile.m
//  Minesweeper
//
//  Created by Rhed Shi on 10/2/14.
//  Copyright (c) 2014 Rhed Shi. All rights reserved.
//

#import "MineSweeperTile.h"

@interface MineSweeperTile ()
{
    MineSweeperTileStateType currentState;
}

@end

@implementation MineSweeperTile

- (id)initWithCell:(MineSweeperCell *)cell size:(CGFloat)size
{
    self = [super init];
    if (self) {
        self.cell = cell;
        
        CGFloat x = cell.y * size + MARGIN;
        CGFloat y = cell.x * size + MARGIN;
        
        self.frame = CGRectMake(x, y, size - MARGIN, size - MARGIN);
        [self setSelected:NO];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
        [self addGestureRecognizer:longPressRecognizer];
    }
    return self;
}

- (void)revealMine
{
    MineSweeperTileStateType previousState = currentState;
    
    [self changeState:kRevealedState];
    [UIView animateWithDuration:1.5
                          delay:0.0
         usingSpringWithDamping:2.0
          initialSpringVelocity:3.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self changeState:previousState];
    }
                     completion:NULL];
}

- (void)setSelected:(BOOL)selected
{
    if (!selected)
    {
        self.cell.visited = NO;
        [self changeState:kHiddenState];
    }
    else
    {
        self.cell.visited = YES;
        [self changeState:kRevealedState];
    }
}

- (void)longPressRecognized:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan && !self.cell.visited) {
        self.cell.marked = !self.cell.marked;
        if (self.cell.marked) {
            [self changeState:kMarkedState];
        }
        else {
            [self changeState:kHiddenState];
        }
    }
}

- (void)changeState:(MineSweeperTileStateType)state
{
    currentState = state;
    
    switch (state) {
        case kHiddenState:
            self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.65];
            self.layer.shadowColor = [UIColor clearColor].CGColor;
            
            [self setAttributedTitle:[[NSAttributedString alloc] initWithString:@""] forState:UIControlStateNormal];
            break;
            
        case kRevealedState:
            if (self.cell.isMine)
            {
                self.backgroundColor = [UIColor redColor];
            }
            else
            {
                NSString *title = self.cell.neighborMines == 0 ? @"" : [NSString stringWithFormat:@"%ld", self.cell.neighborMines];
                
                UIColor *color;
                switch (self.cell.neighborMines) {
                    case 1:
                        color = [UIColor greenColor];
                        break;
                        
                    case 2:
                        color = [UIColor blueColor];
                        break;
                        
                    case 3:
                        color = [UIColor purpleColor];
                        break;
                        
                    default:
                        color = [UIColor blackColor];
                        break;
                }
                
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:color}] forState:UIControlStateNormal];
                
                self.backgroundColor = [UIColor whiteColor];
            }
            
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowOpacity = 0.5;
            self.layer.shadowOffset = CGSizeMake(0, 2);
            self.layer.shadowRadius = 2.0;
            break;
            
        case kMarkedState:
            self.backgroundColor = [UIColor orangeColor];
            
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowOpacity = 0.5;
            self.layer.shadowOffset = CGSizeMake(0, 2);
            self.layer.shadowRadius = 2.0;
            break;
            
        default:
            break;
    }
}

@end
