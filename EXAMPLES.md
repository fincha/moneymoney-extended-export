# MoneyMoney Export Plugins - Examples and Use Cases

## Table of Contents
1. [Sample Outputs](#sample-outputs)
2. [Real-World Use Cases](#real-world-use-cases)
3. [Data Analysis Examples](#data-analysis-examples)
4. [Integration Examples](#integration-examples)
5. [Automation Scripts](#automation-scripts)
6. [Troubleshooting Examples](#troubleshooting-examples)

## Sample Outputs

### JSON Export Sample

```json
{
  "exportDate": 1704067200,
  "dateRange": {
    "start": 1701388800,
    "end": 1704067199
  },
  "accounts": [
    {
      "name": "Hauptkonto",
      "owner": "Max Mustermann",
      "accountNumber": "1234567890",
      "subAccount": null,
      "bankCode": "37040044",
      "currency": "EUR",
      "iban": "DE89370400440532013000",
      "bic": "COBADEFFXXX",
      "type": "Giro",
      "attributes": {
        "branch": "Köln",
        "customerNumber": "123456"
      },
      "comment": "Gehaltskonto",
      "balance": 2543.67,
      "balanceDate": 1704067200
    }
  ],
  "transactions": {
    "Hauptkonto": [
      {
        "name": "REWE MARKT GMBH",
        "accountNumber": "9876543210",
        "bankCode": "30050110",
        "amount": -67.43,
        "currency": "EUR",
        "bookingDate": 1703980800,
        "valueDate": 1703980800,
        "purpose": "KARTENZAHLUNG REWE MARKT KÖLN",
        "bookingText": "SEPA-ELV-LASTSCHRIFT",
        "transactionCode": "MSC",
        "textKeyExtension": null,
        "purposeCode": "GDDS",
        "bookingKey": "083",
        "primanotaNumber": "789456",
        "batchReference": null,
        "endToEndReference": "2023123145678",
        "mandateReference": "MAND123456",
        "creditorId": "DE98ZZZ09999999999",
        "customerReference": null,
        "originalAmount": null,
        "returnReason": null,
        "iban": "DE12300501100098765432",
        "bic": "DUSSDEDDXXX",
        "category": "Lebensmittel",
        "booked": true,
        "checked": false,
        "comment": "Wocheneinkauf"
      },
      {
        "name": "Arbeitgeber GmbH",
        "accountNumber": "5555666677",
        "bankCode": "50010517",
        "amount": 3456.78,
        "currency": "EUR",
        "bookingDate": 1701475200,
        "valueDate": 1701475200,
        "purpose": "GEHALT DEZEMBER 2023",
        "bookingText": "SEPA-ÜBERWEISUNG",
        "transactionCode": "TRF",
        "textKeyExtension": null,
        "purposeCode": "SALA",
        "bookingKey": "051",
        "primanotaNumber": "123789",
        "batchReference": "BATCH202312",
        "endToEndReference": "SALARY-2023-12",
        "mandateReference": null,
        "creditorId": null,
        "customerReference": "MA123456",
        "originalAmount": null,
        "returnReason": null,
        "iban": "DE50501051700555566667",
        "bic": "INGDDEFFXXX",
        "category": "Gehalt",
        "booked": true,
        "checked": true,
        "comment": null
      }
    ]
  }
}
```

### CSV Export Sample

```csv
Account Name,Account Owner,Account Number,Account IBAN,Account BIC,Account Currency,Account Type,Account Balance,Transaction Date,Value Date,Name,Recipient Account,Recipient Bank Code,Amount,Currency,Purpose,Booking Text,Transaction Code,Text Key Extension,Purpose Code,Booking Key,Primanota Number,Batch Reference,End-to-End Reference,Mandate Reference,Creditor ID,Return Reason,Category,Checked,Booked,Comment
Hauptkonto,Max Mustermann,1234567890,DE89370400440532013000,COBADEFFXXX,EUR,Giro,2543.67,2023-12-30,2023-12-30,REWE MARKT GMBH,9876543210,30050110,-67.43,EUR,"KARTENZAHLUNG REWE MARKT KÖLN",SEPA-ELV-LASTSCHRIFT,MSC,,GDDS,083,789456,,2023123145678,MAND123456,DE98ZZZ09999999999,,Lebensmittel,false,true,Wocheneinkauf
Hauptkonto,Max Mustermann,1234567890,DE89370400440532013000,COBADEFFXXX,EUR,Giro,2543.67,2023-12-01,2023-12-01,Arbeitgeber GmbH,5555666677,50010517,3456.78,EUR,"GEHALT DEZEMBER 2023",SEPA-ÜBERWEISUNG,TRF,,SALA,051,123789,BATCH202312,SALARY-2023-12,,,"",Gehalt,true,true,""
```

### XML Export Sample

```xml
<?xml version="1.0" encoding="UTF-8"?>
<export>
  <metadata>
    <exportDate>2024-01-01T12:00:00Z</exportDate>
    <dateRange start="2023-12-01" end="2023-12-31"/>
  </metadata>
  <accounts>
    <account>
      <name>Hauptkonto</name>
      <owner>Max Mustermann</owner>
      <accountNumber>1234567890</accountNumber>
      <iban>DE89370400440532013000</iban>
      <bic>COBADEFFXXX</bic>
      <currency>EUR</currency>
      <type>Giro</type>
      <balance>2543.67</balance>
      <balanceDate>2024-01-01T12:00:00Z</balanceDate>
      <comment>Gehaltskonto</comment>
    </account>
  </accounts>
  <transactions>
    <transaction accountName="Hauptkonto">
      <amount>-67.43</amount>
      <currency>EUR</currency>
      <bookingDate>2023-12-30</bookingDate>
      <valueDate>2023-12-30</valueDate>
      <name>REWE MARKT GMBH</name>
      <accountNumber>9876543210</accountNumber>
      <bankCode>30050110</bankCode>
      <iban>DE12300501100098765432</iban>
      <bic>DUSSDEDDXXX</bic>
      <purpose>KARTENZAHLUNG REWE MARKT KÖLN</purpose>
      <bookingText>SEPA-ELV-LASTSCHRIFT</bookingText>
      <transactionCode>MSC</transactionCode>
      <purposeCode>GDDS</purposeCode>
      <bookingKey>083</bookingKey>
      <endToEndReference>2023123145678</endToEndReference>
      <mandateReference>MAND123456</mandateReference>
      <creditorId>DE98ZZZ09999999999</creditorId>
      <category>Lebensmittel</category>
      <booked>true</booked>
      <checked>false</checked>
      <comment>Wocheneinkauf</comment>
    </transaction>
  </transactions>
</export>
```

### SQL Export Sample

```sql
-- MoneyMoney SQL Export
-- Generated: 2024-01-01 12:00:00

-- Create accounts table
CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    owner TEXT,
    accountNumber TEXT,
    iban TEXT UNIQUE,
    bic TEXT,
    currency TEXT,
    type TEXT,
    balance REAL,
    balanceDate INTEGER,
    comment TEXT
);

-- Create transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,
    bookingDate INTEGER,
    valueDate INTEGER,
    amount REAL NOT NULL,
    currency TEXT,
    name TEXT,
    accountNumber TEXT,
    bankCode TEXT,
    iban TEXT,
    bic TEXT,
    purpose TEXT,
    bookingText TEXT,
    transactionCode TEXT,
    textKeyExtension TEXT,
    purposeCode TEXT,
    bookingKey TEXT,
    primanotaNumber TEXT,
    batchReference TEXT,
    endToEndReference TEXT,
    mandateReference TEXT,
    creditorId TEXT,
    customerReference TEXT,
    returnReason TEXT,
    category TEXT,
    booked INTEGER,
    checked INTEGER,
    comment TEXT,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Insert account data
INSERT INTO accounts (name, owner, accountNumber, iban, bic, currency, type, balance, balanceDate, comment)
VALUES ('Hauptkonto', 'Max Mustermann', '1234567890', 'DE89370400440532013000', 'COBADEFFXXX', 'EUR', 'Giro', 2543.67, 1704067200, 'Gehaltskonto');

-- Insert transaction data
INSERT INTO transactions (account_id, bookingDate, valueDate, amount, currency, name, accountNumber, bankCode, iban, bic, purpose, bookingText, transactionCode, purposeCode, bookingKey, endToEndReference, mandateReference, creditorId, category, booked, checked, comment)
VALUES (1, 1703980800, 1703980800, -67.43, 'EUR', 'REWE MARKT GMBH', '9876543210', '30050110', 'DE12300501100098765432', 'DUSSDEDDXXX', 'KARTENZAHLUNG REWE MARKT KÖLN', 'SEPA-ELV-LASTSCHRIFT', 'MSC', 'GDDS', '083', '2023123145678', 'MAND123456', 'DE98ZZZ09999999999', 'Lebensmittel', 1, 0, 'Wocheneinkauf');

-- Create indexes for performance
CREATE INDEX idx_trans_account ON transactions(account_id);
CREATE INDEX idx_trans_date ON transactions(bookingDate);
CREATE INDEX idx_trans_category ON transactions(category);
CREATE INDEX idx_trans_amount ON transactions(amount);
```

## Real-World Use Cases

### Personal Finance Dashboard

**Scenario**: Building a personal finance dashboard with charts and insights

**Workflow**:
1. Export as JSON monthly
2. Process with Python/pandas
3. Generate visualizations
4. Create web dashboard

**Implementation**:
```python
import json
import pandas as pd
import plotly.express as px
from datetime import datetime

# Load MoneyMoney export
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
df['month'] = df['date'].dt.to_period('M')

# Monthly spending by category
monthly_spending = df[df['amount'] < 0].groupby(['month', 'category'])['amount'].sum().abs()

# Create visualization
fig = px.bar(
    monthly_spending.reset_index(),
    x='month',
    y='amount',
    color='category',
    title='Monthly Spending by Category'
)
fig.show()

# Calculate insights
avg_monthly_spending = df[df['amount'] < 0]['amount'].sum() / df['month'].nunique()
top_categories = df[df['amount'] < 0].groupby('category')['amount'].sum().nlargest(5)

print(f"Average Monthly Spending: €{abs(avg_monthly_spending):.2f}")
print("\nTop 5 Spending Categories:")
for cat, amount in top_categories.items():
    print(f"  {cat}: €{abs(amount):.2f}")
```

### Tax Preparation

**Scenario**: Preparing documentation for tax filing

**Workflow**:
1. Export full year as CSV
2. Filter tax-relevant transactions
3. Categorize by tax categories
4. Generate summary report

**Excel Formula Examples**:
```excel
# Sum business expenses
=SUMIF(O:O,"Business*",N:N)

# Count charitable donations
=COUNTIF(O:O,"Donation")

# Average monthly income
=AVERAGEIFS(N:N,N:N,">0",O:O,"Salary")

# Q4 medical expenses
=SUMIFS(N:N,I:I,">=2023-10-01",I:I,"<=2023-12-31",O:O,"Medical")
```

### Business Expense Tracking

**Scenario**: Track and report business expenses for reimbursement

**SQL Queries After Import**:
```sql
-- Monthly business expense summary
SELECT 
    strftime('%Y-%m', datetime(bookingDate, 'unixepoch')) as month,
    COUNT(*) as transaction_count,
    SUM(ABS(amount)) as total_expenses
FROM transactions
WHERE category LIKE 'Business%'
    AND amount < 0
GROUP BY month
ORDER BY month DESC;

-- Expenses by vendor
SELECT 
    name as vendor,
    COUNT(*) as transactions,
    SUM(ABS(amount)) as total_spent
FROM transactions
WHERE category LIKE 'Business%'
    AND amount < 0
GROUP BY name
ORDER BY total_spent DESC
LIMIT 20;

-- Expenses needing receipts (over €50)
SELECT 
    date(bookingDate, 'unixepoch') as date,
    name,
    purpose,
    ABS(amount) as amount
FROM transactions
WHERE category LIKE 'Business%'
    AND amount < -50
ORDER BY bookingDate DESC;
```

## Data Analysis Examples

### Spending Pattern Analysis

```python
import json
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Load and prepare data
with open('export.json', 'r') as f:
    data = json.load(f)

# Create DataFrame
all_transactions = []
for account, transactions in data['transactions'].items():
    for t in transactions:
        t['account'] = account
        all_transactions.append(t)

df = pd.DataFrame(all_transactions)
df['date'] = pd.to_datetime(df['bookingDate'], unit='s')
df['weekday'] = df['date'].dt.day_name()
df['hour'] = df['date'].dt.hour

# Analyze spending patterns
spending = df[df['amount'] < 0].copy()
spending['amount_abs'] = spending['amount'].abs()

# Daily spending pattern
daily_pattern = spending.groupby('weekday')['amount_abs'].agg(['mean', 'sum', 'count'])
daily_pattern = daily_pattern.reindex(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])

print("Daily Spending Patterns:")
print(daily_pattern)

# Find unusual transactions (outliers)
mean_amount = spending['amount_abs'].mean()
std_amount = spending['amount_abs'].std()
threshold = mean_amount + (2 * std_amount)

unusual = spending[spending['amount_abs'] > threshold][['date', 'name', 'amount', 'purpose']]
print(f"\nUnusual Transactions (>{threshold:.2f}):")
print(unusual)

# Recurring transaction detection
def find_recurring(df, tolerance_days=3):
    recurring = []
    
    for name in df['name'].unique():
        vendor_trans = df[df['name'] == name].sort_values('date')
        
        if len(vendor_trans) < 3:
            continue
            
        # Calculate intervals between transactions
        dates = vendor_trans['date'].values
        intervals = np.diff(dates) / np.timedelta64(1, 'D')
        
        # Check if intervals are regular (within tolerance)
        if np.std(intervals) < tolerance_days:
            avg_interval = np.mean(intervals)
            recurring.append({
                'vendor': name,
                'frequency_days': avg_interval,
                'transactions': len(vendor_trans),
                'avg_amount': vendor_trans['amount'].mean()
            })
    
    return pd.DataFrame(recurring)

recurring_transactions = find_recurring(spending)
print("\nRecurring Transactions:")
print(recurring_transactions)
```

### Cash Flow Forecasting

```python
import json
import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
from datetime import datetime, timedelta

# Load data
with open('export.json', 'r') as f:
    data = json.load(f)

# Prepare transaction data
transactions = []
for account, trans_list in data['transactions'].items():
    for t in trans_list:
        t['account'] = account
        transactions.append(t)

df = pd.DataFrame(transactions)
df['date'] = pd.to_datetime(df['bookingDate'], unit='s')

# Calculate daily balance
daily_balance = df.groupby('date')['amount'].sum().cumsum()
daily_balance = daily_balance.resample('D').last().fillna(method='ffill')

# Simple linear regression forecast
X = np.arange(len(daily_balance)).reshape(-1, 1)
y = daily_balance.values

model = LinearRegression()
model.fit(X, y)

# Forecast next 30 days
future_days = 30
future_X = np.arange(len(daily_balance), len(daily_balance) + future_days).reshape(-1, 1)
forecast = model.predict(future_X)

# Create forecast DataFrame
forecast_dates = pd.date_range(start=daily_balance.index[-1] + timedelta(days=1), periods=future_days)
forecast_df = pd.DataFrame({
    'date': forecast_dates,
    'forecasted_balance': forecast
})

print("30-Day Balance Forecast:")
print(forecast_df.head(10))

# Identify cash flow risks
min_forecast = forecast.min()
if min_forecast < 500:
    days_until_low = np.argmax(forecast < 500) + 1
    print(f"\nWARNING: Balance may fall below €500 in {days_until_low} days")
```

### Category Budget Tracking

```python
import json
import pandas as pd
from datetime import datetime

# Define monthly budgets
BUDGETS = {
    'Lebensmittel': 400,
    'Transport': 150,
    'Unterhaltung': 100,
    'Kleidung': 100,
    'Sonstiges': 200
}

# Load data
with open('export.json', 'r') as f:
    data = json.load(f)

# Process transactions
transactions = []
for account, trans_list in data['transactions'].items():
    for t in trans_list:
        t['account'] = account
        transactions.append(t)

df = pd.DataFrame(transactions)
df['date'] = pd.to_datetime(df['bookingDate'], unit='s')
df['month'] = df['date'].dt.to_period('M')

# Current month analysis
current_month = df['month'].max()
current_spending = df[(df['month'] == current_month) & (df['amount'] < 0)]

# Calculate spending by category
category_spending = current_spending.groupby('category')['amount'].sum().abs()

# Budget analysis
print(f"Budget Analysis for {current_month}:")
print("-" * 50)

for category, budget in BUDGETS.items():
    spent = category_spending.get(category, 0)
    remaining = budget - spent
    percentage = (spent / budget) * 100 if budget > 0 else 0
    
    status = "✓" if remaining >= 0 else "⚠"
    print(f"{status} {category:20} Budget: €{budget:6.2f} | Spent: €{spent:6.2f} | Remaining: €{remaining:7.2f} ({percentage:5.1f}%)")

# Alert for overspending
overspent = [cat for cat, budget in BUDGETS.items() 
             if category_spending.get(cat, 0) > budget]

if overspent:
    print(f"\n⚠ OVERSPENT CATEGORIES: {', '.join(overspent)}")
```

## Integration Examples

### Google Sheets Integration

```javascript
// Google Apps Script for automated import
function importMoneyMoneyCSV() {
  // Get the CSV file from Google Drive
  var file = DriveApp.getFilesByName("moneymoney_export.csv").next();
  var csvData = file.getBlob().getDataAsString();
  
  // Parse CSV
  var csvLines = csvData.split("\n");
  var headers = csvLines[0].split(",");
  
  // Get or create sheet
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Transactions") ||
              SpreadsheetApp.getActiveSpreadsheet().insertSheet("Transactions");
  
  // Clear existing data
  sheet.clear();
  
  // Import data
  var data = [];
  for (var i = 0; i < csvLines.length; i++) {
    var row = csvLines[i].split(",");
    data.push(row);
  }
  
  sheet.getRange(1, 1, data.length, data[0].length).setValues(data);
  
  // Format as table
  var range = sheet.getDataRange();
  range.createFilter();
  
  // Format currency columns
  sheet.getRange("N:N").setNumberFormat("€#,##0.00");
  
  // Add conditional formatting for negative amounts
  var rule = SpreadsheetApp.newConditionalFormatRule()
    .whenNumberLessThan(0)
    .setFontColor("#FF0000")
    .setRanges([sheet.getRange("N:N")])
    .build();
  
  sheet.setConditionalFormatRules([rule]);
}
```

### Quicken/GnuCash Import

```python
#!/usr/bin/env python3
# Convert MoneyMoney JSON to QIF format

import json
import sys
from datetime import datetime

def json_to_qif(json_file, qif_file):
    # Load JSON
    with open(json_file, 'r') as f:
        data = json.load(f)
    
    with open(qif_file, 'w') as f:
        # QIF header
        f.write("!Type:Bank\n")
        
        # Process all transactions
        for account, transactions in data['transactions'].items():
            for trans in transactions:
                # Date
                date = datetime.fromtimestamp(trans['bookingDate'])
                f.write(f"D{date.strftime('%m/%d/%Y')}\n")
                
                # Amount
                f.write(f"T{trans['amount']:.2f}\n")
                
                # Payee
                if trans.get('name'):
                    f.write(f"P{trans['name']}\n")
                
                # Memo/Purpose
                if trans.get('purpose'):
                    f.write(f"M{trans['purpose']}\n")
                
                # Category
                if trans.get('category'):
                    f.write(f"L{trans['category']}\n")
                
                # End of transaction
                f.write("^\n")
    
    print(f"Converted {json_file} to {qif_file}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: json_to_qif.py input.json output.qif")
        sys.exit(1)
    
    json_to_qif(sys.argv[1], sys.argv[2])
```

### YNAB (You Need A Budget) Import

```ruby
#!/usr/bin/env ruby
# Convert MoneyMoney JSON to YNAB CSV format

require 'json'
require 'csv'
require 'date'

def convert_to_ynab(json_file, csv_file)
  # Load JSON
  data = JSON.parse(File.read(json_file))
  
  # Open CSV for writing
  CSV.open(csv_file, 'w') do |csv|
    # YNAB CSV header
    csv << ['Date', 'Payee', 'Category', 'Memo', 'Outflow', 'Inflow']
    
    # Process transactions
    data['transactions'].each do |account, transactions|
      transactions.each do |trans|
        date = Time.at(trans['bookingDate']).strftime('%m/%d/%Y')
        payee = trans['name'] || 'Unknown'
        category = trans['category'] || ''
        memo = trans['purpose'] || ''
        
        if trans['amount'] < 0
          outflow = (-trans['amount']).round(2)
          inflow = 0
        else
          outflow = 0
          inflow = trans['amount'].round(2)
        end
        
        csv << [date, payee, category, memo, outflow, inflow]
      end
    end
  end
  
  puts "Converted #{json_file} to YNAB format: #{csv_file}"
end

if ARGV.length != 2
  puts "Usage: to_ynab.rb input.json output.csv"
  exit 1
end

convert_to_ynab(ARGV[0], ARGV[1])
```

## Automation Scripts

### Daily Export Script

```bash
#!/bin/bash
# daily_export.sh - Automate daily exports (requires manual trigger in MoneyMoney)

EXPORT_DIR="$HOME/Documents/MoneyMoney/Exports"
TODAY=$(date +%Y-%m-%d)
ARCHIVE_DIR="$EXPORT_DIR/Archive/$TODAY"

# Create directories
mkdir -p "$ARCHIVE_DIR"

# Note: Actual export must be triggered manually in MoneyMoney
echo "Please export your transactions from MoneyMoney to: $EXPORT_DIR/current_export.json"
read -p "Press Enter when export is complete..."

# Process the export
if [ -f "$EXPORT_DIR/current_export.json" ]; then
    # Archive with timestamp
    cp "$EXPORT_DIR/current_export.json" "$ARCHIVE_DIR/export_${TODAY}.json"
    
    # Convert to other formats
    python3 <<EOF
import json
import csv
import xml.etree.ElementTree as ET

# Load JSON
with open('$EXPORT_DIR/current_export.json', 'r') as f:
    data = json.load(f)

# Generate CSV summary
with open('$ARCHIVE_DIR/summary_${TODAY}.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['Date', 'Account', 'Transactions', 'Income', 'Expenses'])
    
    for account, transactions in data['transactions'].items():
        income = sum(t['amount'] for t in transactions if t['amount'] > 0)
        expenses = sum(t['amount'] for t in transactions if t['amount'] < 0)
        writer.writerow(['$TODAY', account, len(transactions), income, abs(expenses)])

print("Daily export completed successfully!")
EOF
    
    # Clean up
    rm "$EXPORT_DIR/current_export.json"
    
    echo "Export archived to: $ARCHIVE_DIR"
else
    echo "Error: Export file not found!"
    exit 1
fi
```

### Monthly Report Generator

```python
#!/usr/bin/env python3
# monthly_report.py - Generate monthly financial report from exports

import json
import sys
from datetime import datetime
from pathlib import Path
import matplotlib.pyplot as plt
import pandas as pd

def generate_monthly_report(export_file, output_dir):
    # Load data
    with open(export_file, 'r') as f:
        data = json.load(f)
    
    # Process transactions
    all_trans = []
    for account, transactions in data['transactions'].items():
        for t in transactions:
            t['account'] = account
            all_trans.append(t)
    
    df = pd.DataFrame(all_trans)
    df['date'] = pd.to_datetime(df['bookingDate'], unit='s')
    df['month'] = df['date'].dt.to_period('M')
    
    # Current month
    current_month = df['month'].max()
    month_data = df[df['month'] == current_month]
    
    # Calculate metrics
    total_income = month_data[month_data['amount'] > 0]['amount'].sum()
    total_expenses = abs(month_data[month_data['amount'] < 0]['amount'].sum())
    net_savings = total_income - total_expenses
    
    # Category breakdown
    category_spending = month_data[month_data['amount'] < 0].groupby('category')['amount'].sum().abs()
    
    # Generate report
    report = f"""
    MONTHLY FINANCIAL REPORT
    ========================
    Month: {current_month}
    Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}
    
    SUMMARY
    -------
    Total Income:    €{total_income:,.2f}
    Total Expenses:  €{total_expenses:,.2f}
    Net Savings:     €{net_savings:,.2f}
    Savings Rate:    {(net_savings/total_income*100):.1f}%
    
    TOP SPENDING CATEGORIES
    -----------------------
    """
    
    for category, amount in category_spending.nlargest(10).items():
        report += f"    {category:30} €{amount:10,.2f}\n"
    
    # Save report
    output_path = Path(output_dir) / f"report_{current_month}.txt"
    with open(output_path, 'w') as f:
        f.write(report)
    
    # Generate charts
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))
    
    # Pie chart of expenses
    category_spending.nlargest(8).plot(kind='pie', ax=ax1, autopct='%1.1f%%')
    ax1.set_title(f'Expense Distribution - {current_month}')
    
    # Daily spending trend
    daily_spending = month_data[month_data['amount'] < 0].groupby(df['date'].dt.date)['amount'].sum().abs()
    daily_spending.plot(kind='bar', ax=ax2)
    ax2.set_title('Daily Spending Pattern')
    ax2.set_xlabel('Date')
    ax2.set_ylabel('Amount (€)')
    
    plt.tight_layout()
    chart_path = Path(output_dir) / f"charts_{current_month}.png"
    plt.savefig(chart_path)
    
    print(f"Report generated: {output_path}")
    print(f"Charts saved: {chart_path}")
    
    return report

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: monthly_report.py export.json output_directory")
        sys.exit(1)
    
    generate_monthly_report(sys.argv[1], sys.argv[2])
```

## Troubleshooting Examples

### Debugging Export Issues

```lua
-- Debug version of export plugin
-- Add this to your plugin to debug issues

local DEBUG = true
local debug_log = {}

local function debug(message)
    if DEBUG then
        table.insert(debug_log, os.date("%H:%M:%S") .. " - " .. message)
        print("[DEBUG]", message)
    end
end

function WriteHeader(account, startDate, endDate, transactionCount)
    debug("WriteHeader called")
    debug("Account: " .. (account.name or "nil"))
    debug("Transaction count: " .. transactionCount)
    
    -- Your normal code here
    
    debug("WriteHeader completed")
end

function WriteTail(account)
    -- Write debug log to file
    if DEBUG then
        io.write("\n\n<!-- DEBUG LOG -->\n")
        for _, message in ipairs(debug_log) do
            io.write("<!-- " .. message .. " -->\n")
        end
    end
end
```

### Common Issues and Solutions

#### Issue: Special Characters Corrupted

```python
# Fix encoding issues in exported files
import codecs

def fix_encoding(input_file, output_file):
    # Try different encodings
    encodings = ['utf-8', 'iso-8859-1', 'windows-1252']
    
    for encoding in encodings:
        try:
            with codecs.open(input_file, 'r', encoding=encoding) as f:
                content = f.read()
            
            # Save as UTF-8
            with codecs.open(output_file, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"Successfully converted from {encoding} to UTF-8")
            return True
        except UnicodeDecodeError:
            continue
    
    print("Could not determine encoding")
    return False

# Usage
fix_encoding('export_broken.csv', 'export_fixed.csv')
```

#### Issue: Large Export Performance

```lua
-- Optimized plugin for large exports
local buffer = {}
local BUFFER_SIZE = 100

function WriteTransactions(account, transactions)
    for i, transaction in ipairs(transactions) do
        -- Build transaction string
        local trans_str = formatTransaction(transaction)
        table.insert(buffer, trans_str)
        
        -- Flush buffer periodically
        if #buffer >= BUFFER_SIZE then
            io.write(table.concat(buffer))
            buffer = {}
            
            -- Allow system to process
            if i % 1000 == 0 then
                collectgarbage()
            end
        end
    end
    
    -- Flush remaining
    if #buffer > 0 then
        io.write(table.concat(buffer))
        buffer = {}
    end
end
```

#### Issue: Missing Transactions

```sql
-- Verify transaction completeness after SQL import
-- Check for gaps in transaction dates
WITH date_gaps AS (
    SELECT 
        date(bookingDate, 'unixepoch') as trans_date,
        date(LAG(bookingDate) OVER (ORDER BY bookingDate), 'unixepoch') as prev_date,
        julianday(date(bookingDate, 'unixepoch')) - 
        julianday(date(LAG(bookingDate) OVER (ORDER BY bookingDate), 'unixepoch')) as gap_days
    FROM transactions
    ORDER BY bookingDate
)
SELECT 
    prev_date,
    trans_date,
    gap_days
FROM date_gaps
WHERE gap_days > 7  -- Flag gaps larger than 7 days
ORDER BY gap_days DESC;

-- Check transaction counts by month
SELECT 
    strftime('%Y-%m', datetime(bookingDate, 'unixepoch')) as month,
    COUNT(*) as transaction_count,
    MIN(date(bookingDate, 'unixepoch')) as first_trans,
    MAX(date(bookingDate, 'unixepoch')) as last_trans
FROM transactions
GROUP BY month
ORDER BY month;
```

## Best Practices Summary

### Export Strategy
1. **Regular Exports**: Weekly or monthly for manageable file sizes
2. **Consistent Naming**: Use date-based naming convention
3. **Multiple Formats**: Keep JSON for processing, CSV for viewing
4. **Archival**: Maintain historical exports for comparison

### Data Processing
1. **Validate First**: Check for completeness before processing
2. **Handle Edge Cases**: Account for missing fields
3. **Preserve Precision**: Don't round monetary amounts prematurely
4. **Test with Samples**: Use small date ranges for testing

### Integration
1. **Automate Where Possible**: Script post-export processing
2. **Version Control**: Track your processing scripts
3. **Document Workflows**: Keep notes on your setup
4. **Backup Original**: Never modify original export files

### Security
1. **Encrypt Sensitive Files**: Use disk encryption or file encryption
2. **Limit Access**: Restrict file permissions appropriately
3. **Sanitize for Sharing**: Remove account numbers when sharing
4. **Secure Deletion**: Properly delete old export files