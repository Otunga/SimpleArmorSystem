AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel(ArmorSyst.EntModel) -- Sets ent model
	self:SetMoveType(MOVETYPE_VPHYSICS) -- Sets the physic based movement of the ent
	self:SetSolid(SOLID_VPHYSICS) -- Sets up the collisions
	self:SetUseType( SIMPLE_USE ) -- Need I say more ?
	self:SetPos(self:GetPos() + Vector(0, 0, ArmorSyst.EntPos)) -- Changes depending on model, mess around with the last number in Vector until it works, fuck you it works ok :(
	self:EmitSound( "buttons/weapon_confirm.wav" )

	if ( SERVER ) then -- If we are running a server then
		self:PhysicsInit( SOLID_VPHYSICS ) -- Setup the physics for the ent
	end

	local phys = self:GetPhysicsObject() -- getting physics object

	if ( IsValid( phys ) ) then  -- if the physics object is valid then
		phys:Wake() -- wake that motherfucker up
	end

end

function ENT:Use( ply, caller ) -- called when a player presses E on the entity

	ply.LastJobModel = caller:GetModel()
	-- Sombody toucha mah spahget
	if IsValid(caller) and caller:IsPlayer() then

		local shouldCheck = {(caller:Armor() >= ArmorSyst.ArmorCap) , caller:Health() > (ArmorSyst.HealthCap - ArmorSyst.PlayerHealth)} // *dab* checked
		
		if shouldCheck[1] and shouldCheck[2] then
			caller:ChatPrint( "Your health & armor are at full capacity!" )
			return ""
		end
		
		if !shouldCheck[1] then
		
			caller:SetArmor( caller:Armor() + ArmorSyst.ArmorNumber )
			caller:SetModel(ArmorSyst.PlyModel)
			self:Remove()
			
		else
		
			caller:ChatPrint( "Your armor is at full capacity!" )
		
		end
	    
	    if !shouldCheck[2] then
		
			caller:SetHealth( caller:Health() + ArmorSyst.PlayerHealth )
			self:Remove()
			
		else
		
			caller:ChatPrint( "Your health is at full capacity!" )
		
		end
		
    end
end

hook.Add( "PlayerSay", "RemoveSuit", function( ply, text, public )

	if ( string.lower( text ) == "/dropsuit" ) then

		if (ply:Armor() >= ArmorSyst.ArmorNumber && ply:Health() > ArmorSyst.PlayerHealth) then
		
			ply:SetArmor(ply:Armor() - ArmorSyst.ArmorNumber)
			ply:SetHealth(ply:Health() - ArmorSyst.PlayerHealth)
			ply:SetModel(ply.LastJobModel or ply:GetModel())
			ply:ChatPrint( "You have removed your armor." )

			local enta = ents.Create( "gay_armour" )
			enta:SetPos(ply:GetPos() + Vector(0, 0, ArmorSyst.EntPos))
			enta:Spawn()
			enta:EmitSound( "buttons/weapon_confirm.wav" )
			
			return ""
		end
		
		ply:ChatPrint( "You have no armor to have off." )
		
		return ""
	end
end )

-- You be good now ya hear, I'll miss you.
