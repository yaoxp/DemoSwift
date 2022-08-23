import UIKit
import SQLite

//: 学习第三方库 [SQLite.swift](https://github.com/stephencelis/SQLite.swift)

class RecordTaskModel: Codable, Equatable {
    let timestamp: Int
    let domain: String
    let port: String?
    let log: String
    let type: Int
    var taskID: Int64? = nil
    
    init(type: Int, domain: String, log: String, port: String? = nil, timestamp: Int = 0) {
        self.type = type
        self.timestamp = timestamp
        self.domain = domain
        self.log = log
        self.port = port
    }
    
    static func == (lhs: RecordTaskModel, rhs: RecordTaskModel) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.type == rhs.type &&
        lhs.domain == rhs.domain && lhs.log == rhs.log &&
        lhs.port == rhs.port && lhs.taskID == rhs.taskID
    }
}

/// Create an in-memory database
let db = try Connection(.inMemory)

/// enable statement logging
db.trace { print($0) }

let timestamp = Expression<Int>.init("timestamp")
let domain = Expression<String>.init("domain")
let port = Expression<String?>.init("port")
let log = Expression<String>.init("log")
let id = Expression<Int64>.init("id")
let type = Expression<Int>.init("type")

let tableName: String = "test_table"
let table: Table

do {
    table = Table(tableName)
    try db.run(table.create(temporary: true, ifNotExists: true, withoutRowid: false) { t in
        t.column(id, primaryKey: .autoincrement)
        t.column(timestamp)
        t.column(domain)
        t.column(port)
        t.column(log)
        t.column(type)
    })
} catch {
    assertionFailure("Failed to create DB.")
}

func saveTask(_ task: RecordTaskModel) {
    let insert = table.insert(timestamp <- task.timestamp,
                              domain <- task.domain,
                              port <- task.port,
                              log <- task.log,
                              type <- task.type
    )
    task.taskID = try? db.run(insert)
    print("id: \(task.taskID ?? -1)")
}

func allTask() -> [RecordTaskModel] {
    do {
        var records = [RecordTaskModel]()
        for sq in try db.prepare(table.order(id)) {
            let record = RecordTaskModel(type: sq[type],
                                         domain: sq[domain],
                                         log: sq[log],
                                         port: sq[port],
                                         timestamp: sq[timestamp])
            record.taskID = sq[id]
            records.append(record)
        }
        return records
    } catch {
        return []
    }
}

/// 获取指定ID区间的记录 []
/// - Parameters:
///   - id: 开始id
///   - length: 长度
/// - Returns: 记录
func tasks(startID: Int64, offset: Int64) -> [RecordTaskModel] {
    do {
        let query = table.order(id)
            .where(id >= startID)
            .where(id <= startID + offset)
        var records = [RecordTaskModel]()
        for sq in try db.prepare(query) {
            let record = RecordTaskModel(type: sq[type],
                                         domain: sq[domain],
                                         log: sq[log],
                                         port: sq[port],
                                         timestamp: sq[timestamp])
            record.taskID = sq[id]
            records.append(record)
        }
        return records
    } catch {
        return []
    }
}

func deleteAllTask() {
    _ = try? db.run(table.delete())
}

func deleteTask(_ task: RecordTaskModel) {
    if let taskID = task.taskID {
        let alice = table.filter(id == taskID)
        _ = try? db.run(alice.delete())
    }
}

let record1 = RecordTaskModel(type: 1, domain: "www.baidu.com", log: "abcd", port: "123", timestamp: 12345)
let record2 = RecordTaskModel(type: 2, domain: "www.baidu.c2om", log: "ab2cd", port: "1223", timestamp: 123425)
let record3 = RecordTaskModel(type: 3, domain: "www.ba12idu.c2om", log: "a1b2cd", port: "19223", timestamp: 9123425)
let record4 = RecordTaskModel(type: 4, domain: "www.ba32idu.c2om", log: "a54b2cd", port: "91223", timestamp: 3123425)
let record5 = RecordTaskModel(type: 5, domain: "www.ba32idu.c2om", log: "a546b2cd", port: "91223", timestamp: 32123425)
let record6 = RecordTaskModel(type: 6, domain: "www.ba362idu.c2om", log: "a54b72cd", port: "91223", timestamp: 7123425)
let record7 = RecordTaskModel(type: 7, domain: "测试中文你好", log: "a54b72cd", port: "91223", timestamp: 7123425)
let record8 = RecordTaskModel(type: 8, domain: "大家测试搜索汉字", log: "a54b72cd", port: "91223", timestamp: 7123425)
let record9 = RecordTaskModel(type: 9, domain: "塔楼鞋架涪陵", log: "a54b72cd", port: "91223", timestamp: 7123425)
deleteAllTask()
saveTask(record1)
saveTask(record2)
saveTask(record3)
saveTask(record4)
saveTask(record5)
saveTask(record6)
saveTask(record7)
saveTask(record8)
saveTask(record9)
print("record2 id: \(record2.taskID ?? -1)")
print("record count: \(allTask().count)")
let allRecord = allTask()
tasks(startID: 2, offset: 3)

for sq in try db.prepare(table.filter(domain.like("%测试%"))) {
    print("type: \(sq[type])")
}
print("oK")

deleteAllTask()
print("record count: \(allTask().count)")



