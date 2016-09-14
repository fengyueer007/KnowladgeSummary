//
//  RCDraggableButton.m
//  
//
//  Created by admin on 15/11/25.
//
//

#pragma mark 此手势 有冲突

#import "RCDraggableButton.h"

@implementation RCDraggableButton



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
    NSLog(@"222");
//    _beginLocation =[touch locationInView:self.superview];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"333");
//    UITouch *touch = [touches anyObject];
//    CGPoint currentLocation = [touch locationInView:self.superview];
//    NSLog(@"currentLocation===%f",currentLocation.x);
//    NSLog(@"_beginLocation===%f",_beginLocation.x);
//    NSLog(@"%f",_beginLocation.x - currentLocation.x);
    
//    float offsetX = currentLocation.x - _beginLocation.x;
//    self.center = CGPointMake(self.center.x + offsetX, self.center.y);
//    NSLog(@"self.center.x = %f",self.center.x);
//    CGRect superviewFrame = self.superview.frame;
//    CGRect frame = self.frame;
//    CGFloat leftLimitX = frame.size.width / 2;
//    CGFloat rightLimitX = superviewFrame.size.width - leftLimitX;
//    if (self.center.x > rightLimitX) {
//        self.center = CGPointMake(rightLimitX, self.center.y);
//    }else if (self.center.x <= leftLimitX ){
//        self.center = CGPointMake(leftLimitX, self.center.y);
//    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"444");
//    [super touchesEnded:touches withEvent:event];
//    CGRect superviewFrame = self.superview.frame;
////    CGRect frame = self.frame;
//    CGFloat middleX = superviewFrame.size.width / 2;
//    if (self.center.x >= middleX) {
//        [UIView animateWithDuration:0.2 animations:^{
//            if (self.center.x > superviewFrame.size.width * 3 / 4) {
//                NSLog(@"nihap");
//            }
//            else{
//                self.center = CGPointMake(superviewFrame.size.width / 2, self.center.y);
//            }
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//    } else {
//        [UIView animateWithDuration:0.2 animations:^{
//            if (self.center.x < superviewFrame.size.width / 4) {
//                NSLog(@"nihap");
//            }
//            else{
//                self.center = CGPointMake(superviewFrame.size.width / 2, self.center.y);
//            }
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
