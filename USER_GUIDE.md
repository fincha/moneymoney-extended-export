# MoneyMoney Export Plugins - User Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Export Formats](#export-formats)
5. [Step-by-Step Guides](#step-by-step-guides)
6. [Advanced Usage](#advanced-usage)
7. [Troubleshooting](#troubleshooting)
8. [FAQ](#faq)

## Introduction

The MoneyMoney Export Plugins extend MoneyMoney's built-in export capabilities to provide comprehensive data extraction in multiple formats. Unlike the standard exports, these plugins capture ALL available data fields from your accounts and transactions.

### Why Use These Plugins?

- **Complete Data Export**: Access all 30+ transaction fields
- **Multiple Formats**: Choose from JSON, CSV, XML, or SQL
- **Preserve Data Integrity**: Full precision for amounts and dates
- **Automation Ready**: Structured formats for processing
- **No Data Loss**: Export everything MoneyMoney stores

## Installation

### Prerequisites
- MoneyMoney version 2.4.0 or later
- macOS 10.12 or later
- For JSON export: JSON.lua library file

### Step 1: Download Files

Download the following files from the repository:
- `moneymoney-json-export.lua` (for JSON export)
- `moneymoney-csv-export.lua` (for CSV export)
- `moneymoney-xml-export.lua` (for XML export)
- `moneymoney-sql-export.lua` (for SQL export)
- `JSON.lua` (required for JSON export only)

### Step 2: Locate Extensions Folder

1. Open Finder
2. Press `Cmd + Shift + G` to open "Go to Folder"
3. Paste this path:
```
~/Library/Containers/com.moneymoney-app.retail/Data/Library/Application Support/MoneyMoney/Extensions/
```
4. Press Enter

### Step 3: Install Plugins

1. Copy the downloaded `.lua` files to the Extensions folder
2. Ensure files have read permissions (they should by default)
3. For JSON export, both `moneymoney-json-export.lua` and `JSON.lua` must be in the folder

### Step 4: Restart MoneyMoney

Completely quit and restart MoneyMoney for the plugins to load.

### Verification

1. Open MoneyMoney
2. Select any account
3. Go to **Account → Export Transactions**
4. Check the format dropdown for new options:
   - "JSON" 
   - "Extended CSV"
   - "XML"
   - "SQL"

## Quick Start

### Export Your First File

1. **Select Account(s)**
   - Click on an account in the sidebar
   - Or Cmd+Click multiple accounts
   - Or select an account group

2. **Open Export Dialog**
   - Menu: Account → Export Transactions
   - Or right-click → Export Transactions

3. **Configure Export**
   - **Format**: Choose your desired format
   - **Date Range**: Select period to export
   - **Options**: Configure format-specific settings

4. **Save File**
   - Click "Export"
   - Choose destination folder
   - Name your file
   - Click "Save"

## Export Formats

### JSON Format

**Best for**: APIs, web applications, data processing

**File Extension**: `.json`

**Features**:
- Hierarchical structure
- Preserves data types
- Human-readable
- Easy to parse programmatically

**Sample Output**:
```json
{
  "exportDate": 1704067200,
  "accounts": [{
    "name": "Checking",
    "iban": "DE89370400440532013000",
    "balance": 1234.56
  }],
  "transactions": {
    "Checking": [{
      "amount": -50.00,
      "purpose": "Supermarket",
      "bookingDate": 1704067200
    }]
  }
}
```

### CSV Format

**Best for**: Excel, Google Sheets, data analysis

**File Extension**: `.csv`

**Features**:
- Universal spreadsheet compatibility
- All data in flat table structure
- One row per transaction
- Account info included in each row

**Opens with**:
- Microsoft Excel
- Google Sheets
- Numbers (macOS)
- LibreOffice Calc

### XML Format

**Best for**: Enterprise systems, data transformation

**File Extension**: `.xml`

**Features**:
- Industry-standard format
- Schema-friendly structure
- XSLT transformation ready
- Maintains hierarchical relationships

**Sample Output**:
```xml
<export>
  <accounts>
    <account>
      <name>Checking</name>
      <iban>DE89370400440532013000</iban>
    </account>
  </accounts>
  <transactions>
    <transaction accountName="Checking">
      <amount>-50.00</amount>
      <purpose>Supermarket</purpose>
    </transaction>
  </transactions>
</export>
```

### SQL Format

**Best for**: Database import, data warehousing

**File Extension**: `.sql`

**Features**:
- Complete database schema
- CREATE TABLE statements
- INSERT statements for all data
- Indexes for performance
- Foreign key relationships

**Compatible with**:
- SQLite (directly)
- MySQL (with minor adjustments)
- PostgreSQL (with minor adjustments)
- Any SQL database

## Step-by-Step Guides

### Excel Analysis Workflow

1. **Export as CSV**
   - Select "Extended CSV" format
   - Export your data

2. **Open in Excel**
   - Double-click the .csv file
   - Or File → Open in Excel

3. **Format as Table**
   - Select all data (Ctrl/Cmd + A)
   - Insert → Table
   - Check "My table has headers"

4. **Add Pivot Table**
   - Insert → PivotTable
   - Analyze spending by category
   - Group by month/year

### Database Import Workflow

1. **Export as SQL**
   - Select "SQL" format
   - Save as .sql file

2. **Import to SQLite**
   ```bash
   sqlite3 myfinances.db < export.sql
   ```

3. **Query Your Data**
   ```sql
   -- Monthly spending by category
   SELECT 
     strftime('%Y-%m', datetime(bookingDate, 'unixepoch')) as month,
     category,
     SUM(amount) as total
   FROM transactions
   WHERE amount < 0
   GROUP BY month, category
   ORDER BY month DESC;
   ```

### Python Data Analysis

1. **Export as JSON**
   ```python
   import json
   import pandas as pd
   
   # Load the export
   with open('export.json', 'r') as f:
       data = json.load(f)
   
   # Convert to DataFrame
   transactions = []
   for account, trans_list in data['transactions'].items():
       for t in trans_list:
           t['account'] = account
           transactions.append(t)
   
   df = pd.DataFrame(transactions)
   df['date'] = pd.to_datetime(df['bookingDate'], unit='s')
   ```

2. **Analyze**
   ```python
   # Monthly spending
   df['month'] = df['date'].dt.to_period('M')
   monthly = df[df['amount'] < 0].groupby('month')['amount'].sum()
   monthly.plot(kind='bar')
   ```

## Advanced Usage

### Exporting Multiple Accounts

1. **Select Multiple Accounts**
   - Hold Cmd (Mac) while clicking accounts
   - Or select an account group

2. **Export Options**
   - Each account exports to the same file
   - JSON/XML: Accounts are grouped
   - CSV/SQL: All transactions in one table

### Custom Date Ranges

1. **Preset Ranges**
   - Current Month
   - Last Month
   - Current Year
   - Last Year

2. **Custom Range**
   - Click calendar icons
   - Select start and end dates
   - Or type dates directly

### Large Exports

For exports with 10,000+ transactions:

1. **Consider splitting by year**
   - Export each year separately
   - Combine later if needed

2. **Monitor memory usage**
   - Close other applications
   - Allow extra time for processing

3. **Use appropriate format**
   - SQL most efficient for large datasets
   - JSON may use more memory
   - CSV good balance

## Troubleshooting

### Plugin Not Appearing

**Problem**: New export formats don't show in dropdown

**Solutions**:
1. Verify files are in correct folder
2. Check file permissions (should be readable)
3. Restart MoneyMoney completely (Cmd+Q)
4. Check for typos in filenames

### JSON Export Error

**Problem**: "JSON.lua not found" error

**Solution**:
1. Download JSON.lua from repository
2. Place in same Extensions folder
3. Ensure filename is exactly "JSON.lua"
4. Restart MoneyMoney

### Empty Export File

**Problem**: Export completes but file is empty

**Solutions**:
1. Check date range contains transactions
2. Verify account has transactions
3. Try different date range
4. Check account is not filtered

### Special Characters Issues

**Problem**: Umlauts or special characters appear wrong

**Solutions**:
1. Ensure text editor uses UTF-8 encoding
2. In Excel: Use Import wizard, select UTF-8
3. Try different application to open file

### Performance Issues

**Problem**: Export takes very long or freezes

**Solutions**:
1. Export smaller date ranges
2. Close other applications
3. Export one account at a time
4. Use CSV format (most efficient)

## FAQ

### General Questions

**Q: Will these plugins modify my MoneyMoney data?**
A: No, plugins are read-only and cannot modify your data.

**Q: Can I automate exports?**
A: MoneyMoney doesn't support scheduled exports, but you can script the import of exported files.

**Q: Are my banking credentials safe?**
A: Yes, plugins have no access to credentials or ability to perform transactions.

### Format Questions

**Q: Which format should I use?**
A: 
- **Excel/Sheets**: Use CSV
- **Programming**: Use JSON
- **Database**: Use SQL
- **Enterprise**: Use XML

**Q: Can I convert between formats?**
A: Yes, export in one format and use tools to convert. Many online converters available.

**Q: Why are amounts negative for expenses?**
A: MoneyMoney uses accounting convention: negative = money out, positive = money in.

### Data Questions

**Q: What date format is used?**
A: 
- JSON/SQL: Unix timestamps (seconds since 1970)
- CSV/XML: YYYY-MM-DD format
- All times are in local timezone

**Q: How precise are monetary amounts?**
A: Full precision is preserved (typically 2 decimal places for EUR/USD).

**Q: Can I export investment transactions?**
A: Yes, all transaction types are supported including securities transactions.

### Technical Questions

**Q: What MoneyMoney versions are supported?**
A: Version 2.4.0 and later.

**Q: Can I modify the plugins?**
A: Yes, the Lua source code can be edited with any text editor.

**Q: Where are exports stored by default?**
A: In your Documents folder, but you can choose any location.

**Q: Is there a file size limit?**
A: No plugin-imposed limit, but very large files (>100MB) may be slow to process.

## Tips and Best Practices

### Organization
- Create a dedicated folder for exports
- Use consistent naming: `YYYY-MM-DD_AccountName_Format.ext`
- Keep original exports as backups

### Privacy
- Be careful sharing export files (contain financial data)
- Remove sensitive data before sharing for support
- Use encrypted storage for export files

### Analysis
- Export full year for annual reports
- Use categories consistently for better analysis
- Regular exports create historical archive

### Integration
- JSON for web applications
- CSV for quick spreadsheet analysis
- SQL for complex queries
- XML for enterprise systems

## Getting Help

### Resources
- [API Documentation](API.md) - Technical details
- [Developer Guide](DEVELOPER.md) - Customization
- [Examples](EXAMPLES.md) - Sample outputs

### Support
- Check FAQ first
- Review troubleshooting section
- GitHub Issues for bug reports
- Community forums for general help

## Update Notifications

To stay informed about updates:
1. Watch the GitHub repository
2. Check for new versions periodically
3. Read changelog before updating

## Security Notes

- Plugins run in MoneyMoney's sandbox
- No network access
- No file system access outside export
- Cannot read other applications' data
- Cannot access banking credentials

## Conclusion

These export plugins provide powerful data extraction capabilities while maintaining security and ease of use. Whether you need data for analysis, archiving, or integration, choose the format that best fits your workflow.