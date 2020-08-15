//
//  ReadWriteLock.swift
//  GDExtension
//
//  Created by Objc on 2019/8/22.
//

import UIKit

import Darwin
import Foundation

/** definition of the read/write lock - a common mechanism for thread safety */
protocol ReadWriteLock {
    
    func readLock(runBlock: () -> Void ) -> Void
    func writeLock(runBlock: @escaping () -> Void ) -> Void
    func readLock(runBlock: () throws -> Void ) throws -> Void
    func writeLock(runBlock: @escaping () throws -> Void ) throws -> Void
}

/** provides controlled access to read-write locks  */
struct ReadWriteLockFactory {
    
    enum ReadWriteLockType {
        case dispatchqueuerwlock
        case pthreadrwlock
        case semaphorelockrwlock
        case pretendingrwlock
        case bogusunsaferwlock
    }
    
    
    
    /** default read-write lock strategy */
    // in this source file I've experimented with a lot of alternatives;
    // picking this one as my standard lock type because Apple recommends
    // using GCD (and specifically DispatchQueue) as the strategy for
    // thread synchronization in swift, which as of swift 4 has no native
    // language provision for it, because the OS and Xcode provide better
    // tools for instrumentation and debugging than using other low-level
    // sync methods directly
    //   (source: 2016 WWDC / Concurrent Programming With GCD in Swift 3)
    private static let _defaultLockType = ReadWriteLockType.dispatchqueuerwlock
    
    /** general read-write lock accessor */
    func newLock(_ name: String = "marchebert.reporter.readwritelock",
                 type readWritelockType: ReadWriteLockType = _defaultLockType,
                 alternateLockType: ThreadLockType? = .pthreadmutexlock) -> ReadWriteLock {
        
        let fullName = "\(name).\(readWritelockType)"
        switch (readWritelockType) {
        case .dispatchqueuerwlock:
            return ReadWriteLockViaDispatchQueue(fullName)
        case .pthreadrwlock:
            return ReadWriteLockViaPThreadRWLock(fullName)
        case .pretendingrwlock:
            return PretendingReadWriteSingleMutexLock(actualLockType: alternateLockType!)
        case .semaphorelockrwlock:
            return ReadWriteLockViaSemaphore()
        case .bogusunsaferwlock:
            return AbsolutelyNotThreadSafeReadWriteLock()
        }
    }
    
    /** accessor for an optimally performant read-write lock implementation */
    // the OSUnfairLock alternative is faster than locking
    // via DispatchQueue when performance is a premium;
    // see ReadWriteLockTests for some metrics, see also
    //   https://gist.github.com/steipete/36350a8a60693d440954b95ea6cbbafc
    // ... and for a truly optimal alternative,
    // see the version in Matt Gallagher's CwlUtils for a truly
    // optimized locking strategy -
    // (https://www.cocoawithlove.com/blog/2016/06/02/threads-and-mutexes.html)
    // ... wherein he eliminates heap allocation during closure capture
    // and prohibits the compiler from generating redundant release/retains
    
    // we can't actually implement a read/write lock with os_unfair_locks (for that we
    // need a semaphore, not a mutex) - but the optimization gained with a using a simple
    // os_unfair_lock outweighs the concurrent read advantage of read/write locks...
    func newPerformantLock() -> ReadWriteLock {
        return PretendingReadWriteSingleMutexLock(actualLockType: .osunfairlock)
    }
}


// MARK: Read/Write Lock implementations
/** read-write lock built on GCD / DispatchQueue */
fileprivate class ReadWriteLockViaDispatchQueue: ReadWriteLock {
    
    private var synchronizeWrites = true
    private var _queue: DispatchQueue
    private var _group: DispatchGroup
    
    init(_ label: String) {
        _group = DispatchGroup()
        _queue = DispatchQueue(label: label, attributes: .concurrent)
    }
    
    func readLock(runBlock: ()->()) {
        
        _queue.sync {
            runBlock()
        }
    }
    
    func writeLock(runBlock: @escaping()->()) {
        _group.enter()
        _queue.async(flags: .barrier) { [unowned self] in
            runBlock()
            self._group.leave()
        }
        if (synchronizeWrites) {
            _group.wait()
        }
    }
    
    func readLock(runBlock: () throws -> Void ) throws -> Void {
        try _queue.sync {
            try runBlock()
        }
    }
    
    func writeLock(runBlock: @escaping () throws -> Void ) throws -> Void {
        
        _group.enter()
        var caughtError: Error?
        _queue.async(flags: .barrier) { [unowned self] in
            do {
                try runBlock()
                self._group.leave()
            } catch {
                if self.synchronizeWrites {
                    caughtError = error
                } else {
                    assertionFailure("non-catchable error thrown because it occurred asynchronously - \(error)")
                }
            }
        }
        if (synchronizeWrites) {
            _group.wait()
            if let error = caughtError {
                throw error
            }
        }
    }
}

