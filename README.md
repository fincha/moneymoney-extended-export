# MoneyMoney Export Plugins

Comprehensive export plugins for MoneyMoney that extract all available structured data from your accounts and transactions.

## Features

These plugins export the maximum amount of data available through the MoneyMoney API, including:

### Account Data
- Basic info: name, owner, account number, IBAN, BIC
- Bank details: bank code, currency
- Account type and sub-accounts
- Current balance and balance date
- Comments and custom attributes

### Transaction Data
- Core details: amount, currency, dates (booking/value)
- Parties: sender/recipient names and account details
- Purpose and descriptions
- Banking codes: transaction code, booking key, text key
- SEPA fields: end-to-end reference, mandate reference, creditor ID
- References: batch, primanota numbers
- Status: booked/pending, checked, categories
- Comments and custom attributes

## Available Export Formats

### 1. JSON Export (`moneymoney-json-export.lua`)
Exports data in structured JSON format, ideal for:
- API integrations
- Data processing pipelines
- Web applications
- NoSQL databases

### 2. CSV Export (`moneymoney-csv-export.lua`)
Comprehensive CSV with all fields, perfect for:
- Excel/spreadsheet analysis
- Data science workflows
- Business intelligence tools
- Quick data exploration

### 3. XML Export (`moneymoney-xml-export.lua`)
Well-structured XML format, suitable for:
- Enterprise systems integration
- XSLT transformations
- Legacy system compatibility
- Document-based workflows

### 4. SQL Export (`moneymoney-sql-export.lua`)
Complete SQL script with CREATE TABLE and INSERT statements, ready for:
- SQLite databases
- MySQL/PostgreSQL import (with minor adjustments)
- Data warehousing
- Relational database analysis

## Installation

1. Download the desired export plugin(s) from this repository
2. Place the `.lua` files in MoneyMoney's export extensions folder:
   - macOS: `~/Library/Containers/com.moneymoney-app.retail/Data/Library/Application Support/MoneyMoney/Extensions/`
3. If using the JSON export, ensure you have the `JSON.lua` library in the same directory
4. Restart MoneyMoney

## Usage

1. Open MoneyMoney
2. Select the account(s) you want to export
3. Go to **Account → Export Transactions**
4. Choose your desired format from the dropdown:
   - "JSON" for JSON export
   - "Extended CSV" for CSV export
   - "XML" for XML export
   - "SQL" for SQL export
5. Select date range and click Export
6. Choose destination and filename

## Output Examples

### JSON Format
```json
{
  "exportDate": 1234567890,
  "accounts": [{
    "name": "Checking Account",
    "iban": "DE89370400440532013000",
    "balance": 1234.56
  }],
  "transactions": {
    "Checking Account": [{
      "amount": -50.00,
      "purpose": "Grocery Store",
      "bookingDate": 1234567890
    }]
  }
}
```

### SQL Format
Creates two tables:
- `accounts` - All account information
- `transactions` - All transaction details with foreign key to accounts

Includes indexes for optimal query performance.

## Data Fields Reference

### Account Fields
| Field | Type | Description |
|-------|------|-------------|
| name | String | Account designation |
| owner | String | Account holder name |
| accountNumber | String | Account number |
| iban | String | International Bank Account Number |
| bic | String | Bank Identifier Code |
| currency | String | Account currency (EUR, USD, etc.) |
| type | String | Account type (Giro, Savings, etc.) |
| balance | Number | Current balance |
| balanceDate | Timestamp | Date of balance |

### Transaction Fields
| Field | Type | Description |
|-------|------|-------------|
| amount | Number | Transaction amount |
| currency | String | Transaction currency |
| bookingDate | Timestamp | When transaction was booked |
| valueDate | Timestamp | Effective date for interest |
| purpose | String | Payment description |
| name | String | Sender/recipient name |
| category | String | User-defined category |
| endToEndReference | String | SEPA end-to-end reference |
| ... | ... | Many more fields available |

## Notes

- All exports preserve the full precision of monetary amounts
- Dates are formatted according to ISO standards where applicable
- Special characters are properly escaped for each format
- Large exports may take a moment to process
- The SQL export uses SQLite-compatible syntax by default

## Troubleshooting

### JSON Export requires JSON.lua
The JSON export plugin requires the `JSON.lua` library. Download it from [GitHub](https://github.com/rxi/json.lua) and place it in the Extensions folder.

### Export appears empty
Ensure you have selected the correct date range and that transactions exist in that period.

### Plugin not appearing
1. Verify the `.lua` file is in the correct Extensions folder
2. Check file permissions
3. Restart MoneyMoney completely

## License

These export plugins are provided as-is for use with MoneyMoney. Feel free to modify them for your specific needs.

## Contributing

Suggestions and improvements are welcome! The plugins follow MoneyMoney's Extension API specification.