-- MoneyMoney SQL Export Extension
-- Exports account and transaction data as SQL INSERT statements

Exporter{
    version = 1.00,
    format = "SQL",
    fileExtension = "sql",
    description = "Export transactions and accounts as SQL INSERT statements"
}

local function escapeSQLString(str)
    if str == nil then
        return "NULL"
    end
    str = tostring(str)
    str = string.gsub(str, "'", "''")
    return "'" .. str .. "'"
end

local function escapeSQLNumber(num)
    if num == nil then
        return "NULL"
    end
    return tostring(num)
end

local function escapeSQLBoolean(bool)
    if bool == nil then
        return "NULL"
    end
    return bool and "1" or "0"
end

local function formatSQLDate(timestamp)
    if timestamp == nil then
        return "NULL"
    end
    return "'" .. os.date("%Y-%m-%d %H:%M:%S", timestamp) .. "'"
end

local accountCount = 0
local transactionCount = 0

function WriteHeader(account, startDate, endDate, transactionCount)
    -- Write SQL header and table creation statements only once
    if accountCount == 0 then
        assert(io.write("-- MoneyMoney Export SQL Script\n"))
        assert(io.write("-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n"))
        
        -- Create accounts table
        assert(io.write("-- Create accounts table\n"))
        assert(io.write("CREATE TABLE IF NOT EXISTS accounts (\n"))
        assert(io.write("    id INTEGER PRIMARY KEY AUTOINCREMENT,\n"))
        assert(io.write("    name TEXT NOT NULL,\n"))
        assert(io.write("    owner TEXT,\n"))
        assert(io.write("    account_number TEXT,\n"))
        assert(io.write("    sub_account TEXT,\n"))
        assert(io.write("    bank_code TEXT,\n"))
        assert(io.write("    currency TEXT,\n"))
        assert(io.write("    iban TEXT,\n"))
        assert(io.write("    bic TEXT,\n"))
        assert(io.write("    account_type TEXT,\n"))
        assert(io.write("    balance DECIMAL(15,2),\n"))
        assert(io.write("    balance_date DATETIME,\n"))
        assert(io.write("    comment TEXT,\n"))
        assert(io.write("    attributes TEXT,\n"))
        assert(io.write("    created_at DATETIME DEFAULT CURRENT_TIMESTAMP\n"))
        assert(io.write(");\n\n"))
        
        -- Create transactions table
        assert(io.write("-- Create transactions table\n"))
        assert(io.write("CREATE TABLE IF NOT EXISTS transactions (\n"))
        assert(io.write("    id INTEGER PRIMARY KEY AUTOINCREMENT,\n"))
        assert(io.write("    account_name TEXT,\n"))
        assert(io.write("    name TEXT,\n"))
        assert(io.write("    account_number TEXT,\n"))
        assert(io.write("    bank_code TEXT,\n"))
        assert(io.write("    amount DECIMAL(15,2) NOT NULL,\n"))
        assert(io.write("    currency TEXT,\n"))
        assert(io.write("    booking_date DATETIME,\n"))
        assert(io.write("    value_date DATETIME,\n"))
        assert(io.write("    purpose TEXT,\n"))
        assert(io.write("    transaction_code INTEGER,\n"))
        assert(io.write("    text_key_extension INTEGER,\n"))
        assert(io.write("    purpose_code TEXT,\n"))
        assert(io.write("    booking_key TEXT,\n"))
        assert(io.write("    booking_text TEXT,\n"))
        assert(io.write("    primanota_number TEXT,\n"))
        assert(io.write("    batch_reference TEXT,\n"))
        assert(io.write("    end_to_end_reference TEXT,\n"))
        assert(io.write("    mandate_reference TEXT,\n"))
        assert(io.write("    creditor_id TEXT,\n"))
        assert(io.write("    return_reason TEXT,\n"))
        assert(io.write("    booked BOOLEAN,\n"))
        assert(io.write("    category TEXT,\n"))
        assert(io.write("    checked BOOLEAN,\n"))
        assert(io.write("    comment TEXT,\n"))
        assert(io.write("    attributes TEXT,\n"))
        assert(io.write("    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,\n"))
        assert(io.write("    FOREIGN KEY (account_name) REFERENCES accounts(name)\n"))
        assert(io.write(");\n\n"))
        
        -- Create indexes
        assert(io.write("-- Create indexes for better query performance\n"))
        assert(io.write("CREATE INDEX IF NOT EXISTS idx_transactions_account ON transactions(account_name);\n"))
        assert(io.write("CREATE INDEX IF NOT EXISTS idx_transactions_booking_date ON transactions(booking_date);\n"))
        assert(io.write("CREATE INDEX IF NOT EXISTS idx_transactions_amount ON transactions(amount);\n"))
        assert(io.write("CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions(category);\n\n"))
        
        assert(io.write("-- Begin transaction\n"))
        assert(io.write("BEGIN TRANSACTION;\n\n"))
        assert(io.write("-- Insert account data\n"))
    end
    
    accountCount = accountCount + 1
    
    -- Convert attributes table to JSON string if present
    local attributesStr = "NULL"
    if account.attributes and next(account.attributes) then
        local attrs = {}
        for k, v in pairs(account.attributes) do
            table.insert(attrs, '"' .. k .. '":"' .. tostring(v) .. '"')
        end
        attributesStr = escapeSQLString("{" .. table.concat(attrs, ",") .. "}")
    end
    
    -- Insert account data
    assert(io.write("INSERT INTO accounts (name, owner, account_number, sub_account, bank_code, currency, iban, bic, account_type, balance, balance_date, comment, attributes) VALUES (\n"))
    assert(io.write("    " .. escapeSQLString(account.name) .. ",\n"))
    assert(io.write("    " .. escapeSQLString(account.owner) .. ",\n"))
    assert(io.write("    " .. escapeSQLString(account.accountNumber) .. ",\n"))
    assert(io.write("    " .. escapeSQLString(account.subAccount) .. ",\n"))
    assert(io.write("    " .. escapeSQLString(account.bankCode) .. ",\n"))
    assert(io.write("    " .. escapeSQLString(account.currency) .. ",\n"))
    assert(io.write("    " .. escapeSQLString(account.iban) .. ",\n"))
    assert(io.write("    " .. escapeSQLString(account.bic) .. ",\n"))
    assert(io.write("    " .. escapeSQLString(tostring(account.type)) .. ",\n"))
    assert(io.write("    " .. escapeSQLNumber(account.balance) .. ",\n"))
    assert(io.write("    " .. formatSQLDate(account.balanceDate) .. ",\n"))
    assert(io.write("    " .. escapeSQLString(account.comment) .. ",\n"))
    assert(io.write("    " .. attributesStr .. "\n"))
    assert(io.write(");\n\n"))
