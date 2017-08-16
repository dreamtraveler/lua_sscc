require "type"
require "libgame/g_struct"

local CL_Login = Message("CL_Login")

CL_Login.request = {
	[1]	= Int32("id"),
	[2]	= String("name"),
}
CL_Login.response = {
	[1]	= Int32("sid"),
	[2]	= String("sname"),
	[3] = G_ValueOpt("values"),
	[4] = G_BagItemOpt("bagItems"),
	[5] = Array(G_BagItemOpt("equips")),
}

return CL_Login
