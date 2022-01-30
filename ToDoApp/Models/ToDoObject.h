//
//  ToDoObject.h
//  ToDoApp
//
//  Created by Akram Elhayani on 27/01/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
enum Priorty{
    Low,
    Mediam,
    High
};
enum State{
    ToDO,
    InProgress,
    Done
};
@interface ToDoObject : NSObject<NSCoding>
@property NSString *Name;
@property NSString *Description;
@property enum Priorty  Priorty;
@property NSDate *CreationDate;
@property UIImage *Attachiment;
@property enum State  State;

-(id)initWithName:(NSString*)name;
-(id)initWithName:(NSString*)name andDescription:(NSString*)des;

- (void)encodeWithCoder:(NSCoder *)coder;
- (nullable instancetype)initWithCoder:(NSCoder *)coder;
@end

NS_ASSUME_NONNULL_END
