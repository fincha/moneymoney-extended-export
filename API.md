# MoneyMoney Export Plugins - API Reference

## Overview

The MoneyMoney Export Plugins provide comprehensive data extraction capabilities through the MoneyMoney Extension API. Each plugin implements the `Exporter` interface to export transaction and account data in different formats.

## Plugin Architecture

### Base Structure

All export plugins follow this structure:

```lua
Exporter{
    version = 1.00,
    format = "Format Name",
    fileExtension = "ext",
    description = "Export description"
}

function WriteHeader(account, startDate, endDate, transactionCount)
    -- Initialize export file
end

function WriteTransactions(account, transactions)
    -- Write transaction data
end

function WriteTail(account)
    -- Finalize export file
end
```

## Available Data Fields

### Account Object

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `name` | string | Account designation | "Checking Account" |
| `owner` | string | Account holder name | "John Doe" |
| `accountNumber` | string | Account number | "1234567890" |
| `subAccount` | string | Sub-account identifier | "01" |
| `bankCode` | string | Bank routing code | "12345678" |
| `currency` | string | ISO 4217 currency code | "EUR" |
| `iban` | string | International Bank Account Number | "DE89370400440532013000" |
| `bic` | string | Bank Identifier Code | "COBADEFFXXX" |
| `type` | string | Account type | "Giro", "Savings", "CreditCard" |
| `attributes` | table | Custom attributes | `{key = "value"}` |
| `comment` | string | Account notes | "Main account" |
| `balance` | number | Current balance | 1234.56 |
| `balanceDate` | timestamp | Unix timestamp of balance | 1704067200 |

### Transaction Object

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| **Basic Information** |
| `name` | string | Sender/recipient name | "ACME Corp" |
| `accountNumber` | string | Sender/recipient account | "9876543210" |
| `bankCode` | string | Sender/recipient bank code | "87654321" |
| `amount` | number | Transaction amount | -50.00 |
| `currency` | string | Transaction currency | "EUR" |
| `bookingDate` | timestamp | Unix timestamp when booked | 1704067200 |
| `valueDate` | timestamp | Unix timestamp for value date | 1704153600 |
| **Transaction Details** |
| `purpose` | string | Payment purpose/description | "Invoice #12345" |
| `bookingText` | string | Booking type text | "SEPA-Überweisung" |
| `transactionCode` | string | Transaction type code | "TRF" |
| `textKeyExtension` | string | Additional text key | "999" |
| `purposeCode` | string | Purpose classification code | "GDDS" |
| `bookingKey` | string | Booking classification | "051" |
| `primanotaNumber` | string | Primanota reference | "123456" |
| `batchReference` | string | Batch processing reference | "BATCH001" |
| **SEPA Fields** |
| `endToEndReference` | string | End-to-end reference | "NOTPROVIDED" |
| `mandateReference` | string | Direct debit mandate | "MANDATE123" |
| `creditorId` | string | Creditor identifier | "DE98ZZZ09999999999" |
| `returnReason` | string | Return/reversal reason | "AC01" |
| **Status Fields** |
| `booked` | boolean | Transaction booked status | true |
| `category` | string | User-defined category | "Groceries" |
| `checked` | boolean | User checked status | false |
| `comment` | string | User comment | "Monthly subscription" |

## Plugin-Specific APIs

### JSON Export (`moneymoney-json-export.lua`)

**Dependencies**: Requires `JSON.lua` library

**Output Structure**:
```json
{
  "exportDate": 1704067200,
  "dateRange": {
    "start": 1704067200,
    "end": 1706745600
  },
  "accounts": [/* account objects */],
  "transactions": {
    "Account Name": [/* transaction objects */]
  }
}
```

**Key Functions**:
- Uses `JSON:encode()` for serialization
- Preserves numeric precision for amounts
- Exports Unix timestamps for dates

### CSV Export (`moneymoney-csv-export.lua`)

**Output Format**: RFC 4180 compliant CSV

**Key Functions**:
```lua
escapeCSV(str) -- Escapes special characters
-- Returns: Properly escaped CSV field
```

**Features**:
- All fields in single row per transaction
- Account info repeated for each transaction
- ISO 8601 date formatting (YYYY-MM-DD)
- Proper escaping of commas, quotes, newlines

### XML Export (`moneymoney-xml-export.lua`)

**Output Structure**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<export>
  <metadata>
    <exportDate>2024-01-01T00:00:00Z</exportDate>
    <dateRange start="2024-01-01" end="2024-01-31"/>
  </metadata>
  <accounts>
    <account><!-- account fields --></account>
  </accounts>
  <transactions>
    <transaction accountName="...">
      <!-- transaction fields -->
    </transaction>
  </transactions>
