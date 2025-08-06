-- MoneyMoney CSV Export Extension
-- Exports comprehensive transaction data in CSV format with all available fields

Exporter{
    version = 1.00,
    format = "Extended CSV",
    fileExtension = "csv",
    description = "Export transactions as comprehensive CSV file with all fields"
}

local function escapeCSV(str)
    if str == nil then
        return ""
    end
    str = tostring(str)
    if string.find(str, '[,"\r\n]') then
        str = '"' .. string.gsub(str, '"', '""') .. '"'
    end
    return str
end

function WriteHeader(account, startDate, endDate, transactionCount)
    -- Write CSV header with all available fields
    assert(io.write(
        "Account Name,Account Owner,Account Number,Account IBAN,Account BIC,Account Currency,Account Type,Account Balance," ..
        "Transaction Date,Value Date,Name,Recipient Account,Recipient Bank Code,Amount,Currency,Purpose," ..
        "Booking Text,Transaction Code,Text Key Extension,Purpose Code,Booking Key,Primanota Number," ..
        "Batch Reference,End-to-End Reference,Mandate Reference,Creditor ID,Return Reason," ..
        "Category,Checked,Booked,Comment\n"
    ))
end

function WriteTransactions(account, transactions)
    for _, transaction in ipairs(transactions) do
        -- Format dates
        local bookingDate = ""
        local valueDate = ""
        
        if transaction.bookingDate then
            bookingDate = os.date("%Y-%m-%d", transaction.bookingDate)
        end
        
        if transaction.valueDate then
            valueDate = os.date("%Y-%m-%d", transaction.valueDate)
        end
        
        -- Build CSV row with all fields
        local row = {
            -- Account information
            escapeCSV(account.name),
            escapeCSV(account.owner),
            escapeCSV(account.accountNumber),
            escapeCSV(account.iban),
            escapeCSV(account.bic),
            escapeCSV(account.currency),
            escapeCSV(account.type),
            escapeCSV(account.balance),
            
            -- Transaction dates
            escapeCSV(bookingDate),
            escapeCSV(valueDate),
            
            -- Basic transaction info
            escapeCSV(transaction.name),
            escapeCSV(transaction.accountNumber),
            escapeCSV(transaction.bankCode),
            escapeCSV(transaction.amount),
            escapeCSV(transaction.currency),
            escapeCSV(transaction.purpose),
            
            -- Extended transaction details
            escapeCSV(transaction.bookingText),
            escapeCSV(transaction.transactionCode),
            escapeCSV(transaction.textKeyExtension),
            escapeCSV(transaction.purposeCode),
            escapeCSV(transaction.bookingKey),
            escapeCSV(transaction.primanotaNumber),
            
            -- References
            escapeCSV(transaction.batchReference),
            escapeCSV(transaction.endToEndReference),
            escapeCSV(transaction.mandateReference),
            escapeCSV(transaction.creditorId),
            escapeCSV(transaction.returnReason),
            
            -- Categorization and status
            escapeCSV(transaction.category),
            escapeCSV(transaction.checked and "Yes" or "No"),
            escapeCSV(transaction.booked and "Yes" or "No"),
            escapeCSV(transaction.comment)
        }
        
        assert(io.write(table.concat(row, ",") .. "\n"))
    end
end

function WriteTail(account)
    -- CSV doesn't need a tail
end