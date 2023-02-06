/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTBridge.h"
#import "RCTTurboModuleRegistry.h"

@class RCTBridgeModule;

@implementation RCTModuleRegistry {
  __weak id<RCTTurboModuleRegistry> _turboModuleRegistry;
  __weak RCTBridge *_bridge;
}

- (void)setBridge:(RCTBridge *)bridge
{
  _bridge = bridge;
}

- (void)setTurboModuleRegistry:(id<RCTTurboModuleRegistry>)turboModuleRegistry
{
  _turboModuleRegistry = turboModuleRegistry;
}

- (id)moduleForName:(const char *)moduleName
{
  return [self moduleForName:moduleName lazilyLoadIfNecessary:YES];
}

- (id)moduleForName:(const char *)moduleName lazilyLoadIfNecessary:(BOOL)lazilyLoad
{
  id<RCTBridgeModule> module = nil;

  RCTBridge *bridge = _bridge;
  if (bridge) {
    module = [bridge moduleForName:[NSString stringWithUTF8String:moduleName] lazilyLoadIfNecessary:lazilyLoad];
  }

  id<RCTTurboModuleRegistry> turboModuleRegistry = _turboModuleRegistry;
  if (module == nil && turboModuleRegistry && (lazilyLoad || [turboModuleRegistry moduleIsInitialized:moduleName])) {
    module = [turboModuleRegistry moduleForName:moduleName];
  }

  return module;
}

- (NSArray *)modulesConformingToProtocol:(Protocol *)protocol
{
  NSMutableArray *modules = [NSMutableArray new];
  RCTBridge *bridge = _bridge;
  if (bridge) {
    [modules addObjectsFromArray:[bridge modulesConformingToProtocol:protocol]];
  }
    
  // TODO: find a way to get the same information of turboModules
  return [modules copy];
}

@end
