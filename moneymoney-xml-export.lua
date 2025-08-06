-- MoneyMoney XML Export Extension
-- Exports all account and transaction data in structured XML format

Exporter{
    version = 1.00,
    format = "XML",
    fileExtension = "xml",
    description = "Export transactions and accounts as structured XML file"
}

local function escapeXML(str)
    if str == nil then
        return ""
    end
    str = tostring(str)
    str = string.gsub(str, "&", "&amp;")
    str = string.gsub(str, "<", "&lt;")
    str = string.gsub(str, ">", "&gt;")
    str = string.gsub(str, '"', "&quot;")
    str = string.gsub(str, "'", "&apos;")
    return str
end

local function formatDate(timestamp)
    if timestamp then
        return os.date("%Y-%m-%dT%H:%M:%S", timestamp)
    end
    return ""
end

local accountsData = {}
local currentAccount = nil

function WriteHeader(account, startDate, endDate, transactionCount)
    currentAccount = account
    
    -- Start XML document if this is the first account
    if #accountsData == 0 then
        assert(io.write('<?xml version="1.0" encoding="UTF-8"?>\n'))
        assert(io.write('<export>\n'))
        assert(io.write('  <metadata>\n'))
        assert(io.write('    <exportDate>' .. formatDate(os.time()) .. '</exportDate>\n'))
        assert(io.write('    <startDate>' .. formatDate(startDate) .. '</startDate>\n'))
        assert(io.write('    <endDate>' .. formatDate(endDate) .. '</endDate>\n'))
        assert(io.write('  </metadata>\n'))
        assert(io.write('  <accounts>\n'))
    end
    
    -- Write account information
    assert(io.write('    <account>\n'))
    assert(io.write('      <name>' .. escapeXML(account.name) .. '</name>\n'))
    assert(io.write('      <owner>' .. escapeXML(account.owner) .. '</owner>\n'))
    assert(io.write('      <accountNumber>' .. escapeXML(account.accountNumber) .. '</accountNumber>\n'))
    
    if account.subAccount then
        assert(io.write('      <subAccount>' .. escapeXML(account.subAccount) .. '</subAccount>\n'))
    end
    
    assert(io.write('      <bankCode>' .. escapeXML(account.bankCode) .. '</bankCode>\n'))
    assert(io.write('      <currency>' .. escapeXML(account.currency) .. '</currency>\n'))
    
    if account.iban then
        assert(io.write('      <iban>' .. escapeXML(account.iban) .. '</iban>\n'))
    end
    
    if account.bic then
        assert(io.write('      <bic>' .. escapeXML(account.bic) .. '</bic>\n'))
    end
    
    assert(io.write('      <type>' .. escapeXML(tostring(account.type)) .. '</type>\n'))
    
    if account.balance then
        assert(io.write('      <balance>' .. escapeXML(tostring(account.balance)) .. '</balance>\n'))
    end
    
    if account.balanceDate then
        assert(io.write('      <balanceDate>' .. formatDate(account.balanceDate) .. '</balanceDate>\n'))
    end
    
    if account.comment then
        assert(io.write('      <comment>' .. escapeXML(account.comment) .. '</comment>\n'))
    end
    
    -- Write custom attributes if present
    if account.attributes then
        assert(io.write('      <attributes>\n'))
        for key, value in pairs(account.attributes) do
            assert(io.write('        <attribute key="' .. escapeXML(key) .. '">' .. escapeXML(tostring(value)) .. '</attribute>\n'))
        end
        assert(io.write('      </attributes>\n'))
    end
    
    assert(io.write('      <transactions>\n'))
    
    table.insert(accountsData, account)
end

