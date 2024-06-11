if GetResourceState('aj-inventory') ~= 'started' then return end

AddItem = function(src, item, count, metadata)
	return exports['aj-inventory']:AddItem(src, item, count, slot, metadata)
end

RemoveItem = function(src, item, count, metadata)
	return exports['aj-inventory']:RemoveItem(src, item, count, slot, metadata)
end