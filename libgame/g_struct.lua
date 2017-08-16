require "type"

local _M = {}

G_BagItemOpt = Struct("Item")
G_BagItemOpt.attributes = {
	[1] = Int32("itemId"),
	[2] = Int32("itemNum"),
}

G_ValueOpt = Struct("Item")
G_ValueOpt.attributes = {
	[1] = Int32("id"),
	[2] = Int32("value"),
}

table.insert(_M, G_BagItemOpt)
table.insert(_M, G_ValueOpt)
return _M