function WriteTransactions(account, transactions)
    for _, transaction in ipairs(transactions) do
        assert(io.write('        <transaction>\n'))
        
        -- Basic transaction information
        if transaction.name then
            assert(io.write('          <name>' .. escapeXML(transaction.name) .. '</name>\n'))
        end
        
        if transaction.accountNumber then
            assert(io.write('          <accountNumber>' .. escapeXML(transaction.accountNumber) .. '</accountNumber>\n'))
        end
        
        if transaction.bankCode then
            assert(io.write('          <bankCode>' .. escapeXML(transaction.bankCode) .. '</bankCode>\n'))
        end
        
        assert(io.write('          <amount>' .. escapeXML(tostring(transaction.amount)) .. '</amount>\n'))
        assert(io.write('          <currency>' .. escapeXML(transaction.currency) .. '</currency>\n'))
        
        if transaction.bookingDate then
            assert(io.write('          <bookingDate>' .. formatDate(transaction.bookingDate) .. '</bookingDate>\n'))
        end
        
        if transaction.valueDate then
            assert(io.write('          <valueDate>' .. formatDate(transaction.valueDate) .. '</valueDate>\n'))
        end
        
        if transaction.purpose then
            assert(io.write('          <purpose>' .. escapeXML(transaction.purpose) .. '</purpose>\n'))
        end
        
        -- Extended transaction details
        if transaction.transactionCode then
            assert(io.write('          <transactionCode>' .. escapeXML(tostring(transaction.transactionCode)) .. '</transactionCode>\n'))
        end
        
        if transaction.textKeyExtension then
            assert(io.write('          <textKeyExtension>' .. escapeXML(tostring(transaction.textKeyExtension)) .. '</textKeyExtension>\n'))
        end
        
        if transaction.purposeCode then
            assert(io.write('          <purposeCode>' .. escapeXML(transaction.purposeCode) .. '</purposeCode>\n'))
        end
        
        if transaction.bookingKey then
            assert(io.write('          <bookingKey>' .. escapeXML(transaction.bookingKey) .. '</bookingKey>\n'))
        end
        
        if transaction.bookingText then
            assert(io.write('          <bookingText>' .. escapeXML(transaction.bookingText) .. '</bookingText>\n'))
        end
        
        if transaction.primanotaNumber then
            assert(io.write('          <primanotaNumber>' .. escapeXML(transaction.primanotaNumber) .. '</primanotaNumber>\n'))
        end
        
        if transaction.batchReference then
            assert(io.write('          <batchReference>' .. escapeXML(transaction.batchReference) .. '</batchReference>\n'))
        end
        
        -- SEPA specific fields
        if transaction.endToEndReference then
            assert(io.write('          <endToEndReference>' .. escapeXML(transaction.endToEndReference) .. '</endToEndReference>\n'))
        end
        
        if transaction.mandateReference then
            assert(io.write('          <mandateReference>' .. escapeXML(transaction.mandateReference) .. '</mandateReference>\n'))
        end
        
        if transaction.creditorId then
            assert(io.write('          <creditorId>' .. escapeXML(transaction.creditorId) .. '</creditorId>\n'))
        end
        
        -- Status and categorization
        if transaction.returnReason then
            assert(io.write('          <returnReason>' .. escapeXML(transaction.returnReason) .. '</returnReason>\n'))
        end
        
        if transaction.booked ~= nil then
            assert(io.write('          <booked>' .. tostring(transaction.booked) .. '</booked>\n'))
        end
        
        if transaction.category then
            assert(io.write('          <category>' .. escapeXML(transaction.category) .. '</category>\n'))
        end
        
        if transaction.checked ~= nil then
            assert(io.write('          <checked>' .. tostring(transaction.checked) .. '</checked>\n'))
        end
        
        if transaction.comment then
            assert(io.write('          <comment>' .. escapeXML(transaction.comment) .. '</comment>\n'))
        end
        
        -- Custom attributes
        if transaction.attributes then
            assert(io.write('          <attributes>\n'))
            for key, value in pairs(transaction.attributes) do
                assert(io.write('            <attribute key="' .. escapeXML(key) .. '">' .. escapeXML(tostring(value)) .. '</attribute>\n'))
            end
            assert(io.write('          </attributes>\n'))
        end
        
        assert(io.write('        </transaction>\n'))
    end
end

function WriteTail(account)
    if account then
        -- Close current account
        assert(io.write('      </transactions>\n'))
        assert(io.write('    </account>\n'))
    else
        -- Close XML document
        assert(io.write('  </accounts>\n'))
        assert(io.write('</export>\n'))
    end
end