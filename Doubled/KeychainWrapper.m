//
//  KeychainWrapper.m
//  ChristmasKeeper
//
//  Created by Chris Lowe on 10/31/11.
//  Copyright (c) 2011 USAA. All rights reserved.
//

#import "KeychainWrapper.h"

// Used to specify the Application used in Keychain accessing
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

// Used to help secure the PIN
// Ideally, this is randomly generated, but to avoid unneccessary complexity and overhead of storing the Salt seperately we will standardize on this key.
// !!KEEP IT A SECRET!!
#define SALT_HASH @"FvTivqTqZXsgLLx1v3P8TGRyVHaSAKJSAJKHFKDGKAJadj7RLHV8GrfxaZ84oGA8RsKdNRpxdAojXYg9iAj"

@implementation KeychainWrapper
// *** NOTE *** This class is ARC compliant - any references to CF classes must be paired with a "__bridge" statement to 
// cast between Objective-C and Core Foundation Classes.  WWDC 2011 Video "Introduction to Automatic Reference Counting" explains this
// *** END NOTE ***
+ (NSMutableDictionary *)setupSearchDirectoryForIdentifier:(NSString *)identifier {
    
    NSLog(@"KEY:  Setting up search directory for identifier: %@", identifier);
    
    // Setup dictionary to access keychain
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];  
    // Specify we are using a Password (vs Certificate, Internet Password, etc)
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    // Uniquely identify this keychain accesser
    [searchDictionary setObject:APP_NAME forKey:(__bridge id)kSecAttrService];
	
    // Uniquely identify the account who will be accessing the keychain
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
	
    return searchDictionary; 
}

+ (NSData *)searchKeychainCopyMatchingIdentifier:(NSString *)identifier {
    NSLog(@"KEY:  Searching for keychain copy matching identifier: %@", identifier);
   
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:identifier];
    // Limit search results to one
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
	
    // Specify we want NSData/CFData returned
    [searchDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	
    // Search
    NSData *result = nil;   
    CFTypeRef foundDict = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &foundDict);
    
    if (status == noErr) {
        result = (__bridge_transfer NSData *)foundDict;
    } else {
        result = nil;
    }
    
    return result;
}

+ (NSString *)keychainStringFromMatchingIdentifier:(NSString *)identifier {
    NSLog(@"KEY:  Getting keychain string for identifier: %@", identifier);
    
   NSData *valueData = [self searchKeychainCopyMatchingIdentifier:identifier];
    if (valueData) {
        NSString *value = [[NSString alloc] initWithData:valueData
                                                   encoding:NSUTF8StringEncoding];
        return value;
    } else {
        return nil;
    }
}

+ (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    
    NSLog(@"KEY:  Creating keychain value for identifier: %@", identifier);
   
    NSMutableDictionary *dictionary = [self setupSearchDirectoryForIdentifier:identifier];
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:valueData forKey:(__bridge id)kSecValueData];
   
    // Protect the keychain entry so its only valid when the device is unlocked
    [dictionary setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];

    // Add
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
	
    // If the Addition was successful, return.  Otherwise, attempt to update existing key or quit (return NO)
    if (status == errSecSuccess) {
        return YES;
    } else if (status == errSecDuplicateItem){
        return [self updateKeychainValue:value forIdentifier:identifier];
    } else {
        return NO;
    }
}

+ (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    NSLog(@"KEY:  Updating keychain value for identifier: %@", identifier);
    
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:valueData forKey:(__bridge id)kSecValueData];
	
    // Update
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary,
                                    (__bridge CFDictionaryRef)updateDictionary);
	
    if (status == errSecSuccess) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)deleteItemFromKeychainWithIdentifier:(NSString *)identifier {
    NSLog(@"KEY:  Deleting item from keychain with identifier: %@", identifier);
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:identifier];
    CFDictionaryRef dictionary = (__bridge CFDictionaryRef)searchDictionary;
    
    //Delete
    SecItemDelete(dictionary);
}


// This is where most of the magic happens (the rest of it happens in computeSHA256DigestForString: method below)
// Here we are passing in the Hash of the PIN that the user entered so that we can avoid manually handling the PIN itself
// Then we are extracting the user name that the user supplied during setup so that we can add another unique element to the hash
// From there, we mash the user name, the passed in PIN Hash, and the secret key (From ChristmasConstants.h) together to create 
// one long, unique string.
// From here, we send that entire Hash mashup into the SHA256 method below to create a "Digital Digest" which is considered
// a one way encryption algorithm.  One way meaning that it can never be reverse-engineered, only brute-force attacked
// The algorthim we are using is 'Hash = SHA256(Name + Salt + (Hash(PIN)))'.  This is called "Digest Authentication"
+ (NSString *)securedSHA256DigestHashForPIN:(NSUInteger)pinHash {
    NSLog(@"KEY:  Secured SHA256 digest for hash pin");
    // 1
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:APP_NAME];
    name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 2
    NSString *computedHashString = [NSString stringWithFormat:@"%@%i%@", name, pinHash, SALT_HASH];
    // 3
    NSString *finalHash = [self computeSHA256DigestForString:computedHashString];
    NSLog(@"** Computed hash: %@ for SHA256 Digest: %@", computedHashString, finalHash);
    return finalHash;
}

// This is where the rest of the magic happens
// Here we are taking in our string hash, placing that inside of a C Char Array, then parsing it through the SHA256 encryption method
+ (NSString*)computeSHA256DigestForString:(NSString*)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    return [self computeSHA256DigestForData:data];
}

+(NSString*)computeSHA256DigestForData:(NSData*)data
{
    NSLog(@"KEY:  Computing SHA256 digest for data");
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    // This is an iOS5-specific method
    // Takes in the data, how much data, and then output format which in this case is an int array
    CC_SHA256(data.bytes, data.length, digest);
    
    // Setup our Objective-C output
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[])
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end