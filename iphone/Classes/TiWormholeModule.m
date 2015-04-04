/**
 * Copyright (c) 2015 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the MIT License
 * Please see the LICENSE included with this distribution for details.
 *
 */

#import "TiWormholeModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiUtils.h"

@implementation TiWormholeModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"a27f3702-c2d4-4ae9-a575-b17a25926e24";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.wormhole";
}

#pragma mark Lifecycle

-(void)startup
{
	// you *must* call the superclass
	[super startup];

}


-(void)shutdown:(id)sender
{
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup


#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}


#pragma Public APIs

-(void)start:(id)args
{
    ENSURE_UI_THREAD(start, args)
    ENSURE_SINGLE_ARG(args,NSDictionary);
    ENSURE_TYPE(args,NSDictionary);
    if(![args objectForKey:@"suiteName"]) {
        NSLog(@"[ERROR] suiteName field is required");
        return;
    }
    NSString* identifier =[TiUtils stringValue:@"suiteName" properties:args];
    NSString* dir = [TiUtils stringValue:@"directory" properties:args def:@"tiwormhole"];
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:identifier
                                                         optionalDirectory:dir];
}

-(void)post:(id)args
{
    ENSURE_ARG_COUNT(args,2);
    NSString* eventName = [TiUtils stringValue:[args objectAtIndex:0]];
    NSDictionary *dict = [args objectAtIndex:1];
    ENSURE_TYPE(dict,NSDictionary);
    ENSURE_UI_THREAD(post,args);
    [self.wormhole passMessageObject:dict identifier:eventName];
}


-(id)readWormhole:(id)args
{
    ENSURE_ARG_COUNT(args,1);
    NSString* name = [TiUtils stringValue:[args objectAtIndex:0]];
    ENSURE_TYPE(name,NSString);
    
    id messageObject = [self.wormhole messageWithIdentifier:name];
    
    if([messageObject isKindOfClass: [NSDictionary class]]){
    
        return  [NSDictionary dictionaryWithObjectsAndKeys:
                                       name,@"wormholeName",
                                       (NSDictionary*)messageObject,@"wormhole",
                                       nil];
        
    } else if ([messageObject isKindOfClass: [NSArray class]]){
        return  [NSDictionary dictionaryWithObjectsAndKeys:
                     name,@"wormholeName",
                     (NSArray*)messageObject,@"wormhole",
                     nil];
    }else{
        return nil;
    }
}

-(void)addWormhole:(id)args
{
    ENSURE_ARG_COUNT(args,2);
    NSString* eventName = [TiUtils stringValue:[args objectAtIndex:0]];
    KrollCallback *callback = [args objectAtIndex:1];
    ENSURE_TYPE(callback,KrollCallback);
    ENSURE_UI_THREAD(addWormhole,args);
    
    [self.wormhole listenForMessageWithIdentifier:eventName listener:^(id messageObject) {
        if([messageObject isKindOfClass: [NSDictionary class]]){
            if(callback){
                NSDictionary *dictEvent = [NSDictionary dictionaryWithObjectsAndKeys:
                                           eventName,@"wormholeName",
                                           (NSDictionary*)messageObject,@"wormhole",
                                         nil];
                [self _fireEventToListener:eventName
                                withObject:dictEvent listener:callback thisObject:nil];
            }
        }
        if([messageObject isKindOfClass: [NSArray class]]){
            if(callback){
                NSDictionary *arrayEvent = [NSDictionary dictionaryWithObjectsAndKeys:
                                           eventName,@"wormholeName",
                                           (NSArray*)messageObject,@"wormhole",
                                           nil];
                [self _fireEventToListener:eventName
                                withObject:arrayEvent listener:callback thisObject:nil];
            }
        }

    }];
}

-(void)removeWormhole:(id)arg
{
    ENSURE_ARG_COUNT(arg,1);
    ENSURE_UI_THREAD(removeWormhole,arg);
    NSString* eventName = [TiUtils stringValue:[arg objectAtIndex:0]];
    [self.wormhole stopListeningForMessageWithIdentifier:eventName];
}

-(void)clearAllMessageContents:(id)unused
{
    [self wormhole].clearAllMessageContents;
}

@end
