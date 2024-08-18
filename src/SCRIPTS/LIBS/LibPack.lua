if LibPack then
    return true
else
    local function rU2(val, bc)
        local maxB = 2 ^ (8*bc-1)
        if val < 0 then
        return maxB*2 + val
        else
            return val
        end
    end
    local function U2(val, bc)
        local maxB = 2 ^ (8*bc-1)
        if val < maxB then
            return val
        else
            return val % maxB - maxB
        end
    end

    LibPack ={
        unpack = function(fmt, s, pos)
            pos=pos or 1
            local ty, len =string.match(fmt, "<([bBiIfc])([0-9]*)")
            if ty == "B" then
                return s[pos] or 0, pos+1
            elseif ty == "b" then 
                return U2(s[pos] or 0, 1), pos+1
            elseif ty == "i" then
                len = len or 4
                local v = 0
                for i = 0, len - 1 do
                    v = v + (s[pos + i] or 0) * 256^i
                end
                return U2(v, len), pos + len
            elseif ty == "I" then
                local v = 0
                len = len or 4
                for i = 0, len-1 do
                    v=v + (s[pos+i] or 0) * 256^i
                end
                return v ,pos+len
            elseif ty == "f" then
                    local sig = (s[pos+2] or 0) % 0x80 * 0x10000 + (s[pos+1] or 0) * 0x100 + (s[pos+0] or 0)
                    local exp = (s[pos+3] or 0) % 0x80 * 2 + math.floor((s[pos+2] or 0) / 0x80) - 0x7F
                    if exp == 0x7F then return 0 end
                    return math.ldexp(math.ldexp(sig, -23) + 1, exp) * ((s[pos+3] or 0) < 0x80 and 1 or -1), pos+4
                    --modified from
            elseif ty == "c" then
                len = len or 1
                return string.gsub(string.char(table.unpack({table.unpack(s, pos, pos+len-1)})),"\0",""), pos+len
            end
        end,
        pack = function(fmt,val,tab,pos)
            pos = pos or #tab+1
            tab = tab or {}
            local ty, len =string.match(fmt, "<([bBiIfc])([0-9]*)")
            if ty == "b" then
                tab[pos] = rU2(val or 0, 1)
                return pos + 1
            elseif ty == "B" then
                tab[pos] = val or 0 return pos + 1
            elseif ty == "i" then
                 len = len or 4
                 val = val or 0
                val = rU2(val, len)
                for i=0, len-1 do
                    tab[pos+i] = math.floor(val / 0x100^i) % 256
                end
                return pos + len
            elseif ty == "I" then
                 val = val or 0
                 len = len or 4
                for i=0,len-1 do
                    tab[pos+i] = math.floor(val/0x100^i)%256
                end
                return pos + len
            elseif ty == "f" then
                val= val or 0
                local m, e = math.frexp(math.abs(val))
                m = math.floor(m*0x1000000)
                e = val ~=0 and e + 126 or 0
                tab[pos] = m % 0x100
                tab[pos+1] = math.floor(m / 0x100) % 0x100
                local v = math.floor(m / 0x10000) % 0x80 + (e % 2) * 0x80
                tab[pos+2] = v
                v = math.floor(e / 2) + (val < 0 and 0x80 or 0)
                tab[pos+3] = v
                return pos + 4
            end
        end
    }
    return true
end
