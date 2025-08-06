# MoneyMoney Export Plugins - Developer Documentation

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Development Environment](#development-environment)
3. [Creating Custom Plugins](#creating-custom-plugins)
4. [MoneyMoney API Deep Dive](#moneymoney-api-deep-dive)
5. [Data Processing](#data-processing)
6. [Testing and Debugging](#testing-and-debugging)
7. [Performance Optimization](#performance-optimization)
8. [Integration Patterns](#integration-patterns)
9. [Contributing](#contributing)

## Architecture Overview

### Plugin Lifecycle

```
MoneyMoney Application
    ↓
Load Extensions (startup)
    ↓
User Selects Export Format
    ↓
Initialize Exporter
    ↓
For Each Account:
    WriteHeader() → WriteTransactions() → WriteTail()
    ↓
Close File Handle
```

### Component Interaction

```lua
-- MoneyMoney Core
--   ├── Extension Loader
--   │     └── Reads .lua files from Extensions/
--   ├── Account Manager
--   │     └── Provides account objects
--   ├── Transaction Store  
--   │     └── Provides transaction arrays
--   └── Export Dialog
--         └── Calls plugin functions

-- Plugin (your code)
--   ├── Exporter{} registration
--   ├── WriteHeader() 
--   ├── WriteTransactions()
--   └── WriteTail()
```

## Development Environment

### Prerequisites

- **Text Editor**: Any editor with Lua syntax highlighting
  - Visual Studio Code (recommended)
  - Sublime Text
  - Atom
  - vim/emacs

- **Lua Knowledge**: Basic Lua 5.1 syntax
- **MoneyMoney**: Licensed version for testing

### Setting Up VSCode

1. **Install Lua Extension**
   ```
   ext install sumneko.lua
   ```

2. **Configure Workspace**
   ```json
   {
     "files.associations": {
       "*.lua": "lua"
     },
     "lua.runtime.version": "Lua 5.1"
   }
   ```

3. **Create Debug Configuration**
   ```json
   {
     "version": "0.2.0",
     "configurations": [{
       "type": "lua",
       "request": "launch",
       "name": "Debug Plugin",
       "program": "${file}"
     }]
   }
   ```

### Project Structure

```
moneymoney-export/
├── moneymoney-json-export.lua
├── moneymoney-csv-export.lua
├── moneymoney-xml-export.lua
├── moneymoney-sql-export.lua
├── JSON.lua                    # External dependency
├── test/
│   ├── mock-data.lua          # Test data
│   └── test-runner.lua        # Test harness
└── docs/
    └── *.md                   # Documentation
```

## Creating Custom Plugins

### Basic Plugin Template

```lua
-- MyFormat Export Plugin for MoneyMoney
-- Version: 1.00
-- Author: Your Name

-- Register the exporter
Exporter{
    version = 1.00,
    format = "MyFormat",
    fileExtension = "myf",
    description = "Export as MyFormat file"
}

-- Called once per account before transactions
function WriteHeader(account, startDate, endDate, transactionCount)
    -- Initialize your format
    -- account: account object with all fields
    -- startDate/endDate: Unix timestamps
    -- transactionCount: number of transactions to follow
    
    io.write("MYFORMAT VERSION 1.0\n")
    io.write("Account: " .. (account.name or "Unknown") .. "\n")
    io.write("Transactions: " .. transactionCount .. "\n")
end

-- Called with batches of transactions
function WriteTransactions(account, transactions)
    -- Process and write transactions
    -- transactions: array of transaction objects
    
    for _, transaction in ipairs(transactions) do
        -- Format and write each transaction
        local line = string.format("%s|%.2f|%s\n",
            os.date("%Y-%m-%d", transaction.bookingDate or 0),
            transaction.amount or 0,
            transaction.purpose or ""
        )
        io.write(line)
    end
end

-- Called after all transactions
function WriteTail(account)
    -- Finalize your format
    io.write("END OF FILE\n")
end
```

### Advanced Plugin Features

#### Custom Helper Functions

```lua
-- Utility function for format-specific escaping
local function escapeMyFormat(str)
    if not str then return "" end
    str = tostring(str)
    -- Your escaping logic
    str = string.gsub(str, "|", "\\|")
    str = string.gsub(str, "\n", "\\n")
    return str
end

-- Cache for performance
local cache = {}

function WriteHeader(account, startDate, endDate, transactionCount)
    -- Initialize cache
    cache.account = account
    cache.count = 0
    cache.total = 0
end
```

#### State Management

```lua
-- Module-level state
local state = {
    accounts = {},
    transactions = {},
    metadata = {}
}

function WriteHeader(account, startDate, endDate, transactionCount)
    -- Store account for later reference
    state.accounts[account.name] = {
        account = account,
        startDate = startDate,
        endDate = endDate,
        expectedCount = transactionCount,
        actualCount = 0
    }
end

function WriteTransactions(account, transactions)
    local accountState = state.accounts[account.name]
    accountState.actualCount = accountState.actualCount + #transactions
    -- Process transactions
end

function WriteTail(account)
    local accountState = state.accounts[account.name]
    -- Verify counts match
    if accountState.actualCount ~= accountState.expectedCount then
        -- Handle discrepancy
    end
end
```

## MoneyMoney API Deep Dive

### Account Object Deep Dive

```lua
-- Full account object structure
account = {
    -- Identifiers
    name = "Checking Account",        -- Display name
    accountNumber = "1234567890",     -- Account number
    iban = "DE89370400440532013000", -- IBAN if available
    
    -- Bank Information
    bankCode = "37040044",            -- Bank routing code
    bic = "COBADEFFXXX",             -- SWIFT/BIC code
    
    -- Account Details
    type = "Giro",                   -- Account type
    subAccount = "00",               -- Sub-account number
    owner = "John Doe",              -- Account holder
    currency = "EUR",                -- ISO 4217 code
    
    -- Balance Information
    balance = 1234.56,               -- Current balance
    balanceDate = 1704067200,        -- Unix timestamp
    
    -- Metadata
    comment = "Main account",        -- User notes
    attributes = {                   -- Custom attributes
        customField1 = "value1",
        customField2 = "value2"
    },
    
    -- Undocumented fields (may vary)
    portfolio = false,               -- Investment account flag
    hidden = false,                  -- Hidden account flag
    iconName = "bank_icon",          -- Icon identifier
    groupName = "Personal"           -- Account group
}
```

### Transaction Object Deep Dive

```lua
-- Complete transaction structure
transaction = {
    -- Core Fields (always present)
    amount = -50.00,                 -- Negative for debits
    currency = "EUR",                -- Transaction currency
    bookingDate = 1704067200,        -- Unix timestamp
    
    -- Common Fields (usually present)
    valueDate = 1704067200,          -- Value date timestamp
    purpose = "Payment for invoice", -- Transaction description
    name = "ACME Corporation",       -- Counterparty name
    accountNumber = "9876543210",    -- Counterparty account
    bankCode = "12345678",           -- Counterparty bank
    
    -- Banking Fields (when available)
    bookingText = "SEPA-Überweisung",    -- Booking type
    transactionCode = "TRF",              -- ISO 20022 code
    bookingKey = "051",                   -- German booking key
    textKeyExtension = "999",             -- Text key extension
    primanotaNumber = "123456",           -- Primanota reference
    batchReference = "BATCH001",          -- Batch ID
    
    -- SEPA Fields (for SEPA transactions)
    endToEndReference = "NOTPROVIDED",    -- End-to-end ID
    mandateReference = "MANDATE123",       -- Direct debit mandate
    creditorId = "DE98ZZZ09999999999",   -- Creditor identifier
    customerReference = "CUST123",        -- Customer reference
    
    -- Status Fields
    booked = true,                   -- Booked vs pending
    checked = false,                 -- User checked flag
    category = "Groceries",          -- User category
    comment = "Weekly shopping",     -- User comment
    
    -- Return/Reversal Fields
    returnReason = "AC01",           -- Return reason code
    originalAmount = 50.00,          -- Original amount
    
    -- Investment Fields (securities)
    shares = 10,                     -- Number of shares
    price = 5.00,                    -- Price per share
    fees = 0.50,                     -- Transaction fees
    isin = "US0378331005",          -- Security ISIN
    wkn = "865985",                 -- German security number
    
    -- Additional Metadata
    balance = 1184.56,              -- Balance after transaction
    iban = "DE89370400440532013000", -- Counterparty IBAN
    bic = "COBADEFFXXX",           -- Counterparty BIC
    purposeCode = "GDDS",           -- Purpose code
    
    -- Internal Fields (undocumented)
    id = "TXN123456",               -- Internal transaction ID
    accountId = "ACC123",           -- Internal account ID
    hash = "abc123...",             -- Transaction hash
}
```

### Handling Optional Fields

```lua
-- Safe field access pattern
local function safeGet(object, field, default)
    local value = object[field]
    if value == nil then
        return default
    end
    return value
end

-- Usage
local amount = safeGet(transaction, "amount", 0)
local purpose = safeGet(transaction, "purpose", "")

-- Alternative: Using 'or' operator
local name = transaction.name or "Unknown"
local date = transaction.bookingDate or 0

-- For nested fields
local customAttr = nil
if account.attributes then
    customAttr = account.attributes.customField
end
```

## Data Processing

### Date Handling

```lua
-- Convert Unix timestamp to various formats
local function formatDate(timestamp, format)
    if not timestamp or timestamp == 0 then
        return ""
    end
    
    format = format or "%Y-%m-%d"
    return os.date(format, timestamp)
end

-- Common date formats
local isoDate = formatDate(timestamp, "%Y-%m-%d")
local isoDateTime = formatDate(timestamp, "%Y-%m-%dT%H:%M:%SZ")
local germanDate = formatDate(timestamp, "%d.%m.%Y")
local usDate = formatDate(timestamp, "%m/%d/%Y")

-- Date range processing
local function isInRange(timestamp, startDate, endDate)
    return timestamp >= startDate and timestamp <= endDate
end

-- Month/Year extraction
local function getMonthYear(timestamp)
    local date = os.date("*t", timestamp)
    return date.year, date.month
end
```

### Amount Handling

```lua
-- Preserve precision for monetary amounts
local function formatAmount(amount)
    if not amount then return "0.00" end
    -- Ensure 2 decimal places
    return string.format("%.2f", amount)
end

-- Currency conversion placeholder
local function convertCurrency(amount, fromCurrency, toCurrency, rate)
    if fromCurrency == toCurrency then
        return amount
    end
    return amount * rate
end

-- Amount categorization
local function categorizeAmount(amount)
    if amount > 0 then
        return "income"
    elseif amount < 0 then
        return "expense"
    else
        return "neutral"
    end
end
```

### String Processing

```lua
-- Generic string escaping
local function escape(str, escapeMap)
    if not str then return "" end
    str = tostring(str)
    
    for char, replacement in pairs(escapeMap) do
        str = string.gsub(str, char, replacement)
    end
    
    return str
end

-- Format-specific escape maps
local csvEscapeMap = {
    ['"'] = '""',
    ['\n'] = ' ',
    ['\r'] = ' '
}

local xmlEscapeMap = {
    ['&'] = '&amp;',
    ['<'] = '&lt;',
    ['>'] = '&gt;',
    ['"'] = '&quot;',
    ["'"] = '&apos;'
}

local sqlEscapeMap = {
    ["'"] = "''"
}

-- Usage
local csvValue = escape(value, csvEscapeMap)
local xmlValue = escape(value, xmlEscapeMap)
local sqlValue = escape(value, sqlEscapeMap)
```

## Testing and Debugging

### Mock Environment

```lua
-- test/mock-moneymoney.lua
-- Mock MoneyMoney environment for testing

_G.Exporter = function(config)
    print("Registered exporter:", config.format)
    _G.exporterConfig = config
end

-- Mock I/O
local output = {}
_G.io = {
    write = function(str)
        table.insert(output, str)
        return true
    end
}

-- Get output for assertions
function getOutput()
    return table.concat(output)
end

function clearOutput()
    output = {}
end
```

### Test Data

```lua
-- test/mock-data.lua
local mockAccount = {
    name = "Test Account",
    iban = "DE89370400440532013000",
    bic = "COBADEFFXXX",
    currency = "EUR",
    balance = 1000.00,
    balanceDate = os.time()
}

local mockTransactions = {
    {
        amount = -50.00,
        currency = "EUR",
        bookingDate = os.time() - 86400,
        valueDate = os.time() - 86400,
        purpose = "Test Transaction 1",
        name = "Test Merchant",
        category = "Shopping"
    },
    {
        amount = 100.00,
        currency = "EUR",
        bookingDate = os.time() - 172800,
        valueDate = os.time() - 172800,
        purpose = "Test Income",
        name = "Test Employer",
        category = "Salary"
    }
}

return {
    account = mockAccount,
    transactions = mockTransactions
}
```

### Test Runner

```lua
-- test/test-runner.lua
-- Load mock environment
dofile("test/mock-moneymoney.lua")

-- Load plugin
dofile("moneymoney-myformat-export.lua")

-- Load test data
local testData = dofile("test/mock-data.lua")

-- Run tests
print("Testing WriteHeader...")
clearOutput()
WriteHeader(testData.account, os.time() - 2592000, os.time(), 2)
assert(getOutput():find("Test Account"), "Account name not found")

print("Testing WriteTransactions...")
clearOutput()
WriteTransactions(testData.account, testData.transactions)
assert(getOutput():find("-50.00"), "Transaction amount not found")

print("Testing WriteTail...")
clearOutput()
WriteTail(testData.account)

print("All tests passed!")
```

### Debug Console

Enable MoneyMoney's debug console:

```lua
-- Add debug output to your plugin
local DEBUG = true

local function debug(...)
    if DEBUG then
        print("[DEBUG]", ...)
    end
end

function WriteTransactions(account, transactions)
    debug("Processing", #transactions, "transactions")
    debug("Account:", account.name)
    
    for i, transaction in ipairs(transactions) do
        debug("Transaction", i, "amount:", transaction.amount)
        -- Process transaction
    end
end
```

## Performance Optimization

### Memory Management

```lua
-- Use string.format for efficiency
-- Bad: Multiple concatenations
local line = date .. "," .. amount .. "," .. purpose .. "\n"

-- Good: Single format operation
local line = string.format("%s,%s,%s\n", date, amount, purpose)

-- Better: Table concatenation for many strings
local parts = {}
table.insert(parts, date)
table.insert(parts, amount)
table.insert(parts, purpose)
local line = table.concat(parts, ",") .. "\n"
```

### Batch Processing

```lua
-- Process in chunks to manage memory
local BATCH_SIZE = 1000
local buffer = {}

function WriteTransactions(account, transactions)
    for i, transaction in ipairs(transactions) do
        -- Process transaction into string
        local line = formatTransaction(transaction)
        table.insert(buffer, line)
        
        -- Flush buffer when full
        if #buffer >= BATCH_SIZE then
            io.write(table.concat(buffer))
            buffer = {}
        end
    end
    
    -- Flush remaining
    if #buffer > 0 then
        io.write(table.concat(buffer))
        buffer = {}
    end
end
```

### Lazy Evaluation

```lua
-- Only compute expensive operations when needed
local function getComplexField(transaction)
    -- Cache result
    if transaction._computed then
        return transaction._computed
    end
    
    -- Expensive computation
    local result = expensiveOperation(transaction)
    transaction._computed = result
    return result
end
```

## Integration Patterns

### Pipeline Integration

```bash
#!/bin/bash
# export-pipeline.sh

# Export from MoneyMoney (manual step)
EXPORT_FILE="export.json"

# Process with jq
jq '.transactions | .[] | select(.amount < 0)' $EXPORT_FILE > expenses.json

# Import to database
python3 <<EOF
import json
import sqlite3

with open('expenses.json') as f:
    expenses = json.load(f)

conn = sqlite3.connect('finances.db')
# Process expenses...
EOF
```

### API Integration

```python
# Python integration example
import json
import requests
from datetime import datetime

class MoneyMoneyExport:
    def __init__(self, export_file):
        with open(export_file, 'r') as f:
            self.data = json.load(f)
    
    def get_transactions(self, account=None):
        if account:
            return self.data['transactions'].get(account, [])
        
        all_trans = []
        for trans_list in self.data['transactions'].values():
            all_trans.extend(trans_list)
        return all_trans
    
    def sync_to_api(self, api_endpoint, api_key):
        transactions = self.get_transactions()
        
        for trans in transactions:
            # Convert Unix timestamp
            trans['date'] = datetime.fromtimestamp(
                trans['bookingDate']
            ).isoformat()
            
            # Send to API
            response = requests.post(
                api_endpoint,
                json=trans,
                headers={'Authorization': f'Bearer {api_key}'}
            )
```

### Database Schema

```sql
-- Optimized schema for analytics
CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    iban TEXT UNIQUE,
    currency TEXT,
    type TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency TEXT,
    booking_date DATE,
    value_date DATE,
    purpose TEXT,
    counterparty_name TEXT,
    counterparty_account TEXT,
    category TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Indexes for common queries
CREATE INDEX idx_trans_date ON transactions(booking_date);
CREATE INDEX idx_trans_category ON transactions(category);
CREATE INDEX idx_trans_amount ON transactions(amount);
CREATE INDEX idx_trans_counterparty ON transactions(counterparty_name);

-- Views for analysis
CREATE VIEW monthly_summary AS
SELECT 
    strftime('%Y-%m', booking_date) as month,
    category,
    SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) as expenses,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) as income
FROM transactions
GROUP BY month, category;
```

## Contributing

### Code Style Guidelines

```lua
-- 1. Use meaningful variable names
local transactionAmount = -50.00  -- Good
local ta = -50.00                 -- Bad

-- 2. Comment complex logic
-- Calculate compound interest using daily compounding
local function calculateInterest(principal, rate, days)
    return principal * math.pow(1 + rate/365, days) - principal
end

-- 3. Handle errors gracefully
local function safeWrite(data)
    local success, err = pcall(function()
        io.write(data)
    end)
    
    if not success then
        -- Log error but continue
        print("Write error:", err)
    end
end

-- 4. Use consistent formatting
if condition then
    -- body
elseif otherCondition then
    -- body
else
    -- body
end
```

### Testing Checklist

- [ ] Test with empty account (no transactions)
- [ ] Test with single transaction
- [ ] Test with 1000+ transactions
- [ ] Test with special characters in text fields
- [ ] Test with missing optional fields
- [ ] Test with multiple accounts
- [ ] Test with different date ranges
- [ ] Test with various account types
- [ ] Test with different currencies
- [ ] Test with investment transactions

### Submission Guidelines

1. **Fork the repository**
2. **Create feature branch**
   ```bash
   git checkout -b feature/new-export-format
   ```

3. **Implement your plugin**
   - Follow existing patterns
   - Include all standard fields
   - Handle edge cases

4. **Add documentation**
   - Update README.md
   - Add format description
   - Include examples

5. **Test thoroughly**
   - Use test harness
   - Test with real data
   - Verify output validity

6. **Submit pull request**
   - Clear description
   - Example output
   - Testing notes

### Plugin Certification

For official inclusion:

1. **Completeness**: Export all available fields
2. **Correctness**: Accurate data representation
3. **Robustness**: Handle edge cases
4. **Performance**: Efficient for large datasets
5. **Documentation**: Clear usage instructions

## Advanced Topics

### Custom Attributes

```lua
-- Handling custom attributes
function processCustomAttributes(account)
    if not account.attributes then
        return {}
    end
    
    local custom = {}
    for key, value in pairs(account.attributes) do
        -- Process based on key pattern
        if string.match(key, "^custom_") then
            custom[key] = value
        end
    end
    
    return custom
end
```

### Multi-Currency Support

```lua
-- Track multiple currencies
local currencies = {}

function WriteTransactions(account, transactions)
    for _, trans in ipairs(transactions) do
        local currency = trans.currency or account.currency
        
        if not currencies[currency] then
            currencies[currency] = {
                count = 0,
                total = 0
            }
        end
        
        currencies[currency].count = currencies[currency].count + 1
        currencies[currency].total = currencies[currency].total + trans.amount
    end
end
```

### Security Considerations

```lua
-- Never log sensitive data
local function sanitizeForLog(transaction)
    local safe = {}
    safe.amount = transaction.amount
    safe.date = transaction.bookingDate
    safe.category = transaction.category
    -- Omit account numbers, IBANs, etc.
    return safe
end

-- Validate data before processing
local function validateTransaction(transaction)
    if type(transaction.amount) ~= "number" then
        return false, "Invalid amount"
    end
    
    if transaction.bookingDate and transaction.bookingDate < 0 then
        return false, "Invalid date"
    end
    
    return true
end
```

## Resources

### Official Documentation
- [MoneyMoney Extensions](https://moneymoney-app.com/extensions/)
- [Lua 5.1 Reference](https://www.lua.org/manual/5.1/)

### Tools
- [JSON.lua Library](https://github.com/rxi/json.lua)
- [Lua Pattern Reference](https://www.lua.org/pil/20.2.html)

### Community
- MoneyMoney Forums
- GitHub Discussions
- Stack Overflow: [moneymoney] tag

## License

Plugins are provided under MIT License for maximum flexibility in customization and distribution.