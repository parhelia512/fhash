//
//  HashBridge.mm
//  fHash
//
//  Created by Sun Junwen on 2023/12/7.
//  Copyright © 2023 Sun Junwen. All rights reserved.
//

#import "HashBridge.h"

#include <stdint.h>
#include <pthread.h>
#include <string>
#include "Common/strhelper.h"
#include "Common/Global.h"
#include "Common/HashEngine.h"

#import <Cocoa/Cocoa.h>
#import "fHash-Swift-Header.h"
#import "UIBridgeMacSwift.h"

using namespace std;
using namespace sunjwbase;

@interface HashBridge()

@property (assign) UIBridgeMacSwift *uiBridgeSwift;
@property (assign) ThreadData *thrdData;
@property (assign) pthread_t ptHash;

@end

@implementation HashBridge

@synthesize uiBridgeSwift = _uiBridgeSwift;
@synthesize thrdData = _thrdData;
@synthesize ptHash = _ptHash;

// Not be called on exit.
// Just for sure.
- (void)dealloc {
    delete _uiBridgeSwift;
    delete _thrdData;
}

- (instancetype)initWithController:(MainViewController *)mainViewController {
    self = [super init];
    if (self) {
        _uiBridgeSwift = new UIBridgeMacSwift(mainViewController);
        _thrdData = new ThreadData();
    }
    return self;
}

- (void)didLoad {
    _thrdData->uiBridge = _uiBridgeSwift;
}

- (void)clear {
    _thrdData->threadWorking = false;
    _thrdData->stop = false;

    _thrdData->uppercase = false;
    _thrdData->totalSize = 0;

    _thrdData->nFiles = 0;
    _thrdData->fullPaths.clear();

    _thrdData->resultList.clear();
}

- (void)setStop:(bool)val {
    _thrdData->stop = val;
}

- (void)setUppercase:(bool)val {
    _thrdData->uppercase = val;
}

- (int)getProgMax {
    return _uiBridgeSwift->getProgMax();
}

- (uint64_t)getTotalSize {
    return _thrdData->totalSize;
}

- (void)addFiles:(NSArray *)fileNames isURL:(BOOL)isURL {
    // Get files path.
    NSUInteger fileCount = [fileNames count];
    _thrdData->nFiles = (uint32_t)fileCount;
    _thrdData->fullPaths.clear();

    for (uint32_t i = 0; i < _thrdData->nFiles; ++i) {
        string strFileName;
        if (!isURL) {
            NSString *nsstrFileName = [fileNames objectAtIndex:i];
            strFileName = MacUtils::ConvertNSStringToUTF8String(nsstrFileName);
        } else {
            NSURL *nsurlFileName = [fileNames objectAtIndex:i];
            strFileName = MacUtils::ConvertNSStringToUTF8String([nsurlFileName path]);
        }
        _thrdData->fullPaths.push_back(strtotstr(strFileName));
    }
}

- (NSArray *)getResults {
    NSMutableArray *results = [[NSMutableArray alloc] init];

    ResultList::iterator itr = _thrdData->resultList.begin();
    for(; itr != _thrdData->resultList.end(); ++itr)
    {
        ResultDataSwift *resultData = UIBridgeMacSwift::ConvertResultDataToSwift(*itr);
        [results addObject:resultData];
    }

    return results;
}

- (void)startHashThread {
    pthread_create(&_ptHash,
                   NULL,
                   (void *(*)(void *))HashThreadFunc,
                   _thrdData);
}

@end
