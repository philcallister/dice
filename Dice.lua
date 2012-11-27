Dice = {}
function Dice:parse(dice)
	local x = {}
	x.all = dice

	function x:out()
		print(">>>>>", x.all)
	end

	return x
end

function Dice:new(die)
	local x = {}
	x.die = die

	function x:out()
		print(">>>>> ", x.die)
	end

	return x
end
return Dice