/** read/write lock built on pthread_rwlock */
fileprivate class ReadWriteLockViaPThreadRWLock: ReadWriteLock {
    
    private var _lock: pthread_rwlock_t
    private var _label: String
    
    init(_ label: String) {
        _lock = pthread_rwlock_t()
        _label = label
        let retval = pthread_rwlock_init(&_lock, nil)
        precondition(retval == 0, "\(_label) error initializing pthread_rwlock_t - \(retval)")
    }
    
    func readLock(runBlock: () -> Void) {
        let retval = pthread_rwlock_rdlock(&_lock)
        precondition(retval == 0, "\(_label) error acquiring pthread_rwlock_t read lock - \(retval)")
        defer {
            let retval = pthread_rwlock_unlock(&_lock)
            precondition(retval == 0, "\(_label) error releasing pthread_rwlock_t read lock - \(retval)")
        }
        runBlock()
    }
    
    func writeLock(runBlock: @escaping () -> Void) {
        let retval = pthread_rwlock_wrlock(&_lock)
        precondition(retval == 0, "\(_label) error acquiring pthread_rwlock_t write lock - \(retval)")
        defer {
            let retval = pthread_rwlock_unlock(&_lock)
            precondition(retval == 0, "\(_label) error releasing pthread_rwlock_t write lock - \(retval)")
        }
        runBlock()
    }
    
    func readLock(runBlock: () throws -> Void) throws {
        let retval = pthread_rwlock_rdlock(&_lock)
        precondition(retval == 0, "\(_label) error acquiring pthread_rwlock_t read lock - \(retval)")
        defer {
            let retval = pthread_rwlock_unlock(&_lock)
            precondition(retval == 0, "\(_label) error releasing pthread_rwlock_t read lock - \(retval)")
        }
        try runBlock()
    }
    
    func writeLock(runBlock: @escaping () throws -> Void) throws {
        let retval = pthread_rwlock_wrlock(&_lock)
        precondition(retval == 0, "\(_label) error acquiring pthread_rwlock_t write lock - \(retval)")
        defer {
            let retval = pthread_rwlock_unlock(&_lock)
            precondition(retval == 0, "\(_label) error releasing pthread_rwlock_t write lock - \(retval)")
        }
        try runBlock()
    }
}


fileprivate class PretendingReadWriteSingleMutexLock: ReadWriteLock {
    
    private var _aLock: ThreadLock
    init(actualLockType: ThreadLockType) {
        _aLock = actualLockType.instance
    }
    
    func readLock(runBlock: () -> Void) {
        self._aLock.lock()
        defer {
            self._aLock.unlock()
        }
        runBlock()
    }
    
    func writeLock(runBlock: @escaping () -> Void) {
        self._aLock.lock()
        defer {
            self._aLock.unlock()
        }
        runBlock()
    }
    
    func readLock(runBlock: () throws -> Void) throws {
        self._aLock.lock()
        defer {
            self._aLock.unlock()
        }
        try runBlock()
    }
    
    func writeLock(runBlock: @escaping () throws -> Void) throws {
        self._aLock.lock()
        defer {
            self._aLock.unlock()
        }
        try runBlock()
    }
}

/** homegrown implementation for a read-write lock built on a semaphore */
fileprivate class ReadWriteLockViaSemaphore: ReadWriteLock {
    
    private var _readerCountLock = PThreadMutexThreadLock()
    private var _atLeastOneReaderOrWriterBusyLock = DispatchSemaphoreThreadLock()
    private var _activeReaderCount = 0
    
    init() {
    }
    
    func readLock(runBlock: () -> Void) {
        _performPreReadLocking()
        defer {
            _performPostReadLocking()
        }
        runBlock()
    }
    
    func writeLock(runBlock: @escaping () -> Void) {
        _atLeastOneReaderOrWriterBusyLock.lock()
        defer {
            _atLeastOneReaderOrWriterBusyLock.unlock()
        }
        runBlock()
    }
    
    func readLock(runBlock: () throws -> Void) throws {
        _performPreReadLocking()
        defer {
            _performPostReadLocking()
        }
        try runBlock()
    }
    
    func writeLock(runBlock: @escaping () throws -> Void) throws {
        _atLeastOneReaderOrWriterBusyLock.lock()
        defer {
            _atLeastOneReaderOrWriterBusyLock.unlock()
        }
        try runBlock()
    }
    
    private func _performPreReadLocking() {
        var shouldAcquireRWLock: Bool
        _readerCountLock.lock()
        _activeReaderCount += 1
        shouldAcquireRWLock = _activeReaderCount == 1
        _readerCountLock.unlock()
        if shouldAcquireRWLock {
            _atLeastOneReaderOrWriterBusyLock.lock()
        }
    }
    
    private func _performPostReadLocking() {
        var shouldReleaseLock: Bool
        _readerCountLock.lock()
        _activeReaderCount -= 1
        shouldReleaseLock = _activeReaderCount == 0
        _readerCountLock.unlock()
        if shouldReleaseLock {
            _atLeastOneReaderOrWriterBusyLock.unlock()
        }
    }
}