</export>
```

**Key Functions**:
```lua
escapeXML(str) -- Escapes XML special characters
-- Returns: XML-safe string
```

### SQL Export (`moneymoney-sql-export.lua`)

**Output**: SQLite-compatible SQL script

**Generated Schema**:
```sql
CREATE TABLE accounts (
    id INTEGER PRIMARY KEY,
    name TEXT,
    owner TEXT,
    accountNumber TEXT,
    iban TEXT UNIQUE,
    bic TEXT,
    currency TEXT,
    type TEXT,
    balance REAL,
    balanceDate INTEGER
);

CREATE TABLE transactions (
    id INTEGER PRIMARY KEY,
    account_id INTEGER,
    bookingDate INTEGER,
    valueDate INTEGER,
    amount REAL,
    currency TEXT,
    name TEXT,
    purpose TEXT,
    -- ... additional fields
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Indexes for performance
CREATE INDEX idx_trans_account ON transactions(account_id);
CREATE INDEX idx_trans_date ON transactions(bookingDate);
CREATE INDEX idx_trans_category ON transactions(category);
```

**Key Functions**:
```lua
escapeSQLString(str) -- Escapes SQL special characters
-- Returns: SQL-safe string for INSERT statements
```

## MoneyMoney Extension API

### Exporter Registration

```lua
Exporter{
    version = number,        -- Plugin version
    format = string,         -- Display name in export dialog
    fileExtension = string,  -- Default file extension
    description = string     -- Description shown to user
}
```

### Callback Functions

#### WriteHeader(account, startDate, endDate, transactionCount)
Called once per account before transaction export.

**Parameters**:
- `account`: Account object with all fields
- `startDate`: Unix timestamp of period start
- `endDate`: Unix timestamp of period end  
- `transactionCount`: Number of transactions to export

#### WriteTransactions(account, transactions)
Called with transaction batch for export.

**Parameters**:
- `account`: Account object
- `transactions`: Array of transaction objects

#### WriteTail(account)
Called after all transactions exported.

**Parameters**:
- `account`: Account object

### I/O Operations

All plugins use Lua's standard I/O:
```lua
io.write(data)  -- Write to export file
assert(io.write(data))  -- Write with error checking
```

## Error Handling

Plugins should handle:
- Nil/missing fields gracefully
- Special character escaping
- Date formatting edge cases
- Large transaction volumes

## Date Handling

### Unix Timestamps
- All dates stored as Unix timestamps (seconds since 1970-01-01)
- Use `os.date()` for formatting
- Consider timezone implications

### Common Formats
```lua
-- ISO 8601 Date
os.date("%Y-%m-%d", timestamp)

-- ISO 8601 DateTime
os.date("%Y-%m-%dT%H:%M:%SZ", timestamp)

-- German Format
os.date("%d.%m.%Y", timestamp)
```

## Performance Considerations

- Plugins process transactions in batches
- Memory usage scales with transaction count
- String concatenation optimized using tables
- Consider file size for large exports

## Compatibility

- **MoneyMoney Version**: 2.4.0+
- **Lua Version**: 5.1 (embedded)
- **Platform**: macOS 10.12+
- **File Encoding**: UTF-8

## Extension Locations

### macOS
```
~/Library/Containers/com.moneymoney-app.retail/Data/Library/Application Support/MoneyMoney/Extensions/
```

### File Permissions
Extensions require read permission. No special privileges needed.

## Limitations

- Cannot modify MoneyMoney data (read-only)
- No network access from plugins
- Limited to data exposed by MoneyMoney API
- Single-threaded execution
- No external library loading (except JSON.lua)

## Best Practices

1. **Always check for nil values** before using fields
2. **Escape special characters** appropriately for format
3. **Handle large datasets** efficiently
4. **Preserve numeric precision** for monetary amounts
5. **Use consistent date formatting**
6. **Provide meaningful error messages**
7. **Test with various account types**
8. **Validate output format** compliance

## Debugging

Enable MoneyMoney's debug console:
1. Open MoneyMoney
2. Hold Option key while clicking Help menu
3. Select "Debug Console"
4. View plugin output and errors

## Version History

| Version | Changes |
|---------|---------|
| 1.00 | Initial release with full field support |

## Related Documentation

- [User Guide](USER_GUIDE.md) - End-user instructions
- [Developer Guide](DEVELOPER.md) - Plugin development
- [Examples](EXAMPLES.md) - Sample outputs and use cases