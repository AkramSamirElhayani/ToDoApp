//
//  ToDoObject.m
//  ToDoApp
//
//  Created by Akram Elhayani on 27/01/2022.
//

#import "ToDoObject.h"

@implementation ToDoObject
{
    
    
}
 
-(id)initWithName:(NSString*)name{
    self = [super init];
    if(self){
        _CreationDate = [NSDate date];
        _State = ToDO;
    }
    return self;
}
-(id)initWithName:(NSString*)name andDescription:(NSString*)des{
    self = [self initWithName:name];
    _Description = des;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    
  
    [coder encodeObject:_Name forKey:@"Name"];
    [coder encodeObject:_Description forKey:@"Description"];
    [coder encodeInt:_Priorty forKey:@"Priorty"];
    [coder encodeInt:_State forKey:@"State"];
    [coder encodeObject:_CreationDate forKey:@"CreationDate"];
    [coder encodeObject:_Attachiment forKey:@"Attachiment"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if(self){
        _Name = [coder decodeObjectForKey:@"Name"];
        _Description=[coder decodeObjectForKey:@"Description"];
        _Priorty=[coder decodeIntForKey:@"Priorty"];
        _State=[coder decodeIntForKey:@"State"];
        _CreationDate = [coder decodeObjectForKey:@"CreationDate"];
        _Attachiment = [coder decodeObjectForKey:@"Attachiment"];
    }
    return self;
}



@end