end

function WriteTransactions(account, transactions)
    if transactionCount == 0 then
        assert(io.write("-- Insert transaction data\n"))
    end
    
    for _, transaction in ipairs(transactions) do
        transactionCount = transactionCount + 1
        
        -- Convert attributes table to JSON string if present
        local attributesStr = "NULL"
        if transaction.attributes and next(transaction.attributes) then
            local attrs = {}
            for k, v in pairs(transaction.attributes) do
                table.insert(attrs, '"' .. k .. '":"' .. tostring(v) .. '"')
            end
            attributesStr = escapeSQLString("{" .. table.concat(attrs, ",") .. "}")
        end
        
        -- Insert transaction data
        assert(io.write("INSERT INTO transactions ("))
        assert(io.write("account_name, name, account_number, bank_code, amount, currency, "))
        assert(io.write("booking_date, value_date, purpose, transaction_code, text_key_extension, "))
        assert(io.write("purpose_code, booking_key, booking_text, primanota_number, batch_reference, "))
        assert(io.write("end_to_end_reference, mandate_reference, creditor_id, return_reason, "))
        assert(io.write("booked, category, checked, comment, attributes) VALUES (\n"))
        
        assert(io.write("    " .. escapeSQLString(account.name) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.name) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.accountNumber) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.bankCode) .. ",\n"))
        assert(io.write("    " .. escapeSQLNumber(transaction.amount) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.currency) .. ",\n"))
        assert(io.write("    " .. formatSQLDate(transaction.bookingDate) .. ",\n"))
        assert(io.write("    " .. formatSQLDate(transaction.valueDate) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.purpose) .. ",\n"))
        assert(io.write("    " .. escapeSQLNumber(transaction.transactionCode) .. ",\n"))
        assert(io.write("    " .. escapeSQLNumber(transaction.textKeyExtension) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.purposeCode) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.bookingKey) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.bookingText) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.primanotaNumber) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.batchReference) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.endToEndReference) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.mandateReference) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.creditorId) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.returnReason) .. ",\n"))
        assert(io.write("    " .. escapeSQLBoolean(transaction.booked) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.category) .. ",\n"))
        assert(io.write("    " .. escapeSQLBoolean(transaction.checked) .. ",\n"))
        assert(io.write("    " .. escapeSQLString(transaction.comment) .. ",\n"))
        assert(io.write("    " .. attributesStr .. "\n"))
        assert(io.write(");\n"))
    end
    
    if #transactions > 0 then
        assert(io.write("\n"))
    end
end

function WriteTail(account)
    -- Write commit statement when all accounts are processed
    if account == nil then
        assert(io.write("-- Commit transaction\n"))
        assert(io.write("COMMIT;\n\n"))
        
        assert(io.write("-- Summary\n"))
        assert(io.write("-- Accounts exported: " .. accountCount .. "\n"))
        assert(io.write("-- Transactions exported: " .. transactionCount .. "\n"))
    end
end