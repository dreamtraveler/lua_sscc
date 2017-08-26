
function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))		
    else
      print(formatting .. v)
    end
  end
end

local function getIncr()
    local sum = 0
    return function()
        sum = sum + 1
        return sum
    end
end

local incr = getIncr()
local function makeItem(tabid)
    return {
        id = incr(),
        tabid = tabid,
        count = 1,
        name = "item:"
    }
end

local infot = {}
local instt = {}
local pileLimit = 3

local function probInfo(tabid)
    local list = infot[tabid]
    if not list then
        list = {}
        infot[tabid] = list
    end
    return list
end

local function plus(item, count)
    if count > pileLimit then
        item.count = pileLimit
        count = count - pileLimit
    else
        item.count = count
        count = 0
    end
    return count
end

local function getSlot()
    return 3
end

local function putItem(tabid, count)
    local list = probInfo(tabid)
    local n
    for k, v in pairs(list) do
        n = v.count + count
        count = plus(v, n)
    end

    if count == 0 then
        return
    end

    local slotNum = getSlot()
    local remainNum = count - slotNum * pileLimit
    if remainNum > 0 then
        count = count - remainNum
    end

    while count > 0 do
        local item = makeItem(tabid)
        list[item.id] = item
        instt[item.id] = item
        count = plus(item, count)
    end

    if remainNum > 0 then
        print("bag slot not enough, todo proc remain item, remain="..remainNum)
    end
end

local function getCount(list)
    local sum = 0
    for k, v in pairs(list) do
        sum = sum + v.count
    end
    return sum
end

local function getItemCount(tabid)
    local list = infot[tabid]
    if not list then
        return 0
    else
        return getCount(list)
    end
end

local function sub(list, count)
    for k, v in pairs(list) do
        v.count = v.count - count
        count = -v.count
        if v.count <= 0 then
            list[k] = nil
            instt[k] = nil
        end
        if count <= 0 then
            break
        end
    end
end

local function removeById(id, count)
    local item = instt[id]
    if not item then
        return
    end

    local list = infot[item.tabid]
    local sum = getCount(list)
    if sum < count then
        return
    end

    if count < item.count then
        item.count = item.count - count
        return
    else
        count = count - item.count
        list[id] = nil
        instt[id] = nil
    end

    if count > 0 then
        sub(list, count)
    end
end

local function removeByTabId(tabid, count)
    local list = infot[tabid]
    if not list then
        return
    end

    local sum = getCount(list)
    if sum < count then
        return
    end

    sub(list, count)
end

local function main()
    for i = 1001, 1001 do
        putItem(i, 1)
        putItem(i, 17)
    end

    tprint(infot)
    tprint(instt)

    removeByTabId(1001, 7)
    print("after remove 1001,5")

    tprint(infot)
    tprint(instt)
end
main()
