local crypto = require(".crypto.init")

function verifyEccAddress(address)
    if isEthereumAddress(address) then
        local mixedAddress = toChecksumAddress(address)
        return mixedAddress == address
    end
        return true
end

function isEthereumAddress(address)
    if type(address) == "string" and address:sub(1, 2) == "0x" and #address == 42 then
        local isValid = true
        for i = 3, #address do
            local char = address:sub(i, i)
            if not string.match(char, "%x") then
                isValid = false
                break
            end
        end
        return isValid
    else
        return false
    end
end

function toChecksumAddress(address)
    address = string.lower(string.gsub(address, "^0x", ""))
    local hash = crypto.digest.keccak256(address):asHex()
    local ret = "0x"

    for i = 1, #address do
        local hashChar = tonumber(string.sub(hash, i, i), 16)
        if hashChar >= 8 then
            ret = ret .. string.upper(string.sub(address, i, i))
        else
            ret = ret .. string.sub(address, i, i)
        end
    end

    return ret
end

return {
	verifyEccAddress = verifyEccAddress,
	isEthereumAddress = isEthereumAddress,
	toChecksumAddress = toChecksumAddress,
}
