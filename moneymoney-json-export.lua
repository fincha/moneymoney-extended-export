-- MoneyMoney JSON Export Extension
-- Exports all available transaction and account data in JSON format

local JSON = (loadfile "JSON.lua")()

Exporter{
    version = 1.00,
    format = "JSON",
    fileExtension = "json",
    description = "Export transactions and accounts as comprehensive JSON file"
}

local accounts = {}
local transactions = {}

function WriteHeader(account, startDate, endDate, transactionCount)
    -- Store account information
    local accountData = {
        name = account.name,
        owner = account.owner,
        accountNumber = account.accountNumber,
        subAccount = account.subAccount,
        bankCode = account.bankCode,
        currency = account.currency,
        iban = account.iban,
        bic = account.bic,
        type = account.type,
        attributes = account.attributes,
        comment = account.comment,
        balance = account.balance,
        balanceDate = account.balanceDate
    }
    
    table.insert(accounts, accountData)
    
    -- Initialize transaction array for this account
    transactions[account.name] = {}
end

function WriteTransactions(account, transactions_list)
    for _, transaction in ipairs(transactions_list) do
        local transactionData = {
            -- Basic transaction information
            name = transaction.name,
            accountNumber = transaction.accountNumber,
            bankCode = transaction.bankCode,
            amount = transaction.amount,
            currency = transaction.currency,
            bookingDate = transaction.bookingDate,
            valueDate = transaction.valueDate,
            purpose = transaction.purpose,
            
            -- Extended transaction details
            transactionCode = transaction.transactionCode,
            textKeyExtension = transaction.textKeyExtension,
            purposeCode = transaction.purposeCode,
            bookingKey = transaction.bookingKey,
            bookingText = transaction.bookingText,
            primanotaNumber = transaction.primanotaNumber,
            batchReference = transaction.batchReference,
            
            -- SEPA specific fields
            endToEndReference = transaction.endToEndReference,
            mandateReference = transaction.mandateReference,
            creditorId = transaction.creditorId,
            
            -- Status and categorization
            returnReason = transaction.returnReason,
            booked = transaction.booked,
            category = transaction.category,
            checked = transaction.checked,
            
            -- Additional metadata
            attributes = transaction.attributes,
            comment = transaction.comment,
            
            -- Account reference
            accountName = account.name
        }
        
        table.insert(transactions[account.name], transactionData)
    end
end

function WriteTail(account)
    -- After all accounts are processed, output complete JSON
    if account == nil then
        local output = {
            exportDate = os.time(),
            accounts = accounts,
            transactions = transactions
        }
        
        assert(io.write(JSON:encode_pretty(output)))
    end
end