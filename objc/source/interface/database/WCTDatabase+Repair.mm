/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <WCDB/Assertion.hpp>
#import <WCDB/Core.h>
#import <WCDB/WCTDatabase+Private.h>
#import <WCDB/WCTDatabase+Repair.h>

@implementation WCTDatabase (Repair)

- (void)setNotificationWhenCorrupted:(WCTRecoverNotificationBlock)onRecovering
{
    WCTDatabaseAssert(return;);
    WCDB::Database::RecoverNotification notification = nullptr;
    if (onRecovering != nil) {
        notification = [onRecovering](WCDB::Database *database) -> bool {
            return onRecovering([[WCTDatabase alloc] initWithUnsafeDatabase:database]);
        };
    }
    _database->setNotificationWhenCorrupted(notification);
}

- (void)filterBackup:(WCTBackupFilterBlock)tableShouldBeBackedUp
{
    WCTDatabaseAssert(return;);
    WCDB::Database::BackupFilter filter = nullptr;
    if (tableShouldBeBackedUp != nil) {
        filter = [tableShouldBeBackedUp](const WCDB::String &tableName) -> bool {
            return tableShouldBeBackedUp([NSString stringWithUTF8String:tableName.c_str()]);
        };
    }
    _database->filterBackup(filter);
}

- (BOOL)deposit
{
    WCTDatabaseAssert(return NO;);
    return _database->deposit();
}

- (void)setAutoBackup:(BOOL)flag
{
    WCTDatabaseAssert(return;);
    if (flag) {
        _database->setConfig(WCDB::BackupConfigName, WCDB::Core::shared()->backupConfig(), WCDB::Configs::Priority::Low);
    } else {
        _database->removeConfig(WCDB::BackupConfigName);
    }
}

- (BOOL)backup
{
    WCTDatabaseAssert(return NO;);
    return _database->backup();
}

- (double)retrieve:(WCDB_NO_ESCAPE WCTRetrieveProgressUpdateBlock)onProgressUpdate
{
    WCTDatabaseAssert(return 0;);
    WCDB::Database::RetrieveProgressCallback callback = nullptr;
    if (onProgressUpdate != nil) {
        callback = [onProgressUpdate](double percentage, double increment) {
            onProgressUpdate(percentage, increment);
        };
    }
    return _database->retrieve(callback);
}

- (BOOL)removeDeposited
{
    WCTDatabaseAssert(return NO;);
    return _database->removeDeposited();
}

- (BOOL)containsDeposited
{
    WCTDatabaseAssert(return NO;);
    return _database->containsDeposited();
}

@end