/** a lock that doesn't lock at all */
// exists only as a test for my unittests - any unit test claiming
// to test thread-safety had better fail using this implementation
fileprivate struct AbsolutelyNotThreadSafeReadWriteLock: ReadWriteLock {
    func readLock(runBlock: () -> Void) {
        runBlock()
    }
    
    func writeLock(runBlock: @escaping () -> Void) {
        runBlock()
    }
    
    func readLock(runBlock: () throws -> Void) throws {
        try runBlock()
    }
    
    func writeLock(runBlock: @escaping () throws -> Void) throws {
        try runBlock()
    }
}



// MARK: Simple lock types
/** generalization of a thread synchronization lock */
fileprivate protocol ThreadLock {
    
    init()
    mutating func lock()
    mutating func unlock()
}

enum ThreadLockType {
    
    case recursivepthreadmutexlock
    case nsrecursivelock
    case pthreadmutexlock
    // deprecated
    case osspinlock
    case osunfairlock
    case dispatchsemaphore
    case objcsynclock
    case nslock
    
    fileprivate var instance: ThreadLock {
        switch (self) {
        case .recursivepthreadmutexlock:
            return PThreadMutexRecursiveThreadLock()
        case .nsrecursivelock:
            return NSRecursiveLock()
        case .pthreadmutexlock:
            return PThreadMutexThreadLock()
        case .osspinlock:
            return OSSpinLockThreadLock()
        case .osunfairlock:
            if #available(iOS 10.0, *) {
                return OSUnfairLockThreadLock()
            } else {
                return PThreadMutexThreadLock()
            }
        case .dispatchsemaphore:
            return DispatchSemaphoreThreadLock()
        case .objcsynclock:
            return ObjcSyncThreadLock()
        case .nslock:
            return NSLock()
        }
    }
}



/** recursive sync lock based on pthread_mutex */
fileprivate struct PThreadMutexRecursiveThreadLock: ThreadLock {
    
    private var _aLock = pthread_mutex_t()
    
    init() {
        var mutexattr = pthread_mutexattr_t()
        pthread_mutexattr_init(&mutexattr)
        pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&_aLock, &mutexattr)
    }
    
    mutating func lock() {
        let retval = pthread_mutex_lock(&_aLock)
        assert(retval == 0, "pthread_mutex_lock / unexpected return value: \(retval)")
    }
    
    mutating func unlock() {
        let retval = pthread_mutex_unlock(&_aLock)
        assert(retval == 0, "pthread_mutex_unlock / unexpected return value: \(retval)")
    }
}

/** sync lock based on NSRecursiveLock */
extension NSRecursiveLock: ThreadLock {
    
}

/** sync lock based on a GCD semaphore */
// experimental purposes only, don't use this, it doesn't play nice
// with thread prioritization
fileprivate struct DispatchSemaphoreThreadLock: ThreadLock {
    private var _aLock = DispatchSemaphore(value: 1)
    
    init() {
    }
    
    func lock() {
        _aLock.wait()
    }
    
    func unlock() {
        _aLock.signal()
    }
}

/** sync lock based on pthread_mutex */
fileprivate struct PThreadMutexThreadLock: ThreadLock {
    
    private var _aLock = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&_aLock, nil)
    }
    
    mutating func lock() {
        pthread_mutex_lock(&_aLock)
    }
    
    mutating func unlock() {
        pthread_mutex_unlock(&_aLock)
    }
}

/** sync lock based on os_unfair_lock mutex */
@available(iOS 10.0, *)
fileprivate class OSUnfairLockThreadLock: ThreadLock {
    
    private var _aLock = os_unfair_lock_s()
    
    required init() {
    }
    
    func lock() {
        os_unfair_lock_lock(&_aLock)
    }
    
    func unlock() {
        os_unfair_lock_unlock(&_aLock)
    }
    
    deinit {
        // not sure how to properly decommission an os_unfair_lock_t
    }
}

@available(iOS, deprecated: 11.0)
/** sync lock based on os_spinlock */
// deprecated and also doesn't play nice with thread prioritization,
// here for experimental purposes only
fileprivate struct OSSpinLockThreadLock: ThreadLock {
    private var _aLock = OS_SPINLOCK_INIT
    
    init() {
    }
    
    mutating func lock() {
        OSSpinLockLock(&_aLock)
    }
    
    mutating func unlock() {
        OSSpinLockUnlock(&_aLock)
    }
}

/** sync lock based on objective-c's @synchronized() lock */
fileprivate struct ObjcSyncThreadLock: ThreadLock {
    
    private let _aLock = NSObject()
    
    init() {
    }
    
    func lock() {
        objc_sync_enter(_aLock)
    }
    
    func unlock() {
        objc_sync_exit(_aLock)
    }
}

/** sync lock based on NSLock (which I think just wraps pthread_mutex) */
extension NSLock: ThreadLock {
}
