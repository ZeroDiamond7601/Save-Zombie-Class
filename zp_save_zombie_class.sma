#include <amxmodx>
#include <amxmisc>
#include <fvault>
#include <zombieplague>

new const vault_name[] = "Saved_Class"

public plugin_init() 
	register_plugin("[ZP] Save Class System", "1.0", "Zero")	


public client_putinserver(id)
	load_class(id)

public client_disconnected(id)
	save_class(id)

public save_class(id) 
{
	if (!is_user_connected(id) || is_user_bot(id) || is_user_hltv(id)) 
		return
		
	new g_playername[101]
	get_user_name(id, g_playername[id], charsmax(g_playername))
	
	new classid = zp_get_user_zombie_class(id)
	
	if (classid == -1) 
	{
		server_print("[SAVE] No zombie class selected for player %s", g_playername[id])
		return
	}
	
	new szClassID[16]
	num_to_str(classid, szClassID, charsmax(szClassID))
	fvault_set_data(vault_name, g_playername[id], szClassID)
	
	server_print("[SAVE] Zombie Class ID %d saved for player %s", classid, g_playername[id])
}

public load_class(id) 
{	
	new g_playername[101]
	get_user_name(id, g_playername[id], charsmax(g_playername))
	
	new szClassID[16]
	if (!fvault_get_data(vault_name, g_playername[id], szClassID, charsmax(szClassID))) 
	{
		server_print("[LOAD] No saved zombie class for player %s", g_playername[id])
		return
	}
	
	new classid = str_to_num(szClassID);
	if (classid == -1) 
	{
		server_print("[LOAD] Invalid class ID retrieved for player %s", g_playername[id])
		return
	}
	
	if (zp_set_user_zombie_class(id, classid)) 
		server_print("[LOAD] Zombie Class ID %d loaded for player %s", classid, g_playername[id])
		
	else server_print("[LOAD] Failed to load zombie class ID %d for player %s", classid, g_playername[id])

}



