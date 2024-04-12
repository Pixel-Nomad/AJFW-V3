-- local function execQuery(msg, fn, query, parameters)
--     local start = os.nanotime()
--     local result = fn(query, parameters)
--     local finish = os.nanotime()
 
--     print()
--     print(msg)
--     print('Executed ' .. (type(query) == 'string' and 1 or #query) .. ' queries in ' .. (finish - start) / 1e6 .. 'ms')
 
--     return result
-- end
 
-- CreateThread(function()
--     local initTable = {
--         'DROP TABLE `test_table`',
--         [[CREATE TABLE `test_table` (
--         `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
--         `username` VARCHAR(50) NOT NULL DEFAULT '0',
--         `identifier` VARCHAR(50) NOT NULL DEFAULT '0',
--         PRIMARY KEY (`id`)
--         )]],
--         'TRUNCATE `test_table`',
--         'ALTER TABLE `test_table` AUTO_INCREMENT = 1',
--     }
 
--     execQuery('initialise test_table', MySQL.transaction.await, initTable)
 
--     -- You might rename "values" as "parameters" for mysql-async compatibility.
--     local queries = {
--         { query = 'INSERT INTO `test_table` (identifier) VALUES (?)', values = { 'abcdef1' }},
--         { query = 'UPDATE `test_table` SET `username` = ? WHERE `id` = LAST_INSERT_ID()', values = { 'bob1' }},
--     }
 
--     execQuery('{ query: string, values: string }[] transaction', MySQL.transaction.await, queries)
 
--     -- You can pass an array of arrays.
--     queries = {
--         { 'INSERT INTO `test_table` (identifier) VALUES (?)', { 'abcdef2' } },
--         { 'UPDATE `test_table` SET `username` = ? WHERE `id` = LAST_INSERT_ID()', { 'bob2' } },
--     }
 
--     execQuery('[string, any[]][] transaction', MySQL.transaction.await, queries)
 
--     -- You can pass an array of queries.
--     queries = {
--         'INSERT INTO `test_table` (identifier) VALUES ("abcdef3")',
--         'UPDATE `test_table` SET `username` = "bob3" WHERE `id` = LAST_INSERT_ID()',
--     }
 
--     execQuery('string[] transaction', MySQL.transaction.await, queries)
 
--     local insertUsers = {}
 
--     for i = 1, 10000 do
--         insertUsers[i] = { 'INSERT INTO `test_table` (username, identifier) VALUES (?, ?)',
--             { 'Testuser_' .. i, 'abcdef' .. i } }
--     end
 
--     execQuery('insert ' .. #insertUsers .. ' test users', MySQL.transaction.await, insertUsers)
 
--     local selectUserIds = {}
 
--     for i = 1, 10000 do
--         if i % 4 == 0 then
--             selectUserIds[math.tointeger(i / 4)] = { 'abcdef' .. i }
--         end
--     end
 
--     execQuery('select every 4th userid', MySQL.prepare.await, 'SELECT `id` FROM `test_table` WHERE `identifier` = ? LIMIT 1', selectUserIds)
 
--     local insertid = execQuery('insert', MySQL.insert.await, 'INSERT INTO `test_table` (identifier) VALUES (?)', { 'abcdef' })
--     local update = execQuery('update', MySQL.update.await, 'UPDATE `test_table` SET `username` = ? WHERE `id` = ?', { 'bobby', insertid })
--     local scalar = execQuery('scalar', MySQL.scalar.await, 'SELECT `username` FROM `test_table` WHERE `id` = ?', { insertid })
--     local single = execQuery('single', MySQL.single.await, 'SELECT * FROM `test_table` WHERE `id` = ?', { insertid })
 
--     print(json.encode(execQuery('prepare', MySQL.prepare.await, 'SELECT `username` FROM `test_table` WHERE `id` = ?', { insertid })))
--     print(insertid, update, scalar, json.encode(single))
 
--     execQuery('query', MySQL.query.await, 'SELECT `username` FROM `test_table` WHERE `id` = ? LIMIT 1', { 419 })
-- end)